import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flame/components.dart' hide Timer;
import 'package:flutter/foundation.dart';
import 'package:rove_simulator/controller/base_controller.dart';
import 'package:rove_simulator/controller/enemy_actions/enemy_action_resolver.dart';
import 'package:rove_simulator/controller/enemy_actions/enemy_single_target_heal_resolver.dart';
import 'package:rove_simulator/controller/event_controller.dart';
import 'package:rove_simulator/model/targeting/aoe_def_coordinate_extension.dart';
import 'package:rove_simulator/model/cards/ability_model.dart';
import 'package:rove_simulator/model/encounter_log.dart';
import 'package:rove_simulator/model/path_type.dart';
import 'package:rove_simulator/model/targeting/area_of_effect.dart';
import 'package:rove_simulator/model/targeting/map_model_targeting_extension.dart';
import 'package:rove_simulator/model/targeting/target_data.dart';
import 'package:rove_simulator/model/tiles/enemy_model.dart';
import 'package:rove_simulator/model/tiles/player_unit_model.dart';
import 'package:rove_simulator/model/tiles/unit_model.dart';
import 'package:hex_grid/hex_grid.dart';
import 'package:rove_data_types/rove_data_types.dart';

enum EnemyTargetLogic {
  singleTargetAttack,
  singleTargetHeal,
  multiTargetAttack,
  multiTargetHeal,
}

class EnemyAI extends BaseController {
  final EnemyModel actor;
  EnemyAI({required super.game, required this.actor});

  final List<(int, RoveAction)> _actionsToResolve = [];
  final List<UnitModel> _targets = [];
  HexCoordinate? _targetCoordinate;
  AreaOfEffect? _targetAOE;
  AbilityModel? _ability;
  RoveEvent? _event;
  late PositionComponent _cardComponent;

  UnitModel? get currentActor => _resolver?.actingUnit ?? actor;
  HexCoordinate? get targetCoordinate =>
      _resolver?.targetCoordinates.firstOrNull;
  String? debugStringForCoordinate(HexCoordinate coordinate) {
    return _resolver?.debugStringForCoordinate(coordinate);
  }

  bool isInAreaOfEffect(HexCoordinate coordinate) {
    return _targetAOE?.coordinates.contains(coordinate) ?? false;
  }

  get currentActionPolarity => _resolver?.action.polarity;

  Future<void> resolve() async {
    final ability = model.currentAbilityForEnemy(actor);
    await resolveAbility(
        ability: model.currentAbilityForEnemy(actor), actions: ability.actions);
  }

  Future<void> resolveAbility(
      {required AbilityModel ability,
      required List<RoveAction> actions,
      int indexOffset = 0}) async {
    _ability = ability;
    log.addRecord(actor, 'Resolving ability: ${ability.name}');
    _cardComponent = cardController.showCard(card: ability, unit: actor);
    _actionsToResolve.addAll(
        actions.mapIndexed((index, action) => (index + indexOffset, action)));
    assert(_actionsToResolve.isNotEmpty);
    bool completed = true;
    while (_actionsToResolve.isNotEmpty && !actor.isSlain && model.isPlaying) {
      completed = await _resolveNextAction(skipped: !completed);
    }
    log.addRecord(actor, 'Resolved ability: ${ability.name}');
    ability.currentActionIndex = null;
    cardController.removeCard(_cardComponent);
  }

  Future<void> resolveReaction(
      {required RoveEvent event, required EnemyReactionDef reaction}) async {
    _event = event;
    _actionsToResolve.addAll(
        reaction.actions.mapIndexed((index, action) => (index, action)));
    assert(_actionsToResolve.isNotEmpty);
    bool completed = true;
    while (_actionsToResolve.isNotEmpty && !actor.isSlain && model.isPlaying) {
      completed = await _resolveNextAction(skipped: !completed);
    }
  }

  Future<bool> _resolveNextAction({required bool skipped}) async {
    var (index, action) = _actionsToResolve.removeAt(0);
    _ability?.currentActionIndex = index;
    await Future.delayed(const Duration(milliseconds: kDebugMode ? 0 : 500));
    if (skipped && action.requiresPrevious) {
      log.addRecord(actor,
          'Previous action required; skipping ${action.shortDescription}');
      return false;
    }
    log.addRecord(actor, 'Resolving action: ${action.shortDescription}');
    if (action.hasCustomTargetSelection) {
      action = _applyAugments(action, currentIndex: index);
      return await _executeAction(action);
    } else {
      _resolveTargets((index, action));
      if (_targets.isEmpty) {
        log.addRecord(actor,
            'Did not find a target; skipping ${action.shortDescription}');
        return false;
      } else {
        action = _applyAugments(action, currentIndex: index);
        await _executeTargets(_targets.toList(), action);
        return true;
      }
    }
  }

