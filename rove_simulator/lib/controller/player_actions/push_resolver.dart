import 'dart:math' hide log;

import 'package:rove_simulator/controller/player_action_resolver.dart';
import 'package:rove_simulator/model/encounter_log.dart';
import 'package:rove_simulator/model/path_type.dart';
import 'package:rove_simulator/model/tiles/unit_model.dart';
import 'package:hex_grid/hex_grid.dart';

@Deprecated('Use PushPullResolver instead')
class PushResolver extends PlayerActionResolver {
  final UnitModel unitTarget;

  PushResolver(
      {super.actor,
      required super.cardResolver,
      required super.action,
      required this.unitTarget})
      : super(target: unitTarget);

  int _pushDistanceForCoordinate(HexCoordinate coordinate) {
    final distanceFromActorToTarget =
        mapModel.distance(actorCoordinate, targetCoordinate);
    final distanceToActor = mapModel.distance(actorCoordinate, coordinate);
    final distanceFromTargetToCoordinate =
        mapModel.distance(targetCoordinate, coordinate);
    final pushDistance = distanceToActor - distanceFromActorToTarget;
    return distanceFromTargetToCoordinate <= pushDistance ? pushDistance : 0;
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
    final pushDistance = _pushDistanceForCoordinate(coordinate);
    if (pushDistance <= 0 || pushDistance > amount) {
      return '';
    }
    final path = mapModel.path(
        actor: actor,
        target: unitTarget,
        from: targetCoordinate,
        to: coordinate,
        pathType: pathType);
    return path.isNotEmpty ? pushDistance.toString() : '';
  }

  @override
  String get instruction => 'Select Push Direction';

  PathType get pathType => PathType.push;
  int get amount => max(action.amount - unitTarget.reducePushPullBy, 0);

  @override
  bool isSelectableAtCoordinate(HexCoordinate coordinate) {
    final selectable = _isSelectableAtCoordinate(coordinate);
    // If the path is empty then the coordinate must be a push stopper
    return selectable &&
        (path.isNotEmpty ||
            mapModel.isPushStopperAtCoordinate(coordinate, target: unitTarget));
  }

  bool _isSelectableAtCoordinate(HexCoordinate coordinate,
      {bool pathing = false}) {
    if (coordinate == targetCoordinate &&
        mapModel.isPushStopperAtCoordinate(coordinate, target: unitTarget)) {
      return true;
    }

    final pushDistance = _pushDistanceForCoordinate(coordinate);
    if (pushDistance <= 0 || pushDistance > amount) {
      return false;
    }

    final isStopper =
        mapModel.isPushStopperAtCoordinate(coordinate, target: unitTarget);
    final hasPath = _hasViablePathForCoordinate(coordinate);
    if (pushDistance == amount) {
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
        ? mapModel.distance(actorCoordinate, coordinate)
        : mapModel.distance(path.last, coordinate);
  }

  _updatePath(HexCoordinate coordinate) {
    final distance = mapModel.distance(actorCoordinate, coordinate);
    if (distance == 0) {
      path.clear();
      return;
    }
    if (path.isNotEmpty && path.last == coordinate) {
      return;
    }
    var pathEffort = path.length;
    var distanceFromLast = _distanceFromLast(coordinate);
    var pushDistance = _pushDistanceForCoordinate(coordinate);
    var pushDistanceForLast =
        path.isEmpty ? 0 : _pushDistanceForCoordinate(path.last);

    while (path.isNotEmpty &&
        (amount <= pathEffort ||
            distanceFromLast > 1 ||
            pushDistance <= pushDistanceForLast ||
            mapModel.isPushStopperAtCoordinate(path.last,
                target: unitTarget))) {
      path.removeLast();
      pathEffort = path.length;
      distanceFromLast = _distanceFromLast(coordinate);
      pushDistanceForLast =
          path.isEmpty ? 0 : _pushDistanceForCoordinate(path.last);
    }
    if (path.isEmpty && distanceFromLast > 1) {
      final newPath = mapModel.path(
          actor: actor,
          target: unitTarget,
          from: targetCoordinate,
          to: coordinate,
          pathType: pathType);
      path.addAll(newPath);
    } else if (path.isNotEmpty &&
        (mapModel.canOccupy(actor: actor, coordinate: coordinate) ||
            (!mapModel.isPushStopperAtCoordinate(coordinate,
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

  _resolvePush() async {
    await mapController.push(
        actor: actor, target: unitTarget, path: path, amount: amount);
    didResolve();
  }

  @override
  bool onSelectedCoordinate(HexCoordinate coordinate) {
    if (!isSelectableAtCoordinate(coordinate)) {
      return false;
    }
    _resolvePush();
    return true;
  }

  @override
  Future<bool> resolve() async {
    if (unitTarget.immuneToForcedMovement) {
      log.addRecord(actor,
          'Skipped push because ${EncounterLogEntry.targetKeyword} is immune to forced movement.',
          target: target);
      return false;
    } else if (amount == 0) {
      log.addRecord(actor,
          'Skipped push because ${EncounterLogEntry.targetKeyword} reduced it to 0.',
          target: target);
      return false;
    }
    return super.resolve();
  }
}
