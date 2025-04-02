import 'dart:async';
import 'dart:math' hide log;

import 'package:collection/collection.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:rove_simulator/flame/encounter/coordinate_component.dart';
import 'package:rove_simulator/flame/encounter/tiles/ether_node_component.dart';
import 'package:rove_simulator/flame/encounter/tiles/field_component.dart';
import 'package:rove_simulator/flame/encounter/tiles/glyph_component.dart';
import 'package:rove_simulator/flame/encounter/tiles/trap_component.dart';
import 'package:rove_simulator/flame/encounter/units/object_component.dart';
import 'package:rove_simulator/flame/encounter/units/summon_component.dart';
import 'package:rove_simulator/flame/encounter/units/hexagon_unit_component.dart';
import 'package:rove_simulator/controller/base_controller.dart';
import 'package:rove_simulator/flame/encounter/units/unit_component.dart';
import 'package:rove_simulator/model/encounter_log.dart';
import 'package:rove_simulator/model/path_type.dart';
import 'package:rove_simulator/model/tiles/ether_node_model.dart';
import 'package:rove_simulator/model/tiles/field_model.dart';
import 'package:rove_simulator/model/tiles/glyph_model.dart';
import 'package:rove_simulator/model/tiles/object_model.dart';
import 'package:rove_simulator/model/tiles/player_unit_model.dart';
import 'package:rove_simulator/model/tiles/summon_model.dart';
import 'package:rove_simulator/model/tiles/tile_model.dart';
import 'package:rove_simulator/model/tiles/trap_model.dart';
import 'package:rove_simulator/model/tiles/unit_model.dart';
import 'package:hex_grid/hex_grid.dart';
import 'package:rove_data_types/rove_data_types.dart';

class MapController extends BaseController {
  bool animating = false;

  MapController({required super.game});

  restart() {
    animating = false;
    notifyListeners();
  }

  teleport(
      {required UnitModel actor,
      required HexCoordinate to,
      bool silent = false}) async {
    final component =
        game.findByKey<CoordinateComponent>(ComponentKey.named(actor.key))!;
    final from = component.coordinate;
    final distance = mapModel.distance(from, to);
    component.coordinate = to;
    mapModel.updateCoordinate(target: actor, coordinate: to);
    if (!silent) {
      log.addRecord(actor, 'Teleported $distance to ${to.toEvenQ()}');
    }
    // Teleport is not a move but for the purposes of taking damage it behaves functionally the same as entering the hex with a dash.
    animating = true;
    await _lootIfNeeded(actor, to);
    await _handleDamageWhileMoving(
        actor: actor,
        target: actor,
        component: component,
        from: from,
        to: to,
        pathType: PathType.dash,
        isLast: true);
    if (!actor.isSlain) {
      await _onOccupiedSpace(actor);
    }
    animating = false;
  }

  _onOccupiedSpace(TileModel actor) async {
    final wasAnimating = animating;
    animating = false;
    await eventController.onOccupiedSpace(actor: actor);
    animating = wasAnimating;
  }

  Future<void> swapSpaces(
      {required TileModel fromTile,
      required TileModel toTile,
      bool silent = false}) async {
    assert(fromTile is UnitModel || fromTile is GlyphModel);
    assert(toTile is UnitModel || toTile is GlyphModel);
    final fromComponent =
        game.findByKey<CoordinateComponent>(ComponentKey.named(fromTile.key))!;
    final from = fromComponent.coordinate;
    final toComponent =
        game.findByKey<CoordinateComponent>(ComponentKey.named(toTile.key))!;
    final to = toComponent.coordinate;
    fromComponent.coordinate = to;
    toComponent.coordinate = from;
    mapModel.updateCoordinate(target: fromTile, coordinate: to, swapping: true);
    mapModel.updateCoordinate(target: toTile, coordinate: from, swapping: true);
    // TODO: Handle damage?
    if (!silent) {
      log.addRecord(
          fromTile, 'Swapped spaces with ${EncounterLogEntry.targetKeyword}',
          target: toTile);
    }
    await _onOccupiedSpace(fromTile);
    await _onOccupiedSpace(toTile);
  }

