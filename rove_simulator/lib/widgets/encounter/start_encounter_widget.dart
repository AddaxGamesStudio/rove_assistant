import 'package:flutter/material.dart';
import 'package:rove_simulator/flame/encounter_game.dart';
import 'package:rove_simulator/style/rove_theme.dart';

class StartEncounterWidget extends StatelessWidget {
  final EncounterGame game;

  const StartEncounterWidget({super.key, required this.game});

  static const String overlayName = 'start_encounter';

  onStartEncounter() {
    game.turnController.startEncounter();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: game,
        builder: (context, _) {
          return RoveThemeWidget(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 12,
              children: [
                const SizedBox(
                  width: 400,
                  child: Text(
                    'Choose starting positions. Double-click on skills and reactions to toggle starting side.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.start),
                  onPressed: () {
                    onStartEncounter();
                  },
                  label: const Text('Start Encounter'),
                ),
              ],
            ),
          );
        });
  }
}
