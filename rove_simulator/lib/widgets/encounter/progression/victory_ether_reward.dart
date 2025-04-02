import 'package:flutter/material.dart';
import 'package:rove_app_common/style/rove_palette.dart';
import 'package:rove_app_common/style/rove_theme.dart';
import 'package:rove_data_types/rove_data_types.dart';
import 'package:rove_simulator/flame/encounter_game.dart';
import 'package:rove_simulator/widgets/encounter/progression/victory_dialog.dart';

class VictoryEtherReward extends StatelessWidget with VictoryDialog {
  @override
  final EncounterGame game;

  const VictoryEtherReward({super.key, required this.game});

  static const String overlayName = 'victory_ether_reward';
  List<Ether> get ether => game.model.encounter.etherRewards;

  @override
  Widget build(BuildContext context) {
    List<Widget> etherImages = ether
        .map((e) => Padding(
            padding: const EdgeInsets.only(right: 8, left: 8),
            child: Image.asset(
                'assets/images/ether_${e.name.toLowerCase()}.png',
                width: 64,
                height: 64)))
        .toList();
    String etherText = ether.length > 1 ? 'these ether' : 'a ${ether[0].label}';
    return VictoryDialogScaffold(
      title: 'Ether Reward',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(children: [const Spacer(), ...etherImages, const Spacer()])
        ],
      ),
      footer: Column(
        spacing: RoveTheme.verticalSpacing,
        children: [
          Text(
            'Rovers start the next encounter with $etherText dice in their personal pool.',
            style: const TextStyle(color: Colors.white),
          ),
          Row(spacing: 8, children: [
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
        ],
      ),
    );
  }

  @override
  RewardStage get currentStage => RewardStage.ether;
}
