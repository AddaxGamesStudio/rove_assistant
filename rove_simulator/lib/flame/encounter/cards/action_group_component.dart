import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
import 'package:rove_simulator/flame/encounter_game.dart';

class ActionGroupComponent extends PositionComponent
    with TapCallbacks, PointerMoveCallbacks, HasGameRef<EncounterGame> {
  static final Paint _borderPaint = Paint()
    ..color = const Color(0xffdbaf58)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 4;

  bool _focused = false;

  final int index;
  final bool selecting;

  ActionGroupComponent(
      {required this.index, this.selecting = false, super.size});

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    if (_focused && selecting) {
      final rect = RoundedRectangle.fromLTRBR(0, 0, size.x, size.y, 10);
      canvas.drawPath(rect.asPath(), _borderPaint);
    }
  }

  @override
  void onTapUp(TapUpEvent event) {
    super.onTapUp(event);
    if (selecting) {
      game.cardController.onActionGroupSelected(index);
    }
  }

  @override
  void onPointerMove(PointerMoveEvent event) {
    super.onPointerMove(event);
    _focused = true;
  }

  @override
  void onPointerMoveStop(PointerMoveEvent event) {
    super.onPointerMoveStop(event);
    _focused = false;
  }
}
