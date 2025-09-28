import 'package:flutter/material.dart';
import 'package:rove_assistant/widgets/common/image_shadow.dart';

class CardShadow extends StatelessWidget {
  const CardShadow({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ImageShadow(
      sigma: 1,
      opacity: 0.5,
      offset: const Offset(1, 1),
      child: child,
    );
  }
}
