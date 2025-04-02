import 'package:flutter_test/flutter_test.dart';
import 'package:rove_simulator/model/targeting/area_of_effect.dart';
import 'package:hex_grid/hex_grid.dart';
import 'package:rove_data_types/rove_data_types.dart';

import '../../test_data/enemy_model_test_data.dart';

void main() {
  group('distanceToAOE of large enemies', () {
    test('returns minimum distance when not overlapping', () {
      final enemy = EnemyModelTestData.testLargeEnemy();
      enemy.coordinate = const CubeHexCoordinate(0, 1);

      final aoe = AreaOfEffect(
        definition: AOEDef.x3Triangle(),
        coordinates: {
          const CubeHexCoordinate(0, 2),
          const CubeHexCoordinate(1, 2),
          const CubeHexCoordinate(0, 3)
        },
      );

      expect(enemy.distanceToAOE(aoe), equals(1));
    });

    test('returns zero when overlapping', () {
      final enemy = EnemyModelTestData.testLargeEnemy();
      enemy.coordinate = const CubeHexCoordinate(0, 2);

      final aoe = AreaOfEffect(
        definition: AOEDef.x3Triangle(),
        coordinates: {
          const CubeHexCoordinate(0, 2),
          const CubeHexCoordinate(1, 2),
          const CubeHexCoordinate(0, 3)
        },
      );

      expect(enemy.distanceToAOE(aoe), equals(0));
    });
  });
}
