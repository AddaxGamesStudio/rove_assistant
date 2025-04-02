import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FigureNumber extends StatelessWidget {
  final int number;
  final double size;

  const FigureNumber({
    super.key,
    this.size = 24,
    required this.number,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 1),
        color: Colors.black.withValues(alpha: 0.5),
      ),
      child: Center(
        child: Text(number.toString(),
            style: TextStyle(
                color: Colors.white,
                fontSize: size / 2,
                fontFamily: GoogleFonts.merriweather().fontFamily,
                fontWeight: FontWeight.bold)),
      ),
    );
  }
}
