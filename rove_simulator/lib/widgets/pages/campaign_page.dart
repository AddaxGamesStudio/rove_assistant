import 'package:collection/collection.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:rove_app_common/data/campaign_loader.dart';
import 'package:rove_app_common/model/campaign_model.dart';
import 'package:rove_app_common/model/players_model.dart';
import 'package:rove_app_common/style/rove_palette.dart';
import 'package:rove_app_common/style/rove_theme.dart';
import 'package:rove_app_common/widgets/shop/shop_page.dart';
import 'package:rove_app_common/widgets/rovers/rover_detail.dart';
import 'package:rove_simulator/assets.dart';
import 'package:rove_simulator/flame/map_game.dart';
import 'package:rove_simulator/widgets/campaign/rove_divider.dart';
import 'package:rove_simulator/widgets/campaign/quest_list_tile.dart';
import 'package:rove_data_types/rove_data_types.dart';

class CampaignPage extends StatefulWidget {
  final MapGame map;

  static const double iconSize = 36;

  CampaignPage({super.key}) : map = MapGame();

  @override
  State<CampaignPage> createState() => _CampaignPageState();
}

class _CampaignPageState extends State<CampaignPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  int get playerCount => PlayersModel.instance.players.length;

  @override
  void initState() {
    super.initState();
    CampaignModel.instance.campaign.merchantLevel = 1;
    _tabController = TabController(
        vsync: this, length: 2 + playerCount, animationDuration: Duration.zero);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final quests = CampaignLoader.instance.campaign.quests;
    final items = _itemsFromQuests(quests);
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: GameWidget(
                        game: widget.map,
                      ),
                    ),
                    Container(
                      color: Colors.white.withValues(alpha: 0.75),
                      width: 300,
                      child: ListView.builder(
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            final item = items[index];
                            return item.buildListTitle(widget.map, context);
                          }),
                    )
                  ],
                ),
                for (final player in PlayersModel.instance.players)
                  RoverDetail(roverClassName: player.roverClass.name),
                const ShopPage(),
              ],
            ),
          ),
          Container(
            color: Colors.white,
            width: double.infinity,
            height: CampaignPage.iconSize * 2,
            child: Padding(
              padding: const EdgeInsets.only(
                  left: CampaignPage.iconSize / 2,
                  right: CampaignPage.iconSize / 2),
              child: Row(
                children: [
                  IconButton(
                    icon: Image.asset(
                      'assets/images/icon_map.png',
                      color: RovePalette.codexForeground,
                      height: CampaignPage.iconSize,
                    ),
                    onPressed: () {
                      _tabController.index = 0;
                    },
                  ),
                  const Spacer(),
                  Row(
                      spacing: RoveTheme.horizontalSpacing,
                      children: PlayersModel.instance.players
                          .mapIndexed(
                            (i, player) => IconButton(
                                icon: Image.asset(
                                    Assets.pathForClassImage(
                                        player.roverClass.iconSrc),
                                    height: CampaignPage.iconSize,
                                    color: player.roverClass.color),
                                onPressed: () {
                                  _tabController.index = i + 1;
                                }),
                          )
                          .toList()),
                  const Spacer(),
                  IconButton(
                    color: RovePalette.lyst,
                    icon: Image.asset(
                      'assets/images/icon_pocket.png',
                      color: RovePalette.lyst,
                      height: CampaignPage.iconSize,
                    ),
                    onPressed: () {
                      _tabController.index = playerCount + 1;
                    },
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

abstract class _ListItem {
  Widget buildListTitle(MapGame map, BuildContext context);
}

class _SeparatorListItem implements _ListItem {
  @override
  Widget buildListTitle(MapGame map, BuildContext context) {
    return const QuestDivider();
  }
}

class _QuestListItem implements _ListItem {
  final QuestDef quest;

  _QuestListItem({required this.quest});

  @override
  Widget buildListTitle(MapGame map, BuildContext context) {
    return QuestListTile(map: map, quest: quest);
  }
}

List<_ListItem> _itemsFromQuests(List<QuestDef> quests) {
  final bottomQuests = quests;
  final topQuests = quests.toList()
    ..removeWhere((quest) => bottomQuests.contains(quest));

  final items = <_ListItem>[];
  items.addAll(topQuests.map((quest) => _QuestListItem(quest: quest)).toList());
  if (bottomQuests.isNotEmpty) {
    items.add(_SeparatorListItem());
    items.addAll(
        bottomQuests.map((quest) => _QuestListItem(quest: quest)).toList());
  }
  return items;
}
