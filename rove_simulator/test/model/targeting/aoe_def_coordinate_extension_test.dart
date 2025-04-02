import 'package:flutter_test/flutter_test.dart';
import 'package:rove_simulator/model/targeting/aoe_def_coordinate_extension.dart';
import 'package:rove_simulator/model/targeting/area_of_effect.dart';
import 'package:hex_grid/hex_grid.dart';
import 'package:rove_data_types/rove_data_types.dart';

import '../../test_data/enemy_model_test_data.dart';

void main() {
  group('rotatedCoordinates', () {
    test('returns expected when origin is at range 1 and rotation ticks is 0',
        () {
      final aoeDef = AOEDef.x3Line();
      final coordinates = aoeDef.rotatedCoordinates(
          center: HexCoordinate.zero().toCube(),
          anchor: const CubeHexCoordinate(0, -1));
      expect(coordinates.toSet(), {
        const CubeHexCoordinate(0, -1),
        const CubeHexCoordinate(0, -2),
        const CubeHexCoordinate(0, -3),
      });
    });
    test('returns expected when origin is at range 1 and rotation ticks is 1',
        () {
      final aoeDef = AOEDef.x3Line();
      final coordinates = aoeDef.rotatedCoordinates(
          center: HexCoordinate.zero().toCube(),
          anchor: const CubeHexCoordinate(1, -1));
      expect(coordinates.toSet(), {
        const CubeHexCoordinate(1, -1),
        const CubeHexCoordinate(2, -2),
        const CubeHexCoordinate(3, -3),
      });
    });

    test('returns expected when origin is at range 1 and rotation ticks is 2',
        () {
      final aoeDef = AOEDef.x3Line();
      final coordinates = aoeDef.rotatedCoordinates(
          center: HexCoordinate.zero().toCube(),
          anchor: const CubeHexCoordinate(1, 0));
      expect(coordinates.toSet(), {
        const CubeHexCoordinate(1, 0),
        const CubeHexCoordinate(2, 0),
        const CubeHexCoordinate(3, 0),
      });
    });

    test('returns expected when origin is at range 1 and rotation ticks is 3',
        () {
      final aoeDef = AOEDef.x3Line();
      final coordinates = aoeDef.rotatedCoordinates(
          center: HexCoordinate.zero().toCube(),
          anchor: const CubeHexCoordinate(0, -1));
      expect(coordinates.toSet(), {
        const CubeHexCoordinate(0, -1),
        const CubeHexCoordinate(0, -2),
        const CubeHexCoordinate(0, -3),
      });
    });

    test('returns expected when origin is at range 1 and rotation ticks is 4',
        () {
      final aoeDef = AOEDef.x3Line();
      final coordinates = aoeDef.rotatedCoordinates(
          center: HexCoordinate.zero().toCube(),
          anchor: const CubeHexCoordinate(-1, 1));
      expect(coordinates.toSet(), {
        const CubeHexCoordinate(-1, 1),
        const CubeHexCoordinate(-2, 2),
        const CubeHexCoordinate(-3, 3),
      });
    });

    test('returns expected when origin is at range 1 and rotation ticks is 5',
        () {
      final aoeDef = AOEDef.x3Line();
      final coordinates = aoeDef.rotatedCoordinates(
          center: HexCoordinate.zero().toCube(),
          anchor: const CubeHexCoordinate(-1, 0));
      expect(coordinates.toSet(), {
        const CubeHexCoordinate(-1, 0),
        const CubeHexCoordinate(-2, 0),
        const CubeHexCoordinate(-3, 0),
      });
    });

    test('returns no rotation when exact rotation is not possible', () {
      final aoeDef = AOEDef.x3Line();
      final coordinates = aoeDef.rotatedCoordinates(
          center: HexCoordinate.zero().toCube(),
          anchor: const CubeHexCoordinate(2, -1));
      expect(coordinates, {
        const CubeHexCoordinate(2, -1),
        const CubeHexCoordinate(2, -2),
        const CubeHexCoordinate(2, -3),
      });
    });

    test('returns without rotation when center is origin', () {
      final aoeDef = AOEDef.x3Line();
      final coordinates = aoeDef.rotatedCoordinates(
          center: HexCoordinate.zero().toCube(),
          anchor: HexCoordinate.zero().toCube());
      expect(coordinates.toSet(), {
        const CubeHexCoordinate(0, 0),
        const CubeHexCoordinate(0, -1),
        const CubeHexCoordinate(0, -2),
      });
    });

    test('returns expected when origin is at range 2 and rotation ticks is 1',
        () {
      final aoeDef = AOEDef.x3Line();
      final coordinates = aoeDef.rotatedCoordinates(
          center: HexCoordinate.zero().toCube(),
          anchor: const CubeHexCoordinate(2, -2));
      expect(coordinates.toSet(), {
        const CubeHexCoordinate(2, -2),
        const CubeHexCoordinate(3, -3),
        const CubeHexCoordinate(4, -4),
      });
    });

    test('returns expected when origin is at range 3 and rotation ticks is 1',
        () {
      final aoeDef = AOEDef.x3Line();
      final coordinates = aoeDef.rotatedCoordinates(
          center: HexCoordinate.zero().toCube(),
          anchor: const CubeHexCoordinate(3, -3));
      expect(coordinates.toSet(), {
        const CubeHexCoordinate(3, -3),
        const CubeHexCoordinate(4, -4),
        const CubeHexCoordinate(5, -5),
      });
    });

    test(
        'returns expected when center is not zero, origin is at range 3 and rotation ticks is 2',
        () {
      final aoeDef = AOEDef.x3Line();
      final coordinates = aoeDef.rotatedCoordinates(
          center: const CubeHexCoordinate(2, 0),
          anchor: const CubeHexCoordinate(5, 0));
      expect(coordinates.toSet(), {
        const CubeHexCoordinate(5, 0),
        const CubeHexCoordinate(6, 0),
        const CubeHexCoordinate(7, 0),
      });
    });

    test(
        'returns expected when origin is at range 3 but not in a straight line and rotation ticks is 5',
        () {
      final aoeDef = AOEDef.x3Line();
      final coordinates = aoeDef.rotatedCoordinates(
          center: HexCoordinate.zero().toCube(),
          anchor: const CubeHexCoordinate(-1, -2));
      expect(coordinates.toSet(), {
        const CubeHexCoordinate(-1, -2),
        const CubeHexCoordinate(-1, -3),
        const CubeHexCoordinate(-1, -4),
      });
    });
  });

  group('matchingTarget', () {
    test('returns the coordinate of a single hex target when using x1Hex AOE',
        () {
      final aoeDef = AOEDef.x1Hex();
      final target = EnemyModelTestData.testEnemy();
      target.coordinate = const CubeHexCoordinate(2, 0);
      final results = aoeDef.matchingTarget(target);
      expect(results, {
        AreaOfEffect(
            definition: aoeDef,
            origin: target.coordinate.toCube(),
            coordinates: {target.coordinate})
      });
    });

    test('returns all coordinates of a large enemy target when using x1Hex AOE',
        () {
      final aoeDef = AOEDef.x1Hex();
      final target = EnemyModelTestData.testLargeEnemy();
      target.coordinate = const CubeHexCoordinate(2, 0);
      final results = aoeDef.matchingTarget(target);
      final expectedResults = target.coordinates
          .map((c) => AreaOfEffect(
              definition: aoeDef, origin: c.toCube(), coordinates: {c}))
          .toSet();

      expect(results, expectedResults);
    });

    test('returns the corresponding coordinates for relative to actor aoe', () {
      final aoeDef = AOEDef.x3Line();
      final target = EnemyModelTestData.testEnemy();
      target.coordinate = const CubeHexCoordinate(2, 0);
      final results = aoeDef.matchingTarget(target);
      final expectedResults = {
        AreaOfEffect(
            definition: aoeDef,
            anchor: const CubeHexCoordinate(2, 1),
            origin: const CubeHexCoordinate(2, 0),
            coordinates: {
              const CubeHexCoordinate(2, 0),
              const CubeHexCoordinate(2, -1),
              const CubeHexCoordinate(2, -2),
            }),
        AreaOfEffect(
            definition: aoeDef,
            anchor: const CubeHexCoordinate(2, 2),
            origin: const CubeHexCoordinate(2, 1),
            coordinates: {
              const CubeHexCoordinate(2, 1),
              const CubeHexCoordinate(2, 0),
              const CubeHexCoordinate(2, -1),
            }),
        AreaOfEffect(
            definition: aoeDef,
            anchor: const CubeHexCoordinate(2, 3),
            origin: const CubeHexCoordinate(2, 2),
            coordinates: {
              const CubeHexCoordinate(2, 2),
              const CubeHexCoordinate(2, 1),
              const CubeHexCoordinate(2, 0),
            }),
        AreaOfEffect(
            definition: aoeDef,
            anchor: const CubeHexCoordinate(1, 1),
            origin: const CubeHexCoordinate(2, 0),
            coordinates: {
              const CubeHexCoordinate(2, 0),
              const CubeHexCoordinate(3, -1),
              const CubeHexCoordinate(4, -2),
            }),
        AreaOfEffect(
            definition: aoeDef,
            anchor: const CubeHexCoordinate(0, 2),
            origin: const CubeHexCoordinate(1, 1),
            coordinates: {
              const CubeHexCoordinate(1, 1),
              const CubeHexCoordinate(2, 0),
              const CubeHexCoordinate(3, -1),
            }),
        AreaOfEffect(
            definition: aoeDef,
            anchor: const CubeHexCoordinate(-1, 3),
            origin: const CubeHexCoordinate(0, 2),
            coordinates: {
              const CubeHexCoordinate(0, 2),
              const CubeHexCoordinate(1, 1),
              const CubeHexCoordinate(2, 0),
            }),
        AreaOfEffect(
            definition: aoeDef,
            anchor: const CubeHexCoordinate(1, 0),
            origin: const CubeHexCoordinate(2, 0),
            coordinates: {
              const CubeHexCoordinate(2, 0),
              const CubeHexCoordinate(3, 0),
              const CubeHexCoordinate(4, 0),
            }),
        AreaOfEffect(
            definition: aoeDef,
            anchor: const CubeHexCoordinate(0, 0),
            origin: const CubeHexCoordinate(1, 0),
            coordinates: {
              const CubeHexCoordinate(1, 0),
              const CubeHexCoordinate(2, 0),
              const CubeHexCoordinate(3, 0),
            }),
        AreaOfEffect(
            definition: aoeDef,
            anchor: const CubeHexCoordinate(-1, 0),
            origin: const CubeHexCoordinate(0, 0),
            coordinates: {
              const CubeHexCoordinate(0, 0),
              const CubeHexCoordinate(1, 0),
              const CubeHexCoordinate(2, 0),
            }),
        AreaOfEffect(
            definition: aoeDef,
            anchor: const CubeHexCoordinate(2, -1),
            origin: const CubeHexCoordinate(2, 0),
            coordinates: {
              const CubeHexCoordinate(2, 0),
              const CubeHexCoordinate(2, 1),
              const CubeHexCoordinate(2, 2),
            }),
        AreaOfEffect(
            definition: aoeDef,
            anchor: const CubeHexCoordinate(2, -2),
            origin: const CubeHexCoordinate(2, -1),
            coordinates: {
              const CubeHexCoordinate(2, -1),
              const CubeHexCoordinate(2, 0),
              const CubeHexCoordinate(2, 1),
            }),
        AreaOfEffect(
            definition: aoeDef,
            anchor: const CubeHexCoordinate(2, -3),
            origin: const CubeHexCoordinate(2, -2),
            coordinates: {
              const CubeHexCoordinate(2, -2),
              const CubeHexCoordinate(2, -1),
              const CubeHexCoordinate(2, 0),
            }),
        AreaOfEffect(
            definition: aoeDef,
            anchor: const CubeHexCoordinate(3, -1),
            origin: const CubeHexCoordinate(2, 0),
            coordinates: {
              const CubeHexCoordinate(2, 0),
              const CubeHexCoordinate(1, 1),
              const CubeHexCoordinate(0, 2),
            }),
        AreaOfEffect(
            definition: aoeDef,
            anchor: const CubeHexCoordinate(4, -2),
            origin: const CubeHexCoordinate(3, -1),
            coordinates: {
              const CubeHexCoordinate(3, -1),
              const CubeHexCoordinate(2, 0),
              const CubeHexCoordinate(1, 1),
            }),
        AreaOfEffect(
            definition: aoeDef,
            anchor: const CubeHexCoordinate(5, -3),
            origin: const CubeHexCoordinate(4, -2),
            coordinates: {
              const CubeHexCoordinate(4, -2),
              const CubeHexCoordinate(3, -1),
              const CubeHexCoordinate(2, 0),
            }),
        AreaOfEffect(
            definition: aoeDef,
            anchor: const CubeHexCoordinate(3, 0),
            origin: const CubeHexCoordinate(2, 0),
            coordinates: {
              const CubeHexCoordinate(2, 0),
              const CubeHexCoordinate(1, 0),
              const CubeHexCoordinate(0, 0),
            }),
        AreaOfEffect(
            definition: aoeDef,
            anchor: const CubeHexCoordinate(4, 0),
            origin: const CubeHexCoordinate(3, 0),
            coordinates: {
              const CubeHexCoordinate(3, 0),
              const CubeHexCoordinate(2, 0),
              const CubeHexCoordinate(1, 0),
            }),
        AreaOfEffect(
            definition: aoeDef,
            anchor: const CubeHexCoordinate(5, 0),
            origin: const CubeHexCoordinate(4, 0),
            coordinates: {
              const CubeHexCoordinate(4, 0),
              const CubeHexCoordinate(3, 0),
              const CubeHexCoordinate(2, 0),
            }),
      };
      expect(results, expectedResults);
    });

    test('returns the corresponding coordinates for equidistant aoe', () {
      final aoeDef = AOEDef.x3Triangle();
      final target = EnemyModelTestData.testEnemy();
      target.coordinate = const CubeHexCoordinate(2, 0);
      final results = aoeDef.matchingTarget(target);
      expect(results, {
        AreaOfEffect(definition: aoeDef, coordinates: {
          const CubeHexCoordinate(2, 0),
          const CubeHexCoordinate(2, -1),
          const CubeHexCoordinate(3, -1),
        }),
        AreaOfEffect(definition: aoeDef, coordinates: {
          const CubeHexCoordinate(2, 0),
          const CubeHexCoordinate(3, -1),
          const CubeHexCoordinate(3, 0),
        }),
        AreaOfEffect(definition: aoeDef, coordinates: {
          const CubeHexCoordinate(2, 0),
          const CubeHexCoordinate(3, 0),
          const CubeHexCoordinate(2, 1),
        }),
        AreaOfEffect(definition: aoeDef, coordinates: {
          const CubeHexCoordinate(2, 0),
          const CubeHexCoordinate(2, 1),
          const CubeHexCoordinate(1, 1),
        }),
        AreaOfEffect(definition: aoeDef, coordinates: {
          const CubeHexCoordinate(2, 0),
          const CubeHexCoordinate(1, 1),
          const CubeHexCoordinate(1, 0),
        }),
        AreaOfEffect(definition: aoeDef, coordinates: {
          const CubeHexCoordinate(2, 0),
          const CubeHexCoordinate(1, 0),
          const CubeHexCoordinate(2, -1),
        })
      });
    });

    test('returns the corresponding coordinates for equidistant aoe', () {
      final aoeDef = AOEDef.x3Triangle();
      final target = EnemyModelTestData.testEnemy();
      target.coordinate = const CubeHexCoordinate(2, 0);
      final results = aoeDef.matchingTarget(target);
      expect(results, {
        AreaOfEffect(definition: aoeDef, coordinates: {
          const CubeHexCoordinate(2, 0),
          const CubeHexCoordinate(2, -1),
          const CubeHexCoordinate(3, -1),
        }),
        AreaOfEffect(definition: aoeDef, coordinates: {
          const CubeHexCoordinate(2, 0),
          const CubeHexCoordinate(3, -1),
          const CubeHexCoordinate(3, 0),
        }),
        AreaOfEffect(definition: aoeDef, coordinates: {
          const CubeHexCoordinate(2, 0),
          const CubeHexCoordinate(3, 0),
          const CubeHexCoordinate(2, 1),
        }),
        AreaOfEffect(definition: aoeDef, coordinates: {
          const CubeHexCoordinate(2, 0),
          const CubeHexCoordinate(2, 1),
          const CubeHexCoordinate(1, 1),
        }),
        AreaOfEffect(definition: aoeDef, coordinates: {
          const CubeHexCoordinate(2, 0),
          const CubeHexCoordinate(1, 1),
          const CubeHexCoordinate(1, 0),
        }),
        AreaOfEffect(definition: aoeDef, coordinates: {
          const CubeHexCoordinate(2, 0),
          const CubeHexCoordinate(1, 0),
          const CubeHexCoordinate(2, -1),
        })
      });
    });

    test('returns the corresponding coordinates for radially symetrical aoe',
        () {
      final aoeDef = AOEDef.x7Honeycomb();
      final target = EnemyModelTestData.testEnemy();
      target.coordinate = const CubeHexCoordinate(2, 0);
      final results = aoeDef.matchingTarget(target);
      expect(results, {
        AreaOfEffect(
            definition: aoeDef,
            origin: const CubeHexCoordinate(2, 0),
            coordinates: {
              const CubeHexCoordinate(2, 0),
              const CubeHexCoordinate(2, -1),
              const CubeHexCoordinate(3, -1),
              const CubeHexCoordinate(3, 0),
              const CubeHexCoordinate(2, 1),
              const CubeHexCoordinate(1, 1),
              const CubeHexCoordinate(1, 0),
            }),
        AreaOfEffect(
            definition: aoeDef,
            origin: const CubeHexCoordinate(2, -1),
            coordinates: {
              const CubeHexCoordinate(2, -1),
              const CubeHexCoordinate(2, -2),
              const CubeHexCoordinate(3, -2),
              const CubeHexCoordinate(3, -1),
              const CubeHexCoordinate(2, 0),
              const CubeHexCoordinate(1, 0),
              const CubeHexCoordinate(1, -1),
            }),
        AreaOfEffect(
            definition: aoeDef,
            origin: const CubeHexCoordinate(3, -1),
            coordinates: {
              const CubeHexCoordinate(3, -1),
              const CubeHexCoordinate(3, -2),
              const CubeHexCoordinate(4, -2),
              const CubeHexCoordinate(4, -1),
              const CubeHexCoordinate(3, 0),
              const CubeHexCoordinate(2, 0),
              const CubeHexCoordinate(2, -1),
            }),
        AreaOfEffect(
            definition: aoeDef,
            origin: const CubeHexCoordinate(3, 0),
            coordinates: {
              const CubeHexCoordinate(3, 0),
              const CubeHexCoordinate(3, -1),
              const CubeHexCoordinate(4, -1),
              const CubeHexCoordinate(4, 0),
              const CubeHexCoordinate(3, 1),
              const CubeHexCoordinate(2, 1),
              const CubeHexCoordinate(2, 0),
            }),
        AreaOfEffect(
            definition: aoeDef,
            origin: const CubeHexCoordinate(2, 1),
            coordinates: {
              const CubeHexCoordinate(2, 1),
              const CubeHexCoordinate(2, 0),
              const CubeHexCoordinate(3, 0),
              const CubeHexCoordinate(3, 1),
              const CubeHexCoordinate(2, 2),
              const CubeHexCoordinate(1, 2),
              const CubeHexCoordinate(1, 1),
            }),
        AreaOfEffect(
            definition: aoeDef,
            origin: const CubeHexCoordinate(1, 1),
            coordinates: {
              const CubeHexCoordinate(1, 1),
              const CubeHexCoordinate(1, 0),
              const CubeHexCoordinate(2, 0),
              const CubeHexCoordinate(2, 1),
              const CubeHexCoordinate(1, 2),
              const CubeHexCoordinate(0, 2),
              const CubeHexCoordinate(0, 1),
            }),
        AreaOfEffect(
            definition: aoeDef,
            origin: const CubeHexCoordinate(1, 0),
            coordinates: {
              const CubeHexCoordinate(1, 0),
              const CubeHexCoordinate(1, -1),
              const CubeHexCoordinate(2, -1),
              const CubeHexCoordinate(2, 0),
              const CubeHexCoordinate(1, 1),
              const CubeHexCoordinate(0, 1),
              const CubeHexCoordinate(0, 0),
            }),
      });
    });
  });
}
