import 'package:meta/meta.dart';

@immutable
abstract class HexCoordinate {
  final int q;
  final int r;

  const HexCoordinate(this.q, this.r);

  AxialHexCoordinate toAxial();
  EvenQHexCoordinate toEvenQ();
  CubeHexCoordinate toCube();

  static const _zero = CubeHexCoordinate(0, 0);

  factory HexCoordinate.zero() {
    return _zero;
  }

  @override
  bool operator ==(Object other) {
    if (other is HexCoordinate) {
      final a = toCube();
      final b = other.toCube();
      return a.q == b.q && a.r == b.r && a.s == b.s;
    }
    return super == other;
  }

  @override
  String toString() {
    return '($q, $r)';
  }

  int distanceTo(HexCoordinate other) {
    final a = toAxial();
    final b = other.toAxial();
    return ((a.q - b.q).abs() +
            (a.q + a.r - b.q - b.r).abs() +
            (a.r - b.r).abs()) ~/
        2;
  }

  @override
  int get hashCode {
    final cube = toCube();
    return cube.q.hashCode ^ cube.r.hashCode;
  }

  HexCoordinate addVector(int q, int r, int s) {
    final cubeC = toCube();
    return CubeHexCoordinate(cubeC.q + q, cubeC.r + r);
  }

  static List<HexCoordinate> line(HexCoordinate from, HexCoordinate to,
      {required bool excludeEdges}) {
    final n = from.distanceTo(to);
    if (n == 0) {
      return [];
    }
    final results = <HexCoordinate>[];
    final a = from.toCube();
    final b = to.toCube();
    for (int i = 0; i <= n; i++) {
      final (q, r, s) = CubeHexCoordinate.lerp(a, b, 1.0 / n * i);
      if (excludeEdges && CubeHexCoordinate.isEdge(q, r, s)) {
        continue;
      }
      final rounded = CubeHexCoordinate.round(q, r, s);
      results.add(rounded);
    }
    return results;
  }
}

@immutable
class EvenQHexCoordinate extends HexCoordinate {
  static Iterable<(int, int)> oddQNeighborVectors = [
    (0, -1),
    (1, -1),
    (1, 0),
    (0, 1),
    (-1, 0),
    (-1, -1),
  ];
  static Iterable<(int, int)> evenQNeighborVectors = [
    (0, -1),
    (1, 0),
    (1, 1),
    (0, 1),
    (-1, 1),
    (-1, 0),
  ];

  const EvenQHexCoordinate(super.q, super.r);

  factory EvenQHexCoordinate.round(double q, r) {
    final r1 = r - (q + (q % 1)) / 2;
    return AxialHexCoordinate.round(q, r1).toEvenQ();
  }

  @override
  AxialHexCoordinate toAxial() {
    final r1 = r - (q + (q & 1)) ~/ 2;
    return AxialHexCoordinate(q, r1);
  }

  @override
  CubeHexCoordinate toCube() {
    return toAxial().toCube();
  }

  @override
  EvenQHexCoordinate toEvenQ() {
    return this;
  }

  static EvenQHexCoordinate fromString(String s) {
    s = s.replaceAll(' ', '').replaceAll('(', '').replaceAll(')', '');
    final components = s.split(',');
    if (components.length != 2) {
      throw ArgumentError(s);
    }
    return EvenQHexCoordinate(
        int.parse(components[0]), int.parse(components[1]));
  }
}

@immutable
class AxialHexCoordinate extends HexCoordinate {
  const AxialHexCoordinate(super.q, super.r);

  factory AxialHexCoordinate.round(double q, r) {
    return CubeHexCoordinate.round(q, r, -q - r).toAxial();
  }

  @override
  AxialHexCoordinate toAxial() {
    return this;
  }

  @override
  CubeHexCoordinate toCube() {
    return CubeHexCoordinate(q, r);
  }

  @override
  EvenQHexCoordinate toEvenQ() {
    var r1 = r + (q + (q & 1)) ~/ 2;
    return EvenQHexCoordinate(q, r1);
  }
}

@immutable
class CubeHexCoordinate extends HexCoordinate {
  final int s;

  const CubeHexCoordinate(super.q, super.r) : s = -q - r;

  factory CubeHexCoordinate.round(double q, r, s) {
    var rq = q.round();
    var rr = r.round();
    var rs = s.round();

    final qDiff = (rq - q).abs();
    final rDiff = (rr - r).abs();
    final sDiff = (rs - s).abs();

    if (qDiff > rDiff && qDiff > sDiff) {
      rq = -rr - rs;
    } else if (rDiff > sDiff) {
      rr = -rq - rs;
    } else {
      rs = -rq - rr;
    }
    assert(rq + rr + rs == 0);
    return CubeHexCoordinate(rq, rr);
  }

  static bool isEdge(double q, r, s) {
    var rq = q.round();
    var rr = r.round();
    var rs = s.round();

    final qDiff = (rq - q).abs();
    final rDiff = (rr - r).abs();
    final sDiff = (rs - s).abs();

    if (qDiff == 0.5) {
      if (qDiff == rDiff) {
        return true;
      } else if (qDiff == sDiff) {
        return true;
      }
    }
    if (rDiff == 0.5) {
      return rDiff == sDiff;
    }
    return false;
  }

  @override
  String toString() {
    return '($q, $r, $s)';
  }

  @override
  AxialHexCoordinate toAxial() {
    return AxialHexCoordinate(q, r);
  }

  @override
  CubeHexCoordinate toCube() {
    return this;
  }

  @override
  EvenQHexCoordinate toEvenQ() {
    return toAxial().toEvenQ();
  }

  CubeHexCoordinate vectorToCoordinate(HexCoordinate coordinate) {
    final c = coordinate.toCube();
    return CubeHexCoordinate(c.q - q, c.r - r);
  }

  int rotationTicksTowardsCoordinate(CubeHexCoordinate coordinate) {
    final a = this;
    final b = coordinate;
    final n = a.distanceTo(b);
    if (n == 0) {
      return -1;
    }
    final (q, r, s) = CubeHexCoordinate.lerp(a, b, 1.0 / n);
    if (CubeHexCoordinate.isEdge(q, r, s)) {
      return -1;
    }
    final rounded = CubeHexCoordinate.round(q, r, s);
    final v = vectorToCoordinate(rounded);
    return v._rotationTicks();
  }

  int _rotationTicks() {
    assert(-1 <= q && q <= 1);
    assert(-1 <= r && r <= 1);
    assert(-1 <= s && s <= 1);
    if (q == 0 && r == -1) {
      return 0;
    } else if (q == 1 && r == -1) {
      return 1;
    } else if (q == 1 && r == 0) {
      return 2;
    } else if (q == 0 && r == 1) {
      return 3;
    } else if (q == -1 && r == 1) {
      return 4;
    } else if (q == -1 && r == 0) {
      return 5;
    }
    assert(false);
    return -1;
  }

  CubeHexCoordinate rotateByOneSixthTicks(int ticks) {
    var rotated = (q, r, s);
    for (int i = 1; i <= ticks; i++) {
      rotated = (-rotated.$2, -rotated.$3, -rotated.$1);
    }
    return CubeHexCoordinate(rotated.$1, rotated.$2);
  }

  static (double, double, double) lerp(
      CubeHexCoordinate a, CubeHexCoordinate b, double t) {
    return (
      a.q + (b.q - a.q) * t,
      a.r + (b.r - a.r) * t,
      a.s + (b.s - a.s) * t
    );
  }
}
