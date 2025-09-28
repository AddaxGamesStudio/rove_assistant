import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:rove_assistant/theme/rove_assets.dart';

class FigureReaction extends StatelessWidget {
  const FigureReaction({
    super.key,
    this.available = true,
  });

  final bool available;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24,
      child: Transform.rotate(
          angle: -math.pi / 4,
          child: Image.asset(RoveAssets.assetForIsReactionAvailable(available),
              width: 24)),
    );
  }
}
