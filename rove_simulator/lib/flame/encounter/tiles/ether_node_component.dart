import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:rove_simulator/assets.dart';
import 'package:rove_simulator/flame/encounter/coordinate_component.dart';
import 'package:rove_simulator/flame/encounter/map/map_component.dart';
import 'package:rove_simulator/model/tiles/ether_node_model.dart';

class EtherNodeComponent extends CoordinateComponent {
  final EtherNodeModel model;

  EtherNodeComponent({required this.model})
      : super(priority: MapComponent.glyphPriority);

  @override
  ComponentKey? get key => ComponentKey.named(model.key);

  @override
  void onMount() {
    super.onMount();
    coordinate = model.coordinate;
  }

  @override
  FutureOr<void> onLoad() {
    super.onLoad();

    addCentered(SpriteComponent(
        sprite: Assets.etherSprite(model.ether),
        size: Vector2(size.x * 0.4, size.y * 0.4))
      ..add(RotateEffect.by(-pi / 4, EffectController(duration: 0))));
  }
}
