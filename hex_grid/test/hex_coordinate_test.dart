import 'package:hex_grid/hex_grid.dart';
import 'package:test/test.dart';

void main() {
  group('rotationTicksTowardsCoordinate', () {
    test('returns expected from zero ton range 1', () {
      final o = HexCoordinate.zero().toCube();
      expect(o.rotationTicksTowardsCoordinate(CubeHexCoordinate(0, 0)), -1);
      expect(o.rotationTicksTowardsCoordinate(CubeHexCoordinate(0, -1)), 0);
      expect(o.rotationTicksTowardsCoordinate(CubeHexCoordinate(1, -1)), 1);
      expect(o.rotationTicksTowardsCoordinate(CubeHexCoordinate(1, 0)), 2);
      expect(o.rotationTicksTowardsCoordinate(CubeHexCoordinate(0, 1)), 3);
      expect(o.rotationTicksTowardsCoordinate(CubeHexCoordinate(-1, 1)), 4);
      expect(o.rotationTicksTowardsCoordinate(CubeHexCoordinate(-1, 0)), 5);
    });

    test('returns expected from zero to range 2', () {
      final o = HexCoordinate.zero().toCube();
      expect(o.rotationTicksTowardsCoordinate(CubeHexCoordinate(0, -2)), 0);
      expect(o.rotationTicksTowardsCoordinate(CubeHexCoordinate(1, -2)), -1);
      expect(o.rotationTicksTowardsCoordinate(CubeHexCoordinate(2, -2)), 1);
      expect(o.rotationTicksTowardsCoordinate(CubeHexCoordinate(2, -1)), -1);
      expect(o.rotationTicksTowardsCoordinate(CubeHexCoordinate(2, 0)), 2);
      expect(o.rotationTicksTowardsCoordinate(CubeHexCoordinate(1, 1)), -1);
      expect(o.rotationTicksTowardsCoordinate(CubeHexCoordinate(0, 2)), 3);
      expect(o.rotationTicksTowardsCoordinate(CubeHexCoordinate(-1, 2)), -1);
      expect(o.rotationTicksTowardsCoordinate(CubeHexCoordinate(-2, 2)), 4);
      expect(o.rotationTicksTowardsCoordinate(CubeHexCoordinate(-2, 1)), -1);
      expect(o.rotationTicksTowardsCoordinate(CubeHexCoordinate(-2, 0)), 5);
      expect(o.rotationTicksTowardsCoordinate(CubeHexCoordinate(-1, -1)), -1);
    });

    test('returns expected from zero to range 3', () {
      final o = HexCoordinate.zero().toCube();
      expect(o.rotationTicksTowardsCoordinate(CubeHexCoordinate(0, -3)), 0);
      expect(o.rotationTicksTowardsCoordinate(CubeHexCoordinate(1, -3)), 0);
      expect(o.rotationTicksTowardsCoordinate(CubeHexCoordinate(2, -3)), 1);
      expect(o.rotationTicksTowardsCoordinate(CubeHexCoordinate(3, -3)), 1);
      expect(o.rotationTicksTowardsCoordinate(CubeHexCoordinate(3, -2)), 1);
      expect(o.rotationTicksTowardsCoordinate(CubeHexCoordinate(3, -1)), 2);
      expect(o.rotationTicksTowardsCoordinate(CubeHexCoordinate(3, 0)), 2);
      expect(o.rotationTicksTowardsCoordinate(CubeHexCoordinate(2, 1)), 2);
      expect(o.rotationTicksTowardsCoordinate(CubeHexCoordinate(1, 2)), 3);
      expect(o.rotationTicksTowardsCoordinate(CubeHexCoordinate(0, 3)), 3);
      expect(o.rotationTicksTowardsCoordinate(CubeHexCoordinate(-1, 3)), 3);
      expect(o.rotationTicksTowardsCoordinate(CubeHexCoordinate(-2, 3)), 4);
      expect(o.rotationTicksTowardsCoordinate(CubeHexCoordinate(-3, 3)), 4);
      expect(o.rotationTicksTowardsCoordinate(CubeHexCoordinate(-3, 2)), 4);
      expect(o.rotationTicksTowardsCoordinate(CubeHexCoordinate(-3, 1)), 5);
      expect(o.rotationTicksTowardsCoordinate(CubeHexCoordinate(-3, 0)), 5);
      expect(o.rotationTicksTowardsCoordinate(CubeHexCoordinate(-2, -1)), 5);
      expect(o.rotationTicksTowardsCoordinate(CubeHexCoordinate(-1, -2)), 0);
    });

    test('returns expected from non zero origin', () {
      final o = CubeHexCoordinate(2, 1);
      expect(o.rotationTicksTowardsCoordinate(CubeHexCoordinate(4, -1)), 1);
      expect(o.rotationTicksTowardsCoordinate(CubeHexCoordinate(2, 4)), 3);
    });
  });

  group('distance', () {
    test('Distance between the same coordinate', () {
      const a = CubeHexCoordinate(0, 0);
      const b = CubeHexCoordinate(0, 0);
      expect(a.distanceTo(b), 0);
    });

    test('Distance between two adjacent coordinates', () {
      const a = CubeHexCoordinate(0, 0);
      const b = CubeHexCoordinate(1, 0);
      expect(a.distanceTo(b), 1);
    });

    test('Distance between two coordinates far away', () {
      const a = CubeHexCoordinate(0, 0);
      const b = CubeHexCoordinate(3, 4);
      expect(a.distanceTo(b), 7);
    });
  });

  group('line', () {
    test('Line between the same coordinate', () {
      const a = CubeHexCoordinate(0, 0);
      expect(HexCoordinate.line(a, a, excludeEdges: false), []);
    });
    test('Line between adjacent coordinates', () {
      const a = CubeHexCoordinate(0, 0);
      const b = CubeHexCoordinate(0, 1);
      expect(HexCoordinate.line(a, b, excludeEdges: false), [a, b]);
    });
    test(
        'Line between coordinates passing edge ending in positive q, negative r, negative s',
        () {
      const a = CubeHexCoordinate(0, 0);
      const b = CubeHexCoordinate(2, -1);
      expect(HexCoordinate.line(a, b, excludeEdges: false),
          [a, const CubeHexCoordinate(1, -1), b]);
    });
    test(
        'Line between coordinates passing edge ending in positive q, negative r, negative s, excluding edges',
        () {
      const a = CubeHexCoordinate(0, 0);
      const b = CubeHexCoordinate(2, -1);
      expect(HexCoordinate.line(a, b, excludeEdges: true), [a, b]);
    });
    test(
        'Line between coordinates passing edge ending in positive q, positive r, negative s',
        () {
      const a = CubeHexCoordinate(0, 0);
      const b = CubeHexCoordinate(1, 1);
      expect(HexCoordinate.line(a, b, excludeEdges: false),
          [a, const CubeHexCoordinate(1, 0), b]);
    });
    test(
        'Line between coordinates passing edge ending in positive q, positive r, negative s, excluding edges',
        () {
      const a = CubeHexCoordinate(0, 0);
      const b = CubeHexCoordinate(1, 1);
      expect(HexCoordinate.line(a, b, excludeEdges: true), [a, b]);
    });
    test(
        'Line between coordinates passing edge ending in negative q, positive r, positive s',
        () {
      const a = CubeHexCoordinate(0, 0);
      const b = CubeHexCoordinate(-2, 1);
      expect(HexCoordinate.line(a, b, excludeEdges: false),
          [a, const CubeHexCoordinate(-1, 1), b]);
    });
    test(
        'Line between coordinates passing edge ending in negative q, positive r, positive s, excluding edges',
        () {
      const a = CubeHexCoordinate(0, 0);
      const b = CubeHexCoordinate(-2, 1);
      expect(HexCoordinate.line(a, b, excludeEdges: true), [a, b]);
    });
    test(
        'Line between coordinates passing two edges ending in positive q, negative r, negative s',
        () {
      const a = CubeHexCoordinate(0, 0);
      const b = CubeHexCoordinate(4, -2);
      expect(HexCoordinate.line(a, b, excludeEdges: false), [
        a,
        const CubeHexCoordinate(1, -1),
        const CubeHexCoordinate(2, -1),
        const CubeHexCoordinate(3, -2),
        b
      ]);
    });
    test(
        'Line between coordinates passing two edges ending in positive q, negative r, negative s, excluding edges',
        () {
      const a = CubeHexCoordinate(0, 0);
      const b = CubeHexCoordinate(4, -2);
      expect(HexCoordinate.line(a, b, excludeEdges: true),
          [a, const CubeHexCoordinate(2, -1), b]);
    });
    test(
        'Line between coordinates passing two edges ending in negative q, positive r, positive s',
        () {
      const a = CubeHexCoordinate(0, 0);
      const b = CubeHexCoordinate(-4, 2);
      expect(HexCoordinate.line(a, b, excludeEdges: false), [
        a,
        const CubeHexCoordinate(-1, 1),
        const CubeHexCoordinate(-2, 1),
        const CubeHexCoordinate(-3, 2),
        b
      ]);
    });
    test(
        'Line between coordinates passing two edges ending in negative q, positive r, positive s, excluding edges',
        () {
      const a = CubeHexCoordinate(0, 0);
      const b = CubeHexCoordinate(-4, 2);
      expect(HexCoordinate.line(a, b, excludeEdges: true),
          [a, const CubeHexCoordinate(-2, 1), b]);
    });
  });
}
