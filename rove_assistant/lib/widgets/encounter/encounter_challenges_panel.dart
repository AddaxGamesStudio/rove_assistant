import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rove_assistant/model/encounter/encounter_model.dart';
import 'package:rove_assistant/theme/rove_palette.dart';
import 'package:rove_assistant/widgets/common/rove_icon.dart';
import 'package:rove_assistant/widgets/common/rove_text.dart';
import 'package:rove_assistant/widgets/encounter/encounter_panel.dart';

class EncounterChallengesPanel extends StatelessWidget {
  final EncounterModel model;

  const EncounterChallengesPanel({
    super.key,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: model,
        builder: (context, _) {
          int index = 0;
          List<Widget> challengeWidgets = [];
          for (String challenge in model.encounterDef.challenges) {
            int currentIndex = index;
            challengeWidgets.add(Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Stack(children: [
                    Container(
                      decoration: BoxDecoration(
                          color: RovePalette.challengesForeground,
                          borderRadius: BorderRadius.circular(6)),
                      width: 20,
                      height: 20,
                    ),
                    Positioned.fill(
                        child: Align(
                            alignment: Alignment.topCenter,
                            child: Text((index + 1).toString(),
                                style: GoogleFonts.grenze(
                                  color: Colors.white,
                                  height: 1,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                )))),
                  ]),
                  const SizedBox(width: 12),
                  Expanded(flex: 8, child: RoveText.body(challenge)),
                  Spacer(),
                  Checkbox(
                      checkColor: Colors.white,
                      fillColor: WidgetStateProperty.resolveWith((states) {
                        if (states.contains(WidgetState.selected)) {
                          return RovePalette.challengesForeground;
                        } else {
                          return null;
                        }
                      }),
                      value: model.encounterState.challenges[currentIndex],
                      onChanged: (bool? value) {
                        model.setChallengeValue(
                            index: currentIndex, value: value!);
                      }),
                ]));
            if (index < model.encounterDef.challenges.length - 1) {
              challengeWidgets.add(Divider(
                color: RovePalette.challengesForeground,
                thickness: 2,
              ));
              index++;
            }
          }

          return EncounterPanel(
              title: 'Challenges',
              foregroundColor: RovePalette.challengesForeground,
              backgroundColor: RovePalette.challengesBackground,
              icon: RoveIcon.small('challenges'),
              inWrap: true,
              child: ListenableBuilder(
                  listenable: model,
                  builder: (contex, _) {
                    return Column(
                      children: challengeWidgets,
                    );
                  }));
        });
  }
}
