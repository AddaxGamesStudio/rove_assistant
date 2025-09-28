import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rove_assistant/theme/rove_assets.dart';
import 'package:rove_assistant/theme/rove_palette.dart';
import 'package:rove_assistant/model/campaign_model.dart';
import 'package:rove_assistant/model/players_model.dart';
import 'package:rove_assistant/widgets/campaign_sheet/campaign_sheet_scaffold.dart';
import 'package:rove_assistant/widgets/campaign_sheet/sheet_check_mark.dart';
import 'package:rove_assistant/widgets/campaign_sheet/sheet_dot.dart';
import 'package:rove_assistant/widgets/campaign_sheet/sheet_text.dart';
import 'package:rove_data_types/rove_data_types.dart';

const _absoluteOrigins = {
  'party_name': (420, 128),
  'level_1': (1637, 124),
  'level_2': (1637 + 56, 124),
  'level_3': (1637 + 56 + 56, 124),
  'level_4': (1988, 124),
  'level_5': (1988 + 56, 124),
  'level_6': (1988 + 56 + 56, 124),
  'level_7': (2314, 124),
  'level_8': (2314 + 56, 124),
  'level_9': (2314 + 56 + 56, 124),
  'base_class_1': (138, 308),
  'base_class_2': (138, 308 + 89),
  'base_class_3': (138, 308 + 89 + 89),
  'base_class_4': (138, 308 + 89 + 89 + 89),
  'prime_class_1': (660, 308),
  'prime_class_2': (660, 308 + 89),
  'prime_class_3': (660, 308 + 89 + 89),
  'prime_class_4': (660, 308 + 89 + 89 + 89),
  'apex_class_1': (1170, 308),
  'apex_class_2': (1170, 308 + 89),
  'apex_class_3': (1170, 308 + 89 + 89),
  'apex_class_4': (1170, 308 + 89 + 89 + 89),
  'trait_1_1': (1686, 308),
  'trait_1_2': (1686, 308 + 89),
  'trait_1_3': (1686, 308 + 89 + 89),
  'trait_1_4': (1686, 308 + 89 + 89 + 85),
  'trait_2_1': (2124, 308),
  'trait_2_2': (2124, 308 + 89),
  'trait_2_3': (2124, 308 + 89 + 89),
  'trait_2_4': (2124, 308 + 89 + 89 + 89),
  '10_act1.1': (132, 1014),
  '10_act1.2.early': (132 + 403, 855),
  '10_act1.2.late': (132 + 403, 855),
  '10_act1.3.early': (132 + 403, 1014),
  '10_act1.3.late': (132 + 403, 1014),
  '10_act1.4.early': (132 + 403, 1172),
  '10_act1.4.late': (132 + 403, 1172),
  '10_act1.5': (132 + 403 + 403, 1014),
  '10_act2.6.early': (1339, 855),
  '10_act2.6.late': (1339, 855),
  '10_act2.7.early': (1339, 1014),
  '10_act2.7.late': (1339, 1014),
  '10_act2.8.early': (1339, 1172),
  '10_act2.8.late': (1339, 1172),
  '10_act2.9': (1339 + 402, 1014),
  '10_act2.10': (1339 + 402 + 402, 1014),
  CampaignMilestone.milestone10dot1: (256, 2741),
  'board_b': (256, 2841),
  CampaignMilestone.milestone10dot4: (162, 1434),
  CampaignMilestone.milestone10dot2: (162, 1434 + 112),
  CampaignMilestone.milestone10dot3: (162, 1434 + 112 + 112),
  CampaignMilestone.milestone10dot6: (755, 1434),
  CampaignMilestone.milestone10dot7: (755, 1434 + 112),
  CampaignMilestone.milestone10dot8: (755, 1434 + 112 + 112),
  'shop_open': (1350, 1434),
  'hra_marl': (1350, 1434 + 111),
  'hra_charged': (1946, 1434 + 111),
  'xulc_stash': (1946, 1434),
  'stage_3_player_name_1': (470, 2072),
  'stage_3_player_name_2': (470 + 506, 2072),
  'stage_3_player_name_3': (470 + 506 + 506, 2072),
  'stage_3_player_name_4': (470 + 506 + 506 + 506, 2072),
  'xulc_trait_player_1': (470, 2072 + 110),
  'xulc_trait_player_2': (470 + 506, 2072 + 110),
  'xulc_trait_player_3': (470 + 506 + 506, 2072 + 110),
  'xulc_trait_player_4': (470 + 506 + 506 + 506, 2072 + 110),
  'stage_4_player_name_1': (470, 2072 + 310),
  'stage_4_player_name_2': (470 + 506, 2072 + 310),
  'stage_4_player_name_3': (470 + 506 + 506, 2072 + 310),
  'stage_4_player_name_4': (470 + 506 + 506 + 506, 2072 + 310),
  'stage_4_choice_player_1': (470, 2072 + 310 + 110),
  'stage_4_choice_player_2': (470 + 506, 2072 + 310 + 110),
  'stage_4_choice_player_3': (470 + 506 + 506, 2072 + 310 + 110),
  'stage_4_choice_player_4': (470 + 506 + 506 + 506, 2072 + 310 + 110),
  'ether_field_aura': (215, 3095),
  'ether_field_miasma': (215, 3095 + 61),
  'lyst': (746, 2860),
};

