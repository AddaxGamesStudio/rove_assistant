import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:rove_app_common/data/campaign_loader.dart';
import 'package:rove_app_common/model/items_model.dart';
import 'package:rove_simulator/model/cards/ability_model.dart';
import 'package:rove_simulator/model/encounter_variables.dart';
import 'package:rove_simulator/model/persistence/saveable.dart';
import 'package:rove_simulator/model/tiles/enemy_model.dart';
import 'package:rove_simulator/model/encounter_log.dart';
import 'package:rove_simulator/model/tiles/enemy_class_model.dart';
import 'package:rove_simulator/model/map_model.dart';
import 'package:rove_simulator/model/tiles/ether_node_model.dart';
import 'package:rove_simulator/model/tiles/object_model.dart';
import 'package:rove_simulator/model/tiles/player_unit_model.dart';
import 'package:rove_simulator/model/cards/skill_model.dart';
import 'package:rove_simulator/model/tiles/unit_model.dart';
import 'package:rove_data_types/rove_data_types.dart';

enum EncounterModelState {
  setUp,
  victory,
  failed,
  playing;

  static EncounterModelState fromName(String name) {
    return EncounterModelState.values.firstWhere((v) => v.name == name);
  }
}

enum HistoryEvent { startTurn, startRound }

class EncounterModel extends ChangeNotifier with Saveable {
  final EncounterDef encounter;
  late final List<Player> _players;
  int round = 1;
  int _lyst = 0;
  late MapModel _map;
  MapModel get map => _map;
  late EncounterLog _log;
  EncounterLog get log => _log;
  UnitModel? _currentTurnUnit;
  bool _startedTurn = false;
  List<UnitModel> endedTurnUnits = [];
  List<RoundPhase> phases = [RoundPhase.rover, RoundPhase.adversary];
  late RoundPhase phase;
  EncounterModelState _state = EncounterModelState.setUp;
  bool get isPlaying => _state == EncounterModelState.playing;

  late List<PlayerUnitModel> _playersUnits;
  List<PlayerUnitModel> get players => _playersUnits;
  final Map<String, EnemyClassModel> enemyClasses = {};
  SkillModel? _activeSkill;
  late final CampaignDef _campaignDefinition;
  CampaignDef get campaignDefinition => _campaignDefinition;

  final List<String> _codicesTriggered = [];
  final List<(String, int)> _lystRewards = [];
  final List<(HistoryEvent, SaveData)> _history = [];

  EncounterModel(
      {required this.encounter,
      required List<Player> players,
      CampaignDef? campaign})
      : _players = players,
        _campaignDefinition = campaign ?? CampaignLoader.instance.campaign {
    EncounterVariables.instance.registerModel(this);
    _restart();
  }

  _reset() {
    round = 1;
    _lyst = ItemsModel.instance.lyst;
    _currentTurnUnit = null;
    _startedTurn = false;
    endedTurnUnits.clear();
    enemyClasses.clear;
    phase = phases.first;
    _codicesTriggered.clear();
    _lystRewards.clear();
    _log = EncounterLog();
  }

  _restart() {
    _state = EncounterModelState.setUp;
    _reset();
    _map = MapModel(players: _players, encounter: encounter);
    _map.addListener(() {
      _onMapStateChanged();
    });
    _playersUnits = map.players;
    EncounterVariables.instance.updateVariables(this);
    _map.initialize();
    _startEncounter();
  }

  restartWithSaveData(SaveData data) {
    _state = EncounterModelState.playing;
    final index = _history.indexWhere((e) => e.$2 == data);
    _history.removeRange(index >= 0 ? index + 1 : 1, _history.length);
    _reset();
    initializeWithSaveData(data);
  }

  restart() {
    _history.clear();
    _restart();
    notifyListeners();
  }

  // Listen to state changes

  _onMapStateChanged() {
    _notifyListeners();
  }

  String get instruction {
    if (_activeSkill?.instruction != null) {
      return _activeSkill!.instruction;
    } else if (_currentTurnUnit != null && startedTurn) {
      return '${phase.label()} Phase: ${currentTurnUnit!.name} Turn';
    } else if (phase == RoundPhase.rover && _currentTurnUnit == null) {
      if (endedTurnUnits.whereType<PlayerUnitModel>().isEmpty) {
        return 'Select Any Rover';
      } else {
        return 'Select Next Rover';
      }
    } else {
      return '';
    }
  }

  bool get isPlayingCard {
    return _activeSkill != null;
  }

  /* Card Play */

  _notifyListeners() {
    notifyListeners();
  }

