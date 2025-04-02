import 'package:rove_simulator/controller/player_actions/attack_resolver.dart';
import 'package:rove_simulator/model/tiles/unit_model.dart';
import 'package:hex_grid/hex_grid.dart';

class ForceAttackResolver extends BaseAttackResolver {
  final UnitModel forcedActor;
  UnitModel? _selectedTarget;

  ForceAttackResolver(
      {required super.cardResolver,
      required super.action,
      required this.forcedActor});

  @override
  UnitModel get actor => forcedActor;

  @override
  UnitModel? get unitTarget => _selectedTarget;

  @override
  HexCoordinate get fieldCoordinate => actor.coordinate;

  @override
  HexCoordinate get targetCoordinate => unitTarget!.coordinate;

  @override
  String get instruction => 'Select Ally of Forced Enemy';

  @override
  bool isSelectableAtCoordinate(HexCoordinate coordinate) {
    final distance = forcedActor.distanceToCoordinate(coordinate);
    if (distance != 1) {
      return false;
    }

    return mapModel.hasAllyAtCoordinate(forcedActor, coordinate);
  }

  @override
  bool onSelectedCoordinate(HexCoordinate coordinate) {
    if (!isSelectableAtCoordinate(coordinate)) {
      return false;
    }

    _selectedTarget = mapModel.units[coordinate];
    selectedCoordinate = coordinate;

    attack();
    return true;
  }
}
