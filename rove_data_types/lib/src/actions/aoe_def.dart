import 'package:collection/collection.dart';

class AOEDef {
  final String name;
  final bool relativeToActor;
  late bool equidistant;
  final bool radiallySymmetrical;
  late int maxDistanceToOrigin;
  final List<(int, int, int)> cubeVectors;

  AOEDef(
      {required this.name,
      required this.relativeToActor,
      required this.radiallySymmetrical,
      required this.cubeVectors})
      : assert(cubeVectors.isNotEmpty) {
    equidistant = _isEquidistant(cubeVectors);
    maxDistanceToOrigin = _maxDistanceToOrigin(cubeVectors);
  }

  static AOEDef? fromName(String name) {
    switch (name) {
      case 'x1Hex':
        return AOEDef.x1Hex();
      case 'x2Front':
        return AOEDef.x2Front();
      case 'x2Sides':
        return AOEDef.x2Sides();
      case 'x2Line':
        return AOEDef.x2Line();
      case 'x3Front':
        return AOEDef.x3Front();
      case 'x3Triangle':
        return AOEDef.x3Triangle();
      case 'x3Line':
        return AOEDef.x3Line();
      case 'x4Line':
        return AOEDef.x4Line();
      case 'x4Cleave':
        return AOEDef.x4Cleave();
      case 'x5Line':
        return AOEDef.x5Line();
      case 'x5FrontSpray':
        return AOEDef.x5FrontSpray();
      case 'x6Screech':
        return AOEDef.x6Screech();
      case 'x6Breadth':
        return AOEDef.x6Breath();
      case 'x7Honeycomb':
        return AOEDef.x7Honeycomb();
      case 'x9Cone':
        return AOEDef.x9Cone();
    }
    return null;
  }

  static String _vectorToString((int, int, int) vector) {
    return '(${vector.$1}, ${vector.$2}, ${vector.$3})';
  }

