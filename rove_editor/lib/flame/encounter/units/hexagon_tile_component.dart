import 'dart:math';
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:rove_editor/flame/encounter/hexagon_component.dart';
import 'package:rove_editor/flame/encounter/units/clipped_sprite_component.dart';

class HexagonTileComponent extends ClippedSpriteComponent {
  static const double hexagonRadius = 40;
  static final Path hexagonPath =
      Polygon(List.generate(6, (i) => vertextAtIndex(i))).asPath();

  @override
  final Image image;
  @override
  final Color borderColor;

  static Vector2 vertextAtIndex(int index) {
    return HexagonComponent.vertexAtIndex(index, hexagonRadius);
  }

  HexagonTileComponent({required this.image, required this.borderColor})
      : super(size: Vector2(hexagonRadius * 2, hexagonRadius * sqrt(3)));

  @override
  Path get clipPath => hexagonPath;
}
