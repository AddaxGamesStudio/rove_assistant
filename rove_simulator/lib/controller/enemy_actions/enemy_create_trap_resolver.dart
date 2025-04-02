import 'dart:async';

import 'package:rove_simulator/controller/enemy_actions/enemy_action_resolver.dart';
import 'package:rove_simulator/model/tiles/trap_model.dart';
import 'package:rove_simulator/model/tiles/unit_model.dart';
import 'package:hex_grid/hex_grid.dart';

class EnemyCreateTrapResolver extends EnemyActionResolver {
  EnemyCreateTrapResolver(
      {required super.game, required super.actor, required super.action})
      : super(targets: []);

  Completer<bool> completer = Completer();

  @override
  Future<bool> execute() async {
    final UnitModel target = _findClosestTarget();

    final viableCoordinates = mapModel
        .coordinatesWithinRangeOfTarget(
            target: actor, range: action.range, needsLineOfSight: true)
        .where((c) => mapModel.canPlaceTrap(c))
        .toList();
    if (viableCoordinates.isEmpty) {
      log.addRecord(actor,
          'Skipped create trap due to no empty coordinates within range');
      return false;
    }
    final HexCoordinate coordinate =
        _findClosestCoordinateToTarget(target, viableCoordinates);

    final trap = TrapModel(
        damage: actor.resolveAmountForAction(action),
        creator: actor,
        coordinate: coordinate);
    mapController.addTrap(trap, coordinate: coordinate, actor: actor);
    return true;
  }

  UnitModel _findClosestTarget() {
    final enemies =
        mapModel.targetableUnits.where((u) => u.isEnemyToUnit(actor)).toList();
    var unitsAnDistance =
        enemies.map((u) => (u, actor.distanceToTarget(u))).toList();
    unitsAnDistance.sort((a, b) => b.$1.health.compareTo(a.$1.health));
    unitsAnDistance.sort((a, b) => a.$2.compareTo(b.$2));
    return unitsAnDistance.first.$1;
  }

  HexCoordinate _findClosestCoordinateToTarget(
      UnitModel target, List<HexCoordinate> coordinates) {
    final coordinatesWithDistanceToTarget =
        coordinates.map((c) => (c, target.distanceToCoordinate(c))).toList();
    coordinatesWithDistanceToTarget.sort((a, b) => a.$2.compareTo(b.$2));
    final coordinate = coordinatesWithDistanceToTarget.first.$1;
    return coordinate;
  }
}
