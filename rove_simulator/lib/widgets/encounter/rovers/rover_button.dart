import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rove_simulator/assets.dart';
import 'package:rove_data_types/rove_data_types.dart';

class RoverButton extends StatelessWidget {
  final String label;
  final Color? color;
  final RoverClass? roverClass;
  final VoidCallback onPressed;
  final bool disabled;

  const RoverButton({
    super.key,
    required this.label,
    this.color,
    this.roverClass,
    this.disabled = false,
    required this.onPressed,
  }) : assert(color != null || roverClass != null);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(8), // an
          foregroundColor: Colors.white,
          backgroundColor:
              disabled ? Colors.grey : roverClass?.colorDark ?? color,
          shape: const BeveledRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          )),
      onPressed: () {
        if (disabled) return;
        onPressed();
      },
      child: SizedBox.expand(
        child: Row(
          children: [
            Expanded(
                child: Text(
              label,
              style: TextStyle(
                  fontFamily: GoogleFonts.grenze().fontFamily,
                  fontSize: 12,
                  color: Colors.white),
            )),
            if (roverClass != null)
              Image.asset(
                Assets.pathForClassImage(roverClass!.iconSrc),
                width: 18,
                height: 18,
                color: Colors.white.withValues(alpha: 0.8),
              ),
          ],
        ),
      ),
    );
  }
}
