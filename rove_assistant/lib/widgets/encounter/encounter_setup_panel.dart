import 'package:flutter/material.dart';
import 'package:rove_assistant/theme/rove_palette.dart';
import 'package:rove_assistant/theme/rove_theme.dart';
import 'package:rove_assistant/model/encounter/encounter_model.dart';
import 'package:rove_assistant/widgets/common/rove_dialog.dart';
import 'package:rove_assistant/widgets/common/rove_icon.dart';
import 'package:rove_assistant/widgets/common/rove_text.dart';
import 'package:rove_assistant/widgets/encounter/encounter_panel.dart';
import 'package:rove_data_types/rove_data_types.dart';

class EncounterSetupPanel extends StatelessWidget {
  const EncounterSetupPanel({
    super.key,
    required this.model,
  });

  final EncounterModel model;

  @override
  Widget build(BuildContext context) {
    return EncounterPanel(
        title: 'Setup',
        icon: RoveIcon.small('setup'),
        foregroundColor: RovePalette.setupForeground,
        backgroundColor: RovePalette.setupBackground,
        inWrap: true,
        child: ListenableBuilder(
            listenable: model,
            builder: (context, _) {
              final setup = model.setup ??
                  EncounterSetup(box: '', map: '', adversary: '');
              return _SetupBody(setup: setup);
            }));
  }
}

class _SetupBody extends StatelessWidget {
  const _SetupBody({
    required this.setup,
  });

  final EncounterSetup setup;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RoveText.body(
            'Take [tuckbox] [quest] ${setup.box} ▸ Go to [map] ${setup.map} ▸ Go to [adversary] ${setup.adversary}.'),
        if (setup.tiles != null)
          Divider(
            color: RovePalette.setupForeground,
            thickness: 2,
            height: 24,
          ),
        if (setup.tiles != null) RoveText.body('Tiles: ${setup.tiles}'),
      ],
    );
  }
}

class EncounterEventSetupPage extends StatelessWidget {
  const EncounterEventSetupPage({
    super.key,
    required this.model,
    required this.onContinue,
  });

  final EncounterModel model;
  final Function() onContinue;

  @override
  Widget build(BuildContext context) {
    final setup =
        model.setup ?? EncounterSetup(box: '', map: '', adversary: '');

    return EncounterPanel(
        title: 'Setup',
        icon: RoveIcon.small('setup'),
        foregroundColor: RovePalette.setupForeground,
        backgroundColor: RovePalette.setupBackground,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          spacing: RoveTheme.verticalSpacing,
          children: [
            _SetupBody(setup: setup),
            Row(
              children: [
                Spacer(),
                RoveDialogActionButton(
                  color: RovePalette.setupForeground,
                  title: 'Continue',
                  onPressed: () {
                    onContinue();
                  },
                ),
              ],
            ),
          ],
        ));
  }
}
