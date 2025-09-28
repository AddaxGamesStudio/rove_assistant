import 'package:flutter/foundation.dart';
import 'package:rove_data_types/rove_data_types.dart';

enum BuffType {
  amount,
  attack,
  defense,
  endRange,
  field,
  ignoreTerrainEffects,
  maxHealth,
  pierce,
  push,
  rangeAttackEndRange,
  targetCount,
  trapDamage;

  factory BuffType.fromName(String name) {
    return BuffType.values.firstWhere((v) => v.name == name);
  }

  String toJson() {
    switch (this) {
      case amount:
        return 'amount';
      case attack:
        return 'attack';
      case defense:
        return 'defense';
      case endRange:
        return 'end_range';
      case field:
        return 'field';
      case ignoreTerrainEffects:
        return 'ignore_terrain_effects';
      case maxHealth:
        return 'max_health';
      case pierce:
        return 'pierce';
      case push:
        return 'push';
      case rangeAttackEndRange:
        return 'range_attack_end_range';
      case targetCount:
        return 'target_count';
      case trapDamage:
        return 'trap_damage';
    }
  }

  static BuffType fromJson(String value) {
    return _typeJsonMap[value]!;
  }
}

final Map<String, BuffType> _typeJsonMap = Map<String, BuffType>.fromEntries(
    BuffType.values.map((v) => MapEntry(v.toJson(), v)));

enum BuffScope {
  action,
  permanent,
  untilEndOfTurn,
  untilStartOfTurn;

  static BuffScope fromName(String name) {
    return BuffScope.values.firstWhere((v) => v.name == name);
  }

  String toJson() {
    switch (this) {
      case action:
        return 'action';
      case permanent:
        return 'permanent';
      case untilEndOfTurn:
        return 'until_end_of_turn';
      case untilStartOfTurn:
        return 'until_start_of_turn';
    }
  }

  static BuffScope fromJson(String value) {
    return _scopeJsonMap[value]!;
  }
}

final Map<String, BuffScope> _scopeJsonMap = Map<String, BuffScope>.fromEntries(
    BuffScope.values.map((v) => MapEntry(v.toJson(), v)));

@immutable
class RoveBuff {
  final BuffType type;
  final BuffScope scope;
  final int amount;
  final EtherField? field;

  RoveBuff(
      {required this.type,
      this.scope = BuffScope.action,
      required this.amount,
      this.field})
      : assert(type != BuffType.field || field != null);

  String descriptionForAction(RoveAction action, {bool short = false}) {
    final amountDescription = amount < 0 ? amount.toString() : '+$amount';
    String descriptionForAmountBuff() {
      switch (action.type) {
        case RoveActionType.buff:
          return amountDescription;
        case RoveActionType.attack:
        case RoveActionType.forceAttack:
        case RoveActionType.createTrap:
        case RoveActionType.suffer:
          return '$amountDescription [DMG]';
        case RoveActionType.jump:
          return '$amountDescription [Jump]';
        case RoveActionType.heal:
          return '$amountDescription [hp]';
        case RoveActionType.dash:
          return '$amountDescription [Dash]';
        case RoveActionType.revive:
          return '$amountDescription [RCV]';
        case RoveActionType.command:
        case RoveActionType.generateEther:
        case RoveActionType.group:
        case RoveActionType.infuseEther:
        case RoveActionType.leave:
        case RoveActionType.loot:
        case RoveActionType.placeField:
        case RoveActionType.push:
        case RoveActionType.pull:
        case RoveActionType.removeEther:
        case RoveActionType.rerollEther:
        case RoveActionType.teleport:
        case RoveActionType.trade:
        case RoveActionType.createGlyph:
        case RoveActionType.flipCard:
        case RoveActionType.forceMove:
        case RoveActionType.select:
        case RoveActionType.addDefense:
        case RoveActionType.spawn:
        case RoveActionType.special:
        case RoveActionType.summon:
        case RoveActionType.swapSpace:
        case RoveActionType.triggerFields:
        case RoveActionType.transformEther:
          return throw UnimplementedError();
      }
    }

    switch (type) {
      case BuffType.amount:
        return descriptionForAmountBuff() +
            (field != null ? ', [${field!.name}]' : '');
      case BuffType.attack:
        return '$amountDescription [DMG]';
      case BuffType.defense:
        return '$amountDescription [DEF]';
      case BuffType.field:
        return '[${field!.name}]';
      case BuffType.ignoreTerrainEffects:
        assert(action.type == RoveActionType.dash ||
            action.type == RoveActionType.jump);
        return short
            ? 'Ignore terrain effects'
            : 'During this movement, ignore the effects of difficult or dangerous terrain.';
      case BuffType.maxHealth:
        return '$amountDescription Max Health';
      case BuffType.pierce:
        return '[Pierce]';
      case BuffType.push:
        return action.push > 0 ? '$amountDescription [Push]' : '[Push] $amount';
      case BuffType.endRange:
        return '$amountDescription [Range]';
      case BuffType.rangeAttackEndRange:
        if (action.isRangeAttack) {
          return '$amountDescription [Range]';
        } else {
          return '$amountDescription Range on next Range Attack';
        }
      case BuffType.targetCount:
        return '$amountDescription [Target]';
      case BuffType.trapDamage:
        return 'The first trap triggered with this action deals $amountDescription [DMG].';
    }
  }