  Future<void> push(
      {required TileModel actor,
      required UnitModel target,
      required int amount,
      required List<HexCoordinate> path}) async {
    log.addRecord(
        actor, 'Pushed ${EncounterLogEntry.targetKeyword} for $amount',
        target: target);
    await _pushOrPull(
        actor: actor, target: target, pushAmount: amount, path: path);
  }

  Future<void> pull(
      {required TileModel actor,
      required UnitModel target,
      required int amount,
      required List<HexCoordinate> path}) async {
    log.addRecord(
        actor, 'Pulled ${EncounterLogEntry.targetKeyword} for $amount',
        target: target);
    await _pushOrPull(
        actor: actor, target: target, pushAmount: amount, path: path);
  }

  _pushOrPull(
      {required TileModel actor,
      required UnitModel target,
      required int pushAmount,
      required List<HexCoordinate> path}) async {
    assert(path.isNotEmpty ||
        mapModel.isPushStopperAtCoordinate(target.coordinate, target: target));
    assert(!target.immuneToForcedMovement);
    assert(pushAmount >= path.length);
    final component =
        game.findByKey<CoordinateComponent>(ComponentKey.named(target.key))!;
    animating = true;
    var current = target.coordinate;
    var next = current;
    var lastCoordinate = current;
    bool moved = false;
    for (int i = 0; i < path.length; i++) {
      next = path[i];
      final isLast = i == path.length - 1;
      moved = await _pushOrPullUnitToCoordinate(
          actor, target, component, pushAmount - i, next, isLast);
      if (moved) {
        lastCoordinate = next;
      } else {
        assert(isLast);
      }
      if (target.isSlain) {
        break;
      }
      current = next;
    }
    if (!target.isSlain) {
      if (moved && pushAmount > path.length) {
        // Hitting the edge of the map; takes no damage
        log.addRecord(target, 'Stopped forced movement due to edge');
        assert(mapModel.isEdgeAtCoordinate(target.coordinate));
        await component.shake();
      }
      mapModel.updateCoordinate(target: target, coordinate: lastCoordinate);
      await _onOccupiedSpace(target);
    }
    animating = false;
  }

  Future<bool> _pushOrPullUnitToCoordinate(
      TileModel actor,
      UnitModel target,
      CoordinateComponent unitComponent,
      int pushAmount,
      HexCoordinate to,
      bool isLast) async {
    final t = mapModel.terrain[to]?.terrain;
    final isFlying = target.isFlying;
    if (!isFlying && t == TerrainType.openAir) {
      assert(isLast);
      final potentialDamage = 1 + pushAmount;
      if (target.isAdversary && target.health <= potentialDamage) {
        await unitComponent.setCoordinateAnimated(to);
        target.coordinate = to;
        await unitComponent.slayAnimated();
        log.addRecord(actor,
            'Slayed ${EncounterLogEntry.targetKeyword} by making them fall off a cliff',
            target: target);
        target.health = 0;
        return false;
      } else {
        log.addRecord(target, 'Stopped forced movement due to cliff');
        await unitComponent.shake();
        return false;
      }
    }

    final bool stopWithDamage =
        (!isFlying && t == TerrainType.object) || t == TerrainType.barrier;
    final bool stopWithoutDamage =
        mapModel.units[to] != target && mapModel.hasUnitAtCoordinate(to);
    if (stopWithDamage && !stopWithoutDamage) {
      log.addRecord(target, 'Stopped force movement due to collision');
      await _applyDamageAction(target, unitComponent, actor: actor, action: () {
        return target.sufferDamage(pushAmount);
      }, onSufferedDamage: (amount) {
        log.addRecord(target, 'Suffered $amount impact damage');
      });
      return false;
    } else if (stopWithoutDamage) {
      log.addRecord(target, 'Stopped forced movement due to collision');
      await unitComponent.shake();
      return false;
    } else {
      await unitComponent.setCoordinateAnimated(to);
      final from = target.coordinate;
      target.coordinate = to;
      await _handleDamageWhileMoving(
          actor: actor,
          target: target,
          component: unitComponent,
          from: from,
          to: to,
          pathType: PathType.dash, // Forced movement is like dash
          isLast: isLast);
      return true;
    }
  }

