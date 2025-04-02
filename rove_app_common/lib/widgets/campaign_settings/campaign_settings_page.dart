import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rove_app_common/model/campaign_model.dart';
import 'package:rove_app_common/model/items_model.dart';
import 'package:rove_app_common/style/rove_palette.dart';
import 'package:rove_app_common/style/rove_theme.dart';
import 'package:rove_app_common/widgets/campaign_settings/campaign_settings_property.dart';
import 'package:rove_app_common/widgets/common/lyst_text.dart';
import 'package:rove_app_common/widgets/common/rove_confirm_dialog.dart';
import 'package:rove_data_types/rove_data_types.dart';

class CampaignSettingsPage extends StatelessWidget {
  const CampaignSettingsPage({super.key});

  _onExpansionValueChanged(BuildContext context, bool value, String expansion) {
    final model = CampaignModel.instance;
    if (!value) {
      if (model.usesContentFromExpansion(expansion)) {
        _showUnableToDisableExpansionDialog(context, expansion);
        return;
      }
    }
    model.toggleExpansion(expansion);
  }

  _onDebugModeValueChanged(bool value) {
    final model = CampaignModel.instance;
    model.debugMode = value;
  }

  _onMilestoneValueChanged(BuildContext context, bool value, String milestone) {
    final model = CampaignModel.instance;
    if (value) {
      model.addMilestone(milestone);
    } else {
      model.removeMilestone(milestone);
    }
  }

  _showUnableToDisableExpansionDialog(BuildContext context, String expansion) {
    showDialog(
        context: context,
        builder: (BuildContext context) => RoveConfirmDialog(
            title: 'Expansion Can\'t Be Disabled',
            message:
                'Content from $expansion expansion is already in use and can\'t be disabled.',
            color: RovePalette.campaignSheetForeground,
            confirmTitle: 'OK',
            hideCancelButton: true));
  }

  @override
  Widget build(BuildContext context) {
    final model = CampaignModel.instance;
    return Scaffold(
      backgroundColor: RovePalette.campaignSheetBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: RoveTheme.pageMaxWidth),
              child: SingleChildScrollView(
                child: Column(
                  spacing: RoveTheme.verticalSpacing,
                  children: [
                    CampaignSettingsProperty(
                        label: 'Party Name',
                        value: model.campaign.name,
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            model.setPartyName(value);
                          }
                        }),
                    CampaignSettingsProperty(
                        labelWidget: LystText(
                          fontWeight: FontWeight.normal,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                        value: model.campaign.lyst.toString(),
                        onChanged: (value) {
                          final lyst = int.tryParse(value);
                          if (lyst != null) {
                            ItemsModel.instance.setLyst(lyst);
                          }
                        }),
                    ListenableBuilder(
                        listenable: model,
                        builder: (context, _) {
                          return CampaignSettingsPanel(
                            label: 'Milestones',
                            body: Wrap(
                              spacing: 8,
                              children: CampaignMilestone
                                  .coreCampaignSheetMilestones
                                  .map((milestone) => IntrinsicWidth(
                                        child: CampaignCheckboxTile(
                                            label: milestone,
                                            selected: model.campaign.milestones
                                                .contains(milestone),
                                            onChanged: (value) =>
                                                _onMilestoneValueChanged(
                                                    context, value, milestone)),
                                      ))
                                  .toList(),
                            ),
                          );
                        }),
                    ListenableBuilder(
                        listenable: model,
                        builder: (context, _) {
                          return CampaignSettingsPanel(
                              label: 'Expansions',
                              body: Wrap(
                                spacing: 8,
                                children: [xulcExpansionKey]
                                    .map((expansion) => CampaignCheckboxTile(
                                        label: (Expansion.fromValue(expansion)
                                                ?.name ??
                                            expansion),
                                        selected: model.campaign.expansions
                                            .contains(expansion),
                                        onChanged: (value) =>
                                            _onExpansionValueChanged(
                                                context, value, expansion)))
                                    .toList(),
                              ));
                        }),
                    ListenableBuilder(
                        listenable: model,
                        builder: (context, _) {
                          return CampaignSettingsPanel(
                              label: 'Advanced',
                              body: Wrap(
                                spacing: 8,
                                children: [
                                  CampaignCheckboxTile(
                                      label: 'Debug Mode',
                                      selected: model.debugMode,
                                      onChanged: _onDebugModeValueChanged),
                                ],
                              ));
                        }),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CampaignCheckboxTile extends StatelessWidget {
  final String label;
  final bool selected;
  final Function(bool) onChanged;

  const CampaignCheckboxTile(
      {super.key,
      required this.label,
      required this.selected,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
        dense: true,
        controlAffinity: ListTileControlAffinity.leading,
        fillColor: WidgetStateProperty.fromMap({
          WidgetState.disabled: Colors.transparent,
          WidgetState.selected: RovePalette.campaignSheetForeground,
        }),
        checkColor: RovePalette.campaignSheetForeground,
        checkboxShape: CircleBorder(
            side: BorderSide(
                color: RovePalette.campaignSheetForeground, width: 2)),
        title: Text(label,
            style: TextStyle(
                color: RovePalette.campaignSheetForeground,
                fontFamily: GoogleFonts.grenze().fontFamily,
                fontSize: 18)),
        value: selected,
        onChanged: (value) => onChanged(value ?? false));
  }
}

class CampaignSettingsPanel extends StatelessWidget {
  const CampaignSettingsPanel({
    super.key,
    required this.label,
    required this.body,
  });

  final String label;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 24,
          width: double.infinity,
          decoration: BoxDecoration(
            color: RovePalette.campaignSheetForeground,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8), topRight: Radius.circular(8)),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: RoveTheme.verticalSpacing),
            child: Text(label,
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: GoogleFonts.grenze().fontFamily,
                    fontSize: 18)),
          ),
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: RovePalette.campaignSheetForeground,
                width: 2,
              ),
              bottom: BorderSide(
                color: RovePalette.campaignSheetForeground,
                width: 2,
              ),
              right: BorderSide(
                color: RovePalette.campaignSheetForeground,
                width: 2,
              ),
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(8),
              bottomRight: Radius.circular(8),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: body,
          ),
        ),
      ],
    );
  }
}
