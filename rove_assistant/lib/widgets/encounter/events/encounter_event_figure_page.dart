import 'package:flutter/material.dart';
import 'package:rove_assistant/theme/rove_theme.dart';
import 'package:rove_assistant/model/encounter/encounter_event.dart';
import 'package:rove_assistant/widgets/common/rove_dialog.dart';
import 'package:rove_assistant/widgets/common/rove_text.dart';
import 'package:rove_assistant/widgets/encounter/events/event_panel.dart';
import 'package:rove_assistant/widgets/encounter/figure_hexagon.dart';

class EncounterEventFigurePage extends StatelessWidget {
  final EncounterEvent event;
  final Function() onContinue;

  const EncounterEventFigurePage(
      {super.key, required this.event, required this.onContinue});

  @override
  Widget build(BuildContext context) {
    return EventPanel(
        event: event,
        footer: Row(
          children: [
            Spacer(),
            RoveDialogActionButton(
              color: event.foregroundColor,
              title: 'Continue',
              onPressed: () {
                onContinue();
              },
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: RoveTheme.verticalSpacing,
          children: [
            RoveText(event.message),
            Center(
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 8,
                runSpacing: 8,
                children: event.figures
                    .map((e) => FigureHexagon.fromFigure(e))
                    .toList(),
              ),
            ),
          ],
        ));
  }
}
