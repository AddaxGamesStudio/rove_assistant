import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rove_simulator/assets.dart';
import 'package:rove_simulator/flame/encounter_game.dart';
import 'package:rove_simulator/model/tiles/player_unit_model.dart';
import 'package:rove_simulator/model/tiles/summon_model.dart';
import 'package:rove_simulator/widgets/encounter/rovers/player_board_section_header.dart';
import 'package:rove_simulator/widgets/encounter/rovers/rover_ability_button.dart';

class SummonBoard extends StatelessWidget {
  final PlayerUnitModel player;
  final SummonModel summon;
  final EncounterGame game;

  const SummonBoard({
    super.key,
    required this.summon,
    required this.game,
    required this.player,
  });

  String get decorationString {
    final unplayedAbilityCount = summon.abilities
        .where((a) => !player.playedAbilities.contains(a.name))
        .length;
    final availableCount = player.endedTurn ? 0 : unplayedAbilityCount;
    return [
      ...List.generate(max(0, availableCount), (index) => '●'),
      ...List.generate(
          max(0, summon.abilities.length - availableCount), (index) => '○')
    ].join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8),
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: summon.color),
          image: DecorationImage(
              image:
                  AssetImage(Assets.pathForSummonImage(summon.imageFilename)),
              colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.dst),
              alignment: const Alignment(0, -0.5),
              fit: BoxFit.cover),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PlayerBoardSectionHeader(
                  title: summon.name, decoration: decorationString),
              const SizedBox(height: 8),
              Wrap(
                  direction: Axis.vertical,
                  crossAxisAlignment: WrapCrossAlignment.start,
                  spacing: 8,
                  children: summon.abilities
                      .map((a) => RoverAbilityButton(
                          key: GlobalKey(),
                          ability: a,
                          game: game,
                          player: player,
                          summon: summon))
                      .toList()),
            ],
          ),
        ),
      ),
    );
  }
}
