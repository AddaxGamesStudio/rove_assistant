import 'dart:math';

import 'package:flutter/foundation.dart';
import 'campaign_model.dart';
import 'players_model.dart';
import '../services/analytics.dart';
import 'package:rove_data_types/rove_data_types.dart';

enum EquipItemResult {
  success,
  noSlot,
  alreadyEquipped,
}

class ItemsModel extends ChangeNotifier {
  ItemsModel._privateConstructor();
  final ValueNotifier<int> lystNotifier = ValueNotifier<int>(0);

  static final ItemsModel _instance = ItemsModel._privateConstructor();

  static ItemsModel get instance => _instance;

  Campaign get _campaign => CampaignModel.instance.campaign;
  CampaignDef get _campaignDefinition =>
      CampaignModel.instance.campaignDefinition;

  /* Item Management */

  void consumeItem({required String baseClassName, required String itemName}) {
    final item = itemForName(itemName);
    if (item.isEncounterOnly) {
      return;
    }

    if (item.slotType != ItemSlotType.pocket) {
      throw Exception('Item $itemName is not consumable');
    }
    final player = PlayersModel.instance.playerForClass(baseClassName);
    Analytics.logPlayerItemEvent(player, item, 'consume_item');

    _campaign.removeItem(baseClassName: baseClassName, itemName: itemName);
    if (item.isReward) {
      _campaign.addQuestItemToShop(itemName);
    }
    _onStateChanged();
  }

  EquipItemResult equipItem(
      {required String baseClassName, required String itemName}) {
    final player = PlayersModel.instance.playerForClass(baseClassName);
    final item = _campaignDefinition.itemForName(itemName);
    if (player.hasEquippedItem(item)) {
      return EquipItemResult.alreadyEquipped;
    } else if (canFitItem(player: player, item: item)) {
      Analytics.logPlayerItemEvent(player, item, 'equip_item');
      player.equipItem(item);
      _onStateChanged();
      return EquipItemResult.success;
    } else {
      return EquipItemResult.noSlot;
    }
  }

  bool canFitItem(
      {required Player player,
      required ItemDef item,
      List<ItemDef> equippedEncounterItems = const []}) {
    final slot = item.slotType;
    return availableSlots(
            player: player,
            slotType: slot,
            equippedEncounterItems: equippedEncounterItems) >=
        item.slotCount;
  }

  EquipItemResult transferItem(
      {required String fromBaseClass,
      required String toBaseClass,
      required String itemName}) {
    final fromPlayer = PlayersModel.instance.playerForClass(fromBaseClass);
    _campaign.removeItem(baseClassName: fromBaseClass, itemName: itemName);
    final item = itemForName(itemName);
    Analytics.logPlayerItemEvent(fromPlayer, item, 'transfer_item');

    _campaign.addItem(baseClassName: toBaseClass, item: item);
    final result = equipItem(baseClassName: toBaseClass, itemName: itemName);
    _onStateChanged();
    return result;
  }

  EquipItemResult? giveItem(
      {required String className, required String itemName}) {
    final item = itemForName(itemName);
    if (item.isEncounterOnly) {
      return null;
    }

    final player = PlayersModel.instance.playerForClass(className);
    final baseClassName = player.baseClassName;
    Analytics.logPlayerItemEvent(player, item, 'receive_item');
    _campaign.addItem(baseClassName: baseClassName, item: item);

    _onStateChanged();
    final result = equipItem(baseClassName: baseClassName, itemName: itemName);
    _onStateChanged();
    return result;
  }

  EquipItemResult buyItem(
      {required String baseClassName, required String itemName}) {
    final item = itemForName(itemName);

    final player = PlayersModel.instance.playerForClass(baseClassName);
    Analytics.logPlayerItemEvent(player, item, 'buy_item');

    _campaign.addItem(baseClassName: baseClassName, item: item);

    addLyst(-item.price);
    final result = equipItem(baseClassName: baseClassName, itemName: itemName);
    _onStateChanged();
    return result;
  }

  void sellItem({required String baseClassName, required String itemName}) {
    final item = itemForName(itemName);

    final player = PlayersModel.instance.playerForClass(baseClassName);
    Analytics.logPlayerItemEvent(player, item, 'sell_item');

    _campaign.removeItem(baseClassName: baseClassName, itemName: itemName);
    if (item.isReward) {
      _campaign.addQuestItemToShop(itemName);
    }
    addLyst(item.sellPrice);
    _onStateChanged();
  }

  ItemDef itemForName(String itemName) {
    return _campaignDefinition.itemForName(itemName);
  }

  get shopLevel => _campaign.merchantLevel;

  List<ItemDef> shopItems({required ItemSlotType slot}) {
    if (isMoMissing && slot != ItemSlotType.pocket) {
      return [];
    }
    final shopLevel = _campaign.merchantLevel;
    List<ItemDef> storeItems = _campaignDefinition.shopItems
        .where((item) =>
            item.slotType == slot &&
            item.merchantLevel <= shopLevel &&
            item.hasStock)
        .where((item) =>
            item.stash == null ||
            _campaign.unlockedStashes.contains(item.stash))
        .toList();
    List<ItemDef> questItems = _campaign.questItemsInShop
        .map(_campaignDefinition.itemForName)
        .where((item) => item.slotType == slot)
        .toList();
    return [...storeItems, ...questItems]
      ..sort((a, b) => a.name.compareTo(b.name))
      ..sort((a, b) => a.price.compareTo(b.price));
  }

  bool get isMoMissing {
    return _campaign.milestones.contains(CampaignMilestone.milestone9dot1) &&
        !_campaign.milestones.contains(CampaignMilestone.milestone9dot2);
  }

  /* Equipping Items */

  int missingSlotsToEquip(
      {required Player player,
      required ItemDef item,
      List<ItemDef> equippedEncounterItems = const []}) {
    final slot = item.slotType;
    final slots = availableSlots(
        player: player,
        slotType: slot,
        equippedEncounterItems: equippedEncounterItems);
    return max(0, item.slotCount - slots);
  }

  int availableSlots(
      {required Player player,
      required ItemSlotType slotType,
      List<ItemDef> equippedEncounterItems = const []}) {
    return PlayersModel.instance
            .slotCountForPlayer(player, slotType: slotType) -
        player.usedSlotsForType(slotType,
            items: _campaignDefinition.items,
            equippedEncounterItems: equippedEncounterItems);
  }

  List<ItemDef> equippedItems(
      {required Player player, required ItemSlotType slot}) {
    return player.equippedItemsForSlot(slot, items: _campaignDefinition.items);
  }

  void unequipItem({required Player player, required ItemDef item}) {
    Analytics.logPlayerItemEvent(player, item, 'unequip_item');
    player.unequipItem(item);
    _onStateChanged();
  }

  /* Lyst Management */

  setLyst(int value) {
    _campaign.lyst = value;
    lystNotifier.value = _campaign.lyst;
    _onStateChanged();
  }

  addLyst(int value) {
    _campaign.lyst += value;
    lystNotifier.value = _campaign.lyst;
    _onStateChanged();
  }

  _onStateChanged() {
    CampaignModel.instance.saveCampaign();
    notifyListeners();
  }

  int get lyst => _campaign.lyst;
}
