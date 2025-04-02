import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rove_app_common/data/campaign_loader.dart';
import 'package:rove_app_common/model/campaign_model.dart';
import 'package:rove_app_common/model/players_model.dart';
import 'package:rove_app_common/widgets/common/rove_confirm_dialog.dart';
import 'package:rove_assistant/model/encounter_model.dart';
import 'package:rove_assistant/model/encounter_event.dart';
import 'package:rove_app_common/style/rove_palette.dart';
import 'package:rove_assistant/model/encounter_state.dart';
import 'package:rove_assistant/ui/styles.dart';
import 'package:rove_assistant/ui/widgets/encounter/encounter_detail.dart';
import 'package:rove_assistant/ui/widgets/rewards_dialog.dart';
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

Icon? _iconForEncounterStatus(EncounterStatus status) {
  switch (status) {
    case EncounterStatus.completed:
      return const Icon(Icons.check, color: RovePalette.codexForeground);
    case EncounterStatus.locked:
      return const Icon(Icons.lock, color: Colors.black54);
    default:
      return null;
  }
}

String _titleForQuest(QuestDef quest) {
  return quest.title;
}

String _titleForEncounter(EncounterInQuestDef encounter, QuestDef quest) {
  // Special titles for intermission
  if (quest.encounters.length == 1) {
    return encounter.title;
  } else {
    return '${encounter.displayId} - ${encounter.title}';
  }
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
    if (quest.encounters.length == 1) {
      return EncounterListTile(
          quest: quest,
          encounterData: quest.encounters.first,
          title: Text(_titleForQuest(quest), style: RoveStyles.titleStyle()));
    }

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
    return ExpansionTile(
      key: PageStorageKey<String>(quest.id),
      controller: controller,
      shape: const Border(),
      initiallyExpanded: initiallyExpanded,
      trailing: trailingWidget(status),
      title: Text(
        _titleForQuest(quest),
        style: RoveStyles.titleStyle(),
      ),
      children: encounters.map((encounter) {
        return EncounterListTile(quest: quest, encounterData: encounter);
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

class EncounterListTile extends StatelessWidget {
  const EncounterListTile({
    super.key,
    required this.quest,
    required this.encounterData,
    this.title,
  });

  final Widget? title;
  final QuestDef quest;
  final EncounterInQuestDef encounterData;

  String get encounterId => encounterData.id;

  EncounterStatus get status => quest.statusForEncounter(encounterId);

  _showLevelUpDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) => RoveConfirmDialog(
            title: 'Level Up Required',
            message:
                'Level up all Rovers from their Rover menu before the next encounter.',
            color: RovePalette.title,
            confirmTitle: 'OK',
            hideCancelButton: true));
  }

  _onSelectedEncounter(BuildContext context) async {
    if (PlayersModel.instance.hasPendingLevelUp) {
      _showLevelUpDialog(context);
      return;
    }
    if (status != EncounterStatus.locked) {
      final encounterDef =
          await CampaignLoader.loadEncounter(context, encounterId);
      if (!context.mounted || encounterDef == null) {
        return;
      }
      final events = Provider.of<EncounterEvents>(context, listen: false);
      final model = EncounterModel.forEncounter(encounterDef, events: events);
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return EncounterDetail(quest: quest, model: model);
      }));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      trailing: _iconForEncounterStatus(status),
      title: title ?? Text(_titleForEncounter(encounterData, quest)),
      onTap: () => _onSelectedEncounter(context),
    );
  }
}
