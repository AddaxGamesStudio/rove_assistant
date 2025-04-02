import 'package:flutter/material.dart';
import 'package:rove_app_common/model/items_model.dart';
import 'package:rove_app_common/style/rove_theme.dart';
import 'package:rove_app_common/widgets/common/rove_text.dart';
import 'package:rove_app_common/widgets/items/unequip_to_equip_dialog.dart';
import 'package:rove_assistant/model/encounter_event.dart';
import 'package:rove_assistant/model/encounter_model.dart';
import 'package:rove_assistant/ui/styles.dart';
import 'package:rove_app_common/widgets/common/player_buttons.dart';
import 'package:rove_assistant/ui/widgets/encounter/events/event_panel.dart';
import 'package:rove_data_types/rove_data_types.dart';

class EncounterEventItemPage extends StatelessWidget {
  final EncounterEvent event;
  final ItemDef item;
  final Function() onContinue;

  EncounterEventItemPage(
      {super.key, required this.event, required this.onContinue})
      : item = event.item!;

  EncounterModel get model => event.model;

  onConfirmedItemsToUnequip(
      Player player, List<ItemDef> selectedItems, ItemDef item) {
    for (final item in selectedItems) {
      model.unequipItem(player: player, item: item);
    }
    model.equipItem(player: player, item: item, isReward: true);
  }

  @override
  Widget build(BuildContext context) {
    return EventPanel(
        event: event,
        footer: PlayerButtons(
            buttonLabelBuilder: (player) => 'Send to ${player.name}',
            onSelected: (player) async {
              final result = model.giveItem(player: player, item: item);
              if (result == EquipItemResult.noSlot) {
                await showDialog(
                    context: context,
                    builder: (context) {
                      return UnequipToEquipDialog(
                        player: player,
                        item: item,
                        equippedEncounterItems:
                            model.equippedEncounterItemsForPlayer(player),
                        onConfirmedItemsToUnequip: (selectedItems) {
                          onConfirmedItemsToUnequip(
                              player, selectedItems, item);
                        },
                      );
                    });
              }
              onContinue();
            }),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: RoveTheme.verticalSpacing,
          children: [
            RoveText(
              event.message,
              textAlign: TextAlign.start,
            ),
            Center(child: RoveStyles.itemImage(item.name)),
          ],
        ));
  }
}
