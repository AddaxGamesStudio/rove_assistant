import 'package:flutter/material.dart';
import 'package:rove_assistant/theme/rove_theme.dart';
import 'package:rove_assistant/model/encounter/encounter_event.dart';
import 'package:rove_assistant/theme/rove_palette.dart';
import 'package:rove_assistant/theme/rove_assets.dart';
import 'package:rove_assistant/widgets/common/rove_text.dart';
import 'package:rove_assistant/widgets/common/rover_action_button.dart';
import 'package:rove_assistant/widgets/encounter/events/event_panel.dart';
import 'package:rove_data_types/rove_data_types.dart';

class EncounterEventRollEtherPage extends StatefulWidget {
  final EncounterEvent event;
  final Function() onContinue;

  const EncounterEventRollEtherPage(
      {super.key, required this.event, required this.onContinue});

  @override
  State<EncounterEventRollEtherPage> createState() =>
      _EncounterEventRollEtherPageStage();
}

class _EncounterEventRollEtherPageStage
    extends State<EncounterEventRollEtherPage> {
  EtherDieSide? previousDraw;

  EncounterEvent get event => widget.event;

  @override
  Widget build(BuildContext context) {
    var draw = EtherDieSide.randomSide();
    while (draw == previousDraw) {
      draw = EtherDieSide.randomSide();
    }
    previousDraw = draw;
    return EventPanel(
        event: event,
        footer: Column(
          spacing: RoveTheme.verticalSpacing,
          children: [
            SizedBox(
              width: double.infinity,
              child: RoverActionButton(
                  color: RovePalette.title,
                  label: 'Redraw',
                  onPressed: () {
                    setState(() {});
                  }),
            ),
            SizedBox(
              width: double.infinity,
              child: RoverActionButton(
                  color: RovePalette.title,
                  label: 'Accept ${draw.name}',
                  onPressed: () {
                    event.onComplete?.call(draw);
                    widget.onContinue();
                  }),
            )
          ],
        ),
        child: Column(
          spacing: RoveTheme.verticalSpacing,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
                child: Image.asset(
              RoveAssets.assetForEtherDieSide(draw),
              height: 100,
            )),
            if (event.message.isNotEmpty) RoveText(event.message),
          ],
        ));
  }
}
