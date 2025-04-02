import 'dart:math' hide log;

import 'package:rove_simulator/controller/player_action_resolver.dart';
import 'package:rove_simulator/model/encounter_log.dart';
import 'package:rove_simulator/model/path_type.dart';
import 'package:rove_simulator/model/tiles/unit_model.dart';
import 'package:hex_grid/hex_grid.dart';
import 'package:rove_data_types/rove_data_types.dart';

class PushPullResolver extends PlayerActionResolver {
  final UnitModel unitTarget;
  late PathType pathType;
  late bool isPush;

  PushPullResolver(
      {super.actor,
      required super.cardResolver,
      required super.action,
      required this.unitTarget,
      super.selectedRangeOrigin})
      : super(
          target: unitTarget,
        ) {
    switch (action.type) {
      case RoveActionType.push:
        pathType = PathType.push;
        isPush = true;
        break;
      case RoveActionType.pull:
        pathType = PathType.pull;
        isPush = false;
        break;
      default:
        throw UnimplementedError();
    }
  }

  int _pushPullDistanceForCoordinate(HexCoordinate coordinate) {
    final distanceFromActorToTarget = actor.distanceToTarget(unitTarget);
    final distanceToActor = actor.distanceToCoordinate(coordinate);
    final distanceFromTargetToCoordinate =
        unitTarget.distanceToCoordinate(coordinate);
    late int pushPullDistance;
    switch (action.type) {
      case RoveActionType.push:
        pushPullDistance = distanceToActor - distanceFromActorToTarget;
        break;
      case RoveActionType.pull:
        pushPullDistance = distanceFromActorToTarget - distanceToActor;
        break;
      default:
        throw UnimplementedError();
    }
    return distanceFromTargetToCoordinate <= pushPullDistance
        ? pushPullDistance
        : 0;
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
    final distance = _pushPullDistanceForCoordinate(coordinate);
    if (distance <= 0 || distance > amount) {
      return '';
    }
    final path = mapModel.path(
        actor: actor,
        target: unitTarget,
        from: targetCoordinate,
        to: coordinate,
        pathType: pathType);
    return path.isNotEmpty ? distance.toString() : '';
  }

  @override
  String get instruction => 'Select ${action.type.label} Direction';

  int get amount => max(resolvedAmount - unitTarget.reducePushPullBy, 0);

  bool isStopperAtCoordinate(HexCoordinate coordinate) {
    switch (action.type) {
      case RoveActionType.push:
        return mapModel.isPushStopperAtCoordinate(coordinate,
            target: unitTarget);
      case RoveActionType.pull:
        return mapModel.isPullStopperAtCoordinate(coordinate,
            target: unitTarget);
      default:
        throw UnimplementedError();
    }
  }

  @override
  bool isSelectableAtCoordinate(HexCoordinate coordinate) {
    final selectable = _isSelectableAtCoordinate(coordinate);
    // If the path is empty then the coordinate must be a push stopper
    return selectable && (path.isNotEmpty || isStopperAtCoordinate(coordinate));
  }

  bool _isSelectableAtCoordinate(HexCoordinate coordinate,
      {bool pathing = false}) {
    if (isPush &&
        coordinate == targetCoordinate &&
        isStopperAtCoordinate(coordinate)) {
      return true;
    }

    final distance = _pushPullDistanceForCoordinate(coordinate);
    if (distance <= 0 || distance > amount) {
      return false;
    }

    // Is stopper with a possible path?
    final isStopper = isStopperAtCoordinate(coordinate);
    final hasPath = _hasViablePathForCoordinate(coordinate);
    if (distance == amount) {
      // Must end on an unoccupied space or a stopper with a valid path
      return hasPath &&
          (mapModel.canOccupy(actor: unitTarget, coordinate: coordinate) ||
              isStopper);
    } else if (isStopper) {
      return hasPath;
    } else if (pathing) {
      return mapModel.isPassable(
          actor: target, coordinate: coordinate, pathType: pathType);
    }
    return false;
  }

  int _distanceFromLast(HexCoordinate coordinate) {
    if (path.isNotEmpty) {
      return path.last.distanceTo(coordinate);
    }
    switch (action.type) {
      case RoveActionType.push:
        return actor.distanceToCoordinate(coordinate);
      case RoveActionType.pull:
        return unitTarget.distanceToCoordinate(coordinate);
      default:
        throw UnimplementedError();
    }
  }

  _updatePath(HexCoordinate coordinate) {
    {
      late int distance;
      switch (action.type) {
        case RoveActionType.push:
          distance = actor.distanceToCoordinate(coordinate);
          break;
        case RoveActionType.pull:
          distance = unitTarget.distanceToCoordinate(coordinate);
          break;
        default:
          throw UnimplementedError();
      }
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
    var pushDistance = _pushPullDistanceForCoordinate(coordinate);
    var pushDistanceForLast =
        path.isEmpty ? 0 : _pushPullDistanceForCoordinate(path.last);

    while (path.isNotEmpty &&
        (amount <= pathEffort ||
            distanceFromLast > 1 ||
            pushDistance <= pushDistanceForLast ||
            isStopperAtCoordinate(path.last))) {
      path.removeLast();
      pathEffort = path.length;
      distanceFromLast = _distanceFromLast(coordinate);
      pushDistanceForLast =
          path.isEmpty ? 0 : _pushPullDistanceForCoordinate(path.last);
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
        (mapModel.canOccupy(actor: unitTarget, coordinate: coordinate) ||
            (!isStopperAtCoordinate(coordinate) ||
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

  _resolveAction() async {
    switch (action.type) {
      case RoveActionType.push:
        await mapController.push(
            actor: actor, target: unitTarget, path: path, amount: amount);
        break;
      case RoveActionType.pull:
        await mapController.pull(
            actor: actor, target: unitTarget, path: path, amount: amount);
        break;
      default:
        throw UnimplementedError();
    }
    final field = action.field;
    if (field != null) {
      final fieldCoordinate = unitTarget.coordinate;
      if (mapModel.canPlaceField(fieldCoordinate)) {
        mapController.addField(field,
            creator: actor.owner!, coordinate: fieldCoordinate);
      } else {
        log.addRecord(actor, 'Could not place field at $fieldCoordinate');
      }
    }
    didResolve();
  }

  @override
  bool onSelectedCoordinate(HexCoordinate coordinate) {
    if (!isSelectableAtCoordinate(coordinate)) {
      return false;
    }
    _resolveAction();
    return true;
  }

  @override
  Future<bool> resolve() async {
    if (unitTarget.immuneToForcedMovement) {
      log.addRecord(actor,
          'Skipped ${action.type.label.toLowerCase()} because ${EncounterLogEntry.targetKeyword} is immune to forced movement.',
          target: target);
      return false;
    } else if (amount == 0) {
      log.addRecord(actor,
          'Skipped ${action.type.label.toLowerCase()} because ${EncounterLogEntry.targetKeyword} reduced it to 0.',
          target: target);
      return false;
    }
    return super.resolve();
  }
}
