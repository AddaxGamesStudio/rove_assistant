import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:rove_assistant/theme/rove_theme.dart';
import 'package:rove_assistant/model/encounter/encounter_model.dart';
import 'package:rove_assistant/theme/rove_palette.dart';
import 'package:rove_assistant/model/encounter/encounter_state.dart';
import 'package:rove_assistant/model/items_model.dart';
import 'package:rove_assistant/model/players_model.dart';
import 'package:rove_assistant/widgets/common/rove_icon.dart';
import 'package:rove_assistant/widgets/encounter/encounter_panel.dart';
import 'package:rove_assistant/widgets/rewards/reward_campaign_link_panel.dart';
import 'package:rove_assistant/widgets/rewards/reward_ether_panel.dart';
import 'package:rove_assistant/widgets/rewards/reward_item_panel.dart';
import 'package:rove_assistant/widgets/rewards/reward_lyst_panel.dart';
import 'package:rove_assistant/widgets/rewards/reward_level_up_panel.dart';
import 'package:rove_assistant/widgets/rewards/reward_milestone_panel.dart';
import 'package:rove_assistant/widgets/rewards/reward_shop_panel.dart';
import 'package:rove_assistant/widgets/rewards/reward_trait_panel.dart';
import 'package:rove_data_types/rove_data_types.dart';

abstract class RewardsWrapper {
  String get titlePrefix;
  List<(String, int)> get lystRewards;
  List<String> get itemRewards;
  List<String> get etherRewards;
  int get unlocksShopLevel;
  String? get stashReward;
  int get unlocksRoverLevel;
  bool get unlocksTrait;
  String? get milestone;
  String? get campaignLink;

  @factory
  static fromEncounter(
      {required EncounterDef encounter,
      required EncounterState encounterState}) {
    return _EncounterRewardsWrapper(
        encounter: encounter, encounterState: encounterState);
  }

  @factory
  static tutorial() {
    return _SkipTutorialRewardsWrapper();
  }
}

class _EncounterRewardsWrapper extends RewardsWrapper {
  final EncounterDef encounter;
  final EncounterState encounterState;

  _EncounterRewardsWrapper(
      {required this.encounter, required this.encounterState});

  @override
  String get titlePrefix => 'Encounter';

  @override
  List<(String, int)> get lystRewards {
    final playerCount = PlayersModel.instance.players.length;
    final otherLystRewards = encounterState.lystRewards
      ..sort((a, b) =>
          a.$1.compareTo(b.$1)); // Keep rewards with the same title together
    return [
      if (encounter.baseLystReward > 0 && !encounterState.failed)
        ('Encounter Completed', encounter.baseLystReward * playerCount),
      if (encounterState.achievedChallengesCount > 0 && !encounterState.failed)
        ('1 Challenge Achieved', roveChallengeRewardLyst * playerCount),
      ...otherLystRewards
    ];
  }

  @override
  List<String> get etherRewards =>
      encounterState.rewardedEtherNames(encounterDef: encounter);

  @override
  List<String> get itemRewards => encounter.itemRewards;

  @override
  int get unlocksShopLevel => encounter.unlocksShopLevel;

  @override
  String? get stashReward => encounter.stashReward;

  @override
  int get unlocksRoverLevel => encounter.unlocksRoverLevel;

  @override
  bool get unlocksTrait => encounter.unlocksTrait;

  @override
  String? get milestone => encounter.milestone;

  @override
  String? get campaignLink => encounter.campaignLink;
}

class _SkipTutorialRewardsWrapper extends RewardsWrapper {
  _SkipTutorialRewardsWrapper();

  @override
  String get titlePrefix => 'Prologue';

  @override
  List<(String, int)> get lystRewards =>
      [('Prologue Completed', 30 * PlayersModel.instance.players.length)];

  @override
  List<String> get etherRewards => [];

  @override
  List<String> get itemRewards => [];

  @override
  int get unlocksShopLevel => 1;

  @override
  String? get stashReward => null;

  @override
  int get unlocksRoverLevel => 2;

  @override
  bool get unlocksTrait => false;

  @override
  String? get milestone => null;

  @override
  String? get campaignLink => null;
}

