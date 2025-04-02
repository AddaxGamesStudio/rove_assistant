import 'package:flutter/material.dart';
import 'package:rove_app_common/style/rove_app_assets.dart';
import 'package:rove_app_common/style/rove_palette.dart';
import 'package:rove_app_common/style/rove_theme.dart';
import 'package:rove_app_common/widgets/common/rove_dialog.dart';

class RoveConfirmDialog extends StatelessWidget {
  final String title;
  final String? message;
  final Widget? messageText;
  final Color color;
  final String iconAsset;
  final String confirmTitle;
  final bool hideCancelButton;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;

  const RoveConfirmDialog({
    super.key,
    required this.title,
    this.message,
    this.messageText,
    this.color = RovePalette.title,
    this.confirmTitle = 'Confirm',
    this.iconAsset = RoveAppAssets.iconEtherPath,
    this.onConfirm,
    this.onCancel,
    this.hideCancelButton = false,
  }) : assert(messageText != null || message != null);

  @override
  Widget build(BuildContext context) {
    return RoveDialog(
      title: title,
      color: color,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: RoveTheme.verticalSpacing,
        mainAxisSize: MainAxisSize.min,
        children: [
          messageText ?? Text(message!),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            spacing: RoveTheme.horizontalSpacing,
            children: [
              if (!hideCancelButton)
                RoveDialogCancelButton(onPressed: () {
                  Navigator.of(context).pop();
                  if (onCancel case final callback?) {
                    callback();
                  }
                }),
              RoveDialogActionButton(
                  color: color,
                  title: confirmTitle,
                  onPressed: () {
                    Navigator.of(context).pop();
                    if (onConfirm case final callback?) {
                      callback();
                    }
                  }),
            ],
          ),
        ],
      ),
    );
  }
}