  EnemyActionResolver? _resolver;

  Future<bool> _executeAction(RoveAction action) async {
    final resolver = EnemyActionResolver.fromAction(
        game: game,
        actor: actor,
        targets: [],
        ability: _ability,
        action: action);
    _resolver = resolver;
    await Future.delayed(const Duration(milliseconds: 500));
    final result = await resolver.execute();
    _resolver = null;
    return result;
  }

  _executeTargets(List<UnitModel> targets, RoveAction action) async {
    while (targets.isNotEmpty) {
      final target = targets.removeAt(0);
      final resolver = EnemyActionResolver.fromAction(
          game: game,
          actor: actor,
          targets: [target],
          targetCoordinate: _targetCoordinate,
          targetAOE: _targetAOE,
          ability: _ability,
          action: action);
      _resolver = resolver;
      await Future.delayed(const Duration(milliseconds: 500));
      await resolver.execute();
      _resolver = null;
      if (action.type == RoveActionType.move) {
        break;
      }
    }
  }

  _setTargetFromEventTarget() {
    assert(_event != null);
    final eventTarget = _event?.target;
    if (eventTarget == null || eventTarget is! UnitModel) {
      return;
    }
    _targets.add(eventTarget);
    _targetCoordinate = eventTarget.coordinate;
  }

  _setTargetFromEventActor() {
    assert(_event != null);
    final eventActor = _event?.actor;
    if (eventActor == null || eventActor is! UnitModel) {
      return;
    }
    _targets.add(eventActor);
    _targetCoordinate = eventActor.coordinate;
  }

  _resolveTargets((int, RoveAction) actionWithIndex) {
    final (index, action) = actionWithIndex;
    if (action.retreat) {
      assert(_targets.isNotEmpty);
      return;
    }
    _targets.clear();
    _targetCoordinate = null;
    _targetAOE = null;
    var current = actionWithIndex;
    switch (action.targetMode) {
      case RoveActionTargetMode.eventActor:
        _setTargetFromEventActor();
        return;
      case RoveActionTargetMode.eventTarget:
        _setTargetFromEventTarget();
        return;
      case RoveActionTargetMode.all:
      case RoveActionTargetMode.previous:
        throw UnimplementedError();
      case RoveActionTargetMode.range:
        break;
    }

    while (current.$2.logic == null) {
      int index = _actionsToResolve.indexOf(current);
      if (index >= _actionsToResolve.length - 1) {
        break;
      }
      current = _actionsToResolve[index + 1];
    }
    final logic = current.$2.logic;
    if (logic == null) {
      return;
    }
    final movementAction = current != actionWithIndex ? action : null;
    switch (logic) {
      case EnemyTargetLogic.singleTargetAttack:
        _resolveSingleTargetAttackTarget(movementAction, current.$2);
        break;
      case EnemyTargetLogic.singleTargetHeal:
        _resolveSingleTargetHealTarget(movementAction, current.$2);
        break;
      case EnemyTargetLogic.multiTargetAttack:
        _resolveMultiTargetAttackTargets(movementAction, current.$2);
        break;
      case EnemyTargetLogic.multiTargetHeal:
        _resolveMultiTargetHealTargets(movementAction, current.$2);
        break;
    }
  }

  _resolveMultiTargetHealTargets(
      RoveAction? movementAction, RoveAction healAction) {
    final allies = _allies;
    final targetableUnitsData = allies
        .map((u) => _isAOETargetCandidate(u, movementAction,
            healAction.aoe ?? AOEDef.x1Hex(), healAction.range))
        .flattened
        .toList();
    if (targetableUnitsData.isEmpty) {
      log.addRecord(
          actor, 'No allies to heal found within range; healing self instead');
      _targets.add(actor);
      return;
    }
    final groupedCoordinates =
        TargetData.groupUnitsByCoordinateAndAOE(targetableUnitsData);
    final coordinatesSortedByMostDamagedUnits = groupedCoordinates.entries
        .sorted((a, b) => b.value
            .where((u) => u.damage > 0)
            .length
            .compareTo(a.value.where((u) => u.damage > 0).length))
        .map((entry) => entry.key)
        .toList();
    final bestCoordinate = coordinatesSortedByMostDamagedUnits.first;

    var candidateTargets = groupedCoordinates[bestCoordinate]!;
    List<UnitModel> targets =
        EnemySingleTargetHealResolver.selectTargetsOrActor(
            actor: actor,
            count: healAction.targetCount,
            candidates: candidateTargets);

    _targetCoordinate = bestCoordinate.$1;
    _targetAOE = bestCoordinate.$2;
    _targets.addAll(targets);
  }