  Future<void> _applyDamageAction(
      Slayable target, CoordinateComponent slayableComponent,
      {required TileModel actor,
      required int Function() action,
      required Function(int) onSufferedDamage}) async {
    await slayableComponent.shake();
    target.testDamage = true;
    final int willSufferDamageAmount = action();
    target.testDamage = false;
    final targetCoordinate = target.coordinate;
    final field = mapModel.fieldAtCoordinate(targetCoordinate);
    var damageSuffered = 0;
    if (field?.field == EtherField.windscreen && willSufferDamageAmount > 0) {
      final reduction = min(willSufferDamageAmount, 2);
      log.addRecord(field?.creator,
          '${field!.field.label} field reduced ${EncounterLogEntry.targetKeyword} damage by $reduction',
          target: target);
      final damageAmount = willSufferDamageAmount - reduction;
      if (damageAmount > 0) {
        damageSuffered = target.sufferDamage(damageAmount);
        onSufferedDamage(damageSuffered);
      }
      mapController.removeFieldAtCoordinate(targetCoordinate, actor: target);
    } else {
      damageSuffered = target.sufferDamage(willSufferDamageAmount);
      onSufferedDamage(damageSuffered);
    }
    if (target.isSlain) {
      log.addRecord(actor, 'Slayed ${EncounterLogEntry.targetKeyword}',
          target: target);
      await slayableComponent.slayAnimated();
      await _onSlayed(actor, target);
    } else if (target is PlayerUnitModel && target.isDowned) {
      log.addRecord(actor, 'Downed ${EncounterLogEntry.targetKeyword}',
          target: target);
      await _onPlayerDowned(target);
    }
    await _onDamageSuffered(actor, target, damageSuffered);
  }

  _onSlayed(TileModel actor, Slayable target) async {
    final wasAnimating = animating;
    animating = false;
    await eventController.onSlayed(actor: actor, target: target);
    animating = wasAnimating;
  }

  _onPlayerDowned(PlayerUnitModel player) async {
    final wasAnimating = animating;
    animating = true;
    final summons = player.summons.toList();
    for (final summon in summons) {
      log.addRecord(null, '${EncounterLogEntry.targetKeyword} is slayed',
          target: summon);
      player.removeSummon(summon);
      final component =
          game.findByKey<CoordinateComponent>(ComponentKey.named(summon.key))!;
      await component.slayAnimated();
      _removeSummon(summon);
    }
    animating = wasAnimating;
    turnController.onPlayerDowned(player);
  }

  _onDamageSuffered(TileModel actor, Slayable target, int damage) async {
    if (damage <= 0) {
      return;
    }
    final wasAnimating = animating;
    animating = false;
    await eventController.onAfterSuffer(
        actor: actor, target: target, damage: damage);
    animating = wasAnimating;
  }

