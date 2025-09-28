import 'package:flutter/material.dart';
import 'package:rove_assistant/theme/rove_palette.dart';
import 'package:rove_assistant/widgets/common/image_shadow.dart';
import 'package:rove_assistant/widgets/common/rove_text.dart';

class AffinityChip extends StatelessWidget {
  final int value;

  const AffinityChip(this.value, {super.key});

  String textForValue(int value) {
    if (value < 0) {
      return value.toString();
    } else if (value == 0) {
      return '+0';
    } else {
      return '+$value';
    }
  }

  Color colorForValue(int value) {
    if (value < 0) {
      return RovePalette.affinityNegative;
    } else if (value == 0) {
      return RovePalette.affinityNeutral;
    } else {
      return RovePalette.affinityPositive;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ImageShadow(
      child: SizedBox(
          height: 24,
          child: Container(
            width: 32,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                border: Border.all(color: Colors.white, width: 1),
                color: colorForValue(value)),
            child: Center(
                child:
                    RoveText.label(textForValue(value), color: Colors.white)),
          )),
    );
  }
}
