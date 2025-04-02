import 'package:rove_simulator/model/encounter_model.dart';
import 'package:rove_simulator/model/tiles/unit_def.dart';
import 'package:rove_data_types/rove_data_types.dart';

class EncounterVariables {
  static final EncounterVariables _singleton = EncounterVariables._internal();
  static EncounterVariables get instance => _singleton;
  EncounterVariables._internal();

  int playerCount = 0;
  int round = 0;
  final Map<String, int> _unitCounts = {};

  registerModel(EncounterModel model) {
    model.addListener(() {
      updateVariables(model);
    });
  }

  updateVariables(EncounterModel model) {
    playerCount = model.players.length;
    round = model.round;
    _unitCounts.clear();
    for (final enemyClass in model.encounter.adversaries) {
      _unitCounts[enemyClass.name] = model.map.enemyCount(enemyClass.name);
    }
  }

  Map<String, int> get variables {
    return {
      rovePlayerCountVariable: playerCount,
      roveRoundVariable: round,
    };
  }

  int resolveFormula(String formula,
      {Map<String, int> extraVariables = const {}}) {
    return roveResolveFormula(formula, {...extraVariables, ...variables});
  }

  int resolveFormulaForUnit(String formula, UnitDef unit) {
    final allVariables = variables;
    final xFunction = unit.xFunction;
    if (xFunction != null) {
      switch (xFunction) {
        case EncounterFigureDef.countAdversaryFunction:
          final xTarget = unit.xTarget;
          assert(xTarget != null);
          allVariables[roveXVariable] = _unitCounts[xTarget] ?? 0;
          break;
      }
    }
    return roveResolveFormula(formula, allVariables);
  }
}
