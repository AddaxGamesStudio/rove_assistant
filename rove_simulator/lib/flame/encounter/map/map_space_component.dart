import 'package:flame/components.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rove_simulator/flame/encounter/map/map_component.dart';
import 'package:rove_simulator/flame/encounter/hex_component.dart';
import 'package:rove_simulator/flame/encounter_game.dart';
import 'package:rove_simulator/model/tiles/terrain_model.dart';
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

class MapSpaceComponent extends HexComponent
    with HasGameReference<EncounterGame> {
  static final Paint _selectablePaint = Paint()
    ..color = Colors.white.withValues(alpha: 0.3);
  static final Paint _pathPaint = Paint()
    ..color = Colors.green.shade400.withValues(alpha: 0.5);
  static final Paint _neutralFocusedTargetPaint = Paint()
    ..color = Colors.white.withValues(alpha: 0.75);
  static final Paint _negativeFocusedTargetPaint = Paint()
    ..color = Colors.red.withValues(alpha: 0.75);
  static final Paint _positiveFocusedTargetPaint = Paint()
    ..color = Colors.blue.withValues(alpha: 0.75);

  static final Paint _borderPaint = Paint()
    ..color = const Color(0xffdbaf58)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2;
  static final Paint _focusedBorderPaint = Paint()
    ..color = Colors.white
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2;

  final TerrainModel terrain;

  bool selected = false;
  Paint get focusedTargetPaint {
    final polarity = game.turnController.currentActionPolarity;
    final focusType =
        polarity != null ? FocusType.fromPolarity(polarity) : FocusType.neutral;
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
    final actionString =
        game.turnController.debugStringForCoordinate(coordinate);
    return actionString != null && actionString.isNotEmpty
        ? actionString
        : coordinate.toEvenQ().toString();
  }

  @override
  void onMount() {
    super.onMount();
    coordinate = terrain.coordinate;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final isSelectable =
        game.cardResolver?.isSelectableAtCoordinate(coordinate) ?? false;
    final isPath = game.cardResolver?.isPartOfPath(coordinate) ?? false;
    final isInAreaOfEffect = game.turnController.isInAreaOfEffect(coordinate);

    if (focused && isSelectable) {
      canvas.drawPath(HexComponent.hexagonPath(), focusedTargetPaint);
    } else if (isInAreaOfEffect) {
      canvas.drawPath(HexComponent.hexagonPath(), focusedTargetPaint);
    } else if (isPath) {
      canvas.drawPath(HexComponent.hexagonPath(), _pathPaint);
    } else if (isSelectable) {
      canvas.drawPath(HexComponent.hexagonPath(), _selectablePaint);
    }

    if (selected) {
      canvas.drawPath(HexComponent.hexagonPath(), _borderPaint);
    } else if (focused) {
      canvas.drawPath(HexComponent.hexagonPath(), _focusedBorderPaint);
    }

    if (kDebugMode) {
      // if (terrain.fillPaint != null) {
      //  canvas.drawPath(HexComponent.hexagonPath(), terrain.fillPaint!);
      // }

      final textPainter = TextPainter(
        text: TextSpan(
          text: debugString,
          style: const TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
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

      /*
      final icon = terrain.terrain.icon;
      icon?.render(
        canvas,
        position: Vector2(0.5 * size.x, 0.5 * size.y),
        anchor: Anchor.center,
        size: icon.srcSize.scaled(size.y * (1.0 / 3.0) / icon.srcSize.y),
      ); */
    }
  }
}
