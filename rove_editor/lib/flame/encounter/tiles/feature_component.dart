import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flame/text.dart';
import 'package:rove_editor/flame/encounter/coordinate_component.dart';
import 'package:rove_editor/flame/encounter/map/map_component.dart';
import 'package:rove_editor/model/tiles/feature_model.dart';

class FeatureComponent extends CoordinateComponent {
  final FeatureModel model;
  static final nameTextPaint = TextPaint(
      style: TextStyle(
    fontSize: 12.0,
    color: BasicPalette.black.color,
  ));

  FeatureComponent({required this.model})
      : super(priority: MapComponent.featurePriority);

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

    addCentered(TextComponent(text: model.name, textRenderer: nameTextPaint));
  }
}
