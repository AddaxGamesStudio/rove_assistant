import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rove_app_common/model/players_model.dart';
import 'package:rove_app_common/style/rove_theme.dart';
import 'package:rove_app_common/widgets/common/rover_action_button.dart';
import 'package:rove_data_types/rove_data_types.dart';

class PlayerButtons extends StatelessWidget {
  final Function(Player) onSelected;
  final RoverClass? skipClass;
  final bool Function(Player)? whereTest;
  final Function(Player) buttonLabelBuilder;

  const PlayerButtons({
    super.key,
    this.skipClass,
    required this.buttonLabelBuilder,
    this.whereTest,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<PlayersModel>(builder: (context, model, _) {
      return Column(
          spacing: RoveTheme.verticalSpacing,
          children: model.players
              .where((player) =>
                  skipClass == null || player.roverClass != skipClass!)
              .where((player) => whereTest?.call(player) ?? true)
              .map((player) {
            return SizedBox(
                width: double.infinity,
                child: RoverActionButton(
                    label: buttonLabelBuilder(player),
                    roverClass: player.roverClass,
                    onPressed: () {
                      onSelected(player);
                    }));
          }).toList());
    });
  }
}
