import 'package:flutter/material.dart';

class BackgroundBox extends StatelessWidget {
  final Color? color;
  final ImageProvider image;
  final Widget child;

  const BackgroundBox(
      {super.key, this.color, ImageProvider? image, required this.child})
      : image = image ??
            const AssetImage('assets/images/background.jpeg',
                package: 'rove_app_common');

  @override
  Widget build(Object context) {
    ColorFilter? colorFilter;
    if (color case final value?) {
      colorFilter = ColorFilter.mode(value, BlendMode.dst);
    }
    return DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: image, colorFilter: colorFilter, fit: BoxFit.cover),
        ),
        child: child);
  }
}
