import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:rove_simulator/controller/base_controller.dart';
import 'package:rove_simulator/controller/enemy_ai.dart';
import 'package:rove_simulator/model/encounter_model.dart';
import 'package:rove_simulator/model/tiles/ether_node_model.dart';
import 'package:rove_simulator/model/tiles/player_unit_model.dart';
import 'package:rove_simulator/model/tiles/terrain_model.dart';
import 'package:rove_simulator/model/tiles/tile_model.dart';
import 'package:rove_simulator/model/tiles/unit_model.dart';
import 'package:hex_grid/hex_grid.dart';
import 'package:rove_simulator/widgets/encounter/instruction_widget.dart';
import 'package:rove_simulator/widgets/encounter/start_encounter_widget.dart';
import 'package:rove_data_types/rove_data_types.dart';

class TurnController extends BaseController {
  bool _startedEncounter = false;
  bool get startedEncounter => _startedEncounter;
  PlayerUnitModel? _selectedPlayerDuringSetup;
  Completer<bool>? _exceesEtherCompleter;
  EnemyAI? _enemyAi;

  TurnController({required super.game});

  restart() {
    game.overlays.remove(StartEncounterWidget.overlayName);
    game.overlays.remove(InstructionWidget.overlayName);
    _startedEncounter = false;
    _selectedPlayerDuringSetup = null;
    _exceesEtherCompleter = null;
    _enemyAi = null;
    notifyListeners();
  }

  TileModel? get actor => _enemyAi?.currentActor ?? cardController.actor;
  HexCoordinate? get targetCoordinate =>
      _enemyAi?.targetCoordinate ?? cardController.targetCoordinate;
  String? debugStringForCoordinate(HexCoordinate coordinate) {
    return _enemyAi?.debugStringForCoordinate(coordinate) ??
        cardController.debugStringForCoordinate(coordinate);
  }

  bool isInAreaOfEffect(HexCoordinate coordinate) {
    return _enemyAi?.isInAreaOfEffect(coordinate) ??
        game.cardResolver?.isInAreaOfEffect(coordinate) ??
        false;
  }

  RoveActionPolarity? get currentActionPolarity =>
      _enemyAi?.currentActionPolarity ??
      game.cardResolver?.currentActionPolarity;

  Future<void> onPlayerDowned(PlayerUnitModel player) async {
    assert(player.isDowned);
    final currentTurnUnit = model.currentTurnUnit;
    if (model.actingPlayers.isEmpty) {
      game.fail();
    } else if (currentTurnUnit == player) {
      await endTurnForUnit(player);
    }
  }

  startEncounterSetup() {
    if (kDebugMode) {
      startEncounter();
      return;
    }
    game.overlays.add(StartEncounterWidget.overlayName);
  }

  startEncounter() {
    _selectedPlayerDuringSetup = null;
    _startedEncounter = true;
    model.setPlaying();
    notifyListeners();
    game.overlays.remove(StartEncounterWidget.overlayName);
    game.overlays.add(InstructionWidget.overlayName);
    model.save(HistoryEvent.startRound);
    if (model.phase == RoundPhase.adversary) {
      _resolveNextEnemyTurn();
    }
  }

  bool onSelectedTerrain(TerrainModel terrain) {
    if (_startedEncounter) {
      return false;
    }
    if (_selectedPlayerDuringSetup == null) {
      return false;
    }
    if (terrain.terrain != TerrainType.start) {
      return false;
    }
    if (_selectedPlayerDuringSetup!.coordinate == terrain.coordinate) {
      return false;
    }
    mapController.teleport(
        actor: _selectedPlayerDuringSetup!,
        to: terrain.coordinate,
        silent: true);
    _selectedPlayerDuringSetup = null;
    return true;
  }

  bool onSelectedPlayer(PlayerUnitModel player) {
    if (_startedEncounter) {
      return false;
    }
    if (player == _selectedPlayerDuringSetup) {
      return false;
    }
    if (_selectedPlayerDuringSetup != null) {
      mapController.swapSpaces(
          fromTile: _selectedPlayerDuringSetup!, toTile: player, silent: true);
      _selectedPlayerDuringSetup = null;
      return true;
    } else {
      _selectedPlayerDuringSetup = player;
      return true;
    }
  }

  Future<void> _applyFieldDamage(
      UnitModel unit, HexCoordinate coordinate) async {
    final field = mapModel.fieldAtCoordinate(coordinate);
    final startTurnDamage = field?.startTurnDamageForUnit(unit);
    if (startTurnDamage == null || startTurnDamage == 0) {
      return;
    }

    Completer<void> completer = Completer();
    mapController.suffer(
        actor: field!.creator,
        target: unit,
        amount: startTurnDamage,
        onComplete: () {
          completer.complete();
        });
    return completer.future;
  }

  Future<void> _startTurnForUnit(UnitModel unit) async {
    await eventController.onStartTurn(actor: unit);

    for (var c in unit.coordinates) {
      await _applyFieldDamage(unit, c);
      if (unit.isSlain) {
        return;
      }
    }
  }

  Future<void> startTurnForUnit(UnitModel unit) async {
    model.startTurnForUnit(unit);
    model.save(HistoryEvent.startTurn);
    await _startTurnForUnit(unit);
  }

