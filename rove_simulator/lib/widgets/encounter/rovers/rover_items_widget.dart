import 'package:flutter/material.dart';
import 'package:rove_simulator/flame/encounter_game.dart';
import 'package:rove_simulator/model/cards/item_model.dart';
import 'package:rove_simulator/model/tiles/player_unit_model.dart';
import 'package:rove_simulator/widgets/encounter/rovers/item_slot_button.dart';
import 'package:rove_data_types/rove_data_types.dart';

class RoverItemsWidget extends StatelessWidget {
  final PlayerUnitModel player;
  final EncounterGame game;
  final GlobalKey? boardKey;

  const RoverItemsWidget({
    super.key,
    required this.game,
    required this.player,
    required this.boardKey,
  });

  @override
  Widget build(BuildContext context) {
    final widgets = <ItemSlotButton>[];
    for (var slotType in [
      ItemSlotType.head,
      ItemSlotType.hand,
      ItemSlotType.body,
      ItemSlotType.foot,
      ItemSlotType.pocket
    ]) {
      final count = player.availableSlotsForSlotType(slotType);
      final items = List.generate(
          count, (i) => player.itemAtIndex(index: i, slot: slotType));
      final coalescedItems = <(ItemModel?, int)>[];
      ItemModel? previous;
      for (final item in items) {
        if (previous != null && item == previous) {
          coalescedItems.last = (item, coalescedItems.last.$2 + 1);
        } else {
          coalescedItems.add((item, 1));
        }
        previous = item;
      }
      widgets.addAll(coalescedItems.map((e) => ItemSlotButton(
            key: GlobalKey(),
            game: game,
            player: player,
            slotType: slotType,
            item: e.$1,
            slots: e.$2,
            boardKey: boardKey,
          )));
    }
    return Container(
        color: player.color,
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Column(children: widgets),
        ));
  }
}
