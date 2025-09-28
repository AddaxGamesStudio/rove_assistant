import 'package:flutter/material.dart';
import 'package:rove_assistant/theme/rove_theme.dart';
import 'package:rove_assistant/model/encounter/encounter_model.dart';
import 'package:rove_assistant/model/encounter/figure.dart';
import 'package:rove_assistant/model/players_model.dart';
import 'package:rove_assistant/widgets/common/rove_dialog.dart';
import 'package:rove_assistant/widgets/common/rove_text.dart';
import 'package:rove_assistant/widgets/encounter/figure_hexagon.dart';
import 'package:rove_assistant/widgets/rewards/rewards_dialog.dart';
import 'package:rove_data_types/rove_data_types.dart';

class RewardMilestonePanel extends RewardPanel {
  final String milestone;
  final EncounterModel model;

  const RewardMilestonePanel(
      {super.key,
      required this.milestone,
      required this.model,
      required super.onContinue});

  @override
  String get title => milestone;

  @override
  Widget buildBody(BuildContext context) {
    final milestoneDef = CampaignMilestone.fromMilestone(milestone);
    final figures = milestoneDef.figureNames.map((n) =>
        model.figureFromTarget(n) ??
        FigureBuilder.forGame(model.campaignDef, model.encounterDef,
                PlayersModel.instance.players.length)
            .withDefinition(EncounterFigureDef(name: n))
            .build());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: RoveTheme.verticalSpacing,
      children: [
        RoveText(CampaignMilestone.fromMilestone(milestone).message),
        Center(
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: RoveTheme.verticalSpacing,
            runSpacing: RoveTheme.horizontalSpacing,
            children: figures.map((e) => FigureHexagon.fromFigure(e)).toList(),
          ),
        ),
      ],
    );
  }

  @override
  Widget buildActions(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.end, children: [
      RoveDialogActionButton(
        color: foregroundColor,
        title: 'Continue',
        onPressed: () {
          onContinue();
        },
      )
    ]);
  }
}
