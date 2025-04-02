import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:rove_data_types/rove_data_types.dart';

class EditableEnemyClassModel extends ChangeNotifier {
  String? _name;
  String? _alias;
  String? _letter;
  int? _health;
  String? _healthFormula;
  int? _defense;
  String? _defenseFormula;
  String? _xDefinition;
  bool _large;
  bool _respawns;
  bool _immuneToForcedMovement;
  bool _immuneToTeleport;
  bool _ignoresDifficultTerrain;
  int _reducePushPullBy;
  bool _flies;
  bool _infected;
  bool _entersObjectSpaces;
  final Map<Ether, int> _affinities;
  final List<String> _traits;

  static List<int> abilityDiceSides = [1, 1, 1, 2, 2, 3];

  EditableEnemyClassModel(EncounterFigureDef definition, {Random? random})
      : _name = definition.name,
        _alias = definition.alias,
        _letter = definition.letter,
        _health = definition.health,
        _healthFormula = definition.healthFormula,
        _defense = definition.defense,
        _defenseFormula = definition.defenseFormula,
        _xDefinition = definition.xDefinition,
        _large = definition.large,
        _respawns = definition.respawns,
        _immuneToForcedMovement = definition.immuneToForcedMovement,
        _immuneToTeleport = definition.immuneToTeleport,
        _ignoresDifficultTerrain = definition.ignoresDifficultTerrain,
        _reducePushPullBy = definition.reducePushPullBy,
        _flies = definition.flies,
        _infected = definition.infected,
        _entersObjectSpaces = definition.entersObjectSpaces,
        _affinities = Map.from(definition.affinities),
        _traits = definition.traits.toList();

  String? get name => _name;
  set name(String? value) {
    if (_name != value) {
      _name = value;
      notifyListeners();
    }
  }

  String? get alias => _alias;
  set alias(String? value) {
    if (_alias != value) {
      _alias = value;
      notifyListeners();
    }
  }

  String? get letter => _letter;
  set letter(String? value) {
    if (_letter != value) {
      _letter = value;
      notifyListeners();
    }
  }

  int? get health => _health;
  set health(int? value) {
    if (_health != value) {
      _health = value;
      notifyListeners();
    }
  }

  String? get healthFormula => _healthFormula;
  set healthFormula(String? value) {
    if (_healthFormula != value) {
      _healthFormula = value;
      if (value != null && value.isNotEmpty) {
        _health = null;
      }
      notifyListeners();
    }
  }

  int? get defense => _defense;
  set defense(int? value) {
    if (_defense != value) {
      _defense = value;
      notifyListeners();
    }
  }

  String? get defenseFormula => _defenseFormula;
  set defenseFormula(String? value) {
    if (_defenseFormula != value) {
      _defenseFormula = value;
      if (value != null && value.isNotEmpty) {
        _defense = null;
      }
      notifyListeners();
    }
  }

  String? get xDefinition => _xDefinition;
  set xDefinition(String? value) {
    if (_xDefinition != value) {
      _xDefinition = value;
      notifyListeners();
    }
  }

  bool get large => _large;
  set large(bool value) {
    if (_large != value) {
      _large = value;
      notifyListeners();
    }
  }

  bool get respawns => _respawns;
  set respawns(bool value) {
    if (_respawns != value) {
      _respawns = value;
      notifyListeners();
    }
  }

  bool get immuneToForcedMovement => _immuneToForcedMovement;
  set immuneToForcedMovement(bool value) {
    if (_immuneToForcedMovement != value) {
      _immuneToForcedMovement = value;
      notifyListeners();
    }
  }

  bool get immuneToTeleport => _immuneToTeleport;
  set immuneToTeleport(bool value) {
    if (_immuneToTeleport != value) {
      _immuneToTeleport = value;
      notifyListeners();
    }
  }

  bool get ignoresDifficultTerrain => _ignoresDifficultTerrain;
  set ignoresDifficultTerrain(bool value) {
    if (_ignoresDifficultTerrain != value) {
      _ignoresDifficultTerrain = value;
      notifyListeners();
    }
  }

  int get reducePushPullBy => _reducePushPullBy;
  set reducePushPullBy(int value) {
    if (_reducePushPullBy != value) {
      _reducePushPullBy = value;
      notifyListeners();
    }
  }

  bool get infected => _infected;
  set infected(bool value) {
    if (_infected != value) {
      _infected = value;
      notifyListeners();
    }
  }

  bool get flies => _flies;
  set flies(bool value) {
    if (_flies != value) {
      _flies = value;
      notifyListeners();
    }
  }

  bool get entersObjectSpaces => _entersObjectSpaces;
  set entersObjectSpaces(bool value) {
    if (_entersObjectSpaces != value) {
      _entersObjectSpaces = value;
      notifyListeners();
    }
  }

  Map<Ether, int> get affinities => _affinities;
  void setAffinity(Ether ether, int value) {
    if (_affinities[ether] != value) {
      _affinities[ether] = value;
      notifyListeners();
    }
  }

  List<String> get traits => _traits;
  String? get trait => _traits.firstOrNull;
  set trait(String? trait) {
    if (trait == null) {
      _traits.clear();
      notifyListeners();
    } else if (trait.isEmpty && _traits.isNotEmpty) {
      _traits.clear();
      notifyListeners();
    } else if (_traits.firstOrNull != trait) {
      _traits.clear();
      _traits.add(trait);
      notifyListeners();
    }
  }

  EncounterFigureDef toEncounterFigureDef() {
    return EncounterFigureDef(
        name: _name ?? 'Test',
        alias: _alias,
        letter: _letter,
        health: _health,
        healthFormula: _healthFormula,
        defense: _defense,
        defenseFormula: _defenseFormula,
        xDefinition: _xDefinition,
        respawns: _respawns,
        immuneToForcedMovement: _immuneToForcedMovement,
        reducePushPullBy: _reducePushPullBy,
        flies: _flies,
        infected: _infected,
        entersObjectSpaces: _entersObjectSpaces,
        affinities: _affinities,
        traits: _traits);
  }
}
