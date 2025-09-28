import 'package:flutter/material.dart';
import 'package:rove_assistant/widgets/common/rove_text.dart';
import 'card_shadow.dart';
import 'triangle_widget.dart';

class ActionFlowSeparator extends StatelessWidget {
  final Color color;

  const ActionFlowSeparator({
    super.key,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return CardShadow(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ActionLine(color: color, width: 50),
          Container(
            // Flutter leaves a gap between containers due to antialiasing: github.com/flutter/flutter/issues/14288
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: color, width: 0)),
            ),
            child: TriangleWidget(
              color: color,
              direction: TriangleDirection.down,
              size: const Size(14, 4),
            ),
          ),
        ],
      ),
    );
  }
}

class ActionGroupSeparator extends StatelessWidget {
  final Color borderColor;
  final Color backgroundColor;

  const ActionGroupSeparator({
    super.key,
    required this.borderColor,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return CardShadow(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: ActionLine(color: borderColor, width: 180)),
          SizedBox(
            height: 20,
            width: 30,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(0),
                  disabledForegroundColor: Colors.white,
                  disabledBackgroundColor: backgroundColor,
                  shadowColor: Colors.transparent,
                  side: BorderSide(color: borderColor, width: 1),
                  shape: const BeveledRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                ),
                onPressed: null,
                child: const RoveText('or',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ))),
          ),
        ],
      ),
    );
  }
}

class ActionLine extends StatelessWidget {
  const ActionLine({
    super.key,
    required this.color,
    required this.width,
  });

  final Color color;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 2,
      width: width,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}

class IndependentActionSeparator extends StatelessWidget {
  final Color color;

  const IndependentActionSeparator({
    super.key,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return CardShadow(
      child: Row(
        spacing: 4,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ActionLine(color: color, width: 30),
          Container(
            height: 3,
            width: 3,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          Container(
            height: 4,
            width: 4,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          Container(
            height: 3,
            width: 3,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          ActionLine(color: color, width: 30),
        ],
      ),
    );
  }
}