  Future<void> move(
      {required TileModel actor,
      required dynamic target,
      required List<HexCoordinate> path,
      required PathType pathType}) async {
    assert(target is UnitModel || target is GlyphModel);
    assert(path.isNotEmpty);
    final component = game.findByKeyName<CoordinateComponent>(target.key)!;
    final effort = mapModel.effortOfPath(
        actor: target,
        start: component.coordinate,
        path: path,
        pathType: pathType);
    animating = true;
    if (actor == target) {
      log.addRecord(target,
          '${pathType.presentParticipleVerb} $effort to ${path.last.toEvenQ()}');
    } else {
      log.addRecord(actor,
          '${pathType.presentParticipleVerb} ${EncounterLogEntry.targetKeyword} $effort to ${path.last.toEvenQ()}',
          target: target);
    }
    var current = target.coordinate;
    var next = current;
    for (int i = 0; i < path.length; i++) {
      next = path[i];
      final isLast = i == path.length - 1;
      if (isLast) {
        assert(mapModel.canOccupy(actor: target, coordinate: next));
      } else {
        assert(mapModel.isPassable(
            actor: target, coordinate: next, pathType: pathType));
      }
      await _move(
          actor: actor,
          target: target,
          component: component,
          from: current,
          to: next,
          isLast: isLast,
          pathType: pathType);
      if (target.isSlain) {
        break;
      }
      current = next;
    }
    animating = false;
    if (!target.isSlain) {
      mapModel.updateCoordinate(target: target, coordinate: current);
      await _onOccupiedSpace(target);
    }
    await eventController.onAfterMove(actor: target);
  }

  _removeIceFieldIfNeededWhileMoving(
      {required TileModel actor, required HexCoordinate coordinate}) {
    final field = mapModel.fieldAtCoordinate(coordinate);
    if (field?.field == EtherField.snapfrost) {
      log.addRecord(field?.creator,
          'Reduced ${EncounterLogEntry.targetKeyword} movement by 2',
          target: actor);
      removeFieldAtCoordinate(coordinate, actor: actor);
    }
  }

  Future<void> _lootIfNeeded(TileModel actor, HexCoordinate coordinate) async {
    final object = mapModel.objects[coordinate];
    if (object != null && actor is UnitModel && object.canLoot(actor)) {
      await loot(actor: actor, object: object);
    }
  }

  Future<void> _move(
      {required TileModel actor,
      required TileModel target,
      required CoordinateComponent component,
      required HexCoordinate from,
      required HexCoordinate to,
      required bool isLast,
      required PathType pathType}) async {
    _removeIceFieldIfNeededWhileMoving(actor: target, coordinate: from);
    await _lootIfNeeded(target, to);

    await component.setCoordinateAnimated(to);
    target.coordinate = to;
    _removeIceFieldIfNeededWhileMoving(actor: target, coordinate: to);
    await _handleDamageWhileMoving(
        actor: actor,
        target: target,
        component: component,
        from: from,
        to: to,
        pathType: pathType,
        isLast: isLast);
  }

  Future<void> _handleDamageWhileMoving(
      {required TileModel actor,
      required TileModel target,
      required CoordinateComponent component,
      required HexCoordinate from,
      required HexCoordinate to,
      required PathType pathType,
      required bool isLast}) async {
    await _handleDangerousTerrainWhileMoving(
        actor: actor,
        target: target,
        component: component,
        from: from,
        to: to,
        pathType: pathType,
        isLast: isLast);
    if (!target.isSlain) {
      await _handleTrapWhileMoving(
          actor: actor, target: target, component: component, coordinate: to);
    }
  }

  Future<void> _handleTrapWhileMoving(
      {required TileModel actor,
      required TileModel target,
      required CoordinateComponent component,
      required HexCoordinate coordinate}) async {
    if (!target.triggersTraps) {
      return;
    }
    for (final c in target.coordinatesAtOrigin(coordinate)) {
      final trap = mapModel.trapAtCoordinate(c);
      if (trap == null) {
        continue;
      }
      log.addRecord(target,
          'Triggered ${trap.name}${trap.creator != null ? ' from ${EncounterLogEntry.targetKeyword}' : ''}',
          target: trap.creator);
      await _applyDamageAction(target as UnitModel, component, actor: actor,
          action: () {
        var damage = trap.damage;
        if (actor is UnitModel) {
          final buffs =
              actor.buffs.where((b) => b.type == BuffType.trapDamage).toList();
          final damageBuff = buffs.fold(0, (acc, buff) => acc + buff.amount);
          if (damageBuff > 0) {
            log.addRecord(actor, 'Buffing trap damage by +$damageBuff');
          }
          damage += damageBuff;
          for (final buff in buffs) {
            if (buff.scope == BuffScope.action) {
              actor.buffs.remove(buff);
            }
          }
        }
        return target.sufferDamage(damage);
      }, onSufferedDamage: (amount) {
        log.addRecord(target, 'Suffered $amount damage from trap');
      });
      mapController.removeTrapAtCoordinate(c, actor: target);
    }
  }

