import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rove_assistant/theme/rove_theme.dart';
import 'package:rove_assistant/data/campaign_config.dart';
import 'package:rove_assistant/model/encounter/encounter_event.dart';
import 'package:rove_assistant/model/encounter/encounter_model.dart';
import 'package:rove_assistant/theme/rove_assets.dart';
import 'package:rove_assistant/widgets/util/padded_widget_list.dart';
import 'package:rove_assistant/widgets/encounter/adversaries/encounter_adversaries.dart';
import 'package:rove_assistant/widgets/encounter/encounter_challenges_panel.dart';
import 'package:rove_assistant/widgets/encounter/encounter_codex_links_panel.dart';
import 'package:rove_assistant/widgets/encounter/encounter_progression_panel.dart';
import 'package:rove_assistant/widgets/encounter/encounter_detail_footer.dart';
import 'package:rove_assistant/widgets/encounter/encounter_setup_panel.dart';
import 'package:rove_assistant/widgets/encounter/encounter_terrain_panel.dart';
import 'package:rove_assistant/widgets/encounter/encounter_victory_condition_panel.dart';
import 'package:rove_assistant/widgets/encounter/encounter_rules_panel.dart';
import 'package:rove_assistant/widgets/encounter/encounter_loss_condition_panel.dart';
import 'package:rove_assistant/widgets/encounter/encounter_prefs_dialog.dart';
import 'package:rove_assistant/widgets/encounter/events/encounter_event_consumer.dart';
import 'package:rove_assistant/widgets/encounter/encounter_rovers.dart';
import 'package:rove_data_types/rove_data_types.dart';

String _titleForEncounter(QuestDef quest, EncounterDef encounter) {
  var number = encounter.number.split('.').first;
  return encounter.isIntermission
      ? quest.title
      : '${quest.shortTitle ?? quest.title} • ${number == 'I' ? 'Adventure' : 'Encounter $number'}';
}

class EncounterDetail extends StatefulWidget {
  final QuestDef quest;
  final EncounterDef encounter;

  const EncounterDetail(
      {super.key, required this.quest, required this.encounter});

  @override
  State<EncounterDetail> createState() => _EncounterDetailState();
}

class _EncounterDetailState extends State<EncounterDetail> {
  late EncounterModel model;

  @override
  void initState() {
    super.initState();
    // Ensure the encounter is loaded
    final events = Provider.of<EncounterEvents>(context, listen: false);
    model = EncounterModel.forEncounter(widget.encounter, events: events);
    if (model.pendingLoad) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        model.load();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final encounter = widget.encounter;

    Widget panels() {
      final panels = <Widget>[];
      // Objective
      if (model.setup != null) {
        panels.add(EncounterSetupPanel(model: model));
      }

      // Victory Condition
      if (model.objective.isNotEmpty) {
        panels.add(EncounterVictoryConditionPanel(model: model));
      }

      if (model.lossCondition != null) {
        panels.add(EncounterLossConditionPanel(model: model));
      }

      // Challenges
      if (encounter.challenges.isNotEmpty) {
        panels.add(EncounterChallengesPanel(model: model));
      }

      if (model.terrain.isNotEmpty) {
        panels.add(EncounterTerrainPanel(model: model));
      }

      // Special Rules
      if (model.specialRules.isNotEmpty) {
        panels.add(EncounterRulesPanel(model: model));
      }

      // Codex Links
      if (model.codexLinks.isNotEmpty) {
        panels.add(EncounterCodexLinksPanel(model: model));
      }

      if (!model.encounterState.complete) {
        // Progression Events
        if (model.manualProgressionEvents.isNotEmpty) {
          panels.add(EncounterProgressionPanel(model: model));
        }
      }
      return Center(
        child: Wrap(
          alignment: WrapAlignment.center,
          runAlignment: WrapAlignment.center,
          direction: Axis.horizontal,
          runSpacing: RoveTheme.verticalSpacing,
          spacing: RoveTheme.horizontalSpacing,
          children: panels,
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: ListenableBuilder(
                  listenable: model,
                  builder: (context, _) {
                    final isEmpty = model.mapId == MapDef.emptyMapId;
                    return isEmpty
                        ? SizedBox.shrink()
                        : Image.asset(
                            RoveAssets.assetForMap(model.mapId,
                                expansion: model.encounterDef.expansion),
                            color: Colors.white.withValues(alpha: 0.7),
                            colorBlendMode: BlendMode.lighten,
                            fit: BoxFit.cover,
                          );
                  }),
            ),
          ),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            EncounterEventConsumer(),
            Expanded(
                child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: RoveTheme.verticalSpacing),
              child: ListenableBuilder(
                  listenable: model,
                  builder: (context, _) {
                    final encounterState = model.encounterState;

                    SidePaddedWidgetList children = SidePaddedWidgetList(
                        padding: const EdgeInsets.only(left: 12, right: 12));

                    final quest = widget.quest;
                    final headerPath = CampaignConfig.instance
                        .headerPathForEncounter(encounter.id);
                    children.addWithouthPadding(EncounterDetailHeader(
                        model: model,
                        headerPath: headerPath,
                        quest: quest,
                        encounter: encounter));

                    children.add(panels());

                    if (!encounterState.complete) {
                      children.addWithouthPadding(EncounterRovers(
                        model: model,
                      ));
                      children.addWithouthPadding(EncounterAdversaries(
                        model: model,
                      ));
                    }

                    return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: RoveTheme.verticalSpacing,
                        children: children.widgets);
                  }),
            )),
            EncounterDetailFooter(model: model),
          ]),
        ],
      ),
    );
  }
}

class EncounterDetailHeader extends StatelessWidget {
  const EncounterDetailHeader({
    super.key,
    required this.model,
    required this.headerPath,
    required this.quest,
    required this.encounter,
  });

  final EncounterModel model;
  final String? headerPath;
  final QuestDef quest;
  final EncounterDef encounter;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(headerPath!),
          fit: BoxFit.cover,
        ),
      ),
      child: SafeArea(
          bottom: false,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: RoveTheme.horizontalSpacing,
            children: [
              IconButton(
                  tooltip: 'Encounters',
                  icon: Icon(Icons.navigate_before),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          _titleForEncounter(quest, encounter),
                          style: RoveTheme.titleStyle(color: Colors.white),
                        ),
                      ),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          encounter.title,
                          style: RoveTheme.headerStyle(color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              IconButton(
                  tooltip: 'Settings',
                  color: Colors.white,
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return EncounterPrefsDialog(model: model);
                        });
                  },
                  icon: Icon(Icons.settings)),
            ],
          )),
    );
  }
}

class EncounterSidePadding extends StatelessWidget {
  const EncounterSidePadding({super.key, required this.child});

  static const EdgeInsets padding =
      EdgeInsets.only(left: 12, right: 12, top: 0, bottom: 0);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(top: false, bottom: false, minimum: padding, child: child);
  }
}
