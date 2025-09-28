import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rove_assistant/theme/rove_palette.dart';
import 'package:rove_assistant/theme/icons.dart';
import 'package:rove_assistant/widgets/common/image_shadow.dart';
import 'package:rove_data_types/rove_data_types.dart';

const Map<String, String> _tagAssets = {
  'a': 'assets/images/icon_a.webp',
  'b': 'assets/images/icon_b.webp',
  'c': 'assets/images/icon_c.webp',
  'd': 'assets/images/icon_d.webp',
  'e': 'assets/images/icon_e.webp',
  'hp': 'assets/images/icon_health.webp',
  'rcv': 'assets/images/icon_health.webp',
  'def': 'assets/images/icon_defense.webp',
  'pierce': 'assets/images/icon_ignore_defense.webp',
  'range': 'assets/images/icon_range.webp',
  'icon_wind': 'assets/images/icon_wind.webp',
  'icon_earth': 'assets/images/icon_earth.webp',
  'icon_fire': 'assets/images/icon_fire.webp',
  'icon_water': 'assets/images/icon_water.webp',
  'wind': 'assets/images/ether_wind.webp',
  'earth': 'assets/images/ether_earth.webp',
  'fire': 'assets/images/ether_fire.webp',
  'water': 'assets/images/ether_water.webp',
  'crux': 'assets/images/ether_crux.webp',
  'morph': 'assets/images/ether_morph.webp',
  'dim': 'assets/images/ether_dim.webp',
  'wild': 'assets/images/ether_wild.webp',
  'ether_dice': 'assets/images/icon_ether_dice.webp',
  'wildfire': 'assets/images/icon_wildfire.webp',
  'snapfrost': 'assets/images/icon_snapfrost.webp',
  'everbloom': 'assets/images/icon_everbloom.webp',
  'windscreen': 'assets/images/icon_windscreen.webp',
  'aura': 'assets/images/icon_aura.webp',
  'miasma': 'assets/images/icon_miasma.webp',
  'armor': 'assets/images/icon_xulc_armor.webp',
  'cleaving': 'assets/images/icon_xulc_cleaving.webp',
  'flying_xulc': 'assets/images/icon_xulc_flying.webp',
  'exit': 'assets/images/icon_exit.webp',
  'flying': 'assets/images/icon_flying.webp',
  'push': 'assets/images/icon_push.webp',
  'pull': 'assets/images/icon_pull.webp',
  'react': 'assets/images/icon_react.webp',
  'dmg': 'assets/images/icon_damage.webp',
  'tuckbox': 'assets/images/icon_tuckbox.webp',
  'quest': 'assets/images/icon_quest.webp',
  'map': 'assets/images/icon_map_book.webp',
  'adversary': 'assets/images/icon_adversary_book.webp',
  'codex': 'assets/images/icon_codex_book.webp',
  'codex_entry': 'assets/images/icon_codex.webp',
  'campaign': 'assets/images/icon_quest_book.webp',
  'lyst': 'assets/images/icon_lyst.webp',
  'start': 'assets/images/icon_start.webp',
  'dash': 'assets/images/icon_dash.webp',
  'jump': 'assets/images/icon_jump.webp',
  'plus_wind_morph': 'assets/images/icon_plus_wind_morph.webp',
  'plus_water_earth': 'assets/images/icon_plus_water_earth.webp',
  'recover': 'assets/images/icon_recover.webp',
  'r_attack': 'assets/images/icon_r_attack.webp',
  'm_attack': 'assets/images/icon_m_attack.webp',
  'teleport': 'assets/images/icon_teleport.webp',
  'target': 'assets/images/icon_target.webp',
  'target_pattern': 'assets/images/icon_target_pattern.webp',
  'miniboss': 'assets/images/icon_adversary_miniboss.webp',
  'pos': 'assets/images/icon_positive_ability.webp',
  'neg': 'assets/images/icon_negative_ability.webp',
  'p': 'assets/images/icon_pocket.webp',
  'heal': 'assets/images/icon_recover.webp',
  'flip': 'assets/images/icon_flip.webp',
  'generate': 'assets/images/icon_generate_ether.webp',
  'barrier': 'assets/images/icon_barrier.webp',
  'dangerous': 'assets/images/icon_dangerous.webp',
  'difficult': 'assets/images/icon_difficult.webp',
  'ether_node': 'assets/images/icon_ether_node.webp',
  'object': 'assets/images/icon_object.webp',
  'open_air': 'assets/images/icon_open_air.webp',
  'trap': 'assets/images/icon_trap.webp',
  'treasure': 'assets/images/icon_treasure.webp',
  'trade': 'assets/images/icon_trade.webp',
  'generate_morph': 'assets/images/icon_generate_morph.webp',
};

