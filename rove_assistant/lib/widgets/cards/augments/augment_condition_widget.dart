import 'package:flutter/material.dart';
import 'package:rove_assistant/widgets/common/rove_icon.dart';
import 'package:rove_data_types/rove_data_types.dart';

class AugmentConditionWidget extends StatelessWidget {
  const AugmentConditionWidget({
    super.key,
    required this.condition,
  });

  final AugmentCondition condition;

  @override
  Widget build(BuildContext context) {
    const double iconSize = 22.0;
    switch (condition.type) {
      case AugmentConditionType.personalPoolEther:
        final ethersToDrain = (condition as PersonalPoolEtherCondition).ethers;
        if (ethersToDrain.length == 1) {
          return RoveIcon(
            'drain_${ethersToDrain.first.name}',
            height: iconSize,
          );
        } else {
          return const SizedBox.shrink();
        }
      case AugmentConditionType.infuse:
        return const RoveIcon(
          'ether_dice',
          height: iconSize,
        );
      case AugmentConditionType.personalPoolNonDim:
        return const RoveIcon(
          'drain_wild',
          height: iconSize,
        );
      case AugmentConditionType.etherCheck:
        final ethersToCheck = (condition as EtherCheckCondition).ethers;
        if (ethersToCheck.isNotEmpty) {
          return RoveIcon(
            'check_${ethersToCheck.map((e) => e.name).join('_')}',
            height: iconSize,
          );
        } else {
          return const SizedBox.shrink();
        }

      default:
        return const SizedBox.shrink();
    }
  }
}
