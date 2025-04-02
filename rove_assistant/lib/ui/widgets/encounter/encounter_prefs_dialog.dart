import 'package:flutter/material.dart';
import 'package:rove_app_common/model/campaign_model.dart';
import 'package:rove_app_common/style/rove_theme.dart';
import 'package:rove_app_common/widgets/common/rove_dialog.dart';
import 'package:rove_assistant/model/encounter_model.dart';
import 'package:rove_app_common/persistence/preferences.dart';
import 'package:rove_app_common/style/rove_palette.dart';
import 'package:rove_assistant/persistence/preferences_extension.dart';
import 'package:rove_app_common/widgets/common/rove_confirm_dialog.dart';
import 'package:rove_app_common/widgets/common/rover_action_button.dart';

class EncounterPrefsDialog extends StatelessWidget {
  final EncounterModel model;
  const EncounterPrefsDialog({
    super.key,
    required this.model,
  });

  DropdownMenuEntry get _nullEntry => DropdownMenuEntry(
        value: AssistantPreferences.noneValue,
        label: 'None',
      );

  List<DropdownMenuEntry> get _entries => [
        DropdownMenuEntry(
          value: AssistantPreferences.showDetailValue,
          label: 'Show Detail',
        ),
        DropdownMenuEntry(
          value: AssistantPreferences.toggleReactionValue,
          label: 'Toggle Reaction',
        ),
        DropdownMenuEntry(
          value: AssistantPreferences.decreaseHealthValue,
          label: 'Decrease Health',
        ),
      ];

  resetControls(BuildContext context) {
    for (var pref in [
      AssistantPreferences.onTapUnitPref,
      AssistantPreferences.onDoubleTapUnitPref,
      AssistantPreferences.onLongPressUnitPref
    ]) {
      Preferences.instance.setString(pref, AssistantPreferences.defaults[pref]);
    }
  }

  restart(BuildContext context) {
    Navigator.of(context).pop();
    showDialog(
        context: context,
        builder: (context) => RoveConfirmDialog(
            title: 'Restart Encounter',
            message: 'Progress will be lost.',
            confirmTitle: 'Restart',
            color: RovePalette.lossForeground,
            onConfirm: () {
              model.restart();
            }));
  }

  replay(BuildContext context) {
    Navigator.of(context).pop();
    showDialog(
        context: context,
        builder: (context) => RoveConfirmDialog(
            title: 'Replay Encounter',
            message: 'Encounter rewards will not be reset.',
            confirmTitle: 'Replay',
            color: RovePalette.lossForeground,
            onConfirm: () {
              CampaignModel.instance.undoEncounter(model.encounterDef.id);
              model.restart();
            }));
  }

  @override
  Widget build(BuildContext context) {
    return RoveDialog(
        title: 'Encounter Settings',
        color: RovePalette.title,
        body: ListenableBuilder(
            listenable: Preferences.instance,
            builder: (context, _) {
              return Column(
                spacing: RoveTheme.verticalSpacing,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Controls',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  DropdownSetting(
                      title: 'Unit: Tap',
                      preference: AssistantPreferences.onTapUnitPref,
                      entries: _entries),
                  DropdownSetting(
                      title: 'Unit: Double Tap',
                      preference: AssistantPreferences.onDoubleTapUnitPref,
                      entries: [_nullEntry, ..._entries]),
                  DropdownSetting(
                      title: 'Unit: Long Press',
                      preference: AssistantPreferences.onLongPressUnitPref,
                      entries: [_nullEntry, ..._entries]),
                  SizedBox(
                    width: double.infinity,
                    child: RoverActionButton(
                      label: 'Reset Controls',
                      color: RovePalette.title,
                      onPressed: () {
                        resetControls(context);
                      },
                    ),
                  ),
                  if (!model.completed)
                    SizedBox(
                      width: double.infinity,
                      child: RoverActionButton(
                        label: 'Restart Encounter',
                        color: RovePalette.lossForeground,
                        onPressed: () {
                          restart(context);
                        },
                      ),
                    ),
                  if (model.completed)
                    SizedBox(
                      width: double.infinity,
                      child: RoverActionButton(
                        label: 'Replay Encounter',
                        color: RovePalette.lossForeground,
                        onPressed: () {
                          replay(context);
                        },
                      ),
                    ),
                ],
              );
            }));
  }
}

class DropdownSetting extends StatelessWidget {
  const DropdownSetting({
    super.key,
    required this.preference,
    required this.title,
    required this.entries,
  });

  final String title;
  final String preference;
  final List<DropdownMenuEntry> entries;

  void setValue(BuildContext context, String? value) async {
    Preferences.instance.setString(preference, value);
  }

  @override
  Widget build(BuildContext context) {
    final value = Preferences.instance.getString(preference);

    return Row(
      children: [
        Text(title),
        Spacer(),
        DropdownMenu(
            inputDecorationTheme:
                InputDecorationTheme(border: InputBorder.none),
            width: 160,
            textStyle: TextStyle(fontSize: 14),
            dropdownMenuEntries: entries,
            initialSelection: value,
            onSelected: (value) {
              setValue(context, value);
            })
      ],
    );
  }
}
