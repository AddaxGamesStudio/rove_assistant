import 'package:rove_simulator/model/map_model.dart';
import 'package:rove_simulator/model/tiles/enemy_model.dart';
import 'package:rove_simulator/model/tiles/enemy_unit_def.dart';
import 'package:hex_grid/hex_grid.dart';
import 'package:rove_data_types/rove_data_types.dart';

import 'map_model_test_data.dart';

extension EnemyModelTestData on EnemyModel {
  static EnemyModel _testEnemy(
      {MapModel? map, bool large = false, bool flies = false}) {
    map ??= MapModelTestData.testMap();
    return EnemyModel(
        enemy: EnemyUnitDef(
            number: 1,
            figureDef: const FigureDef(
                name: 'Test', image: 'test.png', role: FigureRole.adversary),
            encounterFigureDef:
                EncounterFigureDef(name: 'Test', large: large, flies: flies),
            placement: const PlacementDef(name: 'Test')),
        coordinate: HexCoordinate.zero(),
        map: map);
  }

  static EnemyModel testEnemy({MapModel? map}) {
    return _testEnemy(map: map);
  }

  static EnemyModel testLargeEnemy({MapModel? map}) {
    return _testEnemy(map: map, large: true);
  }

  static EnemyModel testFlyingEnemy({MapModel? map}) {
    return _testEnemy(map: map, flies: true);
  }
}
