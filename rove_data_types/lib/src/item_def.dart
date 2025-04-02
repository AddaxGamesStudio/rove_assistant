import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:rove_data_types/src/actions/action_augment.dart';
import 'package:rove_data_types/src/actions/item_timing_condition.dart';
import 'package:rove_data_types/src/actions/reaction_trigger_def.dart';
import 'package:rove_data_types/src/actions/rove_action.dart';
import 'package:rove_data_types/src/actions/rove_buff.dart';
import 'package:rove_data_types/src/ether.dart';

enum ItemSlotType {
  head,
  body,
  hand,
  foot,
  pocket,
  none;

  String toJson() {
    return name;
  }

  String get label {
    switch (this) {
      case ItemSlotType.head:
        return 'Head';
      case ItemSlotType.body:
        return 'Body';
      case ItemSlotType.hand:
        return 'Hand';
      case ItemSlotType.foot:
        return 'Foot';
      case ItemSlotType.pocket:
        return 'Pocket';
      case ItemSlotType.none:
        return 'Ethereal';
    }
  }

  String get _cardBackImageSrc {
    switch (this) {
      case ItemSlotType.head:
      case ItemSlotType.body:
      case ItemSlotType.foot:
        return 'item_back_armor.jpeg';
      case ItemSlotType.hand:
        return 'item_back_weapon.jpeg';
      case ItemSlotType.pocket:
      case ItemSlotType.none:
        return 'item_back_consumable.jpeg';
    }
  }

  static ItemSlotType fromJson(String value) {
    return _jsonMap[value]!;
  }
}

final Map<String, ItemSlotType> _jsonMap =
    Map<String, ItemSlotType>.fromEntries(
        ItemSlotType.values.map((v) => MapEntry(v.toJson(), v)));

enum ItemEtherCost {
  air(ether: Ether.wind),
  crux(ether: Ether.crux),
  earth(ether: Ether.earth),
  fire(ether: Ether.fire),
  morph(ether: Ether.morph),
  water(ether: Ether.water),
  dim(ether: Ether.dim),
  fireOrAir(eitherEther: [Ether.fire, Ether.wind]),
  waterOrEarth(eitherEther: [Ether.water, Ether.earth]),
  cruxOrMorph(eitherEther: [Ether.crux, Ether.morph]),
  fireOrEarth(eitherEther: [Ether.fire, Ether.earth]),
  wild();

  final Ether? ether;
  final List<Ether> eitherEther;

  const ItemEtherCost({this.ether, this.eitherEther = const []});

  bool isExactMatch(Ether ether) {
    return ether == this.ether;
  }

  bool canMatch(Ether ether) {
    return ether == this.ether || eitherEther.contains(ether) || this == wild;
  }

  String toJson() {
    switch (this) {
      case ItemEtherCost.air:
      case ItemEtherCost.crux:
      case ItemEtherCost.earth:
      case ItemEtherCost.fire:
      case ItemEtherCost.morph:
      case ItemEtherCost.water:
      case ItemEtherCost.dim:
        return ether!.toJson();
      case ItemEtherCost.fireOrAir:
      case ItemEtherCost.waterOrEarth:
      case ItemEtherCost.cruxOrMorph:
      case ItemEtherCost.fireOrEarth:
        return eitherEther.map((e) => e.toJson()).join('_or_');
      case ItemEtherCost.wild:
        return 'wild';
    }
  }

  static ItemEtherCost fromJson(String value) {
    return _etherCostJsonMap[value]!;
  }
}

final Map<String, ItemEtherCost> _etherCostJsonMap =
    Map<String, ItemEtherCost>.fromEntries(
        ItemEtherCost.values.map((v) => MapEntry(v.toJson(), v)));

@immutable
class ItemDef {
  /// Reward from I.3.
  static const secretStashName = 'Secret';

  /// Reward from 10.6.
  static const xulcStashName = 'Xulc';

  final String? expansion;
  final String name;
  final String _cardId;
  final ItemSlotType slotType;
  final int slotCount;
  final int merchantLevel;
  final String? stash;
  final bool isReward;
  final int price;
  final int stock;
  final ItemTimingCondition? timingCondition;
  final ReactionTriggerDef? trigger;
  final List<ItemEtherCost> etherCost;
  final List<RoveAction> actions;
  final RoveBuff? permanentBuff;

  bool get isAbility => actions.isNotEmpty;

  static const int _defaultSlotCount = 1;
  const ItemDef(
      {this.expansion,
      required this.name,
      required String cardId,
      required this.slotType,
      this.slotCount = _defaultSlotCount,
      this.merchantLevel = 0,
      this.stash,
      this.isReward = false,
      required this.price,
      required this.stock,
      this.etherCost = const [],
      this.timingCondition,
      this.trigger,
      this.actions = const [],
      this.permanentBuff})
      : _cardId = cardId;

  static fromJson(Map<String, dynamic> e, {String? expansion}) {
    return ItemDef(
        expansion: e['expansion'] as String? ?? expansion,
        name: e['name'] as String,
        cardId: e['card_id'] as String,
        slotType: ItemSlotType.fromJson(e['slot_type'] as String),
        slotCount:
            e.containsKey('slots') ? e['slots'] as int : _defaultSlotCount,
        merchantLevel:
            e.containsKey('merchant_level') ? e['merchant_level'] as int : 0,
        stash: e.containsKey('stash') ? e['stash'] as String : null,
        isReward: e.containsKey('reward') ? e['reward'] as bool : false,
        price: e['price'] as int,
        stock: e['stock'] as int? ?? 1,
        etherCost: e.containsKey('ether_cost')
            ? (e['ether_cost'] as List)
                .map((e) => ItemEtherCost.fromJson(e as String))
                .toList()
            : [],
        timingCondition: e.containsKey('timing_condition')
            ? ItemTimingCondition.fromJson(e['timing_condition'])
            : null,
        trigger: e.containsKey('trigger')
            ? ReactionTriggerDef.fromJson(e['trigger'])
            : null,
        actions: e.containsKey('actions')
            ? (e['actions'] as List)
                .map((e) => RoveAction.fromJson(e as Map<String, dynamic>))
                .toList()
            : [],
        permanentBuff: e.containsKey('permanent_buff')
            ? RoveBuff.fromJson(e['permanent_buff'])
            : null);
  }

