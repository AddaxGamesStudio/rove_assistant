import 'package:flutter_test/flutter_test.dart';
import 'package:rove_simulator/controller/enemy_actions/enemy_retreat_resolver.dart';
import 'package:hex_grid/hex_grid.dart';
import 'package:rove_data_types/rove_data_types.dart';

import '../../test_data/map_model_test_data.dart';

void main() {
  group('MapModel.farthestCoordinateFromTargets single-hex unit', () {
    test(
        'returns the coordinate farthest from the target when only one option available',
        () {
      final map = MapModelTestData.testMap(terrain: {
        (1, 0): TerrainType.object,
        (1, 1): TerrainType.object,
        (1, 2): TerrainType.object
      }, enemies: {
        (0, 0): 'Target',
        (0, 1): 'Actor'
      });
      final actor = map.findUnitWithName('Actor #1')!;
      final targets =
          map.units.values.where((u) => u.className == 'Target').toList();

      expect(
          map.farthestCoordinateFromTargets(
              actor: actor,
              targets: targets,
              movementAction: RoveAction.move(1)),
          const EvenQHexCoordinate(0, 2));
    });
    test(
        'returns the coordinate farthest from the target when multiple options available',
        () {
      final map = MapModelTestData.testMap(terrain: {
        (2, 2): TerrainType.object,
      }, enemies: {
        (0, 0): 'Target',
        (1, 1): 'Actor'
      });
      final actor = map.findUnitWithName('Actor #1')!;
      final targets =
          map.units.values.where((u) => u.className == 'Target').toList();

      expect(
          map.farthestCoordinateFromTargets(
              actor: actor,
              targets: targets,
              movementAction: RoveAction.move(1)),
          const EvenQHexCoordinate(1, 2));
    });

    test(
        'returns the actor\'s coordinate when no option moves away from the target',
        () {
      final map = MapModelTestData.testMap(terrain: {
        (2, 0): TerrainType.object,
        (2, 1): TerrainType.object,
        (1, 2): TerrainType.object,
      }, enemies: {
        (0, 0): 'Target',
        (1, 1): 'Actor'
      });
      final actor = map.findUnitWithName('Actor #1')!;
      final targets =
          map.units.values.where((u) => u.className == 'Target').toList();

      expect(
          map.farthestCoordinateFromTargets(
              actor: actor,
              targets: targets,
              movementAction: RoveAction.move(1)),
          const EvenQHexCoordinate(1, 1));
    });

    test('returns the coordinate farthest to the targets when moving 1', () {
      final map = MapModelTestData.testMap(
          enemies: {(0, 0): 'Target', (2, 0): 'Target', (1, 1): 'Actor'});
      final actor = map.findUnitWithName('Actor #1')!;
      final targets =
          map.units.values.where((u) => u.className == 'Target').toList();

      expect(
          map.farthestCoordinateFromTargets(
              actor: actor,
              targets: targets,
              movementAction: RoveAction.move(1)),
          const EvenQHexCoordinate(1, 2));
    });
    test('returns the coordinate farthest to the targets when moving 2', () {
      final map = MapModelTestData.testMap(
          enemies: {(0, 0): 'Target', (2, 0): 'Target', (1, 1): 'Actor'});
      final actor = map.findUnitWithName('Actor #1')!;
      final targets =
          map.units.values.where((u) => u.className == 'Target').toList();

      expect(
          map
              .farthestCoordinateFromTargets(
                  actor: actor,
                  targets: targets,
                  movementAction: RoveAction.move(2))
              .toEvenQ(),
          const EvenQHexCoordinate(1, 3));
    });

    test('returns the coordinate farthest from the target with least effort',
        () {
      final map = MapModelTestData.testMap(terrain: {
        (2, 0): TerrainType.dangerous,
        (1, 2): TerrainType.dangerous,
      }, enemies: {
        (0, 0): 'Target',
        (1, 1): 'Actor'
      });
      final actor = map.findUnitWithName('Actor #1')!;
      final targets =
          map.units.values.where((u) => u.className == 'Target').toList();

      expect(
          map
              .farthestCoordinateFromTargets(
                  actor: actor,
                  targets: targets,
                  movementAction: RoveAction.move(1))
              .toEvenQ(),
          const EvenQHexCoordinate(2, 1));
    });
  });

  group('MapModel.farthestCoordinateFromTargets large unit', () {
    test('returns the coordinate farthest from the target', () {
      final map = MapModelTestData.testMap(
          terrain: {(3, 2): TerrainType.object},
          enemies: {(0, 0): 'Target', (1, 2): 'Large'});
      final actor = map.findUnitWithName('Large #1')!;
      final targets =
          map.units.values.where((u) => u.className == 'Target').toList();

      expect(
          map.farthestCoordinateFromTargets(
              actor: actor,
              targets: targets,
              movementAction: RoveAction.move(1)),
          const EvenQHexCoordinate(1, 3));
    });
    test('returns the coordinate farthest from the targets when moving 1', () {
      final map = MapModelTestData.testMap(
          enemies: {(0, 0): 'Target', (2, 0): 'Target', (1, 2): 'Large'});
      final actor = map.findUnitWithName('Large #1')!;
      final targets =
          map.units.values.where((u) => u.className == 'Target').toList();

      expect(
          map.farthestCoordinateFromTargets(
              actor: actor,
              targets: targets,
              movementAction: RoveAction.move(1)),
          const EvenQHexCoordinate(1, 3));
    });

    test('returns the coordinate farthest from the targets when moving 2', () {
      final map = MapModelTestData.testMap(
          enemies: {(0, 0): 'Target', (2, 0): 'Target', (1, 2): 'Large'});
      final actor = map.findUnitWithName('Large #1')!;
      final targets =
          map.units.values.where((u) => u.className == 'Target').toList();

      expect(
          map.farthestCoordinateFromTargets(
              actor: actor,
              targets: targets,
              movementAction: RoveAction.move(2)),
          const EvenQHexCoordinate(1, 4));
    });
  });
}
