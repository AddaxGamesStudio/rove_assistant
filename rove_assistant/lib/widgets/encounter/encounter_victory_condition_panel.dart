import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:rove_assistant/model/encounter/encounter_model.dart';
import 'package:rove_assistant/theme/rove_palette.dart';
import 'package:rove_assistant/widgets/common/rove_icon.dart';
import 'package:rove_assistant/widgets/common/rove_text.dart';
import 'package:rove_assistant/widgets/encounter/encounter_panel.dart';

class EncounterVictoryConditionPanel extends StatefulWidget {
  final EncounterModel model;

  const EncounterVictoryConditionPanel({
    super.key,
    required this.model,
  });

  @override
  State<EncounterVictoryConditionPanel> createState() =>
      _EncounterVictoryConditionPanelState();
}

class _EncounterVictoryConditionPanelState
    extends State<EncounterVictoryConditionPanel> {
  late String _previousObjective;

  @override
  void initState() {
    super.initState();
    _previousObjective = widget.model.objective;
  }

  @override
  Widget build(BuildContext context) {
    Widget victoryConditionText() {
      final String objective = widget.model.objective;
      final objectiveChanged = _previousObjective != objective;
      _previousObjective = objective;
      final textWidget = RoveText.body(objective);
      return objectiveChanged
          ? AvatarGlow(
              key: ValueKey<String>(objective),
              glowColor: RovePalette.victoryForeground,
              repeat: false,
              child: textWidget)
          : textWidget;
    }

    return ListenableBuilder(
        listenable: widget.model,
        builder: (context, _) {
          return EncounterPanel(
            foregroundColor: RovePalette.victoryForeground,
            backgroundColor: RovePalette.victoryBackground,
            footerColor: RovePalette.victoryFooter,
            title: 'Victory Condition',
            icon: RoveIcon.small('victory_condition'),
            inWrap: true,
            footer: Align(
              alignment: Alignment.centerRight,
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text('Round limit: ${widget.model.roundLimit}',
                      style: TextStyle(color: Colors.white)),
                  RoveIcon(
                    'round',
                    width: 22,
                    height: 22,
                  ),
                ],
              ),
            ),
            child: Row(
              children: [
                Expanded(child: victoryConditionText()),
                if (!widget.model.failed)
                  SizedBox(
                      height: 36,
                      child: Tooltip(
                        message: 'Force Complete Encounter',
                        child: Checkbox(
                            checkColor: Colors.white,
                            fillColor:
                                WidgetStateProperty.resolveWith((states) {
                              if (states.contains(WidgetState.selected)) {
                                return RovePalette.victoryForeground;
                              } else {
                                return null;
                              }
                            }),
                            value: widget.model.isObjectiveAchieved,
                            onChanged: (bool? value) {
                              widget.model.setObjectiveAchieved(value!);
                            }),
                      )),
              ],
            ),
          );
        });
  }
}
