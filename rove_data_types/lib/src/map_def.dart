import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:rove_data_types/src/ether.dart';
import 'package:rove_data_types/src/terrain_type.dart';
import 'package:rove_data_types/src/utils/json_utils.dart';
import 'package:rove_data_types/src/utils/vector_utils.dart';

@immutable
class MapDef {
  final String id;
  final int rowCount;
  final int columnCount;
  final Rect backgroundRect;

  /// Uses even-q coordinates
  final List<(int, int)> _starts;
  final List<(int, int)> _exits;
  final Map<(int, int), TerrainType> _terrain;
  final Map<(int, int), Ether> _spawnPoints;

  MapDef(
      {required this.id,
      required this.columnCount,
      required this.rowCount,
      required this.backgroundRect,
      List<(int, int)> starts = const [],
      List<(int, int)> exits = const [],
      required Map<(int, int), TerrainType> terrain,
      Map<(int, int), Ether> spawnPoints = const {}})
      : _starts = starts.toList(),
        _exits = exits.toList(),
        _terrain = terrain,
        _spawnPoints = spawnPoints;

  List<(int, int)> get starts => [
        ..._starts,
        ..._terrain.entries
            .where((e) => e.value == TerrainType.start)
            .map((e) => e.key)
      ];
  List<(int, int)> get exits => [
        ..._exits,
        ..._terrain.entries
            .where((e) => e.value == TerrainType.exit)
            .map((e) => e.key)
      ];
  Map<(int, int), TerrainType> get terrain => _terrain;
  Map<(int, int), Ether> get spawnPoints => _spawnPoints;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'row_count': rowCount,
      'column_count': columnCount,
      'background_rect': rectToString(backgroundRect),
      if (starts.isNotEmpty)
        'starts': starts.map((c) => coordinateToString(c)).toList(),
      if (exits.isNotEmpty)
        'exits': exits.map((c) => coordinateToString(c)).toList(),
      'terrain': Map.fromEntries(_terrain.entries
          .where((e) =>
              e.value != TerrainType.start && e.value != TerrainType.exit)
          .map((e) => MapEntry(coordinateToString(e.key), e.value.toJson()))),
      if (_spawnPoints.isNotEmpty)
        'spawn_points': _spawnPoints.map(
            (key, value) => MapEntry(coordinateToString(key), value.toJson()))
    };
  }

  factory MapDef.fromJson(Map<String, dynamic> json) {
    return MapDef(
        id: json['id'] as String,
        rowCount: json['row_count'] as int,
        columnCount: json['column_count'] as int,
        backgroundRect: parseRect(json['background_rect'] as String),
        starts: decodeJsonListNamed('starts', json, (c) => parseCoordinate(c)),
        exits: decodeJsonListNamed('exits', json, (c) => parseCoordinate(c)),
        terrain: Map.fromEntries((json['terrain'] as Map<String, dynamic>)
            .entries
            .map((entry) => MapEntry(parseCoordinate(entry.key),
                TerrainType.fromJson(entry.value)))),
        spawnPoints: json.containsKey('spawn_points')
            ? Map.fromEntries((json['spawn_points'] as Map<String, dynamic>)
                .entries
                .map((entry) => MapEntry(
                    parseCoordinate(entry.key), Ether.fromJson(entry.value))))
            : {});
  }

  TerrainType terrainAt({required int q, required int r}) {
    return _terrain[(q, r)] ?? TerrainType.normal;
  }

  Ether? spawnPointAt({required int q, required int r}) {
    return _spawnPoints[(q, r)];
  }

  Iterable<(int, int)> get startCoordinates {
    return _terrain.entries
            .where((entry) => entry.value == TerrainType.start)
            .map((entry) => entry.key)
            .toList() +
        starts;
  }

  static const String emptyMapId = 'empty';

  factory MapDef.empty() {
    return MapDef(
        id: emptyMapId,
        columnCount: 0,
        rowCount: 0,
        backgroundRect: Rect.zero,
        terrain: {});
  }

  bool get isEmpty => rowCount == 0 || columnCount == 0;
}
