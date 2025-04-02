import 'package:collection/collection.dart';
import 'package:rove_data_types/src/actions/encounter_action.dart';
import 'package:rove_data_types/src/actions/rove_condition.dart';
import 'package:rove_data_types/src/utils/json_utils.dart';

enum PlacementType {
  enemy,
  feature,
  field,
  object,
  trap,
  ether;

  factory PlacementType.fromName(String name) {
    return PlacementType.values.firstWhere((e) => e.name == name);
  }

  String toJson() {
    switch (this) {
      case PlacementType.enemy:
        return 'enemy';
      case PlacementType.feature:
        return 'feature';
      case PlacementType.field:
        return 'field';
      case PlacementType.object:
        return 'object';
      case PlacementType.trap:
        return 'trap';
      case PlacementType.ether:
        return 'ether';
    }
  }

  static PlacementType fromJson(String value) {
    return _jsonMap[value]!;
  }
}

final Map<String, PlacementType> _jsonMap =
    Map<String, PlacementType>.fromEntries(
        PlacementType.values.map((v) => MapEntry(v.toJson(), v)));

class PlacementDef {
  final String? key;
  final String name;

  final PlacementType type;

  /// Uses even-q coordinates
  final int c;

  /// Uses even-q coordinates
  final int r;

  final String? alias;
  final List<String> fixedTokens;
  final int minPlayers;
  final int trapDamage;
  final RoveCondition? unlockCondition;
  final bool sleeping;
  final List<EncounterAction> onLoot;
  final List<EncounterAction> onSlain;
  final List<EncounterAction> onDidStartRound;
  final List<EncounterAction> onTokensChanged;
  final List<EncounterAction> onWillEndRound;
  final Map<String, List<EncounterAction>> onMilestone;

  static const _defaultType = PlacementType.enemy;
  static const _defaultMinPlayers = 2;
  static const _defaultTrapDamage = 0;
  const PlacementDef(
      {this.key,
      required this.name,
      this.c = 0,
      this.r = 0,
      this.alias,
      this.type = _defaultType,
      this.minPlayers = _defaultMinPlayers,
      this.trapDamage = _defaultTrapDamage,
      this.unlockCondition,
      this.sleeping = false,
      this.fixedTokens = const [],
      this.onLoot = const [],
      this.onSlain = const [],
      this.onDidStartRound = const [],
      this.onTokensChanged = const [],
      this.onWillEndRound = const [],
      this.onMilestone = const {}});

  factory PlacementDef.fromCoordinateAndJson(
      int column, int row, Map<String, dynamic> json) {
    json['column'] = column;
    json['row'] = row;
    return PlacementDef.fromJson(json);
  }

  factory PlacementDef.fromJson(Map<String, dynamic> json) {
    return PlacementDef(
      key: json['key'] as String?,
      name: json['name'] as String,
      c: json['column'] as int? ?? 0,
      r: json['row'] as int? ?? 0,
      alias: json['alias'],
      type: json.containsKey('type')
          ? PlacementType.fromJson(json['type'])
          : _defaultType,
      minPlayers: json['min_players'] as int? ?? _defaultMinPlayers,
      trapDamage: json['trap_damage'] as int? ?? _defaultTrapDamage,
      unlockCondition: json.containsKey('unlock_condition')
          ? RoveCondition.parse(json['unlock_condition'])
          : null,
      sleeping: json['sleeping'] as bool? ?? false,
      fixedTokens:
          decodeJsonListNamed('fixed_tokens', json, (e) => e.toString()),
      onLoot: decodeJsonListNamed(
          'on_loot', json, (e) => EncounterAction.fromJson(e)),
      onSlain: decodeJsonListNamed(
          'on_slain', json, (e) => EncounterAction.fromJson(e)),
      onDidStartRound: decodeJsonListNamed(
          'on_did_start_round', json, (e) => EncounterAction.fromJson(e)),
      onTokensChanged: decodeJsonListNamed(
          'on_tokens_changed', json, (e) => EncounterAction.fromJson(e)),
      onWillEndRound: decodeJsonListNamed(
          'on_will_end_round', json, (e) => EncounterAction.fromJson(e)),
      onMilestone: actionMapFromJson('on_milestone', json),
    );
  }
  Map<String, dynamic> toJson({bool excludeCoordinate = false}) => {
        if (key case final value?) 'key': value,
        'name': name,
        if (type != _defaultType) 'type': type.name,
        if (!excludeCoordinate) 'column': c,
        if (!excludeCoordinate) 'row': r,
        if (alias case final value?) 'alias': value,
        if (minPlayers != _defaultMinPlayers) 'min_players': minPlayers,
        if (trapDamage != _defaultTrapDamage) 'trap_damage': trapDamage,
        if (unlockCondition case final value?)
          'unlock_condition': value.toString(),
        if (sleeping) 'sleeping': true,
        if (fixedTokens.isNotEmpty) 'fixed_tokens': fixedTokens,
        if (onLoot.isNotEmpty)
          'on_loot': onLoot.map((e) => e.toJson()).toList(),
        if (onSlain.isNotEmpty)
          'on_slain': onSlain.map((e) => e.toJson()).toList(),
        if (onDidStartRound.isNotEmpty)
          'on_did_start_round': onDidStartRound.map((e) => e.toJson()).toList(),
        if (onTokensChanged.isNotEmpty)
          'on_tokens_changed': onTokensChanged.map((e) => e.toJson()).toList(),
        if (onWillEndRound.isNotEmpty)
          'on_will_end_round': onWillEndRound.map((e) => e.toJson()).toList(),
        if (onMilestone.isNotEmpty)
          'on_milestone': actionMapToJson(onMilestone),
      };

  Set<String> get referencedItems {
    return [
      ...onLoot,
      ...onSlain,
      ...onDidStartRound,
      ...onTokensChanged,
      ...onWillEndRound,
      ...onMilestone.values.flattened
    ]
        .where((a) => a.type == EncounterActionType.rewardItem)
        .map((a) => a.value)
        .toSet();
  }
}
