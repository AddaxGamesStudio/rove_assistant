import 'package:flutter/material.dart';
import 'package:rove_simulator/model/tiles/player_unit_model.dart';
import 'package:rove_simulator/widgets/game_dialog.dart';
import 'package:rove_simulator/widgets/encounter/rovers/ether_pool_widget.dart';
import 'package:rove_simulator/widgets/encounter/rovers/rover_button.dart';
import 'package:rove_data_types/rove_data_types.dart';

class GenerateEtherDialog extends StatefulWidget {
  final PlayerUnitModel player;
  final List<Ether> etherOptions;
  final Function(Ether) onSelectedEther;

  const GenerateEtherDialog(
      {super.key,
      required this.player,
      required this.etherOptions,
      required this.onSelectedEther});

  @override
  State<GenerateEtherDialog> createState() => _GenerateEtherDialogState();
}

class _GenerateEtherDialogState extends State<GenerateEtherDialog> {
  PlayerUnitModel get player => widget.player;

  (Ether, int)? selectedEther;

  bool isSelected(int index) {
    return selectedEther?.$2 == index;
  }

  onSelected(Ether ether, int index, bool selected) {
    setState(() {
      selectedEther = selected ? (ether, index) : null;
    });
  }

  bool get canConfirm => selectedEther != null;

  onConfirm() {
    if (!canConfirm) return;
    widget.onSelectedEther(selectedEther!.$1);
  }

  @override
  Widget build(BuildContext context) {
    return GameDialog(
      color: player.color,
      child: SizedBox(
          width: 100,
          height: 150,
          child: Column(
            children: [
              const Text('Select Ether to Generate'),
              const SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  const Spacer(),
                  Column(
                    children: [
                      EtherPoolWidget(
                        ether: widget.etherOptions,
                        isSelectedAtIndex: (index) => isSelected(index),
                        onSelectedEther: (ether, index, selected) =>
                            onSelected(ether, index, selected),
                      ),
                    ],
                  ),
                  const Spacer(),
                ],
              ),
              const Spacer(),
              SizedBox(
                width: 100,
                height: 32,
                child: RoverButton(
                    label: 'Confirm',
                    roverClass: player.roverClass,
                    disabled: !canConfirm,
                    onPressed: onConfirm),
              )
            ],
          )),
    );
  }
}
