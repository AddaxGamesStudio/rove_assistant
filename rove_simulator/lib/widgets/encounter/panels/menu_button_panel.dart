import 'package:flutter/material.dart';
import 'package:rove_simulator/flame/encounter_game.dart';
import 'package:rove_app_common/style/rove_palette.dart';

class MenuButtonPanel extends StatelessWidget {
  const MenuButtonPanel({
    super.key,
    required this.game,
  });

  static const String overlayName = 'menu_button';

  final EncounterGame game;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 50,
        height: 50,
        child: Center(
          child: IconButton(
              color: RovePalette.title,
              onPressed: () {
                game.showMenu();
              },
              icon: const Icon(Icons.menu)),
        ));
  }
}
