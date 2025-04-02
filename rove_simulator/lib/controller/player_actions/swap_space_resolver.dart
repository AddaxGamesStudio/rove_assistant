import 'package:rove_simulator/controller/player_action_resolver.dart';
import 'package:rove_simulator/model/encounter_log.dart';
import 'package:rove_simulator/model/tiles/tile_model.dart';

class SwapSpaceResolver extends PlayerActionResolver {
  final TileModel swapToTarget;

  SwapSpaceResolver(
      {required super.cardResolver,
      required super.action,
      required this.swapToTarget})
      : super(target: swapToTarget);

  @override
  Future<bool> resolve() async {
    if (!mapModel.canOccupy(
        actor: player, coordinate: swapToTarget.coordinate)) {
      log.addRecord(actor,
          'Skipping swap as can not occupy space of ${EncounterLogEntry.targetKeyword}',
          target: swapToTarget);
      return false;
    }
    if (!mapModel.canOccupy(
        actor: swapToTarget, coordinate: actor.coordinate)) {
      log.addRecord(actor,
          'Skipping swap as ${EncounterLogEntry.targetKeyword} can not occupy space of actor',
          target: swapToTarget);
      return false;
    }
    await mapController.swapSpaces(
        fromTile: player, toTile: target as TileModel);
    return true;
  }
}
