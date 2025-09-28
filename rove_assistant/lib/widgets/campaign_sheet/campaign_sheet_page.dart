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
  'party_name': (440, 142),
  'level_1': (1626, 140),
  'level_2': (1626 + 54, 140),
  'level_3': (1626 + 54 + 54, 140),
  'level_4': (1968, 140),
  'level_5': (1968 + 54, 140),
  'level_6': (1968 + 54 + 54, 140),
  'level_7': (2284, 140),
  'level_8': (2284 + 54, 140),
  'level_9': (2284 + 54 + 54, 140),
  'base_class_1': (168, 342),
  'base_class_2': (168, 342 + 85),
  'base_class_3': (168, 342 + 85 + 85),
  'base_class_4': (168, 342 + 85 + 85 + 85),
  'prime_class_1': (660, 342),
  'prime_class_2': (660, 342 + 85),
  'prime_class_3': (660, 342 + 85 + 85),
  'prime_class_4': (660, 342 + 85 + 85 + 85),
  'apex_class_1': (1162, 342),
  'apex_class_2': (1162, 342 + 85),
  'apex_class_3': (1162, 342 + 85 + 85),
  'apex_class_4': (1162, 342 + 85 + 85 + 85),
  'trait_1_1': (1672, 342),
  'trait_1_2': (1672, 342 + 85),
  'trait_1_3': (1672, 342 + 85 + 85),
  'trait_1_4': (1672, 342 + 85 + 85 + 85),
  'trait_2_1': (2091, 342),
  'trait_2_2': (2091, 342 + 85),
  'trait_2_3': (2091, 342 + 85 + 85),
  'trait_2_4': (2091, 342 + 85 + 85 + 85),
  '0.1': (207, 1087),
  '0.2': (207 + 40, 1087),
  '0.3': (207 + 40 + 40, 1087),
  '1.1': (513, 969),
  '1.2': (513 + 40, 969),
  '1.3': (513 + 40 + 40, 969),
  '1.4': (513 + 40 + 40 + 40, 969),
  '1.5': (513 + 40 + 40 + 40 + 42, 969),
  '2.1': (510, 1209),
  '2.2': (510 + 40, 1209),
  '2.3': (510 + 40 + 40, 1209),
  '2.4': (510 + 40 + 40 + 40, 1209),
  '2.5': (510 + 40 + 40 + 40 + 42, 1209),
  '3.1': (931, 969),
  '3.2': (931 + 40, 969),
  '3.3': (931 + 40 + 40, 969),
  '3.4': (931 + 40 + 40 + 40, 969),
  '3.5': (931 + 40 + 40 + 40 + 42, 969),
  '4.1': (931, 1209),
  '4.2': (931 + 40, 1209),
  '4.3': (931 + 40 + 40, 1209),
  '4.4': (931 + 40 + 40 + 40, 1209),
  '4.5': (931 + 40 + 40 + 40 + 42, 1209),
  '5.1': (1347, 969),
  '5.2': (1347 + 40, 969),
  '5.3': (1347 + 40 + 40, 969),
  '5.4': (1347 + 40 + 40 + 40, 969),
  '5.5': (1347 + 40 + 40 + 40 + 42, 969),
  '6.1': (1347, 1209),
  '6.2': (1347 + 40, 1209),
  '6.3': (1347 + 40 + 40, 1209),
  '6.4': (1347 + 40 + 40 + 40, 1209),
  '6.5': (1347 + 40 + 40 + 40 + 42, 1209),
  '7.1': (1766, 969),
  '7.2': (1766 + 40, 969),
  '7.3': (1766 + 40 + 40, 969),
  '7.4': (1766 + 40 + 40 + 40, 969),
  '7.5': (1766 + 40 + 40 + 40 + 42, 969),
  '8.1': (1766, 1209),
  '8.2': (1766 + 40, 1209),
  '8.3': (1766 + 40 + 40, 1209),
  '8.4': (1766 + 40 + 40 + 40, 1209),
  '8.5': (1766 + 40 + 40 + 40 + 42, 1209),
  '9.1a': (2167, 1089),
  '9.1b': (2167, 1089),
  '9.2': (2167 + 40, 1089),
  '9.3': (2167 + 40 + 40, 1089),
  '9.4': (2167 + 40 + 40 + 40, 1089),
  '9.5': (2167 + 40 + 40 + 40 + 42, 1089),
  '9.6': (2167 + 40 + 40 + 40 + 42 + 42, 1089),
  'chapter_2.I': (301, 1382),
  'chapter_3.I': (822, 1382),
  'chapter_4.I': (1341, 1382),
  'chapter_5.I': (1869, 1382),
  CampaignMilestone.milestone1dot5: (182, 1671),
  CampaignMilestone.milestone2dot5Sovereign: (182, 1832),
  CampaignMilestone.milestone2dot5Advocate: (182, 1991),
  CampaignMilestone.milestone3dot4: (768, 1671),
  CampaignMilestone.milestone3dot5: (768, 1832),
  CampaignMilestone.milestone4dot5: (768, 1991),
  CampaignMilestone.milestone5dot5: (768 + 585, 1671),
  CampaignMilestone.milestone6ZeepurahSlain: (1730, 1832),
  CampaignMilestone.milestone6ZeepurahContained: (1351, 1832),
  CampaignMilestone.milestone6ZeepurahLost: (1594, 1832),
  CampaignMilestone.milestone7dot2Querists0: (1414, 1991),
  CampaignMilestone.milestone7dot2Querists1: (1527, 1991),
  CampaignMilestone.milestone7dot2Querists2: (1630, 1991),
  CampaignMilestone.milestone7dot2Querists3: (1739, 1991),
  CampaignMilestone.milestone7dot5: (1933, 1672),
  CampaignMilestone.milestone8dot5: (1933, 1832),
  CampaignMilestone.milestoneIdot4: (1933, 1991),
  'merchant_1': (247, 2195),
  'merchant_2': (247 + 70, 2195),
  'merchant_3': (247 + 70 + 70, 2195),
  'merchant_4': (247 + 70 + 70 + 70, 2195),
  'Ahma Cowl': (145, 2438),
  'Ezmenite Plate': (145, 2438 + 67),
  'Gruv Scale-Mail': (145, 2438 + 67 * 2),
  'Miasma Cape': (145, 2438 + 67 * 3),
  'Gallant Crown': (145, 2438 + 67 * 4),
  'Coruscant Amblers': (145, 2436 + 67 * 5),
  'Twisted Chargers': (145, 2436 + 67 * 6),
  'Thundering Hikers': (145, 2436 + 67 * 7),
  'Thick Briarshawl': (145, 2436 + 67 * 8),
  'Ethereal Catena': (145, 2436 + 67 * 9),
  'Ethereal Aegis': (145, 2436 + 67 * 10),
  'Zyderos Cuirass': (145, 2436 + 67 * 11),
  'Cutting Galewing': (707, 2207),
  'Tendervine Ward': (707, 2207 + 67),
  'Ezmenite Lance': (707, 2207 + 67 * 2),
  'Scour Brand': (707, 2207 + 67 * 3),
  'Mercurial Bough': (707, 2206 + 67 * 4),
  "Rakifa's Garrote": (707, 2206 + 67 * 5),
  "Zaghan's Limb": (707, 2206 + 67 * 6),
  "Uzem's Judgment": (707, 2206 + 67 * 7),
  'Ezmenite Guard': (707, 2205 + 67 * 8),
  "Zeepurah's Piercer": (707, 2205 + 67 * 9),
  'ether_field_quest0_2_aura': (1366, 2280),
  'ether_field_quest0_2_miasma': (1366, 2280 + 61),
  'ether_field_quest3_4_aura_a': (1601, 2262),
  'ether_field_quest3_4_aura_b': (1776, 2262),
  'ether_field_quest3_4_miasma_a': (1601, 2262 + 61),
  'ether_field_quest3_4_miasma_b': (1776, 2262 + 61),
  'ether_field_quest5_6_aura_a': (1347, 2470),
  'ether_field_quest5_6_aura_b': (2008, 2470),
  'ether_field_quest5_6_miasma_a': (1347, 2470 + 61),
  'ether_field_quest5_6_miasma_b': (1987, 2470 + 61),
  'ether_field_quest7_9_aura_a': (1347, 2677),
  'ether_field_quest7_9_aura_b': (1525, 2677),
  'ether_field_quest7_9_miasma_a': (1347, 2677 + 61),
  'ether_field_quest7_9_miasma_b': (1525, 2677 + 61),
  'lyst': (693, 2970),
};

