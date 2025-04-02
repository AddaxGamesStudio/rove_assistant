import 'package:flutter/widgets.dart';
import 'package:rove_app_common/style/rove_palette.dart';
import 'package:rove_assistant/ui/widgets/common/rove_icon.dart';
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
      return 'assets/images/field_$token.webp';
    }
    return 'assets/images/ether_$token.webp';
  }

  static String assetForMap(String mapId, {String? expansion}) {
    return 'assets/${_expansionSubpath(expansion)}img/maps/$mapId.webp';
  }

  static String assetForEtherField(EtherField etherField) {
    return 'assets/images/field_${etherField.name}.webp';
  }

  static String assetForXulcDie(XulcDieSide xulcDieSide) {
    return 'assets/images/icon_${xulcDieSide.adversaryName?.toLowerCase().replaceAll(' ', '_')}.png';
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

  static String assetForAlly(String cardId, int behaviorIndex,
      {String? expansion}) {
    return 'assets/${_expansionSubpath(expansion)}img/allies/$cardId-$behaviorIndex.webp';
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
          size: 18,
          color: color,
        );
      case AdversaryType.miniboss:
        return RoveIcon(
          'adversary_miniboss',
          size: 20,
          color: color,
        );
      case AdversaryType.boss:
        return RoveIcon('adversary_boss', size: 20, color: RovePalette.boss);
    }
  }
}
