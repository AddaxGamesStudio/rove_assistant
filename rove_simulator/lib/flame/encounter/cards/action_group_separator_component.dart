import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flame/text.dart';

class ActionGroupSeparatorComponent extends PositionComponent {
  static final _descriptionTextPaint = TextPaint(
      style: TextStyle(
    fontSize: 18.0,
    color: BasicPalette.white.color,
  ));

  static final Paint _paint = Paint()
    ..color = BasicPalette.white.color
    ..style = PaintingStyle.fill;

  ActionGroupSeparatorComponent() : super(size: Vector2(60, 12));

  @override
  void onLoad() {
    const double lineWidth = 20;

    add(RectangleComponent.fromRect(
        Rect.fromLTWH(0, (size.y - 2) / 2, lineWidth, 2),
        paint: _paint));

    final text = TextComponent(text: 'or', textRenderer: _descriptionTextPaint);
    text.position =
        Vector2((size.x - text.size.x) / 2, (size.y - text.size.y) / 2);
    add(text);

    add(RectangleComponent.fromRect(
        Rect.fromLTWH(size.x - lineWidth, (size.y - 2) / 2, lineWidth, 2),
        paint: _paint));
  }
}
