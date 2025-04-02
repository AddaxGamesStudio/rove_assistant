import 'dart:math';
import 'dart:ui';

import 'package:rove_simulator/model/map_model.dart';
import 'package:rove_data_types/rove_data_types.dart';

extension MapModelTestData on MapModel {
  static String largeEnemyClass = 'Large';

  static MapModel testMap(
      {Map<(int, int), TerrainType> terrain = const {},
      Map<(int, int), int> traps = const {},
      Map<(int, int), String> enemies = const {}}) {
    const minimumSize = 8;
    final keys = [...terrain.keys, ...traps.keys, ...enemies.keys];
    final columnCount = keys.isEmpty
        ? minimumSize
        : max(keys.map((e) => e.$1).reduce((a, b) => a > b ? a : b) + 2,
            minimumSize);
    final rowCount = keys.isEmpty
        ? minimumSize
        : max(keys.map((e) => e.$2).reduce((a, b) => a > b ? a : b) + 2,
            minimumSize);

    final List<FigureDef> enemyFigureDefs = [];
    final List<EncounterFigureDef> enemyEncounterFigureDefs = [];
    for (final entry in enemies.entries) {
      enemyFigureDefs.add(FigureDef(
          name: entry.value, image: 'test.png', role: FigureRole.adversary));
      enemyEncounterFigureDefs.add(EncounterFigureDef(
          name: entry.value, health: 5, large: entry.value == largeEnemyClass));
    }

    final List<PlacementDef> placements = [];
    for (final entry in traps.entries) {
      placements.add(PlacementDef(
          name: 'Trap',
          type: PlacementType.trap,
          c: entry.key.$1,
          r: entry.key.$2,
          trapDamage: entry.value,
          minPlayers: 0));
    }
    for (final entry in enemies.entries) {
      placements.add(PlacementDef(
          name: entry.value,
          type: PlacementType.enemy,
          c: entry.key.$1,
          r: entry.key.$2,
          minPlayers: 0));
    }

    final map = MapModel(
        players: [],
        campaign: CampaignDef(
            title: 'Test',
            quests: const [],
            allClasses: const [],
            questItems: const [],
            shopItems: const [],
            figures: enemyFigureDefs,
            paths: const {}),
        encounter: EncounterDef(
            questId: '0',
            number: '1',
            title: 'Test',
            victoryDescription: 'Test',
            startingMap: MapDef(
                id: '0.1',
                columnCount: columnCount,
                rowCount: rowCount,
                backgroundRect: Rect.zero,
                terrain: terrain),
            roundLimit: 8,
            adversaries: enemyEncounterFigureDefs,
            placements: placements));
    map.initialize();
    return map;
  }
}
