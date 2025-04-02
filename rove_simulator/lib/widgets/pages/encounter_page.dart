import 'dart:ui';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:rove_simulator/assets.dart';
import 'package:rove_simulator/flame/encounter_game.dart';
import 'package:rove_simulator/model/player_extension.dart';
import 'package:rove_simulator/widgets/encounter/action_menu_widget.dart';
import 'package:rove_simulator/widgets/encounter/actions/trade_ether_widget.dart';
import 'package:rove_simulator/widgets/encounter/encounter_menu.dart';
import 'package:rove_simulator/widgets/encounter/progression/failure_dialog.dart';
import 'package:rove_simulator/widgets/encounter/start_encounter_widget.dart';
import 'package:rove_simulator/widgets/encounter/panels/encounter_objective_panel.dart';
import 'package:rove_simulator/widgets/encounter/event_log_widget.dart';
import 'package:rove_simulator/widgets/encounter/panels/lyst_panel.dart';
import 'package:rove_simulator/widgets/encounter/panels/menu_button_panel.dart';
import 'package:rove_simulator/widgets/encounter/reaction_menu.dart';
import 'package:rove_simulator/widgets/encounter/rovers/player_board.dart';
import 'package:rove_simulator/widgets/encounter/instruction_widget.dart';
import 'package:rove_simulator/widgets/encounter/skill_ether_selection_menu.dart';
import 'package:rove_simulator/widgets/encounter/progression/excess_ether_dialog.dart';
import 'package:rove_simulator/widgets/encounter/units/units_widget.dart';
import 'package:rove_data_types/rove_data_types.dart';

class EncounterPage extends StatelessWidget {
  const EncounterPage({
    super.key,
    required this.encounter,
    required this.players,
  });

  final EncounterDef encounter;
  final List<Player> players;

  @override
  Widget build(BuildContext context) {
    const double sideMargin = 24;
    const double verticalMargin = 24;

    final Map<String, OverlayWidgetBuilder<EncounterGame>> overlays = {
      MenuButtonPanel.overlayName: (context, game) =>
          Positioned(top: 0, left: 0, child: MenuButtonPanel(game: game)),
      EncounterMenu.overlayName: (context, game) =>
          Positioned.fill(child: EncounterMenu(game: game)),
      'objective': (context, game) => Positioned(
          top: 100,
          right: sideMargin,
          child: EncounterObjectivePanel(encounter: encounter)),
      'lyst': (context, game) => Positioned(
          top: 50, left: sideMargin, child: LystPanel(encounter: game.model)),
      EventLogWidget.overlayName: (context, game) => Positioned(
          bottom: 0, right: 0, child: EventLogWidget(game.model.log)),
      'action_menu': (content, game) {
        final cardResolver = game.cardResolver;
        return cardResolver != null
            ? Positioned(
                bottom: verticalMargin,
                left: 200,
                right: 200,
                child: ActionMenuWidget(controller: cardResolver))
            : const SizedBox.shrink();
      },
      'reaction_menu': (context, game) => Positioned(
          bottom: verticalMargin,
          left: 200,
          right: 200,
          child: ReactionMenu(game: game)),
      'skill_ether_selection_menu': (context, game) => Positioned(
          bottom: verticalMargin,
          left: 200,
          right: 200,
          child: SkillEtherSelectionMenu(game: game)),
      StartEncounterWidget.overlayName: (context, game) => Positioned(
          bottom: verticalMargin,
          left: 200,
          right: 200,
          child: StartEncounterWidget(game: game)),
      InstructionWidget.overlayName: (context, game) => Positioned(
          bottom: 120,
          left: 200,
          right: 200,
          child: InstructionWidget(game: game)),
      'units': (context, game) => Positioned(
          top: verticalMargin,
          left: sideMargin,
          right: sideMargin,
          child: UnitsWidget(game: game, model: game.model)),
      'trade_ether': (context, game) => Positioned.fill(
          child: TradeEtherWidget(controller: game.cardResolver!)),
      'excess_ether_dialog': (context, game) => Positioned.fill(
          child: ExceesEtherDialog(controller: game.turnController)),
      FailureDialog.overlayName: (context, game) =>
          Positioned.fill(child: FailureDialog(game: game)),
    };

    final game = EncounterGame(encounter: encounter, players: players);

    for (Player player in players) {
      overlays[player.boardOverlayName] = ((context, game) {
        final unit = game.model.unitForPlayer(player);
        assert(unit != null);
        if (unit == null) {
          return const SizedBox.shrink();
        }
        return Positioned(
            top: 100,
            left: sideMargin,
            child: PlayerBoard(key: GlobalKey(), game: game, player: unit));
      });
    }

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image:
                    ExactAssetImage(Assets.pathForEncounterMap(encounter.id)),
                fit: BoxFit.cover,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                decoration:
                    BoxDecoration(color: Colors.black.withValues(alpha: 0.3)),
              ),
            ),
          ),
          GameWidget(
            game: game,
            overlayBuilderMap: overlays,
            initialActiveOverlays: const [
              MenuButtonPanel.overlayName,
              'objective',
              'lyst',
              'units',
              'event_log'
            ],
          ),
        ],
      ),
    );
  }
}
