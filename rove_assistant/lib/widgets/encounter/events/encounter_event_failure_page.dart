import 'package:flutter/material.dart';
import 'package:rove_assistant/theme/rove_theme.dart';
import 'package:rove_assistant/model/encounter/encounter_event.dart';
import 'package:rove_assistant/model/encounter/encounter_model.dart';
import 'package:rove_assistant/theme/rove_palette.dart';
import 'package:rove_assistant/widgets/common/rove_text.dart';
import 'package:rove_assistant/widgets/common/rover_action_button.dart';
import 'package:rove_assistant/widgets/encounter/events/event_panel.dart';

class EncounterEventFailurePage extends StatelessWidget {
  final EncounterEvent event;
  final Function() onContinue;

  const EncounterEventFailurePage(
      {super.key, required this.event, required this.onContinue});

  EncounterModel get model => event.model;

  @override
  Widget build(BuildContext context) {
    return EventPanel(
        event: event,
        footer: Column(
          spacing: RoveTheme.verticalSpacing,
          children: [
            if (event.extra == EncounterEvent.extraFailedWithRewards)
              SizedBox(
                width: double.infinity,
                child: RoverActionButton(
                    color: RovePalette.lossForeground,
                    label: 'Continue',
                    onPressed: () {
                      onContinue();
                      model.fail();
                    }),
              ),
            SizedBox(
              width: double.infinity,
              child: RoverActionButton(
                  color: RovePalette.lossForeground,
                  label: 'Retry Encounter',
                  onPressed: () {
                    model.restart();
                    onContinue();
                  }),
            )
          ],
        ),
        child: Column(
          spacing: RoveTheme.verticalSpacing,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RoveText(event.message),
          ],
        ));
  }
}
