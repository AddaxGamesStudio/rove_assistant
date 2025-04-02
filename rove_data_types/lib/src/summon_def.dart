import 'package:flutter/foundation.dart';
import 'package:rove_data_types/src/actions/ability_def.dart';

@immutable
class SummonDef {
  final String name;
  final int health;
  final bool autoSummoned;
  final bool ignoresDifficultTerrain;
  final AbilityDef ability;

  const SummonDef({
    required this.name,
    required this.health,
    this.autoSummoned = false,
    this.ignoresDifficultTerrain = false,
    required this.ability,
  });

  factory SummonDef.fromJson(Map<String, dynamic> json) {
    return SummonDef(
      name: json['name'] as String,
      health: json['health'] as int,
      autoSummoned: json.containsKey('auto_summoned')
          ? json['auto_summoned'] as bool
          : false,
      ignoresDifficultTerrain: json.containsKey('ignores_difficult_terrain')
          ? json['ignores_difficult_terrain'] as bool
          : false,
      ability: json.containsKey('ability')
          ? AbilityDef.fromJson(json['ability'] as Map<String, dynamic>)
          : AbilityDef(name: 'TODO', actions: []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'health': health,
      if (autoSummoned) 'auto_summoned': autoSummoned,
      if (ignoresDifficultTerrain)
        'ignores_difficult_terrain': ignoresDifficultTerrain,
      'ability': ability.toJson(),
    };
  }
}