class RewardPanel extends StatelessWidget {
  final Function() onContinue;
  const RewardPanel({super.key, required this.onContinue});

  String? get title => null;

  Color get foregroundColor => RovePalette.rewardForeground;

  Color get backgroundColor => RovePalette.rewardBackground;

  Widget get icon => RoveIcon.small('reward');

  Widget buildBody(BuildContext context) {
    throw UnimplementedError();
  }

  Widget buildActions(BuildContext context) {
    throw UnimplementedError();
  }

  @override
  Widget build(BuildContext context) {
    return EncounterPanel(
        title: title ?? 'Reward',
        icon: icon,
        foregroundColor: foregroundColor,
        backgroundColor: backgroundColor,
        child: Column(
          children: [
            buildBody(context),
            RoveTheme.verticalSpacingBox,
            buildActions(context),
          ],
        ));
  }
}

class RewardsDialog extends StatefulWidget {
  final EncounterModel? controller;
  final RewardsWrapper rewards;
  final Function() onCancel;
  final Function() onCompleted;

  const RewardsDialog(
      {super.key,
      this.controller,
      required this.rewards,
      required this.onCancel,
      required this.onCompleted});

  @override
  State<RewardsDialog> createState() => _RewardsDialogState();
}

class _RewardsDialogState extends State<RewardsDialog> {
  int pageIndex = 0;

  final PageController pageController = PageController();

  List<RewardPanel> _rewardPages(Function() onContinue) {
    assert(widget.controller != null || widget.rewards.itemRewards.isEmpty);
    assert(widget.controller != null || widget.rewards.etherRewards.isEmpty);

    List<RewardPanel> pages = [];

    if (widget.rewards.lystRewards.isNotEmpty) {
      pages.add(
        LystRewardPanel(
            lystRewards: widget.rewards.lystRewards,
            onCancel: widget.onCancel,
            onContinue: onContinue),
      );
    }

    for (String itemName in widget.rewards.itemRewards) {
      pages.add(RewardItemPanel(
          model: widget.controller!,
          item: ItemsModel.instance.itemForName(itemName),
          onContinue: onContinue));
    }

    final etherNames = widget.rewards.etherRewards;
    if (etherNames.isNotEmpty) {
      pages.add(RewardEtherPanel(
          controller: widget.controller!,
          etherNames: etherNames,
          onContinue: onContinue));
    }

    if (widget.rewards.unlocksShopLevel > 0) {
      pages.add(RewardShopLevelUpPanel(
          level: widget.rewards.unlocksShopLevel, onContinue: onContinue));
    }

    final stash = widget.rewards.stashReward;
    if (stash != null) {
      pages.add(RewardShopStashPanel(stash: stash, onContinue: onContinue));
    }

    if (widget.rewards.unlocksRoverLevel > 0) {
      pages.add(RoverLevelUpRewardPanel(
          level: widget.rewards.unlocksRoverLevel, onContinue: onContinue));
    }

    if (widget.rewards.unlocksTrait) {
      pages.add(RewardTraitPanel(onContinue: onContinue));
    }

    final milestone = widget.rewards.milestone;
    if (milestone != null &&
        !CampaignMilestone.internalMilestones.contains(milestone)) {
      pages.add(RewardMilestonePanel(
          milestone: milestone,
          model: widget.controller!,
          onContinue: onContinue));
    }

    final campaignLink = widget.rewards.campaignLink;
    if (campaignLink != null) {
      pages.add(RewardCampaignLinkPanel(
          campaignLink: campaignLink, onContinue: onContinue));
    }

    return pages;
  }

  @override
  Widget build(BuildContext context) {
    // Declare pages in advance to reference its length inside onContinue
    List<RewardPanel> pages = [];
    onContinue() {
      if (pageController.page! < pages.length - 1) {
        pageController.nextPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut);
      } else {
        Navigator.of(context).pop();
        widget.onCompleted();
      }
    }

    pages.addAll(_rewardPages(onContinue));

    return Dialog(
        backgroundColor: Colors.transparent,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
              minWidth: RoveTheme.dialogMinWidth,
              maxWidth: RoveTheme.dialogMaxWidth),
          child: SingleChildScrollView(
            child: ExpandablePageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: pageController,
              children: pages,
            ),
          ),
        ));
  }
}
