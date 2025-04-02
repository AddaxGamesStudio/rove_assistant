import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:rove_data_types/src/campaign_presets.dart';
import 'package:rove_data_types/src/campaign_sheet/encounter_record.dart';
import 'package:rove_data_types/src/expansion.dart';
import 'package:rove_data_types/src/item_def.dart';
import 'package:rove_data_types/src/utils/json_utils.dart';
import 'player.dart';
import 'package:uuid/uuid.dart';

enum CampaignAssetType { rover, summon, item, figure }

DateTime _dateTimeFromJson(String? date) {
  if (date != null) {
    return DateTime.parse(date);
  } else {
    return DateTime.now();
  }
}

String dateTimeToJson(DateTime date) => date.toIso8601String();

class Campaign {
  final String id;
  String name;
  int roversLevel;
  int traitsCount;
  int lyst = 0;
  List<Player> _players;
  List<Player> _inactivePlayers = [];
  final Map<String, int> _ownedStock = {};
  Set<String> _questItemsInShop;
  Set<String> _unlockedRewardItems;
  int merchantLevel = 0;
  List<EncounterRecord> _encounterRecords;
  List<String> _etherNamesForNextEncounter = [];
  DateTime saveDate = DateTime.now();
  bool deleted = false;
  List<String> milestones = [];
  List<String> unlockedStashes = [];
  List<String> _expansions = [];
  bool skipCore = false;
  bool debugMode = false;
  Map<String, AdversaryRecord> _adversaryRecords = {};

  factory Campaign.empty(
      {required String name,
      List<String> expansions = const [],
      bool skipCore = false}) {
    final campaign =
        Campaign(name: name, expansions: expansions, skipCore: skipCore);
    if (skipCore) {
      expansions.map((e) => Expansion.fromValue(e)).nonNulls.forEach((e) {
        if (e.roversLevel != 0) {
          campaign.roversLevel = e.roversLevel;
        }
        if (e.merchantLevel != 0) {
          campaign.merchantLevel = e.merchantLevel;
        }
        if (e.unlockedTraitCount != 0) {
          campaign.traitsCount = e.unlockedTraitCount;
        }
      });
    }
    return campaign;
  }

  Campaign(
      {String? id,
      this.name = '',
      this.roversLevel = 1,
      this.traitsCount = 0,
      this.lyst = 0,
      List<Player> players = const [],
      List<Player> inactivePlayers = const [],
      Set<String> questItemsInShop = const {},
      Set<String> unlockedRewardItems = const {},
      this.merchantLevel = 0,
      List<EncounterRecord> encounterRecords = const [],
      Map<String, AdversaryRecord> adversaryRecords = const {},
      List<String> etherNamesForNextEncounter = const [],
      DateTime? saveDate,
      this.deleted = false,
      List<String> milestones = const [],
      List<String> unlockedStashes = const [],
      List<String> expansions = const [],
      this.skipCore = false,
      this.debugMode = false})
      : id = id ?? const Uuid().v4(),
        saveDate = saveDate ?? DateTime.now(),
        _players = players.toList(),
        _inactivePlayers = inactivePlayers.toList(),
        _encounterRecords = encounterRecords.toList(),
        _adversaryRecords = Map.from(adversaryRecords),
        _questItemsInShop = questItemsInShop.toSet(),
        _unlockedRewardItems = unlockedRewardItems.toSet(),
        _etherNamesForNextEncounter = etherNamesForNextEncounter.toList(),
        milestones = milestones.toList(),
        unlockedStashes = unlockedStashes.toList(),
        _expansions = expansions.toList() {
    for (var player in players) {
      for (var itemName in player.itemNames) {
        _ownedStock[itemName] = (_ownedStock[itemName] ?? 0) + 1;
      }
    }
  }

  List<Player> get players => _players.toList();
  List<Player> get inactivePlayers => _inactivePlayers.toList();
  Set<String> get questItemsInShop => _questItemsInShop.toSet();
  UnmodifiableSetView<String> get unlockedRewardItems =>
      UnmodifiableSetView(_unlockedRewardItems);
  List<String> get etherNamesForNextEncounter =>
      _etherNamesForNextEncounter.toList();
  set etherNamesForNextEncounter(List<String> value) {
    _etherNamesForNextEncounter = value.toList();
  }

  List<String> get expansions => _expansions.toList();

