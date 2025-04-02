import 'dart:ui';

import 'package:flutter/material.dart' as material;
import 'package:rove_editor/editor_assets.dart';
import 'package:rove_editor/model/editable_map_model.dart';
import 'package:rove_editor/model/tiles/object_def.dart';
import 'package:rove_editor/model/tiles/tile_model.dart';
import 'package:rove_editor/model/tiles/unit_model.dart';
import 'package:rove_data_types/rove_data_types.dart';

class ObjectModel extends TileModel with Slayable {
  final ObjectDef definition;
  final EditableMapModel map;
  late int _id;

  ObjectModel(
      {required this.definition,
      required super.coordinate,
      required this.map}) {
    _id = ++TileModel.instanceCount;
    maxHealth = definition.resolveMaxHealth();
    health = maxHealth;
  }

  String get className => definition.className;

  @override
  String get key => 'object.$name.$_id';

  @override
  List<RoveGlyph> get affectingGlyphs {
    final glyph = map.glyphs[coordinate];
    if (glyph != null && glyph.matches(this)) {
      return [glyph.glyph];
    }
    return [];
  }

  @override
  Color get color => material.Colors.yellow;

  @override
  int get maxHealth => definition.resolveMaxHealth();

  @override
  bool get ignoresDifficultTerrain => false;

  @override
  bool get isImperviousToDangerousTerrain => false;

  @override
  bool get immuneToForcedMovement => true;

  @override
  int get reducePushPullBy => 0;

  @override
  String get name => definition.name;

  @override
  onAttackResolved() {}

  @override
  UnitModel? get owner => null;

  @override
  List<EncounterAction> get onSlayed => definition.onSlayed;

  @override
  List<EncounterAction> get onDidStartRound => definition.onDidStartRound;

  @override
  List<EncounterAction> get onWillEndRound => definition.onWillEndRound;

  Image get image => Assets.campaignImages
      .entityImage(definition.imageFilename, expansion: definition.expansion);

  bool get canBeSlain => maxHealth > 0;

  List<EncounterAction> get onLoot => definition.onLoot;

  PlacementDef toPlacement() {
    final evenQ = coordinate.toEvenQ();
    return PlacementDef(
      name: className,
      type: PlacementType.object,
      c: evenQ.q,
      r: evenQ.r,
    );
  }
}
