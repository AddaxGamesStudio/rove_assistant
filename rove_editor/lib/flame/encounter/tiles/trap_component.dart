import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:rove_editor/flame/encounter/coordinate_component.dart';
import 'package:rove_editor/flame/encounter/map/map_component.dart';
import 'package:rove_editor/model/tiles/trap_model.dart';

class TrapComponent extends CoordinateComponent {
  final TrapModel model;

  TrapComponent({required this.model})
      : super(priority: MapComponent.trapPriority);

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
        sprite: Sprite(Flame.images.fromCache(model.image)),
        size: Vector2(size.x * 0.9, size.y * 0.9)));
  }
}
