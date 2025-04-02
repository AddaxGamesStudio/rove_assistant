import 'package:flutter/foundation.dart';
import 'package:rove_simulator/model/map_model.dart';
import 'package:rove_simulator/model/persistence/saveable.dart';
import 'package:hex_grid/hex_grid.dart';
import 'package:rove_data_types/rove_data_types.dart';

class TerrainModel extends ChangeNotifier with Saveable {
  late TerrainType _terrain;
  late HexCoordinate _coordinate;
  bool _changed = false;
  bool get changed => _changed;
  Ether? spawnPoint;

  TerrainModel(
      {required TerrainType terrain,
      required HexCoordinate coordinate,
      this.spawnPoint})
      : _terrain = terrain,
        _coordinate = coordinate;

  TerrainType get terrain => _terrain;
  HexCoordinate get coordinate => _coordinate;

  set terrain(TerrainType value) {
    if (_terrain == value) {
      return;
    }
    _changed = true;
    _terrain = value;
    notifyListeners();
  }

  /* Saveable */

  TerrainModel.fromSaveData(SaveData data) {
    initializeWithSaveData(data);
  }

  @override
  String get saveableKey => _terrain.name;

  @override
  Map<String, dynamic> saveableProperties() {
    return {
      'terrain': _terrain.name,
      'coordinate': coordinate.toEvenQ().toString(),
      if (spawnPoint case final value?) 'spawn_point': value.toJson()
    };
  }

  @override
  String get saveableType => 'TerrainModel';

  @override
  int get saveablePriority => MapModel.terrainSaveablePriority;

  @override
  setSaveablePropertiesBeforeChildren(Map<String, dynamic> properties) {
    super.setSaveablePropertiesAfterChildren(properties);
    final terrainName = properties['terrain'] as String?;
    _terrain = terrainName != null
        ? TerrainType.fromName(terrainName)
        : TerrainType.normal;
    final coordinateString = properties['coordinate'] as String?;
    _coordinate = coordinateString != null
        ? EvenQHexCoordinate.fromString(coordinateString)
        : HexCoordinate.zero();
    spawnPoint = properties.containsKey('spawn_point')
        ? Ether.fromJson(properties['spawn_point'] as String)
        : null;
  }
}
