import 'dart:async';

import 'package:rove_simulator/controller/enemy_actions/enemy_action_resolver.dart';
import 'package:rove_simulator/model/tiles/unit_model.dart';

class EnemySingleTargetHealResolver extends EnemyActionResolver {
  EnemySingleTargetHealResolver(
      {required super.game,
      required super.actor,
      required UnitModel target,
      super.targetAOE,
      required super.action})
      : super(targets: [target]);

  @override
  Future<bool> execute() async {
    final target = targets.first;

    if (actor.isSlain || target.isSlain) {
      return false;
    }

    if (!isInRangeForTarget(target: target, needsLineOfSight: true)) {
      log.addRecord(actor,
          'Target is no longer in range; skipping ${action.shortDescription}');
      return false;
    }

    await mapController.healUnit(
        actor: actor,
        target: targets.first,
        amount: actor.resolveAmountForAction(action));

    if (action.field != null) {
      mapController.addField(action.field!,
          creator: actor.owner!,
          coordinate: actor.closestCoordinateOfTarget(target,
              origin: actor.coordinate));
    }

    return true;
  }

  static List<UnitModel> selectTargetsOrActor(
      {required UnitModel actor,
      required int count,
      required List<UnitModel> candidates}) {
    List<UnitModel> targets = [];

    while (targets.length < count && candidates.isNotEmpty) {
      final candidate = candidates[0];
      if (candidate.damage > 0 || targets.contains(actor)) {
        targets.add(candidate);
        candidates.removeAt(0);
        if (candidates.isEmpty && targets.length < count) {
          targets.add(actor);
        }
      } else {
        targets.add(actor);
      }
    }
    return targets;
  }
}
