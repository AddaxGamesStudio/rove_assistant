import 'dart:async';

import 'package:collection/collection.dart';
import 'package:rove_simulator/controller/enemy_actions/enemy_action_resolver.dart';
import 'package:rove_simulator/controller/enemy_ai.dart';
import 'package:rove_simulator/model/map_model.dart';
import 'package:rove_simulator/model/targeting/map_model_targeting_extension.dart';
import 'package:rove_simulator/model/tiles/unit_model.dart';
import 'package:hex_grid/hex_grid.dart';
import 'package:rove_data_types/rove_data_types.dart';

class EnemyRetreatResolver extends EnemyActionResolver {
  EnemyRetreatResolver(
      {required super.game,
      required super.actor,
      required super.targets,
      required super.action})
      : assert(action.retreat);

  @override
  Future<bool> execute() async {
    assert(targets.isNotEmpty);
    final destination = mapModel.farthestCoordinateFromTargets(
        actor: actor, targets: targets, movementAction: action);
    final path = mapModel.path(
        actor: actor,
        target: actor,
        from: actorCoordinate,
        to: destination,
        pathType: action.pathTypeForEnemyExecution);
    if (path.isEmpty) {
      assert(actor.coordinate == destination);
      return true;
    }
    assert(mapModel.canOccupy(actor: actor, coordinate: path.last));
    await mapController.move(
        actor: actor,
        target: actor,
        path: path,
        pathType: action.pathTypeForEnemyExecution);
    return true;
  }
}

extension EnemyRetreatResolverExtension on MapModel {
  HexCoordinate farthestCoordinateFromTargets(
      {required UnitModel actor,
      required List<UnitModel> targets,
      required RoveAction movementAction}) {
    int distanceToTargets(HexCoordinate coordinate) {
      return targets
          .map((t) => actor.distanceToTarget(t, origin: coordinate))
          .reduce((value, element) => value + element);
    }

    final amount = actor.resolveAmountForAction(movementAction);
    var candidateCoordinates =
        occupableCoordinatesByMoving(actor: actor, distance: amount).toList();
    final startingDistance = distanceToTargets(actor.coordinate);
    // Prune coordinates that don't move us away from the targets
    candidateCoordinates = candidateCoordinates
        .where((c) => distanceToTargets(c) > startingDistance)
        .toList();
    var effortData = candidateCoordinates
        .map((c) {
          final aiEffort = pathDistance(
              actor: actor,
              from: actor.coordinate,
              to: c,
              pathType: movementAction.pathTypeForEnemyRouting);
          final realEffort = pathDistance(
              actor: actor,
              from: actor.coordinate,
              to: c,
              pathType: movementAction.pathTypeForEnemyExecution);
          return (c, aiEffort, realEffort);
        })
        .where((d) => d.$2 != null && d.$3 != null)
        .map((d) => (d.$1, d.$2!, d.$3!))
        .toList();
    // Prune coordinates that are beyond our effort
    effortData = effortData.where((d) => d.$3 <= amount).toList();
    if (effortData.isEmpty) {
      return actor.coordinate;
    }
    // SEED: Randomize possible destinations
    var data = effortData
        .map((d) => (d.$1, d.$2, distanceToTargets(d.$1)))
        .sorted((a, b) {
      // Sort by descending distance, ascending AI effort
      if (a.$3 == b.$3) {
        return a.$2.compareTo(b.$2);
      }
      return b.$3.compareTo(a.$3);
    });
    return data.first.$1;
  }
}
