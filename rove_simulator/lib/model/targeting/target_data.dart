import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:rove_simulator/model/targeting/area_of_effect.dart';
import 'package:rove_simulator/model/tiles/unit_model.dart';
import 'package:hex_grid/hex_grid.dart';

@immutable
class TargetData {
  final UnitModel target;
  final AreaOfEffect? aoe;
  final int minimumMoveEffort;
  final List<(HexCoordinate, int)> sortedCoordinates;

  const TargetData(
      {required this.target,
      required this.minimumMoveEffort,
      this.aoe,
      required this.sortedCoordinates});

  bool get targetable => sortedCoordinates.isNotEmpty;
  HexCoordinate? get lowestEffortCoordinate =>
      sortedCoordinates.firstOrNull?.$1;

  factory TargetData.untargetable(UnitModel target) {
    return TargetData(
        target: target, minimumMoveEffort: 0, sortedCoordinates: const []);
  }

  factory TargetData.withoutMoving(
      {required UnitModel target,
      AreaOfEffect? aoe,
      required UnitModel actor}) {
    return TargetData(
        target: target,
        minimumMoveEffort: 0,
        aoe: aoe,
        sortedCoordinates: [(actor.coordinate, 0)]);
  }

  factory TargetData.fromCoordinates(
      {required UnitModel target,
      AreaOfEffect? aoe,
      required List<(HexCoordinate, int)> coordinatesWithEffort}) {
    if (coordinatesWithEffort.isEmpty) {
      return TargetData.untargetable(target);
    }
    return TargetData(
        target: target,
        minimumMoveEffort: coordinatesWithEffort.map((d) => d.$2).reduce(min),
        aoe: aoe,
        sortedCoordinates: coordinatesWithEffort.sorted((a, b) => a.$2 - b.$2));
  }

  static Map<(HexCoordinate, AreaOfEffect?), List<UnitModel>>
      groupUnitsByCoordinateAndAOE(List<TargetData> data) {
    final coordinateTargets =
        <(HexCoordinate, AreaOfEffect?), List<UnitModel>>{};
    for (var d in data) {
      for (var coordinate in d.sortedCoordinates) {
        coordinateTargets.update((coordinate.$1, d.aoe), (targets) {
          if (targets.contains(d.target)) {
            return targets;
          } else {
            return targets + [d.target];
          }
        }, ifAbsent: () => [d.target]);
      }
      continue;
    }
    return coordinateTargets;
  }

  static (HexCoordinate, AreaOfEffect?, List<UnitModel>)
      findMostTargetsCoordinate(List<TargetData> data,
          {bool effortDescending = false}) {
    assert(data.isNotEmpty);
    assert(data.first.targetable);
    final coordinateTargets =
        <(HexCoordinate, AreaOfEffect?), List<UnitModel>>{};
    final coordinateEffort = <(HexCoordinate, AreaOfEffect?), int>{};
    for (var d in data) {
      for (var coordinate in d.sortedCoordinates) {
        coordinateTargets.update((coordinate.$1, d.aoe), (targets) {
          if (targets.contains(d.target)) {
            return targets;
          } else {
            return targets + [d.target];
          }
        }, ifAbsent: () => [d.target]);
        coordinateEffort[(coordinate.$1, d.aoe)] = coordinate.$2;
      }
      continue;
    }
    // Sort by number of targets descending, then by effort
    final sorted = coordinateTargets.entries.sorted((a, b) {
      if (a.value.length == b.value.length) {
        final aEffort = coordinateEffort[a.key]!;
        final bEffort = coordinateEffort[b.key]!;

        return effortDescending
            ? bEffort.compareTo(aEffort)
            : aEffort.compareTo(bEffort);
      } else {
        return b.value.length.compareTo(a.value.length);
      }
    });
    final best = sorted.first;
    return (best.key.$1, best.key.$2, best.value);
  }

  @override
  bool operator ==(Object other) {
    return other is TargetData &&
        other.target == target &&
        other.minimumMoveEffort == minimumMoveEffort &&
        other.aoe == aoe &&
        const ListEquality().equals(other.sortedCoordinates, sortedCoordinates);
  }

  @override
  int get hashCode => Object.hash(
      target, minimumMoveEffort, aoe, Object.hashAll(sortedCoordinates));
}
