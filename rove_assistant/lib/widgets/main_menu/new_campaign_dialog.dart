import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rove_assistant/theme/rove_palette.dart';
import 'package:rove_assistant/theme/rove_theme.dart';
import 'package:rove_assistant/widgets/campaign_settings/campaign_settings_property.dart';
import 'package:rove_assistant/widgets/common/rove_dialog.dart';

class NewCampaignDialog extends StatefulWidget {
  final String defaultName;
  final Function(String, bool, bool) onContinue;
  final bool offerXulcExpansion;

  const NewCampaignDialog({
    super.key,
    required this.defaultName,
    required this.onContinue,
    this.offerXulcExpansion = false,
  });

  @override
  State<NewCampaignDialog> createState() => _NewCampaignDialogState();
}

class _NewCampaignDialogState extends State<NewCampaignDialog> {
  bool includeXulc = false;
  bool skipCore = false;

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController.fromValue(
        TextEditingValue(text: widget.defaultName));

    return RoveDialog(
        title: 'New Campaign',
        titleColor: RovePalette.campaignSheetForeground,
        hideIcon: true,
        color: RovePalette.campaignSheetForeground,
        backgroundColor: RovePalette.campaignSheetBackground,
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CampaignSettingsProperty(
                label: 'Party Name', controller: controller),
            if (widget.offerXulcExpansion)
              CampaignSettingCheckbox(
                  label: 'Include Xulc Expansion',
                  value: includeXulc,
                  onChanged: (value) {
                    setState(() {
                      includeXulc = value ?? false;
                    });
                  }),
            if (includeXulc)
              CampaignSettingCheckbox(
                  label: 'Skip Core Campaign',
                  value: skipCore,
                  onChanged: (value) {
                    setState(() {
                      skipCore = value ?? false;
                    });
                  }),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                spacing: RoveTheme.horizontalSpacing,
                children: [
                  RoveDialogCancelButton(onPressed: () {
                    Navigator.of(context).pop();
                  }),
                  RoveDialogActionButton(
                      color: RovePalette.campaignSheetForeground,
                      title: 'Continue',
                      onPressed: () {
                        final name = controller.text;
                        if (name.isNotEmpty) {
                          Navigator.of(context).pop(name);
                          widget.onContinue(name, includeXulc, skipCore);
                        }
                      }),
                ],
              ),
            ),
          ],
        ));
  }
}

class CampaignSettingCheckbox extends StatelessWidget {
  const CampaignSettingCheckbox({
    super.key,
    required this.label,
    required this.onChanged,
    required this.value,
  });

  final String label;
  final Function(bool?) onChanged;
  final bool value;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      contentPadding: EdgeInsets.zero,
      controlAffinity: ListTileControlAffinity.leading,
      fillColor: WidgetStateProperty.fromMap({
        WidgetState.disabled: Colors.transparent,
        WidgetState.selected: RovePalette.campaignSheetForeground,
      }),
      checkColor: RovePalette.campaignSheetForeground,
      checkboxShape: CircleBorder(
          side:
              BorderSide(color: RovePalette.campaignSheetForeground, width: 2)),
      title: Text(label,
          style: TextStyle(
              color: RovePalette.campaignSheetForeground,
              fontFamily: GoogleFonts.grenze().fontFamily,
              fontSize: 18)),
      value: value,
      onChanged: onChanged,
    );
  }
}
