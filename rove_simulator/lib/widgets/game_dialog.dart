import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GameDialog extends StatelessWidget {
  final Color color;
  final Widget child;

  const GameDialog({super.key, required this.color, required this.child});

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: ThemeData(
          fontFamily: GoogleFonts.grenze().fontFamily,
        ),
        child: Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.black.withValues(alpha: 0.5),
            child: Dialog(
                shape: BeveledRectangleBorder(
                  side: BorderSide(width: 2, color: color),
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: child,
                ))));
  }
}
