import 'package:flutter/material.dart';
import 'package:rove_simulator/flame/encounter_game.dart';
import 'package:rove_simulator/model/tiles/enemy_model.dart';
import 'package:rove_simulator/model/encounter_model.dart';
import 'package:rove_simulator/model/tiles/player_unit_model.dart';
import 'package:rove_simulator/model/tiles/unit_model.dart';
import 'package:rove_simulator/widgets/encounter/units/reaction_indicator_widget.dart';
import 'package:rove_simulator/widgets/encounter/units/tile_number_widget.dart';
import 'package:rove_simulator/widgets/encounter/units/unit_defense_widget.dart';
import 'package:rove_simulator/widgets/encounter/units/unit_health_widget.dart';

class UnitAvatarWidget extends StatelessWidget {
  final EncounterGame game;
  final UnitModel unit;

  const UnitAvatarWidget({
    super.key,
    required this.game,
    required this.unit,
  });

  EncounterModel get model => game.model;
  Color get borderColor =>
      unit == model.currentTurnUnit || unit.focused ? Colors.white : unit.color;
  Color get colorFilterColor =>
      model.endedTurnUnits.contains(unit) || !unit.isTargetable
          ? Colors.grey.withValues(alpha: 0.5)
          : Colors.transparent;

  void onSelectedUnit(UnitModel unit) {
    if (unit is PlayerUnitModel) {
      game.onSelectedPlayer(unit);
    } else if (unit is EnemyModel) {
      game.onSelectedEnemy(unit);
    }
  }

  int get number => unit is EnemyModel ? (unit as EnemyModel).number : 0;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: unit,
        builder: (context, _) {
          final hasReaction = (unit is PlayerUnitModel)
              ? (unit as PlayerUnitModel).canPlayReaction
              : false;
          return Stack(children: [
            Container(
              width: 50,
              height: 75,
              decoration: BoxDecoration(
                  border: Border.all(color: borderColor, width: 2)),
              child: GestureDetector(
                onTap: () => onSelectedUnit(unit),
                child: Container(
                  color: Colors.black,
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      colorFilterColor,
                      BlendMode.saturation,
                    ),
                    child: RawImage(image: unit.image, fit: BoxFit.cover),
                  ),
                ),
              ),
            ),
            if (hasReaction)
              const Positioned(
                top: 4,
                right: 4,
                child: ReactionIndicatorWidget(),
              ),
            if (number > 0)
              Positioned(
                  top: 4,
                  left: 4,
                  child: TileNumberWidget(
                    number: number,
                  )),
            if (unit.defense > 0)
              Positioned(
                  bottom: 4,
                  left: 4,
                  child: UnitDefenseWidget(defense: unit.defense)),
            Positioned(
                bottom: 4,
                right: 4,
                child: UnitHealthWidget(
                    health: unit.health,
                    maxHealth: unit.maxHealth,
                    minHealthColor: Colors.black))
          ]);
        });
  }
}
