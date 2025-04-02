import 'package:flutter/material.dart';
import 'package:rove_simulator/controller/card_controller.dart';
import 'package:rove_simulator/flame/encounter_game.dart';
import 'package:rove_simulator/model/cards/skill_model.dart';
import 'package:rove_simulator/style/rove_theme.dart';

class SkillEtherSelectionMenu extends StatelessWidget {
  final EncounterGame game;

  const SkillEtherSelectionMenu({super.key, required this.game});

  SkillModel get model => game.model.activeSkill!;
  CardController get controller => game.cardController;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = game.model.currentPlayer?.backgroundColor;
    return ListenableBuilder(
        listenable: model,
        builder: (context, _) {
          return RoveThemeWidget(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Wrap(
                  spacing: 12,
                  direction: Axis.horizontal,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  alignment: WrapAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.undo),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: backgroundColor),
                      onPressed: () {
                        game.cardController.cancelSkill();
                      },
                      label: Text('Cancel ${model.name}'),
                    ),
                    if (model.isConfirmable)
                      ElevatedButton.icon(
                        icon: const Icon(Icons.check),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: backgroundColor),
                        onPressed: () {
                          game.cardController.confirmSkill();
                        },
                        label: Text('Confirm Ether for ${model.name}'),
                      ),
                  ],
                ),
              ],
            ),
          );
        });
  }
}
