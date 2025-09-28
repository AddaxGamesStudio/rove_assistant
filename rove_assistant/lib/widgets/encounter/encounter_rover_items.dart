import 'package:flutter/material.dart';
import 'package:rove_assistant/theme/rove_theme.dart';
import 'package:rove_assistant/model/items_model.dart';
import 'package:rove_assistant/model/players_model.dart';
import 'package:rove_assistant/widgets/items/item_image.dart';
import 'package:rove_assistant/widgets/common/rove_dialog.dart';
import 'package:rove_assistant/widgets/common/rover_action_button.dart';
import 'package:rove_assistant/widgets/items/already_equipped_dialog.dart';
import 'package:rove_assistant/widgets/items/unequip_to_equip_dialog.dart';
import 'package:rove_data_types/rove_data_types.dart';
import 'package:rove_assistant/model/encounter/encounter_model.dart';

class EncounterRoverItems extends StatelessWidget {
  final Player player;
  final EncounterModel model;

  static const double height = 200.0;

  const EncounterRoverItems({
    super.key,
    required this.player,
    required this.model,
  });

  onConfirmedItemsToUnequip(BuildContext context, List<ItemDef> selectedItems,
      ItemDef item, bool isReward) {
    for (final item in selectedItems) {
      model.unequipItem(player: player, item: item);
    }
    model.equipItem(player: player, item: item, isReward: isReward);
    Navigator.of(context).pop();
  }

  onUse(BuildContext context, EncounterItemState itemState) {
    assert(itemState.equipped);
    assert(!itemState.exhausted);
    model.exhaustItem(player: player, item: itemState.item);
    Navigator.of(context).pop();
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
                        context, selectedItems, item, itemState.reward);
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
        Navigator.of(context).pop();
        break;
    }
  }

  onUnequip(BuildContext context, EncounterItemState itemState) {
    model.unequipItem(player: player, item: itemState.item);
    Navigator.of(context).pop();
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
              final exhausted = itemState.exhausted;
              final isEquipped = itemState.equipped;
              return SizedBox(
                width: double.infinity,
                child: Column(
                    spacing: RoveTheme.verticalSpacing,
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ItemImage(item.name, disabled: !isEquipped),
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
                      if (isEquipped &&
                          !exhausted &&
                          item.slotType != ItemSlotType.pocket)
                        SizedBox(
                            width: double.infinity,
                            child: RoverActionButton(
                                label: 'Use',
                                roverClass: player.roverClass,
                                onPressed: () {
                                  onUse(context, itemState);
                                })),
                      if (isEquipped && !exhausted)
                        SizedBox(
                            width: double.infinity,
                            child: RoverActionButton(
                                label: 'Unequip',
                                roverClass: player.roverClass,
                                onPressed: () {
                                  onUnequip(context, itemState);
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
                    ]),
              );
            }));
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: model,
        builder: (context, _) {
          final items = model.itemsForPlayer(player);
          return ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              separatorBuilder: (context, index) => SizedBox(
                    width: RoveTheme.verticalSpacing,
                  ),
              itemBuilder: (context, index) {
                final itemState = items[index];
                final item = itemState.item;
                final consumed = itemState.consumed;
                final exhausted = itemState.exhausted;
                final isEquipped = itemState.equipped;
                return RotatedBox(
                  quarterTurns: exhausted ? 1 : 0,
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
                    child: ItemImage(
                      item.name,
                      disabled: !isEquipped,
                      height: height,
                      showBack: consumed,
                    ),
                  ),
                );
              });
        });
  }
}
