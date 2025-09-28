import 'package:flutter/material.dart';
import 'package:rove_assistant/theme/rove_theme.dart';
import 'package:rove_assistant/model/players_model.dart';
import 'rove_text.dart';
import 'package:rove_data_types/rove_data_types.dart';

class RoverActionButton extends StatelessWidget {
  final String label;
  final Color? color;
  final RoverClass? roverClass;
  final VoidCallback? onPressed;

  const RoverActionButton({
    super.key,
    required this.label,
    this.color,
    this.roverClass,
    required this.onPressed,
  }) : assert(color != null || roverClass != null);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: roverClass?.colorDark ?? color,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(RoveTheme.panelRadius),
          )),
      onPressed: onPressed,
      child: Row(
        children: [
          Expanded(
              child: RoveText(label,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold))),
          if (roverClass case final value?)
            Image.asset(
              width: 24,
              height: 24,
              color: Colors.white.withValues(alpha: 0.8),
              value.iconAsset,
            ),
        ],
      ),
    );
  }
}
