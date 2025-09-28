import 'package:flutter/material.dart';
import 'package:rove_assistant/theme/rove_palette.dart';
import 'package:rove_assistant/widgets/common/rove_text.dart';
import 'package:rove_data_types/rove_data_types.dart';
import 'action_list_widget.dart';
import 'card_channel_widget.dart';
import 'card_shadow.dart';
import 'rove_action_layout.dart';

class AbilityWidget extends StatelessWidget {
  final AbilityDef ability;
  final int? selectedGroupIndex;
  final int? selectedActionIndex;
  final Function(int)? onSelectedGroup;
  final Color headerColor;
  final Color borderColor;
  final Color backgroundColor;
  final double width;
  final double headerHeight;

  const AbilityWidget({
    super.key,
    required this.ability,
    this.selectedGroupIndex,
    this.selectedActionIndex,
    this.onSelectedGroup,
    Color? headerColor,
    required this.borderColor,
    required this.backgroundColor,
    double? headerHeight,
    required this.width,
  })  : headerColor = headerColor ?? borderColor,
        headerHeight = headerHeight ?? 55;

  factory AbilityWidget.rover({
    required AbilityDef ability,
    int? selectedGroupIndex,
    int? selectedActionIndex,
    Function(int)? onSelectedGroup,
    required RoverClass roverClass,
    Key? key,
  }) {
    return AbilityWidget(
      key: key,
      ability: ability,
      selectedGroupIndex: selectedGroupIndex,
      selectedActionIndex: selectedActionIndex,
      onSelectedGroup: onSelectedGroup,
      borderColor: roverClass.color,
      backgroundColor: roverClass.colorDark,
      width: AbilityWidget.size.width,
    );
  }

  factory AbilityWidget.adversary({
    required AbilityDef ability,
    int? selectedGroupIndex,
    int? selectedActionIndex,
    Function(int)? onSelectedGroup,
    Key? key,
    Color? headerColor,
    Color borderColor = RovePalette.adversaryHealth,
    double? headerHeight,
    double? width,
  }) {
    return AbilityWidget(
      key: key,
      ability: ability,
      selectedGroupIndex: selectedGroupIndex,
      selectedActionIndex: selectedActionIndex,
      onSelectedGroup: onSelectedGroup,
      headerColor: headerColor,
      borderColor: borderColor,
      backgroundColor: RovePalette.adversaryBackground,
      headerHeight: headerHeight,
      width: width ?? AbilityWidget.size.width,
    );
  }

  static Size size = const Size(300, 300);

  @override
  Widget build(BuildContext context) {
    (bool, Widget?) actionBuilder(RoveAction action, int index) {
      if (ability.name == 'Channel') {
        if (index == 0) {
          return (
            true,
            CardChannelWidget(
                borderColor: borderColor, backgroundColor: backgroundColor)
          );
        } else {
          return (false, null);
        }
      }
      return (true, null);
    }

    final actions = ability.actions;
    final rowCount = actions.fold(0, (sum, action) => sum + action.rowCount);
    final compact = rowCount >= 2;

    final id = ability.id;
    return Container(
      width: width,
      height: size.height,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                alignment: const Alignment(0.0, 0.8),
                width: double.infinity,
                height: headerHeight,
                decoration: BoxDecoration(
                  color: headerColor,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(8)),
                ),
                child: CardShadow(
                  child: RoveText.subtitle(
                    ability.name,
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: const Alignment(0, -0.4),
                  child: ActionListWidget(
                    actions: actions,
                    selectedGroupIndex: selectedGroupIndex,
                    selectedActionIndex: selectedActionIndex,
                    actionBuilder: actionBuilder,
                    borderColor: borderColor,
                    backgroundColor: backgroundColor,
                    fontSize: 10,
                    compact: compact,
                  ),
                ),
              ),
            ],
          ),
          if (id != null)
            Positioned(
              bottom: 10,
              right: 10,
              child: CardShadow(
                child: RoveText(
                  id,
                  style: const TextStyle(color: Colors.white, fontSize: 7),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
