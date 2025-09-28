import 'package:flutter/material.dart';
import 'package:rove_assistant/theme/rove_palette.dart';
import 'package:rove_assistant/theme/rove_theme.dart';
import 'package:rove_assistant/model/campaign_model.dart';
import 'package:rove_assistant/model/encounter/encounter_event.dart';
import 'package:rove_assistant/widgets/common/rove_dialog.dart';
import 'package:rove_assistant/widgets/common/rove_text.dart';
import 'package:rove_assistant/widgets/common/rover_action_button.dart';
import 'package:rove_assistant/widgets/encounter/events/event_panel.dart';

class EncounterEventMessagePage extends StatelessWidget {
  final EncounterEvent event;
  final Function() onContinue;

  const EncounterEventMessagePage(
      {super.key, required this.event, required this.onContinue});

  @override
  Widget build(BuildContext context) {
    final codex = event.codex;
    final artwork = event.artwork ?? codex?.artwork;
    final campaignDef = CampaignModel.instance.campaignDefinition;
    final artworkFigureDef =
        artwork != null ? campaignDef.figureDefinitionForName(artwork) : null;
    return EventPanel(
      event: event,
      footer: Column(
        children: [
          if (event.buttons.isEmpty)
            Row(
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
          if (codex?.subtitle != null)
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RoveText.subtitle('${codex?.subtitle}',
                    color: RovePalette.body),
                SizedBox(
                    width: double.infinity,
                    child: Divider(
                      color: RovePalette.body,
                      thickness: 2,
                      height: 0,
                    )),
              ],
            ),
          RoveText.body(event.message),
          if (artworkFigureDef != null)
            Padding(
              padding: const EdgeInsets.only(top: RoveTheme.verticalSpacing),
              child: ConstrainedBox(
                  constraints: BoxConstraints(
                      maxHeight: RoveTheme.dialogMaxWidth,
                      maxWidth: RoveTheme.dialogMaxWidth),
                  child: Image.asset(
                      campaignDef.pathForFigure(artworkFigureDef),
                      fit: BoxFit.cover)),
            )
        ],
      ),
    );
  }
}
