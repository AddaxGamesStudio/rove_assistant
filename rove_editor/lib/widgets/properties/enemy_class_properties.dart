import 'package:flutter/material.dart';
import 'package:rove_editor/model/tiles/editable_enemy_class_model.dart';
import 'package:rove_editor/widgets/properties/affinities_property.dart';
import 'package:rove_editor/widgets/properties/boolean_property.dart';
import 'package:rove_editor/widgets/properties/number_property.dart';
import 'package:rove_editor/widgets/properties/text_property.dart';

class EnemyClassProperties extends StatelessWidget {
  const EnemyClassProperties({
    super.key,
    required this.model,
  });

  final EditableEnemyClassModel model;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: model,
        builder: (context, _) {
          return ExpansionTile(
            key: ValueKey(model.name),
            title: Text('Enemy: ${model.name}',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            children: [
              AffinitiesProperty(
                  name: 'Affinities',
                  values: model.affinities,
                  onChanged: (ether, value) {
                    model.setAffinity(ether, value);
                  }),
              TextProperty(
                  name: 'Alias',
                  value: model.alias,
                  onChanged: (value) {
                    model.alias = value;
                  }),
              TextProperty(
                  name: 'Letter',
                  value: model.letter,
                  onChanged: (value) {
                    model.letter = value;
                  }),
              NumberProperty(
                  name: 'Health',
                  value: model.health ?? 0,
                  onChanged: (value) {
                    model.health = value;
                  }),
              TextProperty(
                  name: 'Health Formula',
                  value: model.healthFormula,
                  onChanged: (value) {
                    model.healthFormula = value;
                  }),
              NumberProperty(
                  name: 'Defense',
                  value: model.defense ?? 0,
                  onChanged: (value) {
                    model.defense = value;
                  }),
              TextProperty(
                  name: 'Defense Formula',
                  value: model.defenseFormula,
                  onChanged: (value) {
                    model.defenseFormula = value;
                  }),
              TextProperty(
                  name: 'Trait',
                  value: model.trait,
                  onChanged: (value) {
                    model.trait = value;
                  }),
              BooleanProperty(
                  name: 'Infected',
                  value: model.infected,
                  onChanged: (value) {
                    model.infected = value;
                  }),
              BooleanProperty(
                  name: 'Flies',
                  value: model.flies,
                  onChanged: (value) {
                    model.flies = value;
                  }),
              BooleanProperty(
                  name: 'Large',
                  value: model.large,
                  onChanged: (value) {
                    model.large = value;
                  }),
              BooleanProperty(
                  name: 'Respawns',
                  value: model.respawns,
                  onChanged: (value) {
                    model.respawns = value;
                  }),
              BooleanProperty(
                  name: 'Immune To Forced Movement',
                  value: model.immuneToForcedMovement,
                  onChanged: (value) {
                    model.immuneToForcedMovement = value;
                  }),
              BooleanProperty(
                  name: 'Immune To Teleport',
                  value: model.immuneToTeleport,
                  onChanged: (value) {
                    model.immuneToTeleport = value;
                  }),
              NumberProperty(
                  name: 'Reduce Push/Pull By',
                  value: model.reducePushPullBy,
                  onChanged: (value) {
                    model.reducePushPullBy = value;
                  }),
              TextProperty(
                  name: 'X Definition',
                  value: model.xDefinition,
                  onChanged: (value) {
                    model.xDefinition = value;
                  }),
            ],
          );
        });
  }
}
