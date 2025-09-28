import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'classes/rover_class_behavior.dart';
import 'quest_0.dart';
import 'quest_1.dart';
import 'quest_2.dart';
import 'quest_3.dart';
import 'quest_4.dart';
import 'quest_5.dart';
import 'intermissions.dart';
import 'quest_6.dart';
import 'quest_7.dart';
import 'quest_8.dart';
import 'quest_9.dart';
import 'quest_10.dart';
import 'package:rove_data_types/rove_data_types.dart';

final Map<String, String> _contentPacksPaths = {
  coreCampaignKey: 'assets/core/',
  xulcExpansionKey: 'assets/xulc/',
};

class CampaignLoader {
  CampaignLoader._privateConstructor();

  late CampaignDef campaign;

  static final CampaignLoader _instance = CampaignLoader._privateConstructor();

  static CampaignLoader get instance => _instance;

  static Future<List<T>> _loadData<T>(String path, AssetBundle bundle,
      String key, T Function(Map<String, dynamic>) fromJson,
      {required String rootPath}) async {
    final String jsonString = await bundle.loadString(path, cache: false);
    final data = json.decode(jsonString);
    final items = await Future.wait(data[key].map<Future<T>>((e) async {
      return fromJson(e as Map<String, dynamic>);
      /*
      final name = e['name'] as String?;
      try {
        final elementJsonString = await bundle.loadString(
            '$rootPath$key/${name.toLowerCase().replaceAll(' ', '_')}.json',
            cache: false);
        final elementJson = json.decode(elementJsonString);
        return fromJson(elementJson);
      } catch (_) {
        return fromJson(e as Map<String, dynamic>);
      } */
    }).toList());
    return items.cast<T>();
  }

  static EncounterDef? loadEncounterFromJson(String data, {String? questId}) {
    final jsonMap = json.decode(data);
    return EncounterDef.fromJson(questId: questId, json: jsonMap);
  }

  static Future<Codex> loadCodex(BuildContext context, int number,
      {String? expansion}) async {
    final expansion0 = expansion ?? coreCampaignKey;
    final rootBundle = DefaultAssetBundle.of(context);
    final path = '${_contentPacksPaths[expansion0]}codex/$number.txt';
    final String codexData = await rootBundle.loadString(path, cache: false);
    return Codex.fromString(codexData, number);
  }

  static Future<CampaignText> loadText(BuildContext context, String name,
      {String? expansion}) async {
    final expansion0 = expansion ?? coreCampaignKey;
    final rootBundle = DefaultAssetBundle.of(context);
    final path = '${_contentPacksPaths[expansion0]}text/$name.txt';
    final rawText = await rootBundle.loadString(path, cache: false);
    return CampaignText.fromString(name, rawText);
  }

