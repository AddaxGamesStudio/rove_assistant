import 'package:collection/collection.dart';
import 'package:rove_simulator/model/map_model.dart';
import 'package:rove_simulator/model/targeting/area_of_effect.dart';
import 'package:rove_simulator/model/tiles/unit_model.dart';
import 'package:hex_grid/hex_grid.dart';

extension MapModelTargetingExtension on MapModel {
  List<HexCoordinate> occupableCoordinatesByMoving(
      {required UnitModel actor, required int distance}) {
    return coordinatesWithinRange(
            center: actor.coordinate,
            range: (0, distance),
            needsLineOfSight: false)
        .where((c) => canOccupy(actor: actor, coordinate: c))
        .toList();
  }

  Iterable<HexCoordinate> occupableCoordinatesAtRangeOfTarget(
      {required UnitModel actor,
      required UnitModel target,
      required (int, int) range}) {
    return coordinatesWithinRangeOfTarget(
            target: target, range: range, needsLineOfSight: false)
        .map((c) => actor.originCoordinatesToOccupyCoordinate(c))
        .flattened
        .toSet()
        .where((c) => canOccupy(actor: actor, coordinate: c));
  }

  Iterable<HexCoordinate> occupableCoordinatesAtRangeOfAOE(
      {required UnitModel actor,
      required AreaOfEffect aoe,
      required (int, int) range}) {
    late Iterable<HexCoordinate> candidates;
    if (aoe.anchor != null) {
      assert(range == (1, 1));
      candidates = [aoe.anchor!];
    } else if (aoe.origin != null) {
      candidates = coordinatesWithinRange(
          center: aoe.origin!, range: range, needsLineOfSight: true);
    } else {
      candidates = aoe.coordinates
          .map((c) => coordinatesWithinRange(
                      center: c, range: range, needsLineOfSight: true)
                  .where((c) {
                final distance = aoe.distanceToCoordinate(c);
                return range.$1 <= distance && distance <= range.$2;
              }))
          .flattened;
    }
    return candidates
        .map((c) => actor.originCoordinatesToOccupyCoordinate(c).where((c) {
              final distance = actor.distanceToAOE(aoe, origin: c);
              return range.$1 <= distance && distance <= range.$2;
            }))
        .flattened
        .toSet()
        .where((c) => canOccupy(actor: actor, coordinate: c));
  }
}
