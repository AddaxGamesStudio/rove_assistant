import 'package:collection/collection.dart';
import 'package:meta/meta.dart';
import 'package:rove_data_types/rove_data_types.dart';
import 'package:rove_data_types/src/utils/json_utils.dart';

enum AdversaryType {
  minion,
  miniboss,
  boss;

  String toJson() {
    switch (this) {
      case AdversaryType.minion:
        return 'minion';
      case AdversaryType.miniboss:
        return 'miniboss';
      case AdversaryType.boss:
        return 'boss';
    }
  }

  static AdversaryType fromJson(String value) {
    return _jsonMap[value]!;
  }
}

final Map<String, AdversaryType> _jsonMap =
    Map<String, AdversaryType>.fromEntries(
        AdversaryType.values.map((v) => MapEntry(v.toJson(), v)));

@immutable
class EncounterFigureDef {
  static const String countAdversaryFunction = 'count_adversary';
  static const String countTokenFunction = 'count_token';
  static const String tokenPerRoverPrefix = 'Rx';
  static const int undefinedStandeeCount = -1;

  final String name;
  final String? alias;
  final String? letter;
  final AdversaryType type;
  final int standeeCount;

  /// Only needed if the figure starts injured like in 10.4 (Late).
  final int? startingHealth;
  final int? health;
  final String? healthFormula;
  final int? defense;
  final String? defenseFormula;
  final String? xDefinition;
  final bool carryState;
  final bool large;
  final bool spawnable;
  final bool respawns;
  final RoveCondition? respawnCondition;
  final String? faction;
  final bool immuneToDamage;
  final bool immuneToForcedMovement;
  final bool immuneToTeleport;
  final bool ignoresDifficultTerrain;
  final int reducePushPullBy;
  final bool flies;
  final bool entersObjectSpaces;
  final bool unslayable;
  final bool lootable;
  final bool infected;
  final List<String> _selectableTokens;
  final List<String> startingTokens;

  /// Descriptive traits only. Does not change behavior.
  final List<String> traits;
  final Map<Ether, int> affinities;
  final FieldEffect miasmaEffect;
  final List<AbilityDef> abilities;
  final List<EnemyReactionDef> reactions;
  final List<EncounterAction> onDamage;
  final List<EncounterAction> onDidStartRound;
  final List<EncounterAction> onLoot;
  final List<EncounterAction> onStartPhase;
  final List<EncounterAction> onSlain;
  final List<EncounterAction> onTokensChanged;
  final List<EncounterAction> onWillEndRound;
  final Map<String, List<EncounterAction>> onDraw;
  final Map<String, List<EncounterAction>> onMilestone;

  static const _defaultReducePushPullBy = 0;
  EncounterFigureDef({
    required this.name,
    this.alias,
    this.letter,
    this.type = AdversaryType.minion,
    this.standeeCount = undefinedStandeeCount,
    this.startingHealth,
    this.health,
    this.healthFormula,
    this.defense,
    this.defenseFormula,
    this.xDefinition,
    this.carryState = false,
    this.large = false,
    this.spawnable = false,
    this.respawns = false,
    this.respawnCondition,
    this.faction,
    List<String> possibleTokens = const [],
    this.startingTokens = const [],
    this.immuneToDamage = false,
    this.immuneToForcedMovement = false,
    this.immuneToTeleport = false,
    this.reducePushPullBy = _defaultReducePushPullBy,
    this.flies = false,
    this.entersObjectSpaces = false,
    this.ignoresDifficultTerrain = false,
    this.unslayable = false,
    this.lootable = false,
    this.infected = false,
    this.traits = const [],
    this.affinities = const {},
    FieldEffect? miasmaEffect,
    this.abilities = const [],
    this.reactions = const [],
    this.onDamage = const [],
    this.onDidStartRound = const [],
    this.onLoot = const [],
    this.onStartPhase = const [],
    this.onSlain = const [],
    this.onTokensChanged = const [],
    this.onWillEndRound = const [],
    this.onDraw = const {},
    this.onMilestone = const {},
  })  : miasmaEffect = miasmaEffect ?? FieldEffect.empty(),
        _selectableTokens = possibleTokens;

