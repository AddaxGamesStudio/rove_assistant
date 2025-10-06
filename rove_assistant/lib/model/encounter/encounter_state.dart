import 'dart:math';

import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:rove_assistant/model/encounter/figure.dart';
import 'package:rove_assistant/model/players_model.dart';
import 'package:rove_data_types/rove_data_types.dart';
import 'figure_state.dart';

part 'encounter_state.g.dart';

_keyForPlayer(Player player) {
  return player.baseClassName;
}

_keyForFigure(String name, int index) {
  return '$name ($index)';
}

@JsonSerializable(explicitToJson: true)
class EncounterState {
  @JsonKey(name: 'encounter_id', disallowNullValue: true)
  final String encounterId;
  @JsonKey(name: 'is_start_encounter_phase', defaultValue: true)
  bool isStartEncounterPhase = true;
  int round = 1;
  RoundPhase phase = RoundPhase.rover;
  List<bool> challenges = [false, false, false];
  @JsonKey(name: 'actions_with_key_triggered', defaultValue: {})
  Map<String, int> actionsWithKeyTriggerred = {};
  @JsonKey(name: 'codex_entries', defaultValue: {})
  Map<int, String> codexEntries = {};
  @JsonKey(name: 'players_state', defaultValue: {})
  Map<String, PlayerEncounterState> playersState = {};
  @JsonKey(name: 'summons_health', defaultValue: {})
  Map<String, int> summonsHealth = {};
  @JsonKey(name: 'adversaries_state', defaultValue: {})
  Map<String, FigureState> adversariesState = {};
  @JsonKey(name: 'adversaries_random_standee_map', defaultValue: {})
  Map<String, int> adversariesRandomStandeeMap = {};
  @JsonKey(name: 'allies_state', defaultValue: {})
  Map<String, FigureState> alliesState = {};
  @JsonKey(name: 'replacement_placement_group', defaultValue: null)
  String? replacementPlacementGroup;
  @JsonKey(name: 'override_placements', defaultValue: null)
  List<PlacementDef>? overridePlacements;
  @JsonKey(name: 'additional_placements', defaultValue: [])
  List<PlacementDef> additionalPlacements = [];
  @JsonKey(name: 'lyst_rewards', defaultValue: [])
  List<(String, int)> lystRewards = [];
  @JsonKey(name: 'item_rewards', defaultValue: [])
  List<(String, String, bool)> itemRewards = [];
  @JsonKey(name: 'ether_rewards', defaultValue: [])
  List<String> etherRewards = [];
  @JsonKey(name: 'looted_figures', defaultValue: [])
  List<String> lootedFigures = [];
  @JsonKey(defaultValue: [])
  List<String> milestones = [];
  @JsonKey(name: 'fields_to_draw', defaultValue: null)
  List<EtherField>? fieldsToDraw;
  String? subtitle;
  @JsonKey(defaultValue: false)
  bool complete = false;
  @JsonKey(defaultValue: false)
  bool failed = false;
  @JsonKey(name: 'objective_achieved', defaultValue: false)
  bool objectiveAchieved = false;
  @JsonKey(
      name: 'exhausted_items',
      defaultValue: {},
      includeFromJson: true,
      includeToJson: true)
  // ignore: prefer_final_fields
  Map<String, List<String>> _exhaustedItems = {};
  @JsonKey(
      name: 'consumed_items',
      defaultValue: {},
      includeFromJson: true,
      includeToJson: true)
  // ignore: prefer_final_fields
  Map<String, List<String>> _consumedItems = {};
  @JsonKey(
      name: 'started_round_with_feral_blood_lust',
      defaultValue: false,
      includeFromJson: true,
      includeToJson: true)
  bool _startedRoundWithFeralBloodLust = false;
  @JsonKey(name: 'override_loss_condition', defaultValue: null)
  String? overrideLossCondition;
  @JsonKey(name: 'override_round_limit', defaultValue: null)
  int? overrideRoundLimit;
  @JsonKey(name: 'override_victory_condition', defaultValue: null)
  String? overrideVictoryCondition;
  @JsonKey(name: 'override_map', defaultValue: null)
  String? overrideMap;
  @JsonKey(name: 'special_rules', defaultValue: [])
  List<(String, String)> specialRules = [];
  @JsonKey(name: 'codex_links', defaultValue: [])
  List<(int?, String, String?)> codexLinks = [];
  @JsonKey(name: 'encountered_adversaries', defaultValue: {})
  Map<String, int> encounteredAdversaries = {};

