import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rove_app_common/model/items_model.dart';
import 'package:rove_app_common/style/rove_app_assets.dart';
import 'package:rove_app_common/style/rove_palette.dart';

class CampaignLystCounter extends StatelessWidget {
  final Color color;
  final double fontSize;

  const CampaignLystCounter(
      {super.key, this.color = RovePalette.lyst, required this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Consumer<ItemsModel>(builder: (context, model, _) {
      return LystText(lyst: model.lyst, color: color, fontSize: fontSize);
    });
  }
}

class LystText extends StatelessWidget {
  final int? lyst;
  final String? label;
  final FontWeight fontWeight;
  final Color color;
  final double fontSize;

  const LystText({
    super.key,
    this.lyst,
    this.label,
    this.fontWeight = FontWeight.w600,
    this.color = RovePalette.lyst,
    required this.fontSize,
  });

  static List<InlineSpan> spansForLyst(String label,
      {Color color = RovePalette.lyst, required double fontSize}) {
    return [
      TextSpan(text: '$label '),
      WidgetSpan(
        alignment: PlaceholderAlignment.middle,
        baseline: TextBaseline.alphabetic,
        child: ColorFiltered(
          colorFilter: ColorFilter.mode(
            color,
            BlendMode.srcATop,
          ),
          child: Image(
            image: RoveAppAssets.iconLyst,
            width: fontSize,
            height: fontSize,
          ),
        ),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    final label = this.label ?? lyst?.toString() ?? 'Lyst';
    return Text.rich(TextSpan(
        children: spansForLyst(label, color: color, fontSize: fontSize),
        style: GoogleFonts.grenze(
          color: color,
          fontWeight: fontWeight,
          fontSize: fontSize,
        )));
  }
}
