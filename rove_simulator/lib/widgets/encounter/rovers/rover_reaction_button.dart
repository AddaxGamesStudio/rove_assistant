import 'package:flame/components.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rove_simulator/flame/encounter_game.dart';
import 'package:rove_simulator/model/cards/reaction_model.dart';
import 'package:rove_simulator/model/tiles/player_unit_model.dart';

class RoverReactionButton extends StatelessWidget {
  const RoverReactionButton({
    super.key,
    required this.reaction,
    required this.game,
    required this.player,
  }) : globalKey = key as GlobalKey;

  final EncounterGame game;
  final PlayerUnitModel player;
  final ReactionModel reaction;
  final GlobalKey globalKey;

  onEnter() {
    RenderBox box = globalKey.currentContext!.findRenderObject() as RenderBox;
    Offset offset = box.localToGlobal(Offset.zero); //this is global position
    final position = Vector2(offset.dx + box.size.width, offset.dy);
    game.cardPreviewController
        .showReaction(reaction: reaction, player: player, position: position);
  }

  onDoubleTap() {
    if (game.turnController.startedEncounter && !kDebugMode) {
      return;
    }
    reaction.flip();
    game.cardPreviewController.hidePreview();
    onEnter();
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

  @override
  Widget build(BuildContext context) {
    final canPlay = reaction.canPlay;
    final Color color = canPlay ? player.colorDark : Colors.grey;
    final isFlippable =
        game.cardResolver?.isFlippableForReaction(reaction) == true;
    return ListenableBuilder(
        listenable: reaction,
        builder: (context, _) {
          return MouseRegion(
            onEnter: (event) => onEnter(),
            onExit: (event) => onExit(),
            child: GestureDetector(
              onDoubleTap: () {
                onDoubleTap();
              },
              onTap: () {
                if (canPlay) {
                  game.onSelectedReaction(player: player, reaction: reaction);
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
                              reaction.name,
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
                                reaction.other.name,
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
