import 'package:flutter/material.dart';
import 'package:rove_assistant/widgets/common/rove_icon.dart';
import 'package:rove_data_types/rove_data_types.dart';
import 'card_shadow.dart';
import 'card_widget.dart';

class SkillCardWidget extends StatelessWidget {
  final SkillDef skill;
  final int? selectedActionIndex;
  final int? selectedGroupIndex;
  final Function(int)? onSelectedGroup;
  final SkillDef backSkill;
  final RoverClass roverClass;

  const SkillCardWidget({
    super.key,
    required this.skill,
    this.selectedGroupIndex,
    this.selectedActionIndex,
    this.onSelectedGroup,
    required this.backSkill,
    required this.roverClass,
  });

  @override
  Widget build(BuildContext context) {
    return CardWidget(
        card: skill,
        cardType: skill.type.name,
        selectedActionIndex: selectedActionIndex,
        onSelectedGroup: onSelectedGroup,
        backCard: backSkill,
        backCardType: backSkill.type.name,
        roverClass: roverClass,
        subtitle: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 4,
          children: List.generate(
                skill.etherCost,
                (_) =>
                    const CardShadow(child: RoveIcon('ether_dice', height: 20)),
              ) +
              List.generate(
                  skill.abilityCost,
                  (_) => const CardShadow(
                      child: RoveIcon('ability_cost', height: 20))),
        ));
  }
}
