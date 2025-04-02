import 'package:flutter/foundation.dart';
import 'package:rove_simulator/model/tiles/unit_def.dart';
import 'package:rove_data_types/rove_data_types.dart';

@immutable
class EnemyUnitDef extends UnitDef {
  final int number;
  final bool isFlying;
  final bool canEnterObjectSpaces;
  final bool large;
  final bool immuneToForcedMovement;
  final bool ignoresDifficultTerrain;
  final int reducePushPullBy;
  final List<EnemyReactionDef> reactions;
  final EncounterFigureDef _encounterFigureDef;

  EnemyUnitDef({
    required this.number,
    required super.figureDef,
    required EncounterFigureDef encounterFigureDef,
    required super.placement,
  })  : _encounterFigureDef = encounterFigureDef,
        isFlying = encounterFigureDef.flies,
        canEnterObjectSpaces = encounterFigureDef.entersObjectSpaces,
        large = encounterFigureDef.large,
        immuneToForcedMovement = encounterFigureDef.immuneToForcedMovement,
        ignoresDifficultTerrain = encounterFigureDef.ignoresDifficultTerrain,
        reducePushPullBy = encounterFigureDef.reducePushPullBy,
        reactions = encounterFigureDef.reactions,
        super(encounterFigureDef: encounterFigureDef);

  List<String> get descriptiveTraits => _encounterFigureDef.traits;
  List<AbilityDef> get abilities => _encounterFigureDef.abilities;
  Map<Ether, int> get affinities => _encounterFigureDef.affinities;
}
