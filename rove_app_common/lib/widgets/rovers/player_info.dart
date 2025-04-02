import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rove_app_common/style/rove_theme.dart';
import 'package:rove_app_common/widgets/campaign_settings/campaign_settings_property.dart';
import 'package:rove_data_types/rove_data_types.dart';
import 'package:rove_app_common/model/players_model.dart';
import 'package:rove_app_common/widgets/common/rove_confirm_dialog.dart';

class PlayerInfo extends StatelessWidget {
  final Player player;

  const PlayerInfo({super.key, required this.player});

  Widget plusMinusButton(
      {bool isPlus = true, required void Function() onPressed}) {
    return IconButton(
      icon: Icon(isPlus ? Icons.add : Icons.remove, color: Colors.white),
      style: TextButton.styleFrom(
        minimumSize: Size.zero,
      ),
      onPressed: onPressed,
    );
  }

  _showDeactivateDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) => RoveConfirmDialog(
              title: 'Deactivate ${player.name}',
              message:
                  'Deactivated rovers can\'t play in encounters but can sell or transfer items.',
//            iconAsset: player.roverClass.,
              color: player.roverClass.color,
              confirmTitle: 'Confirm',
              onConfirm: () {
                PlayersModel.instance.deactivate(player);
              },
            ));
  }

  _showMaximumPlayersDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) => RoveConfirmDialog(
            title: 'Can\'t Activate',
            message:
                'There are already $roveMaximumPlayerCount Rovers active in your party. Deactivate one to activate another.',
            color: player.roverClass.color,
            confirmTitle: 'OK',
            hideCancelButton: true));
  }

  _showMinimumPlayersDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) => RoveConfirmDialog(
            title: 'Can\'t Deactivate',
            message:
                'At least $roveMinimumPlayerCount Rovers needs to be active in your party.',
            color: player.roverClass.color,
            confirmTitle: 'OK',
            hideCancelButton: true));
  }

  _onResignXulcHealthIncreaseChanged(bool value) {
    PlayersModel.instance
        .setResignXulcHealthIncrease(player: player, value: value);
  }

  _onActiveChanged(bool active, BuildContext context) {
    final model = PlayersModel.instance;
    if (active) {
      if (model.players.length == roveMaximumPlayerCount) {
        _showMaximumPlayersDialog(context);
      } else {
        model.reactivate(player);
      }
    } else if (model.players.length > roveMinimumPlayerCount) {
      _showDeactivateDialog(context);
    } else {
      _showMinimumPlayersDialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController textController =
        TextEditingController.fromValue(TextEditingValue(
      text: player.name,
      selection: TextSelection.collapsed(offset: player.name.length),
    ));

    final backgroundColor = player.roverClass.color;
    final foregroundColor = player.roverClass.colorDark;
    final stage = player.roverClass.evolutionStage;
    final showEvolution = stage != RoverEvolutionStage.base;
    return Padding(
      padding: const EdgeInsets.all(RoveTheme.verticalSpacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: RoveTheme.verticalSpacing,
        children: [
          CampaignSettingsProperty(
            label: 'Name',
            foregroundColor: foregroundColor,
            backgroundColor: backgroundColor,
            controller: textController,
            onChanged: (value) => {
              PlayersModel.instance.setPlayerName(
                  baseClassName: player.baseClassName, name: value)
            },
          ),
          if (showEvolution)
            EvolutionTrail(player: player, foregroundColor: foregroundColor),
          if (PlayersModel.instance.showResignXulcHealthIncrease)
            Row(
              children: [
                Checkbox(
                    value: player.resignXulcHealthIncrease,
                    shape: CircleBorder(
                        side: BorderSide(color: foregroundColor, width: 2)),
                    checkColor: foregroundColor,
                    onChanged: (value) =>
                        _onResignXulcHealthIncreaseChanged(value ?? false)),
                Text('Resign Xulc Health Increase',
                    style: TextStyle(color: foregroundColor)),
              ],
            ),
          Consumer<PlayersModel>(builder: (context, model, _) {
            return Row(
              children: [
                Checkbox(
                    value: !player.inactive,
                    shape: CircleBorder(
                        side: BorderSide(color: foregroundColor, width: 2)),
                    checkColor: foregroundColor,
                    onChanged: (value) => _onActiveChanged(value!, context)),
                Text('Active', style: TextStyle(color: foregroundColor)),
              ],
            );
          }),
        ],
      ),
    );
  }
}

class EvolutionTrail extends StatelessWidget {
  const EvolutionTrail({
    super.key,
    required this.player,
    required this.foregroundColor,
  });

  final Player player;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    text(String text) {
      return Text(text,
          style: TextStyle(
              color: foregroundColor,
              fontFamily: GoogleFonts.grenze().fontFamily,
              fontSize: 18));
    }

    separator() {
      return Icon(
        Icons.navigate_next,
        color: foregroundColor,
      );
    }

    final primeClassName = player.primeClassName;
    final apexClassName = player.apexClassName;
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        text(player.baseClassName),
        separator(),
        if (primeClassName != null) text(primeClassName),
        if (apexClassName != null) separator(),
        if (apexClassName != null) text(apexClassName),
        Padding(
          padding: const EdgeInsets.only(left: RoveTheme.horizontalSpacing),
          child: GestureDetector(
            onTap: () => PlayersModel.instance.resetEvolutionOfPlayer(player),
            child: Chip(
              label: Text('Change',
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: GoogleFonts.grenze().fontFamily,
                      fontSize: 18)),
              backgroundColor: foregroundColor,
            ),
          ),
        ),
      ],
    );
  }
}
