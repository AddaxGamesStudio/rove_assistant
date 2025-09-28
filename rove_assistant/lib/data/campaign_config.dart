import 'dart:convert';

import 'package:flutter/widgets.dart';

class CampaignConfig {
  static final CampaignConfig _instance = CampaignConfig._privateConstructor();

  CampaignConfig._privateConstructor();

  static CampaignConfig get instance => _instance;

  late Map<String, dynamic> config;

  String? headerPathForPage(String pageId) {
    return config['pages']?[pageId]?['header'] ?? config['default_header'];
  }

  String? headerPathForEncounter(String encounterId) {
    return config['encounters']?[encounterId]?['header'] ??
        config['default_header'];
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
