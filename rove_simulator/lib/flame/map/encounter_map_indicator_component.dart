import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:rove_app_common/style/rove_palette.dart';

class EncounterMapIndicatorComponent extends PositionComponent {
  static final Paint _paint = Paint()..color = RovePalette.title;
  static final Paint _focusedPaint = Paint()..color = BasicPalette.white.color;

  final String encounterId;
  late CircleComponent _circleComponent;
  bool focused = false;

  EncounterMapIndicatorComponent({required this.encounterId})
      : super(size: Vector2(20, 20));

  @override
  ComponentKey? get key => ComponentKey.named(encounterId);

  @override
  FutureOr<void> onLoad() {
    super.onLoad();
    add(_circleComponent =
        CircleComponent.relative(1, parentSize: size, paint: _paint));
  }

  @override
  void update(double dt) {
    super.update(dt);
    _circleComponent.paint = focused ? _focusedPaint : _paint;
  }
}
