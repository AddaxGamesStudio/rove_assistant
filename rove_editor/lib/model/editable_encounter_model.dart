import 'package:flutter/foundation.dart';
import 'package:rove_app_common/data/campaign_loader.dart';
import 'package:rove_app_common/model/items_model.dart';
import 'package:rove_editor/data/encounter_def_ext.dart';
import 'package:rove_editor/model/encounter_variables.dart';
import 'package:rove_editor/model/tiles/enemy_model.dart';
import 'package:rove_editor/model/encounter_log.dart';
import 'package:rove_editor/model/tiles/editable_enemy_class_model.dart';
import 'package:rove_editor/model/editable_map_model.dart';
import 'package:rove_editor/model/tiles/object_model.dart';
import 'package:rove_editor/model/cards/skill_model.dart';
import 'package:rove_editor/model/tiles/tile_model.dart';
import 'package:rove_editor/model/tiles/unit_model.dart';
import 'package:rove_data_types/rove_data_types.dart';
import 'package:uuid/uuid.dart';

enum EncounterModelState {
  setUp,
  victory,
  failed,
  playing;

  static EncounterModelState fromName(String name) {
    return EncounterModelState.values.firstWhere((v) => v.name == name);
  }
}

class EditableEncounterModel extends ChangeNotifier {
  final EncounterDef encounter;
  int round = 1;
  int _lyst = 0;
  late EditableMapModel _map;
  EditableMapModel get map => _map;
  late EncounterLog _log;
  EncounterLog get log => _log;
  UnitModel? _currentTurnUnit;
  bool _startedTurn = false;
  List<UnitModel> endedTurnUnits = [];
  List<RoundPhase> phases = [RoundPhase.rover, RoundPhase.adversary];
  late RoundPhase phase;
  EncounterModelState _state = EncounterModelState.setUp;
  bool get isPlaying => _state == EncounterModelState.playing;

  final Map<String, EditableEnemyClassModel> enemyClasses = {};
  SkillModel? _activeSkill;
  late final CampaignDef _campaignDefinition;
  CampaignDef get campaignDefinition => _campaignDefinition;

  final List<String> _codicesTriggered = [];
  final List<(String, int)> _lystRewards = [];

  final String key;
  String? _expansion;
  String _questId;
  String _number;
  String _title;
  String _victoryDescription;
  String? _lossDescription;
  int _roundLimit;
  final List<String> _challenges;

  int _baseLystReward;
  List<String> _itemRewards;
  List<Ether> _etherRewards;
  int _unlocksShopLevel;
  int _unlocksRoverLevel;
  late List<EditableMapModel> _placementGroups;

  EditableEncounterModel({required this.encounter, CampaignDef? campaign})
      : key = const Uuid().v4(),
        _campaignDefinition = campaign ?? CampaignLoader.instance.campaign,
        _expansion = encounter.expansion,
        _questId = encounter.questId,
        _number = encounter.number,
        _title = encounter.title,
        _victoryDescription = encounter.victoryDescription,
        _lossDescription = encounter.lossDescription,
        _roundLimit = encounter.roundLimit,
        _challenges = encounter.challenges.toList(),
        _baseLystReward = encounter.baseLystReward,
        _itemRewards = encounter.itemRewards.toList(),
        _etherRewards = encounter.etherRewards.toList(),
        _unlocksShopLevel = encounter.unlocksShopLevel,
        _unlocksRoverLevel = encounter.unlocksRoverLevel {
    EncounterVariables.instance.registerModel(this);
    _restart();
  }

  String? get expansion => _expansion;
  set expansion(String? value) {
    _expansion = value;
    notifyListeners();
  }

  String get questId => _questId;
  set questId(String value) {
    _questId = value;
    notifyListeners();
  }

  String get number => _number;
  set number(String value) {
    _number = value;
    notifyListeners();
  }

  String get title => _title;
  set title(String value) {
    _title = value;
    notifyListeners();
  }

  String get victoryDescription => _victoryDescription;
  set victoryDescription(String value) {
    _victoryDescription = value;
    notifyListeners();
  }

  String? get lossDescription => _lossDescription;
  set lossDescription(String? value) {
    _lossDescription = value;
    notifyListeners();
  }

  int get roundLimit => _roundLimit;
  set roundLimit(int value) {
    _roundLimit = value;
    notifyListeners();
  }

  List<String> get challenges => _challenges;
  setChallengeAtIndex(index, {required String challenge}) {
    while (index >= _challenges.length) {
      _challenges.add('');
    }
    _challenges[index] = challenge;
    notifyListeners();
  }

  int get baseLystReward => _baseLystReward;
  set baseLystReward(int value) {
    _baseLystReward = value;
    notifyListeners();
  }

  List<String> get itemRewards => _itemRewards;
  set itemReward(String value) {
    _itemRewards = value.isNotEmpty ? [value] : [];
    notifyListeners();
  }

  List<Ether> get etherRewards => _etherRewards;
  set etherReward(Ether ether) {
    _etherRewards = [ether];
    notifyListeners();
  }

  int get unlocksShopLevel => _unlocksShopLevel;
  set unlocksShopLevel(int value) {
    _unlocksShopLevel = value;
    notifyListeners();
  }

