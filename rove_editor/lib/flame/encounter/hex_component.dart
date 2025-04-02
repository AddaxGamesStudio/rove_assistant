import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:rove_editor/flame/encounter/coordinate_component.dart';

class HexComponent extends CoordinateComponent {
  static const double defaultRadius = 50;
  static final defaultSize =
      Vector2(defaultRadius * 2, defaultRadius * sqrt(3));
  static double xSpacing = defaultRadius * (3 / 2);
  static double ySpacing = defaultRadius * sqrt(3);

  HexComponent({required super.priority});

  static Vector2 _cornerPosition(i,
      {double radius = HexComponent.defaultRadius}) {
    var angleDeg = 60 * i;
    var angleRad = pi / 180 * angleDeg;
    return Vector2(radius + radius * cos(angleRad),
        radius * sqrt(3) / 2 + radius * sin(angleRad));
  }

  static Path hexagonPath({double radius = HexComponent.defaultRadius}) {
    final path = Path();
    for (int i = 0; i < 6; i++) {
      final corner = _cornerPosition(i, radius: radius);
      if (i == 0) {
        path.moveTo(corner.x, corner.y);
      } else {
        path.lineTo(corner.x, corner.y);
      }
    }
    path.close();
    return path;
  }
}
