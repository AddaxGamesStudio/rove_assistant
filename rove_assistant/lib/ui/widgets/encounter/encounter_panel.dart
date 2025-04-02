import 'package:flutter/material.dart';
import 'package:rove_app_common/style/rove_theme.dart';
import 'package:rove_app_common/widgets/common/rove_text.dart';

class EncounterPanel extends StatelessWidget {
  const EncounterPanel({
    super.key,
    required this.title,
    required this.icon,
    required this.foregroundColor,
    required this.backgroundColor,
    this.footerColor,
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
                    padding: const EdgeInsets.only(right: 8, top: 4, bottom: 4),
                    child: footer,
                  ),
                ),
            ]),
      ),
    );
  }
}
