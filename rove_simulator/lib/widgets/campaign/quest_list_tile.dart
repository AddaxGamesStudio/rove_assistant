import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rove_app_common/data/campaign_loader.dart';
import 'package:rove_app_common/model/players_model.dart';
import 'package:rove_simulator/flame/map_game.dart';
import 'package:rove_app_common/style/rove_palette.dart';
import 'package:rove_simulator/widgets/pages/encounter_page.dart';
import 'package:rove_simulator/widgets/pages/navigator_ext.dart';
import 'package:rove_data_types/rove_data_types.dart';

String _titleForQuest(QuestDef quest) {
  // Special titles for intermission
  if (quest.encounters.length == 1) {
    return quest.encounters.first.title;
  } else {
    return 'Quest ${quest.id} - ${quest.title}';
  }
}

String _titleForEncounter(EncounterInQuestDef encounter, QuestDef quest) {
  // Special titles for intermission
  if (quest.encounters.length == 1) {
    return encounter.title;
  } else {
    return '${encounter.id} - ${encounter.title}';
  }
}

class QuestListTile extends StatelessWidget {
  final MapGame map;

  QuestListTile({
    super.key,
    required this.map,
    required this.quest,
  });

  final ExpansionTileController controller = ExpansionTileController();

  final QuestDef quest;

  @override
  Widget build(BuildContext context) {
    if (quest.encounters.length == 1) {
      return EncounterListTile(
          map: map,
          quest: quest,
          encounterData: quest.encounters.first,
          title: Text(_titleForQuest(quest),
              style: GoogleFonts.grenze(
                color: RovePalette.title,
                fontWeight: FontWeight.w600,
                fontSize: 24,
              )));
    }

    return ExpansionTile(
      key: PageStorageKey<String>(quest.id),
      controller: controller,
      shape: const Border(),
      title: Text(
        _titleForQuest(quest),
        style: GoogleFonts.grenze(
          color: RovePalette.title,
          fontWeight: FontWeight.w600,
          fontSize: 24,
        ),
      ),
      children: quest.encounters.map((encounter) {
        return EncounterListTile(
            map: map, quest: quest, encounterData: encounter);
      }).toList(),
    );
  }
}

class EncounterListTile extends StatelessWidget {
  final MapGame map;

  const EncounterListTile({
    super.key,
    required this.map,
    required this.quest,
    required this.encounterData,
    this.title,
  });

  final Widget? title;
  final QuestDef quest;
  final EncounterInQuestDef encounterData;

  onEncounterSelected(BuildContext context, EncounterDef encounter) async {
    NavigatorExt.pushReplacementPage(
      context,
      EncounterPage(
          encounter: encounter, players: PlayersModel.instance.players),
    );
  }

  void onEnter() {
    map.onFocusedEncounterWithId(encounterData.id);
  }

  void onExit() {
    map.clearFocusedEncounter();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => onEnter(),
      onExit: (_) => onExit(),
      child: ListTile(
          title: title ?? Text(_titleForEncounter(encounterData, quest)),
          onTap: () async {
            final encounter =
                await CampaignLoader.loadEncounter(context, encounterData.id);
            if (encounter == null || !context.mounted) {
              return;
            }
            // TODO: Remove; this is just to verify that json persistence is working well
            final string = jsonEncode(encounter.toJson());
            final parsedEncounter =
                EncounterDef.fromJson(json: jsonDecode(string));
            onEncounterSelected(context, parsedEncounter);
          }),
    );
  }
}
