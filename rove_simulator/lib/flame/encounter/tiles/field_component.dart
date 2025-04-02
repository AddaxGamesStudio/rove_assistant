import 'dart:async';

import 'package:flame/components.dart';
import 'package:rove_simulator/assets.dart';
import 'package:rove_simulator/flame/encounter/coordinate_component.dart';
import 'package:rove_simulator/flame/encounter/map/map_component.dart';
import 'package:rove_simulator/model/tiles/field_model.dart';

class FieldComponent extends CoordinateComponent {
  final FieldModel model;

  FieldComponent({required this.model})
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
        sprite: Assets.fieldSprite(model.field),
        size: Vector2(size.x * 0.9, size.y * 0.9)));
  }
}
