import 'package:flutter/material.dart';
import 'package:rove_editor/controller/editor_controller.dart';
import 'package:rove_editor/widgets/tools/dialog_utils.dart';
import 'package:rove_editor/widgets/tools/tool_tile.dart';

class BasicToolsExpansionTile extends StatelessWidget {
  const BasicToolsExpansionTile({
    super.key,
    required this.editor,
  });

  final EditorController editor;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
        title: Text('Tools',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        children: [
          ToolTile(
            title: 'Select',
            selected: editor.isSelect,
            onTap: () {
              editor.clearTools();
            },
            leading: Icon(Icons.select_all),
          ),
          ToolTile(
            title: 'Delete',
            selected: editor.toolClear,
            onTap: () {
              editor.toolClear = !editor.toolClear;
            },
            leading: Icon(Icons.clear),
          ),
          ToolTile(
              title:
                  'Feature${editor.toolFeature != null ? ': ${editor.toolFeature}' : ''}',
              selected: editor.toolFeature != null,
              onTap: () async {
                if (editor.toolFeature == null) {
                  final text = await showTextInputDialog(
                      context: context, title: 'Feature Name');
                  if (text != null) {
                    editor.toolFeature = text;
                  }
                } else {
                  editor.toolFeature = null;
                }
              },
              leading: Icon(Icons.label))
        ]);
  }
}