  factory Campaign.fromJson(Map<String, dynamic> json) {
    return Campaign(
      id: json['id'] as String,
      name: json['name'] as String,
      roversLevel: json['party_level'] as int,
      traitsCount: json['traits_count'] as int? ?? 0,
      lyst: json['lyst'] as int,
      players: (json['players'] as List)
          .map((e) => Player.fromJson(e as Map<String, dynamic>))
          .toList(),
      inactivePlayers: json.containsKey('inactive_players')
          ? (json['inactive_players'] as List)
              .map((e) => Player.fromJson(e as Map<String, dynamic>))
              .toList()
          : [],
      questItemsInShop:
          decodeJsonSetNamed('quest_items_in_shop', json, (e) => e as String),
      unlockedRewardItems:
          decodeJsonSetNamed('unlocked_reward_items', json, (e) => e as String),
      merchantLevel: json['shop_level'] as int,
      encounterRecords: (json['encounter_logs'] as List)
          .map((e) => EncounterRecord.fromJson(e as Map<String, dynamic>))
          .toList(),
      adversaryRecords: json.containsKey('adversary_records')
          ? Map<String, AdversaryRecord>.fromEntries(
              (json['adversary_records'] as Map<String, dynamic>).entries.map(
                    (e) => MapEntry(
                      e.key,
                      AdversaryRecord.fromJson(e.value as Map<String, dynamic>),
                    ),
                  ),
            )
          : {},
      etherNamesForNextEncounter: json.containsKey('ether_for_next_encounter')
          ? (json['ether_for_next_encounter'] as List)
              .map((e) => e as String)
              .toList()
          : [],
      saveDate: _dateTimeFromJson(json['save_date'] as String),
      deleted: json.containsKey('deleted') ? json['deleted'] as bool : false,
      milestones: json.containsKey('milestones')
          ? (json['milestones'] as List).map((e) => e as String).toList()
          : [],
      unlockedStashes: json.containsKey('unlocked_stashes')
          ? (json['unlocked_stashes'] as List).map((e) => e as String).toList()
          : [],
      expansions: decodeJsonListNamed('expansions', json, (e) => e as String),
      skipCore: json['skip_core'] as bool? ?? false,
      debugMode: json['debug_mode'] as bool? ?? false,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'party_level': roversLevel,
      if (traitsCount > 0) 'traits_count': traitsCount,
      'lyst': lyst,
      'players': _players.map((e) => e.toJson()).toList(),
      if (_inactivePlayers.isNotEmpty)
        'inactive_players': _inactivePlayers.map((e) => e.toJson()).toList(),
      if (_questItemsInShop.isNotEmpty)
        'quest_items_in_shop': _questItemsInShop.toList(),
      if (_unlockedRewardItems.isNotEmpty)
        'unlocked_reward_items': _unlockedRewardItems.toList(),
      'shop_level': merchantLevel,
      'encounter_logs': _encounterRecords.map((e) => e.toJson()).toList(),
      if (_adversaryRecords.isNotEmpty)
        'adversary_records': _adversaryRecords
            .map((key, value) => MapEntry(key, value.toJson())),
      if (_etherNamesForNextEncounter.isNotEmpty)
        'ether_for_next_encounter': _etherNamesForNextEncounter,
      'save_date': dateTimeToJson(saveDate),
      if (deleted) 'deleted': deleted,
      if (milestones.isNotEmpty) 'milestones': milestones,
      if (unlockedStashes.isNotEmpty) 'unlocked_stashes': unlockedStashes,
      if (_expansions.isNotEmpty) 'expansions': _expansions.toList(),
      if (skipCore) 'skip_core': skipCore,
      if (debugMode) 'debug_mode': debugMode,
    };
  }

  Player addPlayer(String name, String baseClassName) {
    assert(_players.length < roveMaximumPlayerCount);
    final player = Player(name: name, baseClassName: baseClassName);
    _players.add(player);
    if (skipCore) {
      expansions.map((e) => Expansion.fromValue(e)).nonNulls.forEach((e) {
        lyst += e.startingLystPerRover;
      });
    }
    return player;
  }

  inactivatePlayer(Player player) {
    _players.remove(player);
    player.inactive = true;
    _inactivePlayers.add(player);
  }

  reactivatePlayer(Player player) {
    assert(_inactivePlayers.contains(player));
    _inactivePlayers.remove(player);
    player.inactive = false;
    _players.add(player);
  }

