import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/animation.dart';
import 'package:rove_editor/flame/encounter/coordinate_component.dart';

mixin UnitComponent on CoordinateComponent {
  bool get isSlain;
  String get modelKey;

  Future<void> loot(CoordinateComponent component) {
    const maxDelta = 100.0;
    const duration = 0.25;
    final completer = Completer();
    var control = (component.position + position) / 2;
    control = control +
        Vector2(Random().nextDouble() * maxDelta * 2 - maxDelta,
            Random().nextDouble() * maxDelta * 2 - maxDelta);
    component.add(MoveAlongPathEffect(
      Path()
        ..moveTo(component.x, component.y)
        ..quadraticBezierTo(control.x, control.y, position.x, position.y),
      EffectController(duration: duration, curve: Curves.easeOut),
      absolute: true,
    ));
    component.add(ScaleEffect.by(Vector2(0, 0),
        EffectController(duration: duration, curve: Curves.easeIn)));
    component.add(
        RemoveEffect(delay: duration, onComplete: () => completer.complete()));
    return completer.future;
  }
}