  Map<String, dynamic> toJson() {
    return {
      if (expansion case final value?) 'expansion': value,
      'name': name,
      'card_id': _cardId,
      'slot_type': slotType.toJson(),
      if (slotCount != _defaultSlotCount) 'slots': slotCount,
      if (merchantLevel != 0) 'merchant_level': merchantLevel,
      if (stash case final value?) 'stash': value,
      if (isReward) 'reward': isReward,
      'cost': price,
      'stock': stock,
      if (etherCost.isNotEmpty) 'ether_cost': etherCost.map((e) => e.toJson()),
      if (timingCondition case final value?) 'timing_condition': value.toJson(),
      if (trigger case final value?) 'trigger': value.toJson(),
      if (actions.isNotEmpty) 'actions': actions.map((e) => e.toJson()),
      if (permanentBuff case final value?) 'permanent_buff': value.toJson(),
    };
  }

  int get sellPrice => (price / 2.0).ceil();

  bool get isEncounterOnly =>
      ['Metal Key', 'McGuffin', 'Crystaline Spear'].contains(name);

  String get frontImageSrc => '$_cardId.webp';
  String get backImageSrc => slotType._cardBackImageSrc;
  bool get timingIsTurn => trigger == null && timingCondition == null;
  bool get isAugment => timingCondition != null && actions.isNotEmpty;

  AugmentType? get augmentType {
    if (!isAugment) {
      return null;
    }
    final firstAction = actions.first;
    final buff = firstAction.toBuff;
    if (buff != null) {
      return AugmentType.buff;
    } else {
      return AugmentType.additional;
    }
  }

  List<Ether> matchingEther(List<Ether> infusedEther) {
    final matches = <Ether>[];
    final etherCostCopy = etherCost.toList();
    final infusedEtherCopy = infusedEther.toList();
    for (final ec in etherCost) {
      for (final ie in infusedEtherCopy) {
        if (ec.isExactMatch(ie)) {
          matches.add(ie);
          etherCostCopy.remove(ec);
          infusedEtherCopy.remove(ie);
          break;
        }
      }
    }
    for (var ec in etherCostCopy) {
      for (final ie in infusedEtherCopy) {
        if (ec.canMatch(ie)) {
          matches.add(ie);
          infusedEtherCopy.remove(ie);
          break;
        }
      }
    }
    // Can fail to return matching ether depending on order. Example: cost [wild, earth, fire_or_earth] on [earth, fire, air] will return []. This is ok because Rove does not have ether cost of this complexity.
    return etherCost.length == matches.length ? matches : [];
  }

  bool containsUnambiguousMatch(List<Ether> etherToMatch) {
    var etherToMatchCopy = etherToMatch.toList();
    var etherCostCopy = etherCost.toList();
    // Process exact matches
    for (final ec in etherCost) {
      for (final em in etherToMatchCopy) {
        if (ec.isExactMatch(em)) {
          etherCostCopy.remove(ec);
          etherToMatchCopy.remove(em);
          break;
        }
      }
    }

    final remainingEtherCost = etherCostCopy.toList();
    // Process can matches that are unambiguous
    for (final ec in remainingEtherCost) {
      for (final em in etherToMatchCopy) {
        if (ec.canMatch(em) &&
            !etherToMatchCopy.any((e) => e != em && ec.canMatch(e))) {
          etherCostCopy.remove(ec);
          etherToMatchCopy.remove(em);
          break;
        }
      }
    }

    if (etherCostCopy.isEmpty) {
      return true;
    }

    // Single ether can match ether cost
    if (etherToMatchCopy.length == 1 &&
        etherCostCopy.length == 1 &&
        etherCostCopy[0].canMatch(etherToMatchCopy[0])) {
      return true;
    }
    // All costs are wild and there's the same amount of ether
    if (etherCostCopy.every((em) => em == ItemEtherCost.wild) &&
        etherToMatchCopy.length == etherCostCopy.length) {
      return true;
    }

    // All costs are wild and there's the enough ether and they're all the same type
    if (etherCostCopy.every((em) => em == ItemEtherCost.wild) &&
        etherToMatchCopy.length >= etherCostCopy.length &&
        etherToMatchCopy.toSet().length == 1) {
      return true;
    }

    return false;
  }

  bool canMatch(List<Ether> etherToMatch) {
    var etherToMatchCopy = etherToMatch.toList();
    var etherCostCopy = etherCost.toList();
    for (final ec in etherCost) {
      for (final em in etherToMatchCopy) {
        if (ec.isExactMatch(em)) {
          etherCostCopy.remove(ec);
          etherToMatchCopy.remove(em);
          break;
        }
      }
    }
    return etherCostCopy.every((ec) {
      for (final em in etherToMatchCopy) {
        if (ec.canMatch(em)) {
          etherToMatchCopy.remove(em);
          return true;
        }
      }
      return false;
    });
  }
}
