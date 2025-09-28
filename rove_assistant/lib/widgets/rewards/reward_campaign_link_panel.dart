import 'package:flutter/material.dart';
import 'package:rove_assistant/theme/rove_palette.dart';
import 'package:rove_assistant/widgets/common/rove_dialog.dart';
import 'package:rove_assistant/widgets/common/rove_icon.dart';
import 'package:rove_assistant/widgets/common/rove_text.dart';
import 'package:rove_assistant/widgets/rewards/rewards_dialog.dart';

class RewardCampaignLinkPanel extends RewardPanel {
  final String campaignLink;

  const RewardCampaignLinkPanel(
      {super.key, required this.campaignLink, required super.onContinue});

  @override
  Widget buildBody(BuildContext context) {
    return Align(
        alignment: Alignment.centerLeft, child: RoveText(campaignLink));
  }

  @override
  String? get title => 'Campaign Link';

  @override
  Widget get icon => RoveIcon.small('campaign_link');

  @override
  Color get backgroundColor => RovePalette.setupBackground;

  @override
  Color get foregroundColor => RovePalette.setupForeground;

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
