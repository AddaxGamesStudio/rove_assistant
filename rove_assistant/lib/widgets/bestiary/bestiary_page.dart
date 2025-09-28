import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:rove_assistant/theme/rove_palette.dart';
import 'package:rove_assistant/theme/rove_theme.dart';
import 'package:rove_assistant/data/campaign_loader.dart';
import 'package:rove_assistant/model/campaign_model.dart';
import 'package:rove_assistant/services/analytics.dart';
import 'package:rove_assistant/theme/rove_assets.dart';
import 'package:rove_assistant/widgets/bestiary/bestiary_adversary_detail.dart';
import 'package:rove_assistant/widgets/common/rove_text.dart';
import 'package:rove_assistant/widgets/encounter/figure_hexagon.dart';
import 'package:rove_data_types/rove_data_types.dart';

import '../common/background_box.dart';

class BestiaryPage extends StatelessWidget {
  final Widget? appBarLeading;

  const BestiaryPage({super.key, this.appBarLeading});

  static const Color _textColor = Colors.white70;

  CampaignModel get model => CampaignModel.instance;

  assetPathForAdversary(FigureDef adversary) {
    return model.campaignDefinition.pathForFigure(adversary);
  }

  _onAdversarySelected(BuildContext context, FigureDef adversary) async {
    final record = model.recordOfAdversaryNamed(adversary.name);
    if (record == null) {
      return;
    }
    final codexNumber = adversary.codexEntries.reversed.firstWhereOrNull(
        (number) => model.campaign
            .hasCodexEntry(number: number, expansion: adversary.expansion));
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
    Analytics.logScreen('/bestiary/adversary',
        parameters: {'adversary': adversary.name});
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
    final adversaries = CampaignModel.instance.adversaries
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
                  style: RoveTheme.titleStyle(
                    color: _textColor,
                  )),
              RoveAssets.iconForAdversaryType(type, color: _textColor),
            ],
          ),
          Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.start,
              spacing: spacingFoType(type),
              runSpacing: 16,
              children: adversaries
                  .where((a) => a.adversaryType == type)
                  .expand((a) => a.large ? [null, a, null] : [a])
                  .map((a) {
                final adversary = a;
                if (adversary == null) {
                  return SizedBox(
                    width: double.infinity,
                  );
                }
                final record = CampaignModel.instance
                    .recordOfAdversaryNamed(adversary.name);
                final locked = record == null;
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
                            color: _textColor,
                          ),
                        ),
                      ],
                    ));
              }).toList()),
        ],
      );
    }

    return BackgroundBox.named(
      'background_sheet',
      color: RovePalette.adversaryBackground,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          foregroundColor: _textColor,
          backgroundColor: Colors.transparent,
          leading: appBarLeading,
          title: RoveText.title(
            'Bestiary',
            color: _textColor,
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 12,
              children: [
                wrap(adversaries.sortedBy((f) => f.name), AdversaryType.minion),
                wrap(adversaries.sortedBy((f) => f.name),
                    AdversaryType.miniboss),
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
        return 24;
    }
  }
}
