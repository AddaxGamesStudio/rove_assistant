import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:rove_app_common/style/rove_theme.dart';
import 'package:rove_assistant/data/campaign_config.dart';
import 'package:rove_assistant/model/encounter_model.dart';
import 'package:rove_app_common/style/rove_palette.dart';
import 'package:rove_assistant/ui/rove_assets.dart';
import 'package:rove_assistant/ui/styles.dart';
import 'package:rove_assistant/ui/util/padded_widget_list.dart';
import 'package:rove_assistant/ui/widgets/encounter/encounter_adversaries.dart';
import 'package:rove_assistant/ui/widgets/encounter/encounter_challenges_panel.dart';
import 'package:rove_assistant/ui/widgets/encounter/encounter_codex_links_panel.dart';
import 'package:rove_assistant/ui/widgets/encounter/encounter_progression_panel.dart';
import 'package:rove_assistant/ui/widgets/encounter/encounter_detail_footer.dart';
import 'package:rove_assistant/ui/widgets/encounter/encounter_victory_condition_panel.dart';
import 'package:rove_assistant/ui/widgets/encounter/encounter_rules_panel.dart';
import 'package:rove_assistant/ui/widgets/encounter/encounter_loss_condition_panel.dart';
import 'package:rove_assistant/ui/widgets/encounter/encounter_prefs_dialog.dart';
import 'package:rove_assistant/ui/widgets/encounter/events/encounter_event_consumer.dart';
import 'package:rove_assistant/ui/widgets/encounter/encounter_rovers.dart';
import 'package:rove_data_types/rove_data_types.dart';

String _titleForEncounter(QuestDef quest, EncounterDef encounter) => encounter
        .isIntermission
    ? quest.title
    : '${quest.shortTitle ?? quest.title} • Encounter ${encounter.number.split('.').first}';

class EncounterDetail extends StatefulWidget {
  final EncounterModel model;
  final QuestDef quest;
  final EncounterDef encounter;

  EncounterDetail({super.key, required this.quest, required this.model})
      : encounter = model.encounterDef;

  @override
  State<EncounterDetail> createState() => _EncounterDetailState();
}

class _EncounterDetailState extends State<EncounterDetail> {
  @override
  Widget build(BuildContext context) {
    final quest = widget.quest;
    final encounter = widget.encounter;
    final headerPath =
        CampaignConfig.instance.headerPath(encounterId: encounter.id);

    Widget header() {
      return Stack(
        children: [
          if (headerPath != null)
            Image.asset(
              headerPath,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 120,
            ),
          if (headerPath == null)
            Container(
              color: RovePalette.codexForeground,
              width: double.infinity,
              height: 120,
            ),
          Positioned(
            top: 0,
            bottom: 0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                  icon: Icon(Icons.navigate_before),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ),
          ),
          Positioned(
              top: 0,
              bottom: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                    color: Colors.white,
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return EncounterPrefsDialog(model: widget.model);
                          });
                    },
                    icon: Icon(Icons.settings)),
              )),
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding:
                  const EdgeInsets.only(left: 48, top: 8, bottom: 8, right: 48),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 64, right: 64),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        _titleForEncounter(quest, encounter),
                        style: RoveStyles.titleStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      encounter.title,
                      style: RoveStyles.headerStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      );
    }

    final model = widget.model;

    Widget panels() {
      final panels = <Widget>[];
      // Objective
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
          SafeArea(
              minimum: const EdgeInsets.only(bottom: RoveTheme.verticalSpacing),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    EncounterEventConsumer(),
                    Expanded(
                        child: SingleChildScrollView(
                      child: ListenableBuilder(
                          listenable: widget.model,
                          builder: (context, _) {
                            final model = widget.model;
                            final encounterState = model.encounterState;

                            PaddedWidgetList children = PaddedWidgetList(
                                padding:
                                    const EdgeInsets.only(left: 12, right: 8));

                            children.addWithouthPadding(header());

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
                    EncounterDetailFooter(model: widget.model),
                  ])),
        ],
      ),
    );
  }
}
