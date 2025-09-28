import 'package:flutter/material.dart';
import 'package:rove_assistant/theme/rove_theme.dart';
import 'package:rove_assistant/model/campaign_model.dart';
import 'package:rove_assistant/model/encounter/encounter_model.dart';
import 'package:rove_assistant/theme/rove_palette.dart';
import 'package:rove_assistant/widgets/encounter/encounter_detail_round_tracker.dart';
import 'package:rove_assistant/widgets/rewards/rewards_dialog.dart';
import 'package:rove_data_types/rove_data_types.dart';

class EncounterDetailFooter extends StatelessWidget {
  final EncounterModel model;

  const EncounterDetailFooter({
    super.key,
    required this.model,
  });

  static completeEncounter(
      {required BuildContext context,
      required EncounterModel model,
      bool failed = false}) {
    if (!context.mounted) {
      return;
    }
    final state = model.encounterState;
    final encounter = model.encounterDef;
    final milestone = encounter.milestone;
    if (milestone != null) {
      model.setMilestoneReward(milestone);
    }
    state.complete = true;
    onRewardsCompleted() {
      CampaignModel.instance
          .completeEncounter(record: state.record(), encounter: encounter);
      Navigator.of(context).pop();
    }

    if (!model.hasRewards) {
      onRewardsCompleted();
      return;
    }

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) => RewardsDialog(
            controller: model,
            rewards: RewardsWrapper.fromEncounter(
                encounter: encounter, encounterState: state),
            onCancel: () {},
            onCompleted: () {
              onRewardsCompleted();
            }));
  }

  @override
  Widget build(BuildContext context) {
    String completeButtonTitle() {
      if (model.encounterDef.id == EncounterDef.encounter9dot6 ||
          model.encounterDef.id == EncounterDef.encounter10dot10) {
        return 'Complete Campaign';
      }
      return 'Claim Rewards';
    }

    return ListenableBuilder(
        listenable: model,
        builder: (context, _) {
          final encounterState = model.encounterState;
          final bool showButton = !encounterState.complete &&
              (model.isObjectiveAchieved || model.failed);
          final bool showRoundTracker = !encounterState.complete;
          final bool showFooter = showButton || showRoundTracker;

          return SizedBox(
            width: double.infinity,
            child: showFooter
                ? SafeArea(
                    top: false,
                    minimum:
                        const EdgeInsets.only(left: 24, right: 24, bottom: 12),
                    child: Column(
                      children: [
                        if (showRoundTracker)
                          EncounterDetailRoundTracker(model: model),
                        if (showButton)
                          ElevatedButton(
                              onPressed: () {
                                completeEncounter(
                                    context: context, model: model);
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: model.failed
                                      ? RovePalette.challengesForeground
                                      : RovePalette.lyst,
                                  padding: const EdgeInsets.all(12),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(RoveTheme.panelRadius),
                                  )),
                              child: Text(completeButtonTitle(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold))),
                      ],
                    ),
                  )
                : SizedBox.shrink(),
          );
        });
  }
}
