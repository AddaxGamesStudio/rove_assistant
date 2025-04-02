import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:rove_simulator/assets.dart';
import 'package:rove_simulator/model/tiles/tile_model.dart';

class HealthComponent extends PositionComponent {
  final Slayable model;
  late TextComponent _healthText;
  static final _textPaint = TextPaint(
      style: TextStyle(
    fontSize: 16,
    color: BasicPalette.white.color,
  ));

  HealthComponent({required this.model}) : super(size: Vector2(30, 30));

  @override
  void onLoad() {
    final health = SpriteComponent(sprite: Assets.iconHealth, size: size);
    health.anchor = Anchor.center;
    health.position = Vector2(0.5 * size.x, 0.5 * size.y);
    health.add(ColorEffect(Colors.red.shade900, EffectController(duration: 0)));
    add(health);
    _healthText =
        TextComponent(text: model.health.toString(), textRenderer: _textPaint);
    _healthText.anchor = Anchor.center;
    _healthText.position = health.position;
    add(_healthText);
  }

  @override
  void update(double dt) {
    super.update(dt);
    _healthText.text = model.health.toString();
  }
}
