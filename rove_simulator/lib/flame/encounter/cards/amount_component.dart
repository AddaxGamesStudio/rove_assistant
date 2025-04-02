import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flame/text.dart';
import 'package:flutter/material.dart';

class AmountComponent extends PositionComponent {
  static const double _xPadding = 8;
  static const double _yPadding = 4;

  static final Paint _borderPaint = Paint()
    ..color = BasicPalette.white.color
    ..strokeWidth = 2
    ..style = PaintingStyle.stroke;

  static paintWithColor(Color color) => Paint()
    ..style = PaintingStyle.fill
    ..color = color;

  static final _textPaint = TextPaint(
    style: const TextStyle(
      fontSize: 32,
      color: Colors.white,
    ),
  );

  static final _positiveBackgroundPaint = paintWithColor(Colors.green);
  static final _neutralBackgroundPaint = paintWithColor(Colors.grey);
  static final _negativeBackgroundTextPaint = paintWithColor(Colors.red);
  final int amount;
  late TextComponent _amountComponent;
  late RRect _backgroundRRect;

  AmountComponent({required this.amount}) {
    _amountComponent = TextComponent(
        text: amount >= 0 ? '+$amount' : amount.toString(),
        textRenderer: _textPaint);
    updateBounds();
  }

  updateBounds() {
    size = Vector2(_xPadding + _amountComponent.size.x + _xPadding,
        _yPadding + _amountComponent.size.y + _yPadding);
  }

  @override
  void onLoad() {
    super.onLoad();
    add(_amountComponent..position = Vector2(_xPadding, _yPadding));

    _backgroundRRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.x, size.y),
      const Radius.circular(10),
    );
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRRect(
        _backgroundRRect,
        amount > 0
            ? _positiveBackgroundPaint
            : amount < 0
                ? _negativeBackgroundTextPaint
                : _neutralBackgroundPaint);
    canvas.drawRRect(_backgroundRRect, _borderPaint);
    super.render(canvas);
  }
}
