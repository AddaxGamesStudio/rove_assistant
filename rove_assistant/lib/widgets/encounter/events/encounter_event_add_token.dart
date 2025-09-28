import 'package:flutter/material.dart';
import 'package:rove_assistant/model/encounter/encounter_event.dart';
import 'package:rove_assistant/model/players_model.dart';
import 'package:rove_assistant/theme/rove_theme.dart';
import 'package:rove_assistant/widgets/common/player_buttons.dart';
import 'package:rove_assistant/widgets/common/rove_dialog.dart';
import 'package:rove_assistant/widgets/common/rove_text.dart';
import 'package:rove_assistant/widgets/encounter/events/event_panel.dart';
import 'package:rove_data_types/rove_data_types.dart';

class EncounterEventAddToken extends StatelessWidget {
  final EncounterEvent event;
  final String token;
  final Function() onContinue;

  EncounterEventAddToken(
      {super.key, required this.event, required this.onContinue})
      : token = event.extra!;

  bool canAcceptToken(Player player) {
    final model = event.model;
    final encounterTokens = model.stateForPlayer(player).encounterTokens;
    final possibleTokens = model.possiblePlayerEncounterTokens;
    for (String token in encounterTokens) {
      possibleTokens.remove(token);
    }
    return possibleTokens.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final model = event.model;
    final canAnyPlayerAcceptToken =
        PlayersModel.instance.players.any(canAcceptToken);
    return EventPanel(
        event: event,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RoveText(event.message),
            RoveTheme.verticalSpacingBox,
            if (canAnyPlayerAcceptToken)
              PlayerButtons(
                  buttonLabelBuilder: (player) =>
                      'Send $token to ${player.name}',
                  whereTest: canAcceptToken,
                  onSelected: (player) {
                    model.setPlayerEncounterTokens(
                        player: player,
                        tokens: model.stateForPlayer(player).encounterTokens +
                            [token]);
                    onContinue();
                  }),
            if (!canAnyPlayerAcceptToken)
              Row(
                children: [
                  Spacer(),
                  RoveDialogActionButton(
                    color: event.foregroundColor,
                    title: 'Continue',
                    onPressed: onContinue,
                  ),
                ],
              ),
          ],
        ));
  }
}