  removeItem({required String baseClassName, required String itemName}) {
    final player = _players
        .firstWhere((element) => element.baseClassName == baseClassName);
    _ownedStock[itemName] = (_ownedStock[itemName] ?? 1) - 1;
    if (_ownedStock[itemName] == 0) {
      _ownedStock.remove(itemName);
    }
    player.removeItem(itemName);
  }

  addQuestItemToShop(String itemName) {
    _questItemsInShop.add(itemName);
  }

  removeQuestItemFromShop(String itemName) {
    if (!_questItemsInShop.contains(itemName)) {
      throw Exception('Item $itemName not found in store items');
    }
    _questItemsInShop.remove(itemName);
  }

  int ownedStockForItem(String itemName) {
    return _ownedStock[itemName] ?? 0;
  }

  addItem({required String baseClassName, required ItemDef item}) {
    final name = item.name;
    final player = _players
        .firstWhere((element) => element.baseClassName == baseClassName);
    _ownedStock[name] = (_ownedStock[name] ?? 0) + 1;
    player.addItem(name);
    if (item.isReward) {
      _unlockedRewardItems.add(name);
    }
  }

  EncounterRecord? encounterRecordForId(String encounterId) {
    return _encounterRecords
        .firstWhereOrNull((element) => element.encounterId == encounterId);
  }

  setEncounterRecord(EncounterRecord record) {
    if (hasEncounterRecord(record.encounterId)) {
      _encounterRecords.remove(_encounterRecords
          .firstWhere((element) => element.encounterId == record.encounterId));
    }
    _encounterRecords.add(record);
  }

  hasEncounterRecord(String encounterId) {
    return _encounterRecords
        .any((element) => element.encounterId == encounterId);
  }

  isCompletedForEncounter(String encounterId) {
    return _encounterRecords.any(
        (element) => element.encounterId == encounterId && element.complete);
  }

  isCompletedForQuest(String questId) {
    final lastEncounter = questId == '9' ? '6' : '5';
    return _encounterRecords
        .where((r) => r.questId == questId)
        .any((r) => r.complete && r.encounterId == '$questId.$lastEncounter');
  }

  EncounterRecord encounterRecordForIdOrNew(String encounterId) {
    return _encounterRecords.firstWhere(
        (element) => element.encounterId == encounterId, orElse: () {
      return EncounterRecord(encounterId: encounterId);
    });
  }

  get startedQuestIds {
    return _encounterRecords.map((e) => e.questId).toSet();
  }

  int countQuestItemInShop(String name) {
    return _questItemsInShop.where((element) => element == name).length;
  }

  List<Player> get allPlayers {
    return [..._players, ..._inactivePlayers];
  }

  void setPlayers(List<Player> players) {
    assert(kDebugMode);
    _players = players.toList();
  }

  removeExpansion(String name) {
    name = name.toLowerCase();
    _expansions.remove(name);
  }

  addExpansion(String name) {
    name = name.toLowerCase();
    if (_expansions.contains(name)) {
      return;
    }
    _expansions.add(name);
  }

  void updateAdversaryRecord(
      {required String encounterId,
      required String name,
      required int slainCount}) {
    final record = _adversaryRecords[name];
    if (record == null) {
      _adversaryRecords[name] = AdversaryRecord(
          name: name, slainCount: slainCount, encounters: [encounterId]);
    } else {
      _adversaryRecords[name] = record
          .withSlainCount(slainCount + record.slainCount)
          .withAddedEncounter(encounterId);
    }
  }

  AdversaryRecord? recordOfAdversaryNamed(String name) {
    return _adversaryRecords[name];
  }
}

@immutable
class AdversaryRecord {
  final String name;
  final int slainCount;
  final List<String> encounters;

  const AdversaryRecord({
    required this.name,
    this.slainCount = 0,
    this.encounters = const [],
  });

  AdversaryRecord withSlainCount(int count) {
    return AdversaryRecord(
      name: name,
      slainCount: count,
      encounters: encounters,
    );
  }

  AdversaryRecord withAddedEncounter(String encounterId) {
    return AdversaryRecord(
      name: name,
      slainCount: slainCount,
      encounters: encounters + [encounterId],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'slain_count': slainCount,
      'encounters': encounters,
    };
  }

  factory AdversaryRecord.fromJson(Map<String, dynamic> json) {
    return AdversaryRecord(
      name: json['name'] as String,
      slainCount: json['slain_count'] as int,
      encounters: (json['encounters'] as List).map((e) => e as String).toList(),
    );
  }
}
