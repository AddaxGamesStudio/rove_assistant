import 'package:flutter/material.dart';
import 'package:rove_assistant/widgets/util/color_extension.dart';
import 'package:rove_assistant/widgets/common/rove_icon.dart';
import 'card_shadow.dart';

class CardChannelWidget extends StatelessWidget {
  const CardChannelWidget({
    super.key,
    required this.borderColor,
    required this.backgroundColor,
  });

  final Color borderColor;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 250),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: backgroundColor.darken(0.7),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: borderColor,
            width: 1,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor.darken(0.4),
            borderRadius: BorderRadius.circular(6),
          ),
          child: IntrinsicHeight(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: backgroundColor.darken(0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const CardShadow(
                    child: RoveIcon(
                      'ether_dice',
                      height: 25,
                    ),
                  ),
                ),
                const Padding(
                  padding:
                      EdgeInsets.only(left: 8.0, right: 8.0, top: 4, bottom: 4),
                  child: CardShadow(
                    child: RoveIcon(
                      'generate_ether',
                      height: 25,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
