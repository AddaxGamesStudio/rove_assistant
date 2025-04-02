import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/painting.dart';
import 'package:rove_simulator/flame/encounter/cards/ether_draw_attack_indicator_component.dart';

abstract class ClippedSpriteComponent extends PositionComponent
    with HasOpacityProvider {
  static final _backgroundPaint = Paint()
    ..style = PaintingStyle.fill
    ..color = BasicPalette.black.color;
  static final _grayscalePaint = Paint()
    ..color = const Color.fromARGB(255, 0, 0, 0)
    ..blendMode = BlendMode.luminosity;

  Image get image;
  Color get borderColor;
  Path get clipPath;

  late Paint _defaultPaint;
  bool _isGrayscale = false;
  bool get isGrayscale => _isGrayscale;
  late Paint _borderPaint;
  late RectangleComponent _backgroundComponent;
  late SpriteComponent _imageComponent;

  ClippedSpriteComponent({required super.size});

  @override
  void onLoad() {
    super.onLoad();
    _borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    add(_backgroundComponent = RectangleComponent.fromRect(
        Rect.fromLTWH(0, 0, size.x, size.y),
        paint: _backgroundPaint));

    {
      final imageSize =
          Vector2(image.width.toDouble(), image.height.toDouble());
      final sizes = applyBoxFit(
          BoxFit.cover, Size(imageSize.x, imageSize.y), Size(size.x, size.y));
      final srcSize = Vector2(sizes.source.width, sizes.source.height);
      add(_imageComponent = SpriteComponent(
          sprite: Sprite(image,
              srcPosition: (imageSize - srcSize) / 2,
              srcSize: Vector2(sizes.source.width, sizes.source.height)),
          size: size));
      _defaultPaint = _imageComponent.paint;
    }
  }

  @override
  set opacity(double value) {
    super.opacity = value;
    _backgroundComponent.opacity = value;
    _imageComponent.opacity = value;
  }

  set isGrayscale(bool value) {
    if (_isGrayscale == value) {
      return;
    }
    _isGrayscale = value;
    if (_isGrayscale) {
      _imageComponent.paint = _grayscalePaint;
    } else {
      _imageComponent.paint = _defaultPaint;
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawPath(clipPath, _borderPaint);
    canvas.clipPath(clipPath);
  }
}
