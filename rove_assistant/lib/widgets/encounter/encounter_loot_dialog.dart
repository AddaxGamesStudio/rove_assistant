import 'package:flutter/material.dart';
import 'package:rove_assistant/theme/rove_theme.dart';
import 'package:rove_assistant/model/encounter/encounter_model.dart';
import 'package:rove_assistant/theme/rove_palette.dart';
import 'package:rove_assistant/model/encounter/figure.dart';
import 'package:rove_assistant/widgets/common/rove_dialog.dart';
import 'package:rove_assistant/widgets/common/rove_icon.dart';
import 'package:rove_assistant/widgets/common/rove_text.dart';
import 'package:rove_assistant/widgets/encounter/encounter_panel.dart';

class EncounterLootDialog extends StatelessWidget {
  final Figure figure;
  final EncounterModel model;

  const EncounterLootDialog(
      {super.key, required this.figure, required this.model});

  @override
  Widget build(BuildContext context) {
    final foregroundColor = RovePalette.rewardForeground;
    return Dialog(
      child: EncounterPanel(
        title: figure.nameToDisplay,
        foregroundColor: foregroundColor,
        backgroundColor: RovePalette.rewardBackground,
        icon: RoveIcon.small('reward'),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            spacing: RoveTheme.verticalSpacing,
            children: [
              for (final trait in figure.traits)
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: RoveText(trait),
                  ),
                ),
              Image.asset(figure.asset, width: 240),
              SizedBox(
                  width: double.infinity,
                  child: RoveDialogActionButton(
                      title: 'Loot ${figure.nameToDisplay}',
                      color: foregroundColor,
                      onPressed: () {
                        model.loot(figure: figure);
                        Navigator.of(context).pop();
                      })),
              if (model.figuresThatCanLoot.isNotEmpty)
                Column(
                    spacing: RoveTheme.verticalSpacing,
                    children: model.figuresThatCanLoot
                        .map((h) => SizedBox(
                            width: double.infinity,
                            child: RoveDialogActionButton(
                                title:
                                    '${h.nameToDisplay} (${h.numberToDisplay}): Loot ${figure.nameToDisplay}',
                                color: foregroundColor,
                                onPressed: () {
                                  model.lootByAdversary(
                                      figure: figure, adversary: h);
                                  Navigator.of(context).pop();
                                })))
                        .toList()),
            ]),
      ),
    );
  }
}