const _sizes = {
  'party_name': Size(871, 67),
  'rover_class': Size(449, 65),
  'trait': Size(380, 65),
  'player_name': Size(450, 65),
  'xulc_trait': Size(450, 65),
  'large_dot': Size(60, 60),
  'check': Size(80, 80),
  'lyst': Size(1796, 243),
};

extension on CampaignDef {
  List<String> completedEncountersForCampaign(Campaign campaign) {
    return quests
        .where((q) => q.expansion == xulcExpansionKey)
        .expand((q) => q.encounters)
        .where((e) => e.page == null)
        .map((e) => e.id)
        .where((e) =>
            campaign.encounterRecordForId(e)?.complete == true || kDebugMode)
        .toList();
  }

  List<String> achievedMilestonesForCampaign(Campaign campaign) {
    return CampaignMilestone.xulcCampaignSheetMilestones
        .where((m) => campaign.milestones.contains(m) || kDebugMode)
        .toList();
  }
}

class _CampaignSheetLayoutDelegate extends MultiChildLayoutDelegate {
  _CampaignSheetLayoutDelegate({
    required this.campaign,
    required this.encounters,
    required this.milestones,
    required this.players,
  });

  final List<Player> players;
  final Campaign campaign;
  final List<String> encounters;
  final List<String> milestones;

  @override
  void performLayout(Size size) {
    final widthRatio = size.width / 2625.0;
    final heightRatio = size.height / 3376.0;
    layoutForKey(String key, {Size? absoluteSize, String? sizeKey}) {
      final absoluteOffset = _absoluteOrigins[key];
      absoluteSize ??=
          _sizes[key] ?? (sizeKey != null ? _sizes[sizeKey] : null);
      if (absoluteOffset == null || absoluteSize == null) {
        return;
      }
      layoutChild(
        key,
        BoxConstraints.tight(Size(absoluteSize.width * widthRatio,
            absoluteSize.height * heightRatio)),
      );
      positionChild(
          key,
          Offset(
              absoluteOffset.$1 * widthRatio, absoluteOffset.$2 * heightRatio));
    }

    layoutForKey('party_name');
    for (int i = 1; i <= min(campaign.roversLevel, 9); i++) {
      layoutForKey('level_$i', sizeKey: 'check');
    }
    for (int i = 1; i <= min(players.length, 4); i++) {
      layoutForKey('base_class_$i', sizeKey: 'rover_class');
      layoutForKey('trait_1_$i', sizeKey: 'trait');
      layoutForKey('trait_2_$i', sizeKey: 'trait');
      layoutForKey('stage_3_player_name_$i', sizeKey: 'player_name');
      layoutForKey('xulc_trait_player_$i', sizeKey: 'xulc_trait');
      layoutForKey('stage_4_player_name_$i', sizeKey: 'player_name');
      layoutForKey('stage_4_choice_player_$i', sizeKey: 'xulc_trait');
    }
    final evolutionStage = roverEvolutionStageForLevel(campaign.roversLevel);
    for (int i = 1;
        i <= min(players.length, 4) &&
            evolutionStage.index >= RoverEvolutionStage.prime.index;
        i++) {
      layoutForKey('prime_class_$i', sizeKey: 'rover_class');
    }
    for (int i = 1;
        i <= min(players.length, 4) &&
            evolutionStage.index >= RoverEvolutionStage.apex.index;
        i++) {
      layoutForKey('apex_class_$i', sizeKey: 'rover_class');
    }
    for (final key in encounters) {
      layoutForKey(key, absoluteSize: Size(60, 60));
    }
    for (final key in milestones) {
      layoutForKey(key, sizeKey: 'large_dot');
    }
    for (final key in ['ether_field_aura', 'ether_field_miasma']) {
      layoutForKey(key, sizeKey: 'large_dot');
    }
    layoutForKey('lyst');
  }

  @override
  bool shouldRelayout(_CampaignSheetLayoutDelegate oldDelegate) {
    return false;
  }
}

class XulcCampaignSheetPage extends StatelessWidget {
  const XulcCampaignSheetPage({super.key, this.appBarLeading});

  final Widget? appBarLeading;

