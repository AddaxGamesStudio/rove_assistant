import 'package:rove_simulator/controller/player_action_resolver.dart';
import 'package:rove_simulator/model/tiles/trap_model.dart';
import 'package:hex_grid/hex_grid.dart';

class CreateTrapResolver extends PlayerActionResolver {
  CreateTrapResolver({required super.cardResolver, required super.action});

  @override
  String get instruction => 'Select Trap Destination';

  @override
  bool isSelectableAtCoordinate(HexCoordinate coordinate) {
    if (!isInRangeForCoordinate(coordinate, needsLineOfSight: true)) {
      return false;
    }
    return mapModel.canPlaceTrap(coordinate) ||
        mapModel.trapAtCoordinate(coordinate) != null;
  }

  @override
  bool onSelectedCoordinate(HexCoordinate coordinate) {
    if (!isSelectableAtCoordinate(coordinate)) {
      return false;
    }

    final trap = TrapModel(
        damage: action.amount, creator: actor.owner!, coordinate: coordinate);
    mapController.addTrap(trap, coordinate: coordinate, actor: actor.owner!);
    didResolve();

    return true;
  }
}
