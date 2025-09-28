import 'package:flutter/material.dart';
import 'package:rove_assistant/theme/rove_palette.dart';

class SheetDot extends StatelessWidget {
  const SheetDot({
    super.key,
    required this.id,
    this.color = RovePalette.campaignSheetForeground,
  });

  final String id;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return LayoutId(
        id: id,
        child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color,
                ),
              ),
            )));
  }
}
