import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rove_app_common/style/rove_app_assets.dart';
import 'package:rove_app_common/style/rove_theme.dart';
import 'package:rove_app_common/widgets/common/rove_text.dart';

class RovePage extends StatelessWidget {
  final Color color;
  final Color titleColor;
  final EdgeInsetsGeometry padding;
  final ImageIcon icon;
  final bool hideIcon;
  final String? title;
  final Widget child;

  RovePage({
    super.key,
    required this.color,
    this.titleColor = Colors.black54,
    this.hideIcon = false,
    ImageIcon? icon,
    required this.title,
    this.padding = const EdgeInsets.all(16),
    required this.child,
  }) : icon = icon ??
            ImageIcon(AssetImage(RoveAppAssets.iconEtherPath),
                color: Colors.white, size: 100);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        if (!hideIcon)
          Positioned(
              right: 15,
              top: 15,
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  color.withValues(alpha: 0.1),
                  BlendMode.srcATop,
                ),
                child: icon,
              )),
        Padding(
            padding: padding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              spacing: RoveTheme.verticalSpacing,
              children: [
                if (title case final value?)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: RoveText(value,
                        style: GoogleFonts.grenze(
                          color: titleColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 24,
                        )),
                  ),
                Flexible(child: child),
              ],
            )),
      ],
    );
  }
}
