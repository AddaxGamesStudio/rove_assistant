import 'dart:async';

import 'package:flame/components.dart';
import 'package:rove_editor/editor_assets.dart';
import 'package:rove_editor/flame/encounter/coordinate_component.dart';
import 'package:rove_editor/flame/encounter/map/map_component.dart';
import 'package:rove_editor/model/tiles/glyph_model.dart';

class GlyphComponent extends CoordinateComponent {
  final GlyphModel model;
  late SpriteComponent _spriteComponent;

  GlyphComponent({required this.model})
      : super(priority: MapComponent.fieldPriority);

  @override
  ComponentKey? get key => ComponentKey.named(model.key);

  @override
  FutureOr<void> onLoad() {
    super.onLoad();

    _spriteComponent = SpriteComponent(
        sprite: Assets.glyphSprite(model.glyph), size: size * 0.85);
    addCentered(
        ClipComponent.circle(size: size * 0.85, children: [_spriteComponent]));
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (focused) {
      _spriteComponent.opacity =
          game.model.fieldAtCoordinate(coordinate) != null ? 0.5 : 1.0;
    } else {
      _spriteComponent.opacity = 1;
    }
  }
}
