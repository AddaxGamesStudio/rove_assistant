import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:rove_simulator/assets.dart';
import 'package:rove_data_types/rove_data_types.dart';
import 'package:rove_simulator/flame/encounter_game.dart';
import 'package:rove_simulator/model/cards/item_model.dart';
import 'package:rove_simulator/model/tiles/player_unit_model.dart';

class ItemSlotButton extends StatelessWidget {
  final EncounterGame game;
  final PlayerUnitModel player;
  final ItemModel? item;
  final ItemSlotType slotType;
  final int slots;
  final GlobalKey globalKey;
  final GlobalKey? boardKey;

  const ItemSlotButton(
      {super.key,
      required this.game,
      required this.player,
      required this.slotType,
      required this.slots,
      this.item,
      this.boardKey})
      : globalKey = key as GlobalKey;

  onEnter() {
    final itemToShow = item;
    final itemBox = globalKey.currentContext?.findRenderObject() as RenderBox?;
    final boardBox = boardKey?.currentContext?.findRenderObject() as RenderBox?;
    if (itemToShow == null || itemBox == null || boardBox == null) {
      return;
    }
    final itemOffset = itemBox.localToGlobal(Offset.zero);
    final boardOffset = boardBox.localToGlobal(Offset.zero);

    final position =
        Vector2(boardOffset.dx + boardBox.size.width, itemOffset.dy);
    game.cardPreviewController.showItem(item: itemToShow, position: position);
  }

  onExit() {
    game.cardPreviewController.hidePreview();
  }

  onTap() {
    game.cardPreviewController.hidePreview();
    if (item case final selectedItem?) {
      if (selectedItem.canPlayForPlayer(player, encounter: game.model)) {
        game.onSelectedItem(player: player, item: selectedItem);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final applicableItems = game.cardResolver?.availableItems ?? [];

    Color color() {
      if (item == null) {
        return Colors.grey.shade400;
      } else if (item?.canPlayForPlayer(player, encounter: game.model) ==
              true ||
          applicableItems.contains(item)) {
        return Colors.white;
      }
      return Colors.grey.shade800;
    }

    return MouseRegion(
      onEnter: (event) => onEnter(),
      onExit: (event) => onExit(),
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            for (int i = 0; i < slots; i++)
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    color: Colors.grey,
                    width: 24,
                    height: 24,
                  ),
                  Image(
                    image: Assets.imageForSlotType(slotType).image,
                    width: 18,
                    height: 18,
                    color: color(),
                    fit: BoxFit.contain,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
