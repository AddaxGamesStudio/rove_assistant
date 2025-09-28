import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:rove_assistant/model/campaign_model.dart';
import 'package:rove_assistant/model/encounter/encounter_executor.dart';
import 'package:rove_assistant/model/encounter/encounter_event.dart';
import 'package:rove_assistant/model/encounter/encounter_resolver.dart';
import 'package:rove_assistant/model/encounter/encounter_state.dart';
import 'package:rove_assistant/model/encounter/figure.dart';
import 'package:rove_assistant/model/items_model.dart';
import 'package:rove_assistant/model/players_model.dart';
import 'package:rove_assistant/persistence/preferences.dart';
import 'package:rove_assistant/persistence/assistant_preferences.dart';
import 'package:rove_assistant/services/analytics.dart';
import 'package:rove_data_types/rove_data_types.dart';

_historyKeyForPlayer(Player player) => player.roverClass.name;
_historyKeyForFigure(Figure figure) =>
    '${figure.role}:${figure.name}.${figure.numeral}';

class EncounterItemState {
  final ItemDef item;
  final bool reward;
  final bool exhausted;
  final bool consumed;
  final bool equipped;

  EncounterItemState(
      {required this.item,
      required this.reward,
      required this.exhausted,
      required this.consumed,
      required this.equipped});
}

class EncounterModel extends ChangeNotifier {
  EncounterState encounterState;
  final EncounterDef encounterDef;
  final CampaignDef campaignDef;
  final EncounterEvents events;
  final List<String> _history;
  String? _previousActionKey;
  bool _pendingLoad = false;

  EncounterModel._privateConstructor(
      {required this.encounterDef,
      required this.encounterState,
      required this.events})
      : campaignDef = CampaignModel.instance.campaignDefinition,
        _history = [jsonEncode(encounterState.toJson())];

  static _initializeState(EncounterDef encounter, EncounterState state) {
    state.initialize(
        players: PlayersModel.instance.players,
        phases: EncounterResolver(encounter: encounter, state: state).phases);
  }

  static EncounterModel forEncounter(EncounterDef encounter,
      {required EncounterEvents events}) {
    final campaignModel = CampaignModel.instance;
    final hadEncounterRecord =
        campaignModel.hasEncounterRecord(encounterId: encounter.id);
    final record =
        campaignModel.encounterRecordForIdOrNew(encounterId: encounter.id);
    final state = EncounterState.fromRecord(record);
    if (!hadEncounterRecord) {
      Analytics.logEncounterStart(encounter);
      _initializeState(encounter, state);
    } else if (!state.complete) {
      final serializedState =
          Preferences.instance.getString(AssistantPreferences.encounter);
      if (serializedState != null) {
        final potentialState =
            EncounterState.fromJson(json.decode(serializedState));
        if (potentialState.encounterId == encounter.id) {
          return EncounterModel._privateConstructor(
              encounterDef: encounter,
              encounterState: potentialState,
              events: events);
        }
      }
    }

    final model = EncounterModel._privateConstructor(
        encounterDef: encounter, encounterState: state, events: events);
    if (!state.complete) {
      model._pendingLoad = true;
    }
    return model;
  }

  bool get pendingLoad => _pendingLoad;

  EncounterResolver get _resolver => encounterDef.resolver(encounterState);
  EncounterExecutor get _executor => EncounterExecutor(
      encounter: encounterDef, state: encounterState, model: this);

  Future<void> load() async {
    if (!_pendingLoad) {
      return;
    }
    _pendingLoad = false;
    await _onStartEncounter();
  }

  Future<void> _onStartEncounter() async {
    _executor.applyPermanentBuffs();
    await _executor.onLoad();
    // Refresh the starting phase. At least in 10.4 the starting phase can change based on milestones.
    encounterState.phase = _resolver.phases.first;
    encounterState.isStartEncounterPhase = false;
    await _executor.onDidStartRound();
    _history.clear();
    _onStateChanged(key: null);
  }

  /* Progression */

  Future<void> increasePhase() async {
    await _executor.increasePhase();
    _onStateChanged(key: null);
  }

  void setObjectiveAchieved(bool value) {
    encounterState.objectiveAchieved = value;
    _onStateChanged(key: null);
  }

  void setEtherRewards({required List<String> ethers}) {
    encounterState.etherRewards.addAll(ethers);
    // No notification is necessary since this happens at the end of the encounter
  }

  void setChallengeValue({required int index, required bool value}) {
    encounterState.challenges[index] = value;
    _onStateChanged(key: null);
  }

  /* Player Management */

  setPlayerHealth({required Player player, required int health}) {
    _executor.setPlayerHealth(player: player, health: health);
    _onStateChanged(key: 'setHealth:player:${_historyKeyForPlayer(player)}');
  }

