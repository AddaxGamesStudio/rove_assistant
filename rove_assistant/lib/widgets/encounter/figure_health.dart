import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rove_assistant/theme/rove_assets.dart';

class RoverHealth extends StatelessWidget {
  final int health;
  final int maxHealth;
  final Color color;
  final Color textColor;
  final Color minHealthColor;

  RoverHealth({
    super.key,
    required this.health,
    required this.maxHealth,
    Color? color,
    this.textColor = Colors.white,
    Color? minHealthColor,
  })  : color = color ?? Colors.red.shade900,
        minHealthColor = minHealthColor ?? color ?? Colors.red.shade900;

  @override
  Widget build(BuildContext context) {
    final tween = ColorTween(begin: minHealthColor, end: color);
    return Stack(
      alignment: Alignment.center,
      children: [
        Image.asset(
          RoveAssets.iconHealth,
          height: 28,
          color: tween.lerp(health.toDouble() / maxHealth.toDouble()),
        ),
        Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(health.toString(),
                style: TextStyle(
                    color: textColor,
                    fontSize: 10,
                    fontFamily: GoogleFonts.merriweather().fontFamily,
                    fontWeight: FontWeight.bold))),
      ],
    );
  }
}
