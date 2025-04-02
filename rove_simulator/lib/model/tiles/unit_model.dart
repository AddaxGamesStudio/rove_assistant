import 'dart:convert';
import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:rove_simulator/model/encounter_variables.dart';
import 'package:rove_simulator/model/map_model.dart';
import 'package:rove_simulator/model/tiles/ether_node_model.dart';
import 'package:rove_simulator/model/tiles/tile_model.dart';
import 'package:hex_grid/hex_grid.dart';

import 'package:rove_data_types/rove_data_types.dart';

abstract class UnitModel extends TileModel with Slayable {
  bool _startedTurn = false;
  bool _endedTurn = false;
  List<HexCoordinate> _startTurnCoordinates;
  List<RoveBuff> _buffs = [];
  List<RoveBuff> get buffs => _buffs;
  bool _focused = false;
  final MapModel map;

  UnitModel({required super.coordinate, required this.map})
      : _startTurnCoordinates = [coordinate];

  String get className;
  bool get isAdversary => faction == Faction.adversary;
  bool get isAlly => faction == Faction.rover;
  bool get isFlying;
  bool get canEnterObjectSpaces => isFlying;
  Faction get faction;
  Image get image;
  Map<String, int> _variables = {};

  @override
  List<EtherNodeModel> get nearbyEther => coordinates
      .map((c) => map.etherAffectingCoordinate(c))
      .flattenedToSet // Do not repeat ether nodes
      .toList();

  @override
  List<RoveGlyph> get affectingGlyphs {
    final glyph = map.glyphs[coordinate];
    if (glyph != null && glyph.matches(this)) {
      return [glyph.glyph];
    }
    return [];
  }

  @override
  int get defense =>
      buffs
          .where((b) => b.type == BuffType.defense)
          .fold<int>(0, (prev, b) => prev + b.amount) +
      super.defense;
  int get damage => maxHealth - health;

  bool isAllyToUnit(UnitModel unit) => faction == unit.faction && unit != this;
  bool isEnemyToUnit(UnitModel unit) => faction != unit.faction;

  /* Abstract methods */

  int affinityForEther(Ether ether);
  String? get trapImage;

  (Ether, int) rollDamageAndResolveAffinity() {
    final ether = Ether.randomDamageDie();
    return (ether, affinityForEther(ether));
  }

  onPushPullExecuted() {
    buffs.removeWhere(
        (b) => b.type == BuffType.trapDamage && b.scope == BuffScope.action);
  }

  @override
  onAttackResolved() {
    buffs.removeWhere(
        (b) => b.type == BuffType.defense && b.scope == BuffScope.action);
  }

  bool get startedTurn => _startedTurn;
  List<HexCoordinate> get startTurnCoordinates => _startTurnCoordinates;
  bool get endedTurn => _endedTurn;

  set startedTurn(bool value) {
    if (value == _startedTurn) {
      return;
    }
    _startTurnCoordinates = coordinates;
    _startedTurn = value;
    _endedTurn = false;
    if (_startedTurn) {
      buffs.removeWhere((b) {
        switch (b.scope) {
          case BuffScope.untilEndOfTurn:
            return false;
          case BuffScope.action:
            assert(false);
            return true;
          case BuffScope.untilStartOfTurn:
            return true;
          case BuffScope.permanent:
            return false;
        }
      });
    }
    notifyListeners();
  }

  set endedTurn(bool value) {
    if (value == _endedTurn) {
      return;
    }
    _endedTurn = value;
    _startedTurn = false;
    if (_endedTurn) {
      buffs.removeWhere((b) {
        switch (b.scope) {
          case BuffScope.untilEndOfTurn:
            return true;
          case BuffScope.action:
            assert(false);
            return true;
          case BuffScope.untilStartOfTurn:
            return false;
          case BuffScope.permanent:
            return false;
        }
      });
    }
    notifyListeners();
  }

  void resetRound() {
    _variables.clear();
    notifyListeners();
  }

  @override
  bool get isImperviousToDangerousTerrain => isFlying;

  @override
  bool get ignoresDifficultTerrain => isFlying;

  bool get focused => _focused;
  set focused(bool value) {
    if (value == _focused) {
      return;
    }
    _focused = value;
    notifyListeners();
  }

  /* Formula Variables */

  void setVariable(String name, int value) {
    _variables[name] = value;
    notifyListeners();
  }

  int variableForName(String name) => _variables[name] ?? 0;

  int resolveAmountForAction(RoveAction action) {
    return _resolveAmountForAction(action, action.amount, action.amountFormula);
  }

  int resolvePushAmountForAction(RoveAction action) {
    return _resolveAmountForAction(action, action.push, action.pushFormula);
  }

  int _resolveAmountForAction(RoveAction action, int amount, String? formula) {
    if (formula == null) {
      return amount;
    }
    final extraVariables = <String, int>{};
    switch (action.xDefinition) {
      case RoveActionXDefinition.previousMovementEffort:
        extraVariables[roveXVariable] = variableForName(
            RoveActionXDefinition.previousMovementEffort.toJson());
      case RoveActionXDefinition.targetDefense:
        // TODO: Implement targetDefense
        break;
      case null:
    }
    return EncounterVariables.instance
        .resolveFormula(formula, extraVariables: extraVariables);
  }

  /* Saveable */

  @override
  setSaveablePropertiesBeforeChildren(Map<String, dynamic> properties) {
    super.setSaveablePropertiesBeforeChildren(properties);
    _startedTurn = properties['started_turn'] as bool? ?? false;
    _endedTurn = properties['ended_turn'] as bool? ?? false;
    _startTurnCoordinates =
        (properties['start_turn_coordinates'] as List<String>)
            .map((s) => EvenQHexCoordinate.fromString(s))
            .toList();
    _buffs = (properties['buffs'] as List<String>)
        .map((s) => RoveBuff.fromJson(jsonDecode(s)))
        .toList();
    _focused = properties['focused'] as bool? ?? false;
    _variables = (Map<String, int>.from(properties['variables'] as Map));
  }

  @override
  Map<String, dynamic> saveableProperties() {
    final properties = super.saveableProperties();
    properties.addAll({
      'started_turn': _startedTurn,
      'ended_turn': _endedTurn,
      'start_turn_coordinates':
          _startTurnCoordinates.map((c) => c.toEvenQ().toString()).toList(),
      'buffs': buffs.map((b) => jsonEncode(b)).toList(),
      'focused': _focused,
      'variables': Map<String, int>.from(_variables),
    });
    return properties;
  }
}
