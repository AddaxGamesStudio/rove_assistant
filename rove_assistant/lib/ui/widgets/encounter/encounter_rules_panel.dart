import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:rove_app_common/style/rove_palette.dart';
import 'package:rove_app_common/style/rove_theme.dart';
import 'package:rove_app_common/widgets/common/rove_text.dart';
import 'package:rove_assistant/model/encounter_event.dart';
import 'package:rove_assistant/model/encounter_model.dart';
import 'package:rove_assistant/ui/widgets/common/rove_icon.dart';
import 'package:rove_assistant/ui/widgets/encounter/encounter_panel.dart';
import 'package:rove_assistant/ui/widgets/encounter/events/encounter_events_dialog.dart';

class EncounterRulesPanel extends StatelessWidget {
  const EncounterRulesPanel({
    super.key,
    required this.model,
  });

  final EncounterModel model;

  @override
  Widget build(BuildContext context) {
    return EncounterPanel(
        title: 'Special Rules',
        icon: RoveIcon('special_rules'),
        foregroundColor: RovePalette.rulesForeground,
        backgroundColor: RovePalette.rulesBackground,
        child: ListenableBuilder(
            listenable: model,
            builder: (context, _) {
              return Wrap(
                  spacing: RoveTheme.horizontalSpacing,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: model.specialRules
                      .map((d) => TextButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    final ruleEvent = EncounterEvent.rules(
                                        model: model, title: d.$1, body: d.$2);
                                    return EncounterEventsDialog(
                                        events: [ruleEvent],
                                        onCompleted: () {
                                          Navigator.of(context).pop();
                                        });
                                  });
                            },
                            child: RoveText(
                              d.$1,
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ))
                      .map((w) => [
                            w,
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black,
                              ),
                              width: 6,
                              height: 6,
                            )
                          ])
                      .flattened
                      .toList()
                    ..removeLast());
            }));
  }
}
