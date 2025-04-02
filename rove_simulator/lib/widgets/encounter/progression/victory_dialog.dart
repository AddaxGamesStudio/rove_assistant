import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rove_app_common/style/rove_palette.dart';
import 'package:rove_data_types/rove_data_types.dart';
import 'package:rove_simulator/flame/encounter_game.dart';
import 'package:rove_simulator/style/rove_theme.dart';
import 'package:rove_simulator/widgets/encounter/progression/victory_ether_reward.dart';
import 'package:rove_simulator/widgets/encounter/progression/victory_level_up_dialog.dart';
import 'package:rove_simulator/widgets/encounter/progression/victory_reward_items_dialog.dart';
import 'package:rove_simulator/widgets/encounter/progression/victory_shop_unlocked_dialog.dart';

enum RewardStage {
  lyst(0),
  items(1),
  ether(2),
  shop(3),
  level(4);

  final int order;

  const RewardStage(this.order);
}

class VictoryDialogScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final Widget footer;

  const VictoryDialogScaffold(
      {super.key,
      required this.title,
      required this.body,
      required this.footer});

  @override
  Widget build(BuildContext context) {
    return RoveThemeWidget(
        child: Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.black.withValues(alpha: 0.75),
            child: Center(
                child: Padding(
              padding: const EdgeInsets.only(top: 160, bottom: 48),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: RovePalette.victoryForeground,
                        fontSize: 72,
                        fontFamily: GoogleFonts.grenze().fontFamily),
                  ),
                  const Spacer(),
                  body,
                  const Spacer(),
                  footer
                ],
              ),
            ))));
  }
}

mixin VictoryDialog on Widget {
  EncounterGame get game;

  static showNextStageOrExit(BuildContext context,
      {required EncounterGame game, required RewardStage currentStage}) {
    final encounter = game.model.encounter;
    if (encounter.itemRewards.isNotEmpty &&
        currentStage.order < RewardStage.items.order) {
      game.showDialog(VictoryRewardItemsDialog.overlayName,
          (game) => VictoryRewardItemsDialog(game: game));
    } else if (encounter.etherRewards.isNotEmpty &&
        currentStage.order < RewardStage.ether.order) {
      game.showDialog(VictoryEtherReward.overlayName,
          (game) => VictoryEtherReward(game: game));
    } else if (encounter.unlocksShopLevel > 0 &&
        currentStage.order < RewardStage.shop.order) {
      game.showDialog(VictoryShopUnlockedDialog.overlayName,
          (game) => VictoryShopUnlockedDialog(game: game));
    } else if (encounter.unlocksRoverLevel > 0 &&
        currentStage.order < RewardStage.level.order) {
      game.showDialog(VictoryLevelUpDialog.overlayName,
          (game) => VictoryLevelUpDialog(game: game));
    } else {
      game.quit(context);
    }
  }

  static bool isTerminalForStage(
      EncounterDef encounter, RewardStage currentStage) {
    final hasReward = [
      encounter.itemRewards.isNotEmpty,
      encounter.etherRewards.isNotEmpty,
      encounter.unlocksShopLevel > 0,
      encounter.unlocksRoverLevel > 0,
    ];
    final currentOrder = currentStage.order;
    if (currentOrder >= hasReward.length) {
      return true;
    }
    return hasReward.sublist(currentOrder).any((r) => r);
  }

  RewardStage get currentStage;

  onContinue(BuildContext context) {
    game.dismissDialog();
    showNextStageOrExit(context, game: game, currentStage: currentStage);
  }

  bool get isTerminal => isTerminalForStage(game.model.encounter, currentStage);

  IconData get iconData => isTerminal ? Icons.exit_to_app : Icons.arrow_forward;
}
