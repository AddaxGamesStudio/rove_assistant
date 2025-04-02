import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:rove_assistant/model/encounter_model.dart';

class CampaignConfig {
  static final CampaignConfig _instance = CampaignConfig._privateConstructor();

  CampaignConfig._privateConstructor();

  static CampaignConfig get instance => _instance;

  late Map<String, dynamic> config;

  bool hasTickVictoryPrompt({required EncounterModel encounter}) {
    final id = encounter.encounterDef.id;
    final tickVictoryPrompt =
        config['encounters']?[id]?['tick_victory_prompt'] ?? false;
    return tickVictoryPrompt;
  }

  String? replaceVictoryWithMilestone({required String encounterId}) {
    return config['encounters']?[encounterId]
        ?['replace_victory_with_milestone'];
  }

  String? headerPath({required String encounterId}) {
    return config['encounters']?[encounterId]?['header'];
  }

  Future<void> load(BuildContext context) async {
    final rootBundle = DefaultAssetBundle.of(context);
    const path = 'assets/data/config.json';
    rootBundle.evict(path);
    final String configJson = await rootBundle.loadString(path, cache: false);
    final data = json.decode(configJson);
    config = data;
  }
}
