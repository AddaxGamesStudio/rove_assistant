import 'package:rove_simulator/controller/player_action_resolver.dart';
import 'package:rove_simulator/model/path_type.dart';
import 'package:rove_simulator/model/tiles/player_unit_model.dart';
import 'package:rove_simulator/model/tiles/tile_model.dart';
import 'package:hex_grid/hex_grid.dart';
import 'package:rove_data_types/rove_data_types.dart';

class MoveResolver extends PlayerActionResolver {
  MoveResolver(
      {super.actor,
      required super.cardResolver,
      required TileModel target,
      required super.action})
      : super(target: target);

  bool get ignoreTerrainEffects =>
      action.modifiers.contains(IgnoreTerrainEffectsModifier());

  PathType get pathType {
    switch (action.type) {
      case RoveActionType.forceMove:
      case RoveActionType.move:
        return ignoreTerrainEffects
            ? PathType.dashIgnoringTerrainEffects
            : PathType.dash;
      case RoveActionType.jump:
        return PathType.jump;
      default:
        throw UnimplementedError();
    }
  }

  @override
  String debugStringForCoordinate(HexCoordinate coordinate) {
    if (coordinate.distanceTo(targetCoordinate) > action.amount) {
      return '';
    }
    final path = mapModel.path(
        actor: actor,
        target: target!,
        from: targetCoordinate,
        to: coordinate,
        pathType: pathType);
    final effort = mapModel.effortOfPath(
        actor: target, start: targetCoordinate, path: path);
    return effort > 0 ? (effort <= action.amount ? effort.toString() : '') : '';
  }

  @override
  String get instruction => '';

  @override
  bool get isSkippable => true;

  @override
  bool isSelectableAtCoordinate(HexCoordinate coordinate) {
    final distance = mapModel.pathDistance(
        actor: target,
        from: targetCoordinate,
        to: coordinate,
        pathType: pathType);
    if (distance == null) {
      return false;
    }
    if (coordinate == targetCoordinate) {
      return false;
    }

    if (distance > action.amount) {
      return false;
    }

    final isDestination = distance == action.amount;
    if (isDestination) {
      return mapModel.canOccupy(actor: target, coordinate: coordinate);
    }

    return mapModel.isPassable(
        actor: target, coordinate: coordinate, pathType: pathType);
  }

  resolveSelection(HexCoordinate coordinate, Function(int)? onComplete) async {
    assert(path.toSet().length == path.length);
    final pathEffort = mapModel.effortOfPath(
        actor: target, start: targetCoordinate, path: path, pathType: pathType);
    if (pathEffort > action.amount) {
      return;
    }
    await mapController.move(
        actor: actor, target: target!, path: path.toList(), pathType: pathType);
    onComplete?.call(pathEffort);
  }

  int _distanceFromLast(HexCoordinate coordinate) {
    return path.isEmpty
        ? mapModel.distance(targetCoordinate, coordinate)
        : mapModel.distance(path.last, coordinate);
  }

  updatePath(HexCoordinate coordinate) {
    final moveDistance = mapModel.pathDistance(
        actor: target,
        from: targetCoordinate,
        to: coordinate,
        pathType: pathType)!;
    if (moveDistance == 0) {
      path.clear();
      return;
    }
    if (path.contains(coordinate)) {
      path.removeRange(path.indexOf(coordinate) + 1, path.length);
      return;
    }
    var pathEffort = mapModel.effortOfPath(
        actor: target, start: targetCoordinate, path: path);
    var distanceFromLast = _distanceFromLast(coordinate);
    while ((action.amount <= pathEffort || distanceFromLast > 1) &&
        path.isNotEmpty) {
      path.removeLast();
      pathEffort = mapModel.effortOfPath(
          actor: target, start: targetCoordinate, path: path);
      distanceFromLast = _distanceFromLast(coordinate);
    }
    if (path.isEmpty && distanceFromLast > 1) {
      final newPath = mapModel.path(
          actor: actor,
          target: target!,
          from: targetCoordinate,
          to: coordinate,
          pathType: pathType);
      path.addAll(newPath);
      assert(path.toSet().length == path.length);
    } else {
      path.add(coordinate);
      assert(path.toSet().length == path.length);
    }
  }

  @override
  bool onHoveredCoordinate(HexCoordinate coordinate) {
    if (coordinate == targetCoordinate) {
      // Reset path on hover over self
      path.clear();
      return false;
    }
    if (!isSelectableAtCoordinate(coordinate)) {
      return false;
    }
    updatePath(coordinate);
    return true;
  }

  bool hasLootableEtherNodeAtCoordinate(HexCoordinate coordinate) {
    if (target is! PlayerUnitModel) {
      return false;
    }
    final etherNode = mapModel.etherNodes[coordinate];
    if (etherNode == null) {
      return false;
    }
    return etherNode.coordinate.distanceTo(targetCoordinate) == 1;
  }

  @override
  bool onSelectedCoordinate(HexCoordinate coordinate) {
    if (hasLootableEtherNodeAtCoordinate(coordinate)) {
      mapController
          .lootEtherNode(
              actor: target as PlayerUnitModel,
              etherNode: mapModel.etherNodes[coordinate]!)
          .then((_) {
        if (action.amount == 1) {
          didResolve();
        } else {
          action = action.withAmount(action.amount - 1);
        }
      });
      return true;
    }

    if (!isSelectableAtCoordinate(coordinate)) {
      return false;
    }

    if (!mapModel.canOccupy(actor: target, coordinate: coordinate)) {
      return false;
    }

    resolveSelection(coordinate, (effort) {
      if (effort == action.amount) {
        didResolve();
      } else {
        path.clear();
        action = action.withAmount(action.amount - effort);
        modifiedGameState = true;
        notifyListeners();
      }
    });
    return true;
  }
}
