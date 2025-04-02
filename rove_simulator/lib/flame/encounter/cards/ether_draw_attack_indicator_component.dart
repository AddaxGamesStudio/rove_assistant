import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/palette.dart';
import 'package:flutter/animation.dart';
import 'package:rove_simulator/assets.dart';
import 'package:rove_simulator/flame/encounter/cards/amount_component.dart';
import 'package:rove_simulator/flame/encounter/map/map_component.dart';
import 'package:rove_data_types/rove_data_types.dart';

class EtherDrawAttackIndicatorComponent extends PositionComponent
    with HasOpacityProvider {
  static const double _padding = 12;
  static final Vector2 _etherSize = Vector2(48, 48);

  final Ether ether;
  final int amount;
  late SpriteComponent _etherComponent;
  late AmountComponent _amountComponent;

  EtherDrawAttackIndicatorComponent({required this.ether, required this.amount})
      : super(priority: MapComponent.uiPriority) {
    _amountComponent = AmountComponent(amount: amount);
    updateBounds();
  }

  updateBounds() {
    size = Vector2(_etherSize.x + _padding + _amountComponent.size.x, 32);
  }

  @override
  void onLoad() {
    super.onLoad();

    _etherComponent =
        SpriteComponent(sprite: Assets.etherSprite(ether), size: _etherSize);

    add(_etherComponent
      ..position = Vector2(0, (size.y - _etherComponent.size.y) / 2));
    add(_amountComponent
      ..position = Vector2(_etherComponent.size.x + _padding,
          (size.y - _amountComponent.size.y) / 2));
  }

  void animate() {
    const double duration = 1.5;
    add(SequenceEffect([
      OpacityEffect.by(0, EffectController(duration: duration * 0.5)),
      OpacityEffect.fadeOut(
          EffectController(duration: duration * 0.5, curve: Curves.easeIn))
    ]));
    add(MoveEffect.by(Vector2(0, -50),
        EffectController(duration: duration, curve: Curves.easeOut)));
    add(RemoveEffect(delay: duration));
  }
}

mixin HasOpacityProvider on Component implements OpacityProvider {
  final Paint _paint = BasicPalette.white.paint();
  final Paint _srcOverPaint = Paint()..blendMode = BlendMode.srcOver;

  @override
  double get opacity => _paint.color.a;

  @override
  set opacity(double newOpacity) {
    _paint
      ..color = _paint.color.withValues(alpha: newOpacity)
      ..blendMode = BlendMode.modulate;
  }

  @override
  void renderTree(Canvas canvas) {
    canvas.saveLayer(null, _srcOverPaint);
    super.renderTree(canvas);
    canvas.drawPaint(_paint);
    canvas.restore();
  }
}
