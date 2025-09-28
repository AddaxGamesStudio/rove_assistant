import 'package:flutter/material.dart';
import 'package:rove_assistant/model/items_model.dart';
import 'package:rove_assistant/theme/rove_theme.dart';
import 'package:rove_assistant/widgets/common/lyst_text.dart';
import 'package:rove_assistant/widgets/common/rove_dialog.dart';
import 'package:rove_assistant/widgets/common/rove_text.dart';
import 'package:rove_assistant/widgets/rewards/rewards_dialog.dart';

int _foldRewards(List<(String, int)> rewards) {
  return rewards.fold<int>(0, (acc, reward) => acc + reward.$2);
}

List<(String, int)> _coalesceLystRewards(List<(String, int)> lystRewards) {
  assert(lystRewards.isNotEmpty);
  var (currentTitle, currentAmount) = lystRewards.first;
  var count = 1;
  List<(String, int)> coallesced = [];
  for (var (title, amount) in lystRewards) {
    if (currentTitle == title) {
      if (coallesced.isEmpty) {
        coallesced.add((currentTitle, currentAmount));
      } else {
        currentAmount += amount;
        count++;
        coallesced[coallesced.length - 1] = ('$title x$count', currentAmount);
      }
    } else {
      coallesced.add((title, amount));
      currentTitle = title;
      currentAmount = amount;
      count = 1;
    }
  }
  return coallesced;
}

class LystRewardPanel extends RewardPanel {
  final List<(String, int)> lystRewards;
  final Function() onCancel;
  LystRewardPanel(
      {super.key,
      required lystRewards,
      required this.onCancel,
      required super.onContinue})
      : lystRewards = _coalesceLystRewards(lystRewards);

  @override
  String get title => 'Lyst Reward';

  @override
  Widget buildBody(BuildContext context) {
    final totalLyst = _foldRewards(lystRewards);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        LystText(lyst: totalLyst, fontSize: 64),
        if (lystRewards.length > 1) RoveTheme.verticalSpacingBox,
        if (lystRewards.length > 1)
          ...lystRewards.map((reward) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: 16),
                    Expanded(child: Text(reward.$1)),
                    SizedBox(
                        width: 50,
                        child: RoveText(
                          '${reward.$2} [lyst]',
                          textAlign: TextAlign.right,
                        )),
                    SizedBox(width: 16),
                  ],
                ),
              )),
      ],
    );
  }

  @override
  Widget buildActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        RoveDialogCancelButton(onPressed: () {
          Navigator.of(context).pop();
          onCancel();
        }),
        const SizedBox(width: 8),
        RoveDialogActionButton(
            color: foregroundColor,
            title: 'Continue',
            onPressed: () {
              ItemsModel.instance.addLyst(_foldRewards(lystRewards));
              onContinue();
            }),
      ],
    );
  }
}
