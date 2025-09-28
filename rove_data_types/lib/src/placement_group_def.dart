import 'package:collection/collection.dart';
import 'package:meta/meta.dart';
import 'package:rove_data_types/src/ally_def.dart';
import 'package:rove_data_types/src/encounter_def.dart';
import 'package:rove_data_types/src/encounter_figure_def.dart';
import 'package:rove_data_types/src/map_def.dart';
import 'package:rove_data_types/src/placement_def.dart';
import 'package:rove_data_types/src/utils/json_utils.dart';

@immutable
class PlacementGroupDef {
  final String name;
  final EncounterSetup? setup;
  final List<EncounterTerrain> terrain;
  final bool isSpawnWithDie;
  final MapDef? map;
  final List<AllyDef> allies;
  final List<EncounterFigureDef> adversaries;
  final List<PlacementDef> placements;

  const PlacementGroupDef(
      {required this.name,
      this.setup,
      this.terrain = const [],
      this.isSpawnWithDie = false,
      this.map,
      this.allies = const [],
      this.adversaries = const [],
      required this.placements});

  factory PlacementGroupDef.fromJson(Map<String, dynamic> json) {
    return PlacementGroupDef(
      name: json['name'],
      setup: json.containsKey('setup')
          ? EncounterSetup.fromJson(json['setup'] as Map<String, dynamic>)
          : null,
      terrain: decodeJsonListNamed(
          'terrain', json, (e) => EncounterTerrain.fromJson(e)),
      isSpawnWithDie: json.containsKey('spawn_with_die') as bool? ?? false,
      map: json.containsKey('map')
          ? MapDef.fromJson(json['map'] as Map<String, dynamic>)
          : null,
      allies: decodeJsonListNamed('allies', json, (e) => AllyDef.fromJson(e)),
      adversaries: decodeJsonListNamed(
          'adversaries', json, (e) => EncounterFigureDef.fromJson(e)),
      placements: decodeJsonListNamed(
          'placements', json, (e) => PlacementDef.fromJson(e)),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      if (setup case final value?) 'setup': value.toJson(),
      if (terrain.isNotEmpty)
        'terrain': terrain.map((t) => t.toJson()).toList(),
      if (isSpawnWithDie) 'spawn_with_die': isSpawnWithDie,
      if (map case final value?) 'map': value.toJson(),
      if (allies.isNotEmpty) 'allies': allies.map((a) => a.toJson()).toList(),
      if (adversaries.isNotEmpty)
        'adversaries': adversaries.map((a) => a.toJson()).toList(),
      if (placements.isNotEmpty)
        'placements': placements.map((p) => p.toJson()).toList(),
    };
  }

  bool get clearCurrentPlacements => map != null;

  Set<String> get referencedEntities {
    return placements.map((p) => p.name).toSet();
  }

  Set<String> get referencedItems {
    return placements.map((p) => p.referencedItems).flattenedToSet;
  }
}
