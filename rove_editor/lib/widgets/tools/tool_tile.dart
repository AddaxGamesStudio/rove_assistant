import 'package:flutter/material.dart';

class ToolTile extends StatelessWidget {
  final String title;
  final Color? tileColor;
  final bool selected;
  final Function() onTap;
  final Widget? leading;

  const ToolTile({
    super.key,
    required this.title,
    this.tileColor,
    required this.selected,
    required this.onTap,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(
          color: selected ? Colors.grey : Colors.transparent,
          width: selected ? 2 : 0,
        ),
      ),
      child: ListTile(
        leading: leading,
        title: Text(title, style: TextStyle(fontSize: 12)),
        tileColor: tileColor,
        selectedColor: Colors.grey,
        selected: selected,
        onTap: onTap,
      ),
    );
  }
}
