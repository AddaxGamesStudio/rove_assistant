import 'dart:async';

import 'package:rove_simulator/controller/enemy_actions/enemy_action_resolver.dart';
import 'package:rove_simulator/model/tiles/unit_model.dart';

class EnemySufferResolver extends EnemyActionResolver {
  final UnitModel target;

  EnemySufferResolver(
      {required super.game,
      required super.actor,
      required super.action,
      required this.target})
      : super(targets: [target]);

  @override
  Future<bool> execute() async {
    final completer = Completer<bool>();
    mapController.suffer(
        actor: actor,
        target: target,
        amount: actor.resolveAmountForAction(action),
        onComplete: () {
          completer.complete(true);
        });
    return completer.future;
  }
}
