import 'package:flutter/material.dart';
import 'package:rove_app_common/model/items_model.dart';
import 'package:rove_app_common/style/rove_theme.dart';
import 'package:rove_app_common/widgets/common/rove_dialog.dart';
import 'package:rove_app_common/widgets/items/already_equipped_dialog.dart';
import 'package:rove_app_common/widgets/items/unequip_to_equip_dialog.dart';
import 'package:rove_data_types/rove_data_types.dart';
import 'package:rove_app_common/model/campaign_model.dart';
import 'package:rove_app_common/model/players_model.dart';
import 'package:rove_assistant/model/encounter_model.dart';
import 'package:rove_assistant/ui/styles.dart';
import 'package:rove_app_common/widgets/common/rover_action_button.dart';

class EncounterRoverItems extends StatelessWidget {
  final Player player;
  final EncounterModel model;

  const EncounterRoverItems({
    super.key,
    required this.player,
    required this.model,
  });

  onConfirmedItemsToUnequip(
      List<ItemDef> selectedItems, ItemDef item, bool isReward) {
    for (final item in selectedItems) {
      model.unequipItem(player: player, item: item);
    }
    model.equipItem(player: player, item: item, isReward: isReward);
  }

  onEquip(BuildContext context, EncounterItemState itemState) {
    final item = itemState.item;
    final result = model.equipItem(
        player: player, item: itemState.item, isReward: itemState.reward);
    switch (result) {
      case EquipItemResult.noSlot:
        showDialog(
            context: context,
            builder: (context) {
              return UnequipToEquipDialog(
                  player: player,
                  item: item,
                  equippedEncounterItems:
                      model.equippedEncounterItemsForPlayer(player),
                  onConfirmedItemsToUnequip: (selectedItems) {
                    onConfirmedItemsToUnequip(
                        selectedItems, item, itemState.reward);
                  });
            });
        break;
      case EquipItemResult.alreadyEquipped:
        showDialog(
            context: context,
            builder: (context) {
              return AlreadyEquippedDialog(
                player: player,
                itemName: item.name,
              );
            });
        break;
      case EquipItemResult.success:
        break;
    }
  }

  onUnequip(EncounterItemState itemState) {
    model.unequipItem(player: player, item: itemState.item);
  }

  RoveDialog dialogForItem(BuildContext context,
      {required Player player, required EncounterItemState itemState}) {
    final item = itemState.item;
    return RoveDialog.fromRoverClass(
        roverClass: player.roverClass,
        title: item.name,
        body: ListenableBuilder(
            listenable: model,
            builder: (context, _) {
              final isEquipped = itemState.equipped;
              return Column(
                  spacing: RoveTheme.verticalSpacing,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    RoveStyles.itemImage(item.name, unequipped: !isEquipped),
                    if (item.slotType == ItemSlotType.pocket)
                      SizedBox(
                          width: double.infinity,
                          child: RoverActionButton(
                              label: 'Consume',
                              roverClass: player.roverClass,
                              onPressed: () {
                                Navigator.of(context).pop();
                                model.consumeItem(player: player, item: item);
                              })),
                    if (isEquipped)
                      SizedBox(
                          width: double.infinity,
                          child: RoverActionButton(
                              label: 'Unequip',
                              roverClass: player.roverClass,
                              onPressed: () {
                                onUnequip(itemState);
                              })),
                    if (!isEquipped)
                      SizedBox(
                          width: double.infinity,
                          child: RoverActionButton(
                              label: 'Equip',
                              roverClass: player.roverClass,
                              onPressed: () {
                                onEquip(context, itemState);
                              })),
                  ]);
            }));
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: model,
        builder: (context, _) {
          final items = model.itemsForPlayer(player);
          return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              itemBuilder: (context, index) {
                final itemState = items[index];
                final item = itemState.item;
                final consumed = itemState.consumed;
                final imgPath = CampaignModel.instance
                    .assetForItem(itemName: item.name, back: consumed);
                final isEquipped = itemState.equipped;
                return Container(
                  margin: const EdgeInsets.all(12),
                  child: GestureDetector(
                    onTap: () {
                      if (consumed) {
                        return;
                      }
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return dialogForItem(context,
                                player: player, itemState: itemState);
                          });
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.asset(
                        imgPath,
                        fit: BoxFit.contain,
                        color: isEquipped ? null : Colors.grey,
                        colorBlendMode: BlendMode.saturation,
                      ),
                    ),
                  ),
                );
              });
        });
  }
}
