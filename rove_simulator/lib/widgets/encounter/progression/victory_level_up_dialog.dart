import 'package:flutter/material.dart';
import 'package:rove_app_common/data/progression_data.dart';
import 'package:rove_app_common/style/rove_palette.dart';
import 'package:rove_simulator/flame/encounter_game.dart';
import 'package:rove_simulator/widgets/encounter/progression/victory_dialog.dart';

class VictoryLevelUpDialog extends StatelessWidget with VictoryDialog {
  @override
  final EncounterGame game;

  const VictoryLevelUpDialog({super.key, required this.game});

  static const String overlayName = 'victory_level_up';
  int get level => game.model.encounter.unlocksRoverLevel;

  @override
  Widget build(BuildContext context) {
    return VictoryDialogScaffold(
      title: 'Level Up',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Rovers are now level $level! ${ProgressionData.descriptionForLevel(level)}',
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
      footer: Row(spacing: 8, children: [
        const Spacer(),
        ElevatedButton.icon(
          icon: Icon(iconData),
          style: ElevatedButton.styleFrom(
              backgroundColor: RovePalette.victoryForeground),
          onPressed: () {
            onContinue(context);
          },
          label: const Text('Continue'),
        ),
        const Spacer(),
      ]),
    );
  }

  @override
  RewardStage get currentStage => RewardStage.level;
}
