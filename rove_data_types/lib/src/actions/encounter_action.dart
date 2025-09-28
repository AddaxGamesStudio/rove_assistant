import 'package:meta/meta.dart';
import 'package:rove_data_types/src/actions/rove_condition.dart';

enum EncounterActionType {
  addToken,
  awaken,
  codex,
  codexLink,
  dialog,
  function,
  giveTo,
  rewardItem,
  rewardLyst,
  rewardEther,
  milestone,
  setLossCondition,
  setVictoryCondition,
  setSubtitle,
  spawnPlacements,
  unlockFromAdjacentAndLoot,
  victory,
  loss,
  resetRound,
  remove,
  removeAll,
  removeRule,
  removeCodexLink,
  replace,
  respawn,
  rollEtherDie,
  rollXulcDie,
  rules,
  toggleBehavior,
  ;

  String toJson() {
    switch (this) {
      case EncounterActionType.addToken:
        return 'add_token';
      case EncounterActionType.awaken:
        return 'awaken';
      case EncounterActionType.codex:
        return 'codex';
      case EncounterActionType.codexLink:
        return 'codex_link';
      case EncounterActionType.dialog:
        return 'dialog';
      case EncounterActionType.function:
        return 'function';
      case EncounterActionType.giveTo:
        return 'give_to';
      case EncounterActionType.rewardEther:
        return 'reward_ether';
      case EncounterActionType.rewardItem:
        return 'reward_item';
      case EncounterActionType.rewardLyst:
        return 'reward_lyst';
      case EncounterActionType.loss:
        return 'loss';
      case EncounterActionType.milestone:
        return 'milestone';
      case EncounterActionType.remove:
        return 'remove';
      case EncounterActionType.removeAll:
        return 'remove_all';
      case EncounterActionType.removeRule:
        return 'remove_rule';
      case EncounterActionType.removeCodexLink:
        return 'remove_codex_link';
      case EncounterActionType.replace:
        return 'replace';
      case EncounterActionType.resetRound:
        return 'reset_round';
      case EncounterActionType.respawn:
        return 'respawn';
      case EncounterActionType.rollEtherDie:
        return 'roll_ether_die';
      case EncounterActionType.rollXulcDie:
        return 'roll_xulc_die';
      case EncounterActionType.rules:
        return 'rules';
      case EncounterActionType.setLossCondition:
        return 'set_loss_condition';
      case EncounterActionType.setSubtitle:
        return 'set_subtitle';
      case EncounterActionType.setVictoryCondition:
        return 'set_victory_condition';
      case EncounterActionType.spawnPlacements:
        return 'spawn_placements';
      case EncounterActionType.unlockFromAdjacentAndLoot:
        return 'unlock_from_adjacent_and_loot';
      case EncounterActionType.victory:
        return 'victory';
      case EncounterActionType.toggleBehavior:
        return 'toggle_behavior';
    }
  }

  static EncounterActionType fromJson(String value) {
    return _jsonMap[value]!;
  }
}

final Map<String, EncounterActionType> _jsonMap =
    Map<String, EncounterActionType>.fromEntries(
        EncounterActionType.values.map((v) => MapEntry(v.toJson(), v)));

@immutable
class EncounterAction {
  final EncounterActionType type;
  final String? key;
  final int limit;
  final String? title;
  final String? body;
  final String value;
  final bool silent;
  final List<RoveCondition> conditions;

  static const _defaulLimit = 0;
  EncounterAction(
      {required this.type,
      this.title,
      this.body,
      this.key,
      this.limit = _defaulLimit,
      this.value = '',
      this.silent = false,
      this.conditions = const []});

  factory EncounterAction.fromJson(Map<String, dynamic> json) {
    return EncounterAction(
      type: EncounterActionType.fromJson(json['type'] as String),
      title: json['title'] as String?,
      body: json['body'] as String?,
      key: json['key'] as String?,
      limit: json['limit'] as int? ?? _defaulLimit,
      value: json['value'] as String? ?? '',
      silent: json['silent'] as bool? ?? false,
      conditions: json.containsKey('conditions')
          ? (json['conditions'] as List<dynamic>)
              .map((c) => RoveCondition.fromJson(c))
              .toList()
          : [],
    );
  }
  Map<String, dynamic> toJson() => {
        'type': type.toJson(),
        if (title case final value?) 'title': value,
        if (body case final value?) 'body': value,
        if (value.isNotEmpty) 'value': value,
        if (key case final value?) 'key': value,
        if (limit != _defaulLimit) 'limit': limit,
        if (silent) 'silent': silent,
        if (conditions.isNotEmpty)
          'conditions': conditions.map((c) => c.toString()).toList(),
      };
}
