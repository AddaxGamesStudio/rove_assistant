import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/palette.dart';
import 'package:flame/text.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rove_simulator/flame/encounter/cards/ability_card_component.dart';
import 'package:rove_simulator/flame/encounter/cards/action_flow_component.dart';
import 'package:rove_simulator/flame/encounter/cards/action_group_component.dart';
import 'package:rove_simulator/flame/encounter/cards/action_group_separator_component.dart';
import 'package:rove_simulator/flame/encounter/cards/card_action_component.dart';
import 'package:rove_simulator/flame/encounter/cards/item_card_component.dart';
import 'package:rove_simulator/flame/encounter/cards/reaction_card_component.dart';
import 'package:rove_simulator/flame/encounter/cards/skill_card_component.dart';
import 'package:rove_simulator/model/cards/ability_model.dart';
import 'package:rove_simulator/model/cards/card_model.dart';
import 'package:rove_simulator/model/cards/item_model.dart';
import 'package:rove_simulator/model/cards/reaction_model.dart';
import 'package:rove_simulator/model/cards/skill_model.dart';
import 'package:rove_simulator/model/tiles/unit_model.dart';
import 'package:rove_data_types/rove_data_types.dart';

abstract class CardComponent extends PositionComponent {
  static const double actionSpacing = 6;
  static const double rowHeight = 50;
  static final nameTextPaint = TextPaint(
      style: TextStyle(
    fontFamily: GoogleFonts.grenze().fontFamily,
    fontSize: 24.0,
    color: BasicPalette.white.color,
  ));

  late Paint titleBackgroundPaint;
  late Paint bodyBackgroundPaint;

  late PositionComponent titleContainer;
  late PositionComponent bodyContainer;

  final CardModel card;
  final Color titleBackgroundColor;
  final Color bodyBackgroundColor;
  final bool selectingGroup;
  final List<CardActionComponent> _actionComponents = [];

  String get title => card.title;

  CardComponent(
      {required this.card,
      required this.titleBackgroundColor,
      required this.bodyBackgroundColor,
      this.selectingGroup = false,
      super.size});

  double get bodyHeight;
  double get bodyY;

  @override
  FutureOr<void> onLoad() {
    super.onLoad();

    titleBackgroundPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = titleBackgroundColor;

    bodyBackgroundPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = bodyBackgroundColor;

    titleContainer = RectangleComponent.fromRect(
        Rect.fromLTWH(0, 0, size.x, rowHeight),
        paint: titleBackgroundPaint);

    titleContainer
        .addCentered(TextComponent(text: title, textRenderer: nameTextPaint));

    add(titleContainer);

    {
      // Body
      bodyContainer = RectangleComponent.fromRect(
          Rect.fromLTWH(0, bodyY, size.x, bodyHeight),
          paint: bodyBackgroundPaint);
      add(bodyContainer);
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final rect = RoundedRectangle.fromLTRBR(0, 0, size.x, size.y, 10);
    canvas.clipPath(rect.asPath());
  }

  List<PositionComponent> actionGroups = [];

  addActions(
      {required List<RoveAction> actions, double offsetY = actionSpacing}) {
    var currentGroupIndex = actions.isEmpty ? 0 : actions.first.exclusiveGroup;
    var currentGroupYStart = offsetY;
    var currentGroupYEnd = currentGroupYStart;
    int groups = 1;
    const double maxWidth = 280;
    for (int i = 0; i < actions.length; i++) {
      final action = actions[i];
      final actionComponent =
          CardActionComponent(action: action, maxWidth: maxWidth);
      actionComponent.position =
          Vector2((bodyContainer.size.x - actionComponent.size.x) / 2, offsetY);
      _actionComponents.add(actionComponent);
      bodyContainer.add(actionComponent);

      if (action.exclusiveGroup == currentGroupIndex) {
        currentGroupYEnd += actionComponent.y + actionComponent.height;
      } else if (action.exclusiveGroup != 0) {
        _addGroup(
            index: currentGroupIndex,
            yStart: currentGroupYStart,
            yEnd: currentGroupYEnd);

        groups++;

        currentGroupIndex = action.exclusiveGroup;
        currentGroupYStart = actionComponent.y;
        currentGroupYEnd = actionComponent.y + actionComponent.height;
      }

      offsetY += actionComponent.height + actionSpacing;

      if (i < actions.length - 1) {
        final nextGroup = actions[i + 1].exclusiveGroup;
        final bool willChangeGroup =
            nextGroup != 0 && nextGroup != currentGroupIndex;
        final separator = willChangeGroup
            ? ActionGroupSeparatorComponent()
            : ActionFlowComponent(
                requiresPrevious: actions[i + 1].requiresPrevious);
        bodyContainer.add(separator
          ..position =
              Vector2((bodyContainer.size.x - separator.size.x) / 2, offsetY));
        offsetY += separator.height + actionSpacing;
      }
    }

    if (groups > 1 && actionGroups.length != groups) {
      _addGroup(
          index: currentGroupIndex,
          yStart: currentGroupYStart,
          yEnd: currentGroupYEnd);
    }
  }

  _addGroup(
      {required int index, required double yStart, required double yEnd}) {
    final actionGroup = ActionGroupComponent(
        index: index,
        selecting: selectingGroup,
        size: Vector2(280, yEnd - yStart))
      ..position = Vector2((bodyContainer.size.x - 280) / 2, yStart);
    bodyContainer.add(actionGroup);
    actionGroups.add(actionGroup);
  }

  @override
  void update(double dt) {
    super.update(dt);
    for (int i = 0; i < _actionComponents.length; i++) {
      final actionComponent = _actionComponents[i];
      actionComponent.focused = card.currentActionIndex == i;
    }
  }

  static PositionComponent fromCard(
      {required CardModel card,
      required UnitModel unit,
      bool selectingGroup = false}) {
    if (card is AbilityModel) {
      return AbilityCardComponent(
          ability: card, unit: unit, selectingGroup: selectingGroup);
    } else if (card is ReactionModel) {
      return ReactionCardComponent(
          model: card, unit: unit, selectingGroup: selectingGroup);
    } else if (card is SkillModel) {
      return SkillCardComponent(
          model: card, unit: unit, selectingGroup: selectingGroup);
    } else if (card is ItemModel) {
      return ItemCardComponent(item: card);
    }
    throw UnimplementedError('Unknown card model type: $card');
  }
}

extension AddCentered on PositionComponent {
  PositionComponent addCentered(PositionComponent component) {
    component.center = Vector2(0.5 * size.x, 0.5 * size.y);
    add(component);
    return component;
  }
}
