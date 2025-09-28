import 'package:flutter/material.dart';
import 'package:rove_assistant/theme/rove_palette.dart';
import 'package:rove_assistant/widgets/common/rove_icon.dart';
import 'package:rove_assistant/widgets/common/rove_text.dart';
import 'package:rove_data_types/rove_data_types.dart';
import 'action_list_widget.dart';
import 'augments/augment_container_widget.dart';
import 'multi_property_action_widget.dart';
import 'card_shadow.dart';

class CardActionWidget extends StatelessWidget {
  const CardActionWidget({
    super.key,
    required this.action,
    this.selected = false,
    required this.borderColor,
    required this.backgroundColor,
    required this.fontSize,
  });

  final RoveAction action;
  final bool selected;
  final Color borderColor;
  final Color backgroundColor;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final prefix = action.prefix;
    final suffix = action.staticDescription?.suffix;
    return Container(
      width: 250,
      decoration: BoxDecoration(
        border: selected
            ? Border.all(
                color: RovePalette.lyst,
                width: 2,
              )
            : null,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        spacing: 4,
        children: [
          if (prefix != null)
            CardShadow(
              child: RoveText(
                prefix,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: fontSize),
              ),
            ),
          actionWidget(action),
          if (action.augments.isNotEmpty)
            CardAugmentContainerWidget(
                action: action,
                borderColor: borderColor,
                backgroundColor: backgroundColor),
          if (suffix != null)
            CardShadow(
              child: RoveText(
                suffix,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: fontSize),
              ),
            ),
        ],
      ),
    );
  }

  StatelessWidget actionWidget(RoveAction action) {
    if (action.staticDescription?.body != null) {
      return defaultActionWidget(fontSize: fontSize);
    }
    final object = action.object;
    switch (action.type) {
      case RoveActionType.group:
        final firstAction = action.children.firstOrNull;
        assert(firstAction != null);
        return firstAction != null
            ? actionWidget(firstAction)
            : defaultActionWidget(fontSize: fontSize);
      case RoveActionType.command:
        return ActionListWidget(
          actions: action.children,
          actionBuilder: (_, __) => (true, null),
          borderColor: borderColor,
          backgroundColor: backgroundColor,
          fontSize: fontSize,
        );
      case RoveActionType.attack:
      case RoveActionType.buff:
      case RoveActionType.heal:
      case RoveActionType.push:
      case RoveActionType.pull:
      case RoveActionType.placeField:
        return MultiPropertyActionWidget(
          action: action,
          borderColor: borderColor,
          backgroundColor: backgroundColor,
          fontSize: fontSize,
        );
      case RoveActionType.infuseEther:
        return const CardShadow(child: RoveIcon('ether_dice', height: 25));
      case RoveActionType.generateEther:
        if (object != null) {
          return CardShadow(child: RoveIcon('generate_$object', height: 25));
        }
      default:
    }
    return defaultActionWidget(fontSize: fontSize * 1.4);
  }

  CardShadow defaultActionWidget({required double fontSize}) {
    return CardShadow(
      child: RoveText(
        textAlign: TextAlign.center,
        action.actionDescription,
        style: TextStyle(color: Colors.white, fontSize: fontSize),
      ),
    );
  }
}
