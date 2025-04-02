import 'package:flutter/material.dart';
import 'package:rove_app_common/style/rove_theme.dart';
import 'package:rove_app_common/widgets/common/rove_text.dart';
import 'package:rove_assistant/model/encounter_event.dart';
import 'package:rove_app_common/style/rove_palette.dart';
import 'package:rove_assistant/ui/rove_assets.dart';
import 'package:rove_app_common/widgets/common/rover_action_button.dart';
import 'package:rove_assistant/ui/widgets/encounter/events/event_panel.dart';
import 'package:rove_data_types/rove_data_types.dart';

class EncounterXulcDrawPage extends StatefulWidget {
  final EncounterEvent event;
  final Function() onContinue;

  const EncounterXulcDrawPage(
      {super.key, required this.event, required this.onContinue});

  @override
  State<EncounterXulcDrawPage> createState() => _EncounterXulcDrawPageState();
}

class _EncounterXulcDrawPageState extends State<EncounterXulcDrawPage> {
  XulcDieSide? previousDraw;

  EncounterEvent get event => widget.event;

  @override
  Widget build(BuildContext context) {
    var draw = XulcDieSide.randomSide();
    while (draw == previousDraw) {
      draw = XulcDieSide.randomSide();
    }
    previousDraw = draw;
    final bool isBlank = draw.isBlank;
    return EventPanel(
        event: event,
        footer: Column(
          spacing: RoveTheme.verticalSpacing,
          children: [
            SizedBox(
              width: double.infinity,
              child: RoverActionButton(
                  color: RovePalette.xulc,
                  label: 'Redraw',
                  onPressed: () {
                    setState(() {});
                  }),
            ),
            SizedBox(
              width: double.infinity,
              child: RoverActionButton(
                  color: RovePalette.xulc,
                  label: 'Accept ${draw.label}',
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
            if (!isBlank)
              Center(
                  child: Image.asset(
                RoveAssets.assetForXulcDie(draw),
                height: 100,
                color: RovePalette.xulc,
              )),
            if (event.message.isNotEmpty) RoveText(event.message),
            if (isBlank)
              SizedBox(
                height: 100,
                child: Center(
                  child: Text(
                    'You drew blank.',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ));
  }
}
