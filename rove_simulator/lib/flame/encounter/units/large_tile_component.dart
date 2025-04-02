import 'dart:math';
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:rove_simulator/flame/encounter/hexagon_component.dart';
import 'package:rove_simulator/flame/encounter/units/clipped_sprite_component.dart';

class LargeTileComponent extends ClippedSpriteComponent {
  static const double hexagonRadius = 40;
  static final Path tilePath =
      Polygon(List.generate(14, (i) => vertextAtIndex(i))).asPath();

  @override
  final Image image;
  @override
  final Color borderColor;

  static Vector2 vertextAtIndex(int index) {
    const xSpacing = hexagonRadius * (3 / 2);
    final ySpacing = hexagonRadius * sqrt(3);
    // const width = hexagonRadius * 2;
    final height = hexagonRadius * sqrt(3);
    final offsets = [
      Vector2(0, height / 2),
      Vector2(xSpacing, 0),
      Vector2(xSpacing * 2, height / 2),
      Vector2(xSpacing, ySpacing),
    ];
    const sequence = [
      (2, 0),
      (2, 1),
      (2, 2),
      (3, 1),
      (3, 2),
      (3, 3),
      (0, 2),
      (0, 3),
      (0, 4),
      (0, 5),
      (1, 4),
      (1, 5),
      (1, 0),
      (2, 5)
    ];
    assert(index <= sequence.length);
    final offset = offsets[sequence[index].$1];
    final subindex = sequence[index].$2;
    return HexagonComponent.vertexAtIndex(subindex, hexagonRadius) + offset;
  }

  LargeTileComponent({required this.image, required this.borderColor})
      : super(size: Vector2(hexagonRadius * 5, hexagonRadius * sqrt(3) * 2));

  @override
  Path get clipPath => tilePath;
}