  setPlayerDefense({required Player player, required int defense}) {
    encounterState.setPlayerDefense(player: player, defense: defense);
    _onStateChanged(key: 'setDefense:player:${_historyKeyForPlayer(player)}');
  }

  setPlayerEncounterTokens(
      {required Player player, required List<String> tokens}) {
    encounterState.setPlayerEncounterTokens(
        player: player, encounterTokens: tokens);
    _onStateChanged(key: null);
  }

  setPlayerBoardTokens(
      {required Player player, required List<PlayerBoardToken> boardTokens}) {
    encounterState.setPlayerBoardTokens(
        player: player, boardTokens: boardTokens);
    _onStateChanged(key: null);
  }

  toggleReactionForPlayer(Player player) {
    encounterState.toggleReactionForPlayer(player);
    _onStateChanged(key: null);
  }

  void setSummonHealth({required String name, required int health}) {
    encounterState.setSummonHealth(name: name, health: health);
    _onStateChanged(key: 'setHealth:summon:$name}');
  }

  /* Figure Management */

  setFigureHealth({required Figure figure, required int health}) {
    _executor.setFigureHealth(figure: figure, health: health);
    _executor.onSetHealth(figure: figure, health: health).then((_) {
      _onStateChanged(key: 'setHealth:figure:${_historyKeyForFigure(figure)}');
    });
  }

  setFigureDefense({required Figure figure, required int defense}) {
    _executor.setFigureDefense(figure: figure, defense: defense);
    _onStateChanged(key: 'setDefense:figure:${_historyKeyForFigure(figure)}');
  }

  void spawnAdversary({required String name}) {
    _executor.spawn(name: name);
    _onStateChanged(key: null);
  }

  void setFigureNumber({required Figure figure, required int number}) {
    encounterState.setAdversaryState(
        name: figure.name,
        numeral: figure.numeral,
        state: encounterState.stateFromFigure(figure).withNumber(number));
    _onStateChanged(key: null);
  }

  Future<void> setFigureTokens(
      {required Figure figure, required List<String> tokens}) async {
    final figureState =
        encounterState.stateFromFigure(figure).withTokens(tokens);
    switch (figure.role) {
      case FigureRole.ally:
        encounterState.setAllyState(name: figure.name, state: figureState);
        break;
      case FigureRole.adversary:
      case FigureRole.object:
        encounterState.setAdversaryState(
            name: figure.name, numeral: figure.numeral, state: figureState);
    }
    await _executor.onSetTokens(figure: figure, tokens: tokens);
    _onStateChanged(key: null);
  }

  flipAllyCard(Figure ally) {
    _executor.flipAllyCard(ally: ally);
    _onStateChanged(key: null);
  }

  /* Item Management */

  void lootByAdversary({required Figure figure, required Figure adversary}) {
    // 3.4 Haunts are removed from the map after looting
    _executor.setFigureHealth(figure: adversary, health: 0);
    events.addEvent(EncounterEvent.encounter3dot4HauntExit(
        model: this, haunt: adversary, loot: figure));
    loot(figure: figure, byAdversary: true);
  }

  Future<void> loot({required Figure figure, bool byAdversary = false}) async {
    assert(figure.role == FigureRole.object);
    assert(!encounterState.isLooted(name: figure.name, index: figure.numeral));
    encounterState.loot(name: figure.name, index: figure.numeral);
    if (!byAdversary) {
      await _executor.onLoot(figure: figure);
    }
    _onStateChanged(key: null);
  }

  EquipItemResult giveItem({required Player player, required ItemDef item}) {
    encounterState.rewardItem(player: player, itemName: item.name);
    final equippedEncounterItems = equippedEncounterItemsForPlayer(player);
    EquipItemResult result = EquipItemResult.success;
    if (_isEquipped(player: player, item: item)) {
      result = EquipItemResult.alreadyEquipped;
    } else if (ItemsModel.instance.canFitItem(
        player: player,
        item: item,
        equippedEncounterItems: equippedEncounterItems)) {
      encounterState.equipRewardItem(player: player, itemName: item.name);
    } else {
      result = EquipItemResult.noSlot;
    }
    _onStateChanged(key: null);
    return result;
  }

  void consumeItem({required Player player, required ItemDef item}) {
    encounterState.consume(player: player, itemName: item.name);
    _onStateChanged(key: null);
  }

  void exhaustItem({required Player player, required ItemDef item}) {
    encounterState.exhaust(player: player, itemName: item.name);
    _onStateChanged(key: null);
  }

  /* Drawing */

  void rollXulcDie() async {
    await _executor.rollXulcDie();
    _onStateChanged(key: null);
  }

  EtherField drawRandomField() {
    return encounterState.drawField();
  }

