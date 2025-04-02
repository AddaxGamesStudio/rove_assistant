import 'package:flutter/foundation.dart';
import 'package:rove_editor/model/tiles/unit_def.dart';
import 'package:rove_data_types/rove_data_types.dart';

@immutable
class ObjectDef extends UnitDef {
  final bool lootable;
  final RoveCondition? unlockCondition;
  final List<EncounterAction> onLoot;

  ObjectDef({
    required super.figureDef,
    required super.encounterFigureDef,
    required super.placement,
  })  : lootable =
            figureDef.lootable ? true : encounterFigureDef?.lootable ?? false,
        unlockCondition = placement.unlockCondition,
        onLoot = [...placement.onLoot, ...encounterFigureDef?.onLoot ?? []];
}
