import 'package:flutter/material.dart';
import 'package:rove_assistant/theme/rove_palette.dart';
import 'package:rove_assistant/model/campaign_model.dart';
import 'package:rove_assistant/widgets/campaign/campaign_navigator.dart';
import 'package:rove_data_types/rove_data_types.dart';

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

String _titleForEncounter(EncounterInQuestDef encounter, QuestDef quest) {
  // Special titles for intermission
  if (quest.encounters.length == 1) {
    return encounter.title;
  } else {
    return '${encounter.displayId} - ${encounter.title}';
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

  _onSelectedEncounter(BuildContext context) async {
    Navigator.of(context).pushEncounter(encounterId: encounterId);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      trailing: _iconForEncounterStatus(status),
      title: title ??
          Text(
            _titleForEncounter(encounterData, quest),
            style: TextStyle(color: RovePalette.body),
          ),
      onTap: () => _onSelectedEncounter(context),
    );
  }
}
