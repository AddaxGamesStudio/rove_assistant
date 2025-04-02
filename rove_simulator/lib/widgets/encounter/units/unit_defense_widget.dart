import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rove_simulator/assets.dart';

class UnitDefenseWidget extends StatelessWidget {
  final int defense;

  const UnitDefenseWidget({
    super.key,
    required this.defense,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Image.asset(
          Assets.pathForAppImage('icon_shield.png'),
          height: 14,
          color: Colors.blue,
        ),
        Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(defense.toString(),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontFamily: GoogleFonts.merriweather().fontFamily,
                    fontWeight: FontWeight.bold))),
      ],
    );
  }
}