  EncounterState({required this.encounterId});

  factory EncounterState.fromJson(Map<String, dynamic> json) =>
      _$EncounterStateFromJson(json);
  Map<String, dynamic> toJson() => _$EncounterStateToJson(this);

  initialize(
      {required List<Player> players, required List<RoundPhase> phases}) {
    for (var player in players) {
      for (var summon in player.roverClass.summons) {
        if (summon.autoSummoned) {
          setSummonHealth(name: summon.name, health: summon.health);
        }
      }
    }
    phase = phases.first;
  }

  int get achievedChallengesCount {
    return challenges.where((challenge) => challenge).length;
  }

  List<String> get campaignMilestones =>
      milestones.where((a) => !a.startsWith('_')).toList();

  int countForActionKey(String key) {
    return actionsWithKeyTriggerred[key] ?? 0;
  }

  didApplyActionWithKey(String key) {
    actionsWithKeyTriggerred[key] = countForActionKey(key) + 1;
  }

  bool hasCodexWithTitle(String title) {
    return codexEntries.values.any((t) => t == title);
  }

  addCodexEntry({required int number, required String title}) {
    codexEntries[number] = title;
  }

  String get questId {
    return encounterId.split('.').first;
  }

  /* Player Management */

  setPlayerHealth({required Player player, required int health}) {
    playersState[_keyForPlayer(player)] =
        stateForPlayer(player).withHealth(health);
    // When a rover is slain all its summons are also slain
    if (health == 0) {
      for (var summon in player.roverClass.summons) {
        summonsHealth[summon.name] = 0;
      }
    }
  }

  setPlayerDefense({required Player player, required int defense}) {
    assert(player.roverClass.defense <= defense);
    playersState[_keyForPlayer(player)] =
        stateForPlayer(player).withDefense(defense);
  }

  setPlayerEncounterTokens(
      {required Player player, required List<String> encounterTokens}) {
    playersState[_keyForPlayer(player)] =
        stateForPlayer(player).withEncounterTokens(encounterTokens);
  }

  setPlayerBoardTokens(
      {required Player player, required List<PlayerBoardToken> boardTokens}) {
    playersState[_keyForPlayer(player)] =
        stateForPlayer(player).withBoardTokens(boardTokens);
  }

  toggleReactionForPlayer(Player player) {
    final previousState = stateForPlayer(player);
    playersState[_keyForPlayer(player)] =
        previousState.withHasReacted(!previousState.hasReacted);
  }

  PlayerEncounterState stateForPlayer(Player player) {
    final traits = PlayersModel.instance.traitsForPlayer(player);
    return playersState[_keyForPlayer(player)] ??
        PlayerEncounterState.fromRoverClass(player.roverClass, traits: traits);
  }

  bool isDownedForPlayer(Player player) {
    return playersState[_keyForPlayer(player)]?.health == 0;
  }

  List<SummonDef> summonableSummonsForPlayer(Player player) {
    if (isDownedForPlayer(player)) {
      return [];
    }
    return player.roverClass.summons
        .where((summon) => getSummonHealth(name: summon.name) == 0)
        .toList();
  }

  getSummonHealth({required String name}) {
    return summonsHealth[name] ?? 0;
  }

  setSummonHealth({required String name, required int health}) {
    summonsHealth[name] = health;
  }

