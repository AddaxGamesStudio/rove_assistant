import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rove_app_common/style/rove_palette.dart';

class CampaignSettingsProperty extends StatelessWidget {
  const CampaignSettingsProperty({
    super.key,
    this.label,
    this.labelWidget,
    this.foregroundColor = RovePalette.campaignSheetForeground,
    this.backgroundColor = RovePalette.campaignSheetBackground,
    this.value,
    this.controller,
    this.onChanged,
  })  : assert(label != null || labelWidget != null),
        assert(value != null || controller != null);

  final String? label;
  final Color foregroundColor;
  final Color backgroundColor;
  final Widget? labelWidget;
  final String? value;
  final TextEditingController? controller;
  final Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(
        height: 48,
        width: 100,
        decoration: BoxDecoration(
          color: foregroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8),
            bottomLeft: Radius.circular(8),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: labelWidget ??
                Text(label ?? '',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: GoogleFonts.grenze().fontFamily,
                        fontSize: 18)),
          ),
        ),
      ),
      Expanded(
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border(
              top: BorderSide(
                color: foregroundColor,
                width: 2,
              ),
              bottom: BorderSide(
                color: foregroundColor,
                width: 2,
              ),
              right: BorderSide(
                color: foregroundColor,
                width: 2,
              ),
            ),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(8),
              bottomRight: Radius.circular(8),
            ),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: TextField(
                decoration: null,
                style: TextStyle(
                    color: foregroundColor,
                    fontFamily: GoogleFonts.grenze().fontFamily,
                    fontSize: 18),
                controller:
                    controller ?? TextEditingController(text: value ?? ''),
                onChanged: onChanged,
              ),
            ),
          ),
        ),
      ),
    ]);
  }
}