String _assetForTag(tag) {
  if (_tagAssets.containsKey(tag)) {
    return _tagAssets[tag]!;
  }

  if (EtherDieSide.values
      .map(stringFromEtherDie)
      .map((e) => e.toLowerCase())
      .contains(tag)) {
    return 'assets/images/ether_$tag.webp';
  }
  if (EtherField.values
      .map((v) => v.name)
      .map((e) => e.toLowerCase())
      .contains(tag)) {
    return 'assets/images/field_$tag.png';
  }
  if (tag == 'dim') {
    return 'assets/core/img/entities/die_dim.png';
  }
  return 'assets/images/icon_$tag.png';
}

class RoveText extends StatelessWidget {
  final TextStyle? style;
  final String data;
  final TextAlign? textAlign;
  final bool iconShadows;
  final Map<String, Widget Function()> extraIcons;

  static const double iconScale = 1.5;

  factory RoveText.label(String data,
      {Key? key,
      TextAlign? textAlign,
      double fontSize = 20,
      Color color = Colors.white}) {
    return RoveText(
      data,
      key: key,
      style: TextStyle(
          fontFamily: 'Cinder',
          fontSize: fontSize,
          color: color,
          height: 1,
          fontWeight: FontWeight.w100),
      textAlign: textAlign,
      iconShadows: false,
    );
  }

  factory RoveText.title(String data,
      {Key? key, TextAlign? textAlign, Color color = Colors.white}) {
    return RoveText(
      data,
      key: key,
      style: GoogleFonts.grenze(
        color: color,
        fontWeight: FontWeight.w600,
        fontSize: 24,
      ),
      textAlign: textAlign,
      iconShadows: false,
    );
  }

  factory RoveText.subtitle(String data,
      {Key? key,
      TextAlign? textAlign,
      Color color = Colors.white,
      double fontSize = 18}) {
    return RoveText(
      data,
      key: key,
      style: GoogleFonts.grenze(
        color: color,
        fontWeight: FontWeight.w600,
        fontSize: fontSize,
      ),
      textAlign: textAlign,
      iconShadows: false,
    );
  }

  factory RoveText.body(String data,
      {Key? key,
      TextAlign? textAlign,
      Color color = RovePalette.body,
      double fontSize = 14}) {
    return RoveText(
      data,
      key: key,
      style: GoogleFonts.besley(color: color, fontSize: fontSize),
      textAlign: textAlign,
    );
  }

  factory RoveText.trait(String data,
      {Key? key,
      TextAlign? textAlign,
      Color color = Colors.white,
      double fontSize = 12}) {
    return RoveText(
      data,
      key: key,
      style: GoogleFonts.besley(color: color, fontSize: fontSize),
      textAlign: textAlign,
      iconShadows: true,
    );
  }

  const RoveText(this.data,
      {super.key,
      this.style,
      this.textAlign,
      this.iconShadows = false,
      this.extraIcons = const <String, Widget Function()>{}});
  @override
  Widget build(BuildContext context) {
    final style = this.style ?? GoogleFonts.besley();
    final textAlign = this.textAlign ?? TextAlign.start;
    final iconColor = style.color ?? Colors.black87;
    final double iconSize = style.fontSize ?? 14;
    return Text.rich(
      TextSpan(
          children: RoveTextHelper.textSpansWithIconsFromMarkdownText(
              text: data,
              color: iconColor,
              fontSize: iconSize,
              iconShadows: iconShadows,
              extraIcons: extraIcons),
          style: style),
      textAlign: textAlign,
    );
  }
}

class RoveTextHelper {
  static List<String> componentize(String text,
      {List<String> extraKeys = const []}) {
    String tags = (extraKeys + roveRepleceableTags)
        .map((t) => t.replaceAll('[', '\\[').replaceAll(']', '\\]'))
        .join('|');
    final RegExp regex = RegExp('(?=$tags)|(?<=$tags)', caseSensitive: false);
    return text.split(regex);
  }