const _sizes = {
  'party_name': Size(871, 67),
  'rover_class': Size(449, 65),
  'trait': Size(370, 65),
  'large_dot': Size(44, 44),
  'check': Size(80, 80),
  'lyst': Size(1796, 243),
};

extension on CampaignDef {
  static const List<String> rewardArmor = [
    'Ahma Cowl',
    'Ezmenite Plate',
    'Gruv Scale-Mail',
    'Miasma Cape',
    'Gallant Crown',
    'Coruscant Amblers',
    'Twisted Chargers',
    'Thundering Hikers',
    'Thick Briarshawl',
    'Ethereal Catena',
    'Ethereal Aegis',
    'Zyderos Cuirass'
  ];

  static const List<String> rewardWeapons = [
    'Cutting Galewing',
    'Tendervine Ward',
    'Ezmenite Lance',
    'Scour Brand',
    'Mercurial Bough',
    "Rakifa's Garrote",
    "Zaghan's Limb",
    "Uzem's Judgment",
    'Ezmenite Guard',
    "Zeepurah's Piercer"
  ];

  List<String> completedEncountersForCampaign(Campaign campaign) {
    return quests
        .where((q) => q.expansion == null)
        .expand((q) => q.encounters)
        .map((e) => e.id)
        .where((e) =>
            campaign.encounterRecordForId(e)?.complete == true || kDebugMode)
        .toList();
  }

