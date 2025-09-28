import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rove_assistant/theme/rove_palette.dart';
import 'package:rove_assistant/theme/rove_theme.dart';
import 'package:rove_assistant/data/campaign_config.dart';
import 'package:rove_assistant/model/campaign_model.dart';
import 'package:rove_assistant/widgets/campaign/campaign_navigator.dart';
import 'package:rove_assistant/widgets/common/background_box.dart';
import 'package:rove_assistant/widgets/common/rove_dialog.dart';
import 'package:rove_assistant/widgets/common/rove_icon.dart';
import 'package:rove_assistant/widgets/common/rove_text.dart';
import 'package:rove_assistant/widgets/encounter/encounter_panel.dart';
import 'package:rove_data_types/rove_data_types.dart';

String _headerPath(QuestDef quest, ChapterPage page) {
  final pageId = page.id;
  if (pageId != null) {
    final headerPath = CampaignConfig.instance.headerPathForPage(pageId);
    if (headerPath != null) {
      return headerPath;
    }
  }
  final encounterId = quest.encounters.firstOrNull?.id;
  if (encounterId != null) {
    final headerPath =
        CampaignConfig.instance.headerPathForEncounter(encounterId);
    if (headerPath != null) {
      return headerPath;
    }
  }
  return '';
}

class ChapterPageWidget extends StatelessWidget {
  const ChapterPageWidget({
    super.key,
    required this.quest,
    required this.page,
    required this.texts,
  });

  final QuestDef quest;
  final ChapterPage page;
  final Map<String, CampaignText> texts;

  bool canShowSection(Section section) {
    final model = CampaignModel.instance;
    final ifMilestone = section.ifMilestone;
    if (ifMilestone != null) {
      if (!model.hasMilestone(ifMilestone)) {
        return false;
      }
    }
    final encounterCompletedAll = section.encounterCompletedAll;
    if (encounterCompletedAll.isNotEmpty) {
      final matches = encounterCompletedAll.every((id) {
        return model.campaign.isCompletedForEncounter(id);
      });
      if (!matches) {
        return false;
      }
    }

    final encounterCompletedNone = section.encounterCompletedNone;
    if (encounterCompletedNone.isNotEmpty) {
      final matches = !encounterCompletedNone.any((id) {
        return model.campaign.isCompletedForEncounter(id);
      });
      if (!matches) {
        return false;
      }
    }

    final encounterCompletedNotAll = section.encounterCompletedNotAll;
    if (encounterCompletedNotAll.isNotEmpty) {
      final matches = encounterCompletedNotAll.where((id) {
            return model.campaign.isCompletedForEncounter(id);
          }).length !=
          encounterCompletedNotAll.length;
      if (!matches) {
        return false;
      }
    }

    switch (section.type) {
      case SectionType.artwork:
        return section.value != null;
      case SectionType.text:
        return true;
      case SectionType.campaignLink:
        final encounterId = section.value ?? quest.encounters.first.id;
        return !model.campaign.isCompletedForEncounter(encounterId);
      case SectionType.rules:
        return true;
    }
  }

  Widget widgetForSection(Section section) {
    switch (section.type) {
      case SectionType.artwork:
        return _Artwork(name: section.value ?? '');
      case SectionType.text:
        return ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: RoveTheme.pageMaxWidth,
          ),
          child: RoveText.body(texts[section.value]?.body ?? ''),
        );
      case SectionType.campaignLink:
        return _CampaignLink(quest: quest, section: section);
      case SectionType.rules:
        return _Rules(section: section);
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewPadding = MediaQueryData.fromView(View.of(context)).padding;
    return BackgroundBox.named(
      'background_codex',
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: max(viewPadding.bottom, 24)),
          child: Column(
            spacing: 24,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _Header(
                headerPath: _headerPath(quest, page),
                quest: quest,
                page: page,
              ),
              ...page.sections.where((s) => canShowSection(s)).map((s) =>
                  SafeArea(
                      top: false,
                      bottom: false,
                      minimum: EdgeInsets.only(left: 24, right: 24),
                      child: widgetForSection(s))),
            ],
          ),
        ),
      ),
    );
  }
}

class _CampaignLink extends StatelessWidget {
  const _CampaignLink({
    required this.quest,
    required this.section,
  });

  final QuestDef quest;
  final Section section;

  void _onContinue(BuildContext context) async {
    Navigator.of(context).pop();
    final questLink = section.questLink;
    if (questLink != null) {
      Navigator.of(context).pushQuest(questId: questLink);
    } else {
      final encounterId = section.value ?? quest.encounters.first.id;
      Navigator.of(context).pushEncounter(encounterId: encounterId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final body = section.body ?? '';
    return EncounterPanel(
      title: section.title ?? 'Campaign Link',
      icon: RoveIcon.small('campaign_link'),
      foregroundColor: RovePalette.setupForeground,
      backgroundColor: RovePalette.setupBackground,
      child: Column(children: [
        Align(alignment: Alignment.centerLeft, child: RoveText(body)),
        RoveTheme.verticalSpacingBox,
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            RoveDialogActionButton(
              color: RovePalette.setupForeground,
              title: 'Proceed',
              onPressed: () {
                _onContinue(context);
              },
            )
          ],
        )
      ]),
    );
  }
}

class _Artwork extends StatelessWidget {
  const _Artwork({
    required this.name,
  });

  final String name;

  @override
  Widget build(BuildContext context) {
    final campaignDef = CampaignModel.instance.campaignDefinition;
    final figure = campaignDef.figureDefinitionForName(name);
    assert(figure != null);
    if (figure == null) {
      return SizedBox.shrink();
    }
    final asset = campaignDef.pathForFigure(figure);
    return ConstrainedBox(
        constraints: BoxConstraints(
            maxHeight: RoveTheme.dialogMaxWidth,
            maxWidth: RoveTheme.dialogMaxWidth),
        child: Image.asset(asset, fit: BoxFit.cover));
  }
}

class _Rules extends StatelessWidget {
  const _Rules({
    required this.section,
  });

  final Section section;

  @override
  Widget build(BuildContext context) {
    return EncounterPanel(
      title: section.title ?? 'Special Rules',
      icon: RoveIcon.small('special_rules'),
      foregroundColor: RovePalette.rulesForeground,
      backgroundColor: RovePalette.rulesBackground,
      child: Align(
          alignment: Alignment.centerLeft, child: RoveText(section.body ?? '')),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.headerPath,
    required this.quest,
    required this.page,
  });

  final String headerPath;
  final QuestDef quest;
  final ChapterPage page;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(headerPath),
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
                          quest.shortTitle ?? quest.title,
                          style: RoveTheme.titleStyle(color: Colors.white),
                        ),
                      ),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          page.title,
                          style: RoveTheme.headerStyle(color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: false,
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                child: IconButton(
                    color: Colors.white,
                    onPressed: () {},
                    icon: Icon(Icons.navigate_before)),
              ),
            ],
          )),
    );
  }
}
