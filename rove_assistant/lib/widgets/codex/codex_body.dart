import 'package:flutter/material.dart';
import 'package:rove_assistant/theme/rove_palette.dart';
import 'package:rove_assistant/theme/rove_theme.dart';
import 'package:rove_assistant/widgets/common/rove_text.dart';
import 'package:rove_data_types/rove_data_types.dart';

class CodexBody extends StatelessWidget {
  const CodexBody({
    super.key,
    required this.codex,
  });

  final Codex codex;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        spacing: RoveTheme.verticalSpacing,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (codex.subtitle != null)
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RoveText.subtitle('${codex.subtitle}', color: RovePalette.body),
                SizedBox(
                    width: double.infinity,
                    child: Divider(
                      color: RovePalette.body,
                      thickness: 2,
                      height: 0,
                    )),
              ],
            ),
          RoveText.body(codex.body),
        ],
      ),
    );
  }
}
