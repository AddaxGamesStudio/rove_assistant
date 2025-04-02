import 'package:flutter/material.dart';
import 'package:input_quantity/input_quantity.dart';

class NumberProperty extends StatelessWidget {
  final Function(dynamic) onChanged;
  final int value;
  final String name;

  const NumberProperty(
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
          Text(name, style: TextStyle(fontSize: 12)),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 4),
              child: InputQty.int(
                qtyFormProps: QtyFormProps(
                  style: TextStyle(fontSize: 12),
                  enableTyping: true,
                ),
                decoration: QtyDecorationProps(
                  btnColor: Colors.blue,
                  isBordered: false,
                ),
                initVal: value,
                onQtyChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
