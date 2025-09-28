import 'package:flutter/material.dart';
import 'package:rove_assistant/widgets/util/color_extension.dart';
import 'package:rove_data_types/rove_data_types.dart';
import 'augment_widget.dart';
import '../triangle_widget.dart';

class CardAugmentContainerWidget extends StatelessWidget {
  const CardAugmentContainerWidget({
    super.key,
    required this.action,
    required this.borderColor,
    required this.backgroundColor,
  });

  final RoveAction action;
  final Color borderColor;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TriangleWidget(color: borderColor),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: backgroundColor.darken(0.7),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: borderColor,
              width: 1,
            ),
          ),
          child: IntrinsicWidth(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 4,
              children: action.augments
                  .map(
                    (augment) => CardAugmentWidget(
                      action: action,
                      augment: augment,
                      borderColor: borderColor,
                      backgroundColor: backgroundColor,
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
