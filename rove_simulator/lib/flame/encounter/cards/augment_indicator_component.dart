import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flame/text.dart';
import 'package:flutter/material.dart';
import 'package:rove_simulator/assets.dart';
import 'package:rove_data_types/rove_data_types.dart';

class AugmentIndicatorComponent extends PositionComponent {
  static const double _padding = 12;
  static const double _etherSpacing = 6;
  static final Vector2 _etherSize = Vector2(32, 32);

  static final Paint _borderPaint = Paint()
    ..color = BasicPalette.white.color
    ..strokeWidth = 1
    ..style = PaintingStyle.stroke;

  static final Paint _backgroundPaint = Paint()
    ..color = BasicPalette.black.color.withValues(alpha: 0.75)
    ..style = PaintingStyle.fill;

  static final _descriptionTextPaint = TextPaint(
      style: TextStyle(
    fontSize: 18.0,
    color: BasicPalette.white.color,
  ));

  late RRect _backgroundRRect;
  final RoveAction action;
  final ActionAugment augment;
  late PositionComponent? _conditionTextComponent;
  late PositionComponent _descriptionComponent;

  int get etherCount => augment.condition.ethers.length;

  _conditionText() {
    final condition = augment.condition;
    final description = condition.description;
    if (augment.condition.ethers.isEmpty && description.isNotEmpty) {
      return TextBoxComponent(
          text: description,
          align: Anchor.center,
          boxConfig: const TextBoxConfig(
            maxWidth: 230,
          ),
          textRenderer: _descriptionTextPaint);
    } else {
      return null;
    }
  }

  AugmentIndicatorComponent({required this.action, required this.augment}) {
    _conditionTextComponent = _conditionText();
    {
      final multilineDescription = TextBoxComponent(
          text: augment.descriptionForAction(action),
          align: Anchor.center,
          boxConfig:
              const TextBoxConfig(maxWidth: 200, margins: EdgeInsets.zero),
          textRenderer: _descriptionTextPaint);
      final singleLineDescription = TextComponent(
          text: augment.descriptionForAction(action),
          textRenderer: _descriptionTextPaint);
      _descriptionComponent =
          multilineDescription.height > singleLineDescription.height
              ? multilineDescription
              : singleLineDescription;
    }
    updateBounds();
  }

  updateBounds() {
    size = Vector2(
        max(
            _padding +
                _etherSize.x * etherCount +
                _etherSpacing * (etherCount - 1) +
                _padding +
                _descriptionComponent.size.x +
                _padding,
            _padding + (_conditionTextComponent?.size.x ?? 0) + _padding),
        max(
            50,
            _padding +
                (_conditionTextComponent?.size.y ?? 0) +
                _padding +
                _descriptionComponent.size.y +
                _padding));
  }

  @override
  void onLoad() {
    super.onLoad();

    var etherX = _padding;
    SpriteComponent? lastEther;
    for (int i = 0; i < etherCount; i++) {
      final ether = SpriteComponent(
          sprite: Assets.etherSprite(augment.condition.ethers[i]),
          size: _etherSize);
      ether.position = Vector2(etherX, (size.y - ether.size.y) / 2);
      add(ether);
      etherX += ether.size.x + _etherSpacing;
      lastEther = ether;
    }

    _backgroundRRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.x, size.y),
      const Radius.circular(20),
    );

    if (_conditionTextComponent != null) {
      add(_conditionTextComponent!..position = Vector2(0, _padding));
    }

    {
      final descriptionX = _conditionTextComponent != null
          ? (size.x - _descriptionComponent.size.x) / 2
          : (lastEther != null ? lastEther.position.x + lastEther.size.x : 0) +
              _padding;
      final descriptionY = _conditionTextComponent != null
          ? _conditionTextComponent!.position.y +
              _conditionTextComponent!.size.y +
              _padding
          : (size.y - _descriptionComponent.size.y) / 2;
      add(_descriptionComponent
        ..position = Vector2(descriptionX, descriptionY));
    }
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRRect(_backgroundRRect, _backgroundPaint);
    canvas.drawRRect(_backgroundRRect, _borderPaint);
    super.render(canvas);
  }
}