  _resolveMultiTargetAttackTargets(
      RoveAction? movementAction, RoveAction attackAction) {
    final enemies = _enemies;
    final candidatesAndData = enemies
        .map((u) => _isAOETargetCandidate(u, movementAction,
            attackAction.aoe ?? AOEDef.x1Hex(), attackAction.range))
        .flattened
        .toList();
    if (candidatesAndData.isEmpty) {
      _resolveTargetWhenNoCandidates(enemies, movementAction);
      return;
    }

    final effortDescending = movementAction?.targetFarthest ?? false;
    final mostTargetsCoordinate = TargetData.findMostTargetsCoordinate(
        candidatesAndData,
        effortDescending: effortDescending);

    _targetCoordinate = mostTargetsCoordinate.$1;
    _targetAOE = mostTargetsCoordinate.$2;
    _targets.addAll(mostTargetsCoordinate.$3);
  }

  _resolveTargetWhenNoCandidates(
      List<UnitModel> units, RoveAction? movementAction) {
    if (movementAction == null) {
      return;
    }
    final target = _findClosestUnit(units, movementAction);
    if (target == null) {
      return;
    }
    _targetCoordinate = _findClosestCoordinateToTarget(target, movementAction);
    log.addRecord(actor,
        'Did not find a target within range; ${movementAction.movementVerb} towards ${EncounterLogEntry.targetKeyword}',
        target: target);
    _targets.add(target);
  }

  _resolveSingleTargetHealTarget(
      RoveAction? movementAction, RoveAction healAction) {
    final allies = _allies;
    final targetableUnitsData = allies
        .map((u) => _isAOETargetCandidate(u, movementAction,
            healAction.aoe ?? AOEDef.x1Hex(), healAction.range))
        .flattened
        .toList();
    if (targetableUnitsData.isEmpty) {
      log.addRecord(
          actor, 'No allies to heal found within range; healing self instead');
      _targets.add(actor);
      return;
    }
    final targetData = _findHighestDamageTargetData(targetableUnitsData);
    if (targetData.target.damage == 0) {
      log.addRecord(
          actor, 'No damaged allies found within range; healing self instead');
      _targets.add(actor);
      return;
    }
    _targets.add(targetData.target);
    _targetAOE = targetData.aoe;
    _targetCoordinate = targetData.lowestEffortCoordinate;
  }

  List<UnitModel> get _enemies =>
      mapModel.targetableUnits.where((u) => u.isEnemyToUnit(actor)).toList();
  List<UnitModel> get _allies =>
      mapModel.targetableUnits.where((u) => u.isAllyToUnit(actor)).toList();

  _resolveSingleTargetAttackTarget(
      RoveAction? movementAction, RoveAction attackAction) {
    final enemies = _enemies;
    final targetableUnitsData = enemies
        .map((u) => _isAOETargetCandidate(u, movementAction,
            attackAction.aoe ?? AOEDef.x1Hex(), attackAction.range))
        .flattened
        .toList();
    if (targetableUnitsData.isEmpty) {
      _resolveTargetWhenNoCandidates(enemies, movementAction);
      return;
    }
    final effortDescending = movementAction?.targetFarthest ?? false;
    final targetData = _findHighestHealthTargetData(targetableUnitsData,
        effortDescending: effortDescending);
    _targets.add(targetData.target);
    _targetAOE = targetData.aoe;
    _targetCoordinate = targetData.lowestEffortCoordinate;
  }