  Future<void> resumeFromModel() async {
    _startedEncounter = true;
    game.overlays.add(InstructionWidget.overlayName);
    final unit = model.currentTurnUnit;
    if (unit == null) {
      return;
    }
    await _startTurnForUnit(unit);
    if (unit.isAdversary) {
      await _onDidStartEnemyTurn(unit);
    }
  }

  void cancelExceesEther() {
    game.overlays.remove('excess_ether_dialog');
    _exceesEtherCompleter?.complete(false);
    _exceesEtherCompleter = null;
  }

  void removeExceesEther(List<(Ether, int)> excessEtherPoolEther,
      List<(Ether, int)> excessInfusedEther) {
    assert(_exceesEtherCompleter != null);
    for (final (ether, _) in excessEtherPoolEther) {
      model.currentPlayer?.removeEther(ether);
    }
    for (final (ether, _) in excessInfusedEther) {
      model.currentPlayer?.removeInfusedEther(ether);
    }
    game.overlays.remove('excess_ether_dialog');
    _exceesEtherCompleter?.complete(true);
    _exceesEtherCompleter = null;
  }

  Future<bool> resolveExcessEtherForPlayer(PlayerUnitModel player) {
    assert(_exceesEtherCompleter == null);
    _exceesEtherCompleter = Completer<bool>();
    game.overlays.add('excess_ether_dialog');
    return _exceesEtherCompleter!.future;
  }

  _resolveEndTurnFieldEffect(UnitModel unit, HexCoordinate coordinate) async {
    final field = mapModel.fieldAtCoordinate(coordinate);
    if (field == null) {
      return;
    }
    final endTurnHeal = field.endTurnHealForUnit(unit);
    if (endTurnHeal > 0) {
      await mapController.healUnit(
          actor: field, target: unit, amount: endTurnHeal);
    }
  }

  _resolveEndTurnEtherNodeEffect(
      UnitModel unit, EtherNodeModel etherNode) async {
    final endTurnDamage = etherNode.endTurnDamageForUnit(unit);
    if (endTurnDamage > 0) {
      await mapController.suffer(
          actor: etherNode, target: unit, amount: endTurnDamage);
    }
    final endTurnHeal = etherNode.endTurnHealForUnit(unit);
    if (endTurnHeal > 0) {
      await mapController.healUnit(
          actor: etherNode, target: unit, amount: endTurnHeal);
    }
  }

  _resolveEndTurnEffects(UnitModel unit) async {
    if (unit.isSlain) {
      return;
    }

    // Dangerous Terrain
    final coordinates = unit.coordinates;
    final stillCoordinates =
        unit.startTurnCoordinates.where((c) => coordinates.contains(c));
    for (final c in stillCoordinates) {
      if (mapModel.terrain[c]?.terrain == TerrainType.dangerous) {
        await mapController.sufferDamageFromDangerousTerrain(
            target: unit, coordinate: c);
      }
      if (unit.isSlain) {
        return;
      }
    }

    // Fields
    for (var c in coordinates) {
      await _resolveEndTurnFieldEffect(unit, c);
      if (unit.isSlain) {
        return;
      }
    }

    // Ether Nodes
    final etherNodes = unit.nearbyEther;
    for (final etherNode in etherNodes) {
      await _resolveEndTurnEtherNodeEffect(unit, etherNode);
      if (unit.isSlain) {
        return;
      }
    }
  }

  Future<void> endTurnForUnit(UnitModel unit) async {
    assert(model.currentTurnUnit == unit);
    if (unit is PlayerUnitModel && unit.hasExceesEther) {
      final resolved = await resolveExcessEtherForPlayer(unit);
      if (!resolved) {
        return;
      }
    }

    await _resolveEndTurnEffects(unit);
    model.endTurn();
    if (model.willEndPhase) {
      await eventController.onWillEndPhase();
    }
    if (model.willEndRound) {
      await eventController.onWillEndRound();
    }

    // Victory might have been achieved
    if (!model.isPlaying) {
      return;
    }

    final previousRound = model.round;
    final changedPhase = model.nextPhaseIfApplicable();
    if (previousRound != model.round) {
      if (model.round > model.encounter.roundLimit) {
        game.fail();
        return;
      }
      await eventController.onDidStartRound();
      model.save(HistoryEvent.startRound);
    }
    if (changedPhase) {
      if (model.phase == RoundPhase.adversary) {
        _resolveNextEnemyTurn();
      }
    }
  }

  _resolveNextEnemyTurn() async {
    if (!model.isPlaying) {
      return;
    }

    if (model.phase != RoundPhase.adversary) {
      return;
    }
    final enemy = model.pendingTurnAdversaries.firstOrNull;
    if (enemy == null) {
      return;
    }
    await startTurnForUnit(enemy);
    _onDidStartEnemyTurn(enemy);
  }

  _onDidStartEnemyTurn(enemy) async {
    if (!enemy.isSlain) {
      final ai = EnemyAI(game: game, actor: enemy);
      _enemyAi = ai;
      await ai.resolve();
      _enemyAi = null;
    }
    await endTurnForUnit(enemy);
    _resolveNextEnemyTurn();
  }
}
