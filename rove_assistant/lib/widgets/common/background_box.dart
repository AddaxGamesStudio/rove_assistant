import 'package:flutter/material.dart';

class BackgroundBox extends StatelessWidget {
  final Color? color;
  final ImageProvider image;
  final Widget child;

  factory BackgroundBox.named(String name,
          {Color? color, required Widget child}) =>
      BackgroundBox(
          color: color,
          image: AssetImage('assets/images/$name.webp'),
          child: child);

  const BackgroundBox(
      {super.key, this.color, ImageProvider? image, required this.child})
      : image =
            image ?? const AssetImage('assets/images/background_campaign.webp');

  @override
  Widget build(Object context) {
    ColorFilter? colorFilter;
    if (color case final value?) {
      colorFilter = ColorFilter.mode(value, BlendMode.multiply);
    }
    return DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: image, colorFilter: colorFilter, fit: BoxFit.cover),
        ),
        child: child);
  }
}
