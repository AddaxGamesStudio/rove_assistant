import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rove_app_common/style/rove_palette.dart';

class RoveTheme {
  static final cardBorderRadius = BorderRadius.circular(8.0);

  static const panelRadius = Radius.circular(6);
  static const bevelRadius = Radius.circular(8);
  static const bevelBorderRadius = BorderRadius.all(bevelRadius);

  static const dialogMinWidth = 280.0;
  static const dialogMaxWidth = 480.0;
  static const pageMaxWidth = 720.0;

  static const horizontalSpacing = 8.0;
  static const verticalSpacing = 12.0;
  static const verticalSpacingBox = SizedBox(height: verticalSpacing);

  static TextStyle titleStyle({Color color = RovePalette.title}) {
    return GoogleFonts.grenze(
      color: color,
      fontWeight: FontWeight.w600,
      fontSize: 24,
    );
  }
}
