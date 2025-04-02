import 'package:flutter/material.dart';
import 'package:rove_app_common/model/campaign_model.dart';
import 'package:rove_app_common/style/rove_theme.dart';
import 'package:rove_simulator/flame/encounter_game.dart';
import 'package:rove_app_common/data/progression_data.dart';
import 'package:rove_app_common/style/rove_palette.dart';
import 'package:rove_simulator/widgets/encounter/progression/victory_dialog.dart';

class VictoryShopUnlockedDialog extends StatelessWidget with VictoryDialog {
  @override
  final EncounterGame game;

  const VictoryShopUnlockedDialog({super.key, required this.game});

  static const String overlayName = 'victory_shop_unlocked';

  int get shopLevel => game.model.encounter.unlocksShopLevel;
  String get title {
    switch (shopLevel) {
      case 1:
        return 'M&M\'s Shop Opens!';
      default:
        return 'Level $shopLevel Items Unlocked';
    }
  }

  Widget itemsStack(List<String> itemNames) {
    assert(itemNames.isNotEmpty);
    const itemWidth = 200.0;
    const itemHeight = itemWidth / 0.7342222222;
    final count = itemNames.length;
    final List<Widget> children = [];
    const yOffset = 20.0;
    const xOffset = 50.0;

    // Stack size is determined by non-positioned children so add its size
    children.add(SizedBox(
        width: itemWidth + (itemWidth - xOffset) * (count - 1),
        height: itemHeight + (count - 1) * yOffset));
    double offset = 0;
    for (int i = 0; i < count; i++) {
      final name = itemNames[i];
      final asset = CampaignModel.instance.assetForItem(itemName: name);
      children.add(Positioned(
          bottom: i * yOffset,
          left: offset,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.asset(asset, width: itemWidth, fit: BoxFit.contain),
          )));
      offset += itemWidth - xOffset;
    }
    return Stack(children: children.reversed.toList());
  }

  @override
  Widget build(BuildContext context) {
    final items = ProgressionData.previewItemsForShopLevel(shopLevel);
    return VictoryDialogScaffold(
      title: title,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          itemsStack(items),
        ],
      ),
      footer: Column(
        spacing: RoveTheme.verticalSpacing,
        children: [
          Text(
            'You can now purchase level $shopLevel items from M&M\'s shop.',
            style: const TextStyle(color: Colors.white),
          ),
          Row(spacing: 8, children: [
            const Spacer(),
            ElevatedButton.icon(
              icon: Icon(iconData),
              style: ElevatedButton.styleFrom(
                  backgroundColor: RovePalette.victoryForeground),
              onPressed: () {
                onContinue(context);
              },
              label: const Text('Continue'),
            ),
            const Spacer(),
          ]),
        ],
      ),
    );
  }

  @override
  RewardStage get currentStage => RewardStage.shop;
}
