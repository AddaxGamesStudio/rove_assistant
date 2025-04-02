import 'package:flutter/material.dart';
import 'package:rove_assistant/model/encounter_model.dart';
import 'package:rove_assistant/ui/styles.dart';
import 'package:rove_app_common/widgets/common/player_buttons.dart';
import 'package:rove_assistant/ui/widgets/rewards_dialog.dart';
import 'package:rove_data_types/rove_data_types.dart';

class RewardItemPanel extends RewardPanel {
  final EncounterModel model;
  final ItemDef item;
  const RewardItemPanel(
      {super.key,
      required this.model,
      required this.item,
      required super.onContinue});

  @override
  String get title => 'Item Reward';

  @override
  Widget buildBody(BuildContext context) {
    return RoveStyles.itemImage(item.name);
  }

  @override
  Widget buildActions(BuildContext context) {
    return PlayerButtons(
        buttonLabelBuilder: (Player player) => 'Send to ${player.name}',
        onSelected: (player) {
          model.giveItem(player: player, item: item);
          onContinue();
        });
  }
}
