import 'package:flutter/material.dart';
import 'package:rove_assistant/data/progression_data.dart';
import 'package:rove_assistant/model/campaign_model.dart';
import 'package:rove_assistant/theme/rove_theme.dart';
import 'package:rove_assistant/widgets/common/rove_dialog.dart';
import 'package:rove_assistant/widgets/common/rove_text.dart';
import 'package:rove_assistant/widgets/rewards/rewards_dialog.dart';

abstract class _ShopPanel extends RewardPanel {
  String get body;

  List<String> get items;

  Function() get changeState;

  const _ShopPanel({super.key, required super.onContinue});

  Widget itemsStack(List<String> itemNames) {
    assert(itemNames.isNotEmpty);
    const itemWidth = 140.0;
    const itemHeight = itemWidth / 0.7342222222;
    final count = itemNames.length;
    final List<Widget> children = [];
    final yOffset = 20.0;
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
  Widget buildBody(BuildContext context) {
    final List<Widget> children = [];
    if (items.isNotEmpty) {
      children.add(itemsStack(items));
    }
    children.add(RoveTheme.verticalSpacingBox);
    children.add(RoveText(body));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: children,
    );
  }

  @override
  Widget buildActions(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.end, children: [
      RoveDialogActionButton(
        color: foregroundColor,
        title: 'Continue',
        onPressed: () {
          changeState();
          onContinue();
        },
      )
    ]);
  }
}

class RewardShopStashPanel extends _ShopPanel {
  final String stash;

  const RewardShopStashPanel(
      {super.key, required this.stash, required super.onContinue});

  @override
  String get body =>
      'Add the $stash merchant deck to the store. [*The app does this automatically.*]';

  @override
  Function() get changeState => () {
        CampaignModel.instance.addShopStash(stash);
      };

  @override
  List<String> get items => ProgressionData.previewItemsForStash(stash);
}

class RewardShopLevelUpPanel extends _ShopPanel {
  final int level;

  const RewardShopLevelUpPanel(
      {super.key, required this.level, required super.onContinue});

  @override
  String get body => level == 1
      ? 'M&M\'s shop is now open!'
      : 'M&M\'s tier $level items unlocked.';

  @override
  Function() get changeState => () {
        CampaignModel.instance.setShopLevel(level);
      };

  @override
  List<String> get items => ProgressionData.previewItemsForShopLevel(level);
}
