import 'package:flutter/material.dart';
import 'package:input_quantity/input_quantity.dart';
import 'package:rove_data_types/rove_data_types.dart';
import 'package:rove_editor/editor_assets.dart';

class AffinitiesProperty extends StatelessWidget {
  final Function(Ether, int) onChanged;
  final Map<Ether, int> values;
  final String name;

  const AffinitiesProperty(
      {super.key,
      required this.name,
      required this.values,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          Text(name, style: TextStyle(fontSize: 12)),
          Wrap(
              runSpacing: 8,
              spacing: 8,
              direction: Axis.horizontal,
              children: Ether.values
                  .map((e) => Column(children: [
                        Image(
                            image: Assets.etherImage(e).image,
                            width: 16,
                            fit: BoxFit.fill),
                        InputQty.int(
                          qtyFormProps:
                              QtyFormProps(style: TextStyle(fontSize: 10)),
                          decoration: QtyDecorationProps(
                            btnColor: Colors.blue,
                            width: 8,
                            isBordered: false,
                          ),
                          initVal: values[e] ?? 0,
                          maxVal: 3,
                          minVal: -3,
                          onQtyChanged: (value) {
                            onChanged(e, value);
                          },
                        ),
                      ]))
                  .toList()),
        ],
      ),
    );
  }
}
