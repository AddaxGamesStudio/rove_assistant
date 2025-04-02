import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rove_app_common/model/campaign_model.dart';
import 'package:rove_app_common/model/players_model.dart';
import 'package:rove_app_common/rove_routes.dart';
import 'package:rove_app_common/style/rove_palette.dart';
import 'package:rove_app_common/style/rove_theme.dart';
import 'package:rove_app_common/widgets/common/background_box.dart';
import 'package:rove_app_common/widgets/common/rove_app_bar.dart';
import 'package:rove_app_common/widgets/common/rove_confirm_dialog.dart';
import 'package:rove_app_common/widgets/rovers/focusable_rover_class_portrait.dart';
import 'package:rove_app_common/widgets/rovers/rover_name_dialog.dart';
import 'package:rove_app_common/widgets/rovers/rover_starting_item_dialog.dart';
import 'package:rove_data_types/rove_data_types.dart';

class RoversPage extends StatefulWidget {
  const RoversPage({super.key});

  @override
  State<RoversPage> createState() => _RoversPageState();
}

class _RoversPageState extends State<RoversPage> {
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
                RoveTrailingAppBarButton(
                    text: 'Begin >',
                    onPressed: () async {
                      await Navigator.of(context).pushNamedAndRemoveUntil(
                          RoveRoutes.campaignName, (route) {
                        return route.isFirst;
                      });
                    }),
              ];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RoveAppBar(
                titleText: 'Welcome to Chorus!',
                leading: RoveLeadingAppBarButton(
                    text: '< Menu',
                    onPressed: () {
                      Navigator.of(context).pop();
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
                    onTap: (roverClass) => _onTap(roverClass),
                  );
                },
              ),
            ),
            RoveTheme.verticalSpacingBox
          ],
        );
      },
    )));
  }
}
