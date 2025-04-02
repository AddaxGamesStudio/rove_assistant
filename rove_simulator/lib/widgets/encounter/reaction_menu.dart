import 'package:flutter/material.dart';
import 'package:rove_simulator/controller/card_controller.dart';
import 'package:rove_simulator/flame/encounter_game.dart';
import 'package:rove_simulator/style/rove_theme.dart';

class ReactionMenu extends StatelessWidget {
  final EncounterGame game;

  const ReactionMenu({super.key, required this.game});

  CardController get controller => game.cardController;

  @override
  Widget build(BuildContext context) {
    final reactionPlayer = controller.reactionPlayer;
    final backgroundColor = reactionPlayer?.backgroundColor;
    return ListenableBuilder(
        listenable: controller,
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
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: backgroundColor),
                      onPressed: () {
                        controller.skipReaction();
                      },
                      child: Text('Skip ${reactionPlayer?.name} Reaction'),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }
}
