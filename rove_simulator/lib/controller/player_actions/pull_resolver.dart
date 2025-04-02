import 'dart:math' hide log;

import 'package:rove_simulator/controller/player_action_resolver.dart';
import 'package:rove_simulator/model/encounter_log.dart';
import 'package:rove_simulator/model/path_type.dart';
import 'package:rove_simulator/model/tiles/unit_model.dart';
import 'package:hex_grid/hex_grid.dart';

@Deprecated('Use PushPullResolver instead')
class PullResolver extends PlayerActionResolver {
  final UnitModel unitTarget;

  PullResolver(
      {super.actor,
      required super.cardResolver,
      required super.action,
      required this.unitTarget})
      : super(target: unitTarget);

  int _pullDistanceForCoordinate(HexCoordinate coordinate) {
    final distanceFromActorToTarget =
        mapModel.distance(actorCoordinate, targetCoordinate);
    final distanceToActor = mapModel.distance(actorCoordinate, coordinate);
    final distanceFromTargetToCoordinate =
        mapModel.distance(targetCoordinate, coordinate);
    final pullDistance = distanceFromActorToTarget - distanceToActor;
    return distanceFromTargetToCoordinate <= pullDistance ? pullDistance : 0;
  }

  bool _hasViablePathForCoordinate(HexCoordinate coordinate) {
    final path = mapModel.path(
        actor: actor,
        target: unitTarget,
        from: targetCoordinate,
        to: coordinate,
        pathType: pathType);
    return path.isNotEmpty &&
        mapModel.effortOfPath(
                actor: target, start: targetCoordinate, path: path) <=
            amount;
  }

  @override
  String debugStringForCoordinate(HexCoordinate coordinate) {
    final pullDistance = _pullDistanceForCoordinate(coordinate);
    if (pullDistance <= 0 || pullDistance > amount) {
      return '';
    }
    final path = mapModel.path(
        actor: actor,
        target: unitTarget,
        from: targetCoordinate,
        to: coordinate,
        pathType: pathType);
    return path.isNotEmpty ? pullDistance.toString() : '';
  }

  @override
  String get instruction => 'Select Pull Direction';

  PathType get pathType => PathType.pull;
  int get amount => max(action.amount - unitTarget.reducePushPullBy, 0);

  @override
  bool isSelectableAtCoordinate(HexCoordinate coordinate) {
    final selectable = _isSelectableAtCoordinate(coordinate);
    // If the path is empty then the coordinate must be a push stopper
    return selectable &&
        (path.isNotEmpty ||
            mapModel.isPullStopperAtCoordinate(coordinate, target: unitTarget));
  }

  bool _isSelectableAtCoordinate(HexCoordinate coordinate,
      {bool pathing = false}) {
    final pullDistance = _pullDistanceForCoordinate(coordinate);
    if (pullDistance <= 0 || pullDistance > amount) {
      return false;
    }

    // Is stopper with a possible pull path?
    final isStopper =
        mapModel.isPullStopperAtCoordinate(coordinate, target: unitTarget);
    final hasPath = _hasViablePathForCoordinate(coordinate);
    if (pullDistance == amount) {
      // Must end on an unoccupied space or a stopper with a valid path
      return hasPath &&
          (mapModel.canOccupy(actor: actor, coordinate: coordinate) ||
              isStopper);
    } else if (isStopper) {
      return hasPath;
    } else if (pathing) {
      return mapModel.isPassable(
          actor: actor, coordinate: coordinate, pathType: pathType);
    }
    return false;
  }

  int _distanceFromLast(HexCoordinate coordinate) {
    return path.isEmpty
        ? mapModel.distance(targetCoordinate, coordinate)
        : mapModel.distance(path.last, coordinate);
  }

  _updatePath(HexCoordinate coordinate) {
    {
      final distance = mapModel.distance(targetCoordinate, coordinate);
      if (distance == 0) {
        path.clear();
        return;
      }
    }
    if (path.isNotEmpty && path.last == coordinate) {
      return;
    }
    var pathEffort = path.length;
    var distanceFromLast = _distanceFromLast(coordinate);
    var pullDistance = _pullDistanceForCoordinate(coordinate);
    var pullDistanceForLast =
        path.isEmpty ? 0 : _pullDistanceForCoordinate(path.last);

    while (path.isNotEmpty &&
        (amount <= pathEffort ||
            distanceFromLast > 1 ||
            pullDistance <= pullDistanceForLast ||
            mapModel.isPullStopperAtCoordinate(path.last,
                target: unitTarget))) {
      path.removeLast();
      pathEffort = path.length;
      distanceFromLast = _distanceFromLast(coordinate);
      pullDistanceForLast =
          path.isEmpty ? 0 : _pullDistanceForCoordinate(path.last);
    }
    if (path.isEmpty && distanceFromLast > 1) {
      final newPath = mapModel.path(
          actor: actor,
          target: target!,
          from: targetCoordinate,
          to: coordinate,
          pathType: pathType);
      path.addAll(newPath);
    } else if (path.isNotEmpty &&
        (mapModel.canOccupy(actor: actor, coordinate: coordinate) ||
            (!mapModel.isPullStopperAtCoordinate(coordinate,
                    target: unitTarget) ||
                mapModel.canOccupy(
                    actor: unitTarget, coordinate: path.last)))) {
      // Must be able to occupy previous coordinate if adding a stopper that can't be occupied
      path.add(coordinate);
    } else {
      // Rebuild path
      path.clear();
      final newPath = mapModel.path(
          actor: actor,
          target: unitTarget,
          from: targetCoordinate,
          to: coordinate,
          pathType: pathType);
      path.addAll(newPath);
    }
  }

  @override
  bool onHoveredCoordinate(HexCoordinate coordinate) {
    if (coordinate == targetCoordinate) {
      // Reset path on hover over target
      path.clear();
      return false;
    }

    if (!_isSelectableAtCoordinate(coordinate, pathing: true)) {
      return false;
    }

    _updatePath(coordinate);
    return true;
  }

  _resolvePull() async {
    await mapController.pull(
        actor: actor, target: unitTarget, path: path, amount: amount);
    didResolve();
  }

  @override
  bool onSelectedCoordinate(HexCoordinate coordinate) {
    if (!isSelectableAtCoordinate(coordinate)) {
      return false;
    }
    _resolvePull();
    return true;
  }

  @override
  Future<bool> resolve() async {
    if (unitTarget.immuneToForcedMovement) {
      log.addRecord(actor,
          'Skipped pull because ${EncounterLogEntry.targetKeyword} is immune to forced movement.',
          target: target);
      return false;
    } else if (amount == 0) {
      log.addRecord(actor,
          'Skipped pull because ${EncounterLogEntry.targetKeyword} reduced it to 0.',
          target: target);
      return false;
    }
    return super.resolve();
  }
}
