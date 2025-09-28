import 'package:flutter/material.dart';
import 'package:rove_assistant/widgets/util/color_extension.dart';
import 'card_shadow.dart';

class ActionPropertyContainer extends StatelessWidget {
  const ActionPropertyContainer({
    super.key,
    required this.child,
    required this.backgroundColor,
  });

  final Widget child;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(top: 4, bottom: 4, left: 6, right: 6),
      decoration: BoxDecoration(
        color: backgroundColor.darken(0.4),
        borderRadius: BorderRadius.circular(6),
      ),
      child: CardShadow(
        child: child,
      ),
    );
  }
}
