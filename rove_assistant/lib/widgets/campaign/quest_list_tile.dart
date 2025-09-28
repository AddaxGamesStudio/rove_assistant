import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rove_assistant/theme/rove_palette.dart';
import 'package:rove_assistant/model/campaign_model.dart';
import 'package:rove_assistant/model/encounter/encounter_state.dart';
import 'package:rove_assistant/theme/rove_theme.dart';
import 'package:rove_assistant/widgets/campaign/encounter_list_tile.dart';
import 'package:rove_assistant/widgets/campaign/page_list_tile.dart';
import 'package:rove_assistant/widgets/rewards/rewards_dialog.dart';
import 'package:rove_data_types/rove_data_types.dart';

Icon? _iconForQuestStatus(QuestStatus status) {
  switch (status) {
    case QuestStatus.completed:
      return const Icon(Icons.check, color: RovePalette.codexForeground);
    case QuestStatus.locked:
      return const Icon(Icons.lock, color: Colors.black54);
    case QuestStatus.blocked:
      return const Icon(Icons.highlight_off,
          color: RovePalette.challengesForeground);
    default:
      return null;
  }
}

String _titleForQuest(QuestDef quest) {
  return quest.title;
}

class QuestListTile extends StatelessWidget {
  QuestListTile({
    super.key,
    required this.quest,
  });

  final ExpansionTileController controller = ExpansionTileController();

  final QuestDef quest;

  @override
  Widget build(BuildContext context) {
    skipTutorial({required QuestDef tutorialQuest}) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) => RewardsDialog(
              rewards: RewardsWrapper.tutorial(),
              onCancel: () {},
              onCompleted: () {
                completeQuest();
              }));
    }

    Widget trailingWidget(QuestStatus status) {
      final icon = _iconForQuestStatus(status);
      if (icon != null) {
        return icon;
      }

      if (quest.isTutorial && status != QuestStatus.inProgress) {
        return TextButton(
            onPressed: () {
              skipTutorial(tutorialQuest: quest);
            },
            child: const Text('Skip', style: TextStyle(color: Colors.black54)));
      }

      if (kDebugMode && status != QuestStatus.inProgress) {
        return TextButton(
            onPressed: () {
              completeQuest();
            },
            child: const Text('Complete',
                style: TextStyle(color: Colors.black54)));
      }

      return const SizedBox.shrink();
    }

    final status = quest.status;
    /*
    if (quest.encounters.length == 1) {
      return EncounterListTile(
          quest: quest,
          encounterData: quest.encounters.first,
          title: Text(_titleForQuest(quest), style: RoveStyles.titleStyle()));
    } */

    final initiallyExpanded =
        status == QuestStatus.available || status == QuestStatus.inProgress;

    final encounters = quest.encounters.where((e) {
      final status = quest.statusForEncounter(e.id);
      switch (status) {
        case EncounterStatus.completed:
          return true;
        case EncounterStatus.locked:
          return false;
        case EncounterStatus.available:
          return true;
      }
    }).toList();

    final introduction = quest.introduction;
    final List<Widget> prefixChildren =
        introduction != null && status != QuestStatus.locked
            ? [
                PageListTile(
                  quest: quest,
                  page: introduction,
                ),
              ]
            : [];

    return ExpansionTile(
      key: PageStorageKey<String>(quest.id),
      controller: controller,
      shape: const Border(),
      initiallyExpanded: initiallyExpanded,
      trailing: trailingWidget(status),
      title: Text(
        _titleForQuest(quest),
        style: RoveTheme.titleStyle(),
      ),
      children: prefixChildren +
          encounters.map((encounter) {
            final page = encounter.page;
            if (page != null) {
              return PageListTile(quest: quest, page: page);
            } else {
              return EncounterListTile(quest: quest, encounterData: encounter);
            }
          }).toList(),
    );
  }

  void completeQuest() {
    for (var encounter in quest.encounters) {
      final encounterState = EncounterState(encounterId: encounter.id);
      encounterState.complete = true;
      CampaignModel.instance.completeEncounter(record: encounterState.record());
    }
  }
}
