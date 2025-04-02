import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:rove_simulator/model/persistence/saveable.dart';
import 'package:rove_data_types/rove_data_types.dart';

class EnemyClassModel extends ChangeNotifier with Saveable {
  final Random _random;
  final EncounterFigureDef _definition;
  final String name;
  int _abilityIndex = 0;
  bool _startedRound = false;
  bool _endedRound = false;

  static List<int> abilityDiceSides = [1, 1, 1, 2, 2, 3];

  EnemyClassModel(EncounterFigureDef definition, {Random? random})
      : _definition = definition,
        _random = random ?? Random(),
        name = definition.name;

  int get abilityIndex => _abilityIndex;

  _nextAbility() {
    final delta = abilityDiceSides[_random.nextInt(abilityDiceSides.length)];
    _abilityIndex = (_abilityIndex + delta) % _definition.abilities.length;
  }

  bool get startedRound => _startedRound;
  bool get endedRound => _endedRound;

  startRound(int round) {
    assert(!_startedRound);
    _startedRound = true;
    _endedRound = false;
    if (round > 1) {
      _nextAbility();
    }
    notifyListeners();
  }

  endRound() {
    assert(_startedRound);
    _endedRound = true;
    _startedRound = false;
    notifyListeners();
  }

  resetRound() {
    _endedRound = false;
    _startedRound = false;
    notifyListeners();
  }

  @override
  String get saveableKey => name;

  @override
  Map<String, dynamic> saveableProperties() {
    return {
      'ability_index': _abilityIndex,
      'started_round': _startedRound,
      'ended_round': _endedRound,
    };
  }

  @override
  String get saveableType => 'EnemyClassModel';

  @override
  setSaveablePropertiesBeforeChildren(Map<String, dynamic> properties) {
    _abilityIndex = properties['ability_index'] as int? ?? 0;
    _startedRound = properties['started_round'] as bool? ?? false;
    _endedRound = properties['ended_round'] as bool? ?? false;
  }
}
