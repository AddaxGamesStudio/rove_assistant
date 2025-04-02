import 'dart:async';

import 'package:rove_simulator/controller/enemy_actions/enemy_action_resolver.dart';
import 'package:rove_simulator/controller/enemy_ai.dart';
import 'package:rove_simulator/model/cards/ability_model.dart';
import 'package:rove_simulator/model/encounter_log.dart';
import 'package:rove_simulator/model/tiles/enemy_model.dart';
import 'package:rove_simulator/model/tiles/unit_model.dart';
import 'package:hex_grid/hex_grid.dart';

class EnemyCommandResolver extends EnemyActionResolver {
  final AbilityModel ability;

  EnemyCommandResolver(
      {required super.game,
      required super.actor,
      required this.ability,
      required super.action})
      : super(targets: []);

  Completer<bool> completer = Completer();

  EnemyAI? _commandedAI;

  @override
  UnitModel get actingUnit => _commandedAI?.actor ?? actor;

  @override
  List<HexCoordinate> get targetCoordinates {
    if (_commandedAI != null) {
      return _commandedAI!.targetCoordinate != null
          ? [_commandedAI!.targetCoordinate!]
          : [];
    } else {
      return super.targetCoordinates;
    }
  }

  @override
  Future<bool> execute() async {
    final List<EnemyModel> targets = _findClosestsTarget();
    if (targets.isEmpty) {
      log.addRecord(actor, 'Skipped Command due to no targets within range');
      return false;
    }
    for (EnemyModel target in targets) {
      log.addRecord(actor, 'Commanding ${EncounterLogEntry.targetKeyword}',
          target: target);
      final ai = EnemyAI(game: game, actor: target);
      _commandedAI = ai;
      await ai.resolveAbility(
          ability: ability,
          actions: action.commands,
          indexOffset: ability.actions.indexOf(action) + 1);
      _commandedAI = null;
    }
    return true;
  }

  List<EnemyModel> _findClosestsTarget() {
    final enemies = mapModel.targetableUnits
        .where((u) => u.isAllyToUnit(actor) && u.className == action.object)
        .whereType<EnemyModel>()
        .toList();
    var unitsAnDistance = enemies
        .map((u) => (u, actor.distanceToTarget(u)))
        .where((d) => action.range.$1 <= d.$2 && d.$2 <= action.range.$2)
        .toList();
    // SEED: Randomize in case of tie
    unitsAnDistance.shuffle();
    unitsAnDistance.sort((a, b) => a.$2.compareTo(b.$2));
    final targets = unitsAnDistance.map((d) => d.$1).toList();
    return targets.length > action.targetCount
        ? targets.sublist(0, action.targetCount)
        : targets;
  }
}
