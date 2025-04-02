import 'package:flutter/material.dart';
import 'package:rove_app_common/style/rove_theme.dart';
import 'package:rove_app_common/widgets/common/rove_text.dart';
import 'package:rove_assistant/model/encounter_event.dart';
import 'package:rove_assistant/ui/styles.dart';
import 'package:rove_app_common/widgets/common/rover_action_button.dart';
import 'package:rove_assistant/ui/widgets/encounter/events/event_panel.dart';

class EncounterEventMessagePage extends StatelessWidget {
  final EncounterEvent event;
  final Function() onContinue;

  const EncounterEventMessagePage(
      {super.key, required this.event, required this.onContinue});

  @override
  Widget build(BuildContext context) {
    final codex = event.codex;
    return EventPanel(
      event: event,
      footer: Column(
        children: [
          if (event.buttons.isEmpty)
            Row(
              children: [
                Spacer(),
                RoveStyles.compactDialogActionButton(
                  color: event.foregroundColor,
                  title: 'Continue',
                  onPressed: () {
                    onContinue();
                  },
                ),
              ],
            ),
          if (event.buttons.isNotEmpty)
            Column(
              spacing: RoveTheme.verticalSpacing,
              children: [
                ...event.buttons.map((b) {
                  return SizedBox(
                    width: double.infinity,
                    child: RoverActionButton(
                        color: event.foregroundColor,
                        label: b.title,
                        onPressed: () {
                          event.onComplete?.call(b);
                          onContinue();
                        }),
                  );
                })
              ],
            )
        ],
      ),
      child: Column(
        spacing: RoveTheme.verticalSpacing,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (codex != null && codex.isConclusion)
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RoveText.subtitle('Conclusion', color: Colors.black),
                SizedBox(
                    width: double.infinity,
                    child: Divider(
                      color: Colors.black,
                      thickness: 2,
                      height: 0,
                    )),
              ],
            ),
          RoveText(event.message),
        ],
      ),
    );
  }
}
