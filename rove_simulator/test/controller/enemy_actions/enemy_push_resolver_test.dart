import 'package:flutter_test/flutter_test.dart';
import 'package:rove_simulator/controller/enemy_actions/enemy_push_resolver.dart';
import 'package:rove_simulator/model/path_type.dart';
import 'package:hex_grid/hex_grid.dart';
import 'package:rove_data_types/rove_data_types.dart';

import '../../test_data/enemy_model_test_data.dart';
import '../../test_data/map_model_test_data.dart';

void main() {
  group('MapModel.damageOfPath: single-hex unit', () {
    setUp(() {});

    test('returns 0 for empty path', () {
      final map = MapModelTestData.testMap();
      final unit = EnemyModelTestData.testEnemy(map: map);
      expect(
        map.damageOfPath(
          actor: unit,
          start: unit.coordinate,
          path: [],
        ),
        0,
      );
    });

    test('returns 0 for path without hazards', () {
      final map = MapModelTestData.testMap();
      final unit = EnemyModelTestData.testEnemy(map: map);
      expect(
        map.damageOfPath(
          actor: unit,
          start: unit.coordinate,
          path: [const CubeHexCoordinate(1, 0), const CubeHexCoordinate(0, 1)],
        ),
        0,
      );
    });

    test('returns 1 for path with 1 dangerous terrain', () {
      final map = MapModelTestData.testMap(terrain: {
        (0, 1): TerrainType.dangerous,
      });
      final unit = EnemyModelTestData.testEnemy(map: map);
      expect(
        map.damageOfPath(
          actor: unit,
          start: unit.coordinate,
          path: [const EvenQHexCoordinate(0, 1)],
        ),
        1,
      );
    });

    test('returns 2 for path with 2 dangerous terrain', () {
      final map = MapModelTestData.testMap(terrain: {
        (0, 1): TerrainType.dangerous,
        (0, 2): TerrainType.dangerous,
      });
      final unit = EnemyModelTestData.testEnemy(map: map);
      expect(
        map.damageOfPath(
          actor: unit,
          start: unit.coordinate,
          path: [
            const EvenQHexCoordinate(0, 1),
            const EvenQHexCoordinate(0, 2)
          ],
        ),
        2,
      );
    });

    test('returns 0 when jumping over dangerous terrain', () {
      final map = MapModelTestData.testMap(terrain: {
        (0, 1): TerrainType.dangerous,
      });
      final unit = EnemyModelTestData.testEnemy(map: map);
      expect(
        map.damageOfPath(
            actor: unit,
            start: unit.coordinate,
            path: [
              const EvenQHexCoordinate(0, 1),
              const EvenQHexCoordinate(0, 2)
            ],
            pathType: PathType.jump),
        0,
      );
    });

    test('returns 1 when jumping onto dangerous terrain', () {
      final map = MapModelTestData.testMap(terrain: {
        (0, 1): TerrainType.dangerous,
        (0, 2): TerrainType.dangerous,
      });
      final unit = EnemyModelTestData.testEnemy(map: map);
      expect(
        map.damageOfPath(
            actor: unit,
            start: unit.coordinate,
            path: [
              const EvenQHexCoordinate(0, 1),
              const EvenQHexCoordinate(0, 2)
            ],
            pathType: PathType.jump),
        1,
      );
    });

    test('returns 0 when ignoring terrain effects', () {
      final map = MapModelTestData.testMap(terrain: {
        (0, 1): TerrainType.dangerous,
        (0, 2): TerrainType.dangerous,
      });
      final unit = EnemyModelTestData.testEnemy(map: map);
      expect(
        map.damageOfPath(
            actor: unit,
            start: unit.coordinate,
            path: [
              const EvenQHexCoordinate(0, 1),
              const EvenQHexCoordinate(0, 2)
            ],
            pathType: PathType.dashIgnoringTerrainEffects),
        0,
      );
    });

    test('returns 0 when impervious to dangerous terrain', () {
      final map = MapModelTestData.testMap(terrain: {
        (0, 1): TerrainType.dangerous,
        (0, 2): TerrainType.dangerous,
      });
      final unit = EnemyModelTestData.testFlyingEnemy(map: map);
      expect(
        map.damageOfPath(actor: unit, start: unit.coordinate, path: [
          const EvenQHexCoordinate(0, 1),
          const EvenQHexCoordinate(0, 2)
        ]),
        0,
      );
    });

    test('returns trap damage when triggering trap', () {
      const trapDamage = 3;
      final map = MapModelTestData.testMap(traps: {
        (0, 1): trapDamage,
      });
      final unit = EnemyModelTestData.testEnemy(map: map);
      expect(
        map.damageOfPath(actor: unit, start: unit.coordinate, path: [
          const EvenQHexCoordinate(0, 1),
        ]),
        trapDamage,
      );
    });

    test('returns corresponding damage when triggering 2 traps', () {
      const trapDamage = 3;
      final map = MapModelTestData.testMap(traps: {
        (0, 1): trapDamage,
        (0, 2): trapDamage,
      });
      final unit = EnemyModelTestData.testEnemy(map: map);
      expect(
        map.damageOfPath(actor: unit, start: unit.coordinate, path: [
          const EvenQHexCoordinate(0, 1),
          const EvenQHexCoordinate(0, 2),
        ]),
        trapDamage * 2,
      );
    });

    test('triggers trap only once', () {
      const trapDamage = 3;
      final map = MapModelTestData.testMap(traps: {
        (0, 1): trapDamage,
      });
      final unit = EnemyModelTestData.testEnemy(map: map);
      expect(
        map.damageOfPath(actor: unit, start: unit.coordinate, path: [
          const EvenQHexCoordinate(0, 1),
          const EvenQHexCoordinate(0, 2),
          const EvenQHexCoordinate(0, 1),
        ]),
        trapDamage,
      );
    });

    test(
        'returns corresponding damage when triggering a trap in dangerous terrain',
        () {
      const trapDamage = 3;
      final map = MapModelTestData.testMap(terrain: {
        (0, 1): TerrainType.dangerous,
      }, traps: {
        (0, 1): trapDamage,
      });
      final unit = EnemyModelTestData.testEnemy(map: map);
      expect(
        map.damageOfPath(actor: unit, start: unit.coordinate, path: [
          const EvenQHexCoordinate(0, 1),
        ]),
        trapDamage + 1,
      );
    });

    test(
        'returns corresponding damage when triggering a trap and dangerous terrain separately',
        () {
      const trapDamage = 3;
      final map = MapModelTestData.testMap(terrain: {
        (0, 1): TerrainType.dangerous,
      }, traps: {
        (0, 2): trapDamage,
      });
      final unit = EnemyModelTestData.testEnemy(map: map);
      expect(
        map.damageOfPath(actor: unit, start: unit.coordinate, path: [
          const EvenQHexCoordinate(0, 1),
          const EvenQHexCoordinate(0, 2),
        ]),
        trapDamage + 1,
      );
    });
  });

  group('MapModel.damageOfPath: large unit', () {
    setUp(() {});

    test('returns 0 for empty path', () {
      final map = MapModelTestData.testMap();
      final unit = EnemyModelTestData.testLargeEnemy(map: map)
        ..coordinate = const EvenQHexCoordinate(1, 1);
      expect(
        map.damageOfPath(
          actor: unit,
          start: unit.coordinate,
          path: [],
        ),
        0,
      );
    });

    test('returns 0 for path without hazards', () {
      final map = MapModelTestData.testMap();
      final unit = EnemyModelTestData.testLargeEnemy(map: map)
        ..coordinate = const EvenQHexCoordinate(1, 1);
      expect(
        map.damageOfPath(
          actor: unit,
          start: unit.coordinate,
          path: [
            const EvenQHexCoordinate(2, 1),
            const EvenQHexCoordinate(1, 2)
          ],
        ),
        0,
      );
    });

    test('returns 1 for path with 1 dangerous terrain', () {
      final map = MapModelTestData.testMap(terrain: {
        (2, 1): TerrainType.dangerous,
      });
      final unit = EnemyModelTestData.testLargeEnemy(map: map)
        ..coordinate = const EvenQHexCoordinate(1, 1);
      expect(
        map.damageOfPath(
          actor: unit,
          start: unit.coordinate,
          path: [const EvenQHexCoordinate(2, 1)],
        ),
        1,
      );
    });

    test('returns 2 for path with 2 dangerous terrain', () {
      final map = MapModelTestData.testMap(terrain: {
        (2, 1): TerrainType.dangerous,
        (1, 2): TerrainType.dangerous,
      });
      final unit = EnemyModelTestData.testLargeEnemy(map: map)
        ..coordinate = const EvenQHexCoordinate(1, 1);
      expect(
        map.damageOfPath(
          actor: unit,
          start: unit.coordinate,
          path: [
            const EvenQHexCoordinate(2, 1),
            const EvenQHexCoordinate(1, 2)
          ],
        ),
        2,
      );
    });

    test('returns 0 when jumping over dangerous terrain', () {
      final map = MapModelTestData.testMap(terrain: {
        (1, 2): TerrainType.dangerous,
      });
      final unit = EnemyModelTestData.testLargeEnemy(map: map)
        ..coordinate = const EvenQHexCoordinate(1, 1);
      expect(
        map.damageOfPath(
            actor: unit,
            start: unit.coordinate,
            path: [
              const EvenQHexCoordinate(1, 2),
              const EvenQHexCoordinate(1, 3),
              const EvenQHexCoordinate(1, 4),
            ],
            pathType: PathType.jump),
        0,
      );
    });

    test('returns 1 when jumping onto dangerous terrain', () {
      final map = MapModelTestData.testMap(terrain: {
        (1, 2): TerrainType.dangerous,
      });
      final unit = EnemyModelTestData.testLargeEnemy(map: map)
        ..coordinate = const EvenQHexCoordinate(1, 1);
      expect(
        map.damageOfPath(
            actor: unit,
            start: unit.coordinate,
            path: [
              const EvenQHexCoordinate(1, 2),
            ],
            pathType: PathType.jump),
        1,
      );
    });

    test(
        'returns 1 when jumping onto dangerous terrain even if not the last coordinate',
        () {
      final map = MapModelTestData.testMap(terrain: {
        (1, 2): TerrainType.dangerous,
      });
      final unit = EnemyModelTestData.testLargeEnemy(map: map)
        ..coordinate = const EvenQHexCoordinate(1, 1);
      expect(
        map.damageOfPath(
            actor: unit,
            start: unit.coordinate,
            path: [
              const EvenQHexCoordinate(1, 2),
              const EvenQHexCoordinate(1, 3),
            ],
            pathType: PathType.jump),
        1,
      );
    });

    test('returns trap damage when triggering trap', () {
      const trapDamage = 3;
      final map = MapModelTestData.testMap(traps: {
        (1, 2): trapDamage,
      });
      final unit = EnemyModelTestData.testLargeEnemy(map: map)
        ..coordinate = const EvenQHexCoordinate(1, 1);
      expect(
        map.damageOfPath(actor: unit, start: unit.coordinate, path: [
          const EvenQHexCoordinate(1, 2),
        ]),
        trapDamage,
      );
    });

    test('returns trap damage when triggering trap indirectly', () {
      const trapDamage = 3;
      final map = MapModelTestData.testMap(traps: {
        (2, 1): trapDamage,
      });
      final unit = EnemyModelTestData.testLargeEnemy(map: map)
        ..coordinate = const EvenQHexCoordinate(1, 1);
      expect(
        map.damageOfPath(actor: unit, start: unit.coordinate, path: [
          const EvenQHexCoordinate(1, 2),
        ]),
        trapDamage,
      );
    });

    test('returns corresponding damage when triggering 2 traps', () {
      const trapDamage = 3;
      final map = MapModelTestData.testMap(traps: {
        (1, 2): trapDamage,
        (2, 1): trapDamage,
      });
      final unit = EnemyModelTestData.testLargeEnemy(map: map)
        ..coordinate = const EvenQHexCoordinate(1, 1);
      expect(
        map.damageOfPath(actor: unit, start: unit.coordinate, path: [
          const EvenQHexCoordinate(1, 2),
        ]),
        trapDamage * 2,
      );
    });

    test('triggers trap only once', () {
      const trapDamage = 3;
      final map = MapModelTestData.testMap(traps: {
        (1, 2): trapDamage,
      });
      final unit = EnemyModelTestData.testLargeEnemy(map: map)
        ..coordinate = const EvenQHexCoordinate(1, 1);
      expect(
        map.damageOfPath(actor: unit, start: unit.coordinate, path: [
          const EvenQHexCoordinate(1, 2),
          const EvenQHexCoordinate(2, 2),
          const EvenQHexCoordinate(1, 2),
        ]),
        trapDamage,
      );
    });

    test(
        'returns corresponding damage when triggering a trap in dangerous terrain',
        () {
      const trapDamage = 3;
      final map = MapModelTestData.testMap(terrain: {
        (1, 2): TerrainType.dangerous,
      }, traps: {
        (1, 2): trapDamage,
      });
      final unit = EnemyModelTestData.testLargeEnemy(map: map)
        ..coordinate = const EvenQHexCoordinate(1, 1);
      expect(
        map.damageOfPath(actor: unit, start: unit.coordinate, path: [
          const EvenQHexCoordinate(1, 2),
        ]),
        trapDamage + 1,
      );
    });

    test(
        'returns corresponding damage when triggering a trap and dangerous terrain separately',
        () {
      const trapDamage = 3;
      final map = MapModelTestData.testMap(terrain: {
        (1, 2): TerrainType.dangerous,
      }, traps: {
        (1, 3): trapDamage,
      });
      final unit = EnemyModelTestData.testLargeEnemy(map: map)
        ..coordinate = const EvenQHexCoordinate(1, 1);
      expect(
        map.damageOfPath(actor: unit, start: unit.coordinate, path: [
          const EvenQHexCoordinate(1, 2),
          const EvenQHexCoordinate(1, 3),
        ]),
        trapDamage + 1,
      );
    });
  });
}