  set activeSkill(SkillModel? skill) {
    if (skill == _activeSkill) {
      return;
    }
    _activeSkill?.isPlaying = false;
    _activeSkill?.removeListener(_notifyListeners);
    _activeSkill = skill;
    skill?.addListener(_notifyListeners);
    notifyListeners();
  }

  SkillModel? get activeSkill => _activeSkill;

  /* State Management */

  get state => _state;

  setPlaying() {
    assert(_state == EncounterModelState.setUp);
    _state = EncounterModelState.playing;
    notifyListeners();
  }

  setFailed() {
    assert(_state == EncounterModelState.playing);
    _state = EncounterModelState.failed;
    notifyListeners();
  }

  setVictory() {
    assert(_state == EncounterModelState.playing);
    _state = EncounterModelState.victory;
    notifyListeners();
  }

  /* Progression Management */

  UnitModel? get currentTurnUnit => _currentTurnUnit;
  PlayerUnitModel? get currentPlayer => _currentTurnUnit is PlayerUnitModel
      ? _currentTurnUnit as PlayerUnitModel
      : null;

  bool get startedTurn => _startedTurn;

  startTurnForUnit(UnitModel unit) {
    assert(!_startedTurn);
    assert(_currentTurnUnit == null);
    assert(!endedTurnUnits.contains(unit));

    if (unit is EnemyModel && isFirstEnemyOfClassInRound(unit)) {
      final enemyClass = enemyClasses[unit.className];
      assert(enemyClass != null);
      enemyClass?.startRound(round);
    }

    _currentTurnUnit = unit;
    _startedTurn = true;
    unit.startedTurn = true;
    log.addRecord(unit, 'Started turn');
    notifyListeners();
  }

  bool canStartTurnForPlayer(PlayerUnitModel player) {
    return isPlaying &&
        phase == RoundPhase.rover &&
        !_startedTurn &&
        !player.isDowned &&
        !endedTurnUnits.contains(player);
  }

  bool canEndTurnForPlayer(PlayerUnitModel player) {
    return _currentTurnUnit == player;
  }

  bool isEndedTurnOfUnit(UnitModel unit) {
    return endedTurnUnits.contains(unit);
  }

  List<PlayerUnitModel> get _presentPlayers {
    List<PlayerUnitModel> actingPlayers = [];
    actingPlayers.addAll(endedTurnUnits.whereType<PlayerUnitModel>());
    final playersCopy = players.toList();
    playersCopy.removeWhere((element) => actingPlayers.contains(element));
    return actingPlayers + playersCopy;
  }

  List<PlayerUnitModel> get actingPlayers {
    return players.whereNot((p) => p.isDowned).toList();
  }

  List<EnemyModel> get actingAdversaries {
    return encounter.adversaries.fold<List<EnemyModel>>([],
        (List<EnemyModel> list, adversaryDef) {
      list.addAll(map.adversaries
          .whereType<EnemyModel>()
          .where((a) => a.className == adversaryDef.name)
          .toList()
        ..sort((a, b) => a.number.compareTo(b.number)));
      return list;
    });
  }

  List<EnemyModel> get pendingTurnAdversaries {
    return encounter.adversaries
        .where((a) => enemyClasses[a.name]?.endedRound == false)
        .fold<List<EnemyModel>>([], (List<EnemyModel> list, adversaryDef) {
      list.addAll(map.adversaries
          .whereType<EnemyModel>()
          .where((a) => !isEndedTurnOfUnit(a))
          .where((a) => a.className == adversaryDef.name)
          .toList()
        ..sort((a, b) => a.number.compareTo(b.number)));
      return list;
    });
  }

  AbilityModel currentAbilityForEnemy(EnemyModel enemy) {
    assert(enemyClasses.containsKey(enemy.className));
    final index = enemyClasses[enemy.className]!.abilityIndex;
    return enemy.abilities[index];
  }

  List<UnitModel> _unitsForPhase(RoundPhase phase) {
    switch (phase) {
      case RoundPhase.rover:
        return _presentPlayers;
      case RoundPhase.adversary:
        return actingAdversaries;
      case RoundPhase.extra:
        return [];
    }
  }

  List<UnitModel> get presentUnits {
    return phases.fold<List<UnitModel>>([], (List<UnitModel> list, phase) {
      list.addAll(_unitsForPhase(phase));
      return list;
    }).toList();
  }

  _startEncounter() {
    for (var p in players) {
      if (kDebugMode) {
        for (final entry in p.roverClass.affinities.entries) {
          if (entry.value > 0) {
            p.addEther(entry.key);
          }
          p.infuseEther(entry.key, fromPersonalPool: false);
        }
      } else {
        p.addEther(Ether.randomNonDimEther());
      }
    }
    for (final adversary in encounter.adversaries) {
      enemyClasses[adversary.name] = EnemyClassModel(adversary);
    }
  }

