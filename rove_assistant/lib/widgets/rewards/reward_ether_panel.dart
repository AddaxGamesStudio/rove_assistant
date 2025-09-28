import 'package:flutter/material.dart';
import 'package:rove_assistant/model/encounter/encounter_model.dart';
import 'package:rove_assistant/theme/rove_assets.dart';
import 'package:rove_assistant/theme/rove_theme.dart';
import 'package:rove_assistant/widgets/common/rove_dialog.dart';
import 'package:rove_assistant/widgets/rewards/rewards_dialog.dart';

class RewardEtherPanel extends RewardPanel {
  final EncounterModel controller;
  final List<String> etherNames;

  const RewardEtherPanel(
      {super.key,
      required this.controller,
      required this.etherNames,
      required super.onContinue});

  @override
  String get title => 'Ether Reward';

  @override
  Widget buildBody(BuildContext context) {
    List<Widget> etherImages = etherNames
        .map((name) => Padding(
            padding: const EdgeInsets.only(right: 8, left: 8),
            child: Image.asset(RoveAssets.assetForEtherName(name),
                width: 64, height: 64)))
        .toList();
    String etherText =
        etherNames.length > 1 ? 'these ethers' : 'a ${etherNames[0]}';
    return Column(children: [
      Row(children: [const Spacer(), ...etherImages, const Spacer()]),
      RoveTheme.verticalSpacingBox,
      Text(
          'Rovers start the next encounter with $etherText dice in their personal pool.'),
    ]);
  }

  @override
  Widget buildActions(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.end, children: [
      RoveDialogActionButton(
        color: foregroundColor,
        title: 'Continue',
        onPressed: () {
          controller.setEtherRewards(ethers: etherNames);
          onContinue();
        },
      )
    ]);
  }
}
