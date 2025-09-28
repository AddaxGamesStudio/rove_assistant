import 'package:flutter/material.dart';
import 'package:rove_assistant/theme/rove_palette.dart';
import 'package:rove_assistant/theme/rove_theme.dart';
import 'package:rove_assistant/model/items_model.dart';
import 'package:rove_assistant/model/players_model.dart';
import 'package:rove_assistant/widgets/items/item_image.dart';
import 'package:rove_assistant/widgets/common/player_buttons.dart';
import 'package:rove_assistant/widgets/common/rove_dialog.dart';
import 'package:rove_assistant/widgets/common/rove_text.dart';
import 'package:rove_assistant/widgets/common/rover_action_button.dart';
import '../items/unequip_to_equip_dialog.dart';
import 'package:rove_data_types/rove_data_types.dart';

class ShopItemDialog extends StatelessWidget {
  final ItemDef item;
  final Player? seller;

  const ShopItemDialog({super.key, required this.item, this.seller});

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = [
      ItemImage(item.name),
    ];

    final model = ItemsModel.instance;

    if (seller != null) {
      final sellerClass = seller!.roverClass;
      children.add(SizedBox(
          width: double.infinity,
          child: RoverActionButton(
              label: 'Sell for ${item.sellPrice} [lyst]',
              roverClass: sellerClass,
              onPressed: () {
                model.sellItem(
                    baseClassName: seller!.baseClassName, itemName: item.name);
                Navigator.of(context).pop();
              })));
    } else if (model.lyst < item.price) {
      children.add(RoveText.body('Not enough [lyst] to buy this item.'));
    } else {
      children.add(PlayerButtons(
          buttonLabelBuilder: (Player player) => 'Buy for ${player.name}',
          onSelected: (Player player) {
            final result = model.buyItem(
                baseClassName: player.baseClassName, itemName: item.name);
            Navigator.of(context).pop();
            if (result == EquipItemResult.noSlot) {
              showDialog(
                  context: context,
                  builder: (context) {
                    return UnequipToEquipDialog(player: player, item: item);
                  });
            }
          }));
    }

    final roverClass = seller?.roverClass;
    return RoveDialog(
        title: item.name,
        color: roverClass?.color ?? RovePalette.title,
        iconAssetPath: roverClass?.iconAsset,
        body: Column(
            spacing: RoveTheme.verticalSpacing,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: children));
  }
}
