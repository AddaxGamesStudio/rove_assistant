import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rove_simulator/assets.dart';
import 'package:rove_simulator/flame/encounter_game.dart';
import 'package:rove_simulator/model/tiles/player_unit_model.dart';
import 'package:rove_simulator/widgets/encounter/rovers/ether_pool_widget.dart';
import 'package:rove_simulator/widgets/encounter/rovers/player_board_section_header.dart';
import 'package:rove_simulator/widgets/encounter/rovers/rover_items_widget.dart';
import 'package:rove_simulator/widgets/encounter/rovers/rover_ability_button.dart';
import 'package:rove_simulator/widgets/encounter/rovers/rover_button.dart';
import 'package:rove_simulator/widgets/encounter/rovers/rover_reaction_button.dart';
import 'package:rove_simulator/widgets/encounter/rovers/rover_skill_button.dart';
import 'package:rove_simulator/widgets/encounter/rovers/summon_board.dart';
import 'package:rove_data_types/rove_data_types.dart';

class PlayerBoard extends StatelessWidget {
  final EncounterGame game;
  final PlayerUnitModel player;
  final GlobalKey globalKey;

  const PlayerBoard({
    super.key,
    required this.game,
    required this.player,
  }) : globalKey = key as GlobalKey;

  String get abilitiesString {
    final availableCount = player.endedTurn ? 0 : player.availableAbilityCount;
    return [
      ...List.generate(max(0, availableCount), (index) => '●'),
      ...List.generate(
          max(0, PlayerUnitModel.abilitiesPerTurnCount - availableCount),
          (index) => '○')
    ].join(' ');
  }

  String get reactionsString {
    final availableCount = player.availableReactionCount;
    return [
      ...List.generate(max(0, availableCount), (index) => '●'),
      ...List.generate(
          max(0, PlayerUnitModel.reactionsPerRound - availableCount),
          (index) => '○')
    ].join(' ');
  }

  String get skillsString {
    final availableCount = player.endedTurn ? 0 : player.availableSkillCount;
    return [
      ...List.generate(max(0, availableCount), (index) => '●'),
      ...List.generate(
          max(0, PlayerUnitModel.skillsPerTurnCount - availableCount),
          (index) => '○')
    ].join(' ');
  }

  onSelectedGeneralPoolEther(Ether ether, int index, bool selected) {
    game.cardController
        .onSelectedPersonalPoolEther(ether, index: index, selected: selected);
  }

  onSelectedInfusedPoolEther(Ether ether, int index, bool selected) {
    player.onSelectedInfusedEtherChanged(ether,
        index: index, selected: selected);
    final selectedEther = player.selectedInfusedEther;
    game.cardController.onSelectedInfusedEther(selectedEther);
  }

  onStartTurnPressed() {
    game.startTurnOfPlayer(player);
  }

  onEndTurnPressed() {
    game.endTurnOfPlayer(player);
  }

  bool get hasSummons => player.summons.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: player,
        builder: (context, _) {
          return Container(
            color: player.roverClass.colorDark.withValues(alpha: 0.25),
            child: Stack(children: [
              Positioned.fill(
                child: Opacity(
                  opacity: 0.5,
                  child: Image(
                      image: Assets.roverImage(player.roverClass).image,
                      fit: BoxFit.cover),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: RoverItemsWidget(
                          player: player, game: game, boardKey: globalKey),
                    ),
                    Column(
                      spacing: 4,
                      children: [
                        if (hasSummons)
                          ...player.summons.map((s) => SummonBoard(
                              summon: s, player: player, game: game)),
                        PlayerBoardSectionHeader(
                            title: 'Abilities', decoration: abilitiesString),
                        Padding(
                          padding: const EdgeInsets.only(left: 8, right: 8),
                          child: Wrap(
                              direction: Axis.vertical,
                              crossAxisAlignment: WrapCrossAlignment.start,
                              spacing: 8,
                              children: player.abilities
                                  .map((a) => RoverAbilityButton(
                                      key: GlobalKey(),
                                      ability: a,
                                      game: game,
                                      player: player))
                                  .toList()),
                        ),
                        PlayerBoardSectionHeader(
                            title: 'Skills', decoration: skillsString),
                        Padding(
                          padding: const EdgeInsets.only(left: 8, right: 8),
                          child: Wrap(
                              direction: Axis.vertical,
                              crossAxisAlignment: WrapCrossAlignment.start,
                              spacing: 8,
                              children: player.skills
                                  .map((s) => RoverSkillButton(
                                      key: GlobalKey(),
                                      skill: s,
                                      game: game,
                                      player: player))
                                  .toList()),
                        ),
                        PlayerBoardSectionHeader(
                            title: 'Reactions', decoration: reactionsString),
                        Padding(
                          padding: const EdgeInsets.only(left: 8, right: 8),
                          child: Wrap(
                              direction: Axis.vertical,
                              crossAxisAlignment: WrapCrossAlignment.start,
                              spacing: 8,
                              children: player.reactions
                                  .map((r) => RoverReactionButton(
                                      key: GlobalKey(),
                                      reaction: r,
                                      game: game,
                                      player: player))
                                  .toList()),
                        ),
                        const PlayerBoardSectionHeader(
                          title: 'Ether',
                          decoration: '',
                        ),
                        Row(
                          children: [
                            RotatedBox(
                                quarterTurns: 3,
                                child: Text(
                                  'Personal Pool',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily:
                                          GoogleFonts.grenze().fontFamily,
                                      fontSize: 12),
                                )),
                            SizedBox(
                              width: 50,
                              height: 70,
                              child: Center(
                                child: EtherPoolWidget(
                                    ether: player.personalEtherPool,
                                    isSelectedAtIndex: (index) => player
                                        .isSelectedPersonalPoolEtherAtIndex(
                                            index),
                                    onSelectedEther: (ether, index, selected) =>
                                        onSelectedGeneralPoolEther(
                                            ether, index, selected)),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Container(
                                width: 1, height: 40, color: Colors.white),
                            const SizedBox(
                              width: 10,
                            ),
                            SizedBox(
                                width: 50,
                                height: 70,
                                child: Center(
                                    child: EtherPoolWidget(
                                        ether: player.infusedEtherPool,
                                        isSelectedAtIndex: (index) => player
                                            .isSelectedInfusedEtherAtIndex(
                                                index),
                                        onSelectedEther:
                                            onSelectedInfusedPoolEther))),
                            RotatedBox(
                                quarterTurns: 3,
                                child: Text(
                                  'Infused',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily:
                                          GoogleFonts.grenze().fontFamily,
                                      fontSize: 12),
                                )),
                          ],
                        ),
                        if (game.model.canStartTurnForPlayer(player))
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: SizedBox(
                              width: 150,
                              height: 32,
                              child: RoverButton(
                                  label: 'Start Turn',
                                  roverClass: player.roverClass,
                                  onPressed: onStartTurnPressed),
                            ),
                          ),
                        if (game.model.canEndTurnForPlayer(player))
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: SizedBox(
                              width: 150,
                              height: 32,
                              child: RoverButton(
                                  label: 'End Turn',
                                  roverClass: player.roverClass,
                                  disabled: game.cardController.isPlayingCard,
                                  onPressed: onEndTurnPressed),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ]),
          );
        });
  }
}