  UnitModel _findHighestHealthEnemy(List<(UnitModel, int)> enemiesAndMoveEffort,
      {bool effortDescending = false}) {
    assert(enemiesAndMoveEffort.isNotEmpty);
    enemiesAndMoveEffort.sort((a, b) => a.$1.health - b.$1.health);
    enemiesAndMoveEffort = enemiesAndMoveEffort.reversed.toList();
    if (effortDescending) {
      enemiesAndMoveEffort.sort((a, b) => b.$2 - a.$2);
    } else {
      enemiesAndMoveEffort.sort((a, b) => a.$2 - b.$2);
    }
    return enemiesAndMoveEffort.first.$1;
  }

  TargetData _findHighestHealthTargetData(List<TargetData> enemiesAndMoveEffort,
      {bool effortDescending = false}) {
    assert(enemiesAndMoveEffort.isNotEmpty);
    enemiesAndMoveEffort.sort((a, b) => a.target.health - b.target.health);
    enemiesAndMoveEffort = enemiesAndMoveEffort.reversed.toList();
    if (effortDescending) {
      enemiesAndMoveEffort
          .sort((a, b) => b.minimumMoveEffort - a.minimumMoveEffort);
    } else {
      enemiesAndMoveEffort
          .sort((a, b) => a.minimumMoveEffort - b.minimumMoveEffort);
    }
    return enemiesAndMoveEffort.first;
  }

  TargetData _findHighestDamageTargetData(List<TargetData> targets) {
    assert(targets.isNotEmpty);
    targets.sort((a, b) => b.target.damage - a.target.damage);
    return targets.first;
  }

  UnitModel? _findClosestUnit(
      List<UnitModel> units, RoveAction movementAction) {
    final actorCoordinate = actor.coordinate;
    var unitsAndMoveEffort = units
        .expand((u) => actor
            .originCoordinatesToOccupyCoordinate(u.coordinate)
            .map((c) => (u, c)))
        .map((d) => (
              d.$1,
              mapModel.pathDistance(
                  actor: actor,
                  from: actorCoordinate,
                  to: d.$2,
                  pathType: movementAction.pathTypeForEnemyRouting)
            ))
        .where((d) => d.$2 != null)
        .map((d) => (d.$1, d.$2!))
        .toList();
    final effortDescending = movementAction.targetFarthest;
    return _findHighestHealthEnemy(unitsAndMoveEffort,
        effortDescending: effortDescending);
  }

  HexCoordinate? _findClosestCoordinateToTarget(
      UnitModel target, RoveAction movementAction) {
    final amount = actor.resolveAmountForAction(movementAction);
    final coordinates = mapModel
        .occupableCoordinatesByMoving(actor: actor, distance: amount)
        .toList();
    assert(coordinates
        .isNotEmpty); // At least the actor coordinate should be there
    final allCoordinates = coordinates.map((c) {
      final path = mapModel.path(
          actor: actor,
          target: actor,
          from: actor.coordinate,
          to: c,
          pathType: movementAction.pathTypeForEnemyRouting);
      return (
        c,
        path.isEmpty
            ? null
            : mapModel.effortOfPath(
                actor: actor,
                start: actor.coordinate,
                path: path,
                pathType: movementAction.pathTypeForEnemyRouting)
      );
    }).toList();
    final viableCoordinates = allCoordinates
        .where((d) => d.$2 != null)
        .map((d) => (d.$1, d.$2!))
        .where((d) => d.$2 <= amount)
        .toList();
    final coordinatesAndDistanceToTarget = viableCoordinates
        .map((d) => (d.$1, actor.distanceToTarget(target, origin: d.$1)))
        .toList();
    coordinatesAndDistanceToTarget.sort((a, b) => a.$2 - b.$2);
    return coordinatesAndDistanceToTarget.first.$1;
  }

  TargetData _targetDataFromReachableCoordinates(
      UnitModel target,
      RoveAction? movementAction,
      AreaOfEffect? aoe,
      Iterable<HexCoordinate> coordinates) {
    if (movementAction == null) {
      return coordinates.where((c) => c == actor.coordinate).isEmpty
          ? TargetData.untargetable(target)
          : TargetData.withoutMoving(target: target, aoe: aoe, actor: actor);
    }
    final amount = actor.resolveAmountForAction(movementAction);
    final viableCoordinatesAndDistances = coordinates
        .map((c) => (
              c,
              mapModel.pathDistance(
                  actor: actor,
                  from: actor.coordinate,
                  to: c,
                  pathType: movementAction.pathTypeForEnemyRouting)
            ))
        .where((d) => d.$2 != null)
        .map(((d) => (d.$1, d.$2!)))
        .where((d) => d.$2 <= amount)
        .toList();
    return TargetData.fromCoordinates(
        target: target,
        aoe: aoe,
        coordinatesWithEffort: viableCoordinatesAndDistances);
  }

