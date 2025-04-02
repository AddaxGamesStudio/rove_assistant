import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rove_app_common/style/rove_palette.dart';
import 'package:rove_app_common/style/rove_theme.dart';
import 'package:rove_app_common/widgets/common/rove_dialog.dart';

Future<String?> showTextInputDialog(
    {required BuildContext context, required String title}) async {
  final completer = Completer<String>();
  await showDialog(
      context: context,
      builder: (context) {
        final textController = TextEditingController();
        return RoveDialog(
            title: title,
            body: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: RoveTheme.verticalSpacing,
              children: [
                TextField(
                  controller: textController,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    RoveDialogCancelButton(onPressed: () {
                      Navigator.of(context).pop();
                    }),
                    const SizedBox(width: 8),
                    RoveDialogActionButton(
                        color: RovePalette.title,
                        title: 'Continue',
                        onPressed: () {
                          completer.complete(textController.text);
                          Navigator.of(context).pop();
                        }),
                  ],
                ),
              ],
            ));
      });
  return completer.isCompleted ? completer.future : null;
}
