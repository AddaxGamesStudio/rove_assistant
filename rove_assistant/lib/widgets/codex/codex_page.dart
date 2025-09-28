import 'package:flutter/material.dart';
import 'package:rove_assistant/theme/rove_palette.dart';
import 'package:rove_assistant/theme/rove_theme.dart';
import 'package:rove_assistant/data/campaign_loader.dart';
import 'package:rove_assistant/model/campaign_model.dart';
import 'package:rove_assistant/services/analytics.dart';
import 'package:rove_assistant/widgets/codex/codex_body.dart';
import 'package:rove_assistant/widgets/codex/codex_panel.dart';
import 'package:rove_assistant/widgets/common/background_box.dart';
import 'package:rove_assistant/widgets/common/rove_text.dart';
import 'package:rove_data_types/rove_data_types.dart';

class CodexPage extends StatelessWidget {
  const CodexPage({
    super.key,
    this.appBarLeading,
  });

  final Widget? appBarLeading;

  _onCodexSelected(BuildContext context, int number, String expansion) async {
    final codex =
        await CampaignLoader.loadCodex(context, number, expansion: expansion);
    if (!context.mounted) {
      return;
    }

    Analytics.logScreen('/codex/codex_entry', parameters: {
      'codex_number': number.toString(),
      'codex_title': codex.title,
      'codex_expansion': expansion,
    });

    showDialog(
        context: context,
        builder: (_) {
          return Dialog(
              backgroundColor: Colors.transparent,
              child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: RoveTheme.dialogMinWidth,
                    maxWidth: RoveTheme.dialogMaxWidth,
                  ),
                  child: CodexPanel(
                    title: codex.title,
                    number: codex.number,
                    child: CodexBody(codex: codex),
                  )));
        });
  }

  List<String> expansionsWithCodexEntries() {
    final campaign = CampaignModel.instance.campaign;
    final expansions = [coreCampaignKey] + campaign.expansions;
    return expansions
        .where((e) => campaign.codexEntries(expansion: e).isNotEmpty)
        .toList()
        .reversed
        .toList();
  }

  List<ListTile> tilesForExpansion(BuildContext context, String expansion) {
    final entries = CampaignModel.instance.campaign
        .codexEntries(expansion: expansion)
        .reversed
        .toList();
    return entries
        .map((e) => ListTile(
              title: RoveText.subtitle(
                e.$2,
                color: RovePalette.codexForeground,
              ),
              trailing: RoveText.subtitle(e.$1.toString(),
                  color: RovePalette.codexForeground),
              onTap: () => _onCodexSelected(context, e.$1, expansion),
            ))
        .toList();
  }

  String titleForExpansion(String key) {
    final expansion = Expansion.fromValue(key);
    assert(expansion != null);
    if (expansion == null) {
      return 'Undefined Campaign';
    }
    return '${expansion.name} Campaign';
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundBox.named(
      'background_codex',
      color: RovePalette.codexBackground,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          foregroundColor: RovePalette.codexForeground,
          backgroundColor: Colors.transparent,
          leading: appBarLeading,
          title: RoveText.title(
            'Codex',
            color: RovePalette.codexForeground,
          ),
        ),
        body: Center(
          child: ListenableBuilder(
              listenable: CampaignModel.instance,
              builder: (context, _) {
                final expansions = expansionsWithCodexEntries();
                if (expansions.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(RoveTheme.horizontalSpacing),
                    child: RoveText.body(
                      'Play encounters to unlock Codex entries.',
                      textAlign: TextAlign.center,
                      color: RovePalette.codexForeground,
                    ),
                  );
                }
                return ConstrainedBox(
                    constraints:
                        BoxConstraints(maxWidth: RoveTheme.pageMaxWidth),
                    child: ListView(
                      children: expansions.length == 1
                          ? tilesForExpansion(context, expansions.first)
                          : expansions
                              .map((e) => ExpansionTile(
                                    shape: LinearBorder.none,
                                    collapsedShape: LinearBorder.none,
                                    initiallyExpanded: true,
                                    title: RoveText.title(
                                      titleForExpansion(e),
                                      color: RovePalette.codexForeground,
                                    ),
                                    children: tilesForExpansion(context, e),
                                  ))
                              .toList(),
                    ));
              }),
        ),
      ),
    );
  }
}
