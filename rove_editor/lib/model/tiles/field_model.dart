import 'package:flutter/material.dart';
import 'package:rove_editor/model/tiles/glyph_model.dart';
import 'package:rove_editor/model/tiles/tile_model.dart';
import 'package:rove_editor/model/tiles/unit_model.dart';
import 'package:rove_data_types/rove_data_types.dart';

class FieldModel extends TileModel {
  late final EtherField field;
  late final int _id;

  FieldModel({required this.field, required super.coordinate})
      : _id = ++TileModel.instanceCount;

  @override
  String get key => 'field.${field.name}.$_id';

  int startTurnDamageForUnit(UnitModel unit) {
    switch (field) {
      case EtherField.wildfire:
        return 1;
      default:
        return 0;
    }
  }

  int endTurnHealForUnit(UnitModel unit) {
    switch (field) {
      case EtherField.everbloom:
        return 1;
      default:
        return 0;
    }
  }

  int moveEffortToExitSpaceForActor(dynamic actor) {
    switch (field) {
      case EtherField.snapfrost:
        return (actor is GlyphModel) ? 0 : 2;
      default:
        return 0;
    }
  }

  int moveEffortToEnterSpaceForActor(dynamic actor) {
    switch (field) {
      case EtherField.snapfrost:
        return (actor is GlyphModel) ? 0 : 2;
      default:
        return 0;
    }
  }

  @override
  bool get isImperviousToDangerousTerrain => true;
  @override
  bool get ignoresDifficultTerrain => true;
  @override
  bool get immuneToForcedMovement => true;

  @override
  String get name => field.label;

  @override
  bool get isSlain => false;

  @override
  Color get color => Colors.white;

  @override
  UnitModel? get owner => null;

  PlacementDef toPlacement() {
    final evenQ = coordinate.toEvenQ();
    return PlacementDef(
      name: field.name,
      type: PlacementType.field,
      c: evenQ.q,
      r: evenQ.r,
    );
  }
}
