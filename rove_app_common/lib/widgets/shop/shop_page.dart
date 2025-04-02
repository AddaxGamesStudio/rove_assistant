import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rove_app_common/model/campaign_model.dart';
import 'package:rove_app_common/model/items_model.dart';
import 'package:rove_app_common/style/rove_palette.dart';
import 'package:rove_app_common/widgets/common/background_box.dart';
import 'package:rove_app_common/widgets/common/lyst_text.dart';
import 'package:rove_app_common/widgets/common/rove_app_bar.dart';
import 'package:rove_app_common/widgets/shop/players_tab_controller.dart';
import 'package:rove_app_common/widgets/shop/shop_grid_view.dart';
import 'package:rove_data_types/rove_data_types.dart';

class ShopPage extends StatefulWidget {
  final bool includeBackButton;
  final Widget? appBarLeading;

  const ShopPage(
      {super.key, this.includeBackButton = false, this.appBarLeading});

  static const String path = '/shop';

  @override
  State<ShopPage> createState() => _ShopPageState();
}

Widget _gridViewForSlot(ItemSlotType slot) {
  return Consumer<ItemsModel>(builder: (context, model, _) {
    final shopItems = model.shopItems(slot: slot);
    return Padding(
        padding: const EdgeInsets.only(left: 8, right: 8),
        child: ShopGridView(shopItems: shopItems));
  });
}

abstract class _TabItem {
  Tab get tab;
  Widget get view;
}

class _SlotTabItem extends _TabItem {
  final ItemSlotType slot;

  _SlotTabItem(this.slot);

  @override
  Tab get tab => Tab(
      icon: Image.asset('assets/images/icon_${slot.name.toLowerCase()}.png',
          width: 24, height: 24),
      child: FittedBox(fit: BoxFit.scaleDown, child: Text(slot.label)));

  @override
  Widget get view {
    return _gridViewForSlot(slot);
  }
}

class _SellTabItem extends _TabItem {
  @override
  Tab get tab => Tab(
      text: 'Sell',
      icon: Image.asset(
        'assets/images/icon_lyst.png',
        width: 24,
        height: 24,
        color: Colors.black87,
      ));

  @override
  Widget get view {
    return PlayersTabController(tabBarViewForPlayer: (Player player) {
      return Consumer<ItemsModel>(builder: (context, model, _) {
        final campaignDefinition = CampaignModel.instance.campaignDefinition;
        final playerItemsNoRepeats = player.itemNames
            .toSet() // Convert to set to avoid repeats
            .map((e) => campaignDefinition.itemForName(e))
            .toList()
          ..sort((a, b) => a.price.compareTo(b.price));
        return ShopGridView(shopItems: playerItemsNoRepeats, seller: player);
      });
    });
  }
}

class _ShopPageState extends State<ShopPage> {
  @override
  Widget build(BuildContext context) {
    final tabs = [
      ...[
        ItemSlotType.head,
        ItemSlotType.hand,
        ItemSlotType.body,
        ItemSlotType.pocket,
        ItemSlotType.foot,
      ].map((e) => _SlotTabItem(e)),
      _SellTabItem(),
    ];

    final shopLevel = ItemsModel.instance.shopLevel;

    String title() {
      String tierSuffix = shopLevel > 1 ? ' Tier $shopLevel' : '';
      final bool isMoMissing = ItemsModel.instance.isMoMissing;
      return '${isMoMissing ? 'Makaal\'s' : 'Mo & Makaal\'s'} Shop$tierSuffix';
    }

    return BackgroundBox(
        child: DefaultTabController(
            length: tabs.length,
            child: Column(children: [
              RoveAppBar(
                  titleText: title(),
                  leading: widget.includeBackButton
                      ? RoveLeadingAppBarButton(
                          text: '< Campaign',
                          onPressed: () {
                            Navigator.of(context).pop();
                          })
                      : widget.appBarLeading,
                  actions: [
                    Padding(
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        child: CampaignLystCounter(fontSize: 18))
                  ]),
              TabBar(
                indicatorColor: RovePalette.rulesForeground,
                labelColor: Colors.black87,
                tabs: tabs.map((e) => e.tab).toList(),
              ),
              MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: Expanded(
                    child: TabBarView(
                  children: tabs.map((e) => e.view).toList(),
                )),
              ),
            ])));
  }
}
