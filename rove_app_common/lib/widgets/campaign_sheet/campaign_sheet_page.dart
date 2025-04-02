import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rove_app_common/model/campaign_model.dart';
import 'package:rove_app_common/model/players_model.dart';
import 'package:rove_app_common/style/rove_app_assets.dart';
import 'package:rove_app_common/style/rove_palette.dart';
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
  '0.1': (209, 1089),
  '0.2': (209 + 40, 1089),
  '0.3': (209 + 40 + 40, 1089),
  '1.1': (515, 971),
  '1.2': (515 + 40, 971),
  '1.3': (515 + 40 + 40, 971),
  '1.4': (515 + 40 + 40 + 40, 971),
  '1.5': (515 + 40 + 40 + 40 + 42, 971),
  '2.1': (512, 1211),
  '2.2': (512 + 40, 1211),
  '2.3': (512 + 40 + 40, 1211),
  '2.4': (512 + 40 + 40 + 40, 1211),
  '2.5': (512 + 40 + 40 + 40 + 42, 1211),
  '3.1': (933, 971),
  '3.2': (933 + 40, 971),
  '3.3': (933 + 40 + 40, 971),
  '3.4': (933 + 40 + 40 + 40, 971),
  '3.5': (933 + 40 + 40 + 40 + 42, 971),
  '4.1': (933, 1211),
  '4.2': (933 + 40, 1211),
  '4.3': (933 + 40 + 40, 1211),
  '4.4': (933 + 40 + 40 + 40, 1211),
  '4.5': (933 + 40 + 40 + 40 + 42, 1211),
  '5.1': (1349, 971),
  '5.2': (1349 + 40, 971),
  '5.3': (1349 + 40 + 40, 971),
  '5.4': (1349 + 40 + 40 + 40, 971),
  '5.5': (1349 + 40 + 40 + 40 + 42, 971),
  '6.1': (1349, 1211),
  '6.2': (1349 + 40, 1211),
  '6.3': (1349 + 40 + 40, 1211),
  '6.4': (1349 + 40 + 40 + 40, 1211),
  '6.5': (1349 + 40 + 40 + 40 + 42, 1211),
  '7.1': (1768, 971),
  '7.2': (1768 + 40, 971),
  '7.3': (1768 + 40 + 40, 971),
  '7.4': (1768 + 40 + 40 + 40, 971),
  '7.5': (1768 + 40 + 40 + 40 + 42, 971),
  '8.1': (1768, 1211),
  '8.2': (1768 + 40, 1211),
  '8.3': (1768 + 40 + 40, 1211),
  '8.4': (1768 + 40 + 40 + 40, 1211),
  '8.5': (1768 + 40 + 40 + 40 + 42, 1211),
  '9.1a': (2169, 1091),
  '9.1b': (2169, 1091),
  '9.2': (2169 + 40, 1091),
  '9.3': (2169 + 40 + 40, 1091),
  '9.4': (2169 + 40 + 40 + 40, 1091),
  '9.5': (2169 + 40 + 40 + 40 + 42, 1091),
  '9.6': (2169 + 40 + 40 + 40 + 42 + 42, 1091),
  'I.1': (303, 1384),
  'I.2': (824, 1384),
  'I.3': (1343, 1384),
  'I.4': (1871, 1384),
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
  'Tindervine Ward': (707, 2207 + 67),
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
    'Tindervine Ward',
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
        .where((e) => campaign.encounterRecordForId(e)?.complete == true)
        .toList();
  }

  List<String> achievedMilestonesForCampaign(Campaign campaign) {
    return CampaignMilestone.coreCampaignSheetMilestones
        .where((m) => campaign.milestones.contains(m))
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
      layoutForKey(key, absoluteSize: Size(40, 40));
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
  const CampaignSheetPage({super.key});

  @override
  Widget build(BuildContext context) {
    final campaign = CampaignModel.instance.campaign;
    final players = PlayersModel.instance.players;

    textWithKey(String key,
        {required String text,
        AlignmentGeometry alignment = Alignment.centerLeft}) {
      return LayoutId(
        id: key,
        child: FittedBox(
          alignment: alignment,
          fit: BoxFit.scaleDown,
          child: Text(
            text,
            style: TextStyle(
                fontSize: 24,
                height: 1.2,
                color: RovePalette.campaignSheetForeground,
                fontFamily: GoogleFonts.grenze().fontFamily,
                fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    checkWithKey(String key) {
      return LayoutId(
        id: key,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            '✗',
            style: TextStyle(
                fontSize: 24,
                height: 1,
                color: RovePalette.campaignSheetForeground),
          ),
        ),
      );
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
    return Scaffold(
      backgroundColor: RovePalette.campaignSheetBackground,
      body: SingleChildScrollView(
          child: Stack(children: [
        Image(
          image: RoveAppAssets.campaignSheetFront,
          fit: BoxFit.cover,
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
              textWithKey('party_name', text: campaign.name),
              for (int i = 1; i <= min(campaign.roversLevel, 9); i++)
                checkWithKey('level_$i'),
              for (int i = 1; i <= min(players.length, 4); i++)
                textWithKey('base_class_$i',
                    text: players[i - 1].baseClassName),
              for (int i = 1;
                  i <= min(players.length, 4) &&
                      evolutionStage.index >= RoverEvolutionStage.prime.index;
                  i++)
                textWithKey('prime_class_$i',
                    text: players[i - 1].primeClassName ?? ''),
              for (int i = 1;
                  i <= min(players.length, 4) &&
                      evolutionStage.index >= RoverEvolutionStage.apex.index;
                  i++)
                textWithKey('apex_class_$i',
                    text: players[i - 1].apexClassName ?? ''),
              for (int i = 1; i <= min(players.length, 4); i++)
                textWithKey('trait_1_$i', text: players[i - 1].trait1 ?? ''),
              for (int i = 1; i <= min(players.length, 4); i++)
                textWithKey('trait_2_$i', text: players[i - 1].trait2 ?? ''),
              for (int i = 1; i <= min(campaign.merchantLevel, 4); i++)
                checkWithKey('merchant_$i'),
              for (final key in fieldEffects) checkWithKey(key),
              for (final dot in dots)
                LayoutId(
                  id: dot,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      '⬤',
                      style: TextStyle(
                          fontSize: 24,
                          color: RovePalette.campaignSheetForeground),
                    ),
                  ),
                ),
              textWithKey('lyst',
                  text: '${campaign.lyst}', alignment: Alignment.center),
            ],
          ),
        )
      ])),
    );
  }
}