  Iterable<TargetData> _isAOETargetCandidate(UnitModel target,
      RoveAction? movementAction, AOEDef aoeDef, (int, int) range) {
    final aoes = aoeDef.matchingTarget(target);
    return aoes.map((aoe) {
      final coordinates = mapModel.occupableCoordinatesAtRangeOfAOE(
          actor: actor, aoe: aoe, range: range);
      return _targetDataFromReachableCoordinates(
          target, movementAction, aoe, coordinates);
    }).where((t) => t.targetable);
  }

  /* Augments */

  RoveAction _applyAugments(RoveAction action, {required int currentIndex}) {
    final applicableAugments =
        action.augments.where((a) => _canApplyAugment(a));
    for (var augment in applicableAugments) {
      action = _applyAugment(action, augment, currentIndex: currentIndex);
    }
    return action;
  }

  bool _canApplyAugment(ActionAugment augment) {
    final condition = augment.condition;
    if (condition is AllyAdjacentToTargetAugmentCondition) {
      if (_targets.length == 1) {
        final target = _targets.first;
        final adjacentCoordinates = mapModel.coordinatesWithinRange(
            center: target.coordinate, range: (1, 1), needsLineOfSight: false);
        return adjacentCoordinates
            .any((c) => mapModel.hasAllyAtCoordinate(actor, c));
      }
    } else if (condition is TargetHasEtherCondition) {
      final target = _targets.firstOrNull;
      if (target != null && target is PlayerUnitModel) {
        final ether = condition.ether;
        return target.personalEtherPool.contains(ether) ||
            target.infusedEtherPool.contains(ether);
      }
    }
    return false;
  }

  RoveAction _applyAugment(RoveAction action, ActionAugment augment,
      {required int currentIndex}) {
    switch (augment.type) {
      case AugmentType.buff:
        log.addRecord(actor,
            'Used augment to buff ${action.shortDescription} with ${augment.action.toBuff!.descriptionForAction(action)}');
        return augment.augmentAction(action);
      case AugmentType.replacement:
        throw UnimplementedError('Replacement action augment not implemented');
      case AugmentType.additional:
        _actionsToResolve.insert(0, (currentIndex, augment.action));
        return action;
      case AugmentType.special:
        throw UnimplementedError('Special augment not implemented');
    }
  }
}

extension RoveActionPathType on RoveAction {
  bool get hasCustomTargetSelection {
    switch (type) {
      case RoveActionType.createTrap:
      case RoveActionType.command:
      case RoveActionType.spawn:
        return true;
      default:
        return false;
    }
  }

  String get movementVerb {
    switch (type) {
      case RoveActionType.jump:
        return 'jumping';
      case RoveActionType.move:
        return 'moving';
      default:
        throw Exception('Invalid action type');
    }
  }

  PathType get pathTypeForEnemyRouting {
    switch (type) {
      case RoveActionType.jump:
        return PathType.enemyAIJump;
      case RoveActionType.move:
        return PathType.enemyAIDash;
      case RoveActionType.teleport:
        // TODO: Handle teleport
        return PathType.jump;
      default:
        throw Exception('Invalid path type');
    }
  }

  PathType get pathTypeForEnemyExecution {
    switch (type) {
      case RoveActionType.jump:
        return PathType.jump;
      case RoveActionType.move:
        return PathType.dash;
      case RoveActionType.teleport:
        // TODO: Handle teleport
        return PathType.jump;
      default:
        throw Exception('Invalid path type');
    }
  }

  EnemyTargetLogic? get logic {
    switch (polarity) {
      case RoveActionPolarity.negative:
        return targetCount == 1
            ? EnemyTargetLogic.singleTargetAttack
            : EnemyTargetLogic.multiTargetAttack;
      case RoveActionPolarity.positive:
        return targetCount == 1
            ? EnemyTargetLogic.singleTargetHeal
            : EnemyTargetLogic.multiTargetHeal;
      case RoveActionPolarity.neutral:
        return null;
    }
  }

  bool get targetFarthest {
    return modifiers.contains(const TargetFarthestModifier());
  }
}