  factory EncounterFigureDef.fromJson(Map<String, dynamic> json) {
    return EncounterFigureDef(
      name: json['name'] as String,
      alias: json['alias'] as String?,
      letter: json['letter'] as String?,
      type: json.containsKey('enemy_type')
          ? AdversaryType.fromJson(json['enemy_type'] as String)
          : AdversaryType.minion,
      standeeCount: json.containsKey('standee_count')
          ? json['standee_count'] as int
          : undefinedStandeeCount,
      startingHealth: json['starting_health'] as int?,
      health: json['health'] as int?,
      healthFormula: json['health_formula'] as String?,
      defense: json['defense'] as int?,
      defenseFormula: json['defense_formula'] as String?,
      xDefinition: json['X'] as String?,
      traits: json.containsKey('traits')
          ? (json['traits'] as List<dynamic>).map((e) => e as String).toList()
          : [],
      carryState: json['carry_state'] as bool? ?? false,
      large: json.containsKey('large') ? json['large'] as bool : false,
      spawnable:
          json.containsKey('spawnable') ? json['spawnable'] as bool : false,
      respawns: json.containsKey('respawns') ? json['respawns'] as bool : false,
      respawnCondition: json.containsKey('respawn_condition')
          ? RoveCondition.fromJson(json['respawn_condition'] as String)
          : null,
      faction: json['faction'] as String?,
      possibleTokens: json.containsKey('selectable_tokens')
          ? (json['selectable_tokens'] as List<dynamic>)
              .map((e) => e as String)
              .toList()
          : [],
      startingTokens:
          decodeJsonListNamed('starting_tokens', json, (e) => e as String),
      immuneToDamage: json['immune_to_damage'] as bool? ?? false,
      immuneToForcedMovement:
          json['immune_to_forced_movement'] as bool? ?? false,
      immuneToTeleport: json['immune_to_teleport'] as bool? ?? false,
      ignoresDifficultTerrain:
          json['ignores_difficult_terrain'] as bool? ?? false,
      reducePushPullBy: json.containsKey('reduce_push_pull_by')
          ? json['reduce_push_pull_by'] as int
          : _defaultReducePushPullBy,
      flies: json.containsKey('flies') ? json['flies'] as bool : false,
      entersObjectSpaces: json.containsKey('enters_object_spaces')
          ? json['enters_object_spaces'] as bool
          : false,
      unslayable: json['unslayable'] as bool? ?? false,
      lootable: json.containsKey('lootable') ? json['lootable'] as bool : false,
      infected: json['infected'] as bool? ?? false,
      affinities: json.containsKey('affinities')
          ? Ether.affinityFromJson(json['affinities'])
          : {},
      miasmaEffect: json.containsKey('miasma_effect')
          ? FieldEffect.fromJson(json['miasma_effect'])
          : FieldEffect.empty(),
      abilities:
          decodeJsonListNamed('abilities', json, (e) => AbilityDef.fromJson(e)),
      reactions: decodeJsonListNamed(
          'reactions', json, (e) => EnemyReactionDef.fromJson(e)),
      onDamage: decodeJsonListNamed(
          'on_damage', json, (e) => EncounterAction.fromJson(e)),
      onDidStartRound: decodeJsonListNamed(
          'on_did_start_round', json, (e) => EncounterAction.fromJson(e)),
      onLoot: decodeJsonListNamed(
          'on_loot', json, (e) => EncounterAction.fromJson(e)),
      onSlain: decodeJsonListNamed(
          'on_slain', json, (e) => EncounterAction.fromJson(e)),
      onStartPhase: decodeJsonListNamed(
          'on_start_phase', json, (e) => EncounterAction.fromJson(e)),
      onTokensChanged: decodeJsonListNamed(
          'on_tokens_changed', json, (e) => EncounterAction.fromJson(e)),
      onWillEndRound: decodeJsonListNamed(
          'on_will_end_round', json, (e) => EncounterAction.fromJson(e)),
      onDraw: actionMapFromJson('on_draw', json),
      onMilestone: actionMapFromJson('on_milestone', json),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      if (alias case final value?) 'alias': value,
      if (letter case final value?) 'letter': value,
      if (type != AdversaryType.minion) 'enemy_type': type.toJson(),
      if (standeeCount != undefinedStandeeCount) 'standee_count': standeeCount,
      if (startingHealth case final value?) 'starting_health': value,
      if (health case final value?) 'health': value,
      if (healthFormula case final value?) 'health_formula': value,
      if (defense case final value?) 'defense': value,
      if (defenseFormula case final value?) 'defense_formula': value,
      if (xDefinition case final value?) 'X': value,
      if (traits.isNotEmpty) 'traits': traits,
      if (carryState) 'carry_state': carryState,
      if (large) 'large': large,
      if (spawnable) 'spawnable': spawnable,
      if (respawns) 'respawns': respawns,
      if (respawnCondition case final value?)
        'respawn_condition': value.toString(),
      if (faction case final value?) 'faction': value,
      if (_selectableTokens.isNotEmpty) 'selectable_tokens': _selectableTokens,
      if (startingTokens.isNotEmpty) 'starting_tokens': startingTokens,
      if (immuneToDamage) 'immune_to_damage': immuneToDamage,
      if (immuneToForcedMovement)
        'immune_to_forced_movement': immuneToForcedMovement,
      if (immuneToTeleport) 'immune_to_teleport': immuneToTeleport,
      if (ignoresDifficultTerrain)
        'ignores_difficult_terrain': ignoresDifficultTerrain,
      if (reducePushPullBy != _defaultReducePushPullBy)
        'reduce_push_pull_by': reducePushPullBy,
      if (flies) 'flies': flies,
      if (entersObjectSpaces) 'enters_object_spaces': entersObjectSpaces,
      if (unslayable) 'unslayable': unslayable,
      if (lootable) 'lootable': lootable,
      if (infected) 'infected': infected,
      if (affinities.isNotEmpty)
        'affinities': Ether.affinitiesToJson(affinities),
      if (!miasmaEffect.isEmpty) 'miasma_effect': miasmaEffect.toJson(),
      if (abilities.isNotEmpty)
        'abilities': abilities.map((e) => e.toJson()).toList(),
      if (reactions.isNotEmpty)
        'reactions': reactions.map((e) => e.toJson()).toList(),
      if (onDamage.isNotEmpty)
        'on_damage': onLoot.map((e) => e.toJson()).toList(),
      if (onDidStartRound.isNotEmpty)
        'on_did_start_round': onLoot.map((e) => e.toJson()).toList(),
      if (onLoot.isNotEmpty) 'on_loot': onLoot.map((e) => e.toJson()).toList(),
      if (onTokensChanged.isNotEmpty)
        'on_tokens_changed': onTokensChanged.map((e) => e.toJson()).toList(),
      if (onSlain.isNotEmpty)
        'on_slain': onSlain.map((e) => e.toJson()).toList(),
      if (onStartPhase.isNotEmpty)
        'on_start_phase': onStartPhase.map((e) => e.toJson()).toList(),
      if (onWillEndRound.isNotEmpty)
        'on_will_end_round': onWillEndRound.map((e) => e.toJson()).toList(),
      if (onDraw.isNotEmpty) 'on_draw': actionMapToJson(onDraw),
      if (onMilestone.isNotEmpty) 'on_milestone': actionMapToJson(onMilestone),
    };
  }

