import 'package:flutter/material.dart';
import 'package:rove_assistant/widgets/util/color_extension.dart';
import 'package:rove_assistant/widgets/common/rove_text.dart';
import 'package:rove_data_types/rove_data_types.dart';
import 'augment_condition_widget.dart';
import '../card_shadow.dart';

class CardAugmentWidget extends StatelessWidget {
  const CardAugmentWidget({
    super.key,
    required this.action,
    required this.augment,
    required this.borderColor,
    required this.backgroundColor,
  });

  final RoveAction action;
  final ActionAugment augment;
  final Color borderColor;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: augment.condition.showAugmentCondition
            ? backgroundColor.darken(0.4)
            : null,
        borderRadius: BorderRadius.circular(6),
      ),
      child: IntrinsicHeight(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (augment.condition.showAugmentCondition)
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: backgroundColor.darken(0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: CardShadow(
                  child: AugmentConditionWidget(
                    condition: augment.condition,
                  ),
                ),
              ),
            Flexible(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 8.0, right: 8.0, top: 4, bottom: 4),
                  child: CardShadow(
                    child: RoveText(
                      textAlign: TextAlign.center,
                      augment.descriptionForAction(action),
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension on AugmentCondition {
  bool get showAugmentCondition {
    switch (type) {
      case AugmentConditionType.reactionTrigger:
      case AugmentConditionType.removeGlyph:
      case AugmentConditionType.allyAdjacentToTarget:
        return false;
      default:
    }
    return true;
  }
}