  int get unlocksRoverLevel => _unlocksRoverLevel;
  set unlocksRoverLevel(int value) {
    _unlocksRoverLevel = value;
    notifyListeners();
  }

  List<EditableMapModel> get placementGroups => _placementGroups;

  EditableMapModel addPlacementGroup(String name, {required bool replacesMap}) {
    final submap = EditableMapModel(
        encounter: this,
        name: name,
        map: replacesMap ? EncounterData.newMap() : _map.toMapDef(),
        placements: []);
    submap.addListener(() {
      _onMapStateChanged();
    });
    _placementGroups.add(submap);
    _notifyListeners();
    return submap;
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
    _map = EditableMapModel(
        encounter: this,
        name: 'Default',
        map: encounter.startingMap,
        placements: encounter.placements);
    _map.addListener(() {
      _onMapStateChanged();
    });
    _placementGroups = [];
    for (final placementGroup in encounter.placementGroups) {
      final submap = EditableMapModel(
          encounter: this,
          name: placementGroup.name,
          map: placementGroup.map ?? encounter.startingMap,
          placements: placementGroup.placements);
      submap.addListener(() {
        _onMapStateChanged();
      });
      _placementGroups.add(submap);
    }
    EncounterVariables.instance.updateVariables(this);
    _startEncounter();
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
      return 'Rover Phase';
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

  bool get startedTurn => _startedTurn;

  startTurnForUnit(UnitModel unit) {
    assert(!_startedTurn);
    assert(_currentTurnUnit == null);
    assert(!endedTurnUnits.contains(unit));

    _currentTurnUnit = unit;
    _startedTurn = true;
    unit.startedTurn = true;
    log.addRecord(unit, 'Started turn');
    notifyListeners();
  }

  bool isEndedTurnOfUnit(UnitModel unit) {
    return endedTurnUnits.contains(unit);
  }

  List<EnemyModel> get actingAdversaries {
    return encounter.adversaries.fold<List<EnemyModel>>([],
        (List<EnemyModel> list, adversaryDef) {
      list.addAll(map.adversaries
          .whereType<EnemyModel>()
          .where((a) => a.className == adversaryDef.name)
          .toList()
        ..sort((a, b) => a.minPlayerCount.compareTo(b.minPlayerCount)));
      return list;
    });
  }

  List<EnemyModel> get pendingTurnAdversaries {
    return encounter.adversaries.fold<List<EnemyModel>>([],
        (List<EnemyModel> list, adversaryDef) {
      list.addAll(map.adversaries
          .whereType<EnemyModel>()
          .where((a) => !isEndedTurnOfUnit(a))
          .where((a) => a.className == adversaryDef.name)
          .toList()
        ..sort((a, b) => a.minPlayerCount.compareTo(b.minPlayerCount)));
      return list;
    });
  }

  List<UnitModel> _unitsForPhase(RoundPhase phase) {
    switch (phase) {
      case RoundPhase.rover:
        return [];
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
    for (final adversary in encounter.adversaries) {
      enemyClasses[adversary.name] = EditableEnemyClassModel(adversary);
    }
  }

  void initializeUnitClassesIfNeeded(List<TileModel> models) {
    for (final model in models) {
      if (model is EnemyModel) {
        if (!enemyClasses.containsKey(model.className)) {
          enemyClasses[model.className] = EditableEnemyClassModel(
              EncounterFigureDef(name: model.className, health: 8));
        }
      }
    }
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

    _currentTurnUnit = null;
    _startedTurn = false;
    notifyListeners();
  }

  bool get isLastPhaseOfRound => phases.indexOf(phase) == phases.length - 1;

  bool get willEndPhase {
    switch (phase) {
      case RoundPhase.rover:
        return false;
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

  EncounterDef toEncounterDef() {
    final placements = map.placements;

    final placementGroupsDef =
        placementGroups.map((m) => m.toPlacementGroupDef()).toList();

    final allPlacements = <PlacementDef>[];
    allPlacements.addAll(placements);
    for (final group in placementGroupsDef) {
      allPlacements.addAll(group.placements);
    }
    final adversaries = allPlacements
        .where((p) => p.type == PlacementType.enemy)
        .map((p) => p.name)
        .toSet()
        .map((name) {
      final enemyClass = enemyClasses[name];
      if (enemyClass != null) {
        return enemyClass.toEncounterFigureDef();
      }
      return EncounterFigureDef(name: name, health: 10);
    }).toList();

    return EncounterDef(
      expansion: expansion,
      questId: questId,
      number: number,
      title: title,
      victoryDescription: victoryDescription,
      lossDescription: lossDescription,
      roundLimit: roundLimit,
      startingMap: map.toMapDef(),
      adversaries: adversaries,
      placements: placements,
      challenges: challenges,
      baseLystReward: baseLystReward,
      itemRewards: itemRewards,
      etherRewards: etherRewards,
      unlocksShopLevel: unlocksShopLevel,
      unlocksRoverLevel: unlocksRoverLevel,
      placementGroups: placementGroupsDef,
    );
  }
}
