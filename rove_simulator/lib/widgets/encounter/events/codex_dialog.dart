import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rove_app_common/widgets/common/rove_text.dart';
import 'package:rove_simulator/controller/codex_controller.dart';
import 'package:rove_app_common/style/rove_palette.dart';
import 'package:rove_simulator/style/rove_theme.dart';
import 'package:rove_simulator/widgets/game_dialog.dart';

class CodexDialog extends StatelessWidget {
  final CodexController controller;
  final String title;
  final String page;

  const CodexDialog({
    super.key,
    required this.controller,
    required this.title,
    required this.page,
  });

  onContinue() {
    controller.dismissCodexDialog();
  }

  @override
  Widget build(BuildContext context) {
    return GameDialog(
      color: RovePalette.codexForeground,
      child: SizedBox(
        width: 100,
        height: 140,
        child: RoveThemeWidget(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Codex: $title',
                textAlign: TextAlign.center,
                style: GoogleFonts.grenze(
                    color: RovePalette.codexForeground, fontSize: 18),
              ),
              const Spacer(),
              RoveText(
                'Go to page $page of the Codex book and read section "**$title**".',
              ),
              const Spacer(),
              ElevatedButton.icon(
                icon: const Icon(Icons.forward),
                style: ElevatedButton.styleFrom(
                    backgroundColor: RovePalette.codexForeground),
                onPressed: () {
                  onContinue();
                },
                label: const Text('Continue'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
