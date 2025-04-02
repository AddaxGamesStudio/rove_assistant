import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PlayerBoardSectionHeader extends StatelessWidget {
  const PlayerBoardSectionHeader({
    super.key,
    required this.title,
    required this.decoration,
  });

  final String title;
  final String decoration;

  @override
  Widget build(BuildContext context) {
    final child = decoration.isEmpty
        ? Container(
            padding: const EdgeInsets.only(top: 6),
            child: Row(
              children: [
                const Spacer(),
                Text(
                  title,
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: GoogleFonts.grenze().fontFamily,
                      fontSize: 12),
                ),
                const Spacer(),
              ],
            ))
        : Container(
            padding: const EdgeInsets.only(top: 6),
            child: Row(
              children: [
                Text(
                  title,
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: GoogleFonts.grenze().fontFamily,
                      fontSize: 12),
                ),
                const Spacer(),
                Text(
                  decoration,
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: GoogleFonts.grenze().fontFamily),
                ),
              ],
            ));

    return SizedBox(
      width: 150,
      child: child,
    );
  }
}
