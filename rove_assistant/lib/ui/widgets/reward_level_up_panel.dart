import 'package:flutter/material.dart';
import 'package:rove_app_common/data/progression_data.dart';
import 'package:rove_app_common/model/campaign_model.dart';
import 'package:rove_app_common/model/players_model.dart';
import 'package:rove_app_common/style/rove_theme.dart';
import 'package:rove_app_common/widgets/common/rove_text.dart';
import 'package:rove_app_common/widgets/rovers/rover_class_portrait.dart';
import 'package:rove_assistant/ui/styles.dart';
import 'package:rove_assistant/ui/widgets/rewards_dialog.dart';
import 'package:rove_data_types/rove_data_types.dart';

class RoverLevelUpRewardPanel extends RewardPanel {
  final int level;

  const RoverLevelUpRewardPanel(
      {super.key, required this.level, required super.onContinue});

  static Widget? _previewForLevel(int level) {
    switch (level) {
      case 4:
      case 7:
        final classes = PlayersModel.instance.classesForLevel(4);
        return SizedBox(
          height: 400,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: classes.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final roverClass = classes[index];
              return RoverClassPortrait(
                roverClass: roverClass,
                focused: true,
              );
            },
          ),
        );
    }
    return null;
  }

  @override
  String get title => 'Level Up';

  @override
  Widget buildBody(BuildContext context) {
    final preview = _previewForLevel(level);
    return Column(
      spacing: RoveTheme.verticalSpacing,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (preview != null) preview,
        RoveText(
            'Rovers are now level $level! ${ProgressionData.descriptionForLevel(level)}'),
        if (!PlayersModel.instance.canLevelUpWithoutUserSelectionToLevel(level))
          RoveText(
              '[*In the app, select your ${roverEvolutionStageForLevel(level).label} evolution classes from each Rover\'s menu before the next encounter.*]'),
      ],
    );
  }

  @override
  Widget buildActions(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.end, children: [
      RoveStyles.compactDialogActionButton(
        color: foregroundColor,
        title: 'Continue',
        onPressed: () {
          CampaignModel.instance.setRoversLevel(level);
          onContinue();
        },
      )
    ]);
  }
}
