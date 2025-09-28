import 'package:flutter/material.dart';
import 'package:rove_assistant/theme/rove_theme.dart';
import 'package:rove_assistant/model/items_model.dart';
import 'package:rove_assistant/model/players_model.dart';
import 'package:rove_assistant/widgets/items/item_image.dart';
import 'package:rove_assistant/widgets/common/player_buttons.dart';
import 'package:rove_assistant/widgets/common/rove_dialog.dart';
import 'package:rove_assistant/widgets/common/rover_action_button.dart';
import 'package:rove_assistant/widgets/items/already_equipped_dialog.dart';
import 'package:rove_assistant/widgets/items/unequip_to_equip_dialog.dart';
import 'package:rove_data_types/rove_data_types.dart';

class RoverItemDialog extends StatelessWidget {
  final RoverClass roverClass;
  final String itemName;
  final bool equipped;
  final Function() onOptionSelected;
  const RoverItemDialog(
      {super.key,
      required this.roverClass,
      required this.itemName,
      required this.equipped,
      required this.onOptionSelected});

  @override
  Widget build(BuildContext context) {
    final model = ItemsModel.instance;

    Widget fullWidthActionButton(
        {required String title,
        required RoverClass roverClass,
        required Function() onPressed}) {
      return SizedBox(
          width: double.infinity,
          child: RoverActionButton(
              label: title, roverClass: roverClass, onPressed: onPressed));
    }

    handleEquipItemResult(EquipItemResult result, Player player, ItemDef item,
        {bool warmIfAlreadyEquipped = false}) {
      switch (result) {
        case EquipItemResult.noSlot:
          showDialog(
              context: context,
              builder: (context) {
                return UnequipToEquipDialog(player: player, item: item);
              });
          break;
        case EquipItemResult.alreadyEquipped:
          if (!warmIfAlreadyEquipped) {
            return;
          }
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

    onEquip(BuildContext context, Player player, ItemDef item) {
      final result = model.equipItem(
          baseClassName: player.baseClassName, itemName: itemName);
      Navigator.of(context).pop();
      onOptionSelected();
      handleEquipItemResult(result, player, item, warmIfAlreadyEquipped: true);
    }

    onTransfer(BuildContext context, Player fromPlayer, Player toPlayer,
        ItemDef item) {
      final result = model.transferItem(
          fromBaseClass: fromPlayer.baseClassName,
          toBaseClass: toPlayer.baseClassName,
          itemName: item.name);
      Navigator.of(context).pop();
      onOptionSelected();
      handleEquipItemResult(result, toPlayer, item);
    }

    return RoveDialog.fromRoverClass(
        roverClass: roverClass,
        title: 'Manage Item',
        body: ListenableBuilder(
            listenable: model,
            builder: (context, _) {
              final List<Widget> children = [
                Flexible(child: ItemImage(itemName)),
              ];

              ItemDef item = model.itemForName(itemName);
              final player =
                  PlayersModel.instance.playerForClass(roverClass.name);
              if (equipped) {
                children.add(fullWidthActionButton(
                    title: 'Unequip',
                    roverClass: roverClass,
                    onPressed: () {
                      model.unequipItem(player: player, item: item);
                      Navigator.of(context).pop();
                      onOptionSelected();
                    }));
              } else {
                children.add(fullWidthActionButton(
                    title: 'Equip',
                    roverClass: roverClass,
                    onPressed: () {
                      onEquip(context, player, item);
                    }));
              }
              children.add(fullWidthActionButton(
                  title: 'Sell for ${item.sellPrice} [lyst]',
                  roverClass: roverClass,
                  onPressed: () {
                    model.sellItem(
                        baseClassName: roverClass.baseClass.name,
                        itemName: itemName);
                    Navigator.of(context).pop();
                    onOptionSelected();
                  }));
              if (item.slotType == ItemSlotType.pocket) {
                children.add(fullWidthActionButton(
                    title: 'Consume',
                    roverClass: roverClass,
                    onPressed: () {
                      model.consumeItem(
                          baseClassName: roverClass.baseClass.name,
                          itemName: itemName);
                      Navigator.of(context).pop();
                      onOptionSelected();
                    }));
              }
              children.add(PlayerButtons(
                  buttonLabelBuilder: (toPlayer) => 'Give to ${toPlayer.name}',
                  skipClass: roverClass,
                  onSelected: (toPlayer) {
                    onTransfer(context, player, toPlayer, item);
                  }));

              return Column(
                  spacing: RoveTheme.verticalSpacing,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: children);
            }));
  }
}
