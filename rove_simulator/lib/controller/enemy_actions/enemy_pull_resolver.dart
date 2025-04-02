import 'dart:async';

import 'package:rove_simulator/controller/enemy_actions/enemy_action_resolver.dart';
import 'package:rove_simulator/controller/enemy_actions/enemy_push_resolver.dart';
import 'package:rove_simulator/model/encounter_log.dart';
import 'package:rove_simulator/model/path_type.dart';
import 'package:rove_simulator/model/tiles/unit_model.dart';
import 'package:hex_grid/hex_grid.dart';
import 'package:rove_data_types/rove_data_types.dart';

class EnemyPullResolver extends EnemyActionResolver
    with FindPullPushPathCausingMostDamage {
  EnemyPullResolver(
      {required super.game,
      required super.actor,
      required UnitModel target,
      required super.action})
      : super(targets: [target]);

  Completer<bool> completer = Completer();

  int get amount => action.type == RoveActionType.push
      ? actor.resolveAmountForAction(action)
      : action.pull;

  @override
  Future<bool> execute() async {
    assert(amount > 0);
    final target = targets.first;
    if (target.immuneToForcedMovement) {
      log.addRecord(actor,
          'Skipped pull because ${EncounterLogEntry.targetKeyword} is immune to forced movement.',
          target: target);
      return false;
    }

    final List<HexCoordinate> validDestinations =
        _validPullDestinations(target);

    if (validDestinations.isEmpty) {
      log.addRecord(actor, 'Skipped pull due to no viable direction');
      return false;
    }

    final List<HexCoordinate> path = findPathCausingMostDamage(
        destinations: validDestinations,
        amount: amount,
        pathType: PathType.pull);

    await mapController.pull(
        actor: actor, target: target, amount: amount, path: path);
    return true;
  }

  List<HexCoordinate> _validPullDestinations(UnitModel target) {
    final coordinates = mapModel
        .coordinatesWithinRange(
            center: target.coordinate,
            range: (1, amount),
            needsLineOfSight: false)
        .toList();
    final distanceToActor = actor.distanceToTarget(target);
    final pushCoordinates = coordinates
        .where((c) => actor.distanceToCoordinate(c) < distanceToActor)
        .toList();
    final validDestinations = pushCoordinates.where((c) {
      final path = mapModel.path(
          actor: actor,
          target: target,
          from: target.coordinate,
          to: c,
          pathType: PathType.pull);
      if (mapModel.isPullStopperAtCoordinate(c, target: target)) {
        return path.isNotEmpty;
      } else {
        return path.length == amount &&
            mapModel.canOccupy(actor: target, coordinate: c);
      }
    }).toList();
    return validDestinations;
  }
}