  Future<void> _handleDangerousTerrainWhileMoving(
      {required TileModel actor,
      required TileModel target,
      required CoordinateComponent component,
      required HexCoordinate from,
      required HexCoordinate to,
      required PathType pathType,
      required bool isLast}) async {
    final bool takesDamage = !target.isImperviousToDangerousTerrain &&
        (!pathType.ignoresNonTerminalDangerous || isLast) &&
        (!pathType.ignoresTerminalDangerous || !isLast);
    if (!takesDamage) {
      return;
    }
    final currentCoordinates = target.coordinatesAtOrigin(from);
    for (final c in target.coordinatesAtOrigin(to)) {
      final terrain = mapModel.terrain[c]?.terrain;
      if (terrain != TerrainType.dangerous) {
        continue;
      }
      if (currentCoordinates.contains(c)) {
        continue;
      }
      await _applyDamageAction(target as UnitModel, component, actor: actor,
          action: () {
        return target.sufferDamage(1);
      }, onSufferedDamage: (amount) {
        log.addRecord(target,
            'Suffered $amount damage from dangerous terrain at ${c.toEvenQ()}');
      });
    }
  }

  /* Health Actions */

  Future<void> sufferDamageFromDangerousTerrain(
      {required Slayable target, required HexCoordinate coordinate}) async {
    assert(mapModel.terrain[coordinate]?.terrain == TerrainType.dangerous);
    final component =
        game.findByKey<CoordinateComponent>(ComponentKey.named(target.key))!;
    animating = true;
    // TODO: Is there a better actor here?
    await _applyDamageAction(target, component, actor: target, action: () {
      return target.sufferDamage(1);
    }, onSufferedDamage: (amount) {
      log.addRecord(target,
          'Suffered $amount damage from dangerous terrain at ${coordinate.toEvenQ()}');
    });
    animating = false;
  }

  suffer(
      {required TileModel actor,
      required Slayable target,
      required int amount,
      Function()? onComplete}) async {
    log.addRecord(actor,
        'Making ${EncounterLogEntry.targetKeyword} suffer $amount damage',
        target: target);
    final component =
        game.findByKey<CoordinateComponent>(ComponentKey.named(target.key))!;
    animating = true;
    await _applyDamageAction(target, component, actor: actor, action: () {
      return target.sufferDamage(amount);
    }, onSufferedDamage: (amount) {
      log.addRecord(target, 'Suffered $amount damage');
    });
    animating = false;
    onComplete?.call();
  }

  attack(
      {required TileModel actor,
      required Slayable target,
      required int amount,
      required bool pierce,
      required Future<void> Function() willResolveAttack,
      Function()? onComplete}) async {
    assert(actor.owner != null, 'Actor must have an owner');
    log.addRecord(actor,
        'Attacking ${EncounterLogEntry.targetKeyword} for $amount base damage',
        target: target);
    final (ether, delta) = actor.owner!.rollDamageAndResolveAffinity();
    log.addRecord(actor,
        'Rolled ${ether.label} for ${delta >= 0 ? '+$delta' : delta.toString()} damage');
    showEtherDraw(target: target, ether: ether, amount: delta);
    amount += delta;
    final component =
        game.findByKey<CoordinateComponent>(ComponentKey.named(target.key))!;
    animating = true;
    await _applyDamageAction(target, component, actor: actor, action: () {
      return target.resolveAttack(amount, pierce: pierce);
    }, onSufferedDamage: (amount) {
      log.addRecord(target, 'Suffered $amount damage');
    });
    animating = false;
    await willResolveAttack();
    await eventController.onAfterAttack(actor: actor, target: target);
    onComplete?.call();
  }

