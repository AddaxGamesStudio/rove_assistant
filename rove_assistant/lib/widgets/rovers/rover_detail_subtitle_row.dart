import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RoverDetailSubtitleRow extends StatelessWidget {
  const RoverDetailSubtitleRow({
    super.key,
    required this.text,
    required this.color,
  });

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    const double padding = 8;
    return Padding(
        padding: const EdgeInsets.only(left: padding, right: padding),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(text,
                style: GoogleFonts.grenze(
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                )),
            SizedBox(width: padding),
            Expanded(
                child: Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: SizedBox(
                        height: 1,
                        child: Divider(color: color, indent: 0, thickness: 2))))
          ],
        ));
  }
}
