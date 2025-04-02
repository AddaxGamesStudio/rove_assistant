import 'package:rove_data_types/rove_data_types.dart';

extension EncounterFigureDefTestData on EncounterFigureDef {
  static testEncounterFigureDef() {
    return EncounterFigureDef(name: 'Test', abilities: [
      AbilityDef(name: 'Ability 1', actions: [RoveAction.move(1)]),
      AbilityDef(name: 'Ability 2', actions: [RoveAction.move(2)]),
      AbilityDef(name: 'Ability 3', actions: [RoveAction.move(3)])
    ]);
  }
}
