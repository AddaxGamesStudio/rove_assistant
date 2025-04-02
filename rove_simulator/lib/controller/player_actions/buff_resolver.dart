import 'package:rove_simulator/controller/player_action_resolver.dart';
import 'package:rove_simulator/model/encounter_log.dart';
import 'package:rove_simulator/model/tiles/unit_model.dart';
import 'package:hex_grid/hex_grid.dart';

class BuffResolver extends PlayerActionResolver {
  final UnitModel unitTarget;

  BuffResolver(
      {required super.cardResolver,
      required super.action,
      required this.unitTarget})
      : super(target: unitTarget);

  @override
  bool get resolvesWithoutUserInput => true;

  @override
  bool isSelectableAtCoordinate(HexCoordinate coordinate) {
    return coordinate == unitTarget.coordinate;
  }

  @override
  Future<bool> resolve() async {
    log.addRecord(actor,
        'Buffed ${EncounterLogEntry.targetKeyword} with ${action.buffDescription}',
        target: target);
    unitTarget.buffs.add(action.toBuff!);
    return true;
  }
}