  consumeDrawnField(EtherField field) {
    encounterState.consumeDrawnField(field);
    _executor.onDraw(field.toJson());
    _onStateChanged(key: null);
  }

  bool get isLastDraw => encounterState.isLastDraw;

  bool get showXulcDie =>
      [
        XulcExpansion.infectedMilestone,
        CampaignMilestone.milestone10dot1XulcRevealed
      ].any((m) => hasMilestone(m)) &&
      encounterDef.expansion == xulcExpansionKey;

  /* Milestones */

  void setMilestoneReward(String milestone) {
    encounterState.milestones.add(milestone);
    _onStateChanged(key: null);
  }

  bool hasMilestone(String milestone) {
    return encounterState.milestones.contains(milestone) ||
        CampaignModel.instance.hasMilestone(milestone);
  }

  void triggerTrackerEvent(EncounterTrackerEventDef event) async {
    await _executor.triggerTrackerEvent(event);
    _onStateChanged(key: null);
  }

  /* State Management */

  _onStateChanged({required String? key}) {
    events.notify();
    bool replace = key != null && key == _previousActionKey;
    if (!replace && _history.length == 50) {
      _history.removeAt(0);
    }
    final serializedState = jsonEncode(encounterState.toJson());
    if (replace && _history.isNotEmpty) {
      _history[_history.length - 1] = serializedState;
    } else {
      _history.add(serializedState);
    }
    _previousActionKey = key;
    _persistState(serializedState);
    notifyListeners();
  }

  _persistState(String state) {
    CampaignModel.instance.saveCampaign();
    Preferences.instance.setString(AssistantPreferences.encounter, state);
  }

  void fail() {
    encounterState.failed = true;
    _onStateChanged(key: null);
  }

  void restart() async {
    encounterState = EncounterState(encounterId: encounterState.encounterId);
    _initializeState(encounterDef, encounterState);
    _history.clear();
    await _onStartEncounter();
    _onStateChanged(key: null);
  }

  undo() {
    if (_history.length < 2) {
      return;
    }
    _history.removeLast();
    _previousActionKey = null;
    final serializedState = _history.last;
    encounterState = EncounterState.fromJson(json.decode(serializedState));
    _persistState(serializedState);
    notifyListeners();
  }

  /* Getters */

  bool get isStartEncounterPhase => encounterState.isStartEncounterPhase;

  int get round => encounterState.round;

  String get phaseName => encounterDef.nameForPhase(encounterState.phase);

  bool get isObjectiveAchieved => encounterState.objectiveAchieved || completed;
  bool get failed => encounterState.failed;

  bool get completed => encounterState.complete;

  get hasApplicableEndRoundCodices => _executor.hasEmergentEndRoundCodices;

  bool get hasRewards =>
      encounterDef.hasReward || encounterState.lystRewards.isNotEmpty;

  List<EncounterTrackerEventDef> get manualProgressionEvents =>
      encounterDef.publicTrackerEvents
          .where((e) => e.ifMilestone == null || hasMilestone(e.ifMilestone!))
          .toList();

  List<(int?, String, String?)> get codexLinks => encounterState.codexLinks;

  int? numberForCodex(String title) => encounterState.codexLinks
      .where((c) => c.$2 == title)
      .map((c) => c.$1)
      .firstOrNull;

  List<(String, String)> get specialRules => encounterState.specialRules;

  EncounterSetup? get setup {
    final overrideName = encounterState.replacementPlacementGroup;
    if (overrideName != null) {
      final placementGroup = encounterDef.placementGroupWithName(overrideName);
      if (placementGroup != null) {
        return placementGroup.setup;
      }
    }
    return encounterDef.setup;
  }

  List<EncounterTerrain> get terrain {
    final overrideName = encounterState.replacementPlacementGroup;
    if (overrideName != null) {
      final placementGroup = encounterDef.placementGroupWithName(overrideName);
      if (placementGroup != null) {
        return placementGroup.terrain.isNotEmpty
            ? placementGroup.terrain
            : encounterDef.terrain;
      }
    }
    return encounterDef.terrain;
  }

  String get objective => _resolver.objectiveForModel(this);

  String? get lossCondition => _resolver.lossCondition;

  String? get subtitle => encounterState.subtitle;

  int get roundLimit => _resolver.roundLimit;

  String get mapId => encounterState.overrideMap ?? encounterDef.startingMap.id;

  List<Figure> get allies => _resolver.allies;

  List<Figure> get objects => _resolver.objects;

  List<Figure> get adversaries => _resolver.adversaries;

  List<Figure> get figuresThatCanLoot =>
      _resolver.adversaries.where((f) => f.isAlive && f.canLoot).toList();

  /* Queries */

  Figure? figureFromTarget(String target) {
    return _resolver.figureForTarget(target);
  }

  int maxHealthForPlayer(Player player) {
    return _resolver.maxHealthForPlayer(player);
  }

