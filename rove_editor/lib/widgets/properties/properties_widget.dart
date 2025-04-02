import 'package:flutter/material.dart';
import 'package:rove_editor/flame/map_editor.dart';
import 'package:rove_editor/controller/editor_controller.dart';
import 'package:rove_editor/model/tiles/enemy_model.dart';
import 'package:rove_editor/widgets/properties/encounter_properties.dart';
import 'package:rove_editor/widgets/properties/enemy_class_properties.dart';
import 'package:rove_editor/widgets/properties/map_properties.dart';

class PropertiesWidget extends StatelessWidget {
  const PropertiesWidget({
    super.key,
    required this.editor,
  });

  final MapEditor editor;

  @override
  Widget build(BuildContext context) {
    final map = editor.model;
    final encounter = EditorController.instance.model;
    final mapComponent = editor.map;
    return ListenableBuilder(
        listenable: mapComponent,
        builder: (context, _) {
          final selectedCoordinate = mapComponent.selectedCoordinate;
          final selectedUnit =
              selectedCoordinate != null ? map.units[selectedCoordinate] : null;
          final enemySelected = selectedUnit is EnemyModel;
          final enemyClassModel = selectedUnit != null
              ? encounter.enemyClasses[selectedUnit.className]
              : null;

          return ListView(children: [
            EncounterProperties(
                key: ValueKey(encounter.key), encounter: encounter),
            MapProperties(map: map),
            if (enemySelected && enemyClassModel != null)
              EnemyClassProperties(model: enemyClassModel),
          ]);
        });
  }
}
