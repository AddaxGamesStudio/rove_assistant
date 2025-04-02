import 'package:flutter/foundation.dart';
import 'package:hex_grid/hex_grid.dart';
import 'package:rove_data_types/rove_data_types.dart';

class TerrainModel extends ChangeNotifier {
  late TerrainType _terrain;
  late final HexCoordinate _coordinate;
  bool _isStart;
  bool _isExit;
  Ether? spawnPoint;

  TerrainModel(
      {required HexCoordinate coordinate,
      required TerrainType terrain,
      bool isStart = false,
      bool isExit = false,
      this.spawnPoint})
      : _terrain = terrain,
        _coordinate = coordinate,
        _isStart = isStart,
        _isExit = isExit;

  TerrainType get terrain => _terrain;
  HexCoordinate get coordinate => _coordinate;
  bool get isStart => _isStart;
  bool get isExit => _isExit;

  set terrain(TerrainType value) {
    if (_terrain == value) {
      return;
    }
    _terrain = value;
    notifyListeners();
  }

  set isStart(bool value) {
    if (_isStart == value) {
      return;
    }
    _isStart = value;
    notifyListeners();
  }

  set isExit(bool value) {
    if (_isExit == value) {
      return;
    }
    _isExit = value;
    notifyListeners();
  }
}
