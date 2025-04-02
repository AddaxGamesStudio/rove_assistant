import 'dart:async';

import 'package:rove_simulator/controller/enemy_actions/enemy_action_resolver.dart';
import 'package:rove_simulator/model/encounter_log.dart';
import 'package:rove_simulator/model/map_model.dart';
import 'package:rove_simulator/model/path_type.dart';
import 'package:rove_simulator/model/tiles/trap_model.dart';
import 'package:rove_simulator/model/tiles/unit_model.dart';
import 'package:hex_grid/hex_grid.dart';
import 'package:rove_data_types/rove_data_types.dart';

mixin FindPullPushPathCausingMostDamage on EnemyActionResolver {
  List<HexCoordinate> findPathCausingMostDamage(
      {required List<HexCoordinate> destinations,
      required int amount,
      required PathType pathType}) {
    assert(amount > 0);
    assert(destinations.isNotEmpty);
    assert(pathType == PathType.push || pathType == PathType.pull);
    final target = targets.first;
    List<List<HexCoordinate>> paths = destinations
        .map((c) => mapModel.path(
            actor: actor,
            target: target,
            from: target.coordinate,
            to: c,
            pathType: pathType))
        .toList();
    final pathsAndDamage = paths
        .map((path) => (
              path,
              mapModel.damageOfPath(
                      actor: target, start: target.coordinate, path: path) +
                  amount -
                  path.length
            ))
        .toList();
    pathsAndDamage.sort((a, b) => b.$2.compareTo(a.$2));

    final path = pathsAndDamage.first.$1;
    return path;
  }
}

class EnemyPushResolver extends EnemyActionResolver
    with FindPullPushPathCausingMostDamage {
  EnemyPushResolver(
      {required super.game,
      required super.actor,
      required UnitModel target,
      required super.action})
      : super(targets: [target]);

  Completer<bool> completer = Completer();

  int get amount => action.type == RoveActionType.push
      ? actor.resolveAmountForAction(action)
      : actor.resolvePushAmountForAction(action);

  @override
  Future<bool> execute() async {
    assert(amount > 0);
    final target = targets.first;
    if (target.immuneToForcedMovement) {
      log.addRecord(actor,
          'Skipped push because ${EncounterLogEntry.targetKeyword} is immune to forced movement.',
          target: target);
      return false;
    }

    final List<HexCoordinate> validDestinations =
        _validPushDestinations(target);

    if (validDestinations.isEmpty) {
      log.addRecord(actor, 'Skipped push due to no viable direction');
      return false;
    }

    final List<HexCoordinate> path = findPathCausingMostDamage(
        destinations: validDestinations,
        amount: amount,
        pathType: PathType.push);

    await mapController.push(
        actor: actor, target: target, amount: amount, path: path);
    return true;
  }

  List<HexCoordinate> _validPushDestinations(UnitModel target) {
    final coordinates = mapModel
        .coordinatesWithinRange(
            center: target.coordinate,
            range: (1, amount),
            needsLineOfSight: false)
        .toList();
    final distanceToActor = actor.distanceToTarget(target);
    final pushCoordinates = coordinates
        .where((c) => actor.distanceToCoordinate(c) > distanceToActor)
        .toList();
    final validDestinations = pushCoordinates.where((c) {
      final path = mapModel.path(
          actor: actor,
          target: target,
          from: target.coordinate,
          to: c,
          pathType: PathType.push);
      if (mapModel.isPushStopperAtCoordinate(c, target: target)) {
        return path.isNotEmpty;
      } else {
        return path.length == amount &&
            mapModel.canOccupy(actor: target, coordinate: c);
      }
    }).toList();
    return validDestinations;
  }
}

extension EnemyPushPullResolverExtension on MapModel {
  int _damageOfCoordinate(
      {required UnitModel actor,
      required HexCoordinate coordinate,
      required PathType pathType,
      required bool isTerminal,
      required List<TrapModel> triggeredTraps}) {
    int damage = 0;
    if (terrain[coordinate]?.terrain == TerrainType.dangerous) {
      if (!actor.isImperviousToDangerousTerrain) {
        if (isTerminal) {
          if (!pathType.ignoresTerminalDangerous) {
            damage += 1;
          }
        } else if (!pathType.ignoresNonTerminalDangerous) {
          damage += 1;
        }
      }
    }
    final trap = traps[coordinate];
    if (trap != null && !triggeredTraps.contains(trap)) {
      damage += trap.damage;
      triggeredTraps.add(trap);
    }
    return damage;
  }

  int damageOfPath(
      {required UnitModel actor,
      required HexCoordinate start,
      required List<HexCoordinate> path,
      PathType pathType = PathType.dash}) {
    int damage = 0;
    if (path.isEmpty) {
      return 0;
    }
    HexCoordinate previous = start;
    final List<TrapModel> triggeredTraps = [];
    for (var i = 0; i < path.length; i++) {
      final current = path[i];
      assert(previous.distanceTo(current) == 1, 'Must be neighbors');

      final isTerminal = i == path.length - 1;

      final previousCoordinates = actor.coordinatesAtOrigin(previous);
      final currentCoordinates = actor.coordinatesAtOrigin(current);
      final enteringCoordinates = currentCoordinates
          .where((c) =>
              !previousCoordinates.contains(c) ||
              (isTerminal && pathType.ignoresNonTerminalDangerous))
          .toList();

      for (HexCoordinate c in enteringCoordinates) {
        damage += _damageOfCoordinate(
            actor: actor,
            coordinate: c,
            pathType: pathType,
            isTerminal: isTerminal,
            triggeredTraps: triggeredTraps);
      }

      previous = current;
    }
    return damage;
  }
}
