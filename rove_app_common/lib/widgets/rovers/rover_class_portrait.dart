import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rove_app_common/model/players_model.dart';
import 'package:rove_data_types/rove_data_types.dart';

class RoverClassPortrait extends StatelessWidget {
  const RoverClassPortrait(
      {super.key, required this.roverClass, required this.focused});

  final RoverClass roverClass;
  final bool focused;

  ColorFilter _colorFilterForClass(RoverClass roverClass) {
    final model = PlayersModel.instance;
    if (focused) {
      return const ColorFilter.mode(
        Colors.transparent,
        BlendMode.saturation,
      );
    }
    if (model.isInactiveForClass(roverClass.name)) {
      return ColorFilter.mode(
        Colors.grey,
        BlendMode.saturation,
      );
    } else if (model.hasPlayerForClass(roverClass.name)) {
      return const ColorFilter.mode(
        Colors.transparent,
        BlendMode.saturation,
      );
    } else {
      // No player
      return ColorFilter.mode(
        Colors.grey,
        BlendMode.saturation,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final asset = roverClass.posterAsset;
    return AspectRatio(
      aspectRatio: 0.3,
      child: Container(
        margin: const EdgeInsets.all(6.0),
        decoration: BoxDecoration(
            border: Border.all(color: roverClass.color, width: 3)),
        child: Column(children: [
          Expanded(
              flex: 9,
              child: Stack(
                children: [
                  Positioned.fill(
                      child: Container(
                          padding:
                              const EdgeInsets.only(top: 3, left: 3, right: 3),
                          child: ColorFiltered(
                              colorFilter: _colorFilterForClass(roverClass),
                              child: Image.asset(
                                asset,
                                fit: BoxFit.cover,
                              )))),
                  Positioned(
                      bottom: 0,
                      child: Container(
                          decoration: BoxDecoration(
                              color: roverClass.color,
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(10),
                              )),
                          padding: const EdgeInsets.only(top: 10),
                          height: 200,
                          child: RotatedBox(
                              quarterTurns: 1,
                              child: Text(roverClass.name,
                                  style: GoogleFonts.grenze(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 24,
                                  ))))),
                ],
              )),
          Expanded(
            flex: 1,
            child: Container(
                width: double.infinity,
                color: roverClass.color,
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    width: 36,
                    height: 36,
                    roverClass.iconAsset,
                  ),
                )),
          )
        ]),
      ),
    );
  }
}
