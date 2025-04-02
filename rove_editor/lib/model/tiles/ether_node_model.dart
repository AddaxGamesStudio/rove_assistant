import 'dart:ui';

import 'package:rove_editor/model/tiles/tile_model.dart';
import 'package:rove_editor/model/tiles/unit_model.dart';
import 'package:rove_data_types/rove_data_types.dart';

class EtherNodeModel extends TileModel {
  late final Ether ether;
  late final int _id;

  EtherNodeModel({required this.ether, required super.coordinate}) {
    _id = ++TileModel.instanceCount;
  }

  @override
  String get key => 'ether.${ether.name}.$_id';

  int endTurnDamageForUnit(UnitModel unit) {
    switch (ether) {
      case Ether.fire:
        return 1;
      default:
        return 0;
    }
  }

  int endTurnHealForUnit(UnitModel unit) {
    switch (ether) {
      case Ether.earth:
        return 1;
      default:
        return 0;
    }
  }

  @override
  Color get color => ether.color;

  @override
  bool get isImperviousToDangerousTerrain => true;
  @override
  bool get ignoresDifficultTerrain => true;
  @override
  bool get immuneToForcedMovement => true;

  @override
  String get name => '${ether.label} Node';

  @override
  bool get isSlain => false;

  @override
  UnitModel? get owner => null;

  PlacementDef toPlacement() {
    final evenQ = coordinate.toEvenQ();
    return PlacementDef(
      name: ether.name,
      type: PlacementType.ether,
      c: evenQ.q,
      r: evenQ.r,
    );
  }
}
