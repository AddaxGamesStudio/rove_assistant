import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:rove_simulator/flame/encounter/coordinate_component.dart';
import 'package:rove_simulator/flame/encounter/map/map_space_component.dart';
import 'package:rove_simulator/flame/encounter_game.dart';

class TargetComponent extends PositionComponent with HasGameRef<EncounterGame> {
  late Paint _targetPaint;
  Offset? _fromOffset;
  Offset? _toOffset;

  TargetComponent({required super.size, required super.priority});

  bool get needsDrawing => _fromOffset != null && _toOffset != null;

  _reset() {
    _fromOffset = null;
    _toOffset = null;
  }

  bool _setTarget(double dt) {
    final actor = game.turnController.actor;
    if (actor == null) {
      return false;
    }
    final targetCoordinate = game.turnController.targetCoordinate;
    if (targetCoordinate == null) {
      return false;
    }
    final actorComponent =
        game.findByKey<CoordinateComponent>(ComponentKey.named(actor.key)) ??
            game.map
                .componentsAtCoordinate(actor.coordinate)
                .whereType<MapSpaceComponent>()
                .firstOrNull;
    if (actorComponent == null) {
      return false;
    }
    final from = actorComponent.center;
    final to = game.map.centerForCoordinate(targetCoordinate);
    if (to == null) {
      return false;
    }
    _fromOffset = Offset(from.x, from.y);
    _toOffset = Offset(to.x, to.y);
    _targetPaint = Paint()
      ..shader = Gradient.linear(
        _fromOffset!,
        _toOffset!,
        [
          BasicPalette.white.color.withValues(alpha: 0.5),
          BasicPalette.white.color,
        ],
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    return true;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!_setTarget(dt)) {
      _reset();
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    if (needsDrawing) {
      canvas.drawLine(
        _fromOffset!,
        _toOffset!,
        _targetPaint,
      );
    }
  }
}
