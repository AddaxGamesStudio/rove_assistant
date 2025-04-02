import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:rove_simulator/assets.dart';
import 'package:rove_data_types/rove_data_types.dart';

class EtherPoolWidget extends StatelessWidget {
  const EtherPoolWidget({
    super.key,
    required this.ether,
    this.isSelectedAtIndex,
    this.onSelectedEther,
  });

  final List<Ether> ether;
  final Function(int)? isSelectedAtIndex;
  final Function(Ether, int, bool)? onSelectedEther;

  onSelectedEtherAtIndex(Ether ether, int index) {
    final bool selected = !(isSelectedAtIndex?.call(index) == true);
    onSelectedEther?.call(ether, index, selected);
  }

  @override
  Widget build(BuildContext context) {
    Widget etherIcon(Ether ether, int index) {
      if (isSelectedAtIndex?.call(index) == true) {
        return Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.yellow.shade800, width: 2)),
          child: Assets.etherImage(ether),
        );
      } else {
        return SizedBox(width: 16, height: 16, child: Assets.etherImage(ether));
      }
    }

    return Wrap(
        direction: Axis.vertical,
        runSpacing: 8,
        spacing: 8,
        children: ether
            .mapIndexed((i, e) => GestureDetector(
                onTap: () => onSelectedEtherAtIndex(e, i),
                child: etherIcon(e, i)))
            .toList());
  }
}
