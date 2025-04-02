import 'package:flutter/material.dart';
import 'package:rove_simulator/controller/turn_controller.dart';
import 'package:rove_simulator/model/tiles/player_unit_model.dart';
import 'package:rove_simulator/widgets/game_dialog.dart';
import 'package:rove_simulator/widgets/encounter/rovers/ether_pool_widget.dart';
import 'package:rove_simulator/widgets/encounter/rovers/rover_button.dart';
import 'package:rove_data_types/rove_data_types.dart';

class ExceesEtherDialog extends StatefulWidget {
  final TurnController controller;

  const ExceesEtherDialog({super.key, required this.controller});

  @override
  State<ExceesEtherDialog> createState() => _ExceesEtherDialogState();
}

class _ExceesEtherDialogState extends State<ExceesEtherDialog> {
  PlayerUnitModel get player => widget.controller.model.currentPlayer!;

  final List<(Ether, int)> _selectedEtherPoolEther = [];
  final List<(Ether, int)> _selectedInfusedEther = [];

  bool isSelectedFromEtherPool(int index) {
    return _selectedEtherPoolEther.any((e) => e.$2 == index);
  }

  _onSelectedEther(Ether ether, int index, bool selected,
      List<(Ether, int)> list, List<Ether> currentEther) {
    if (selected) {
      if (currentEther.length - list.length <= player.roverClass.etherLimit) {
        list.removeAt(0);
      }
      list.add((ether, index));
    } else {
      list.removeWhere((element) => element.$2 == index);
    }
  }

  onSelectedFromEtherPool(Ether ether, int index, bool selected) {
    setState(() {
      _onSelectedEther(ether, index, selected, _selectedEtherPoolEther,
          player.personalEtherPool);
    });
  }

  bool isSelectedFromInfused(int index) {
    return _selectedInfusedEther.any((e) => e.$2 == index);
  }

  onSelectedFromInfused(Ether ether, int index, bool selected) {
    setState(() {
      _onSelectedEther(ether, index, selected, _selectedInfusedEther,
          player.infusedEtherPool);
    });
  }

  bool get canConfirm =>
      player.personalEtherPool.length - _selectedEtherPoolEther.length <=
          player.roverClass.etherLimit &&
      player.infusedEtherPool.length - _selectedInfusedEther.length <=
          player.roverClass.etherLimit;

  onCancel() {
    widget.controller.cancelExceesEther();
  }

  onConfirm() {
    if (!canConfirm) return;

    widget.controller
        .removeExceesEther(_selectedEtherPoolEther, _selectedInfusedEther);
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
                    const Text('Remove Excess Ether'),
                    Text('Ether Limit: ${player.roverClass.etherLimit}'),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        const Spacer(),
                        Column(
                          children: [
                            const Text('Personal Pool'),
                            const SizedBox(
                              height: 4,
                            ),
                            SizedBox(
                              width: 60,
                              height: 70,
                              child: EtherPoolWidget(
                                ether: player.personalEtherPool,
                                isSelectedAtIndex: (index) =>
                                    isSelectedFromEtherPool(index),
                                onSelectedEther: (ether, index, selected) =>
                                    onSelectedFromEtherPool(
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
                            const Text('Infused Ether'),
                            const SizedBox(
                              height: 4,
                            ),
                            SizedBox(
                              width: 60,
                              height: 70,
                              child: EtherPoolWidget(
                                ether: player.infusedEtherPool,
                                isSelectedAtIndex: (index) =>
                                    isSelectedFromInfused(index),
                                onSelectedEther: (ether, index, selected) =>
                                    onSelectedFromInfused(
                                        ether, index, selected),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        const Spacer(),
                        SizedBox(
                          width: 120,
                          height: 32,
                          child: RoverButton(
                              label: 'Cancel',
                              color: player.color,
                              onPressed: onCancel),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          width: 120,
                          height: 32,
                          child: RoverButton(
                              label: 'Confirm Removal',
                              roverClass: player.roverClass,
                              disabled: !canConfirm,
                              onPressed: onConfirm),
                        ),
                        const Spacer(),
                      ],
                    )
                  ],
                ));
          }),
    );
  }
}
