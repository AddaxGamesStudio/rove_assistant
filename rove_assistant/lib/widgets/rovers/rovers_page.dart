import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rove_assistant/theme/rove_palette.dart';
import 'package:rove_assistant/theme/rove_theme.dart';
import 'package:rove_assistant/model/campaign_model.dart';
import 'package:rove_assistant/model/players_model.dart';
import 'package:rove_assistant/services/analytics.dart';
import 'package:rove_assistant/widgets/common/background_box.dart';
import 'package:rove_assistant/widgets/common/rove_app_bar.dart';
import 'package:rove_assistant/widgets/common/rove_confirm_dialog.dart';
import 'focusable_rover_class_portrait.dart';
import 'rover_name_dialog.dart';
import 'rover_starting_item_dialog.dart';
import 'rulebook_class_description.dart';
import 'package:rove_data_types/rove_data_types.dart';

class RoversPage extends StatefulWidget {
  const RoversPage(
      {super.key,
      required this.campaignRouteBuilder,
      this.showRulebookDescriptions = false});

  final Route Function(BuildContext) campaignRouteBuilder;
  final bool showRulebookDescriptions;

  @override
  State<RoversPage> createState() => _RoversPageState();
}

class _RoversPageState extends State<RoversPage> {
  RoverClass? _focusedClass;

  List<RoverClass> itemsForCampaign(CampaignDef campaign) {
    final classes = campaign.currentClasses;
    /* classes.sort((a, b) => controller.hasPlayerForClass(a.name) ==
              controller.hasPlayerForClass(b.name)
          ? a.name.compareTo(b.name)
          : controller.hasPlayerForClass(a.name)
              ? -1
              : 1); */
    classes.sort((a, b) => a.name.compareTo(b.name));
    return classes;
  }

  _showNameDialog(RoverClass roverClass) {
    Analytics.logScreen('/rover_selection/name_dialog');
    showDialog(
        context: context,
        builder: (BuildContext context) => RoverNameDialog(
            roverClass: roverClass,
            onCancel: () {},
            onContinue: (String name) {
              setState(() {});
              if (roverClass.startingEquipment.isNotEmpty) {
                _showStartingItemDialog(roverClass);
              }
            }));
  }

  _showOnePlayerPerBaseClassDialog(RoverClass roverClass) {
    Analytics.logScreen('/rover_selection/one_player_per_base_class_dialog');
    showDialog(
        context: context,
        builder: (BuildContext context) => RoveConfirmDialog(
            title: 'One Player Per Base Class',
            message:
                'There is already a player with ${roverClass.baseClass.name} as their base class. If needed, you can change their evolution class once you begin the campaign.',
            color: RovePalette.title,
            confirmTitle: 'OK',
            hideCancelButton: true));
  }

  _showMaximumPlayersDialog() {
    Analytics.logScreen('/rover_selection/maximum_players_dialog');
    showDialog(
        context: context,
        builder: (BuildContext context) => RoveConfirmDialog(
            title: 'Maximum Players',
            message:
                'A campaign can have a maximum of $roveMaximumPlayerCount players. If needed, you can deactivate players and add another once you begin the campaign.',
            color: RovePalette.title,
            confirmTitle: 'OK',
            hideCancelButton: true));
  }

  _showStartingItemDialog(RoverClass roverClass) {
    Analytics.logScreen('/rover_selection/starting_item_dialog');
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) =>
            RoverStartingItemDialog(roverClass: roverClass, onContinue: () {}));
  }

  _onTap(RoverClass roverClass) {
    final model = PlayersModel.instance;
    if (model.hasPlayerForClass(roverClass.name)) {
      // Do nothing
    } else if (model.hasPlayerForBaseClass(roverClass.baseClass.name)) {
      _showOnePlayerPerBaseClassDialog(roverClass);
    } else if (model.players.length < roveMaximumPlayerCount) {
      _showNameDialog(roverClass);
    } else {
      _showMaximumPlayersDialog();
    }
  }

  _onFocusedClassChanged(
      {required bool focused, required RoverClass roverClass}) {
    if (_focusedClass == roverClass && focused) {
      return; // No change needed
    }
    if (focused) {
      setState(() {
        _focusedClass = roverClass;
      });
    } else if (_focusedClass == roverClass) {
      setState(() {
        _focusedClass = null;
      });
    }
  }

  _returnToMainMenu(BuildContext context) {
    Analytics.logScreen('/main_menu');
    final campaign = CampaignModel.instance.campaign;
    if (campaign.players.isEmpty) {
      CampaignModel.instance.deleteCampaign(campaign);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: BackgroundBox(child: Consumer<PlayersModel>(
      builder: (context, model, _) {
        final campaign = CampaignModel.instance.campaignDefinition;
        final items = itemsForCampaign(campaign);
        bool hasMinimumPlayers = model.hasMinimumPlayerCount;
        List<Widget> appBarActions = !hasMinimumPlayers
            ? []
            : [
                AvatarGlow(
                  repeat: false,
                  glowColor: Colors.blue,
                  child: RoveTrailingAppBarButton(
                      text: 'Begin >',
                      onPressed: () async {
                        await Navigator.of(context).pushAndRemoveUntil(
                            widget.campaignRouteBuilder(context), (route) {
                          return route.isFirst;
                        });
                      }),
                ),
              ];

        final focusedClass = _focusedClass;
        final bool showDescription = widget.showRulebookDescriptions &&
            focusedClass != null &&
            focusedClass.rulebookDescription != null &&
            !PlayersModel.instance.hasPlayerForClass(focusedClass.name);
        return Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                RoveAppBar(
                    titleText: 'Welcome to Chorus!',
                    leading: RoveLeadingAppBarButton(
                        text: '< Menu',
                        onPressed: () {
                          _returnToMainMenu(context);
                        }),
                    actions: appBarActions),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: const Text(
                    'Select $roveMinimumPlayerCount to $roveMaximumPlayerCount Rovers to begin your campaign.',
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: items.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final roverClass = items[index];
                      return FocusableRoverClassPortrait(
                        roverClass: roverClass,
                        onTap: () => _onTap(roverClass),
                        onFocusChanged: (focused) => _onFocusedClassChanged(
                            focused: focused, roverClass: roverClass),
                      );
                    },
                  ),
                ),
                RoveTheme.verticalSpacingBox
              ],
            ),
            if (showDescription)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Center(
                    child:
                        RulebookClassDescription(roverClass: _focusedClass!)),
              ),
          ],
        );
      },
    )));
  }
}