  bool _allPlayersEndedTurn() {
    return players.every((p) => p.endedTurn);
  }

  bool _allAdversariesEndedTurn() {
    return pendingTurnAdversaries.isEmpty;
  }

  bool isFirstEnemyOfClassInRound(EnemyModel enemy) {
    // Enemy could have been slain and thus is no longer in acting adversaries
    if (endedTurnUnits.contains(enemy)) {
      return false;
    }

    final enemies = actingAdversaries;
    final index = enemies.indexOf(enemy);
    assert(index >= 0);
    if (index == -1) {
      return false;
    }
    if (index == 0) {
      return true;
    }
    final previousEnemy = enemies[index - 1];
    return previousEnemy.className != enemy.className;
  }

  bool isLastEnemyOfClassInRound(EnemyModel enemy) {
    final enemies = actingAdversaries;
    var index = enemies.indexOf(enemy);
    assert(index >= 0 || enemy.isSlain);
    if (index == -1) {
      index = 0;
    }
    if (index == enemies.length - 1 || enemies.isEmpty) {
      return true;
    }
    final nextEnemy = enemies[index + 1];
    return nextEnemy.className != enemy.className;
  }

  endTurn() {
    assert(_currentTurnUnit != null);
    assert(_startedTurn);
    log.addRecord(_currentTurnUnit, 'Ended turn', addSeparator: true);
    endedTurnUnits.add(_currentTurnUnit!);
    final unit = _currentTurnUnit!;
    if (unit is EnemyModel && isLastEnemyOfClassInRound(unit)) {
      final enemyClass = enemyClasses[unit.className];
      assert(enemyClass != null);
      enemyClass?.endRound();
    }

    _currentTurnUnit = null;
    unit.endedTurn = true;
    _startedTurn = false;
    notifyListeners();
  }

  bool get isLastPhaseOfRound => phases.indexOf(phase) == phases.length - 1;

  bool get willEndPhase {
    switch (phase) {
      case RoundPhase.rover:
        return _allPlayersEndedTurn();
      case RoundPhase.adversary:
        return _allAdversariesEndedTurn();
      case RoundPhase.extra:
        break;
    }
    return false;
  }

  bool get willEndRound {
    if (!isLastPhaseOfRound) {
      return false;
    }
    return willEndPhase;
  }

  bool nextPhaseIfApplicable() {
    switch (phase) {
      case RoundPhase.rover:
        if (_allPlayersEndedTurn()) {
          nextPhase();
          return true;
        }
        break;
      case RoundPhase.adversary:
        if (_allAdversariesEndedTurn()) {
          nextPhase();
          return true;
        }
        break;
      case RoundPhase.extra:
        break;
    }
    return false;
  }

  _nextRound() {
    log.addRecord(null, 'Round $round: Ended', addSeparator: true);

    round++;
    log.addRecord(null, 'Round $round: Started', addSeparator: true);

    for (var p in players) {
      p.endedTurn = false;
      p.resetRound();
    }
    for (final enemyClass in enemyClasses.values) {
      enemyClass.resetRound();
    }
    for (var a in actingAdversaries) {
      a.endedTurn = false;
    }
    endedTurnUnits.clear();
    phase = phases.first;
    _startPhase();
  }

  nextPhase() {
    log.addRecord(null, '${phase.label()} Phase: Ended', addSeparator: true);
    final index = phases.indexOf(phase);
    if (index == phases.length - 1) {
      _nextRound();
    } else {
      phase = phases[index + 1];
      _startPhase();
    }
    notifyListeners();
  }

  _startPhase() {
    log.addRecord(null, '${phase.label()} Phase: Started', addSeparator: true);
    switch (phase) {
      case RoundPhase.rover:
        break;
      case RoundPhase.adversary:
        _startAdversaryPhase();
        break;
      case RoundPhase.extra:
        break;
    }
  }

  _startAdversaryPhase() {}

  /* Unit Management */

  PlayerUnitModel? unitForPlayer(Player player) {
    return players.firstWhereOrNull((p) => p.player == player);
  }

  removeUnit(UnitModel unit) {
    if (!map.units.values.contains(unit)) {
      return;
    }

    map.removeUnit(unit);
    notifyListeners();
  }

  /* Reward Management */

  void loot({required UnitModel actor, required ObjectModel object}) {
    map.removeObject(object);
  }

