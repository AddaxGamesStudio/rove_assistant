import 'package:flutter/material.dart';
import 'package:rove_assistant/widgets/common/rove_text.dart';
import 'package:rove_data_types/rove_data_types.dart';
import 'card_shadow.dart';
import 'card_widget.dart';

class ReactionCardWidget extends StatelessWidget {
  final ReactionDef reaction;
  final int? selectedGroupIndex;
  final int? selectedActionIndex;
  final Function(int)? onSelectedGroup;
  final ReactionDef backReaction;
  final RoverClass roverClass;

  const ReactionCardWidget({
    super.key,
    required this.reaction,
    this.selectedGroupIndex,
    this.selectedActionIndex,
    this.onSelectedGroup,
    required this.backReaction,
    required this.roverClass,
  });

  @override
  Widget build(BuildContext context) {
    return CardWidget(
      card: reaction,
      cardType: 'react',
      selectedActionIndex: selectedActionIndex,
      onSelectedGroup: onSelectedGroup,
      backCard: backReaction,
      backCardType: 'react',
      roverClass: roverClass,
      subtitle: CardShadow(
        child: RoveText(
          reaction.trigger.description,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 10, color: Colors.white),
        ),
      ),
    );
  }
}
