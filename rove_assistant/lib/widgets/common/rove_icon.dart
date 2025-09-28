import 'package:flutter/material.dart';
import 'package:rove_assistant/theme/icons.dart';

class RoveIcon extends StatelessWidget {
  const RoveIcon.small(this.name, {super.key, this.color})
      : width = 24,
        height = 24,
        fit = BoxFit.contain;

  const RoveIcon(this.name, {super.key, this.width, this.height, this.color})
      : fit = null;

  final String name;
  final BoxFit? fit;
  final double? width;
  final double? height;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    double? calculatedWidth = width;
    double? calculatedHeight = height;
    final size = roveIconSizes[name];
    if (size != null && fit == null) {
      if (calculatedWidth != null && calculatedHeight == null) {
        calculatedHeight = size.height * (calculatedWidth / size.width);
      } else if (calculatedWidth == null && calculatedHeight != null) {
        calculatedWidth = size.width * (calculatedHeight / size.height);
      } else if (calculatedWidth == null && calculatedHeight == null) {
        calculatedWidth = size.width;
        calculatedHeight = size.height;
      }
    }

    return Image.asset(
      'assets/images/icon_$name.webp',
      width: calculatedWidth,
      height: calculatedHeight,
      fit: fit,
      color: color,
    );
  }
}
