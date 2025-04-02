import 'package:flutter/material.dart';
import 'package:rove_app_common/style/rove_theme.dart';
import 'package:rove_app_common/widgets/common/rove_text.dart';
import 'package:rove_assistant/model/encounter_model.dart';
import 'package:rove_app_common/style/rove_palette.dart';
import 'package:rove_assistant/ui/widgets/common/rove_icon.dart';
import 'package:rove_assistant/ui/widgets/encounter/encounter_panel.dart';
import 'package:rove_data_types/rove_data_types.dart';

class EncounterProgressionPanel extends StatelessWidget {
  final EncounterModel model;

  const EncounterProgressionPanel({
    super.key,
    required this.model,
  });

  Widget _buttonsForCodex(EncounterTrackerEventDef codex) {
    final milestone = codex.recordMilestone;
    final completed = (milestone != null && model.hasMilestone(milestone));
    return SizedBox(
        height: 36,
        child: Checkbox(
            checkColor: Colors.white,
            fillColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return RovePalette.codexForeground;
              } else {
                return null;
              }
            }),
            value: completed,
            onChanged: (bool? value) {
              if (completed) {
                return;
              }
              model.applyCodex(codex);
            }));
  }

  @override
  Widget build(BuildContext context) {
    return EncounterPanel(
        title: 'Progression',
        icon: RoveIcon('check'),
        foregroundColor: RovePalette.codexForeground,
        backgroundColor: RovePalette.codexBackground,
        child: ListenableBuilder(
            listenable: model,
            builder: (context, _) {
              int index = 0;
              List<Widget> widgets = [];
              final events = model.manualProgressionEvents;
              for (EncounterTrackerEventDef event in events) {
                widgets.add(Row(mainAxisSize: MainAxisSize.max, children: [
                  Expanded(
                    child: RoveText(event.title),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: RoveTheme.horizontalSpacing),
                    child: _buttonsForCodex(event),
                  ),
                ]));

                if (index < events.length - 1) {
                  widgets.add(Divider(
                    color: RovePalette.codexForeground,
                    thickness: 2,
                  ));
                  index++;
                }
              }
              return Column(
                children: widgets,
              );
            }));
  }
}
