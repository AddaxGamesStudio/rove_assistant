import 'package:flame/cache.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flutter/widgets.dart' as widgets;
import 'package:rove_app_common/data/campaign_loader.dart';
import 'package:rove_data_types/rove_data_types.dart';

class CampaignImages extends Images {
  CampaignImages({required super.prefix});

  Future<Image> loadClass(String filename) async {
    return await super.load('${Assets._classesSubpath}$filename');
  }

  Future<Image> loadEntity(String filename) async {
    return await super.load('${Assets._entitiesSubpath}$filename');
  }

  Future<Image> loadItem(String filename) async {
    return await super.load('${Assets._itemsSubpath}$filename');
  }

  Future<Image> loadMap(String filename) async {
    return await super.load('${Assets._mapsSubpath}$filename');
  }

  Image classImage(String filename) {
    return super.fromCache('${Assets._classesSubpath}$filename');
  }

  Image entityImage(String filename) {
    return super.fromCache('${Assets._entitiesSubpath}$filename');
  }

  Image itemImage(String filename) {
    return super.fromCache('${Assets._itemsSubpath}$filename');
  }
}

class Assets {
  static const _campaignPath = 'assets/core/';
  static const _classesSubpath = 'img/classes/';
  static const _entitiesSubpath = 'img/entities/';
  static const _itemsSubpath = 'img/items/';
  static const _mapsSubpath = 'img/maps/';

  static final CampaignImages _campaignImages =
      CampaignImages(prefix: _campaignPath);

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

  static widgets.Image roverImage(RoverClass roverClass) {
    return widgets.Image.asset(pathForClassImage(roverClass.imageSrc));
  }

  static String pathForSummonImage(String filename) {
    return pathForClassImage(filename);
  }

  static String pathForClassImage(String filename) {
    return '$_campaignPath$_classesSubpath$filename';
  }

  static String pathForEncounterMap(String encounterId) {
    return '$_campaignPath$_mapsSubpath$encounterId.webp';
  }

  static String pathForItemImage(String filename) {
    return '$_campaignPath$_itemsSubpath$filename';
  }

  static String pathForAppImage(String filename) {
    return 'assets/images/$filename';
  }

  static widgets.Image etherImage(Ether ether) {
    return widgets.Image.asset('assets/images/ether_${ether.name}.png');
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
      await campaignImages.loadClass(roverClass.imageSrc);
      await campaignImages.loadClass(roverClass.iconSrc);
      if (roverClass.trapImage != null) {
        await Flame.images.load(roverClass.trapImage!);
      }
      for (final summon in roverClass.summons) {
        await campaignImages.loadClass(
            'summon_${summon.name.toLowerCase().replaceAll(' ', '_')}.webp');
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
