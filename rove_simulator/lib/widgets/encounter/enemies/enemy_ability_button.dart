import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rove_simulator/flame/encounter_game.dart';
import 'package:rove_simulator/model/cards/ability_model.dart';
import 'package:rove_simulator/model/tiles/enemy_model.dart';

class EnemyAbilityButton extends StatelessWidget {
  const EnemyAbilityButton({
    super.key,
    required this.ability,
    required this.game,
    required this.enemy,
  }) : globalKey = key as GlobalKey;

  final EncounterGame game;
  final EnemyModel enemy;
  final AbilityModel ability;
  final GlobalKey globalKey;

  onFocused() {
    RenderBox box = globalKey.currentContext!.findRenderObject() as RenderBox;
    Offset offset = box.localToGlobal(Offset.zero);
    final position = Vector2(offset.dx + box.size.width, offset.dy);
    game.cardPreviewController
        .showEnemyAbility(ability: ability, enemy: enemy, position: position);
  }

  bool get isCurrent =>
      ability.name == game.model.currentAbilityForEnemy(enemy).name;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) => onFocused(),
      onExit: (event) => game.cardPreviewController.hidePreview(),
      child: Container(
        width: 150,
        decoration: BoxDecoration(border: Border.all(color: Colors.white)),
        child: Container(
            padding:
                const EdgeInsets.only(top: 2, bottom: 2, left: 8, right: 8),
            color: enemy.color,
            child: Row(
              children: [
                Text(
                  ability.name,
                  style: TextStyle(
                      fontFamily: GoogleFonts.grenze().fontFamily,
                      color: Colors.white,
                      fontSize: 12),
                ),
                if (isCurrent) const Spacer(),
                if (isCurrent)
                  Text(
                    '●',
                    style: TextStyle(
                        fontFamily: GoogleFonts.grenze().fontFamily,
                        color: Colors.white,
                        fontSize: 12),
                  )
              ],
            )),
      ),
    );
  }
}
