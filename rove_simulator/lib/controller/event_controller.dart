import 'dart:math' hide log;

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:rove_simulator/controller/base_controller.dart';
import 'package:rove_simulator/controller/enemy_ai.dart';
import 'package:rove_simulator/model/cards/reaction_model.dart';
import 'package:rove_simulator/model/encounter_log.dart';
import 'package:rove_simulator/model/map_model.dart';
import 'package:rove_simulator/model/tiles/enemy_model.dart';
import 'package:rove_simulator/model/tiles/glyph_model.dart';
import 'package:rove_simulator/model/tiles/object_model.dart';
import 'package:rove_simulator/model/tiles/player_unit_model.dart';
import 'package:rove_simulator/model/tiles/tile_model.dart';
import 'package:rove_simulator/model/tiles/unit_model.dart';
import 'package:rove_data_types/rove_data_types.dart';

@immutable
class RoveEvent {
  final RoveEventType type;
  final TileModel? actor;
  final TileModel? target;
  final int amount;

  const RoveEvent(
      {required this.type, this.actor, this.target, this.amount = 0});

  RoveEvent withTarget(TileModel? target) {
    return RoveEvent(type: type, actor: actor, target: target, amount: amount);
  }
}

class EventController extends BaseController {
  EventController({required super.game});

  restart() {
    notifyListeners();
  }

  int _availableReactionsForPlayer(PlayerUnitModel player) {
    return max(
        0,
        player.availableReactionCount -
            cardController.selectedReactionsForPlayerCount(player));
  }

  Future<void> _handlePlayerReactions(RoveEvent event) async {
    final reactions = <(PlayerUnitModel, ReactionModel)>[];
    for (final player in game.model.actingPlayers
        .where((p) => _availableReactionsForPlayer(p) > 0)) {
      reactions.addAll(player.reactions
          .where((r) =>
              r.current.trigger.matches(event, mapModel, reactor: player))
          .map((r) => (player, r)));
    }
    if (reactions.isEmpty) return;
    for (final (player, reaction) in reactions) {
      log.addRecord(player, 'Can play ${reaction.name} reaction');
      await cardController.resolveReaction(
          event: reaction.current.trigger.eventBySettingTargetIfNeeded(
              event: event, map: mapModel, reactor: player),
          player: player,
          reaction: reaction);
    }
  }

  Future<void> _handleEnemyReaction(
      EnemyModel enemy, RoveEvent event, EnemyReactionDef reaction) async {
    if (enemy.isSlain) return;
    log.addRecord(enemy, 'Reacting');
    final ai = EnemyAI(game: game, actor: enemy);
    await ai.resolveReaction(event: event, reaction: reaction);
  }

  Future<void> _handleEnemyReactions(RoveEvent event) async {
    for (final enemy in model.actingAdversaries) {
      final reactions = enemy.reactions;
      if (reactions.isEmpty) continue;
      for (final reaction in reactions) {
        if (reaction.trigger.matches(event, mapModel, reactor: enemy)) {
          await _handleEnemyReaction(enemy, event, reaction);
        }
      }
    }
  }

  Future<void> _handleEventReactions(RoveEvent event) async {
    if (!model.isPlaying) {
      return;
    }
    await _handlePlayerReactions(event);
    await _handleEnemyReactions(event);
  }

  Future<void> onGeneratedEther({required PlayerUnitModel actor}) async {
    final event = RoveEvent(type: RoveEventType.generatedEther, actor: actor);
    await _handleEventReactions(event);
  }

  Future<void> onAfterAttack(
      {required TileModel actor, required Slayable target}) async {
    final event = RoveEvent(
        type: RoveEventType.afterAttack, actor: actor, target: target);
    await _handleEventReactions(event);
  }

  Future<void> onBeforeAttack(
      {required TileModel actor, required Slayable target}) async {
    final event = RoveEvent(
        type: RoveEventType.beforeAttack, actor: actor, target: target);
    await _handleEventReactions(event);
  }

  Future<void> onAfterSuffer(
      {required TileModel actor,
      required Slayable target,
      required int damage}) async {
    final event = RoveEvent(
        type: RoveEventType.afterSuffer,
        actor: actor,
        target: target,
        amount: damage);
    await _handleEventReactions(event);
  }

  Future<void> onAfterMove({required TileModel actor}) async {
    final event = RoveEvent(type: RoveEventType.afterMove, actor: actor);
    await _handleEventReactions(event);
  }

  Future<void> onStartTurn({required UnitModel actor}) async {
    final event = RoveEvent(type: RoveEventType.startTurn, actor: actor);
    await _handleEventReactions(event);
  }

  bool matches(
      {required RoveEvent event,
      required ReactionTriggerDef trigger,
      required PlayerUnitModel player}) {
    return trigger.matches(event, mapModel, reactor: player);
  }

