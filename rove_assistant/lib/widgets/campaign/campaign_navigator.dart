import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:rove_assistant/theme/rove_palette.dart';
import 'package:rove_assistant/data/campaign_loader.dart';
import 'package:rove_assistant/model/campaign_model.dart';
import 'package:rove_assistant/model/players_model.dart';
import 'package:rove_assistant/services/analytics.dart';
import 'package:rove_assistant/widgets/chapter_page/chapter_page_widget.dart';
import 'package:rove_assistant/widgets/common/rove_confirm_dialog.dart';
import 'package:rove_assistant/widgets/encounter/encounter_detail.dart';
import 'package:rove_data_types/rove_data_types.dart';

extension CampaignNavigator on NavigatorState {
  Future<void> pushQuest({required String questId}) async {
    final quest =
        CampaignModel.instance.quests.firstWhereOrNull((q) => q.id == questId);
    if (quest == null) {
      return;
    }
    final page = quest.introduction;
    if (page != null) {
      await pushPage(quest: quest, page: page);
    } else {
      final encounterId = quest.encounters.firstOrNull?.id;
      if (encounterId != null) {
        await pushEncounter(encounterId: encounterId);
      }
    }
  }

  Future<void> pushPage(
      {required QuestDef quest, required ChapterPage page}) async {
    final context = this.context;
    final texts = await Future.wait(page.sections
        .where((s) => s.type == SectionType.text && s.value != null)
        .map((s) => CampaignLoader.loadText(context, s.value!,
            expansion: quest.expansion)));
    final map = Map.fromEntries(texts.map((e) => MapEntry(e.name, e)));

    if (!context.mounted) {
      return;
    }
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return ChapterPageWidget(quest: quest, page: page, texts: map);
    }));
  }

  static _showLevelUpDialog(BuildContext context) {
    Analytics.logScreen('/encounters/level_up_dialog');
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

  Future<void> pushEncounter({required String encounterId}) async {
    final quest = CampaignModel.instance.questForEncounter(encounterId);
    if (quest == null) {
      return;
    }
    final status = quest.statusForEncounter(encounterId);
    if (status == EncounterStatus.locked) {
      return;
    }

    final context = this.context;
    if (PlayersModel.instance.hasPendingLevelUp) {
      _showLevelUpDialog(context);
      return;
    }

    final encounterDef = await CampaignLoader.loadEncounter(
        context, encounterId,
        expansion: quest.expansion ?? coreCampaignKey);
    if (!context.mounted || encounterDef == null) {
      return;
    }
    Analytics.logEncounterScreen(encounterDef);

    if (!context.mounted) {
      return;
    }
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return EncounterDetail(quest: quest, encounter: encounterDef);
    }));
  }
}
