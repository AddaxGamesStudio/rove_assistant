import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rove_simulator/model/tiles/enemy_class_model.dart';
import 'package:rove_data_types/rove_data_types.dart';

import '../../test_data/encounter_figure_def_test_data.dart';
import 'enemy_class_model_test.mocks.dart';

@GenerateMocks([Random])
void main() {
  group('saveable', () {
    late EnemyClassModel enemyClass;
    late MockRandom random;
    setUp(() {
      random = MockRandom();
      enemyClass = EnemyClassModel(
          EncounterFigureDefTestData.testEncounterFigureDef(),
          random: random);
    });

    test('defaul state', () {
      expect(enemyClass.abilityIndex, 0);
      expect(enemyClass.startedRound, isFalse);
      expect(enemyClass.endedRound, isFalse);
    });

    test('round trip after modifying state', () {
      when(random.nextInt(EnemyClassModel.abilityDiceSides.length))
          .thenReturn(0);
      enemyClass.startRound(2);

      final data = enemyClass.toSaveData();
      final other =
          EnemyClassModel(EncounterFigureDef(name: 'Test'), random: Random());
      other.initializeWithSaveData(data);

      expect(enemyClass.abilityIndex, 1);
      expect(enemyClass.startedRound, isTrue);
      expect(enemyClass.endedRound, isFalse);
    });
  });
}
