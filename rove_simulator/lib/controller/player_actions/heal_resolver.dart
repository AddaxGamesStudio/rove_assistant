import 'package:rove_simulator/controller/player_action_resolver.dart';
import 'package:rove_simulator/model/tiles/unit_model.dart';
import 'package:rove_data_types/rove_data_types.dart';

class HealResolver extends PlayerActionResolver {
  final UnitModel unitTarget;

  HealResolver(
      {required super.cardResolver,
      required super.action,
      required this.unitTarget})
      : super(target: unitTarget);

  @override
  Future<bool> resolve() async {
    await mapController.healUnit(
        actor: actor, target: unitTarget, amount: action.amount);

    if (action.field != null) {
      mapController.addField(action.field!,
          creator: actor.owner!, coordinate: unitTarget.coordinate);
    }
    return true;
  }

  @override
  bool get resolvesWithoutUserInput => action.targetKind == TargetKind.self;
}
