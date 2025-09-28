import 'package:flutter/material.dart';
import 'package:rove_assistant/theme/rove_palette.dart';
import 'package:rove_assistant/theme/rove_theme.dart';
import 'package:rove_assistant/model/campaign_model.dart';
import 'package:rove_assistant/widgets/campaign/quest_list_tile.dart';
import 'package:rove_assistant/widgets/common/background_box.dart';
import 'package:rove_assistant/widgets/common/rove_divider.dart';
import 'package:rove_assistant/widgets/common/rove_text.dart';
import 'package:rove_data_types/rove_data_types.dart';

abstract class _ListItem {
  Widget buildListTitle(BuildContext context);
}

class _IntroListItem implements _ListItem {
  @override
  Widget buildListTitle(BuildContext context) {
    return Image.asset(
        CampaignModel.instance.campaign.isPlayingXulcCampaign
            ? 'assets/images/xulc_campaign_intro.webp'
            : 'assets/images/campaign_intro.webp',
        fit: BoxFit.contain);
  }
}

class _SeparatorListItem implements _ListItem {
  @override
  Widget buildListTitle(BuildContext context) {
    return RoveDivider();
  }
}

class _QuestListItem implements _ListItem {
  final QuestDef quest;

  _QuestListItem({required this.quest});

  @override
  Widget buildListTitle(BuildContext context) {
    return QuestListTile(quest: quest);
  }
}

class EncountersListPage extends StatelessWidget {
  final Widget? appBarLeading;

  const EncountersListPage({
    super.key,
    this.appBarLeading,
  });

  List<_ListItem> _itemsFromQuests(List<QuestDef> quests) {
    final bottomQuests = quests.where((quest) {
      return quest.status == QuestStatus.completed ||
          quest.status == QuestStatus.blocked;
    }).toList();
    final topQuests = quests.toList()
      ..removeWhere((quest) => bottomQuests.contains(quest));

    final items = <_ListItem>[];
    items.add(_IntroListItem());
    items.addAll(
        topQuests.map((quest) => _QuestListItem(quest: quest)).toList());
    if (bottomQuests.isNotEmpty) {
      items.add(_SeparatorListItem());
      items.addAll(
          bottomQuests.map((quest) => _QuestListItem(quest: quest)).toList());
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundBox(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          foregroundColor: RovePalette.title,
          title: RoveText.title('Encounters', color: RovePalette.title),
          backgroundColor: Colors.transparent,
          leading: appBarLeading,
        ),
        body: Center(
          child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: ListenableBuilder(
                  listenable: CampaignModel.instance.lastEncounterCompleted,
                  builder: (context, _) {
                    final quests = CampaignModel.instance.quests;
                    final items = _itemsFromQuests(quests);
                    return ConstrainedBox(
                      constraints:
                          BoxConstraints(maxWidth: RoveTheme.pageMaxWidth),
                      child: ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items[index];
                          return item.buildListTitle(context);
                        },
                      ),
                    );
                  })),
        ),
      ),
    );
  }
}
