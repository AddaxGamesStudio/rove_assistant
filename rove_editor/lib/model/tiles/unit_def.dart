import 'package:rove_editor/model/encounter_variables.dart';
import 'package:rove_data_types/rove_data_types.dart';

class UnitDef {
  final String? expansion;
  final String className;
  final String name;
  final int? _maxHealth;
  final String? _maxHealthFormula;
  final int? _defense;
  final String? _defenseFormula;
  final String? xTarget;
  final String? xFunction;
  final String imageFilename;
  final bool sleeping;
  final List<EncounterAction> onDidStartRound;
  final List<EncounterAction> onWillEndRound;
  final List<EncounterAction> onSlayed;
  final PlacementDef placement;

  UnitDef({
    required FigureDef figureDef,
    required EncounterFigureDef? encounterFigureDef,
    required this.placement,
  })  : expansion = figureDef.expansion,
        className = figureDef.name,
        name = encounterFigureDef?.alias ?? figureDef.name,
        _maxHealth = encounterFigureDef?.health,
        _maxHealthFormula = encounterFigureDef?.healthFormula,
        _defense = encounterFigureDef?.defense,
        _defenseFormula = encounterFigureDef?.defenseFormula,
        imageFilename = figureDef.image,
        sleeping = placement.sleeping,
        onDidStartRound = placement.onDidStartRound,
        onWillEndRound = placement.onWillEndRound,
        onSlayed = [...placement.onSlain, ...encounterFigureDef?.onSlain ?? []],
        xFunction = encounterFigureDef?.xFunction,
        xTarget = encounterFigureDef?.xTarget;

  int resolveDefense() {
    return _defenseFormula != null
        ? EncounterVariables.instance
            .resolveFormulaForUnit(_defenseFormula, this)
        : _defense ?? 0;
  }

  int resolveMaxHealth() {
    return _maxHealthFormula != null
        ? EncounterVariables.instance
            .resolveFormulaForUnit(_maxHealthFormula, this)
        : _maxHealth ?? 0;
  }
}
