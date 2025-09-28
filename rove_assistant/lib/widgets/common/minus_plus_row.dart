import 'package:flutter/material.dart';

class MinusPlusRow extends StatelessWidget {
  final Widget child;
  final Color? color;
  final Function() onMinus;
  final Function() onPlus;

  const MinusPlusRow({
    super.key,
    this.color,
    required this.onMinus,
    required this.onPlus,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
            icon: Icon(
              Icons.remove,
              color: color,
            ),
            onPressed: onMinus),
        child,
        IconButton(
            icon: Icon(
              Icons.add,
              color: color,
            ),
            onPressed: onPlus),
      ],
    );
  }
}
