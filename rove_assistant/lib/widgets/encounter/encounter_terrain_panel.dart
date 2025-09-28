import 'package:flutter/material.dart';
import 'package:rove_assistant/theme/rove_theme.dart';
import 'package:rove_assistant/model/encounter/encounter_model.dart';
import 'package:rove_assistant/theme/rove_palette.dart';
import 'package:rove_assistant/theme/rove_assets.dart';
import 'package:rove_assistant/widgets/common/rove_dialog.dart';
import 'package:rove_assistant/widgets/common/rove_icon.dart';
import 'package:rove_assistant/widgets/common/rove_text.dart';
import 'package:rove_assistant/widgets/encounter/encounter_panel.dart';
import 'package:rove_data_types/rove_data_types.dart';

class EncounterTerrainPanel extends StatelessWidget {
  final EncounterModel model;

  const EncounterTerrainPanel({
    super.key,
    required this.model,
  });

  _onTerrainSelected(BuildContext context, EncounterTerrain terrain) {
    showDialog(
        context: context,
        builder: (context) {
          return EncounterTerrainDialog(terrain);
        });
  }

  @override
  Widget build(BuildContext context) {
    return EncounterPanel(
        title: 'Terrain',
        foregroundColor: RovePalette.terrainForeground,
        backgroundColor: RovePalette.terrainBackground,
        icon: RoveIcon.small('terrain'),
        inWrap: true,
        child: ListenableBuilder(
            listenable: model,
            builder: (contex, _) {
              return Center(
                child: Wrap(
                    spacing: RoveTheme.horizontalSpacing,
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: model.terrain.map((terrain) {
                      final damage = terrain.damage;
                      return Stack(
                        children: [
                          IconButton(
                              tooltip: terrain.title,
                              onPressed: () {
                                _onTerrainSelected(context, terrain);
                              },
                              icon: SizedBox(
                                  width: 48,
                                  height: 48,
                                  child: Image.asset(
                                      RoveAssets.assetForTerrain(terrain)))),
                          if (damage != null)
                            Positioned(
                                bottom: 0,
                                right: 0,
                                child: GestureDetector(
                                    onTap: () {
                                      _onTerrainSelected(context, terrain);
                                    },
                                    child: _DamageIndicator(damage: damage)))
                        ],
                      );
                    }).toList()),
              );
            }));
  }
}

class _DamageIndicator extends StatelessWidget {
  const _DamageIndicator({
    required this.damage,
  });

  final int? damage;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        RoveIcon(
          'damage',
          width: 32,
          height: 32,
          color: RovePalette.terrainDangerous,
        ),
        Positioned(
          top: 0,
          bottom: 0,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: RovePalette.terrainDangerous,
              ),
            ),
          ),
        ),
        Positioned(
          top: 0,
          bottom: 0,
          left: 0,
          right: 0,
          child: Center(
            child: RoveText.label(
              damage.toString(),
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        )
      ],
    );
  }
}

class EncounterTerrainDialog extends StatelessWidget {
  final EncounterTerrain terrain;

  const EncounterTerrainDialog(this.terrain, {super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
        backgroundColor: Colors.transparent,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: RoveTheme.dialogMinWidth,
            maxWidth: RoveTheme.dialogMaxWidth,
          ),
          child: EncounterPanel(
              title: terrain.title,
              foregroundColor: RovePalette.terrainForeground,
              backgroundColor: RovePalette.terrainBackground,
              icon: RoveIcon.small('terrain'),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: RoveTheme.verticalSpacing,
                children: [
                  Row(
                    spacing: 12,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                          width: 64,
                          height: 64,
                          child:
                              Image.asset(RoveAssets.assetForTerrain(terrain))),
                      Expanded(
                        child: RoveText.body(
                          terrain.body ?? '',
                          color: Colors.grey.shade900,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Spacer(),
                      RoveDialogActionButton(
                        color: RovePalette.terrainForeground,
                        title: 'Continue',
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ],
              )),
        ));
  }
}
