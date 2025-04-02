import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rove_simulator/assets.dart';
import 'package:rove_simulator/controller/reward_controller.dart';
import 'package:rove_simulator/model/tiles/player_unit_model.dart';
import 'package:rove_simulator/widgets/encounter/rovers/rover_button.dart';
import 'package:rove_data_types/rove_data_types.dart';

class ItemRewardDialog extends StatelessWidget {
  final RewardController controller;
  final ItemDef item;
  final PlayerUnitModel player;

  const ItemRewardDialog(
      {super.key,
      required this.player,
      required this.item,
      required this.controller});

  onConfirm(BuildContext context) {
    controller.dismissItemRewardDialog();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: ThemeData(
          fontFamily: GoogleFonts.grenze().fontFamily,
        ),
        child: Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.black.withValues(alpha: 0.75),
            child: Dialog(
              backgroundColor: Colors.transparent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.asset(
                        Assets.pathForItemImage(item.frontImageSrc),
                        height: 340,
                        fit: BoxFit.contain),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    '${player.name} received ${item.name}!',
                    textAlign: TextAlign.center,
                    style:
                        GoogleFonts.grenze(color: Colors.white, fontSize: 18),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  SizedBox(
                    width: 150,
                    height: 32,
                    child: RoverButton(
                        label: 'Continue',
                        roverClass: player.roverClass,
                        onPressed: () {
                          onConfirm(context);
                        }),
                  ),
                  const Spacer(),
                ],
              ),
            )));
  }
}
