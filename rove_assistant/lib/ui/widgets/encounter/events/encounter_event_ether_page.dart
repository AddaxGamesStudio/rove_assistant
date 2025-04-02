import 'package:flutter/material.dart';
import 'package:rove_app_common/style/rove_theme.dart';
import 'package:rove_app_common/widgets/common/rove_text.dart';
import 'package:rove_assistant/model/encounter_event.dart';
import 'package:rove_assistant/ui/rove_assets.dart';
import 'package:rove_assistant/ui/styles.dart';
import 'package:rove_assistant/ui/widgets/encounter/events/event_panel.dart';
import 'package:rove_data_types/rove_data_types.dart';

class EncounterEventEtherPage extends StatelessWidget {
  final EncounterEvent event;

  final Function() onContinue;

  const EncounterEventEtherPage(
      {super.key, required this.event, required this.onContinue});

  @override
  Widget build(BuildContext context) {
    final optionsValue = event.extra ?? '';
    final ethers = Ether.etherOptionsFromString(optionsValue);
    List<Widget> etherImages = ethers
        .map((e) => Padding(
            padding: const EdgeInsets.only(right: 8, left: 8),
            child: Image.asset(RoveAssets.assetForEther(e),
                width: 64, height: 64)))
        .toList();
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
            Row(children: [const Spacer(), ...etherImages, const Spacer()]),
            RoveText(event.message),
          ],
        ));
  }
}
