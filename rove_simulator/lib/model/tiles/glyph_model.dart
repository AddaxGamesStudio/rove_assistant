import 'dart:ui';

import 'package:rove_app_common/data/campaign_loader.dart';
import 'package:rove_simulator/model/map_model.dart';
import 'package:rove_simulator/model/persistence/saveable.dart';
import 'package:rove_simulator/model/tiles/tile_model.dart';
import 'package:rove_simulator/model/tiles/unit_model.dart';
import 'package:hex_grid/hex_grid.dart';
import 'package:rove_data_types/rove_data_types.dart';

class GlyphModel extends TileModel {
  late final RoveGlyph glyph;
  late final UnitModel creator;
  late final int _id;

  GlyphModel(this.glyph, {required this.creator, required super.coordinate}) {
    _id = ++TileModel.instanceCount;
  }

  @override
  String get key => 'glyph.${glyph.name}.$_id';

  @override
  Color get color =>
      CampaignLoader.instance.campaign.getClass(className: 'Sophist').color;

  @override
  bool get isImperviousToDangerousTerrain => true;
  @override
  bool get ignoresDifficultTerrain => true;
  @override
  bool get immuneToForcedMovement => true;

  @override
  String get name => glyph.label;

  @override
  bool get isSlain => false;

  @override
  UnitModel? get owner => creator;

  @override
  bool get usesGlyphs => true;

  bool matches(Slayable target) {
    if (target is! UnitModel) {
      return false;
    }
    switch (glyph) {
      case RoveGlyph.aerios:
      case RoveGlyph.armoroll:
        return target.isAlly;
      case RoveGlyph.hyperbola:
        return target.usesGlyphs;
    }
  }

  /* Saveable */

  GlyphModel._saveData({required SaveData data, required this.creator})
      : super(coordinate: HexCoordinate.zero()) {
    initializeWithSaveData(data);
  }

  factory GlyphModel.fromSaveData(SaveData data, {required MapModel map}) {
    final creatorKey = data.properties['creator_key'];
    final creator = creatorKey != null ? map.findUnitByKey(creatorKey) : null;
    return GlyphModel._saveData(data: data, creator: creator!);
  }

  @override
  setSaveablePropertiesBeforeChildren(Map<String, dynamic> properties) {
    super.setSaveablePropertiesBeforeChildren(properties);
    _id = properties['id'] as int? ?? ++TileModel.instanceCount;
    glyph = RoveGlyph.fromName(properties['glyph']);
  }

  @override
  Map<String, dynamic> saveableProperties() {
    final properties = super.saveableProperties();
    properties.addAll({
      'id': _id,
      'glyph': glyph.name,
      'creator_key': creator.key,
    });
    return properties;
  }

  @override
  String get saveableKey => key;

  @override
  int get saveablePriority => creator.saveablePriority + 10;

  @override
  String get saveableType => 'GlyphModel';
}
