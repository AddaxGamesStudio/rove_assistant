import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:rove_assistant/model/campaign_model.dart';
import 'package:rove_assistant/model/players_model.dart';
import 'package:rove_data_types/rove_data_types.dart';

class Analytics {
  static bool disabled = false;

  static Map<String, Object> _defaultParameters() {
    final campaign = CampaignModel.instance.campaignOrNull;
    return {
      if (campaign case final value?) 'campaign_id': value.id,
    };
  }

  static Map<String, Object> _encounterParameters(EncounterDef encounter) {
    final players = PlayersModel.instance.players;
    return {
      'encounter_id': encounter.id,
      'encounter_expansion': encounter.expansion ?? coreCampaignKey,
      'player_count': PlayersModel.instance.players.length,
      ...Map.fromEntries(players.map((player) {
        return MapEntry(player.roverClass.name, 1);
      })),
    };
  }

  static Future<void> logAppOpen() async {
    if (Analytics.disabled) return;
    FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    await analytics.logAppOpen();
  }

  static Future<void> logEncounterScreen(EncounterDef encounter) async {
    if (Analytics.disabled) return;
    FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    await analytics.logScreenView(screenName: '/encounter', parameters: {
      ..._defaultParameters(),
      ..._encounterParameters(encounter)
    });
  }

  static Future<void> logScreen(String name,
      {Map<String, String>? parameters}) async {
    if (Analytics.disabled) return;
    FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    await analytics.logScreenView(screenName: name, parameters: {
      ..._defaultParameters(),
      ...parameters ?? {},
    });
  }

  static Future<void> logEncounterStart(EncounterDef encounter) async {
    if (Analytics.disabled) return;
    FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    await logEncounterEvent(encounter, 'encounter_start');
    await analytics.logLevelStart(levelName: encounter.id, parameters: {
      ..._defaultParameters(),
      ..._encounterParameters(encounter)
    });
  }

  static Future<void> logEncounterComplete(EncounterDef encounter,
      {required EncounterRecord record}) async {
    if (Analytics.disabled) return;
    FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    final parameters = {
      'challenge_1': record.completedChallenges.isNotEmpty
          ? record.completedChallenges[0]
          : 0,
      'challenge_2': record.completedChallenges.length > 1
          ? record.completedChallenges[1]
          : 0,
      'challenge_3': record.completedChallenges.length > 2
          ? record.completedChallenges[2]
          : 0,
    };
    await logEncounterEvent(encounter, 'encounter_complete',
        parameters: parameters);
    await analytics
        .logLevelEnd(levelName: encounter.id, success: 1, parameters: {
      ..._defaultParameters(),
      ..._encounterParameters(encounter),
      ...parameters,
    });
  }

  static Future<void> logEvent(String name,
      {Map<String, Object>? parameters}) async {
    if (Analytics.disabled) return;
    FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    await analytics.logEvent(
        name: name, parameters: {..._defaultParameters(), ...parameters ?? {}});
  }

  static Future<void> logEncounterEvent(EncounterDef encounter, String name,
      {Map<String, Object>? parameters}) async {
    await logEvent(name, parameters: {
      ..._encounterParameters(encounter),
      ...parameters ?? {},
    });
  }

  static void logPlayerEvent(Player player, String name,
      {Map<String, String>? parameters}) async {
    await logEvent(name, parameters: {
      'player_class': player.roverClass.name,
      ...parameters ?? {},
    });
  }

  static Future<void> logPlayerItemEvent(
      Player player, ItemDef item, String name,
      {Map<String, String>? parameters}) async {
    await logEvent(name, parameters: {
      'player_class': player.roverClass.name,
      'item_name': item.name,
      'item_slot': item.slotType.name,
      ...parameters ?? {},
    });
  }

  static Future<void> logLevelUp(int level) async {
    if (Analytics.disabled) return;
    FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    await analytics.logLevelUp(level: level, parameters: {
      ..._defaultParameters(),
    });
  }
}
