import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/palette.dart';
import 'package:flame/text.dart';
import 'package:rove_simulator/flame/encounter/cards/augment_indicator_component.dart';
import 'package:rove_data_types/rove_data_types.dart';

class CardActionComponent extends PositionComponent {
  static final _descriptionTextPaint = TextPaint(
      style: TextStyle(
    fontSize: 18.0,
    color: BasicPalette.white.color,
  ));

  static final Paint _borderPaint = Paint()
    ..color = const Color(0xffdbaf58)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 4;

  static const double _padding = 6;
  bool focused = false;

  final RoveAction action;
  late PositionComponent _descriptionComponent;
  late List<AugmentIndicatorComponent> _augmentIndicatorComponents;

  CardActionComponent({required this.action, required double maxWidth}) {
    _descriptionComponent = TextBoxComponent(
        text: action.description,
        align: Anchor.center,
        boxConfig: TextBoxConfig(
          maxWidth: maxWidth,
        ),
        textRenderer: _descriptionTextPaint);
    _augmentIndicatorComponents = action.augments
        .map((a) => AugmentIndicatorComponent(
              action: action,
              augment: a,
            ))
        .toList();
    updateBounds();
  }

  updateBounds() {
    double maxAugmentWidth() {
      return _augmentIndicatorComponents
          .map((a) => a.size.x)
          .fold(0, (a, b) => max(a, b));
    }

    double augmentsHeight() {
      return _augmentIndicatorComponents
          .map((a) => _padding + a.size.y)
          .fold(0, (a, b) => a + b);
    }

    size = Vector2(max(_descriptionComponent.size.x, maxAugmentWidth()),
        _descriptionComponent.size.y + augmentsHeight());
  }

  @override
  void onLoad() {
    add(_descriptionComponent
      ..position = Vector2((size.x - _descriptionComponent.size.x) / 2, 0));
    var currentY = _descriptionComponent.size.y + _padding;
    for (final augmentIndicatorComponent in _augmentIndicatorComponents) {
      add(augmentIndicatorComponent
        ..position =
            Vector2((size.x - augmentIndicatorComponent.size.x) / 2, currentY));
      currentY += augmentIndicatorComponent.size.y + _padding;
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    if (focused) {
      final rect = RoundedRectangle.fromLTRBR(0, 0, size.x, size.y, 10);
      canvas.drawPath(rect.asPath(), _borderPaint);
    }
  }
}
