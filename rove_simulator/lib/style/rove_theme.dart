import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rove_app_common/style/rove_palette.dart';

class RoveThemeWidget extends StatelessWidget {
  final Widget child;

  const RoveThemeWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
          elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
            backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
              if (states.contains(WidgetState.disabled)) {
                return Colors.grey;
              } else {
                return RovePalette.title;
              }
            }),
            foregroundColor: WidgetStateProperty.all(Colors.white),
            iconColor: WidgetStateProperty.all(Colors.white),
            shape: WidgetStateProperty.all(BeveledRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            )),
            textStyle: WidgetStateProperty.all(TextStyle(
                fontFamily: GoogleFonts.grenze().fontFamily, fontSize: 14))),
      )),
      child: child,
    );
  }
}
