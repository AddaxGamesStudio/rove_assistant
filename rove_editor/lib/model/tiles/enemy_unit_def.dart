import 'package:rove_editor/model/tiles/unit_def.dart';
import 'package:rove_data_types/rove_data_types.dart';

class EnemyUnitDef extends UnitDef {
  int minPlayerCount;
  final bool isFlying;
  final bool canEnterObjectSpaces;
  final bool large;
  final bool immuneToForcedMovement;
  final bool immuneToTeleport;
  final bool ignoresDifficultTerrain;
  final int reducePushPullBy;
  final List<EnemyReactionDef> reactions;
  final EncounterFigureDef? _encounterFigureDef;

  EnemyUnitDef({
    required this.minPlayerCount,
    required super.figureDef,
    required super.encounterFigureDef,
    required super.placement,
  })  : _encounterFigureDef = encounterFigureDef,
        isFlying = encounterFigureDef?.flies ?? false,
        canEnterObjectSpaces = encounterFigureDef?.entersObjectSpaces ?? false,
        large = encounterFigureDef?.large ?? false,
        immuneToForcedMovement =
            encounterFigureDef?.immuneToForcedMovement ?? false,
        immuneToTeleport = encounterFigureDef?.immuneToTeleport ?? false,
        ignoresDifficultTerrain =
            encounterFigureDef?.ignoresDifficultTerrain ?? false,
        reducePushPullBy = encounterFigureDef?.reducePushPullBy ?? 0,
        reactions = encounterFigureDef?.reactions ?? [];

  List<String> get descriptiveTraits => _encounterFigureDef?.traits ?? [];
  List<AbilityDef> get abilities => _encounterFigureDef?.abilities ?? [];
  Map<Ether, int> get affinities => _encounterFigureDef?.affinities ?? {};
}
