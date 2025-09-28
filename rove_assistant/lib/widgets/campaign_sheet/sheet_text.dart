import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rove_assistant/theme/rove_palette.dart';

class SheetText extends StatelessWidget {
  const SheetText({
    super.key,
    required this.id,
    required this.text,
    this.alignment = Alignment.centerLeft,
    this.color = RovePalette.campaignSheetForeground,
  });

  final String id;
  final String text;
  final AlignmentGeometry alignment;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return LayoutId(
      id: id,
      child: FittedBox(
        alignment: alignment,
        fit: BoxFit.scaleDown,
        child: Text(
          text,
          style: TextStyle(
              fontSize: 24,
              height: 1.2,
              color: color,
              fontFamily: GoogleFonts.grenze().fontFamily,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
