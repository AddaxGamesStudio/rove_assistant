import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rove_assistant/theme/rove_palette.dart';
import 'package:rove_assistant/theme/rove_theme.dart';
import 'package:rove_assistant/model/players_model.dart';
import 'package:rove_assistant/widgets/common/background_box.dart';
import 'focusable_rover_class_portrait.dart';
import 'package:rove_data_types/rove_data_types.dart';

class RoverLevelUpPage extends StatelessWidget {
  final Player player;
  final Widget? appBarLeading;
  final Function() onComplete;

  const RoverLevelUpPage(
      {super.key,
      required this.player,
      required this.onComplete,
      this.appBarLeading});

  List<RoverClass> classesForPlayer() {
    final classes = PlayersModel.instance.evolutionsForPlayer(player);
    classes.sort((a, b) => a.name.compareTo(b.name));
    return classes;
  }

  _onTap(RoverClass roverClass) {
    PlayersModel.instance.levelUpToClass(player, levelUpClass: roverClass);
    onComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: BackgroundBox(child: Consumer<PlayersModel>(
      builder: (context, model, _) {
        final items = classesForPlayer();
        return SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.only(
                bottom: RoveTheme.verticalSpacing,
                left: RoveTheme.horizontalSpacing,
                right: RoveTheme.horizontalSpacing),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: RoveTheme.verticalSpacing,
              children: [
                AppBar(
                  backgroundColor: Colors.transparent,
                  foregroundColor: RovePalette.title,
                  title: Text(
                    '${player.name} - Level Up',
                    style: RoveTheme.titleStyle(),
                  ),
                  leading: appBarLeading,
                ),
                Text(
                  'Select your ${player.nextEvolutionStage?.label} evolution class.',
                  textAlign: TextAlign.center,
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
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    )));
  }
}
