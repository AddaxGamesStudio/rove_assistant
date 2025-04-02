import 'package:flutter/material.dart';
import 'package:rove_app_common/style/rove_theme.dart';
import 'package:rove_app_common/widgets/common/rove_text.dart';
import 'package:rove_assistant/model/encounter_event.dart';
import 'package:rove_assistant/model/encounter_model.dart';
import 'package:rove_assistant/ui/rove_assets.dart';
import 'package:rove_app_common/widgets/common/rover_action_button.dart';
import 'package:rove_assistant/ui/widgets/encounter/events/event_panel.dart';
import 'package:rove_data_types/rove_data_types.dart';

class EncounterEventDrawPage extends StatefulWidget {
  final EncounterEvent event;
  final Function() onContinue;

  const EncounterEventDrawPage(
      {super.key, required this.event, required this.onContinue});

  @override
  State<EncounterEventDrawPage> createState() => _EncounterEventDrawPageState();
}

class _EncounterEventDrawPageState extends State<EncounterEventDrawPage> {
  EtherField? previousDrawnField;

  EncounterModel get model => widget.event.model;

  @override
  Widget build(BuildContext context) {
    var drawnField = model.drawRandomField();
    while (!model.isLastDraw && drawnField == previousDrawnField) {
      drawnField = model.drawRandomField();
    }
    previousDrawnField = drawnField;
    return EventPanel(
        event: widget.event,
        footer: Column(
          spacing: RoveTheme.verticalSpacing,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!model.isLastDraw)
              SizedBox(
                width: double.infinity,
                child: RoverActionButton(
                    color: widget.event.foregroundColor,
                    label: 'Redraw',
                    onPressed: () {
                      setState(() {});
                    }),
              ),
            SizedBox(
              width: double.infinity,
              child: RoverActionButton(
                  color: widget.event.foregroundColor,
                  label: 'Accept ${drawnField.label}',
                  onPressed: () {
                    model.consumeDrawnField(drawnField);
                    widget.onContinue();
                  }),
            )
          ],
        ),
        child: Column(
          spacing: RoveTheme.verticalSpacing,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
                child: Image.asset(RoveAssets.assetForEtherField(drawnField),
                    width: 150)),
            RoveText(widget.event.message),
          ],
        ));
  }
}
