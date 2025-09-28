import 'package:flutter/material.dart';
import 'package:rove_assistant/widgets/util/color_extension.dart';
import 'package:rove_assistant/widgets/util/column_with_child_setting_width.dart';
import 'package:rove_assistant/widgets/common/rove_icon.dart';
import 'package:rove_assistant/widgets/common/rove_text.dart';
import 'package:rove_data_types/rove_data_types.dart';
import 'action_property_container.dart';
import 'card_aoe_widget.dart';
import 'card_shadow.dart';

class MultiPropertyActionWidget extends StatelessWidget {
  const MultiPropertyActionWidget({
    super.key,
    required this.action,
    required this.borderColor,
    required this.backgroundColor,
    required this.fontSize,
  });

  final RoveAction action;
  final Color borderColor;
  final Color backgroundColor;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final field = action.field;
    final aoe = action.aoe;
    final showRange = action.showRange;
    final childSettingWidthKey = GlobalKey();
    final showTargetRow = action.showNonAOETargetRow;
    final darkBackgroundColor = backgroundColor.darken(0.7);
    final showFieldOnOwnRow = action.type != RoveActionType.placeField;
    List<String> properties = [
      if (action.push > 0) 'push',
      if (action.pull > 0) 'pull',
      if (showTargetRow) 'target',
    ];
    Widget buildPush() {
      properties.remove('push');
      return _IconWithAmountContainer(
          actionIconName: 'push',
          backgroundColor: backgroundColor,
          fontSize: fontSize,
          amount: action.push);
    }

    Widget buildPull() {
      properties.remove('pull');
      return _IconWithAmountContainer(
          actionIconName: 'pull',
          backgroundColor: backgroundColor,
          fontSize: fontSize,
          amount: action.pull);
    }

    Widget buildTarget() {
      properties.remove('target');
      return _TargetContainer(
        backgroundColor: backgroundColor,
        fontSize: fontSize,
        action: action,
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 8,
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: darkBackgroundColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: borderColor,
              width: 1,
            ),
          ),
          child: IntrinsicWidth(
            child: ColumnWithChildSettingWidth(
              spacing: 4,
              childSettingWidthKey: childSettingWidthKey,
              children: [
                IntrinsicHeight(
                  child: Row(
                    key: childSettingWidthKey,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: 4,
                    children: [
                      Center(
                          child: Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: CardShadow(
                            child: RoveIcon(action.iconName, height: 20)),
                      )),
                      if (showRange)
                        ActionPropertyContainer(
                          backgroundColor: backgroundColor,
                          child: RoveText(
                            action.rangeDescription,
                            style: TextStyle(
                                color: Colors.white, fontSize: fontSize),
                          ),
                        ),
                      if (action.amount != 0)
                        ActionPropertyContainer(
                          backgroundColor: backgroundColor,
                          child: Row(
                            children: [
                              RoveText(
                                '[${action.amountKeyword}] ${action.amount}',
                                style: TextStyle(
                                    color: Colors.white, fontSize: fontSize),
                              ),
                              if (action.pierce)
                                Row(mainAxisSize: MainAxisSize.min, children: [
                                  VerticalDivider(
                                    color: darkBackgroundColor,
                                    thickness: 1,
                                    width: 8,
                                  ),
                                  const RoveIcon('ignore_defense', height: 20)
                                ]),
                            ],
                          ),
                        ),
                      if (field != null && !showFieldOnOwnRow)
                        ActionPropertyContainer(
                            backgroundColor: backgroundColor,
                            child: CardShadow(
                                child: RoveIcon(field.name, height: 25))),
                    ],
                  ),
                ),
                if (properties.contains('push')) buildPush(),
                if (properties.contains('pull')) buildPull(),
                if (field != null && showFieldOnOwnRow)
                  _FieldContainer(
                      backgroundColor: backgroundColor, field: field),
                if (properties.contains('target')) buildTarget(),
                if (aoe != null)
                  ActionPropertyContainer(
                    backgroundColor: backgroundColor,
                    child: CardShadow(
                      child: RoveText(
                        action.aoeTargetDescription,
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(color: Colors.white, fontSize: fontSize),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        if (aoe != null) CardAoeWidget(aoe: aoe),
      ],
    );
  }
}

class _FieldContainer extends StatelessWidget {
  const _FieldContainer({
    required this.backgroundColor,
    required this.field,
  });

  final Color backgroundColor;
  final EtherField field;

  @override
  Widget build(BuildContext context) {
    return ActionPropertyContainer(
      backgroundColor: backgroundColor,
      child: CardShadow(child: RoveIcon(field.name, height: 25)),
    );
  }
}

class _IconWithAmountContainer extends StatelessWidget {
  const _IconWithAmountContainer({
    required this.actionIconName,
    required this.backgroundColor,
    required this.fontSize,
    required this.amount,
  });

  final String actionIconName;
  final Color backgroundColor;
  final int amount;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return ActionPropertyContainer(
      backgroundColor: backgroundColor,
      child: RoveText(
        '[$actionIconName] $amount',
        style: TextStyle(color: Colors.white, fontSize: fontSize),
      ),
    );
  }
}

class _TargetContainer extends StatelessWidget {
  const _TargetContainer({
    required this.backgroundColor,
    required this.fontSize,
    required this.action,
  });

