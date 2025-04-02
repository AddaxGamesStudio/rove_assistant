import 'package:flutter/material.dart';

class TextProperty extends StatefulWidget {
  final Function(String) onChanged;
  final String? value;
  final String name;
  final bool dense;

  const TextProperty(
      {super.key,
      required this.name,
      required this.value,
      required this.onChanged,
      this.dense = false});

  @override
  State<TextProperty> createState() => _TextPropertyState();
}

class _TextPropertyState extends State<TextProperty> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final value = widget.value;
    _controller = value != null
        ? TextEditingController.fromValue(TextEditingValue(text: value))
        : TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.dense) {
      return Padding(
        padding: const EdgeInsets.only(top: 8, left: 8.0, right: 8.0),
        child: Row(
          spacing: 8,
          children: [
            Text(widget.name, style: TextStyle(fontSize: 12)),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 8),
                ),
                controller: _controller,
                onChanged: widget.onChanged,
                style: TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
      );
    } else {}
    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 8.0, right: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.name,
            style: TextStyle(fontSize: 12),
          ),
          TextField(
            decoration: InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 8),
            ),
            controller: _controller,
            onChanged: widget.onChanged,
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