  static (int, int, int) _vectorFromString(String vector) {
    final parts = vector
        .replaceAll('(', '')
        .replaceAll(')', '')
        .replaceAll(' ', '')
        .split(',');
    return (int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2]));
  }

  Map<String, dynamic> toJson() {
    final knownAOE = fromName(name);
    final json = <String, dynamic>{'name': name};
    if (knownAOE != null) {
      return json;
    }
    json.addAll({
      'relative_to_actor': relativeToActor,
      'radially_symetrical': radiallySymmetrical,
      'cube_vectors': cubeVectors.map((c) => _vectorToString(c)),
    });
    return json;
  }

  factory AOEDef.fromJson(Map<String, dynamic> json) {
    final name = json['name'];
    final knownAOE = fromName(name);
    if (knownAOE != null) {
      return knownAOE;
    }
    return AOEDef(
        name: name,
        relativeToActor: json['relative_to_actor'] as bool,
        radiallySymmetrical: json['radially_symetrical'] as bool,
        cubeVectors: (json['cube_vectors'] as List<String>)
            .map((s) => _vectorFromString(s))
            .toList());
  }

  factory AOEDef.x1Hex() {
    return AOEDef(
        name: 'x1Hex',
        relativeToActor: false,
        radiallySymmetrical: true,
        cubeVectors: [(0, 0, 0)]);
  }

  factory AOEDef.x2Front() {
    return AOEDef(
        name: 'x2Front',
        relativeToActor: true,
        radiallySymmetrical: false,
        cubeVectors: [(0, 0, 0), (1, 0, -1)]);
  }

  factory AOEDef.x2Sides() {
    return AOEDef(
        name: 'x2Sides',
        relativeToActor: true,
        radiallySymmetrical: false,
        cubeVectors: [(0, 0, 0), (1, 1, -2)]);
  }

  factory AOEDef.x2Line() {
    return AOEDef(
        name: 'x2Line',
        relativeToActor: true,
        radiallySymmetrical: false,
        cubeVectors: [(0, 0, 0), (0, -1, 1)]);
  }

  factory AOEDef.x3Front() {
    return AOEDef(
        name: 'x3Front',
        relativeToActor: true,
        radiallySymmetrical: false,
        cubeVectors: [(-1, 1, 0), (0, 0, 0), (1, 0, -1)]);
  }

  factory AOEDef.x4Cleave() {
    return AOEDef(
        name: 'x4Cleave',
        relativeToActor: true,
        radiallySymmetrical: false,
        cubeVectors: [(0, 0, 0), (1, 0, -1), (1, 1, -2), (0, 2, -2)]);
  }

  factory AOEDef.x3Triangle() {
    return AOEDef(
        name: 'x3Triangle',
        relativeToActor: false,
        radiallySymmetrical: false,
        cubeVectors: [(0, 0, 0), (1, 0, -1), (1, -1, 0)]);
  }

  factory AOEDef.x3Line() {
    return AOEDef(
        name: 'x3Line',
        relativeToActor: true,
        radiallySymmetrical: false,
        cubeVectors: [(0, 0, 0), (0, -1, 1), (0, -2, 2)]);
  }

  factory AOEDef.x4Line() {
    return AOEDef(
        name: 'x4Line',
        relativeToActor: true,
        radiallySymmetrical: false,
        cubeVectors: [(0, 0, 0), (0, -1, 1), (0, -2, 2), (0, -3, 3)]);
  }

  factory AOEDef.x5Line() {
    return AOEDef(
        name: 'x5Line',
        relativeToActor: true,
        radiallySymmetrical: false,
        cubeVectors: [
          (0, 0, 0),
          (0, -1, 1),
          (0, -2, 2),
          (0, -3, 3),
          (0, -4, 4)
        ]);
  }

  factory AOEDef.x5FrontSpray() {
    return AOEDef(
        name: 'x5FrontSpray',
        relativeToActor: true,
        radiallySymmetrical: false,
        cubeVectors: [
          (0, 0, 0),
          (0, -1, 1),
          (1, -1, 0),
          (1, 0, -1),
          (2, -1, -1)
        ]);
  }

  factory AOEDef.x6Screech() {
    return AOEDef(
        name: 'x6Screech',
        relativeToActor: true,
        radiallySymmetrical: false,
        cubeVectors: [
          (0, 0, 0),
          (0, -1, 1),
          (-1, 0, 1),
          (-1, -1, 2),
          (1, -1, 0),
          (1, -2, 1)
        ]);
  }

  factory AOEDef.x6Breath() {
    return AOEDef(
        name: 'x6Breath',
        relativeToActor: true,
        radiallySymmetrical: false,
        cubeVectors: [
          (0, 0, 0),
          (1, 1, -2),
          (1, 0, -1),
          (1, -1, 0),
          (2, 0, -2),
          (2, -1, -1)
        ]);
  }

  factory AOEDef.x7Honeycomb() {
    return AOEDef(
        name: 'x7Honeycomb',
        relativeToActor: false,
        radiallySymmetrical: true,
        cubeVectors: [
          (1, 0, -1),
          (1, -1, 0),
          (0, -1, 1),
          (0, 0, 0),
          (-1, 0, 1),
          (-1, 1, 0),
          (0, 1, -1),
        ]);
  }

  factory AOEDef.x9Cone() {
    return AOEDef(
        name: 'x9Cone',
        relativeToActor: true,
        radiallySymmetrical: false,
        cubeVectors: [
          (0, -1, 1),
          (0, -2, 2),
          (0, -3, 3),
          (1, -1, 0),
          (1, -2, 1),
          (1, -3, 3),
          (2, -3, 1),
          (2, -2, 1),
          (3, -3, 1),
        ]);
  }

  bool get isSingleHex => cubeVectors.length == 1 && relativeToActor == false;

  @override
  bool operator ==(Object other) {
    if (other is! AOEDef) {
      return false;
    }
    return name == other.name &&
        relativeToActor == other.relativeToActor &&
        radiallySymmetrical == other.radiallySymmetrical &&
        const IterableEquality().equals(cubeVectors, other.cubeVectors);
  }

  @override
  int get hashCode {
    return name.hashCode;
  }

  static bool _isEquidistant(List<(int, int, int)> vectors) {
    if (vectors.length == 1) {
      return true;
    }

    final distance = _distance(vectors[0], vectors[1]);
    for (var i = 0; i < vectors.length; i++) {
      for (var j = 0; j < vectors.length; j++) {
        if (i == j) {
          continue;
        }
        if (distance != _distance(vectors[i], vectors[j])) {
          return false;
        }
      }
    }
    return true;
  }

  static int _maxDistanceToOrigin(List<(int, int, int)> vectors) {
    var maxDistance = 0;
    for (final vector in vectors) {
      final distance = _distance((0, 0, 0), vector);
      if (distance > maxDistance) {
        maxDistance = distance;
      }
    }
    return maxDistance;
  }

  static int _distance((int, int, int) a, (int, int, int) b) {
    return ((a.$1 - b.$1).abs() +
            (a.$1 + a.$2 - b.$1 - b.$2).abs() +
            (a.$2 - b.$2).abs()) ~/
        2;
  }
}
