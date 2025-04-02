import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rove_simulator/assets.dart';

class ReactionIndicatorWidget extends StatelessWidget {
  const ReactionIndicatorWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 14,
        width: 14,
        child: Transform.rotate(angle: -pi / 4, child: Assets.reactionImage()));
  }
}
