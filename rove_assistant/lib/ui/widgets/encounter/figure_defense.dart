import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rove_assistant/ui/rove_assets.dart';

class FigureDefense extends StatelessWidget {
  final int defense;
  final Color color;
  final Color textColor;

  const FigureDefense({
    super.key,
    required this.defense,
    this.color = Colors.blue,
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Image.asset(RoveAssets.iconDefense, height: 28, color: color),
        Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(defense.toString(),
                style: TextStyle(
                    color: textColor,
                    fontSize: 10,
                    fontFamily: GoogleFonts.merriweather().fontFamily,
                    fontWeight: FontWeight.bold))),
      ],
    );
  }
}
