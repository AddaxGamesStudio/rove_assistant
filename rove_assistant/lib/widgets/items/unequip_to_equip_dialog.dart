import 'package:flutter/material.dart';
import 'package:rove_assistant/theme/rove_theme.dart';
import 'package:rove_assistant/model/campaign_model.dart';
import 'package:rove_assistant/model/items_model.dart';
import 'package:rove_assistant/model/players_model.dart';
import 'package:rove_assistant/widgets/items/item_image.dart';
import 'package:rove_assistant/widgets/common/rove_dialog.dart';
import 'package:rove_assistant/widgets/common/rove_text.dart';
import 'package:rove_assistant/widgets/common/rover_action_button.dart';
import 'package:rove_data_types/rove_data_types.dart';

class UnequipToEquipDialog extends StatefulWidget {
  final Player player;
  final ItemDef item;
  final List<ItemDef> equippedEncounterItems;

  /// If not provided will default to work on the items model singleton.
  final Function(List<ItemDef>)? onConfirmedItemsToUnequip;

  const UnequipToEquipDialog(
      {super.key,
      required this.player,
      required this.item,
      this.equippedEncounterItems = const [],
      this.onConfirmedItemsToUnequip});

  @override
  State<UnequipToEquipDialog> createState() => _UnequipToEquipDialogState();
}

class _UnequipToEquipDialogState extends State<UnequipToEquipDialog> {
  final List<(int, ItemDef)> selectedItems = [];

  ItemsModel get model => ItemsModel.instance;
  ItemDef get item => widget.item;
  Player get player => widget.player;
  ItemSlotType get slot => item.slotType;
  RoverClass get roverClass => player.roverClass;
  int get selectedSlots =>
      selectedItems.map((s) => s.$2.slotCount).fold(0, (a, b) => a + b);
  List<ItemDef> get equippedEncounterItems => widget.equippedEncounterItems;
  List<ItemDef> get equippedItems =>
      model.equippedItems(player: widget.player, slot: slot) +
      equippedEncounterItems;

  @override
  void initState() {
    super.initState();
    if (equippedItems.length == 1) {
      selectedItems.add((0, equippedItems.first));
    }
  }

  onContinue(BuildContext context) {
    final onConfirmedItemsToUnequip = widget.onConfirmedItemsToUnequip;
    if (onConfirmedItemsToUnequip != null) {
      onConfirmedItemsToUnequip(selectedItems.map((s) => s.$2).toList());
    } else {
      for (var (_, selectedItem) in selectedItems) {
        model.unequipItem(player: player, item: selectedItem);
      }
      final result = model.equipItem(
          baseClassName: player.baseClassName, itemName: item.name);
      assert(result == EquipItemResult.success);
    }
    Navigator.of(context).pop();
  }

  onSkip(BuildContext context) {
    Navigator.of(context).pop();
  }

  isSelected(int index) {
    return selectedItems.any((s) => s.$1 == index);
  }

  onSelectetedItem(int index, ItemDef item) {
    setState(() {
      if (isSelected(index)) {
        selectedItems.removeWhere((s) => s.$1 == index);
      } else {
        selectedItems.add((index, item));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final missingSlots = model.missingSlotsToEquip(
        player: widget.player,
        item: item,
        equippedEncounterItems: equippedEncounterItems);
    final selectedEnough = selectedSlots >= missingSlots;
    final name = item.name;
    final isSingleOption = equippedItems.length == 1;

    Widget singleOptionWidget() {
      final equippedItem = equippedItems.first;
      return Column(
        spacing: RoveTheme.verticalSpacing,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.all(12),
            child: ItemImage(equippedItem.name, height: 250),
          ),
          RoveText('Unequip ${equippedItem.name} to equip $name?'),
          SizedBox(
              width: double.infinity,
              child: RoverActionButton(
                  label: 'Confirm',
                  roverClass: roverClass,
                  onPressed: () {
                    onContinue(context);
                  })),
          SizedBox(
              width: double.infinity,
              child: RoverActionButton(
                  label: 'Do Not Equip $name',
                  roverClass: roverClass,
                  onPressed: () {
                    onSkip(context);
                  }))
        ],
      );
    }

    Widget multipleOptionWidget() {
      return Column(
        spacing: RoveTheme.verticalSpacing,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          RoveText(missingSlots == 1
              ? 'Select an item to free 1 ${slot.label} slot for $name.'
              : 'Select one or more items to free $missingSlots ${slot.label} slots for $name.'),
          SizedBox(
            height: 250,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: equippedItems.length,
                itemBuilder: (context, index) {
                  final item = equippedItems[index];
                  final imgPath =
                      CampaignModel.instance.assetForItem(itemName: item.name);
                  return Container(
                    margin: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        borderRadius: RoveTheme.cardBorderRadius,
                        border: Border.all(
                            color: isSelected(index)
                                ? roverClass.color
                                : Colors.transparent,
                            width: 4)),
                    child: GestureDetector(
                      onTap: () {
                        onSelectetedItem(index, item);
                      },
                      child: ClipRRect(
                        borderRadius: RoveTheme.cardBorderRadius,
                        child: Image.asset(imgPath, fit: BoxFit.contain),
                      ),
                    ),
                  );
                }),
          ),
          SizedBox(
              width: double.infinity,
              child: RoverActionButton(
                  label:
                      'Unequip ${selectedItems.length > 1 ? 'items' : 'item'} & equip $name',
                  roverClass: roverClass,
                  onPressed: selectedEnough
                      ? () {
                          onContinue(context);
                        }
                      : null)),
          SizedBox(
              width: double.infinity,
              child: RoverActionButton(
                  label: 'Do not equip $name',
                  roverClass: roverClass,
                  onPressed: () {
                    onSkip(context);
                  }))
        ],
      );
    }

    return RoveDialog.fromRoverClass(
        title: 'Unequip to Equip',
        roverClass: widget.player.roverClass,
        body: isSingleOption ? singleOptionWidget() : multipleOptionWidget());
  }
}
