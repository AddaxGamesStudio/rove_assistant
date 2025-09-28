import 'package:flutter/material.dart';
import 'package:rove_assistant/theme/rove_palette.dart';
import 'package:rove_assistant/model/players_model.dart';
import 'package:rove_data_types/rove_data_types.dart';

class PlayersTabController extends StatelessWidget {
  final Widget Function(Player) tabBarViewForPlayer;
  final double? height;

  const PlayersTabController(
      {super.key, required this.tabBarViewForPlayer, this.height});

  @override
  Widget build(BuildContext context) {
    final players = PlayersModel.instance.players;
    final tabBarView = TabBarView(
      children: players.map(tabBarViewForPlayer).toList(),
    );

    const iconSize = 18.0;
    const labelPadding = 4.0;
    final maxWidth = (MediaQuery.of(context).size.width / players.length) -
        iconSize -
        labelPadding * 3;

    return DefaultTabController(
      length: players.length,
      child: Column(children: [
        TabBar(
          labelPadding:
              EdgeInsets.only(left: labelPadding, right: labelPadding),
          indicatorColor: RovePalette.title,
          tabs: players.map((player) {
            final color = player.roverClass.color;
            return Tab(
                child: IntrinsicWidth(
                    child: Row(children: [
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(player.name,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.black))),
              ),
              const SizedBox(width: labelPadding),
              ImageIcon(
                  size: 18,
                  color: color,
                  AssetImage(player.roverClass.iconAsset)),
            ])));
          }).toList(),
        ),
        height == null
            ? Expanded(child: tabBarView)
            : SizedBox(height: height, child: tabBarView),
      ]),
    );
  }
}