  bool canBuffAction(RoveAction action) {
    if (action.type == RoveActionType.group) {
      return action.children.any((a) => canBuffAction(a));
    }

    switch (type) {
      case BuffType.amount:
        switch (action.type) {
          case RoveActionType.attack:
          case RoveActionType.heal:
          case RoveActionType.jump:
          case RoveActionType.suffer:
            return true;
          default:
            return false;
        }
      case BuffType.attack:
        switch (action.type) {
          case RoveActionType.attack:
            return true;
          default:
            return false;
        }
      case BuffType.defense:
        return false;
      case BuffType.endRange:
        switch (action.type) {
          case RoveActionType.attack:
          case RoveActionType.buff:
          case RoveActionType.createGlyph:
          case RoveActionType.createTrap:
          case RoveActionType.forceAttack:
          case RoveActionType.forceMove:
          case RoveActionType.heal:
          case RoveActionType.placeField:
          case RoveActionType.pull:
          case RoveActionType.push:
          case RoveActionType.revive:
          case RoveActionType.select:
          case RoveActionType.addDefense:
          case RoveActionType.suffer:
          case RoveActionType.swapSpace:
          case RoveActionType.trade:
          case RoveActionType.triggerFields:
            return true;
          case RoveActionType.command:
          case RoveActionType.group:
          case RoveActionType.flipCard:
          case RoveActionType.generateEther:
          case RoveActionType.infuseEther:
          case RoveActionType.jump:
          case RoveActionType.leave:
          case RoveActionType.loot:
          case RoveActionType.dash:
          case RoveActionType.removeEther:
          case RoveActionType.rerollEther:
          case RoveActionType.summon:
          case RoveActionType.spawn:
          case RoveActionType.teleport:
          case RoveActionType.transformEther:
          case RoveActionType.special:
            return false;
        }
      case BuffType.field:
        switch (action.type) {
          case RoveActionType.attack:
          case RoveActionType.forceAttack:
          case RoveActionType.heal:
          case RoveActionType.suffer:
            return true;
          default:
            return false;
        }
      case BuffType.ignoreTerrainEffects:
        switch (action.type) {
          case RoveActionType.jump:
          case RoveActionType.dash:
            return true;
          default:
            return false;
        }
      case BuffType.pierce:
        switch (action.type) {
          case RoveActionType.attack:
            return true;
          default:
            return false;
        }
      case BuffType.push:
        switch (action.type) {
          case RoveActionType.attack:
          case RoveActionType.push:
          case RoveActionType.suffer:
            return true;
          default:
            return false;
        }
      case BuffType.rangeAttackEndRange:
        switch (action.type) {
          case RoveActionType.attack:
            return action.isRangeAttack;
          default:
            return false;
        }
      case BuffType.targetCount:
        switch (action.type) {
          case RoveActionType.attack:
          case RoveActionType.buff:
          case RoveActionType.heal:
          case RoveActionType.push:
          case RoveActionType.pull:
          case RoveActionType.placeField:
            return true;
          default:
            return false;
        }
      case BuffType.maxHealth:
      case BuffType.trapDamage:
        return false;
    }
  }

  bool canApplyDuringTargetSelectionForAction(RoveAction action) {
    switch (scope) {
      case BuffScope.action:
        switch (type) {
          case BuffType.amount:
          case BuffType.attack:
          case BuffType.defense:
          case BuffType.field:
          case BuffType.ignoreTerrainEffects:
          case BuffType.maxHealth:
          case BuffType.pierce:
          case BuffType.push:
          case BuffType.trapDamage:
            return action.targetCount == 1;
          case BuffType.rangeAttackEndRange:
          case BuffType.endRange:
            return action.targetCount == 1 || action.aoe != null;
          case BuffType.targetCount:
            return true;
        }
      case BuffScope.permanent:
      case BuffScope.untilEndOfTurn:
      case BuffScope.untilStartOfTurn:
        return true;
    }
  }

  bool canApplyAfterTargetSelectionForAction(RoveAction action) {
    switch (scope) {
      case BuffScope.action:
        switch (type) {
          case BuffType.amount:
          case BuffType.attack:
          case BuffType.defense:
          case BuffType.field:
          case BuffType.ignoreTerrainEffects:
          case BuffType.maxHealth:
          case BuffType.pierce:
          case BuffType.push:
          case BuffType.rangeAttackEndRange:
          case BuffType.trapDamage:
            return true;
          case BuffType.endRange:
          case BuffType.targetCount:
            return false;
        }
      case BuffScope.permanent:
      case BuffScope.untilEndOfTurn:
      case BuffScope.untilStartOfTurn:
        return true;
    }
  }

  factory RoveBuff.fromJson(Map<String, dynamic> json) {
    final fieldString = json['field'] as String?;
    return RoveBuff(
        type: BuffType.fromJson(json['type'] as String),
        scope: BuffScope.fromJson(json['scope'] as String),
        amount: json['amount'] as int? ?? 0,
        field: fieldString != null ? EtherField.fromName(fieldString) : null);
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'type': type.name,
      'scope': scope.name,
      'amount': amount,
    };
    if (field != null) {
      map['field'] = field!.name;
    }
    return map;
  }
}
