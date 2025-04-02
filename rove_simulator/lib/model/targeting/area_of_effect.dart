import 'dart:math';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:hex_grid/hex_grid.dart';
import 'package:rove_data_types/rove_data_types.dart';

@immutable
class AreaOfEffect {
  final AOEDef definition;
  final CubeHexCoordinate? origin;
  final CubeHexCoordinate? anchor;
  final Set<HexCoordinate> coordinates;

  const AreaOfEffect(
      {required this.definition,
      this.origin,
      this.anchor,
      required this.coordinates});

  @override
  bool operator ==(Object other) {
    if (other is! AreaOfEffect) {
      return false;
    }
    return definition == other.definition &&
        origin == other.origin &&
        anchor == other.anchor &&
        const SetEquality().equals(coordinates, other.coordinates);
  }

  @override
  int get hashCode {
    return Object.hash(definition, origin, anchor, coordinates.length);
  }

  /// Returns the distance from the origin to the given coordinate if defined, or the minimum distance to the area of effect coordinates otherwise.
  int distanceToCoordinate(HexCoordinate coordinate) {
    if (origin != null) {
      return origin!.distanceTo(coordinate);
    } else {
      return coordinates.map((c) => c.distanceTo(coordinate)).reduce(min);
    }
  }
}
