import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:rove_editor/model/targeting/area_of_effect.dart';
import 'package:rove_editor/model/tiles/unit_model.dart';
import 'package:hex_grid/hex_grid.dart';
import 'package:rove_data_types/rove_data_types.dart';

mixin Slayable on TileModel {
  int health = 0;
  int maxHealth = 0;
  @override
  bool get isSlain => health <= 0;
  bool get isTargetable => !isSlain;
  int get defense {
    final glyphDefense =
        affectingGlyphs.fold(0, (value, glyph) => value + glyph.defenseBuff);
    return glyphDefense;
  }

  List<RoveGlyph> get affectingGlyphs;

  int resolveHeal(int amount) {
    final newhealth = min<int>(amount + health, maxHealth);
    final delta = newhealth - health;
    health = newhealth;
    notifyListeners();
    return delta;
  }

  bool testDamage = false;

  int sufferDamage(int amount) {
    final newhealth = max(0, health - amount);
    final delta = health - newhealth;
    if (!testDamage) {
      health = newhealth;
      notifyListeners();
    }
    return delta;
  }

  onAttackResolved();

  int resolveAttack(int amount, {bool pierce = false}) {
    final defense = pierce ? 0 : this.defense;
    final damage = max<int>(amount - defense, 0);
    final sufferedDamage = sufferDamage(damage);
    onAttackResolved();
    return sufferedDamage;
  }

  List<EncounterAction> get onSlayed;
  List<EncounterAction> get onDidStartRound;
  List<EncounterAction> get onWillEndRound;

  int get reducePushPullBy;
}

abstract class TileModel extends ChangeNotifier {
  HexCoordinate coordinate;
  TileModel({required this.coordinate});

  int? _key;

  String get name;
  String get key {
    _key ??= instanceCount++;
    return '$_key';
  }

  Color get color;
  Color get backgroundColor => color;

  bool get triggersTraps => (this is UnitModel);
  bool get isImperviousToDangerousTerrain;
  bool get immuneToForcedMovement;
  bool get ignoresDifficultTerrain;

  static int instanceCount = 0;

  bool get isSlain;

  List<HexCoordinate> get coordinates => coordinatesAtOrigin(coordinate);

  UnitModel? get owner;

  bool get usesGlyphs => false;

  static final List<(int, int)> _defaultCubeVectors = [(0, 0)];

  /// Override if the model has a different shape than a single hex. Used for large enemies.
  List<(int, int)> cubeVectorsForCoordinates() {
    return _defaultCubeVectors;
  }

  List<HexCoordinate> originCoordinatesToOccupyCoordinate(
      HexCoordinate coordinate) {
    final cubeCoordinate = coordinate.toCube();
    return cubeVectorsForCoordinates()
        .map((v) =>
            CubeHexCoordinate(cubeCoordinate.q - v.$1, cubeCoordinate.r - v.$2))
        .toList();
  }

  List<HexCoordinate> coordinatesAtOrigin(HexCoordinate origin) {
    final cubeOrigin = origin.toCube();
    return cubeVectorsForCoordinates()
        .map((v) => CubeHexCoordinate(cubeOrigin.q + v.$1, cubeOrigin.r + v.$2))
        .toList();
  }

  int distanceToCoordinate(HexCoordinate to, {HexCoordinate? origin}) {
    final fromCoordinates = coordinatesAtOrigin(origin ?? coordinate);
    int minimumDistance = fromCoordinates[0].distanceTo(to);
    for (int i = 0; i < fromCoordinates.length; i++) {
      final distance = fromCoordinates[i].distanceTo(to);
      if (distance < minimumDistance) {
        minimumDistance = distance;
      }
      if (minimumDistance == 0) {
        return minimumDistance;
      }
    }
    return minimumDistance;
  }

  HexCoordinate closestCoordinateOfTarget(TileModel target,
      {required HexCoordinate origin}) {
    final fromCoordinates = coordinatesAtOrigin(origin);
    final toCoordinates = target.coordinates;
    int minimumDistance = fromCoordinates[0].distanceTo(toCoordinates[0]);
    var closestCoordinate = toCoordinates[0];
    for (int i = 0; i < fromCoordinates.length; i++) {
      for (int j = 0; j < toCoordinates.length; j++) {
        final distance = fromCoordinates[i].distanceTo(toCoordinates[j]);
        if (distance < minimumDistance) {
          minimumDistance = distance;
          closestCoordinate = toCoordinates[j];
        }
        if (minimumDistance == 0) {
          return closestCoordinate;
        }
      }
    }
    return closestCoordinate;
  }

  int distanceToTarget(TileModel target, {HexCoordinate? origin}) {
    final fromCoordinates = coordinatesAtOrigin(origin ?? coordinate);
    final toCoordinates = target.coordinates;
    int minimumDistance = fromCoordinates[0].distanceTo(toCoordinates[0]);
    for (int i = 0; i < fromCoordinates.length; i++) {
      for (int j = 0; j < toCoordinates.length; j++) {
        final distance = fromCoordinates[i].distanceTo(toCoordinates[j]);
        if (distance < minimumDistance) {
          minimumDistance = distance;
        }
        if (minimumDistance == 0) {
          return minimumDistance;
        }
      }
    }
    return minimumDistance;
  }

  int distanceToAOE(AreaOfEffect aoe, {HexCoordinate? origin}) {
    return coordinatesAtOrigin(origin ?? coordinate)
        .map((c) => aoe.distanceToCoordinate(c))
        .reduce(min);
  }
}
