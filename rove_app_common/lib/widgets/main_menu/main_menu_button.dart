import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rove_app_common/style/rove_palette.dart';
import 'package:rove_app_common/style/rove_theme.dart';

class MainMenuButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const MainMenuButton({
    required this.text,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      margin: EdgeInsets.only(bottom: 24),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            foregroundColor: RovePalette.campaignSheetForeground,
            backgroundColor:
                RovePalette.campaignSheetBackground.withValues(alpha: 0.5),
            shadowColor: Colors.transparent,
            side: BorderSide(
                color: RovePalette.campaignSheetForeground, width: 2),
            shape: const BeveledRectangleBorder(
              borderRadius: RoveTheme.bevelBorderRadius,
            )),
        onPressed: onPressed,
        child: Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              text,
              style: GoogleFonts.grenze(
                color: RovePalette.campaignSheetForeground,
                fontWeight: FontWeight.w600,
                fontSize: 24,
              ),
            )),
      ),
    );
  }
}
