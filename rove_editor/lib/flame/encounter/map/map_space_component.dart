import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:rove_editor/editor_assets.dart';
import 'package:rove_editor/flame/encounter/map/map_component.dart';
import 'package:rove_editor/data/terrain_type_ext.dart';
import 'package:rove_editor/flame/encounter/hex_component.dart';
import 'package:rove_editor/flame/map_editor.dart';
import 'package:rove_editor/model/tiles/terrain_model.dart';
import 'package:rove_data_types/rove_data_types.dart';

enum FocusType {
  positive,
  neutral,
  negative;

  factory FocusType.fromPolarity(RoveActionPolarity polarity) {
    switch (polarity) {
      case RoveActionPolarity.positive:
        return FocusType.positive;
      case RoveActionPolarity.negative:
        return FocusType.negative;
      case RoveActionPolarity.neutral:
        return FocusType.neutral;
    }
  }
}

class MapSpaceComponent extends HexComponent with HasGameReference<MapEditor> {
  static final Paint _neutralFocusedTargetPaint = Paint()
    ..color = Colors.white.withValues(alpha: 0.75);
  static final Paint _negativeFocusedTargetPaint = Paint()
    ..color = Colors.red.withValues(alpha: 0.75);
  static final Paint _positiveFocusedTargetPaint = Paint()
    ..color = Colors.blue.withValues(alpha: 0.75);

  static final Paint _borderPaint = Paint()
    ..color = Colors.grey
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2;

  static final Paint _focusedBorderPaint = Paint()
    ..color = Colors.white
    ..style = PaintingStyle.stroke
    ..strokeWidth = 8;

  static final Paint _selectedBorderPaint = Paint()
    ..color = const Color(0xffdbaf58)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 8;

  final TerrainModel terrain;

  bool selected = false;
  Paint get focusedTargetPaint {
    final focusType = FocusType.neutral;
    switch (focusType) {
      case FocusType.positive:
        return _positiveFocusedTargetPaint;
      case FocusType.neutral:
        return _neutralFocusedTargetPaint;
      case FocusType.negative:
        return _negativeFocusedTargetPaint;
    }
  }

  // @override
  // bool get debugMode => true;

  MapSpaceComponent(
      {super.priority = MapComponent.spacePriority, required this.terrain});

  String get debugString {
    return '';
  }

  @override
  void onMount() {
    super.onMount();
    coordinate = terrain.coordinate;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    if (selected) {
      canvas.drawPath(HexComponent.hexagonPath(), _selectedBorderPaint);
    } else if (focused) {
      canvas.drawPath(HexComponent.hexagonPath(), _focusedBorderPaint);
    } else {
      canvas.drawPath(HexComponent.hexagonPath(), _borderPaint);
    }

    final fillePaint = terrain.terrain.fillPaint;
    if (fillePaint != null) {
      canvas.drawPath(HexComponent.hexagonPath(), fillePaint);
    }

    final textPainter = TextPainter(
      text: TextSpan(
        text: debugString,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    final offset = Offset(
      (size.x - textPainter.width) / 2,
      (size.y - textPainter.height) / 2,
    );
    textPainter.paint(canvas, offset);

    Sprite? icon;
    if (terrain.isStart) {
      icon = TerrainType.start.iconSprite;
    } else if (terrain.isExit) {
      icon = TerrainType.exit.iconSprite;
    }

    icon?.render(
      canvas,
      position: Vector2(0.5 * size.x, 0.5 * size.y),
      anchor: Anchor.center,
      size: icon.srcSize.scaled(size.y * (1.0 / 3.0) / icon.srcSize.y),
    );

    final spawnPoint = terrain.spawnPoint;
    if (spawnPoint != null) {
      final ether = Assets.etherSprite(spawnPoint);
      ether.render(canvas,
          position: Vector2(0.5 * size.x, 0.5 * size.y),
          anchor: Anchor.center,
          size: size / 3.0);
    }
  }
}
