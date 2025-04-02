import 'package:flutter/material.dart';
import 'package:rove_app_common/model/campaign_model.dart';
import 'package:rove_data_types/rove_data_types.dart';
import 'package:rove_editor/editor_assets.dart';
import 'package:rove_editor/data/terrain_type_ext.dart';
import 'package:rove_editor/controller/editor_controller.dart';
import 'package:rove_editor/widgets/tools/basic_tools_expansion_tile.dart';
import 'package:rove_editor/widgets/tools/tool_tile.dart';

class ToolsWidget extends StatelessWidget {
  const ToolsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final editor = EditorController.instance;
    return ListenableBuilder(
        listenable: editor,
        builder: (context, _) {
          return ListView(
            shrinkWrap: true,
            children: [
              BasicToolsExpansionTile(editor: editor),
              ExpansionTile(
                title: Text('Terrain',
                    style:
                        TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                children: TerrainType.values
                    .map((t) => TerrainTile(editor: editor, terrain: t))
                    .toList(),
              ),
              ExpansionTile(
                title: Text('Adversaries',
                    style:
                        TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                children: CampaignModel
                    .instance.campaignDefinition.adversaries.entries
                    .map((t) => AdversaryTile(
                        editor: editor, name: t.key, adversary: t.value))
                    .toList(),
              ),
              ExpansionTile(
                title: Text('Ether',
                    style:
                        TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                children: Ether.values
                    .map((e) => EtherTitle(editor: editor, ether: e))
                    .toList(),
              ),
              ExpansionTile(
                title: Text('Objects',
                    style:
                        TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                children: CampaignModel
                    .instance.campaignDefinition.objects.entries
                    .map((t) => ObjectTile(
                        editor: editor, name: t.key, object: t.value))
                    .toList(),
              ),
              ExpansionTile(
                title: Text('Traps',
                    style:
                        TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                children: TrapType.values
                    .map((t) => TrapTile(editor: editor, trap: t))
                    .toList(),
              ),
              ExpansionTile(
                title: Text('Spawn Points',
                    style:
                        TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                children: Ether.values
                    .map((e) => SpawnSpointTitle(editor: editor, ether: e))
                    .toList(),
              ),
              ExpansionTile(
                title: Text('Ether Fields',
                    style:
                        TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                children: EtherField.values
                    .map((e) => EtherFieldTitle(editor: editor, field: e))
                    .toList(),
              ),
            ],
          );
        });
  }
}

class ObjectTile extends StatelessWidget {
  const ObjectTile({
    super.key,
    required this.editor,
    required this.name,
    required this.object,
  });
  final EditorController editor;
  final String name;
  final FigureDef object;

  void onTap() async {
    await Assets.campaignImages
        .loadEntity(object.image, expansion: object.expansion);
    editor.toolObject = object;
  }

  @override
  Widget build(BuildContext context) {
    final bool selected = editor.toolObject?.name == object.name;
    return FigureTile(
        editor: editor,
        name: name,
        figure: object,
        selected: selected,
        onTap: onTap);
  }
}

class AdversaryTile extends StatelessWidget {
  const AdversaryTile({
    super.key,
    required this.editor,
    required this.name,
    required this.adversary,
  });
  final EditorController editor;
  final String name;
  final FigureDef adversary;

  void onTap() async {
    await Assets.campaignImages
        .loadEntity(adversary.image, expansion: adversary.expansion);
    editor.toolAdversary = adversary;
  }

  @override
  Widget build(BuildContext context) {
    final bool selected = editor.toolAdversary?.name == adversary.name;
    return FigureTile(
        editor: editor,
        name: name,
        figure: adversary,
        selected: selected,
        onTap: onTap);
  }
}

class FigureTile extends StatelessWidget {
  const FigureTile({
    super.key,
    required this.editor,
    required this.name,
    required this.figure,
    required this.selected,
    required this.onTap,
  });
  final EditorController editor;
  final String name;
  final FigureDef figure;
  final bool selected;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    final bool selected = editor.toolAdversary?.name == figure.name;
    return DecoratedBox(
      decoration: BoxDecoration(
          border: Border.all(
        color: selected ? Colors.grey : Colors.transparent,
        width: selected ? 2 : 0,
      )),
      child: ListTile(
        contentPadding: EdgeInsets.all(0),
        leading: Image.asset(
          Assets.pathForEntityImage(figure.image, expansion: figure.expansion),
          width: 32,
          fit: BoxFit.cover,
        ),
        title: Text(name,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        selected: selected,
        onTap: onTap,
      ),
    );
  }
}

class TerrainTile extends StatelessWidget {
  const TerrainTile({
    super.key,
    required this.editor,
    required this.terrain,
  });

  final EditorController editor;
  final TerrainType terrain;

  @override
  Widget build(BuildContext context) {
    final bool selected = editor.toolTerrain == terrain;
    return ToolTile(
        title: terrain.label,
        tileColor: terrain.color,
        selected: selected,
        onTap: () {
          editor.toolTerrain = terrain;
        });
  }
}

class SpawnSpointTitle extends StatelessWidget {
  const SpawnSpointTitle({
    super.key,
    required this.editor,
    required this.ether,
  });

  final EditorController editor;
  final Ether ether;

  @override
  Widget build(BuildContext context) {
    final bool selected = editor.toolSpawnPoint == ether;
    return ToolTile(
        title: ether.label,
        selected: selected,
        onTap: () {
          editor.toolSpawnPoint = ether;
        },
        leading: Image(
          image: Assets.etherImage(ether).image,
          width: 32,
          fit: BoxFit.cover,
        ));
  }
}

class EtherTitle extends StatelessWidget {
  const EtherTitle({
    super.key,
    required this.editor,
    required this.ether,
  });

  final EditorController editor;
  final Ether ether;

  @override
  Widget build(BuildContext context) {
    final bool selected = editor.toolEther == ether;
    return ToolTile(
        title: ether.label,
        selected: selected,
        onTap: () {
          editor.toolEther = ether;
        },
        leading: Image(
          image: Assets.etherImage(ether).image,
          width: 32,
          fit: BoxFit.cover,
        ));
  }
}

class EtherFieldTitle extends StatelessWidget {
  const EtherFieldTitle({
    super.key,
    required this.editor,
    required this.field,
  });

  final EditorController editor;
  final EtherField field;

  @override
  Widget build(BuildContext context) {
    final bool selected = editor.toolField == field;
    return ToolTile(
        title: field.label,
        selected: selected,
        onTap: () {
          editor.toolField = field;
        },
        leading: Image(
          image: Assets.fieldImage(field).image,
          width: 32,
          fit: BoxFit.cover,
        ));
  }
}

class TrapTile extends StatelessWidget {
  const TrapTile({
    super.key,
    required this.editor,
    required this.trap,
  });

  final EditorController editor;
  final TrapType trap;

  @override
  Widget build(BuildContext context) {
    final bool selected = editor.toolTrap == trap.label;
    return ToolTile(
        title: trap.label,
        selected: selected,
        onTap: () {
          editor.toolTrap = trap.label;
        },
        leading: Image.asset(
            Assets.pathForAppImage('trap_${trap.toJson()}.png'),
            width: 32,
            fit: BoxFit.cover));
  }
}
