import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rove_assistant/theme/rove_theme.dart';
import 'package:rove_assistant/model/campaign_model.dart';
import 'package:rove_assistant/model/players_model.dart';
import 'package:rove_assistant/widgets/common/background_box.dart';
import 'package:rove_assistant/widgets/common/rove_app_bar.dart';
import 'focusable_rover_class_portrait.dart';
import 'rover_name_dialog.dart';
import 'rover_starting_item_dialog.dart';
import 'package:rove_data_types/rove_data_types.dart';

class AddPlayerPage extends StatelessWidget {
  final Function(Player) onPlayerAdded;
  final Widget? appBarLeading;

  const AddPlayerPage(
      {super.key, required this.onPlayerAdded, this.appBarLeading});

  List<RoverClass> itemsForCampaign(CampaignDef campaign) {
    final playersBaseClasses =
        CampaignModel.instance.campaign.allPlayers.map((p) => p.baseClassName);
    final classes = campaign.currentClasses
        .where((c) => !playersBaseClasses.contains(c.baseClass.name))
        .toList();
    classes.sort((a, b) => a.name.compareTo(b.name));
    return classes;
  }

  _onPlayerAdded(RoverClass roverClass) {
    onPlayerAdded(PlayersModel.instance.playerForClass(roverClass.name));
  }

  _showNameDialog(BuildContext context, RoverClass roverClass) {
    showDialog(
        context: context,
        builder: (BuildContext context) => RoverNameDialog(
            roverClass: roverClass,
            onCancel: () {},
            onContinue: (String name) {
              if (roverClass.startingEquipment.isNotEmpty) {
                _showStartingItemDialog(context, roverClass);
              } else {
                _onPlayerAdded(roverClass);
              }
            }));
  }

  _showStartingItemDialog(BuildContext context, RoverClass roverClass) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => RoverStartingItemDialog(
            roverClass: roverClass,
            onContinue: () => _onPlayerAdded(roverClass)));
  }

  _onTap(BuildContext context, RoverClass roverClass) {
    _showNameDialog(context, roverClass);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: BackgroundBox(child: Consumer<PlayersModel>(
      builder: (context, model, _) {
        final campaign = CampaignModel.instance.campaignDefinition;
        final items = itemsForCampaign(campaign);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RoveAppBar(
              titleText: 'Add Rover',
              leading: appBarLeading,
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
                    onTap: () => _onTap(context, roverClass),
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
