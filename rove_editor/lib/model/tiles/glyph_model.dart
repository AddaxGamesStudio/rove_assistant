import 'dart:ui';

import 'package:rove_app_common/data/campaign_loader.dart';
import 'package:rove_editor/model/tiles/tile_model.dart';
import 'package:rove_editor/model/tiles/unit_model.dart';
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
}
