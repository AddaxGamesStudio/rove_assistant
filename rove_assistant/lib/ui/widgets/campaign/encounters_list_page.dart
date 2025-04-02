import 'package:flutter/material.dart';
import 'package:rove_app_common/model/campaign_model.dart';
import 'package:rove_app_common/style/rove_theme.dart';
import 'package:rove_assistant/ui/widgets/campaign/quest_list_tile.dart';
import 'package:rove_assistant/ui/widgets/common/rove_divider.dart';
import 'package:rove_data_types/rove_data_types.dart';

abstract class _ListItem {
  Widget buildListTitle(BuildContext context);
}

class _IntroListItem implements _ListItem {
  @override
  Widget buildListTitle(BuildContext context) {
    return Image.asset('assets/images/campaign_intro.png', fit: BoxFit.contain);
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
  const EncountersListPage({
    super.key,
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
    return Center(
      child: MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: ListenableBuilder(
              listenable: CampaignModel.instance.lastEncounterCompleted,
              builder: (context, _) {
                final quests = CampaignModel.instance.quests;
                final items = _itemsFromQuests(quests);
                return ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: RoveTheme.pageMaxWidth),
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return item.buildListTitle(context);
                    },
                  ),
                );
              })),
    );
  }
}
