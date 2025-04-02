import 'package:flutter/material.dart';

class BooleanProperty extends StatelessWidget {
  final Function(bool) onChanged;
  final bool value;
  final String name;

  const BooleanProperty(
      {super.key,
      required this.name,
      required this.value,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: Row(
        spacing: 8,
        children: [
          Checkbox(
              value: value,
              onChanged: (value) {
                if (value != null) {
                  onChanged(value);
                }
              }),
          Expanded(child: Text(name, style: TextStyle(fontSize: 12))),
        ],
      ),
    );
  }
}