  void lootEtherNode(
      {required PlayerUnitModel actor, required EtherNodeModel etherNode}) {
    actor.addEther(etherNode.ether);
    map.removeEtherNode(etherNode);
  }

  int get lyst => _lyst;
  addLyst({required int amount, required String name}) {
    _lyst += amount;
    _lystRewards.add((name, amount));
    notifyListeners();
  }

  List<(String, int)> get lystRewards => _lystRewards;

  /* Codex */

  void didTriggerCodex(String codex) {
    _codicesTriggered.add(codex);
    notifyListeners();
  }

  bool hasTriggeredCodex(String codex) {
    return _codicesTriggered.contains(codex);
  }

  /* History */

  SaveData? get startOfTurnData {
    if (_history.isEmpty) {
      return null;
    }
    final last = _history.last;
    return last.$1 == HistoryEvent.startTurn ? last.$2 : null;
  }

  SaveData? get startOfRoundData {
    var i = _history.length - 1;
    while (i >= 0) {
      final event = _history[i].$1;
      if (event == HistoryEvent.startRound) {
        return _history[i].$2;
      }
      i--;
    }
    return null;
  }

  /* Saveable */

  save(HistoryEvent event) {
    _history.add((event, toSaveData()));
  }

  @override
  String get saveableKey => encounter.id;

  @override
  String get saveableType => 'EncounterModel';

  @override
  List<Saveable> get saveableChildren => [_map, ...enemyClasses.values];

  @override
  Map<String, dynamic> saveableProperties() {
    return {
      'round': round,
      'lyst': _lyst,
      if (_currentTurnUnit case final value?)
        'current_turn_unit_key': value.key,
      if (_activeSkill case final value?)
        'active_skill_front_name': value.front.name,
      'started_turn': _startedTurn,
      'ended_turn_unit_keys': endedTurnUnits.map((u) => u.key).toList(),
      'phase': phase.name,
      'state': _state.name,
      if (_codicesTriggered.isNotEmpty)
        'codices_triggered': _codicesTriggered.toList(),
      if (_lystRewards.isNotEmpty)
        'lyst_rewards':
            _lystRewards.map((r) => {'name': r.$1, 'amount': r.$2}).toList(),
    };
  }

  @override
  setSaveablePropertiesBeforeChildren(Map<String, dynamic> properties) {
    super.setSaveablePropertiesAfterChildren(properties);
    round = properties['round'];
    _lyst = properties['lyst'];
    _startedTurn = properties['started_turn'];
    phase = RoundPhase.fromName(properties['phase'] as String);
    _state = EncounterModelState.fromName(properties['state'] as String);
    final codicesTriggered = properties['codices_triggered'] as List<String>?;
    if (codicesTriggered != null) {
      _codicesTriggered.addAll(codicesTriggered);
    }
    final lystRewards = properties['lyst_rewards'] as List<dynamic>?;
    if (lystRewards != null) {
      _lystRewards
          .addAll(lystRewards.map((r) => (r['name'], r['amount'] as int)));
    }
  }

  @override
  setSaveablePropertiesAfterChildren(Map<String, dynamic> properties) {
    super.setSaveablePropertiesAfterChildren(properties);
    final currentTurnUnitKey = properties['current_turn_unit_key'] as String?;
    if (currentTurnUnitKey != null) {
      _currentTurnUnit = _map.findUnitByKey(currentTurnUnitKey);
    }
    endedTurnUnits.addAll((properties['ended_turn_unit_keys'] as List<String>)
        .map((k) => _map.findUnitByKey(k)!));
    _playersUnits = _map.players;
    final activeSkillFrontName =
        properties['active_skill_front_name'] as String?;
    if (activeSkillFrontName != null) {
      _activeSkill = _playersUnits
          .map((u) => u.skills)
          .flattened
          .firstWhere((s) => s.front.name == activeSkillFrontName);
    }
  }

  @override
  Saveable createSaveableChild(SaveData childData) {
    switch (childData.type) {
      case 'MapModel':
        final map = MapModel(
            players: _players,
            encounter: encounter,
            campaign: _campaignDefinition,
            skipPlayerInitialization: true);
        _map = map;
        _map.addListener(() {
          _onMapStateChanged();
        });
        return map;
      case 'EnemyClassModel':
        final className = childData.key;
        final encounterFigureDef =
            encounter.adversaries.firstWhere((a) => a.name == className);
        final enemyClassModel = EnemyClassModel(encounterFigureDef);
        enemyClasses[className] = enemyClassModel;
        return enemyClassModel;
      default:
        throw ArgumentError.value(childData.type);
    }
  }
}
