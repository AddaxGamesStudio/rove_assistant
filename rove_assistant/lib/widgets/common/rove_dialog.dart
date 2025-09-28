import 'package:flutter/material.dart';
import 'package:rove_assistant/theme/rove_assets.dart';
import 'package:rove_assistant/theme/rove_palette.dart';
import 'package:rove_assistant/theme/rove_theme.dart';
import 'package:rove_assistant/model/players_model.dart';
import 'rove_page.dart';
import 'rove_text.dart';
import 'package:rove_data_types/rove_data_types.dart';

class RoveDialog extends StatelessWidget {
  final String? title;
  final Color? titleColor;
  final Color color;
  final Color? backgroundColor;
  final bool hideIcon;
  final String iconAssetPath;
  final Widget body;
  final EdgeInsetsGeometry padding;

  const RoveDialog({
    super.key,
    this.title,
    this.titleColor,
    this.color = RovePalette.title,
    this.backgroundColor,
    this.hideIcon = false,
    String? iconAssetPath,
    this.padding = const EdgeInsets.all(16),
    required this.body,
  }) : iconAssetPath = iconAssetPath ?? RoveAssets.iconEtherPath;

  @factory
  static fromRoverClass({
    required RoverClass roverClass,
    String? title,
    required Widget body,
  }) {
    return RoveDialog(
        title: title,
        color: roverClass.color,
        iconAssetPath: roverClass.iconAsset,
        body: body);
  }

  @override
  Widget build(BuildContext context) {
    ImageIcon icon = ImageIcon(
      AssetImage(iconAssetPath),
      color: Colors.white,
      size: 100,
    );

    return Dialog(
        backgroundColor: backgroundColor,
        shape: BeveledRectangleBorder(
          side: BorderSide(width: 2, color: color),
          borderRadius: RoveTheme.bevelBorderRadius,
        ),
        child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: RoveTheme.dialogMinWidth,
              maxWidth: RoveTheme.dialogMaxWidth,
            ),
            child: RovePage(
                color: color,
                hideIcon: hideIcon,
                icon: icon,
                title: title,
                titleColor: titleColor ?? Colors.black54,
                padding: padding,
                child: body)));
  }
}

class RoveDialogCancelButton extends StatelessWidget {
  final Function() onPressed;

  const RoveDialogCancelButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: TextButton.styleFrom(
          foregroundColor: Colors.grey,
        ),
        onPressed: onPressed,
        child: const Text('Cancel'));
  }
}

class RoveDialogActionButton extends StatelessWidget {
  final Function() onPressed;
  final String title;
  final Color color;

  const RoveDialogActionButton(
      {super.key,
      required this.title,
      required this.color,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: color,
          shape: const BeveledRectangleBorder(
            borderRadius: RoveTheme.bevelBorderRadius,
          )),
      onPressed: onPressed,
      child: RoveText(title,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold)),
    );
  }
}