  /* Item Management */

  exhaust({required Player player, required String itemName}) {
    final key = _keyForPlayer(player);
    if (!_exhaustedItems.containsKey(key)) {
      _exhaustedItems[key] = [];
    }
    _exhaustedItems[key]?.add(itemName);
  }

  List<String> exhaustedItemsForPlayer(Player player) {
    return _exhaustedItems.containsKey(_keyForPlayer(player))
        ? _exhaustedItems[_keyForPlayer(player)]!.toList()
        : [];
  }

  consume({required Player player, required String itemName}) {
    final key = _keyForPlayer(player);
    if (!_consumedItems.containsKey(key)) {
      _consumedItems[key] = [];
    }
    _consumedItems[key]?.add(itemName);
  }

  List<String> consumedItemsForPlayer(Player player) {
    return _consumedItems.containsKey(_keyForPlayer(player))
        ? _consumedItems[_keyForPlayer(player)]!.toList()
        : [];
  }

  List<String> rewardedItemsForPlayer(Player player) {
    return itemRewards
        .where((reward) => reward.$1 == _keyForPlayer(player))
        .map((reward) => reward.$2)
        .toList();
  }

  List<String> equippedItemsForPlayer(Player player) {
    return itemRewards
        .where((reward) => reward.$1 == _keyForPlayer(player))
        .where((reward) => reward.$3)
        .map((reward) => reward.$2)
        .toList();
  }

  List<String> unconsumedRewardedItemsForPlayer(Player player) {
    final consumedItems = consumedItemsForPlayer(player);
    final key = _keyForPlayer(player);
    return itemRewards
        .where((reward) => reward.$1 == key)
        .map((reward) => reward.$2)
        .map((item) {
          final bool consumed = consumedItems.contains(item);
          if (consumed) {
            consumedItems.remove(item);
          }
          return (item, consumed);
        })
        .where((o) => !o.$2) // Remove consumed items
        .map((o) => o.$1)
        .toList();
  }

  rewardItem({required Player player, required String itemName}) {
    itemRewards.add((_keyForPlayer(player), itemName, false));
  }

  _setEquipped(
      {required Player player,
      required String itemName,
      required bool equipped}) {
    final playerKey = _keyForPlayer(player);
    assert(itemRewards.any(
        (d) => d.$1 == playerKey && d.$2 == itemName && d.$3 == !equipped));
    final reward = itemRewards
        .where(
            (d) => d.$1 == playerKey && d.$2 == itemName && d.$3 == !equipped)
        .firstOrNull;
    if (reward == null) {
      return;
    }
    itemRewards.remove(reward);
    itemRewards.add((playerKey, itemName, equipped));
  }

  unequipRewardItem({required Player player, required String itemName}) {
    _setEquipped(player: player, itemName: itemName, equipped: false);
  }

  equipRewardItem({required Player player, required String itemName}) {
    _setEquipped(player: player, itemName: itemName, equipped: true);
  }

  List<String> rewardedEtherNames({required EncounterDef encounterDef}) {
    final etherNames = [...encounterDef.etherRewards.map((e) => e.label)];
    if (achievedChallengesCount > 1) {
      etherNames.add('Wild');
    }
    if (achievedChallengesCount > 2) {
      etherNames.add('Wild');
    }
    return etherNames;
  }

  setAdversaryRandomStandeeMapping(
      {required String name, required int index, required int standeeNumber}) {
    adversariesRandomStandeeMap[_keyForFigure(name, index)] = standeeNumber;
  }

  int? getAdversaryRandomStandeeMapping(
      {required String name, required int index}) {
    return adversariesRandomStandeeMap[_keyForFigure(name, index)];
  }

  clearAdversaryRandomStandeeMapping(
      {required String name, required int index}) {
    adversariesRandomStandeeMap.remove(_keyForFigure(name, index));
  }

