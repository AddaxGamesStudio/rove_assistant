import 'package:flutter/material.dart';
import 'package:rove_simulator/flame/encounter_game.dart';
import 'package:rove_simulator/model/encounter_model.dart';
import 'package:rove_app_common/style/rove_palette.dart';
import 'package:rove_simulator/style/rove_theme.dart';
import 'package:rove_simulator/widgets/game_dialog.dart';

class EncounterMenu extends StatelessWidget {
  final EncounterGame game;
  EncounterModel get encounter => game.model;

  static const String overlayName = 'encounter_menu';

  const EncounterMenu({super.key, required this.game});

  dismiss() {
    game.overlays.remove(EncounterMenu.overlayName);
  }

  onRestartTurn() {
    game.restartTurn();
    dismiss();
  }

  onRestartRound() {
    game.restartRound();
    dismiss();
  }

  onQuitEncounter(BuildContext context) {
    dismiss();
    game.quit(context);
  }

  onRestartEncounter() {
    game.restart();
    dismiss();
  }

  @override
  Widget build(BuildContext context) {
    final canRestartTurn = encounter.startOfTurnData != null;
    final canRestartRound = encounter.startOfRoundData != null;
    return GameDialog(
        color: RovePalette.title,
        child: RoveThemeWidget(
          child: SizedBox(
            height: 240,
            width: 240,
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  right: 0,
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: dismiss,
                  ),
                ),
                Positioned.fill(
                    child: Column(spacing: 8, children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text(
                      'Menu',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: 200,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.undo),
                      onPressed: canRestartTurn
                          ? () {
                              onRestartTurn();
                            }
                          : null,
                      label: const Text('Restart Turn'),
                    ),
                  ),
                  SizedBox(
                    width: 200,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.fast_rewind),
                      onPressed: canRestartRound
                          ? () {
                              onRestartRound();
                            }
                          : null,
                      label: const Text('Restart Round'),
                    ),
                  ),
                  SizedBox(
                    width: 200,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.restart_alt),
                      onPressed: () {
                        onRestartEncounter();
                      },
                      label: const Text('Restart Encounter'),
                    ),
                  ),
                  SizedBox(
                    width: 200,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.exit_to_app),
                      onPressed: () {
                        onQuitEncounter(context);
                      },
                      label: const Text('Quit Encounter'),
                    ),
                  ),
                  const Spacer(),
                ]))
              ],
            ),
          ),
        ));
  }
}
