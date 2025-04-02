import 'package:flutter/material.dart';
import 'package:rove_simulator/flame/encounter_game.dart';

class InstructionWidget extends StatelessWidget {
  final EncounterGame game;

  static const String overlayName = 'instruction';

  const InstructionWidget({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: game,
        builder: (context, _) {
          return Center(
            child: SizedBox(
              width: 400,
              child: Text(
                game.instruction,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          );
        });
  }
}