  int getDefense({required Map<String, int> variables}) {
    return roveResolveValueOrFormula(defense, defenseFormula, variables);
  }

  int getHealth({required Map<String, int> variables}) {
    return roveResolveValueOrFormula(health, healthFormula, variables);
  }

  List<String> selectableTokensForPlayerCount(int playerCount) {
    return _selectableTokens.expand((e) {
      if (e.startsWith(tokenPerRoverPrefix)) {
        final token = e.substring(tokenPerRoverPrefix.length);
        return List.generate(playerCount, (_) => token);
      }
      return [e];
    }).toList();
  }

  String get nameToDisplay => alias ?? name;

  String? get xFunction {
    return xDefinition?.split('(').first;
  }

  String? get xTarget {
    if (xDefinition == null) {
      return null;
    }
    final parts = xDefinition!.split('(');
    return parts[1].substring(0, parts[1].length - 1);
  }

  bool get canLoot {
    return [
      ...abilities.expand((ability) => ability.actions),
      ...reactions.expand((reaction) => reaction.actions)
    ].any((action) => action.type == RoveActionType.loot);
  }

  Set<String> get referencedItems {
    return [
      ...onLoot,
      ...onSlain,
      ...onStartPhase,
      ...onTokensChanged,
      ...onWillEndRound,
      ...onMilestone.values.flattened,
    ]
        .where((a) => a.type == EncounterActionType.rewardItem)
        .map((a) => a.value)
        .toSet();
  }

  String targetForNumber(int number) {
    return '$name#$number';
  }
}
