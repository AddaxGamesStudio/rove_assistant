import 'package:flutter/material.dart';
import 'package:rove_assistant/theme/rove_palette.dart';
import 'package:rove_assistant/theme/rove_theme.dart';
import 'package:rove_assistant/widgets/common/rove_icon.dart';
import 'package:rove_assistant/widgets/common/rove_text.dart';

class CodexPanel extends StatelessWidget {
  const CodexPanel({
    super.key,
    required this.title,
    required this.number,
    this.foregroundColor = RovePalette.codexForeground,
    this.backgroundColor = RovePalette.codexBackground,
    required this.child,
  });

  final String title;
  final int number;
  final Widget child;
  final Color foregroundColor;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    final radius = RoveTheme.panelRadius;
    final borderRadius = BorderRadius.circular(6.0);
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 520),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          border: Border.all(color: foregroundColor),
          color: backgroundColor,
          borderRadius: borderRadius,
        ),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: foregroundColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: radius,
                    bottomRight: radius,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 12, top: 2, bottom: 2, right: 12),
                  child: Row(
                    children: [
                      Expanded(child: RoveText.subtitle(title)),
                      RoveIcon.small('codex'),
                      RoveText.subtitle(number.toString()),
                    ],
                  ),
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 12, right: 12, top: 6, bottom: 8),
                  child: child,
                ),
              ),
            ]),
      ),
    );
  }
}
