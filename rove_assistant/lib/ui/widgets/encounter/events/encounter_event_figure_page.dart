import 'package:flutter/material.dart';
import 'package:rove_app_common/style/rove_theme.dart';
import 'package:rove_app_common/widgets/common/rove_text.dart';
import 'package:rove_assistant/model/encounter_event.dart';
import 'package:rove_assistant/ui/styles.dart';
import 'package:rove_assistant/ui/widgets/encounter/events/event_panel.dart';
import 'package:rove_assistant/ui/widgets/encounter/figure_hexagon.dart';

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
            RoveStyles.compactDialogActionButton(
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
