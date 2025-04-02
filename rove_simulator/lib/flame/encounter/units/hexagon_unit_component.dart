import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/geometry.dart';
import 'package:flame_noise/flame_noise.dart';
import 'package:flutter/material.dart';
import 'package:rove_simulator/flame/encounter/coordinate_component.dart';
import 'package:rove_simulator/flame/encounter/map/map_component.dart';
import 'package:rove_simulator/flame/encounter/units/defense_component.dart';
import 'package:rove_simulator/flame/encounter/units/health_component.dart';
import 'package:rove_simulator/flame/encounter/units/hexagon_tile_component.dart';
import 'package:rove_simulator/flame/encounter/units/unit_component.dart';
import 'package:rove_simulator/flame/encounter_game.dart';
import 'package:rove_simulator/model/tiles/unit_model.dart';

abstract class HexagonUnitComponent extends CoordinateComponent
    with UnitComponent, HasGameRef<EncounterGame> {
  final UnitModel _model;
  late HexagonTileComponent tileComponent;
  late HealthComponent _healthComponent;
  late DefenseComponent _defenseComponent;

  HexagonUnitComponent({required UnitModel model})
      : _model = model,
        super(priority: MapComponent.unitPriority);

  Color get borderColor => _model.color;

  @override
  bool get isSlain => _model.isSlain;
  @override
  String get modelKey => _model.key;

  @override
  ComponentKey? get key => ComponentKey.named(_model.key);

  @override
  set focused(bool value) {
    super.focused = value;
    _model.focused = value;
  }

  @override
  void onMount() {
    super.onMount();
    coordinate = _model.coordinate;
  }

  @override
  void onLoad() {
    super.onLoad();

    add(tileComponent = HexagonTileComponent(
      image: _model.image,
      borderColor: borderColor,
    )..center = size / 2);

    _healthComponent = HealthComponent(model: _model)
      ..center =
          tileComponent.positionOf(HexagonTileComponent.vertextAtIndex(1));
    _defenseComponent = DefenseComponent(model: _model)
      ..center =
          tileComponent.positionOf(HexagonTileComponent.vertextAtIndex(2));
  }

  final List<Effect> _flyingEffects = [];

  @override
  void update(double dt) {
    super.update(dt);
    if (focused) {
      _healthComponent.parent = this;
      _defenseComponent.parent = _model.defense > 0 ? this : null;
      // Allow the effect to be seen
      tileComponent.opacity =
          game.mapModel.hasEffectAtCoordinate(coordinate) ? 0.5 : 1.0;
    } else {
      _healthComponent.parent = null;
      _defenseComponent.parent = null;
      tileComponent.opacity = 1;
    }
    if (_model.isFlying) {
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

  Future<void> glowWithColor(Color color) async {
    const duration = 1.0;
    final completer = Completer<void>();
    final glowComponent = PolygonComponent(
      List.generate(6, (i) => HexagonTileComponent.vertextAtIndex(i)),
      position: position,
      anchor: anchor,
      paint: Paint()..color = color.withValues(alpha: 0.75),
    )
      ..add(ScaleEffect.by(
          Vector2(1.5, 1.5),
          EffectController(
              duration: duration / 2, reverseDuration: duration / 2)))
      ..add(RotateEffect.by(
          tau, EffectController(duration: duration, curve: Curves.easeIn)))
      ..add(
        GlowEffect(
          5,
          style: BlurStyle.normal,
          EffectController(
              duration: duration / 2, reverseDuration: duration / 2),
        ),
      )
      ..add(
        RemoveEffect(delay: duration, onComplete: () => completer.complete()),
      );
    parent!.add(glowComponent);
    return completer.future;
  }
}
