import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_noise/flame_noise.dart';
import 'package:flutter/animation.dart';
import 'package:rove_simulator/flame/encounter/coordinate_component.dart';
import 'package:rove_simulator/flame/encounter/map/map_component.dart';
import 'package:rove_simulator/flame/encounter/units/defense_component.dart';
import 'package:rove_simulator/flame/encounter/units/health_component.dart';
import 'package:rove_simulator/flame/encounter/units/large_tile_component.dart';
import 'package:rove_simulator/flame/encounter/units/tile_number_component.dart';
import 'package:rove_simulator/flame/encounter/units/unit_component.dart';
import 'package:rove_simulator/flame/encounter_game.dart';
import 'package:rove_simulator/model/tiles/enemy_model.dart';
import 'package:hex_grid/hex_grid.dart';

class LargeEnemyComponent extends CoordinateComponent
    with UnitComponent, HasGameRef<EncounterGame> {
  final EnemyModel model;

  LargeEnemyComponent({required this.model})
      : super(priority: MapComponent.unitPriority);

  late LargeTileComponent tileComponent;
  late TileNumberComponent _numberComponent;
  late HealthComponent _healthComponent;
  late DefenseComponent _defenseComponent;

  Color get borderColor => model.color;

  @override
  bool get isSlain => model.isSlain;
  @override
  String get modelKey => model.key;

  @override
  Vector2? centerForCoordinate(HexCoordinate coordinate) {
    final result = super.centerForCoordinate(coordinate);
    if (result == null) {
      return null;
    }
    final offset =
        Vector2(0, LargeTileComponent.hexagonRadius * sqrt(3) / 2 + 10);
    return result - offset;
  }

  @override
  bool occupiesCoordinate(HexCoordinate coordinate) {
    return model.coordinates.contains(coordinate);
  }

  @override
  ComponentKey? get key => ComponentKey.named(model.key);

  @override
  set focused(bool value) {
    super.focused = value;
    model.focused = value;
  }

  @override
  void onMount() {
    super.onMount();
    coordinate = model.coordinate;
  }

  @override
  void onLoad() {
    super.onLoad();

    add(tileComponent = LargeTileComponent(
      image: model.image,
      borderColor: borderColor,
    )..center = size / 2);

    _healthComponent = HealthComponent(model: model)
      ..center = tileComponent.positionOf(LargeTileComponent.vertextAtIndex(1));
    _defenseComponent = DefenseComponent(model: model)
      ..center = tileComponent.positionOf(LargeTileComponent.vertextAtIndex(6));

    _numberComponent = TileNumberComponent(model: model);
    _numberComponent.center =
        tileComponent.positionOf(LargeTileComponent.vertextAtIndex(8));
  }

  final List<Effect> _flyingEffects = [];

  @override
  void update(double dt) {
    super.update(dt);
    if (focused) {
      _numberComponent.parent = this;
      _healthComponent.parent = this;
      _defenseComponent.parent = model.defense > 0 ? this : null;
      // Allow the effect to be seen
      final hasEffectBelow =
          model.coordinates.any((c) => game.mapModel.hasEffectAtCoordinate(c));
      tileComponent.opacity = hasEffectBelow ? 0.6 : 1.0;
    } else {
      _numberComponent.parent = null;
      _healthComponent.parent = null;
      _defenseComponent.parent = null;
      tileComponent.opacity = 1;
    }
    if (model.isFlying) {
      if (_flyingEffects.isEmpty) {
        _flyingEffects.addAll([
          MoveEffect.by(
              Vector2(0, -6),
              EffectController(
                duration: 0.75,
                curve: Curves.linear,
                reverseCurve: Curves.linear,
                reverseDuration: 0.75,
                infinite: true,
              )),
          SequenceEffect([
            MoveEffect.by(
              Vector2(4, 4),
              NoiseEffectController(
                duration: 2,
                taperingCurve: Curves.linear,
                noise: PerlinNoise(frequency: 2, seed: hashCode),
              ),
            )
          ], infinite: true),
        ]);
        addAll(_flyingEffects);
      }
    } else {
      if (_flyingEffects.isNotEmpty) {
        for (final effect in _flyingEffects) {
          effect.parent = null;
        }
        _flyingEffects.clear();
      }
    }
  }
}
