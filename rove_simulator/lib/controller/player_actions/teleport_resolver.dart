import 'package:rove_simulator/controller/player_action_resolver.dart';
import 'package:rove_simulator/model/tiles/unit_model.dart';
import 'package:hex_grid/hex_grid.dart';

class TeleportResolver extends PlayerActionResolver {
  TeleportResolver({required super.cardResolver, required super.action});

  @override
  String get instruction => 'Select ${action.shortDescription} Destination';

  @override
  bool isSelectableAtCoordinate(HexCoordinate coordinate) {
    if (actorCoordinate.distanceTo(coordinate) > action.amount) {
      return false;
    }

    return mapModel.canOccupy(actor: actor, coordinate: coordinate);
  }

  _resolveTeleportToCoordinate(HexCoordinate coordinate) async {
    await mapController.teleport(actor: actor as UnitModel, to: coordinate);
    didResolve();
  }

  @override
  bool onSelectedCoordinate(HexCoordinate coordinate) {
    if (!isSelectableAtCoordinate(coordinate)) {
      return false;
    }
    _resolveTeleportToCoordinate(coordinate);
    return true;
  }
}
