import 'package:flame/components.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rove_simulator/assets.dart';
import 'package:rove_simulator/flame/encounter_game.dart';
import 'package:rove_simulator/model/cards/ability_model.dart';
import 'package:rove_simulator/model/tiles/player_unit_model.dart';
import 'package:rove_simulator/model/tiles/summon_model.dart';
import 'package:rove_data_types/rove_data_types.dart';

class RoverAbilityButton extends StatelessWidget {
  const RoverAbilityButton({
    super.key,
    required this.ability,
    required this.game,
    required this.player,
    this.summon,
  }) : globalKey = key as GlobalKey;

  final EncounterGame game;
  final PlayerUnitModel player;
  final AbilityModel ability;
  final SummonModel? summon;
  final GlobalKey globalKey;

  onEnter() {
    RenderBox box = globalKey.currentContext!.findRenderObject() as RenderBox;
    Offset offset = box.localToGlobal(Offset.zero); //this is global position
    final position = Vector2(offset.dx + box.size.width, offset.dy);
    game.cardPreviewController
        .showAbility(ability: ability, player: player, position: position);
  }

  onExit() {
    game.cardPreviewController.hidePreview();
  }

  Ether? get augmentEther => ability.ability.augmentEther.firstOrNull;

  @override
  Widget build(BuildContext context) {
    final canPlay =
        player.canPlayAbility(ability) && game.model.currentTurnUnit == player;
    final Color color = canPlay ? player.colorDark : Colors.grey;
    return MouseRegion(
      onEnter: (event) => onEnter(),
      onExit: (event) => onExit(),
      child: GestureDetector(
        onTap: () {
          if (canPlay || kDebugMode) {
            game.onSelectedAbility(
                player: player, summon: summon, ability: ability);
          }
        },
        child: Container(
          width: 156,
          decoration:
              BoxDecoration(border: Border.all(color: player.roverClass.color)),
          child: Container(
              padding:
                  const EdgeInsets.only(top: 2, bottom: 2, left: 8, right: 8),
              color: color,
              child: Row(
                children: [
                  Text(
                    ability.name,
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: GoogleFonts.grenze().fontFamily,
                        fontSize: 12),
                  ),
                  const Spacer(),
                  if (augmentEther != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child:
                          _AugmentEther(player: player, ether: augmentEther!),
                    ),
                ],
              )),
        ),
      ),
    );
  }
}

class _AugmentEther extends StatelessWidget {
  const _AugmentEther({
    required this.player,
    required this.ether,
  });

  final PlayerUnitModel player;
  final Ether ether;

  bool get hasEther => player.personalEtherPool.contains(ether);

  @override
  Widget build(BuildContext context) {
    if (hasEther) {
      return _EtherIcon(ether: ether);
    } else {
      return Opacity(
        opacity: 0.5,
        child: Container(
            foregroundDecoration: const BoxDecoration(
              color: Colors.grey,
              backgroundBlendMode: BlendMode.saturation,
            ),
            child: _EtherIcon(ether: ether)),
      );
    }
  }
}

class _EtherIcon extends StatelessWidget {
  const _EtherIcon({
    required this.ether,
  });

  final Ether ether;

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: 16, height: 16, child: Assets.etherImage(ether));
  }
}
