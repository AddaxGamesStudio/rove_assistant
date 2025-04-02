import 'package:rove_simulator/controller/player_action_resolver.dart';
import 'package:hex_grid/hex_grid.dart';

class SelectRangeOriginResolver extends PlayerActionResolver {
  SelectRangeOriginResolver(
      {required super.cardResolver, required super.action})
      : assert(action.rangeOrigin.needsSelection);

  int get endRange => action.rangeOrigin.endRange ?? 0;

  HexCoordinate? selectedCoordinate;

  @override
  String get instruction => 'Select A Space Within (1, $endRange)';

  @override
  bool isSelectableAtCoordinate(HexCoordinate coordinate) {
    return actorCoordinate.distanceTo(coordinate) <= endRange;
  }

  @override
  bool onSelectedCoordinate(HexCoordinate coordinate) {
    if (!isSelectableAtCoordinate(coordinate)) {
      return false;
    }

    selectedCoordinate = coordinate;
    didResolve();
    return true;
  }
}