  final Color backgroundColor;
  final double fontSize;
  final RoveAction action;

  @override
  Widget build(BuildContext context) {
    return ActionPropertyContainer(
      backgroundColor: backgroundColor,
      child: RoveText(
        '[target] ${action.targetDescription}',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white, fontSize: fontSize),
      ),
    );
  }
}

extension on RoveAction {
  bool get showRange {
    switch (targetMode) {
      case RoveActionTargetMode.all:
      case RoveActionTargetMode.eventTarget:
      case RoveActionTargetMode.previous:
      case RoveActionTargetMode.eventActor:
        return false;
      default:
    }
    if (!isRangeAttack && range.$2 == 1 && range.$2 == range.$1) {
      return true;
      // return false;
    }
    if (range == RoveAction.anyRange) {
      return false;
    }
    switch (rangeOrigin) {
      case RoveActionRangeOrigin.armoroll:
      case RoveActionRangeOrigin.aerios:
        return false;
      default:
    }
    return true;
  }

  bool get showNonAOETargetRow {
    if (aoe != null) {
      return false;
    }
    switch (targetMode) {
      case RoveActionTargetMode.all:
      case RoveActionTargetMode.eventActor:
      case RoveActionTargetMode.eventTarget:
        return true;
      default:
    }
    final staticTargetDescription = staticDescription?.target;
    if (staticTargetDescription != null) {
      return true;
    }

    switch (type) {
      case RoveActionType.placeField:
      case RoveActionType.createTrap:
        return false;
      default:
    }

    switch (polarity) {
      case RoveActionPolarity.positive:
        switch (targetKind) {
          case TargetKind.allyOrGlyph:
          case TargetKind.glyph:
          case TargetKind.self:
          case TargetKind.ally:
          case TargetKind.selfOrEventActor:
          case TargetKind.enemy:
            return true;
          case TargetKind.selfOrAlly:
            return targetCount > 1;
        }

      case RoveActionPolarity.negative:
        switch (targetKind) {
          case TargetKind.ally:
          case TargetKind.allyOrGlyph:
          case TargetKind.glyph:
          case TargetKind.self:
          case TargetKind.selfOrAlly:
          case TargetKind.selfOrEventActor:
            return true;
          case TargetKind.enemy:
            return targetCount > 1;
        }
      case RoveActionPolarity.neutral:
        return false;
    }
  }

  String get iconName {
    switch (type) {
      case RoveActionType.attack:
        return isRangeAttack ? 'r_attack' : 'm_attack';
      case RoveActionType.heal:
        return 'recover';
      case RoveActionType.buff:
      case RoveActionType.placeField:
        switch (polarity) {
          case RoveActionPolarity.positive:
            return 'positive_ability';
          case RoveActionPolarity.neutral:
            return 'positive_ability';
          case RoveActionPolarity.negative:
            return 'negative_ability';
        }
      case RoveActionType.push:
      case RoveActionType.pull:
        return 'negative_ability';
      default:
        return 'm_attack';
    }
  }

  String get amountKeyword {
    switch (type) {
      case RoveActionType.attack:
        return 'dmg';
      case RoveActionType.push:
        return 'push';
      case RoveActionType.pull:
        return 'pull';
      case RoveActionType.heal:
        return 'hp';
      case RoveActionType.buff:
        switch (buffType) {
          case BuffType.defense:
            return 'def';
          default:
            return 'def';
        }
      default:
        return 'dmg';
    }
  }
}
