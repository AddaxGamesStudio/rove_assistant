import 'dart:ui';

import 'package:rove_editor/model/editable_map_model.dart';
import 'package:rove_editor/model/tiles/tile_model.dart';
import 'package:hex_grid/hex_grid.dart';

import 'package:rove_data_types/rove_data_types.dart';

abstract class UnitModel extends TileModel with Slayable {
  bool _startedTurn = false;
  bool _endedTurn = false;
  List<HexCoordinate> _startTurnCoordinates;
  final List<RoveBuff> _buffs = [];
  List<RoveBuff> get buffs => _buffs;
  bool _focused = false;
  final EditableMapModel map;

  UnitModel({required super.coordinate, required this.map})
      : _startTurnCoordinates = [coordinate];

  String get className;
  bool get isAdversary => faction == Faction.adversary;
  bool get isAlly => faction == Faction.rover;
  bool get isFlying;
  bool get canEnterObjectSpaces => isFlying;
  Faction get faction;
  Image get image;
  final Map<String, int> _variables = {};

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

  PlacementType get placementType;
  int get minPlayerCount;

  PlacementDef toPlacement() {
    final evenQ = coordinate.toEvenQ();
    return PlacementDef(
      name: className,
      type: placementType,
      minPlayers: minPlayerCount,
      c: evenQ.q,
      r: evenQ.r,
    );
  }
}
