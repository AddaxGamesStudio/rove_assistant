import 'package:flutter/material.dart';
import 'package:rove_simulator/flame/encounter_game.dart';
import 'package:rove_simulator/model/encounter_model.dart';
import 'package:rove_simulator/widgets/encounter/units/unit_avatar_widget.dart';

class UnitsWidget extends StatelessWidget {
  final EncounterModel model;
  final EncounterGame game;

  const UnitsWidget({
    super.key,
    required this.model,
    required this.game,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: model,
        builder: (context, _) {
          final units = model.presentUnits;
          return Center(
            child: Wrap(
              direction: Axis.horizontal,
              spacing: 6,
              children: units
                  .map((unit) => UnitAvatarWidget(game: game, unit: unit))
                  .toList(),
            ),
          );
        });
  }
}