  setAdversaryState(
      {required String name,
      required int numeral,
      required FigureState state}) {
    final previousState = adversariesState[_keyForFigure(name, numeral)];
    if (((previousState != null && previousState.health > 0) ||
            previousState == null) &&
        state.health == 0) {
      _increaseSlainCount(name: name);
    }
    adversariesState[_keyForFigure(name, numeral)] = state;
  }

  FigureState stateFromFigure(Figure figure) {
    switch (figure.role) {
      case FigureRole.adversary:
      case FigureRole.object:
        return adversariesState[_keyForFigure(figure.name, figure.numeral)] ??
            FigureState.defaultFromFigure(figure);
      case FigureRole.ally:
        return alliesState[figure.name] ??
            FigureState.defaultFromFigure(figure);
    }
  }

  isAdversarySlain({required String name, int numeral = 0}) {
    return adversariesState[_keyForFigure(name, numeral)]?.health == 0;
  }

  List<String> selectedTokensForAdvesary(
      {required String name, required int numeral}) {
    return adversariesState[_keyForFigure(name, numeral)]?.selectedTokens ?? [];
  }

  bool isStandeeNumberUsedForAdversary(
      {required String name, required int numeral}) {
    for (int i = 0; i <= FigureDef.standeeLimit; i++) {
      if (adversariesState[_keyForFigure(name, i)]?.overrideNumber == numeral) {
        return true;
      }
    }
    for (int i = 0; i <= FigureDef.standeeLimit; i++) {
      if (adversariesRandomStandeeMap[_keyForFigure(name, i)] == numeral) {
        return true;
      }
    }
    return false;
  }

  FigureState adversaryState(
      {required String name,
      int numeral = 0,
      required FigureState defaultState}) {
    _initializeEncounteredAdversariesIfNeeded(name: name);
    return adversariesState[_keyForFigure(name, numeral)] ?? defaultState;
  }

  setAllyState({required String name, required FigureState state}) {
    alliesState[name] = state;
  }

  stateForAlly({required String name, required FigureState defaultState}) {
    return alliesState[name] ?? defaultState;
  }

  int slainCount({required String figureName}) {
    return adversariesState.keys
        .where((key) =>
            key.startsWith(figureName) && adversariesState[key]!.health == 0)
        .length;
  }

  void setPlacements({required List<PlacementDef>? placements}) {
    adversariesState.clear();
    lootedFigures.clear();
    overridePlacements = placements;
    additionalPlacements = [];
  }

  void addPlacements({required List<PlacementDef> placements}) {
    additionalPlacements.addAll(placements);
  }

  List<PlacementDef> resolvePlacements(
      {required List<PlacementDef> startingPlacements}) {
    final placements = overridePlacements ?? startingPlacements;
    return placements + additionalPlacements;
  }

  loot({required String name, required int index}) {
    lootedFigures.add(_keyForFigure(name, index));
  }

  isLooted({required String name, required int index}) {
    return lootedFigures.contains(_keyForFigure(name, index));
  }

  /* Phase management */

  restartRoundCounter({required List<RoundPhase> phases}) {
    phase = phases.first;
    round = 1;
  }

  isLastPhaseOfRound(List<RoundPhase> encounterPhases) {
    return phase == encounterPhases.last;
  }

  _resetFlipTokens(String className) {
    final playerState = playersState[className];
    if (playerState != null) {
      playersState[className] = playerState.withFlipResetForClass(className);
    }
  }

