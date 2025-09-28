import 'package:flutter/material.dart';
import 'package:rove_assistant/theme/rove_palette.dart';
import 'package:rove_assistant/model/encounter/encounter_model.dart';
import 'package:rove_assistant/widgets/common/rove_icon.dart';
import 'package:rove_assistant/widgets/common/rove_text.dart';
import 'package:rove_assistant/widgets/encounter/encounter_panel.dart';

class EncounterLossConditionPanel extends StatelessWidget {
  const EncounterLossConditionPanel({
    super.key,
    required this.model,
  });

  final EncounterModel model;

  @override
  Widget build(BuildContext context) {
    return EncounterPanel(
        title: 'Loss Condition',
        icon: RoveIcon.small('loss_condition'),
        foregroundColor: RovePalette.lossForeground,
        backgroundColor: RovePalette.lossBackground,
        inWrap: true,
        child: ListenableBuilder(
            listenable: model,
            builder: (context, _) {
              final lossCondition = model.lossCondition ?? '';
              return RoveText.body(lossCondition);
            }));
  }
}