  List<String> achievedMilestonesForCampaign(Campaign campaign) {
    return CampaignMilestone.coreCampaignSheetMilestones
        .where((m) => campaign.milestones.contains(m) || kDebugMode)
        .toList();
  }

  List<String> unlockedRewardItemsForCampaign(Campaign campaign) {
    return (rewardArmor + rewardWeapons)
        .where((r) => campaign.unlockedRewardItems.contains(r))
        .toList();
  }

  List<String> etherFieldKeysForCampaign(Campaign campaign) {
    final quest1Completed = campaign.isCompletedForQuest('1');
    final quest2Completed = campaign.isCompletedForQuest('2');
    final quest3Completed = campaign.isCompletedForQuest('3');
    final quest4Completed = campaign.isCompletedForQuest('4');
    final quest5Completed = campaign.isCompletedForQuest('5');
    final quest6Completed = campaign.isCompletedForQuest('6');
    return [
      if (quest1Completed) ...[
        'ether_field_quest3_4_aura_b',
        'ether_field_quest3_4_miasma_a'
      ],
      if (quest2Completed) ...[
        'ether_field_quest3_4_aura_a',
        'ether_field_quest3_4_miasma_b'
      ],
      if (quest3Completed) ...[
        'ether_field_quest5_6_aura_b',
        'ether_field_quest5_6_miasma_b'
      ],
      if (quest4Completed) ...[
        'ether_field_quest5_6_aura_a',
        'ether_field_quest5_6_miasma_a'
      ],
      if (quest5Completed) ...[
        'ether_field_quest7_9_aura_b',
        'ether_field_quest7_9_miasma_b'
      ],
      if (quest6Completed) ...[
        'ether_field_quest7_9_aura_a',
        'ether_field_quest7_9_miasma_a'
      ],
    ];
  }
}

