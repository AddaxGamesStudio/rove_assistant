import 'package:flutter/material.dart';
import 'package:rove_editor/model/tiles/tile_model.dart';
import 'package:rove_editor/model/tiles/unit_model.dart';
import 'package:rove_data_types/rove_data_types.dart';

class FeatureModel extends TileModel {
  @override
  final String name;
  late final int _id;

  FeatureModel({required this.name, required super.coordinate}) {
    _id = ++TileModel.instanceCount;
  }

  @override
  String get key => 'feature.$name.$_id';

  @override
  Color get color => Colors.black;

  @override
  bool get isImperviousToDangerousTerrain => true;
  @override
  bool get ignoresDifficultTerrain => true;
  @override
  bool get immuneToForcedMovement => true;

  @override
  bool get isSlain => false;

  @override
  UnitModel? get owner => null;

  PlacementDef toPlacement() {
    final evenQ = coordinate.toEvenQ();
    return PlacementDef(
      name: name,
      type: PlacementType.feature,
      c: evenQ.q,
      r: evenQ.r,
    );
  }
}
