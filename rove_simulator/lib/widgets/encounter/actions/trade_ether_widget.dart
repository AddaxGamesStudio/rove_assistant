import 'package:flutter/material.dart';
import 'package:rove_simulator/controller/card_resolver.dart';
import 'package:rove_simulator/controller/player_actions/trade_ether_resolver.dart';
import 'package:rove_simulator/model/tiles/player_unit_model.dart';
import 'package:rove_simulator/widgets/game_dialog.dart';
import 'package:rove_simulator/widgets/encounter/rovers/ether_pool_widget.dart';
import 'package:rove_simulator/widgets/encounter/rovers/rover_button.dart';
import 'package:rove_data_types/rove_data_types.dart';

class TradeEtherWidget extends StatefulWidget {
  final CardResolver controller;

  const TradeEtherWidget({super.key, required this.controller});

  @override
  State<TradeEtherWidget> createState() => _TradeEtherWidgetState();
}

class _TradeEtherWidgetState extends State<TradeEtherWidget> {
  PlayerUnitModel get player => widget.controller.player;
  TradeEtherResolver get resolver =>
      widget.controller.actionResolver as TradeEtherResolver;

  (Ether, int)? fromPlayerEther;

  bool isSelectedFromPlayerEther(int index) {
    return fromPlayerEther != null ? fromPlayerEther!.$2 == index : false;
  }

  onSelectedFromPlayerEther(Ether ether, int index, bool selected) {
    setState(() {
      fromPlayerEther = selected ? (ether, index) : null;
    });
  }

  (Ether, int)? toPlayerEther;

  bool isSelectedToPlayerEther(int index) {
    return toPlayerEther != null ? toPlayerEther!.$2 == index : false;
  }

  onSelectedToPlayerEther(Ether ether, int index, bool selected) {
    setState(() {
      toPlayerEther = selected ? (ether, index) : null;
    });
  }

  bool get canConfirm => fromPlayerEther != null && toPlayerEther != null;

  onConfirm() {
    if (!canConfirm) return;
    resolver.trade(fromPlayerEther!.$1, toPlayerEther!.$1);
  }

  @override
  Widget build(BuildContext context) {
    return GameDialog(
      color: player.color,
      child: ListenableBuilder(
          listenable: widget.controller,
          builder: (context, _) {
            return SizedBox(
                width: 250,
                height: 200,
                child: Column(
                  children: [
                    const Text('Trade Ether'),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        const Spacer(),
                        Column(
                          children: [
                            Text(player.name),
                            const SizedBox(
                              height: 4,
                            ),
                            SizedBox(
                              width: 50,
                              height: 70,
                              child: EtherPoolWidget(
                                ether: widget
                                    .controller.availableEtherFromPersonalPool,
                                isSelectedAtIndex: (index) =>
                                    isSelectedFromPlayerEther(index),
                                onSelectedEther: (ether, index, selected) =>
                                    onSelectedFromPlayerEther(
                                        ether, index, selected),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(width: 1, height: 40, color: Colors.grey),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          children: [
                            Text(resolver.playerTarget.name),
                            const SizedBox(
                              height: 4,
                            ),
                            SizedBox(
                              width: 50,
                              height: 70,
                              child: EtherPoolWidget(
                                ether: resolver.playerTarget.personalEtherPool,
                                isSelectedAtIndex: (index) =>
                                    isSelectedToPlayerEther(index),
                                onSelectedEther: (ether, index, selected) =>
                                    onSelectedToPlayerEther(
                                        ether, index, selected),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                      ],
                    ),
                    const Spacer(),
                    SizedBox(
                      width: 150,
                      height: 32,
                      child: RoverButton(
                          label: 'Confirm Trade',
                          roverClass: player.roverClass,
                          disabled: !canConfirm,
                          onPressed: onConfirm),
                    )
                  ],
                ));
          }),
    );
  }
}