  Future<void> onSlayed(
      {required TileModel actor, required Slayable target}) async {
    await _handleEncounterActions(actor: actor, actions: target.onSlayed);
  }

  Future<void> onLoot(
      {required UnitModel actor, required ObjectModel object}) async {
    await _handleEncounterActions(actor: actor, actions: object.onLoot);
  }

  bool _matchesCondition(
      {required TileModel? actor,
      required EncounterAction action,
      required RoveCondition condition}) {
    switch (condition.type) {
      case RoveConditionType.hasItem:
        return actor is PlayerUnitModel &&
            condition is HasItemCondition &&
            actor.items.any((i) => i.name == condition.item);
      // TODO: Implement missing conditions
      case RoveConditionType.allAdversariesSlainExcept:
      case RoveConditionType.milestone:
      case RoveConditionType.damage:
      case RoveConditionType.faction:
      case RoveConditionType.health:
      case RoveConditionType.isAlive:
      case RoveConditionType.isSlain:
      case RoveConditionType.inRangeOfAny:
      case RoveConditionType.inRangeOfNone:
      case RoveConditionType.matches:
      case RoveConditionType.roversInRangeOf:
      case RoveConditionType.onExit:
      case RoveConditionType.playerCount:
      case RoveConditionType.minPlayerCount:
      case RoveConditionType.sufferedDamageThisTurn:
      case RoveConditionType.tokenCount:
        return false;
      case RoveConditionType.phase:
        return game.model.phase == (condition as PhaseCondition).phase;
      case RoveConditionType.round:
        return game.model.round == (condition as RoundCondition).round;
      case RoveConditionType.roversOnExit:
        return model.players.any((p) =>
                mapModel.terrain[p.coordinate]?.terrain != TerrainType.exit) ==
            false;
      case RoveConditionType.ownerIsClosestOfClassToRovers:
        assert(actor != null);
        return actor != null ? mapModel.isClosestOfClassToRovers(actor) : false;
      case RoveConditionType.allAdversariesSlain:
        return mapModel.adversaries.any((a) => !a.isSlain) == false;
    }
  }

  Future<void> _handleEncounterActions(
      {TileModel? actor, required List<EncounterAction> actions}) async {
    for (final action in actions) {
      if (!action.conditions.every((c) =>
          _matchesCondition(actor: actor, action: action, condition: c))) {
        continue;
      }
      switch (action.type) {
        case EncounterActionType.codex:
          await game.codexController.showCodex(action);
          break;
        // TODO: Implement actions
        case EncounterActionType.codexLink:
          break;
        case EncounterActionType.addToken:
          break;
        case EncounterActionType.awaken:
          break;
        case EncounterActionType.function:
          break;
        case EncounterActionType.dialog:
          break;
        case EncounterActionType.toggleBehavior:
          break;
        case EncounterActionType.giveTo:
          break;
        case EncounterActionType.milestone:
          break;
        case EncounterActionType.remove:
          break;
        case EncounterActionType.removeAll:
          break;
        case EncounterActionType.removeRule:
          break;
        case EncounterActionType.replace:
          break;
        case EncounterActionType.resetRound:
          break;
        case EncounterActionType.respawn:
          break;
        case EncounterActionType.rollEtherDie:
          break;
        case EncounterActionType.rollXulcDie:
          break;
        case EncounterActionType.rules:
          break;
        case EncounterActionType.setLossCondition:
          break;
        case EncounterActionType.setSubtitle:
          break;
        case EncounterActionType.setVictoryCondition:
          break;
        case EncounterActionType.rewardEther:
        case EncounterActionType.rewardItem:
        case EncounterActionType.rewardLyst:
          if (actor is PlayerUnitModel) {
            await rewardController.resolveReward(player: actor, action: action);
          }
          break;
        case EncounterActionType.unlockFromAdjacentAndLoot:
          assert(actor is ObjectModel);
          if (actor is ObjectModel) {
            await _resolveUnlock(object: actor);
          }
          break;
        case EncounterActionType.spawnPlacements:
          await mapController.spawnPlacementsByName(name: action.value);
          break;
        case EncounterActionType.victory:
          game.win();
          break;
        case EncounterActionType.loss:
          game.fail();
          break;
      }
    }
  }

  Future<void> _resolveUnlock({required ObjectModel object}) async {
    final condition = object.unlockCondition;
    assert(condition is HasItemCondition);
    final item = condition is HasItemCondition ? condition.item : null;
    if (item == null) return;

    final player = mapModel
        .unitsAdjacentToCoordinate(object.coordinate)
        .whereType<PlayerUnitModel>()
        .firstWhereOrNull((p) => p.encounterItems.any((i) => i.name == item));
    if (player != null) {
      log.addRecord(
          player, 'Unlocked ${EncounterLogEntry.targetKeyword} with $item',
          target: object);
      await mapController.loot(actor: player, object: object);
    }
  }

