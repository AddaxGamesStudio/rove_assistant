import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';

class HexagonComponent extends PositionComponent {
  final double radius;
  final Paint paint;
  final double xSpacing;
  final double ySpacing;

  static Vector2 vertexAtIndex(i, radius) {
    var angleDeg = 60 * i;
    var angleRad = pi / 180 * angleDeg;
    return Vector2(radius + radius * cos(angleRad),
        radius * sqrt(3) / 2 + radius * sin(angleRad));
  }

  HexagonComponent({required this.radius, required this.paint})
      : xSpacing = radius * (3 / 2),
        ySpacing = radius * sqrt(3),
        super(
            size: Vector2(radius * 2, radius * sqrt(3)), anchor: Anchor.center);

  Path _hexagonPath() {
    final path = Path();
    for (int i = 0; i < 6; i++) {
      final corner = vertexAtIndex(i, radius);
      if (i == 0) {
        path.moveTo(corner.x, corner.y);
      } else {
        path.lineTo(corner.x, corner.y);
      }
    }
    path.close();
    return path;
  }

  @override
  render(Canvas canvas) {
    canvas.drawPath(_hexagonPath(), paint);
  }
}
