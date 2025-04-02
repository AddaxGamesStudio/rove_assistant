import 'package:flutter_test/flutter_test.dart';
import 'package:rove_simulator/model/targeting/area_of_effect.dart';
import 'package:hex_grid/hex_grid.dart';
import 'package:rove_data_types/rove_data_types.dart';

void main() {
  group('AreaOfEffect', () {
    test('equality returns false when not equal', () {
      final a = AreaOfEffect(
        definition: AOEDef.x3Line(),
        origin: const CubeHexCoordinate(0, 0),
        anchor: const CubeHexCoordinate(-1, 0),
        coordinates: {
          const CubeHexCoordinate(0, 0),
          const CubeHexCoordinate(1, 0),
          const CubeHexCoordinate(2, 0)
        },
      );
      final b = AreaOfEffect(
        definition: AOEDef.x3Line(),
        origin: const CubeHexCoordinate(1, 0),
        anchor: const CubeHexCoordinate(0, 0),
        coordinates: {
          const CubeHexCoordinate(1, 0),
          const CubeHexCoordinate(2, 0),
          const CubeHexCoordinate(3, 0)
        },
      );
      expect(a == b, isFalse);
    });

    test('equality returns true when equal', () {
      final a = AreaOfEffect(
        definition: AOEDef.x3Line(),
        origin: const CubeHexCoordinate(0, 0),
        anchor: const CubeHexCoordinate(-1, 0),
        coordinates: {
          const CubeHexCoordinate(0, 0),
          const CubeHexCoordinate(1, 0),
          const CubeHexCoordinate(2, 0)
        },
      );
      final b = AreaOfEffect(
        definition: AOEDef.x3Line(),
        origin: const CubeHexCoordinate(0, 0),
        anchor: const CubeHexCoordinate(-1, 0),
        coordinates: {
          const CubeHexCoordinate(0, 0),
          const CubeHexCoordinate(1, 0),
          const CubeHexCoordinate(2, 0)
        },
      );
      expect(a == b, isTrue);
    });

    test('hashCode is the same when equal', () {
      final a = AreaOfEffect(
        definition: AOEDef.x3Line(),
        origin: const CubeHexCoordinate(0, 0),
        anchor: const CubeHexCoordinate(-1, 0),
        coordinates: {
          const CubeHexCoordinate(0, 0),
          const CubeHexCoordinate(1, 0),
          const CubeHexCoordinate(2, 0)
        },
      );
      final b = AreaOfEffect(
        definition: AOEDef.x3Line(),
        origin: const CubeHexCoordinate(0, 0),
        anchor: const CubeHexCoordinate(-1, 0),
        coordinates: {
          const CubeHexCoordinate(0, 0),
          const CubeHexCoordinate(1, 0),
          const CubeHexCoordinate(2, 0)
        },
      );

      expect(a == b, isTrue);
      expect(a.hashCode, equals(b.hashCode));
    });

    test('distanceToCoordinate returns distance from origin when set', () {
      final aoe = AreaOfEffect(
        definition: AOEDef.x3Line(),
        origin: const CubeHexCoordinate(0, 0),
        anchor: const CubeHexCoordinate(-1, 0),
        coordinates: {
          const CubeHexCoordinate(0, 0),
          const CubeHexCoordinate(1, 0),
          const CubeHexCoordinate(2, 0)
        },
      );

      expect(
          aoe.distanceToCoordinate(const CubeHexCoordinate(2, 0)), equals(2));
    });

    test(
        'distanceToCoordinate returns minimum distance to coordinates when origin is not set',
        () {
      final aoe = AreaOfEffect(
        definition: AOEDef.x3Triangle(),
        coordinates: {
          const CubeHexCoordinate(0, 0),
          const CubeHexCoordinate(1, 0),
          const CubeHexCoordinate(2, 0)
        },
      );

      expect(
          aoe.distanceToCoordinate(const CubeHexCoordinate(2, 0)), equals(0));
    });
  });
}
