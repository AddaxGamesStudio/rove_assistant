import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flame/text.dart';
import 'package:rove_simulator/flame/encounter/cards/card_component.dart';
import 'package:rove_simulator/model/cards/skill_model.dart';
import 'package:rove_simulator/model/tiles/unit_model.dart';
import 'package:rove_data_types/rove_data_types.dart';

class SkillCardComponent extends CardComponent {
  final SkillModel model;
  final UnitModel unit;
  final bool isOther;

  static final _descriptionTextPaint = TextPaint(
      style: TextStyle(
    fontSize: 18,
    color: BasicPalette.white.color,
  ));

  SkillCardComponent(
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
  String get costDescription =>
      isOther ? model.other.costDescription : model.current.costDescription;
  List<RoveAction> get actions =>
      isOther ? model.other.actions : model.current.actions;

  @override
  FutureOr<void> onLoad() {
    super.onLoad();

    {
      // Subtitle
      PositionComponent subtitleContainer = RectangleComponent.fromRect(
          Rect.fromLTWH(
              0, CardComponent.rowHeight, size.x, CardComponent.rowHeight),
          paint: bodyBackgroundPaint);

      subtitleContainer.add(RectangleComponent.fromRect(
          Rect.fromLTWH(
              0, 0, subtitleContainer.size.x, subtitleContainer.size.y),
          paint: Paint()
            ..style = PaintingStyle.fill
            ..color = BasicPalette.black.color.withValues(alpha: 0.5)));

      subtitleContainer.addCentered(TextComponent(
          text: costDescription, textRenderer: _descriptionTextPaint));

      add(subtitleContainer);
    }
    addActions(actions: actions);
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

  @override
  double get bodyHeight => size.y - CardComponent.rowHeight * 3;

  @override
  double get bodyY => CardComponent.rowHeight * 2;
}
