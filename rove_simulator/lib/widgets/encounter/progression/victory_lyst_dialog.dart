import 'package:flutter/material.dart';
import 'package:rove_app_common/style/rove_palette.dart';
import 'package:rove_simulator/flame/encounter_game.dart';
import 'package:rove_app_common/widgets/common/lyst_text.dart';
import 'package:rove_simulator/widgets/encounter/progression/victory_dialog.dart';

class VictoryLystDialog extends StatelessWidget with VictoryDialog {
  @override
  final EncounterGame game;

  const VictoryLystDialog({super.key, required this.game});

  static const String overlayName = 'victory_lyst';

  @override
  Widget build(BuildContext context) {
    final lystRewards = game.rewardController.lystRewards;
    final totalLyst =
        lystRewards.fold<int>(0, (acc, reward) => acc + reward.$2);
    return VictoryDialogScaffold(
      title: 'VICTORY!',
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (lystRewards.isNotEmpty)
            _LystTally(lystRewards: lystRewards, totalLyst: totalLyst),
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
  RewardStage get currentStage => RewardStage.lyst;
}

class _LystTally extends StatelessWidget {
  const _LystTally({
    required this.lystRewards,
    required this.totalLyst,
  });

  final List<(String, int)> lystRewards;
  final int totalLyst;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 240, maxWidth: 320),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ...lystRewards
              .map((reward) => _LystRow(title: reward.$1, amount: reward.$2)),
          if (lystRewards.length > 1)
            const Divider(
              color: Colors.white,
            ),
          if (lystRewards.length > 1)
            _LystRow(title: 'Total', amount: totalLyst)
        ],
      ),
    );
  }
}

class _LystRow extends StatelessWidget {
  final String title;
  final int amount;
  const _LystRow({
    required this.title,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    const color = Colors.white;
    const fontSize = 12.0;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
            child: Text(
          title,
          style: const TextStyle(color: color, fontSize: fontSize),
        )),
        SizedBox(
            width: 50,
            child: Text.rich(
              TextSpan(
                  children: LystText.spansForLyst(amount.toString(),
                      color: color, fontSize: fontSize)),
              textAlign: TextAlign.right,
              style: const TextStyle(color: color),
            )),
      ],
    );
  }
}