  nextPhase(List<RoundPhase> encounterPhases) {
    final index = encounterPhases.indexOf(phase);
    if (index == encounterPhases.length - 1) {
      // Reset exhausted items
      _exhaustedItems.clear();

      round++;
      phase = encounterPhases.first;
      // Reset player reactions
      for (var key in playersState.keys) {
        playersState[key] = playersState[key]!.withHasReacted(false);
      }

      if (_startedRoundWithFeralBloodLust) {
        // Reset Umbral How Blood Lust
        if (playersState[RoverClass.umbralHowlName] != null) {
          playersState[RoverClass.umbralHowlName] =
              playersState[RoverClass.umbralHowlName]!.withBloodLustReset();
        }
      }
      _startedRoundWithFeralBloodLust =
          playersState[RoverClass.umbralHowlName]?.hasFeralBloodLust ?? false;

      _resetFlipTokens(RoverClass.essentialistName);
      _resetFlipTokens(RoverClass.kathapatistName);
    } else {
      phase = encounterPhases[index + 1];
    }
  }

  /* Drawing */

  EtherField drawField() {
    switch (encounterId) {
      case EncounterDef.encounter4dot5:
        fieldsToDraw ??= [
          EtherField.wildfire,
          EtherField.everbloom,
          EtherField.snapfrost,
          EtherField.windscreen,
        ];
        break;
      case EncounterDef.encounterChapter3dotI:
      default:
        fieldsToDraw ??= [
          EtherField.wildfire,
          EtherField.everbloom,
          EtherField.snapfrost,
          EtherField.windscreen,
          EtherField.miasma,
          EtherField.aura,
        ];
        break;
    }
    return fieldsToDraw![Random().nextInt(fieldsToDraw!.length)];
  }

  consumeDrawnField(EtherField field) {
    assert(fieldsToDraw!.contains(field));
    fieldsToDraw!.remove(field);
  }

  bool get isLastDraw => fieldsToDraw?.length == 1;

  EncounterRecord record() {
    return EncounterRecord(
      encounterId: encounterId,
      complete: complete,
      completedChallenges: challenges
          .mapIndexed((index, value) => (index, value))
          .where((e) => e.$2)
          .map((e) => e.$1 + 1)
          .toList(),
      campaignMilestones: campaignMilestones.toList(),
      itemRewards: itemRewards.toList(),
      consumedItems: Map.from(_consumedItems),
      adversaries: Map.from(encounteredAdversaries),
      codexEntries: Map.from(codexEntries),
    );
  }

  factory EncounterState.fromRecord(EncounterRecord record) {
    return EncounterState(encounterId: record.encounterId)
      ..complete = record.complete
      ..challenges = List.generate(3, (index) {
        return record.completedChallenges.contains(index + 1);
      })
      ..milestones = record.campaignMilestones.toList()
      ..itemRewards = record.itemRewards.toList()
      .._consumedItems = Map.from(record.consumedItems)
      ..encounteredAdversaries = Map.from(record.adversaries)
      ..codexEntries = Map.from(record.codexEntries);
  }

  /* Rules */

  addSpecialRule({required String title, required String body}) {
    final index = specialRules.indexWhere((r) => r.$1 == title);
    if (index != -1) {
      specialRules.removeAt(index);
    }
    specialRules.add((title, body));
  }

  void removeSpecialRule({required String title}) {
    final index = specialRules.indexWhere((r) => r.$1 == title);
    if (index != -1) {
      specialRules.removeAt(index);
    }
  }

  addCodexLink(
      {required int? number, required String title, required String? trigger}) {
    codexLinks
        .removeWhere((r) => r.$1 == number && r.$2 == title && r.$3 == trigger);
    codexLinks.add((number, title, trigger));
  }

  void removeCodexLinkByTitle(String title) {
    codexLinks.removeWhere((r) => r.$2 == title);
  }

  void removeCodexLinkByNumber(int number) {
    codexLinks.removeWhere((r) => r.$1 == number);
  }

  void _increaseSlainCount({required String name}) {
    final count = encounteredAdversaries[name] ?? 0;
    encounteredAdversaries[name] = count + 1;
  }

  void _initializeEncounteredAdversariesIfNeeded({required String name}) {
    if (!encounteredAdversaries.containsKey(name)) {
      encounteredAdversaries[name] = 0;
    }
  }
}