  static Future<EncounterDef?> loadEncounter(
      BuildContext context, String encounterId,
      {String expansion = coreCampaignKey}) async {
    switch (encounterId) {
      case '0.1':
        return Quest0.encounter0dot1;
      case '0.2':
        return Quest0.encounter0dot2;
      case '0.3':
        return Quest0.encounter0dot3;
      case '1.1':
        return Quest1.encounter1dot1;
      case '1.2':
        return Quest1.encounter1dot2;
      case '1.3':
        return Quest1.encounter1dot3;
      case '1.4':
        return Quest1.encounter1dot4;
      case '1.5':
        return Quest1.encounter1dot5;
      case '2.1':
        return Quest2.encounter2dot1;
      case '2.2':
        return Quest2.encounter2dot2;
      case '2.3':
        return Quest2.encounter2dot3;
      case '2.4':
        return Quest2.encounter2dot4;
      case '2.5':
        return Quest2.encounter2dot5;
      case 'chapter_2.I':
        return Intermissions.encounterChapter2dotI;
      case '3.1':
        return Quest3.encounter3dot1;
      case '3.2':
        return Quest3.encounter3dot2;
      case '3.3':
        return Quest3.encounter3dot3;
      case '3.4':
        return Quest3.encounter3dot4;
      case '3.5':
        return Quest3.encounter3dot5;
      case '4.1':
        return Quest4.encounter4dot1;
      case '4.2':
        return Quest4.encounter4dot2;
      case '4.3':
        return Quest4.encounter4dot3;
      case '4.4':
        return Quest4.encounter4dot4;
      case '4.5':
        return Quest4.encounter4dot5;
      case 'chapter_3.I':
        return Intermissions.encounterChapter3dotI;
      case '5.1':
        return Quest5.encounter5dot1;
      case '5.2':
        return Quest5.encounter5dot2;
      case '5.3':
        return Quest5.encounter5dot3;
      case '5.4':
        return Quest5.encounter5dot4;
      case '5.5':
        return Quest5.encounter5dot5;
      case '6.1':
        return Quest6.encounter6dot1;
      case '6.2':
        return Quest6.encounter6dot2;
      case '6.3':
        return Quest6.encounter6dot3;
      case '6.4':
        return Quest6.encounter6dot4;
      case '6.5':
        return Quest6.encounter6dot5;
      case 'chapter_4.I':
        return Intermissions.encounterChapter4dotI;
      case '7.1':
        return Quest7.encounter7dot1;
      case '7.2':
        return Quest7.encounter7dot2;
      case '7.3':
        return Quest7.encounter7dot3;
      case '7.4':
        return Quest7.encounter7dot4;
      case '7.5':
        return Quest7.encounter7dot5;
      case '8.1':
        return Quest8.encounter8dot1;
      case '8.2':
        return Quest8.encounter8dot2;
      case '8.3':
        return Quest8.encounter8dot3;
      case '8.4':
        return Quest8.encounter8dot4;
      case '8.5':
        return Quest8.encounter8dot5;
      case 'chapter_5.I':
        return Intermissions.encounterChapter5dotI;
      case '9.1a':
        return Quest9.encounter9dot1a;
      case '9.1b':
        return Quest9.encounter9dot1b;
      case '9.2':
        return Quest9.encounter9dot2;
      case '9.3':
        return Quest9.encounter9dot3;
      case '9.4':
        return Quest9.encounter9dot4;
      case '9.5':
        return Quest9.encounter9dot5;
      case '9.6':
        return Quest9.encounter9dot6;
      case '10_act1.1':
        return Quest10.encounter10dot1;
      case '10_act1.2.early':
        return Quest10.encounter10dot2dotEarly;
      case '10_act1.2.late':
        return Quest10.encounter10dot2dotLate;
      case '10_act1.3.early':
        return Quest10.encounter10dot3dotEarly;
      case '10_act1.3.late':
        return Quest10.encounter10dot3dotLate;
      case '10_act1.4.early':
        return Quest10.encounter10dot4dotEarly;
      case '10_act1.4.late':
        return Quest10.encounter10dot4dotLate;
      case '10_act1.5':
        return Quest10.encounter10dot5;
      case '10_act2.6.early':
        return Quest10.encounter10dot6dotEarly;
      case '10_act2.6.late':
        return Quest10.encounter10dot6dotLate;
      case '10_act2.7.early':
        return Quest10.encounter10dot7dotEarly;
      case '10_act2.7.late':
        return Quest10.encounter10dot7dotLate;
      case '10_act2.8.early':
        return Quest10.encounter10dot8dotEarly;
      case '10_act2.8.late':
        return Quest10.encounter10dot8dotLate;
      case '10_act2.9':
        return Quest10.encounter10dot9;
      case '10_act2.10':
        return Quest10.encounter10dot10;
      default:
        final rootBundle = DefaultAssetBundle.of(context);
        final path =
            '${_contentPacksPaths[expansion]}encounters/$encounterId.json';
        rootBundle.evict(path);
        final String jsonString =
            await rootBundle.loadString(path, cache: false);
        return loadEncounterFromJson(jsonString,
            questId: encounterId.split('.')[0]);
    }
  }

  Future<CampaignDef> load(BuildContext context) async {
    final rootBundle = DefaultAssetBundle.of(context);

    final classes = [
      for (final entry in _contentPacksPaths.entries)
        await _loadData<RoverClass>(
          '${entry.value}classes.json',
          rootBundle,
          'classes',
          (json) => RoverClass.fromJson(json),
          rootPath: entry.value,
        )
    ]
        .flattened
        .map((c) => RoverClassBehavior.roverClassWithBehavior(c))
        .toList();

    final items = [
      for (final entry in _contentPacksPaths.entries)
        await _loadData<ItemDef>(
          '${entry.value}items.json',
          rootBundle,
          'items',
          (json) => ItemDef.fromJson(json,
              expansion: entry.key == coreCampaignKey ? null : entry.key),
          rootPath: entry.value,
        )
    ].flattened.toList();

    final figures = [
      for (final entry in _contentPacksPaths.entries)
        await _loadData<FigureDef>(
          '${entry.value}figures.json',
          rootBundle,
          'figures',
          (json) => FigureDef.fromJson(json,
              expansion: entry.key == coreCampaignKey ? null : entry.key),
          rootPath: entry.value,
        )
    ].flattened.toList();

    final quests = [
      for (final entry in _contentPacksPaths.entries)
        await _loadData<QuestDef>(
          '${entry.value}quests.json',
          rootBundle,
          'quests',
          (json) => QuestDef.fromJson(json),
          rootPath: entry.value,
        )
    ].flattened.toList();

    campaign = CampaignDef.fromData(
        'Rove', quests, classes, items, figures, _contentPacksPaths);
    return campaign;
  }
}
