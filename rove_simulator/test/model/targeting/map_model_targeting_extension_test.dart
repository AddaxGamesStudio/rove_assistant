import 'package:flutter_test/flutter_test.dart';
import 'package:rove_simulator/model/map_model.dart';
import 'package:rove_simulator/model/targeting/area_of_effect.dart';
import 'package:rove_simulator/model/targeting/map_model_targeting_extension.dart';
import 'package:rove_simulator/model/tiles/unit_model.dart';
import 'package:hex_grid/hex_grid.dart';
import 'package:rove_data_types/rove_data_types.dart';

import '../../test_data/map_model_test_data.dart';

void main() {
  group('occupableCoordinatesAtRangeOfAOE', () {
    late MapModel map;
    late UnitModel actor;

    setUp(() {
      const terrainCoordinate = CubeHexCoordinate(6, 0);
      map = MapModelTestData.testMap(terrain: {
        (terrainCoordinate.toEvenQ().q, terrainCoordinate.toEvenQ().r):
            TerrainType.object
      }, enemies: {
        (1, 2): 'Large'
      });
      actor = map.findUnitWithName('Large #1')!;
    });

    test(
        'returns occupable coordinates to occupy anchor coordinate when AOE has anchor',
        () {
      final aoe = AreaOfEffect(
        definition: AOEDef.x3Line(),
        origin: const CubeHexCoordinate(1, 3),
        anchor: const CubeHexCoordinate(1, 2),
        coordinates: {
          const CubeHexCoordinate(1, 3),
          const CubeHexCoordinate(1, 4),
          const CubeHexCoordinate(1, 5)
        },
      );
      final results = map.occupableCoordinatesAtRangeOfAOE(
          actor: actor, aoe: aoe, range: (1, 1)).toSet();
      expect(results,
          {const CubeHexCoordinate(1, 2), const CubeHexCoordinate(2, 2)});
    });

    test('returns occupable coordinates at range of origin when AOE has origin',
        () {
      final aoe = AreaOfEffect(
        definition: AOEDef.x7Honeycomb(),
        origin: const CubeHexCoordinate(3, 2),
        coordinates: {
          const CubeHexCoordinate(3, 2),
          const CubeHexCoordinate(3, 1),
          const CubeHexCoordinate(4, 1),
          const CubeHexCoordinate(4, 2),
          const CubeHexCoordinate(3, 3),
          const CubeHexCoordinate(2, 3),
          const CubeHexCoordinate(2, 2),
        },
      );
      final results = map.occupableCoordinatesAtRangeOfAOE(
          actor: actor, aoe: aoe, range: (2, 2)).toSet();
      final expectedResults = {
        const CubeHexCoordinate(1, 2),
        const CubeHexCoordinate(1, 5),
        const CubeHexCoordinate(2, 1),
        const CubeHexCoordinate(2, 5),
        const CubeHexCoordinate(3, 0),
        const CubeHexCoordinate(4, 0),
        const CubeHexCoordinate(4, 4),
        const CubeHexCoordinate(3, 5),
        const CubeHexCoordinate(5, 0),
        const CubeHexCoordinate(5, 3),
        // const CubeHexCoordinate(6, 0), // Has object
        // const CubeHexCoordinate(6, 1), // Has object
        const CubeHexCoordinate(6, 2)
      };
      expect(results, containsAll(expectedResults));
      expect(expectedResults, containsAll(results));
    });

    test(
        'returns occupable coordinates at range of the AOE coordinates when no origin',
        () {
      final aoe = AreaOfEffect(
        definition: AOEDef.x3Triangle(),
        coordinates: {
          const CubeHexCoordinate(3, 2),
          const CubeHexCoordinate(4, 1),
          const CubeHexCoordinate(4, 2),
        },
      );
      final results = map.occupableCoordinatesAtRangeOfAOE(
          actor: actor, aoe: aoe, range: (2, 2)).toSet();
      final expectedResults = {
        const CubeHexCoordinate(1, 2),
        const CubeHexCoordinate(1, 5),
        const CubeHexCoordinate(2, 1),
        const CubeHexCoordinate(2, 5),
        const CubeHexCoordinate(3, 0),
        const CubeHexCoordinate(3, 5),
        const CubeHexCoordinate(4, -1),
        const CubeHexCoordinate(5, -1),
        const CubeHexCoordinate(5, 4),
        const CubeHexCoordinate(6, -1),
        const CubeHexCoordinate(6, 3),
      };
      expect(results, containsAll(expectedResults));
      expect(expectedResults, containsAll(results));
    });
  });
}