  List<String> unnamedMilestones() {
    final model = CampaignModel.instance;
    const Map<String, List<String>> map = {
      'shop_open': ['10_act1.3.early', '10_act1.3.late'],
      'hra_marl': ['10_act1.4.early', '10_act1.4.late'],
      'hra_charged': ['10_act2.8.early', '10_act2.8.late'],
      'xulc_stash': ['10_act2.6.early', '10_act2.6.early'],
      'board_b': ['10_act1.5']
    };
    return map.entries
        .where((e) =>
            kDebugMode ||
            e.value.any((encounter) =>
                model.campaign.isCompletedForEncounter(encounter)))
        .map((e) => e.key)
        .toList();
  }

  String _stage4ChoiceForPlayer(Player player) {
    if (!CampaignModel.instance
        .hasMilestone(CampaignMilestone.milestone10dot7)) {
      return '';
    }
    return player.resignXulcHealthIncrease ? '-3 Health' : '+1 Infected Card';
  }

  @override
  Widget build(BuildContext context) {
    final campaign = CampaignModel.instance.campaign;
    final players = PlayersModel.instance.players;

    textWithId(String id,
        {required String text,
        AlignmentGeometry alignment = Alignment.centerLeft}) {
      return SheetText(
        id: id,
        text: text,
        alignment: alignment,
        color: RovePalette.xulc,
      );
    }

    checkWitId(String id) {
      return SheetCheckMark(
        id: id,
        color: RovePalette.xulc,
      );
    }

    final campaignDef = CampaignModel.instance.campaignDefinition;
    final evolutionStage = roverEvolutionStageForLevel(campaign.roversLevel);
    final encounters = campaignDef.completedEncountersForCampaign(campaign);
    final milestones = campaignDef.achievedMilestonesForCampaign(campaign) +
        unnamedMilestones();
    final dots =
        encounters + milestones + ['ether_field_aura', 'ether_field_miasma'];
    return CampaignSheetScaffold(
      title: 'Xulc Campaign Sheet',
      foregroundColor: RovePalette.xulc,
      appBarLeading: appBarLeading,
      blankColorURL:
          'https://www.roveassistant.com/files/xulc_campaign_sheet_color.pdf',
      blankPrinterFriendlyURL:
          'https://www.roveassistant.com/files/xulc_campaign_sheet.pdf',
      child: Stack(children: [
        Image(
          image: RoveAssets.xulCampaignSheetFront,
          fit: BoxFit.cover,
        ),
        Positioned.fill(
          child: CustomMultiChildLayout(
            delegate: _CampaignSheetLayoutDelegate(
              campaign: campaign,
              players: players,
              encounters: encounters,
              milestones: milestones,
            ),
            children: <Widget>[
              textWithId('party_name', text: campaign.name),
              for (int i = 1; i <= min(campaign.roversLevel, 9); i++)
                checkWitId('level_$i'),
              for (int i = 1; i <= min(players.length, 4); i++)
                textWithId('base_class_$i', text: players[i - 1].baseClassName),
              for (int i = 1;
                  i <= min(players.length, 4) &&
                      evolutionStage.index >= RoverEvolutionStage.prime.index;
                  i++)
                textWithId('prime_class_$i',
                    text: players[i - 1].primeClassName ?? ''),
              for (int i = 1;
                  i <= min(players.length, 4) &&
                      evolutionStage.index >= RoverEvolutionStage.apex.index;
                  i++)
                textWithId('apex_class_$i',
                    text: players[i - 1].apexClassName ?? ''),
              for (int i = 1; i <= min(players.length, 4); i++)
                textWithId('trait_1_$i', text: players[i - 1].trait1 ?? ''),
              for (int i = 1; i <= min(players.length, 4); i++)
                textWithId('trait_2_$i', text: players[i - 1].trait2 ?? ''),
              for (final dot in dots)
                SheetDot(
                  id: dot,
                  color: RovePalette.xulc,
                ),
              for (int i = 1; i <= min(players.length, 4); i++)
                textWithId('stage_3_player_name_$i', text: players[i - 1].name),
              for (int i = 1; i <= min(players.length, 4); i++)
                textWithId('xulc_trait_player_$i',
                    text: players[i - 1].xulcTrait ?? ''),
              for (int i = 1; i <= min(players.length, 4); i++)
                textWithId('stage_4_player_name_$i', text: players[i - 1].name),
              for (int i = 1; i <= min(players.length, 4); i++)
                textWithId('stage_4_choice_player_$i',
                    text: _stage4ChoiceForPlayer(players[i - 1])),
              textWithId('lyst',
                  text: '${campaign.lyst}', alignment: Alignment.center),
            ],
          ),
        )
      ]),
    );
  }
}
