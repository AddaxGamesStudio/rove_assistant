import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rove_app_common/data/campaign_loader.dart';
import 'package:rove_data_types/rove_data_types.dart';
import 'package:rove_editor/convert/encounter_to_dart.dart';
import 'package:rove_editor/data/encounter_def_ext.dart';
import 'package:rove_editor/flame/map_editor.dart';
import 'package:rove_editor/controller/editor_controller.dart';
import 'package:rove_editor/widgets/tools/dialog_utils.dart';

class EditorMenu extends StatefulWidget {
  final MapEditor editor;

  const EditorMenu({
    required this.editor,
    super.key,
  });

  @override
  State<EditorMenu> createState() => _EditorMenuState();
}

class _EditorMenuState extends State<EditorMenu> {
  ShortcutRegistryEntry? _shortcutRegistryEntry;

  @override
  dispose() {
    _shortcutRegistryEntry?.dispose();
    super.dispose();
  }

  menuNew() async {
    EditorController.instance.encounter = EncounterData.newEncounter();
  }

  open() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      withData: true,
      allowedExtensions: ['json'],
    );
    final bytes = result?.files.firstOrNull?.bytes;
    if (bytes == null) {
      return;
    }
    String data = utf8.decode(bytes);
    final encounter = CampaignLoader.loadEncounterFromJson(data);
    if (encounter == null) {
      return;
    }
    openEncounter(encounter);
  }

  openEncounter(EncounterDef encounter) {
    EditorController.instance.encounter = encounter;
  }

  save() async {
    final encounter = EditorController.instance.model.toEncounterDef();
    final path = await FilePicker.platform.saveFile(
      dialogTitle: 'Save Encounter',
      fileName: '${encounter.id}.json',
    );
    if (path == null) {
      return;
    }
    final file = File(path);
    final contents = json.encode(encounter);
    await file.writeAsString(contents);
  }

  saveAsDart() async {
    final encounter = EditorController.instance.model.toEncounterDef();
    final path = await FilePicker.platform.saveFile(
      dialogTitle: 'Save Encounter',
      fileName: 'encounter_${encounter.id.replaceAll('.', '_')}.dart',
    );
    if (path == null) {
      return;
    }
    final file = File(path);
    final string = encounter.toDartCode();
    await file.writeAsString(string);
  }

  toggleForeground() {
    widget.editor.map.toggleForeground();
  }

  addPlacementGroup(BuildContext context, {required bool replacesMap}) async {
    addPlacementGroupNamed(String name) {
      EditorController.instance
          .addPlacementGroup(name, replacesMap: replacesMap);
    }

    final text = await showTextInputDialog(
        context: context,
        title: replacesMap ? 'Map Name' : 'Placement Group Name');
    if (text != null) {
      addPlacementGroupNamed(text);
    }
  }

  @override
  Widget build(BuildContext context) {
    _shortcutRegistryEntry?.dispose();
    _shortcutRegistryEntry = ShortcutRegistry.of(context).addAll({
      SingleActivator(LogicalKeyboardKey.keyT, control: true):
          VoidCallbackIntent(toggleForeground),
    });

    return MenuBar(
      children: [
        SubmenuButton(menuChildren: [
          MenuItemButton(onPressed: menuNew, child: Text('New')),
          MenuItemButton(onPressed: open, child: Text('Open')),
          MenuItemButton(onPressed: save, child: Text('Save')),
          MenuItemButton(onPressed: saveAsDart, child: Text('Save As Dart'))
        ], child: Text('File')),
        SubmenuButton(menuChildren: [
          MenuItemButton(
              onPressed: () {
                addPlacementGroup(context, replacesMap: false);
              },
              child: Text('Add Placement Group')),
          MenuItemButton(
              onPressed: () {
                addPlacementGroup(context, replacesMap: true);
              },
              child: Text('Add Map')),
        ], child: Text('Edit')),
        SubmenuButton(menuChildren: [
          MenuItemButton(
            onPressed: toggleForeground,
            shortcut: SingleActivator(LogicalKeyboardKey.keyT, control: true),
            child: Text('Toggle Foreground'),
          ),
        ], child: Text('View')),
        SubmenuButton(
            menuChildren: EncounterData.encounters
                .map((pair) => SubmenuButton(
                    menuChildren: pair.$2
                        .map((e) => MenuItemButton(
                            onPressed: () {
                              openEncounter(e);
                            },
                            child: Text('Encounter ${e.id}')))
                        .toList(),
                    child: Text(pair.$1)))
                .toList(),
            child: Text('Encounters'))
      ],
    );
  }
}
