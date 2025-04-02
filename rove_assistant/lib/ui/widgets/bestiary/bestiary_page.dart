import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rove_app_common/data/campaign_loader.dart';
import 'package:rove_app_common/model/campaign_model.dart';
import 'package:rove_app_common/style/rove_palette.dart';
import 'package:rove_app_common/style/rove_theme.dart';
import 'package:rove_app_common/widgets/common/rove_text.dart';
import 'package:rove_assistant/ui/rove_assets.dart';
import 'package:rove_assistant/ui/styles.dart';
import 'package:rove_assistant/ui/widgets/bestiary/bestiary_adversary_detail.dart';
import 'package:rove_assistant/ui/widgets/encounter/figure_hexagon.dart';
import 'package:rove_data_types/rove_data_types.dart';

class BestiaryPage extends StatelessWidget {
  const BestiaryPage({super.key});

  assetPathForAdversary(FigureDef adversary) {
    return CampaignModel.instance.campaignDefinition.pathForImage(
        type: CampaignAssetType.figure,
        src: adversary.image,
        expansion: adversary.expansion);
  }

  _onAdversarySelected(BuildContext context, FigureDef adversary) async {
    final record =
        CampaignModel.instance.recordOfAdversaryNamed(adversary.name) ??
            (kDebugMode ? AdversaryRecord(name: adversary.name) : null);
    if (record == null) {
      return;
    }
    final codexNumber = adversary.codices.firstOrNull;
    late final Codex? codex;
    if (codexNumber != null) {
      codex = await CampaignLoader.loadCodex(context, codexNumber,
          expansion: adversary.expansion);
    } else {
      codex = null;
    }
    if (!context.mounted) {
      return;
    }
    showDialog(
        context: context,
        builder: (_) {
          return BestiaryAdversaryDetail(
            name: adversary.displayName,
            adversaryType: adversary.adversaryType,
            asset: assetPathForAdversary(adversary),
            record: record,
            codex: codex,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final adversaries = CampaignModel
        .instance.campaignDefinition.adversaries.values
        .where((a) => !a.excludeFromBestiary)
        .toList();

    Widget wrap(List<FigureDef> adversaries, AdversaryType type) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        spacing: RoveTheme.verticalSpacing,
        children: [
          Row(
            spacing: RoveTheme.horizontalSpacing,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(labelForType(type),
                  style: RoveStyles.titleStyle(
                    color: Colors.white70,
                  )),
              RoveAssets.iconForAdversaryType(type, color: Colors.white70),
            ],
          ),
          Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.start,
              spacing: spacingFoType(type),
              runSpacing: 16,
              children: adversaries
                  .where((a) => a.adversaryType == type)
                  .map((adversary) {
                final record = CampaignModel.instance
                    .recordOfAdversaryNamed(adversary.name);
                final locked = record == null && !kDebugMode;
                return GestureDetector(
                    onTap: () {
                      if (locked) {
                        return;
                      }
                      _onAdversarySelected(context, adversary);
                    },
                    child: Column(
                      spacing: 4,
                      children: [
                        FigureHexagon(
                          asset: assetPathForAdversary(adversary),
                          borderColor: RovePalette.adversaryInnerBorder,
                          tileType: adversary.large
                              ? TileType.fourHex
                              : TileType.single,
                          height: 80,
                          heightScale: 1.2,
                          locked: locked,
                        ),
                        SizedBox(
                          width: 120,
                          child: RoveText.subtitle(
                            locked ? '?' : adversary.displayName,
                            textAlign: TextAlign.center,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ));
              }).toList()),
        ],
      );
    }

    return Scaffold(
      backgroundColor: RovePalette.adversaryBackground,
      body: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 12,
              children: [
                wrap(adversaries, AdversaryType.minion),
                wrap(adversaries, AdversaryType.miniboss),
                wrap(adversaries, AdversaryType.boss),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String labelForType(AdversaryType type) {
    switch (type) {
      case AdversaryType.minion:
        return 'Minions';
      case AdversaryType.miniboss:
        return 'Mini-bosses';
      case AdversaryType.boss:
        return 'Bosses';
    }
  }

  double spacingFoType(AdversaryType type) {
    switch (type) {
      case AdversaryType.minion:
        return 12;
      case AdversaryType.miniboss:
        return 24;
      case AdversaryType.boss:
        return 48;
    }
  }
}
