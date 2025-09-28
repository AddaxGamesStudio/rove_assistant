import 'package:flutter/widgets.dart';
import 'package:rove_assistant/theme/rove_palette.dart';
import 'package:rove_assistant/widgets/common/rove_icon.dart';
import 'package:rove_data_types/rove_data_types.dart';

String _expansionSubpath(String? expansion) {
  return '${expansion ?? 'core'}/';
}

class RoveAssets {
  RoveAssets._privateConstructor();

  static const iconHealth = 'assets/images/icon_health.png';
  static const iconDefense = 'assets/images/icon_defense.png';
  static const maskHexagon = 'assets/images/mask_hexagon.png';
  static const maskLargeAdversary = 'assets/images/mask_large_adversary.png';

  static String assetForToken(String token) {
    token = token.toLowerCase();
    if (['a', 'b', 'c', 'd', 'e'].contains(token)) {
      return 'assets/images/icon_$token.png';
    }
    if (token == 'hoard' || token == 'crystalline spear') {
      return 'assets/core/img/entities/hoard.webp';
    }
    if (token == 'dim') {
      return 'assets/core/img/entities/die_dim.png';
    }
    if (token == 'key') {
      return 'assets/images/token_key.png';
    }
    if (EtherField.values.map((v) => v.name).contains(token)) {
      return 'assets/images/icon_$token.webp';
    }
    return 'assets/images/ether_$token.webp';
  }

  static String assetForTerrain(EncounterTerrain terrain) {
    return 'assets/${_expansionSubpath(terrain.expansion)}img/terrain/${terrain.name}.webp';
  }

  static String assetForMap(String mapId, {String? expansion}) {
    return 'assets/${_expansionSubpath(expansion)}img/maps/$mapId.webp';
  }

  static String assetForEtherField(EtherField etherField) {
    return 'assets/images/field_${etherField.name}.webp';
  }

  static String assetForXulcDie(XulcDieSide xulcDieSide) {
    String nameForXulcDie(XulcDieSide xulcDieSide) {
      switch (xulcDieSide) {
        case XulcDieSide.armor:
          return 'xulc_armor';
        case XulcDieSide.cleaving:
          return 'xulc_cleaving';
        case XulcDieSide.flying:
          return 'xulc_flying';
        case XulcDieSide.blank:
          return '';
      }
    }

    final String name = nameForXulcDie(xulcDieSide);
    return 'assets/images/icon_$name.webp';
  }

  static String assetForIsReactionAvailable(bool available) {
    return 'assets/images/reaction_${available ? 'available' : 'unavailable'}.png';
  }

  static String assetForPlayerBoardToken(String token) {
    token = token.toLowerCase();
    // TODO: Fix missing player board token assets
    if (token == 'blood') {
      token = PlayerBoardToken.feralBloodLustValue;
    } else if (token == 'thureoll') {
      token = 'spinaerios';
    } else if (token == 'flip') {
      return 'assets/xulc/img/classes/token_flip.webp';
    }
    return 'assets/images/token_$token.png';
  }

  static String assetForAlly(String cardId, int cardIndex,
      {String? expansion}) {
    return 'assets/${_expansionSubpath(expansion)}img/allies/$cardId-$cardIndex.webp';
  }

  static String assetForEther(Ether ether) {
    return assetForEtherName(ether.toJson());
  }

  static String assetForEtherName(String name) {
    return 'assets/images/ether_${name.toLowerCase()}.webp';
  }

  static String assetForEtherDieSide(EtherDieSide draw) {
    return 'assets/images/ether_${draw.toJson()}.webp';
  }

  static Widget iconForAdversaryType(AdversaryType type, {Color? color}) {
    switch (type) {
      case AdversaryType.minion:
        return RoveIcon(
          'adversary_minion',
          width: 18,
          height: 18,
          color: color,
        );
      case AdversaryType.miniboss:
        return RoveIcon(
          'adversary_miniboss',
          width: 20,
          height: 20,
          color: color,
        );
      case AdversaryType.boss:
        return RoveIcon('adversary_boss',
            width: 20, height: 20, color: RovePalette.boss);
    }
  }

  static const iconEtherPath = 'assets/images/icon_ether.png';

  static const backgroundMainMenuPath =
      'assets/images/main_menu_background.webp';

  static AssetImage xulcBoxArt() {
    return background(5);
  }

  static AssetImage background(int index) {
    return AssetImage('assets/images/background$index.webp');
  }

  static AssetImage get campaignSheetFront {
    return AssetImage('assets/images/campaign_sheet_front.webp');
  }

  static AssetImage get xulCampaignSheetFront {
    return AssetImage('assets/images/xulc_campaign_sheet_front.webp');
  }

  static AssetImage iconLyst = AssetImage('assets/images/icon_lyst.png');

  static AssetImage logo = AssetImage('assets/images/rove_logo.webp');
}
