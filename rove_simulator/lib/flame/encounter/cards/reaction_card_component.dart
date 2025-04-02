import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flame/text.dart';
import 'package:rove_simulator/flame/encounter/cards/card_component.dart';
import 'package:rove_simulator/model/cards/reaction_model.dart';
import 'package:rove_simulator/model/tiles/unit_model.dart';
import 'package:rove_data_types/rove_data_types.dart';

class ReactionCardComponent extends CardComponent {
  final ReactionModel model;
  final UnitModel unit;
  final bool isOther;

  static final _descriptionTextPaint = TextPaint(
      style: TextStyle(
    fontSize: 18,
    color: BasicPalette.white.color,
  ));

  ReactionCardComponent(
      {required this.model,
      required this.unit,
      super.selectingGroup,
      this.isOther = false})
      : super(
            card: model,
            titleBackgroundColor: unit.color,
            bodyBackgroundColor: unit.backgroundColor,
            size: Vector2(300, 480));

  @override
  String get title => isOther ? model.other.cardTitle : model.current.cardTitle;
  String get otherTitle =>
      isOther ? model.current.cardTitle : model.other.cardTitle;
  List<RoveAction> get actions =>
      isOther ? model.other.actions : model.current.actions;

  @override
  FutureOr<void> onLoad() {
    super.onLoad();
    {
      final triggerComponent = TextBoxComponent(
          text: model.current.trigger.description,
          align: Anchor.center,
          boxConfig: const TextBoxConfig(
            maxWidth: 280,
          ),
          textRenderer: _descriptionTextPaint);
      bodyContainer.add(triggerComponent
        ..position = Vector2(
            (bodyContainer.size.x - triggerComponent.size.x) / 2,
            CardComponent.actionSpacing));

      final offsetY = triggerComponent.position.y +
          triggerComponent.size.y +
          CardComponent.actionSpacing;
      addActions(actions: actions, offsetY: offsetY);

      {
        // Footer
        final footerContainer = RectangleComponent.fromRect(
            Rect.fromLTWH(0, size.y - CardComponent.rowHeight, size.x,
                CardComponent.rowHeight),
            paint: titleBackgroundPaint);

        footerContainer.addCentered(TextComponent(
            text: otherTitle, textRenderer: CardComponent.nameTextPaint));

        add(footerContainer);
      }
    }
  }

  @override
  double get bodyHeight => size.y - CardComponent.rowHeight * 2;

  @override
  double get bodyY => CardComponent.rowHeight;
}
