import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_noise/flame_noise.dart';
import 'package:rove_editor/flame/encounter/map/map_component.dart';
import 'package:hex_grid/hex_grid.dart';
import 'package:rove_editor/flame/map_editor.dart';

class CoordinateComponent extends PositionComponent with HasGameRef<MapEditor> {
  static const double defaultRadius = 50;
  static final defaultSize =
      Vector2(defaultRadius * 2, defaultRadius * sqrt(3));

  bool coordinateSet = false;
  late HexCoordinate _coordinate;
  HexCoordinate get coordinate => _coordinate;

  bool focused = false;

  CoordinateComponent({required int priority})
      : super(priority: priority, size: defaultSize, anchor: Anchor.center);

  Vector2? centerForCoordinate(HexCoordinate coordinate) {
    return map.centerForCoordinate(coordinate)!;
  }

  bool occupiesCoordinate(HexCoordinate coordinate) {
    return coordinate == _coordinate;
  }

  Future<void> setCoordinateAnimated(HexCoordinate value) async {
    if (coordinateSet && coordinate == value) {
      return;
    }
    final hexCenter = centerForCoordinate(value);
    assert(hexCenter != null, 'Coordinate $value is not on the map');
    if (coordinateSet) {
      _coordinate = value;
      final completer = Completer();
      add(MoveToEffect(
        hexCenter!,
        EffectController(duration: 0.1),
        onComplete: () {
          completer.complete();
        },
      ));
      return completer.future;
    } else {
      _coordinate = value;
      coordinateSet = true;
      position = hexCenter!;
    }
  }

  setPathAnimated(Iterable<HexCoordinate> path, Function()? onComplete) {
    if (path.isEmpty) {
      return;
    }
    final effects = path.map((c) {
      final hexCenter = centerForCoordinate(c);
      return MoveToEffect(hexCenter!, EffectController(duration: 0.1),
          onComplete: () {
        _coordinate = c;
        coordinateSet = true;
      });
    });
    add(
      SequenceEffect(effects.toList(), onComplete: onComplete),
    );
  }

  Future<void> shake() {
    final completer = Completer();
    add(
      MoveEffect.by(
          Vector2(10, 10),
          NoiseEffectController(
            duration: 0.25,
            noise: PerlinNoise(frequency: 5),
          ), onComplete: () {
        completer.complete();
      }),
    );
    return completer.future;
  }

  Future<void> slayAnimated() {
    final completer = Completer();
    add(ScaleEffect.by(
      Vector2(0, 0),
      EffectController(duration: 0.1),
      onComplete: () {
        removeFromParent();
        completer.complete();
      },
    ));
    return completer.future;
  }

  set coordinate(HexCoordinate value) {
    if (coordinateSet && coordinate == value) {
      return;
    }
    final hexCenter = centerForCoordinate(value);
    assert(hexCenter != null, 'Coordinate $value is not on the map');
    _coordinate = value;
    coordinateSet = true;
    position = hexCenter!;
  }

  MapComponent get map => game.map;

  addCentered(PositionComponent component) {
    component.anchor = Anchor.center;
    component.position = size / 2;
    add(component);
  }
}