  static List<TextSpan> textSpansWithMarkdown({
    required String text,
    required TextStyle baseStyle,
  }) {
    final List<TextSpan> spans = [];
    final RegExp xulcRegex = RegExp(r'\*\*\*\*(.*?)\*\*\*\*');
    final RegExp boldItalicRegex = RegExp(r'\*\*\*(.*?)\*\*\*');
    final RegExp boldRegex = RegExp(r'\*\*(.*?)\*\*');
    final RegExp italicRegex = RegExp(r'\*(.*?)\*');

    String remaining = text;
    while (remaining.isNotEmpty) {
      final xulcMatch = xulcRegex.firstMatch(remaining);
      final boldItalicMatch = boldItalicRegex.firstMatch(remaining);
      final boldMatch = boldRegex.firstMatch(remaining);
      final italicMatch = italicRegex.firstMatch(remaining);

      if (xulcMatch?.start == 0) {
        spans.add(TextSpan(
          text: xulcMatch!.group(1),
          style: baseStyle.copyWith(
            fontFamily: 'Westsac',
            fontWeight: FontWeight.bold,
          ),
        ));
        remaining = remaining.substring(xulcMatch.end);
      } else if (boldItalicMatch?.start == 0) {
        spans.add(TextSpan(
          text: boldItalicMatch!.group(1),
          style: baseStyle.copyWith(
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ));
        remaining = remaining.substring(boldItalicMatch.end);
      } else if (boldMatch?.start == 0) {
        spans.add(TextSpan(
          text: boldMatch!.group(1),
          style: baseStyle.copyWith(fontWeight: FontWeight.w900),
        ));
        remaining = remaining.substring(boldMatch.end);
      } else if (italicMatch?.start == 0) {
        spans.add(TextSpan(
          text: italicMatch!.group(1),
          style: baseStyle.copyWith(fontStyle: FontStyle.italic),
        ));
        remaining = remaining.substring(italicMatch.end);
      } else {
        final nextMatch = [
          xulcMatch,
          boldItalicMatch,
          boldMatch,
          italicMatch,
        ].where((m) => m != null).map((m) => m!.start);

        final endIndex = nextMatch.isEmpty
            ? remaining.length
            : nextMatch.reduce((a, b) => a < b ? a : b);
        spans.add(TextSpan(
          text: remaining.substring(0, endIndex),
          style: baseStyle,
        ));
        remaining = remaining.substring(endIndex);
      }
    }
    return spans;
  }

  static List<InlineSpan> textSpansWithIconsFromTextSpan(
      {required TextSpan textSpan,
      required Color color,
      PlaceholderAlignment alignment = PlaceholderAlignment.middle,
      bool iconShadows = false,
      Map<String, Widget Function()> extraIcons =
          const <String, Widget Function()>{}}) {
    final text = textSpan.text;
    final fontSize = textSpan.style?.fontSize ?? 14;
    if (text == null) {
      return [textSpan];
    }

    Widget imageForTag(String tag) {
      final widgetBuilder = extraIcons['[$tag]'];
      if (widgetBuilder != null) {
        return widgetBuilder();
      }
      final originalSize = roveIconSizes[tag];
      final height = fontSize * RoveText.iconScale;
      final width = originalSize != null
          ? (height * originalSize.width / originalSize.height)
          : null;
      return ColorFiltered(
        colorFilter: ColorFilter.mode(
          roveUncoloredTags.contains(tag) ? Colors.transparent : color,
          BlendMode.srcATop,
        ),
        child: Image.asset(
          _assetForTag(tag),
          width: width,
          height: fontSize * RoveText.iconScale,
        ),
      );
    }

    final components = componentize(text, extraKeys: extraIcons.keys.toList());
    final tags = roveRepleceableTags + extraIcons.keys.toList();
    return components.map((component) {
      if (tags.contains(component.toLowerCase())) {
        final String tag =
            component.substring(1, component.length - 1).toLowerCase();
        return WidgetSpan(
          alignment: alignment,
          baseline: TextBaseline.alphabetic,
          child: iconShadows
              ? ImageShadow(child: imageForTag(tag))
              : imageForTag(tag),
        );
      } else {
        return TextSpan(text: component, style: textSpan.style);
      }
    }).toList();
  }

  static List<InlineSpan> textSpansWithIconsFromMarkdownText(
      {required String text,
      required Color color,
      required double fontSize,
      PlaceholderAlignment alignment = PlaceholderAlignment.middle,
      bool iconShadows = false,
      Map<String, Widget Function()> extraIcons =
          const <String, Widget Function()>{}}) {
    final baseStyle = TextStyle(color: color, fontSize: fontSize);
    final spans = textSpansWithMarkdown(text: text, baseStyle: baseStyle);
    return spans.expand((span) {
      return textSpansWithIconsFromTextSpan(
          textSpan: span,
          color: color,
          alignment: alignment,
          iconShadows: iconShadows,
          extraIcons: extraIcons);
    }).toList();
  }

  static List<InlineSpan> textSpansWithIcons(
      {required String text,
      required Color color,
      required double fontSize,
      PlaceholderAlignment alignment = PlaceholderAlignment.middle}) {
    final components = componentize(text);
    return components.map((component) {
      if (roveRepleceableTags.contains(component.toLowerCase())) {
        final String tag =
            component.substring(1, component.length - 1).toLowerCase();
        return WidgetSpan(
          alignment: alignment,
          baseline: TextBaseline.alphabetic,
          child: ColorFiltered(
            colorFilter: ColorFilter.mode(
              roveUncoloredTags.contains(tag) ? Colors.transparent : color,
              BlendMode.srcATop,
            ),
            child: Image.asset(
              _assetForTag(tag),
              height: fontSize,
            ),
          ),
        );
      } else {
        return TextSpan(text: component);
      }
    }).toList();
  }
}
