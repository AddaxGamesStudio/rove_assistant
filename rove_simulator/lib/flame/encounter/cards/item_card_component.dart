import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/palette.dart';
import 'package:rove_simulator/model/cards/item_model.dart';

class ItemCardComponent extends PositionComponent {
  final ItemModel item;
  SpriteComponent? _spriteComponent;
  final bool preview;
  static final _grayscalePaint = Paint()
    ..colorFilter =
        ColorFilter.mode(BasicPalette.gray.color, BlendMode.saturation);

  ItemCardComponent({required this.item, this.preview = false})
      : super(size: Vector2(360, 490));

  @override
  ComponentKey? get key =>
      ComponentKey.named('${item.name}${preview ? '.preview' : ''}');

  @override
  FutureOr<void> onLoad() {
    super.onLoad();
    final component = SpriteComponent(
        sprite: Sprite(item.image), size: Vector2(size.x, size.y));
    _spriteComponent = component;
    add(component);
  }

  @override
  void update(double dt) {
    super.update(dt);
    _spriteComponent?.sprite = Sprite(item.image);
    _spriteComponent?.paint = item.exhausted ? _grayscalePaint : Paint();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final rect = RoundedRectangle.fromLTRBR(0, 0, size.x, size.y, 12);
    canvas.clipPath(rect.asPath());
  }
}