  Future<void> healUnit(
      {required TileModel actor,
      required UnitModel target,
      required int amount}) async {
    final component =
        game.findByKey<CoordinateComponent>(ComponentKey.named(target.key))!;
    final String verb =
        (target is PlayerUnitModel) && target.isDowned ? 'Revived' : 'Healed';
    final amountHealed = target.resolveHeal(amount);
    animating = true;
    // TODO: Generalize heal animation for all units, not just single hex
    if (component is HexagonUnitComponent) {
      await component.glowWithColor(Colors.blue);
    }
    log.addRecord(
        actor, '$verb ${EncounterLogEntry.targetKeyword} for $amountHealed',
        target: target);
    animating = false;
  }

  /* Glyph & Field Management */

  void addField(EtherField field,
      {required UnitModel creator, required HexCoordinate coordinate}) {
    final previousField = mapModel.fields[coordinate];
    if (previousField != null) {
      removeFieldAtCoordinate(coordinate, actor: creator);
    }

    log.addRecord(
        creator, 'Added ${field.label} field to ${coordinate.toEvenQ()}');
    final fieldModel =
        FieldModel(field: field, creator: creator, coordinate: coordinate);
    mapModel.addField(fieldModel, coordinate: coordinate);
    FieldComponent fieldComponent = FieldComponent(model: fieldModel);
    game.map.add(fieldComponent);
    fieldComponent.coordinate = coordinate;
  }

  void addGlyph(RoveGlyph glyph,
      {required UnitModel actor, required HexCoordinate coordinate}) {
    assert(!mapModel.hasGlyph(coordinate));
    final glyphModel =
        GlyphModel(glyph, creator: actor, coordinate: coordinate);
    log.addRecord(actor,
        'Created ${EncounterLogEntry.targetKeyword} glyph at ${coordinate.toEvenQ()}',
        target: glyphModel);
    mapModel.addGlyph(glyphModel, coordinate: coordinate);
    GlyphComponent glyphComponent = GlyphComponent(model: glyphModel);
    game.map.add(glyphComponent);
    glyphComponent.coordinate = coordinate;
  }

  void removeTrapAtCoordinate(HexCoordinate coordinate,
      {required TileModel actor}) {
    assert(mapModel.trapAtCoordinate(coordinate) != null);
    final trap = mapModel.trapAtCoordinate(coordinate)!;
    log.addRecord(actor, 'Removed ${trap.name} from ${coordinate.toEvenQ()}');
    mapModel.removeTrapAtCoordinate(coordinate);
    game.map.componentsAtCoordinate<TrapComponent>(coordinate).forEach((c) {
      c.removeFromParent();
    });
  }

  void addTrap(TrapModel trap,
      {required HexCoordinate coordinate, required UnitModel actor}) {
    final previousTrap = mapModel.trapAtCoordinate(coordinate);
    if (previousTrap != null) {
      removeTrapAtCoordinate(coordinate, actor: actor);
    }
    log.addRecord(actor, 'Added ${trap.name} to ${coordinate.toEvenQ()}');
    mapModel.addTrap(trap, coordinate: coordinate);
    TrapComponent trapComponent = TrapComponent(model: trap);
    game.map.add(trapComponent);
    trapComponent.coordinate = coordinate;
  }

  void removeFieldAtCoordinate(HexCoordinate coordinate,
      {required TileModel actor}) {
    assert(mapModel.fields.containsKey(coordinate));
    final field = mapModel.fields[coordinate]!;
    log.addRecord(actor,
        'Removed ${field.field.label} field from ${coordinate.toEvenQ()}');
    mapModel.removeFieldAtCoordinate(coordinate);
    game.map.componentsAtCoordinate<FieldComponent>(coordinate).forEach((c) {
      c.removeFromParent();
    });
  }

