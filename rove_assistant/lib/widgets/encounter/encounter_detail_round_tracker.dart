import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rove_assistant/theme/rove_palette.dart';
import 'package:rove_assistant/model/campaign_model.dart';
import 'package:rove_assistant/model/encounter/encounter_model.dart';
import 'package:rove_assistant/theme/rove_assets.dart';
import 'package:rove_assistant/widgets/common/rove_text.dart';
import 'package:rove_data_types/rove_data_types.dart';

class EncounterDetailRoundTracker extends StatelessWidget {
  final EncounterModel model;

  const EncounterDetailRoundTracker({
    super.key,
    required this.model,
  });

  Widget roundLimitText() {
    final int currentRoundLimit = model.roundLimit;
    final String data = currentRoundLimit == EncounterDef.noRoundLimit
        ? 'Round ${model.round}: ${model.phaseName} Phase'
        : 'Round ${model.round} of $currentRoundLimit: ${model.phaseName} Phase';
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Text(data,
          style: TextStyle(
              color: RovePalette.body,
              fontFamily: GoogleFonts.grenze().fontFamily,
              fontSize: 20)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: model,
        builder: (context, _) {
          final extraEtherNames = model.encounterDef.extraEtherNames;
          bool showExtraEther = model.round == 1 && extraEtherNames.isNotEmpty;
          final subtitle = model.subtitle;
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      tooltip: 'Undo',
                      icon: const Icon(Icons.history),
                      onPressed: () {
                        model.undo();
                      }),
                  Expanded(child: roundLimitText()),
                  _NextButton(model: model),
                ],
              ),
              if (subtitle != null && subtitle.isNotEmpty)
                Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: RoveText(subtitle, style: TextStyle(fontSize: 16))),
              if (showExtraEther)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      Spacer(),
                      Text(
                        'Extra Ether: ',
                        style: TextStyle(color: RovePalette.body),
                      ),
                      ...extraEtherNames.map((name) => Padding(
                          padding: const EdgeInsets.only(right: 4, left: 4),
                          child: Image.asset(RoveAssets.assetForEtherName(name),
                              width: 24, height: 24))),
                      Spacer(),
                    ],
                  ),
                )
            ],
          );
        });
  }
}

class _NextButton extends StatelessWidget {
  const _NextButton({
    required this.model,
  });

  final EncounterModel model;

  Widget get _iconButton => IconButton(
      tooltip: 'Next Phase',
      iconSize: 48,
      icon: const Icon(Icons.navigate_next),
      onPressed: () {
        model.increasePhase();
      });

  @override
  Widget build(BuildContext context) {
    return model.hasApplicableEndRoundCodices
        ? AvatarGlow(repeat: false, glowColor: Colors.blue, child: _iconButton)
        : _iconButton;
  }
}
