import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:rove_app_common/style/rove_palette.dart';
import 'package:rove_editor/editor_assets.dart';
import 'package:rove_data_types/rove_data_types.dart';

Paint _dangerousPaint = Paint()
  ..color = RovePalette.terrainDangerous.withValues(alpha: 0.5);
Paint _barrierPaint = Paint()
  ..color = RovePalette.terrainBarrier.withValues(alpha: 0.5);
Paint _difficultPaint = Paint()
  ..color = RovePalette.terrainDifficult.withValues(alpha: 0.5);
Paint _objectPaint = Paint()
  ..color = RovePalette.terrainObject.withValues(alpha: 0.5);
Paint _openAirPaint = Paint()
  ..color = RovePalette.terrainOpenAir.withValues(alpha: 0.5);
Paint _unplayablePlaint = Paint()
  ..color = RovePalette.terrainUnplayable.withValues(alpha: 0.5);

extension TerrainTypeExtension on TerrainType {
  Paint? get fillPaint {
    switch (this) {
      case TerrainType.normal:
        return null;
      case TerrainType.dangerous:
        return _dangerousPaint;
      case TerrainType.difficult:
        return _difficultPaint;
      case TerrainType.object:
        return _objectPaint;
      case TerrainType.start:
        return null;
      case TerrainType.exit:
        return null;
      case TerrainType.openAir:
        return _openAirPaint;
      case TerrainType.unplayable:
        return _unplayablePlaint;
      case TerrainType.barrier:
        return _barrierPaint;
    }
  }

  Color get color {
    switch (this) {
      case TerrainType.normal:
        return Colors.transparent;
      case TerrainType.dangerous:
        return RovePalette.terrainDangerous;
      case TerrainType.difficult:
        return RovePalette.terrainDifficult;
      case TerrainType.object:
        return RovePalette.terrainObject;
      case TerrainType.start:
        return Colors.transparent;
      case TerrainType.exit:
        return Colors.transparent;
      case TerrainType.openAir:
        return RovePalette.terrainOpenAir;
      case TerrainType.barrier:
        return RovePalette.terrainBarrier;
      case TerrainType.unplayable:
        return RovePalette.terrainUnplayable;
    }
  }

  Sprite? get iconSprite {
    switch (this) {
      case TerrainType.barrier:
      case TerrainType.normal:
      case TerrainType.dangerous:
      case TerrainType.difficult:
      case TerrainType.object:
      case TerrainType.openAir:
      case TerrainType.unplayable:
        return null;
      case TerrainType.start:
        return Assets.iconStart;
      case TerrainType.exit:
        return Assets.iconExit;
    }
  }
}
