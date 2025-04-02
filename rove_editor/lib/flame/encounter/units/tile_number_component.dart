import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:rove_editor/flame/encounter/hexagon_component.dart';
import 'package:rove_editor/model/tiles/enemy_model.dart';

class TileNumberComponent extends PositionComponent {
  final EnemyModel model;
  late TextComponent _healthText;
  static final _textPaint = TextPaint(
      style: TextStyle(
    fontSize: 16,
    color: BasicPalette.white.color,
  ));

  static const double _hexagonRadius = 15;
  static final Path _hexagonPath =
      Polygon(List.generate(6, (i) => vertextAtIndex(i))).asPath();
  static Vector2 vertextAtIndex(int index) {
    return HexagonComponent.vertexAtIndex(index, _hexagonRadius);
  }

  static final _backgroundPaint = Paint()
    ..style = PaintingStyle.fill
    ..color = BasicPalette.black.color;

  static final _borderPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2
    ..color = BasicPalette.white.color;

  TileNumberComponent({required this.model}) : super(size: Vector2(30, 30));

  @override
  void onLoad() {
    _healthText =
        TextComponent(text: model.health.toString(), textRenderer: _textPaint);
    _healthText.anchor = Anchor.center;
    _healthText.position = size / 2;
    add(_healthText);
  }

  @override
  void update(double dt) {
    super.update(dt);
    _healthText.text = model.minPlayerCount.toString();
  }

  @override
  void render(Canvas canvas) {
    canvas.drawPath(_hexagonPath, _borderPaint);
    canvas.drawPath(_hexagonPath, _backgroundPaint);
    super.render(canvas);
  }
}
