import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rove_simulator/flame/encounter_game.dart';
import 'package:rove_app_common/style/rove_palette.dart';
import 'package:rove_simulator/style/rove_theme.dart';

class FailureDialog extends StatelessWidget {
  final EncounterGame game;

  static const String overlayName = 'failure';

  const FailureDialog({super.key, required this.game});

  dismiss() {
    game.overlays.remove(FailureDialog.overlayName);
  }

  onQuitEncounter(BuildContext context) {
    dismiss();
    game.quit(context);
  }

  onRestartRound() {
    game.restartRound();
    dismiss();
  }

  onRestartEncounter() {
    game.restart();
    dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return RoveThemeWidget(
        child: Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.black.withValues(alpha: 0.75),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(),
                  Text(
                    'ENCOUNTER FAILED',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: RovePalette.lossForeground,
                        fontSize: 72,
                        fontFamily: GoogleFonts.grenze().fontFamily),
                  ),
                  const Spacer(),
                  Row(spacing: 8, children: [
                    const Spacer(),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.fast_rewind),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: RovePalette.lossForeground),
                      onPressed: () {
                        onRestartRound();
                      },
                      label: const Text('Restart From Last Round'),
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.restart_alt),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: RovePalette.lossForeground),
                      onPressed: () {
                        onRestartEncounter();
                      },
                      label: const Text('Restart Encounter'),
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.exit_to_app),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: RovePalette.lossForeground),
                      onPressed: () {
                        onQuitEncounter(context);
                      },
                      label: const Text('Quit'),
                    ),
                    const Spacer(),
                  ]),
                  const Spacer(),
                ],
              ),
            )));
  }
}
