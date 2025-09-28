import 'package:flutter/material.dart';
import 'package:rove_assistant/theme/rove_palette.dart';

class SheetCheckMark extends StatelessWidget {
  const SheetCheckMark({
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
        child: Text(
          '✗',
          style: TextStyle(fontSize: 24, height: 1, color: color),
        ),
      ),
    );
  }
}
