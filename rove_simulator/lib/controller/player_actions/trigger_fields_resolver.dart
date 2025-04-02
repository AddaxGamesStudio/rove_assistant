import 'package:rove_data_types/rove_data_types.dart';
import 'package:rove_simulator/controller/player_action_resolver.dart';
import 'package:rove_simulator/model/tiles/field_model.dart';

class TriggerFieldsResolver extends PlayerActionResolver {
  TriggerFieldsResolver({required super.cardResolver, required super.action})
      : super();

  @override
  bool get resolvesWithoutUserInput => true;

  _triggerField(FieldModel field) async {
    final unit = mapModel.units[field.coordinate];
    if (unit == null) {
      return;
    }
    final healAmount = field.endTurnHealForUnit(unit);
    if (healAmount > 0) {
      await mapController.healUnit(
          actor: actor, target: unit, amount: healAmount);
    }
    final damageAmount = field.startTurnDamageForUnit(unit);
    if (damageAmount > 0) {
      await mapController.suffer(
          actor: actor, target: unit, amount: damageAmount);
    }
  }

  @override
  Future<bool> resolve() async {
    assert(action.field != null);
    assert(action.field == EtherField.everbloom ||
        action.field == EtherField.wildfire);
    final fields = mapModel.fields.values
        .where((f) => f.field == action.field)
        .where((f) =>
            isInRangeForCoordinate(f.coordinate, needsLineOfSight: false));
    for (final field in fields) {
      await _triggerField(field);
    }
    return true;
  }
}
