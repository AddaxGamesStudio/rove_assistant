import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rove_simulator/model/targeting/target_data.dart';
import 'package:rove_simulator/model/tiles/unit_model.dart';
import 'package:hex_grid/hex_grid.dart';

import '../../test_data/enemy_model_test_data.dart';
import '../../test_data/map_model_test_data.dart';
import 'target_data_test.mocks.dart';

@GenerateMocks([UnitModel])
void main() {
  late MockUnitModel mockTarget;
  late MockUnitModel mockActor;

  setUp(() {
    mockTarget = MockUnitModel();
    mockActor = MockUnitModel();
  });

  group('TargetData', () {
    test('untargetable factory', () {
      final data = TargetData.untargetable(mockTarget);

      expect(data.sortedCoordinates, isEmpty);
      expect(data.targetable, isFalse);
      expect(data.aoe, isNull);
      expect(data.minimumMoveEffort, 0);
      expect(data.lowestEffortCoordinate, isNull);
    });

    test('withoutMoving factory', () {
      final actorCoordinate = HexCoordinate.zero();
      when(mockActor.coordinate).thenReturn(actorCoordinate);
      final data =
          TargetData.withoutMoving(target: mockTarget, actor: mockActor);

      expect(data.sortedCoordinates, [(actorCoordinate, 0)]);
      expect(data.targetable, isTrue);
      expect(data.aoe, isNull);
      expect(data.minimumMoveEffort, 0);
      expect(data.lowestEffortCoordinate, actorCoordinate);
    });

    test('fromCoordinates factory when coordinates is not empty', () {
      final coordinatesWithEffort = [
        (const EvenQHexCoordinate(1, 0), 3),
        (const EvenQHexCoordinate(2, 0), 2),
        (const EvenQHexCoordinate(3, 0), 1),
      ];
      final data = TargetData.fromCoordinates(
          target: mockTarget, coordinatesWithEffort: coordinatesWithEffort);

      expect(data.sortedCoordinates, [
        (const EvenQHexCoordinate(3, 0), 1),
        (const EvenQHexCoordinate(2, 0), 2),
        (const EvenQHexCoordinate(1, 0), 3),
      ]);
      expect(data.targetable, isTrue);
      expect(data.aoe, isNull);
      expect(data.minimumMoveEffort, 1);
      expect(data.lowestEffortCoordinate, const EvenQHexCoordinate(3, 0));
    });
  });

  test('fromCoordinates factory when coordinates is empty', () {
    final data = TargetData.fromCoordinates(
        target: mockTarget, coordinatesWithEffort: const []);

    expect(data.sortedCoordinates, isEmpty);
    expect(data.targetable, isFalse);
    expect(data.aoe, isNull);
    expect(data.minimumMoveEffort, 0);
    expect(data.lowestEffortCoordinate, isNull);
  });

  test(
      'findMostTargetsLeastEffortCoordinate returns the most targets coordinate',
      () {
    final map = MapModelTestData.testMap();
    final target1 = EnemyModelTestData.testEnemy(map: map);
    final target2 = EnemyModelTestData.testEnemy(map: map);
    final data = [
      TargetData.fromCoordinates(target: target1, coordinatesWithEffort: const [
        (EvenQHexCoordinate(1, 0), 3),
        (EvenQHexCoordinate(3, 0), 1),
      ]),
      TargetData.fromCoordinates(target: target2, coordinatesWithEffort: const [
        (EvenQHexCoordinate(1, 0), 3),
        (EvenQHexCoordinate(2, 0), 1),
      ])
    ];
    final result = TargetData.findMostTargetsCoordinate(data);
    expect(result.$1, const EvenQHexCoordinate(1, 0));
    expect(result.$2, isNull);
    expect(result.$3, containsAll([target1, target2]));
    expect([target1, target2], containsAll(result.$3));
  });

  test(
      'findMostTargetsLeastEffortCoordinate returns the most targets coordinate with least effort',
      () {
    final map = MapModelTestData.testMap();
    final target1 = EnemyModelTestData.testEnemy(map: map);
    final target2 = EnemyModelTestData.testEnemy(map: map);
    final data = [
      TargetData.fromCoordinates(target: target1, coordinatesWithEffort: const [
        (EvenQHexCoordinate(1, 0), 3),
        (EvenQHexCoordinate(2, 0), 2),
        (EvenQHexCoordinate(3, 0), 1),
      ]),
      TargetData.fromCoordinates(target: target2, coordinatesWithEffort: const [
        (EvenQHexCoordinate(1, 0), 3),
        (EvenQHexCoordinate(2, 0), 2),
        (EvenQHexCoordinate(3, 0), 1),
      ])
    ];
    final result = TargetData.findMostTargetsCoordinate(data);
    expect(result.$1, const EvenQHexCoordinate(3, 0));
    expect(result.$2, isNull);
    expect(result.$3, containsAll([target1, target2]));
    expect([target1, target2], containsAll(result.$3));
  });

  test(
      'findMostTargetsLeastEffortCoordinate returns the most targets coordinate when there are duplicates',
      () {
    final map = MapModelTestData.testMap();
    final target1 = EnemyModelTestData.testEnemy(map: map);
    final target2 = EnemyModelTestData.testEnemy(map: map);
    final data = [
      TargetData.fromCoordinates(target: target1, coordinatesWithEffort: const [
        (EvenQHexCoordinate(1, 0), 3),
        (EvenQHexCoordinate(2, 0), 2),
        (EvenQHexCoordinate(3, 0), 1),
      ]),
      TargetData.fromCoordinates(target: target1, coordinatesWithEffort: const [
        (EvenQHexCoordinate(1, 0), 3),
        (EvenQHexCoordinate(2, 0), 2),
        (EvenQHexCoordinate(3, 0), 1),
      ]),
      TargetData.fromCoordinates(target: target1, coordinatesWithEffort: const [
        (EvenQHexCoordinate(1, 0), 3),
        (EvenQHexCoordinate(2, 0), 2),
        (EvenQHexCoordinate(3, 0), 1),
      ]),
      TargetData.fromCoordinates(target: target2, coordinatesWithEffort: const [
        (EvenQHexCoordinate(2, 0), 2),
      ])
    ];
    final result = TargetData.findMostTargetsCoordinate(data);
    expect(result.$1, const EvenQHexCoordinate(2, 0));
    expect(result.$2, isNull);
    expect(result.$3, containsAll([target1, target2]));
    expect([target1, target2], containsAll(result.$3));
  });
}
