import 'package:flutter/material.dart';
import 'package:rove_app_common/model/items_model.dart';
import 'package:rove_app_common/style/rove_theme.dart';
import 'package:rove_app_common/widgets/common/item_image.dart';
import 'package:rove_app_common/widgets/common/player_buttons.dart';
import 'package:rove_app_common/widgets/items/unequip_to_equip_dialog.dart';
import 'package:rove_data_types/rove_data_types.dart';
import 'package:rove_simulator/flame/encounter_game.dart';
import 'package:rove_simulator/widgets/encounter/progression/victory_dialog.dart';

class VictoryRewardItemsDialog extends StatefulWidget with VictoryDialog {
  @override
  final EncounterGame game;

  const VictoryRewardItemsDialog({super.key, required this.game});

  static const String overlayName = 'victory_reward_items';

  @override
  State<VictoryRewardItemsDialog> createState() =>
      _VictoryRewardItemsDialogState();

  @override
  RewardStage get currentStage => RewardStage.items;
}

class _VictoryRewardItemsDialogState extends State<VictoryRewardItemsDialog> {
  List<String> awardedItems = [];

  onContinue(BuildContext context) {
    widget.onContinue(context);
  }

  List<String> get itemRewards => widget.game.model.encounter.itemRewards;

  onItemAwarded(String itemName) {
    setState(() {
      awardedItems.add(itemName);
      if (awardedItems.length == itemRewards.length) {
        onContinue(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final title = itemRewards.length > 1 ? 'Item Rewards' : 'Item Reward';
    return VictoryDialogScaffold(
      title: title,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 48,
            children: itemRewards
                .map((itemName) =>
                    _ItemReward(itemName, awardedItems.contains(itemName), () {
                      onItemAwarded(itemName);
                    }))
                .toList(),
          ),
        ],
      ),
      footer: const Text(
        'Rovers can also trade items in between encounters.',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}

class _ItemReward extends StatelessWidget {
  final String itemName;
  final Function onAwarded;
  final bool awarded;

  const _ItemReward(this.itemName, this.awarded, this.onAwarded);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: RoveTheme.verticalSpacing,
      children: [
        ItemImage(itemName),
        if (!awarded)
          SizedBox(
            width: 200,
            child: PlayerButtons(
                buttonLabelBuilder: (Player player) => 'Send to ${player.name}',
                onSelected: (player) {
                  final result = ItemsModel.instance.giveItem(
                      className: player.baseClassName, itemName: itemName);
                  onAwarded();
                  if (result == EquipItemResult.noSlot) {
                    showDialog(
                        context: context,
                        builder: (context) {
                          final item =
                              ItemsModel.instance.itemForName(itemName);
                          return UnequipToEquipDialog(
                              player: player, item: item);
                        });
                  }
                }),
          )
      ],
    );
  }
}
