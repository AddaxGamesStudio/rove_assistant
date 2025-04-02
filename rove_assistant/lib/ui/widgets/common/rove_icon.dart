import 'package:flutter/material.dart';

class RoveIcon extends StatelessWidget {
  const RoveIcon(this.name,
      {super.key, this.size = 24, this.color = Colors.white});

  final String name;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/icon_$name.webp',
      width: size,
      height: size,
      fit: BoxFit.contain,
      color: color,
    );
  }
}