  void removeGlyphAtCoordinate(HexCoordinate coordinate,
      {required UnitModel actor}) {
    final glyph = mapModel.glyphs[coordinate];
    log.addRecord(actor,
        'Removed ${EncounterLogEntry.targetKeyword} glyph from ${coordinate.toEvenQ()}',
        target: glyph);
    mapModel.removeGlyphAtCoordinate(coordinate);
    game.map.componentsAtCoordinate<GlyphComponent>(coordinate).forEach((c) {
      c.removeFromParent();
    });
  }

  /* Summons */

  void _removeSummon(UnitModel unit) {
    mapModel.removeUnit(unit);
    game.map
        .componentsAtCoordinate<SummonComponent>(unit.coordinate)
        .forEach((c) {
      c.removeFromParent();
    });
  }

  void addSummon(SummonDef summonDef,
      {required HexCoordinate coordinate, required PlayerUnitModel player}) {
    final previousSummon =
        player.summons.firstWhereOrNull((s) => s.className == summonDef.name);
    if (previousSummon != null) {
      _removeSummon(previousSummon);
      player.removeSummon(previousSummon);
    }
    final summon = SummonModel(
        summoner: player,
        summon: summonDef,
        coordinate: coordinate,
        map: mapModel);
    log.addRecord(player,
        'Summoned ${EncounterLogEntry.targetKeyword} at ${coordinate.toEvenQ()}',
        target: summon);
    player.addSummon(summon);
    mapModel.addSummon(summon, coordinate: coordinate);
    SummonComponent summonComponent = SummonComponent(model: summon);
    game.map.add(summonComponent);
    summonComponent.coordinate = coordinate;
  }

  // Misc

  void showEtherDraw(
      {required Slayable target, required Ether ether, required int amount}) {
    final component =
        game.findByKey<CoordinateComponent>(ComponentKey.named(target.key))!;
    component.showEtherDraw(ether: ether, amount: amount);
  }

  Future<void> loot(
      {required UnitModel actor, required ObjectModel object}) async {
    final objectComponent =
        game.findByKey<ObjectComponent>(ComponentKey.named(object.key))!;
    final actorComponent =
        game.findByKey<UnitComponent>(ComponentKey.named(actor.key))!;
    animating = true;
    await actorComponent.loot(objectComponent);
    animating = false;
    log.addRecord(actor, 'Looted ${EncounterLogEntry.targetKeyword}',
        target: object);
    model.loot(actor: actor, object: object);
    await eventController.onLoot(actor: actor, object: object);
  }

  Future<void> lootEtherNode(
      {required PlayerUnitModel actor,
      required EtherNodeModel etherNode}) async {
    final etherNodeComponent =
        game.findByKey<EtherNodeComponent>(ComponentKey.named(etherNode.key))!;
    final actorComponent =
        game.findByKey<UnitComponent>(ComponentKey.named(actor.key))!;
    animating = true;
    await actorComponent.loot(etherNodeComponent);
    animating = false;
    log.addRecord(
        actor, 'Used 1 movement to loot ${EncounterLogEntry.targetKeyword}',
        target: etherNode);
    model.lootEtherNode(actor: actor, etherNode: etherNode);
  }

  spawnPlacementsByName({required String name}) {
    final placements = model.encounter.placementGroups
        .where((p) => p.name == name)
        .firstOrNull;
    assert(placements != null);
    if (placements == null) {
      return;
    }
    spawnPlacements(placements: placements.placements);
  }

  spawnPlacements({required List<PlacementDef> placements}) {
    final models = mapModel.initializePlacements(placements);
    final components = game.map.components.initializeModels(models);
    game.map.addAll(components);
    for (final model in models) {
      log.addRecord(null,
          'Spawned ${EncounterLogEntry.targetKeyword} at ${model.coordinate.toEvenQ()}',
          target: model);
    }
  }
}