  PlayerEncounterState stateForPlayer(Player player) {
    return encounterState.stateForPlayer(player);
  }

  bool _isEquipped({required Player player, required ItemDef item}) {
    return player.isEquipped(item) ||
        encounterState
            .equippedItemsForPlayer(player)
            .any((name) => name == item.name);
  }

  List<ItemDef> equippedEncounterItemsForPlayer(Player player) {
    return encounterState
        .equippedItemsForPlayer(player)
        .map((name) => campaignDef.itemForName(name))
        .nonNulls
        .toList();
  }

  EquipItemResult equipItem(
      {required Player player, required ItemDef item, required bool isReward}) {
    if (player.hasEquippedItem(item)) {
      return EquipItemResult.alreadyEquipped;
    }
    final equippedEncounterItems = equippedEncounterItemsForPlayer(player);
    if (ItemsModel.instance.canFitItem(
        player: player,
        item: item,
        equippedEncounterItems: equippedEncounterItems)) {
      if (isReward) {
        encounterState.equipRewardItem(player: player, itemName: item.name);
      } else {
        player.equipItem(item);
      }
      _onStateChanged(key: null);
      return EquipItemResult.success;
    }
    return EquipItemResult.noSlot;
  }

  void unequipItem({required Player player, required ItemDef item}) {
    if (player.isEquipped(item)) {
      player.unequipItem(item);
    } else {
      assert(encounterState.equippedItemsForPlayer(player).contains(item.name));
      encounterState.unequipRewardItem(player: player, itemName: item.name);
    }
    _onStateChanged(key: null);
  }

  List<EncounterItemState> itemsForPlayer(Player player) {
    final itemsAndIsReward = [
      ...player.items.map((i) => (i.$1, false)),
      ...encounterState
          .rewardedItemsForPlayer(player)
          .map((name) => campaignDef.itemForName(name))
          .map((i) => (i, true))
    ];

    final consumedItemNames =
        encounterState.consumedItemsForPlayer(player).toList();
    final exhaustedItemNames =
        encounterState.exhaustedItemsForPlayer(player).toList();
    final equippedItemNames = [
      ...equippedEncounterItemsForPlayer(player),
      ...player.equippedItems(items: campaignDef.items)
    ].map((i) => i.name).toSet();

    final itemStates = <EncounterItemState>[];
    for (final (item, isReward) in itemsAndIsReward) {
      var equipped = false;
      if (equippedItemNames.contains(item.name)) {
        equipped = true;
        equippedItemNames.remove(item.name);
      }
      var consumed = false;
      if (consumedItemNames.contains(item.name)) {
        consumed = true;
        consumedItemNames.remove(item.name);
      }
      var exhausted = false;
      if (exhaustedItemNames.contains(item.name)) {
        exhausted = true;
        exhaustedItemNames.remove(item.name);
      }
      itemStates.add(EncounterItemState(
          item: item,
          reward: isReward,
          exhausted: exhausted,
          consumed: consumed,
          equipped: equipped));
    }

    itemStates.sort((a, b) => a.item.name.compareTo(b.item.name));
    // Prioritize pocket items
    itemStates.sort((a, b) => a.item.slotType == ItemSlotType.pocket
        ? -1
        : b.item.slotType == ItemSlotType.pocket
            ? 1
            : a.item.slotType.index.compareTo(b.item.slotType.index));
    itemStates.sort((a, b) => a.equipped
        ? -1
        : b.equipped
            ? 1
            : 0);
    return itemStates;
  }

  bool _spawns(
      {required EncounterFigureDef adversary, required String spawnName}) {
    return adversary.abilities.expand((a) => a.actions).any(
            (a) => a.type == RoveActionType.spawn && a.object == spawnName) ||
        adversary.reactions.expand((a) => a.actions).any(
            (a) => a.type == RoveActionType.spawn && a.object == spawnName);
  }

  bool isSpawnableWithName(String name) {
    if (!_resolver.canSpawnTarget(name)) {
      return false;
    }

    final definitions = _resolver.adversaryDefinitions;

    return definitions.where((e) => e.name == name && e.spawnable).isNotEmpty ||
        definitions
            .where((a) => _spawns(adversary: a, spawnName: name))
            .isNotEmpty;
  }

  List<String> get possiblePlayerEncounterTokens {
    return encounterDef.playerPossibleTokensForPlayerCount(
        PlayersModel.instance.players.length);
  }

  List<String> encounterTokensForPlayer(Player player) {
    return itemsForPlayer(player).where((e) => e.item.isEncounterOnly).map((e) {
      final name = e.item.name;
      if (name.toLowerCase().contains('key')) {
        return 'Key';
      } else {
        return 'Hoard';
      }
    }).toList();
  }
}
