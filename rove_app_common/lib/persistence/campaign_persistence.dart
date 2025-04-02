import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:rove_app_common/model/campaign_model.dart';
import 'package:rove_app_common/persistence/preferences.dart';
import 'package:rove_data_types/rove_data_types.dart';

const String _keyAllCampaignKeys = 'rove.campaigns.all';
const String _keyCurrentCampaignKey = 'rove.campaigns.current';

class CampaignPersistence with CampaignPersistor {
  static String _keyFromCampaign(Campaign campaign) =>
      'rove.campaigns.save.${campaign.id}';

  @override
  Campaign? get currentCampaign {
    final prefs = Preferences.silentPrefs;
    final String? currentCampaignId = prefs.getString(_keyCurrentCampaignKey);
    if (currentCampaignId == null) {
      return null;
    }
    final String? campaignJson = prefs.getString(currentCampaignId);
    if (campaignJson == null) {
      debugPrint('Campaign $currentCampaignId not found in prefs.');
      prefs.remove(currentCampaignId);
      return null;
    }
    return Campaign.fromJson(json.decode(campaignJson));
  }

  @override
  List<Campaign> get allCampaigns {
    final prefs = Preferences.silentPrefs;
    final List<String>? campaignKeys = prefs.getStringList(_keyAllCampaignKeys);
    if (campaignKeys == null) {
      return [];
    }
    return campaignKeys
        .where((key) => prefs.containsKey(key))
        .map((key) => prefs.getString(key))
        .where((json) => json != null)
        .map((json) => Campaign.fromJson(jsonDecode(json!)))
        .toList();
  }

  @override
  Future<void> deleteCampaign(Campaign campaign) async {
    await campaign.delete();
  }

  @override
  Future<void> saveCampaign(Campaign campaign) async {
    await campaign.save();
  }
}

extension on Campaign {
  Future<void> save() async {
    saveDate = DateTime.now();
    final prefs = Preferences.silentPrefs;
    final List<String> campaignKeys =
        prefs.getStringList(_keyAllCampaignKeys) ?? [];
    final key = CampaignPersistence._keyFromCampaign(this);
    await prefs.setString(_keyCurrentCampaignKey, key);
    await prefs.setString(key, jsonEncode(this));
    if (!campaignKeys.contains(key)) {
      campaignKeys.add(key);
      await prefs.setStringList(_keyAllCampaignKeys, campaignKeys);
    }
  }

  Future<void> delete() async {
    deleted = true;
    final prefs = Preferences.silentPrefs;
    final List<String> campaignKeys =
        prefs.getStringList(_keyAllCampaignKeys) ?? [];
    await prefs.remove(CampaignPersistence._keyFromCampaign(this));
    campaignKeys.remove(name);
    await prefs.setStringList(_keyAllCampaignKeys, campaignKeys);
  }
}