  Future<void> onOccupiedSpace({required TileModel actor}) async {
    await _handleEncounterActions(actions: model.encounter.onOccupiedSpace);
  }

  onDidStartRound() async {
    final tiles = [...mapModel.units.values, ...mapModel.objects.values];
    for (final tile in tiles) {
      await _handleEncounterActions(actor: tile, actions: tile.onDidStartRound);
    }
    await _handleEncounterActions(actions: model.encounter.onDidStartRound);
  }

  onWillEndPhase() async {
    await _handleEncounterActions(actions: model.encounter.onWillEndPhase);
  }

  onWillEndRound() async {
    final tiles = [...mapModel.units.values, ...mapModel.objects.values];
    for (final tile in tiles) {
      await _handleEncounterActions(actor: tile, actions: tile.onWillEndRound);
    }
    await _handleEncounterActions(actions: model.encounter.onWillEndRound);
  }
}

extension on TargetKind {
  bool _matches({required TileModel target, UnitModel? reactor}) {
    if (reactor == null) return false;
    switch (this) {
      case TargetKind.self:
        return target == reactor;
      case TargetKind.ally:
        return target is UnitModel && target.isAllyToUnit(reactor);
      case TargetKind.enemy:
        return target is UnitModel && target.isEnemyToUnit(reactor);
      case TargetKind.selfOrAlly:
        return target is UnitModel && target.isAllyToUnit(reactor) ||
            target == reactor;
      case TargetKind.selfOrEventActor:
        assert(this != TargetKind.selfOrEventActor);
        return false;
      case TargetKind.allyOrGlyph:
        return (target is UnitModel && target.isAllyToUnit(reactor)) ||
            (target is GlyphModel);
      case TargetKind.glyph:
        return target is GlyphModel;
    }
  }
}

extension on ReactionTriggerDef {
  List<TileModel> _triggerTargetCandidatesForEvent(
      {required RoveEvent event,
      required UnitModel? reactor,
      required MapModel map}) {
    if (event.target != null) {
      return [event.target!];
    }

    switch (targetKind) {
      case TargetKind.self:
      case TargetKind.ally:
      case TargetKind.enemy:
      case TargetKind.selfOrAlly:
      case TargetKind.selfOrEventActor:
      case TargetKind.allyOrGlyph:
      case null:
        throw UnimplementedError();
      case TargetKind.glyph:
        return map.glyphs.values.where((g) => g.creator == reactor).toList();
    }
  }

  bool _matchesRange(RoveEvent event, UnitModel? reactor, TileModel target) {
    late TileModel originUnit;
    switch (rangeOrigin) {
      case ReactionTriggerRangeOrigin.eventActor:
        if (event.actor == null) {
          return false;
        }
        originUnit = event.actor!;
        break;
      case ReactionTriggerRangeOrigin.reactor:
        if (reactor == null) {
          return false;
        }
        originUnit = reactor;
    }
    final distance = originUnit.distanceToTarget(target);
    return range.$1 <= distance && distance <= range.$2;
  }

  bool matches(RoveEvent event, MapModel map, {UnitModel? reactor}) {
    if (type != event.type) return false;

    if (!matchesAmount(event.amount)) return false;

    if (actorKind == null && targetKind == null) {
      final actor = event.actor;
      if (actor != null && range != (0, 0)) {
        if (!_matchesRange(event, reactor, actor)) {
          return false;
        }
      }
    }

    if (actorKind != null) {
      if (event.actor == null) {
        return false;
      }
      if (!actorKind!._matches(target: event.actor!, reactor: reactor)) {
        return false;
      }
      if (range != (0, 0) && targetKind == null) {
        if (!_matchesRange(event, reactor, event.actor!)) {
          return false;
        }
      }
    }

    if (targetKind != null) {
      final candidates = _triggerTargetCandidatesForEvent(
              event: event, reactor: reactor, map: map)
          .where((t) =>
              targetKind!._matches(target: t, reactor: reactor) &&
              _matchesRange(event, reactor, t));
      if (candidates.isEmpty) {
        return false;
      }
    }

    return true;
  }

  RoveEvent eventBySettingTargetIfNeeded(
      {required RoveEvent event,
      required MapModel map,
      required UnitModel reactor}) {
    if (event.target != null || targetKind == null) {
      return event;
    }

    final target = _triggerTargetCandidatesForEvent(
            event: event, reactor: reactor, map: map)
        .where((t) =>
            targetKind!._matches(target: t, reactor: reactor) &&
            _matchesRange(event, reactor, t))
        .firstOrNull;
    // TODO: What happens if there's multiple targets? Unsure if it makes as difference for any class and it's unlikely.
    return event.withTarget(target);
  }
}
