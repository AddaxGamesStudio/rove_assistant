import 'package:collection/collection.dart';
import 'package:rove_editor/model/targeting/area_of_effect.dart';
import 'package:rove_editor/model/tiles/unit_model.dart';
import 'package:hex_grid/hex_grid.dart';
import 'package:rove_data_types/rove_data_types.dart';

extension AOEDefCoordinateExtension on AOEDef {
  List<HexCoordinate> rotatedCoordinates(
      {required CubeHexCoordinate center,
      required CubeHexCoordinate anchor,
      int rotationTicksDelta = 0}) {
    if (relativeToActor && center != anchor) {
      // Calculate the rotation
      var ticks = center.rotationTicksTowardsCoordinate(anchor);
      if (ticks == -1) {
        // No exact rotation possible; default to no rotation
        ticks = 0;
      }
      ticks = (ticks + rotationTicksDelta) % 6;

      final projectedCenterTicks = (ticks + 3) % 6;
      final rotatedVector = const CubeHexCoordinate(0, -1)
          .rotateByOneSixthTicks(projectedCenterTicks);
      final projectedCenter = CubeHexCoordinate(
          anchor.q + rotatedVector.q, anchor.r + rotatedVector.r);
      final nonRotatedAnchor =
          CubeHexCoordinate(projectedCenter.q, projectedCenter.r - 1);

      return cubeVectors
          .map((v) => CubeHexCoordinate(
              nonRotatedAnchor.q + v.$1, nonRotatedAnchor.r + v.$2))
          .map((c) => projectedCenter.vectorToCoordinate(c))
          .map((v) => v.rotateByOneSixthTicks(ticks))
          .map((v) => CubeHexCoordinate(
              projectedCenter.q + v.q, projectedCenter.r + v.r))
          .toList();
    } else {
      return cubeVectors
          .map((v) => CubeHexCoordinate(anchor.q + v.$1, anchor.r + v.$2))
          .toList();
    }
  }

  bool isInside(
      {required CubeHexCoordinate center,
      required CubeHexCoordinate anchor,
      required HexCoordinate coordinate,
      int rotationTicksDelta = 0}) {
    if (coordinate.distanceTo(anchor) > maxDistanceToOrigin) {
      return false;
    }

    return rotatedCoordinates(
            center: center,
            anchor: anchor,
            rotationTicksDelta: rotationTicksDelta)
        .any((c) => c == coordinate);
  }

  Set<AreaOfEffect> matchingTarget(UnitModel target) {
    return target.coordinates
        .map((c) => c.toCube())
        .map(matchingCoordinate)
        .flattened
        .toSet();
  }

  Set<AreaOfEffect> matchingCoordinate(CubeHexCoordinate coordinate) {
    final Set<AreaOfEffect> result = {};
    if (radiallySymmetrical) {
      for (final vector in cubeVectors) {
        final origin = CubeHexCoordinate(
            coordinate.q - vector.$1, coordinate.r - vector.$2);
        final coordinates = cubeVectors
            .map((v) => CubeHexCoordinate(origin.q + v.$1, origin.r + v.$2))
            .toSet();
        result.add(AreaOfEffect(
            definition: this, origin: origin, coordinates: coordinates));
      }
    } else {
      for (int i = 0; i < 6; i++) {
        final rotatedVectors = cubeVectors
            .map((v) => CubeHexCoordinate(v.$1, v.$2))
            .map((v) => v.rotateByOneSixthTicks(i));
        if (equidistant) {
          final coordinates = rotatedVectors
              .map((v) =>
                  CubeHexCoordinate(coordinate.q - v.q, coordinate.r - v.r))
              .toSet();
          result.add(AreaOfEffect(definition: this, coordinates: coordinates));
        } else {
          final anchorVector =
              const CubeHexCoordinate(0, 1).rotateByOneSixthTicks(i);
          for (final vector in rotatedVectors) {
            final origin = CubeHexCoordinate(
                coordinate.q - vector.q, coordinate.r - vector.r);
            final anchor = CubeHexCoordinate(
                origin.q + anchorVector.q, origin.r + anchorVector.r);
            final coordinates = rotatedVectors
                .map((v) => CubeHexCoordinate(origin.q + v.q, origin.r + v.r))
                .toSet();
            result.add(AreaOfEffect(
                definition: this,
                anchor: anchor,
                origin: origin,
                coordinates: coordinates));
          }
        }
      }
    }

    return result;
  }
}
