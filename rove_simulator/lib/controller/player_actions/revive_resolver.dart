import 'package:rove_simulator/controller/player_action_resolver.dart';
import 'package:rove_simulator/model/tiles/player_unit_model.dart';
import 'package:rove_simulator/model/tiles/unit_model.dart';
import 'package:rove_data_types/rove_data_types.dart';

class ReviveResolver extends PlayerActionResolver {
  final UnitModel unitTarget;

  ReviveResolver(
      {required super.cardResolver,
      required super.action,
      required this.unitTarget})
      : assert(action.type == RoveActionType.revive),
        assert(action.amount > 0),
        assert(unitTarget is PlayerUnitModel && unitTarget.isDowned),
        super(target: unitTarget);

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
  bool get resolvesWithoutUserInput => true;
}
