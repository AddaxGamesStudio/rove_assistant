import 'package:flame/components.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rove_simulator/flame/encounter_game.dart';
import 'package:rove_simulator/model/tiles/player_unit_model.dart';
import 'package:rove_simulator/model/cards/skill_model.dart';

class RoverSkillButton extends StatelessWidget {
  const RoverSkillButton({
    super.key,
    required this.skill,
    required this.game,
    required this.player,
  }) : globalKey = key as GlobalKey;

  final EncounterGame game;
  final PlayerUnitModel player;
  final SkillModel skill;
  final GlobalKey globalKey;

  onEnter() {
    RenderBox box = globalKey.currentContext!.findRenderObject() as RenderBox;
    Offset offset = box.localToGlobal(Offset.zero); //this is global position
    final position = Vector2(offset.dx + box.size.width, offset.dy);
    game.cardPreviewController
        .showSkill(model: skill, player: player, position: position);
  }

  onExit() {
    game.cardPreviewController.hidePreview();
  }

  onEnterBack() {
    game.cardPreviewController.showOtherSideOfCard();
  }

  onExitBack() {
    game.cardPreviewController.hideOtherSideOfCard();
  }

  onDoubleTap() {
    if (game.turnController.startedEncounter && !kDebugMode) {
      return;
    }
    skill.flip();
    game.cardPreviewController.hidePreview();
    onEnter();
  }

  @override
  Widget build(BuildContext context) {
    final canPlay =
        player.canPlaySkill(skill) && game.model.currentTurnUnit == player;
    final Color color = canPlay ? player.colorDark : Colors.grey;
    final isFlippable = game.cardResolver?.isFlippableForSkill(skill) == true;
    return ListenableBuilder(
        listenable: skill,
        builder: (context, _) {
          return MouseRegion(
            onEnter: (event) => onEnter(),
            onExit: (event) => onExit(),
            child: GestureDetector(
              onDoubleTap: () {
                onDoubleTap();
              },
              onTap: () {
                if (canPlay || kDebugMode) {
                  game.onSelectedSkill(player: player, skill: skill);
                }
              },
              child: Container(
                width: 156,
                decoration: BoxDecoration(
                    border: Border.all(
                        width: isFlippable ? 4 : 1,
                        color: isFlippable
                            ? Colors.yellow.shade800
                            : player.roverClass.color)),
                child: Container(
                    color: color,
                    child: Row(
                      children: [
                        Container(
                          width: 99,
                          padding: const EdgeInsets.only(
                              top: 2, bottom: 2, left: 8, right: 8),
                          child: FittedBox(
                            alignment: Alignment.centerLeft,
                            fit: BoxFit.scaleDown,
                            child: Text(
                              skill.displayName,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: GoogleFonts.grenze().fontFamily,
                                  fontSize: 12),
                            ),
                          ),
                        ),
                        const Spacer(),
                        MouseRegion(
                          onEnter: (event) => onEnterBack(),
                          onExit: (event) => onExitBack(),
                          child: Container(
                            width: 49,
                            color: Colors.black.withValues(alpha: 0.5),
                            padding: const EdgeInsets.only(
                                top: 2, bottom: 2, left: 6, right: 6),
                            child: FittedBox(
                              alignment: Alignment.centerRight,
                              fit: BoxFit.scaleDown,
                              child: Text(
                                skill.other.name,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: GoogleFonts.grenze().fontFamily,
                                    fontSize: 12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
              ),
            ),
          );
        });
  }
}
