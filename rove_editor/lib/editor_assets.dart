import 'package:flame/cache.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flutter/widgets.dart' as widgets;
import 'package:rove_app_common/data/campaign_loader.dart';
import 'package:rove_data_types/rove_data_types.dart';

String _expansionSubpath(String? expansion) {
  return '${expansion ?? 'core'}/';
}

class CampaignImages extends Images {
  CampaignImages({required super.prefix});

  Future<Image> loadEntity(String filename, {String? expansion}) async {
    return await super.load(
        '${_expansionSubpath(expansion)}${Assets._entitiesSubpath}$filename');
  }

  Future<Image?> loadMap(String filename, {String? expansion}) async {
    final path =
        '${_expansionSubpath(expansion)}${Assets._mapsSubpath}$filename';
    try {
      await bundle.load('$prefix$path');
      return await super.load(path);
    } catch (e) {
      return null;
    }
  }

  Image entityImage(String filename, {String? expansion}) {
    return super.fromCache(
        '${_expansionSubpath(expansion)}${Assets._entitiesSubpath}$filename');
  }
}

class Assets {
  static const _campaignPath = 'assets/';
  static const _entitiesSubpath = 'img/entities/';
  static const _mapsSubpath = 'img/maps/';

  static final CampaignImages _campaignImages =
      CampaignImages(prefix: 'assets/');

  static CampaignImages get campaignImages => _campaignImages;

  static Sprite get iconExit => Sprite(Flame.images.fromCache('icon_exit.png'));
  static Sprite get iconHealth =>
      Sprite(Flame.images.fromCache('icon_health.png'));
  static Sprite get iconShield =>
      Sprite(Flame.images.fromCache('icon_shield.png'));
  static Sprite get iconStart =>
      Sprite(Flame.images.fromCache('icon_start.png'));
  static Sprite get trapSprite => Sprite(Flame.images.fromCache('trap.png'));
  static Sprite get reactionSprite =>
      Sprite(Flame.images.fromCache('reaction_available.png'));

  static Sprite etherSprite(Ether ether) {
    return Sprite(Flame.images.fromCache('ether_${ether.name}.png'));
  }

  static Sprite fieldSprite(EtherField field) {
    return Sprite(Flame.images.fromCache('field_${field.name}.png'));
  }

  static Sprite glyphSprite(RoveGlyph glyph) {
    return Sprite(Flame.images.fromCache('glyph_${glyph.name}.webp'));
  }

  static String pathForEntityImage(String filename, {String? expansion}) {
    return '$_campaignPath${_expansionSubpath(expansion)}$_entitiesSubpath$filename';
  }

  static String pathForEncounterMap(String encounterId, {String? expansion}) {
    return '$_campaignPath${_expansionSubpath(expansion)}$_mapsSubpath$encounterId.webp';
  }

  static String pathForAppImage(String filename) {
    return 'assets/images/$filename';
  }

  static widgets.Image etherImage(Ether ether) {
    return widgets.Image.asset('assets/images/ether_${ether.name}.png');
  }

  static widgets.Image fieldImage(EtherField field) {
    return widgets.Image.asset('assets/images/field_${field.name}.png');
  }

  static widgets.Image reactionImage() {
    return widgets.Image.asset('assets/images/reaction_available.png');
  }

  static Future<void> loadImages() async {
    await Flame.images.load('icon_exit.png');
    await Flame.images.load('icon_shield.png');
    await Flame.images.load('icon_health.png');
    await Flame.images.load('icon_start.png');
    await Flame.images.load('reaction_available.png');

    for (var e in Ether.values) {
      await Flame.images.load('ether_${e.name}.png');
    }

    for (var e in RoveGlyph.values) {
      await Flame.images.load('glyph_${e.name}.webp');
    }

    for (var e in EtherField.values) {
      await Flame.images.load('field_${e.name}.png');
    }

    for (var roverClass
        in CampaignLoader.instance.campaign.classesForLevel(1)) {
      if (roverClass.trapImage != null) {
        await Flame.images.load(roverClass.trapImage!);
      }
    }
    {
      await Flame.images.load('trap.png');
      for (final trap in TrapType.values) {
        await Flame.images.load('trap_${trap.toJson()}.png');
      }
    }
  }

  static widgets.Image imageForSlotType(ItemSlotType slotType) {
    switch (slotType) {
      case ItemSlotType.head:
        return widgets.Image.asset(Assets.pathForAppImage('icon_head.png'));
      case ItemSlotType.hand:
        return widgets.Image.asset(Assets.pathForAppImage('icon_hand.png'));
      case ItemSlotType.body:
        return widgets.Image.asset(Assets.pathForAppImage('icon_body.png'));
      case ItemSlotType.foot:
        return widgets.Image.asset(Assets.pathForAppImage('icon_foot.png'));
      case ItemSlotType.pocket:
        return widgets.Image.asset(Assets.pathForAppImage('icon_pocket.png'));
      case ItemSlotType.none:
        throw UnimplementedError();
    }
  }
}