class _CampaignSheetLayoutDelegate extends MultiChildLayoutDelegate {
  _CampaignSheetLayoutDelegate({
    required this.campaign,
    required this.encounters,
    required this.milestones,
    required this.players,
    required this.rewards,
    required this.fieldEffects,
  });

  final List<Player> players;
  final Campaign campaign;
  final List<String> encounters;
  final List<String> milestones;
  final List<String> rewards;
  final List<String> fieldEffects;

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
      layoutForKey(key, absoluteSize: Size(44, 44));
    }
    for (final key in milestones) {
      layoutForKey(key, sizeKey: 'large_dot');
    }
    for (int i = 1; i <= min(campaign.merchantLevel, 4); i++) {
      layoutForKey('merchant_$i', sizeKey: 'check');
    }
    for (final key in rewards) {
      layoutForKey(key, sizeKey: 'large_dot');
    }
    for (final key in [
      'ether_field_quest0_2_aura',
      'ether_field_quest0_2_miasma'
    ]) {
      layoutForKey(key, sizeKey: 'large_dot');
    }
    for (final key in fieldEffects) {
      layoutForKey(key, sizeKey: 'check');
    }
    layoutForKey('lyst');
  }

  @override
  bool shouldRelayout(_CampaignSheetLayoutDelegate oldDelegate) {
    return false;
  }
}

class CampaignSheetPage extends StatelessWidget {
  const CampaignSheetPage({super.key, this.appBarLeading});

  final Widget? appBarLeading;

  @override
  Widget build(BuildContext context) {
    final campaign = CampaignModel.instance.campaign;
    final players = PlayersModel.instance.players;

    textWithId(String id,
        {required String text,
        AlignmentGeometry alignment = Alignment.centerLeft}) {
      return SheetText(id: id, text: text, alignment: alignment);
    }

    checkWitId(String id) {
      return SheetCheckMark(id: id);
    }

    final campaignDef = CampaignModel.instance.campaignDefinition;
    final evolutionStage = roverEvolutionStageForLevel(campaign.roversLevel);
    final encounters = campaignDef.completedEncountersForCampaign(campaign);
    final milestones = campaignDef.achievedMilestonesForCampaign(campaign);
    final rewards = campaignDef.unlockedRewardItemsForCampaign(campaign);
    final fieldEffects = campaignDef.etherFieldKeysForCampaign(campaign);
    final dots = encounters +
        milestones +
        rewards +
        ['ether_field_quest0_2_aura', 'ether_field_quest0_2_miasma'];
    return CampaignSheetScaffold(
      title: 'Campaign Sheet',
      foregroundColor: RovePalette.campaignSheetForeground,
      blankColorURL:
          'https://www.roveassistant.com/files/campaign_sheet_color.pdf',
      blankPrinterFriendlyURL:
          'https://www.roveassistant.com/files/campaign_sheet.pdf',
      appBarLeading: appBarLeading,
      child: Stack(children: [
        Image(
          image: RoveAssets.campaignSheetFront,
          fit: BoxFit.contain,
        ),
        Positioned.fill(
          child: CustomMultiChildLayout(
            delegate: _CampaignSheetLayoutDelegate(
                campaign: campaign,
                players: players,
                encounters: encounters,
                milestones: milestones,
                rewards: rewards,
                fieldEffects: fieldEffects),
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
              for (int i = 1; i <= min(campaign.merchantLevel, 4); i++)
                checkWitId('merchant_$i'),
              for (final key in fieldEffects) checkWitId(key),
              for (final dot in dots) SheetDot(id: dot),
              textWithId('lyst',
                  text: '${campaign.lyst}', alignment: Alignment.center),
            ],
          ),
        )
      ]),
    );
  }
}
