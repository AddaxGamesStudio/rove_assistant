import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/palette.dart';

class ActionFlowComponent extends PositionComponent {
  static const double _triangleSize = 12;
  static const double _lineWidth = 60;

  static final Paint _paint = Paint()
    ..color = BasicPalette.white.color
    ..style = PaintingStyle.fill;

  final bool requiresPrevious;

  ActionFlowComponent({required this.requiresPrevious})
      : super(size: Vector2(_lineWidth, requiresPrevious ? _triangleSize : 2));

  @override
  void onLoad() {
    if (requiresPrevious) {
      add(PolygonComponent(
        [
          Vector2(0, _triangleSize),
          Vector2(_triangleSize / 2, 0),
          Vector2(_triangleSize, _triangleSize),
        ],
        paint: _paint,
      )..position = Vector2((size.x - _triangleSize) / 2, 0));
    }
    add(RectangleComponent.fromRect(
        Rect.fromLTWH(
            0, requiresPrevious ? _triangleSize - 2 : 0, _lineWidth, 2),
        paint: _paint));
  }
}
