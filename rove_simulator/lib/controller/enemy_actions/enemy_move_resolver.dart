import 'dart:async';

import 'package:rove_data_types/rove_data_types.dart';
import 'package:rove_simulator/controller/enemy_actions/enemy_action_resolver.dart';
import 'package:rove_simulator/controller/enemy_ai.dart';
import 'package:rove_simulator/model/tiles/unit_model.dart';
import 'package:hex_grid/hex_grid.dart';

class EnemyMoveResolver extends EnemyActionResolver {
  late HexCoordinate targetCoordinate;
  final UnitModel target;

  EnemyMoveResolver(
      {required super.game,
      required super.actor,
      required this.target,
      required HexCoordinate? targetCoordinate,
      required super.action})
      : super(targets: [target]) {
    this.targetCoordinate = targetCoordinate ?? target.coordinate;
  }

  @override
  String? debugStringForCoordinate(HexCoordinate coordinate) {
    final path = mapModel.path(
        actor: actor,
        target: actor,
        from: actorCoordinate,
        to: coordinate,
        pathType: action.pathTypeForEnemyRouting);
    return mapModel
        .effortOfPath(
            actor: actor,
            start: actorCoordinate,
            path: path,
            pathType: action.pathTypeForEnemyRouting)
        .toString();
  }

  @override
  Future<bool> execute() async {
    assert(mapModel.units[targetCoordinate] == null ||
        mapModel.units[targetCoordinate] == actor);
    if (actor.coordinate == targetCoordinate) {
      log.addRecord(actor, 'Skipping move');
      return false;
    }
    final path = mapModel.path(
        actor: actor,
        target: actor,
        from: actorCoordinate,
        to: targetCoordinate,
        pathType: action.pathTypeForEnemyRouting);
    assert(path.isNotEmpty);
    var validPath = <HexCoordinate>[];
    var subpath = <HexCoordinate>[];
    var effort = 0;
    final amount = actor.resolveAmountForAction(action);
    while (effort <= amount) {
      validPath = subpath.toList();
      if (subpath.length == path.length) {
        break;
      }
      subpath = path.getRange(0, subpath.length + 1).toList();
      effort = mapModel.effortOfPath(
          actor: actor,
          start: actorCoordinate,
          path: subpath,
          pathType: action.pathTypeForEnemyExecution);
    }
    actor.setVariable(
        RoveActionXDefinition.previousMovementEffort.toJson(), effort);
    assert(mapModel.canOccupy(actor: actor, coordinate: path.last));
    await mapController.move(
        actor: actor,
        target: actor,
        path: validPath,
        pathType: action.pathTypeForEnemyExecution);
    return true;
  }
}
