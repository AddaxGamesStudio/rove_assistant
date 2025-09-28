import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rove_assistant/theme/rove_theme.dart';
import 'package:rove_assistant/widgets/common/rove_text.dart';
import 'package:rove_assistant/widgets/encounter/encounter_detail.dart';

class EncounterPanel extends StatelessWidget {
  const EncounterPanel({
    super.key,
    required this.title,
    required this.icon,
    required this.foregroundColor,
    required this.backgroundColor,
    this.footerColor,
    this.inWrap = false,
    this.footer,
    required this.child,
  });

  final String title;
  final Widget icon;
  final Widget child;
  final Widget? footer;
  final Color foregroundColor;
  final Color backgroundColor;
  final Color? footerColor;
  final bool inWrap;

  @override
  Widget build(BuildContext context) {
    final radius = RoveTheme.panelRadius;
    final borderRadius = BorderRadius.circular(6.0);

    return OrientationBuilder(builder: (context, orientation) {
      final viewQuery = MediaQueryData.fromView(View.of(context));
      final safeWidth = viewQuery.size.width -
          max(viewQuery.padding.left, EncounterSidePadding.padding.left) -
          max(viewQuery.padding.right, EncounterSidePadding.padding.right);
      final double tightWidth = 398.0;
      final double looseWidth = 520.0;
      final fitCountTight =
          (safeWidth / (tightWidth + RoveTheme.horizontalSpacing)).floor();
      final fitCountLoose =
          (safeWidth / (looseWidth + RoveTheme.horizontalSpacing)).floor();
      return ConstrainedBox(
        constraints: BoxConstraints(
            maxWidth:
                !inWrap || fitCountLoose == 0 || fitCountLoose >= fitCountTight
                    ? looseWidth
                    : tightWidth),
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
                Stack(
                  alignment: Alignment.topRight,
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
                        padding:
                            const EdgeInsets.only(left: 12, top: 2, bottom: 2),
                        child: RoveText.subtitle(title, color: Colors.white),
                      ),
                    ),
                    Positioned(
                      child: Container(
                          width: 40,
                          height: 36,
                          decoration: BoxDecoration(
                            color: foregroundColor,
                            borderRadius: borderRadius,
                          ),
                          child: Center(child: icon)),
                    ),
                  ],
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 12, right: 12, top: 6, bottom: 8),
                    child: child,
                  ),
                ),
                if (footer != null)
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: footerColor ?? foregroundColor,
                      borderRadius: BorderRadius.only(
                        topLeft: radius,
                        topRight: radius,
                      ),
                    ),
                    child: Padding(
                      padding:
                          const EdgeInsets.only(right: 8, top: 4, bottom: 4),
                      child: footer,
                    ),
                  ),
              ]),
        ),
      );
    });
  }
}
