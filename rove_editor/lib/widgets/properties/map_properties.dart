import 'package:flutter/material.dart';
import 'package:rove_editor/model/editable_map_model.dart';
import 'package:rove_editor/widgets/properties/number_property.dart';
import 'package:rove_editor/widgets/properties/text_property.dart';

class MapProperties extends StatelessWidget {
  const MapProperties({
    super.key,
    required this.map,
  });

  final EditableMapModel map;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: map,
        builder: (context, _) {
          return ExpansionTile(
            key: ValueKey(map.name),
            title: Text('Map: ${map.name}',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            children: [
              TextProperty(
                  name: 'Id',
                  value: map.id,
                  onChanged: (value) {
                    map.id = value;
                  }),
              NumberProperty(
                  name: 'Offset X',
                  value: map.map.backgroundRect.left.toInt(),
                  onChanged: (value) {
                    map.backgroundX = value.toDouble();
                  }),
              NumberProperty(
                  name: 'Offset Y',
                  value: map.map.backgroundRect.top.toInt(),
                  onChanged: (value) {
                    map.backgroundY = value.toDouble();
                  }),
              NumberProperty(
                  name: 'Offset Width',
                  value: map.map.backgroundRect.width.toInt(),
                  onChanged: (value) {
                    map.backgroundWidth = value.toDouble();
                  }),
              NumberProperty(
                  name: 'Offset Height',
                  value: map.map.backgroundRect.height.toInt(),
                  onChanged: (value) {
                    map.backgroundHeight = value.toDouble();
                  })
            ],
          );
        });
  }
}
