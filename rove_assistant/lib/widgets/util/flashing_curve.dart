import 'dart:math' as math;
import 'package:flutter/material.dart';

class FlashingCurve extends Curve {
  final double count;

  const FlashingCurve(this.count);

  @override
  double transformInternal(double t) {
    return 1.0 - ((math.cos((count * 2 + 1) * math.pi * t)) * 0.5 + 0.5);
  }
}
