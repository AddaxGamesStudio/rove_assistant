import 'package:rove_simulator/controller/player_action_resolver.dart';
import 'package:rove_simulator/model/tiles/summon_model.dart';
import 'package:hex_grid/hex_grid.dart';
import 'package:rove_data_types/rove_data_types.dart';

class SummonResolver extends PlayerActionResolver {
  late SummonDef _summon;

  SummonResolver({required super.cardResolver, required super.action}) {
    assert(action.object != null);
    _summon = player.summonDefinitionForName(action.object!)!;
  }

  @override
  String get instruction => 'Select Summon Destination';

  @override
  bool isSelectableAtCoordinate(HexCoordinate coordinate) {
    if (!isInRangeForCoordinate(coordinate, needsLineOfSight: true)) {
      return false;
    }
    final placeHolderSummon = SummonModel(
        summoner: player,
        summon: _summon,
        coordinate: coordinate,
        map: mapModel);
    return mapModel.canOccupy(
            actor: placeHolderSummon, coordinate: coordinate) ||
        mapModel.units[coordinate]?.className == _summon.name;
  }

  @override
  bool onSelectedCoordinate(HexCoordinate coordinate) {
    if (!isSelectableAtCoordinate(coordinate)) {
      return false;
    }

    mapController.addSummon(_summon, coordinate: coordinate, player: player);
    didResolve();

    return true;
  }
}
