import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rove_simulator/assets.dart';

class TileNumberWidget extends StatelessWidget {
  final int number;

  const TileNumberWidget({
    super.key,
    required this.number,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Image.asset(Assets.pathForAppImage('mask_hexagon.png'),
            height: 16, color: Colors.grey),
        Image.asset(Assets.pathForAppImage('mask_hexagon.png'),
            height: 14, color: Colors.black),
        Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(number.toString(),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontFamily: GoogleFonts.merriweather().fontFamily,
                    fontWeight: FontWeight.bold))),
      ],
    );
  }
}
