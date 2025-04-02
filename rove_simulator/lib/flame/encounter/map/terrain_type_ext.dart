import 'dart:ui';

import 'package:flame/sprite.dart';
import 'package:flutter/widgets.dart';
import 'package:rove_simulator/assets.dart';
import 'package:rove_data_types/rove_data_types.dart';

Paint _dangerousPaint = Paint()..color = const Color.fromRGBO(255, 0, 25, 1);
Paint _barrierPaint = Paint()..color = const Color.fromRGBO(255, 0, 0, 0);
Paint _difficultPaint = Paint()..color = const Color.fromARGB(255, 0, 131, 253);
Paint _objectPaint = Paint()..color = const Color.fromARGB(255, 251, 255, 0);

extension TerrainTypeExtension on TerrainType {
  Paint? get fillPaint {
    switch (this) {
      case TerrainType.normal:
        return null;
      case TerrainType.dangerous:
        return _dangerousPaint;
      case TerrainType.difficult:
        return _difficultPaint;
      case TerrainType.object:
        return _objectPaint;
      case TerrainType.start:
        return null;
      case TerrainType.exit:
        return null;
      case TerrainType.openAir:
        return null;
      case TerrainType.barrier:
        return _barrierPaint;
      case TerrainType.unplayable:
        return null;
    }
  }

  Sprite? get icon {
    switch (this) {
      case TerrainType.barrier:
      case TerrainType.normal:
      case TerrainType.dangerous:
      case TerrainType.difficult:
      case TerrainType.object:
      case TerrainType.openAir:
      case TerrainType.unplayable:
        return null;
      case TerrainType.start:
        return Assets.iconStart;
      case TerrainType.exit:
        return Assets.iconExit;
    }
  }
}
