import 'package:flutter/material.dart';
import 'package:rove_app_common/model/campaign_model.dart';
import 'package:rove_app_common/style/rove_theme.dart';
import 'package:rove_assistant/ui/styles.dart';
import 'package:rove_assistant/ui/widgets/rewards_dialog.dart';

class RewardTraitPanel extends RewardPanel {
  const RewardTraitPanel({super.key, required super.onContinue});

  @override
  Widget buildBody(BuildContext context) {
    final level = CampaignModel.instance.campaign.roversLevel;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: RoveTheme.verticalSpacing,
      children: [
        if (level == 5)
          Text(
              'Each Rover gains one prime class trait! Look inside your prime class box and select one of the three traits within, adding it to your class board. This is a permanent choice.'),
        if (level == 8)
          Text(
              'Each Rover gains one apex class trait! Look inside your apex class box and select one of the three traits within, adding it to your class board. This is a permanent choice.'),
        Text(
            'Reflect the trait you chose on the corresponding Rover page from the Drawer menu.')
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
          CampaignModel.instance.addTrait();
          onContinue();
        },
      )
    ]);
  }
}
