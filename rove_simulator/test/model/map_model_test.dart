import 'package:flutter_test/flutter_test.dart';
import 'package:rove_simulator/model/map_model.dart';
import 'package:rove_data_types/rove_data_types.dart';

import '../test_data/map_model_test_data.dart';

void main() {
  group('saveable', () {
    late MapModel map;

    setUp(() {
      map = MapModelTestData.testMap(
          terrain: {(0, 0): TerrainType.object}, enemies: {(0, 1): 'A'});
    });

    test('toSaveData has children', () {
      final data = map.toSaveData();
      expect(data.children, isNotEmpty);
    });
  });
}
