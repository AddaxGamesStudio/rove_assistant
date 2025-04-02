import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rove_simulator/assets.dart';

class UnitHealthWidget extends StatelessWidget {
  final int health;
  final int maxHealth;
  final Color minHealthColor;

  const UnitHealthWidget({
    super.key,
    required this.health,
    required this.maxHealth,
    required this.minHealthColor,
  });

  @override
  Widget build(BuildContext context) {
    final tween = ColorTween(begin: minHealthColor, end: Colors.red.shade900);
    return Stack(
      alignment: Alignment.center,
      children: [
        Image.asset(
          Assets.pathForAppImage('icon_health.png'),
          height: 14,
          color: tween.lerp(health.toDouble() / maxHealth.toDouble()),
        ),
        Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(health.toString(),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontFamily: GoogleFonts.merriweather().fontFamily,
                    fontWeight: FontWeight.bold))),
      ],
    );
  }
}
