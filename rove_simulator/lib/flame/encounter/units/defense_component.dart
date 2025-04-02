import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:rove_simulator/assets.dart';
import 'package:rove_simulator/flame/encounter_game.dart';
import 'package:rove_simulator/model/tiles/unit_model.dart';

class DefenseComponent extends PositionComponent
    with HasGameRef<EncounterGame> {
  final UnitModel model;
  late TextComponent _label;
  static final _textPaint = TextPaint(
      style: TextStyle(
    fontSize: 16,
    color: BasicPalette.white.color,
  ));

  DefenseComponent({required this.model}) : super(size: Vector2(30, 30));

  @override
  void onLoad() {
    final health = SpriteComponent(sprite: Assets.iconShield, size: size);
    health.anchor = Anchor.center;
    health.position = Vector2(0.5 * size.x, 0.5 * size.y);
    health.add(ColorEffect(Colors.blue, EffectController(duration: 0)));
    add(health);
    _label =
        TextComponent(text: model.defense.toString(), textRenderer: _textPaint);
    _label.anchor = Anchor.center;
    _label.position = health.position;
    add(_label);
  }

  @override
  void update(double dt) {
    super.update(dt);
    _label.text = model.defense.toString();
  }
}
