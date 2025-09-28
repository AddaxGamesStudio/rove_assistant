import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:rove_data_types/src/actions/action_augment.dart';
import 'package:rove_data_types/src/actions/aoe_def.dart';
import 'package:rove_data_types/src/actions/augment_condition.dart';
import 'package:rove_data_types/src/actions/flip_condition.dart';
import 'package:rove_data_types/src/actions/rove_action_actor_kind.dart';
import 'package:rove_data_types/src/actions/rove_action_description.dart';
import 'package:rove_data_types/src/actions/rove_action_modifier.dart';
import 'package:rove_data_types/src/actions/rove_action_range_origin.dart';
import 'package:rove_data_types/src/actions/rove_action_target_mode.dart';
import 'package:rove_data_types/src/actions/target_kind.dart';
import 'package:rove_data_types/src/actions/rove_action_type.dart';
import 'package:rove_data_types/src/utils/vector_utils.dart';
import 'package:rove_data_types/src/ether.dart';
import 'package:rove_data_types/src/actions/rove_buff.dart';
import 'package:rove_data_types/src/rove_glyph.dart';

enum RoveActionPolarity { positive, negative, neutral }

@immutable
class RoveAction {
  final RoveActionActorKind actor;
  final (int, int) actorRange;
  final RoveActionType type;
  final String? object;
  final int amount;
  final String? amountFormula;
  final int targetCount;
  final RoveActionTargetMode targetMode;
  final TargetKind targetKind;
  final RoveActionRangeOrigin rangeOrigin;
  final (int, int) range;
  final String? rangeFormula;
  final AOEDef? aoe;
  final int push;
  final String? pushFormula;
  final int pull;
  final EtherField? field;
  final bool pierce;
  final List<RoveActionModifier> modifiers;
  final BuffType? buffType;
  final BuffScope? buffScope;
  final List<ActionAugment> augments;
  final bool requiresPrevious;
  final bool retreat;
  final RoveActionXDefinition? xDefinition;
  final int exclusiveGroup;
  final RoveActionDescription? staticDescription;
  final List<RoveAction> children;

  static const (int, int) anyRange = (0, 99);
  static const int allTargets = 99;

  static const _defaultActor = RoveActionActorKind.self;
  static const _defaultActorRange = RoveAction.anyRange;
  static const _defaultAmount = 0;
  static const _defaultTargetCount = 1;
  static const _defaultTargetMode = RoveActionTargetMode.range;
  static const _defaultTargetKind = TargetKind.enemy;
  static const _defaultRangeOrigin = RoveActionRangeOrigin.actor;
  static const _defaultRange = (0, 0);
  static const _defaultPush = 0;
  static const _defaultPull = 0;
  static const _defaultPierce = false;
  static const _defaultRequiresPrevious = false;
  static const _defaultRetreat = false;
  static const _defaultExclusiveGroup = 0;
  RoveAction({
    this.actor = _defaultActor,
    this.actorRange = _defaultActorRange,
    required this.type,
    this.object,
    this.amount = _defaultAmount,
    this.amountFormula,
    this.targetCount = _defaultTargetCount,
    this.targetMode = _defaultTargetMode,
    this.targetKind = _defaultTargetKind,
    this.rangeOrigin = _defaultRangeOrigin,
    this.range = _defaultRange,
    this.rangeFormula,
    this.aoe,
    this.push = _defaultPush,
    this.pushFormula,
    this.pull = _defaultPull,
    this.field,
    this.pierce = _defaultPierce,
    this.modifiers = const [],
    this.buffType,
    this.buffScope,
    this.augments = const [],
    this.requiresPrevious = _defaultRequiresPrevious,
    this.retreat = _defaultRetreat,
    this.xDefinition,
    this.exclusiveGroup = _defaultExclusiveGroup,
    this.staticDescription,
    this.children = const [],
  });

  factory RoveAction.fromJson(Map<String, dynamic> json) {
    return RoveAction(
      actor: json.containsKey('actor')
          ? RoveActionActorKind.fromJson(json['actor'] as String)
          : _defaultActor,
      actorRange: json.containsKey('actor_range')
          ? parseRange(json['actor_range'] as String)
          : _defaultActorRange,
      type: RoveActionType.fromJson(json['type'] as String),
      object: json['object'] as String?,
      amount:
          json.containsKey('amount') ? json['amount'] as int : _defaultAmount,
      amountFormula: json['amount_formula'] as String?,
      targetCount: json.containsKey('target_count')
          ? json['target_count'] as int
          : _defaultTargetCount,
      targetMode: json.containsKey('target_mode')
          ? RoveActionTargetMode.fromJson(json['target_mode'] as String)
          : _defaultTargetMode,
      targetKind: json.containsKey('target_kind')
          ? TargetKind.fromJson(json['target_kind'] as String)
          : _defaultTargetKind,
      rangeOrigin: json.containsKey('range_origin')
          ? RoveActionRangeOrigin.fromJson(json['range_origin'] as String)
          : _defaultRangeOrigin,
      range: json.containsKey('range')
          ? parseRange(json['range'] as String)
          : _defaultRange,
      rangeFormula: json['range_formula'] as String?,
      aoe: json.containsKey('aoe')
          ? AOEDef.fromJson(json['aoe'] as Map<String, dynamic>)
          : null,
      push: json.containsKey('push') ? json['push'] as int : _defaultPush,
      pushFormula: json['push_formula'] as String?,
      pull: json.containsKey('pull') ? json['pull'] as int : _defaultPull,
      field: json.containsKey('field')
          ? EtherField.fromJson(json['field'] as String)
          : null,
      pierce:
          json.containsKey('pierce') ? json['pierce'] as bool : _defaultPierce,
      modifiers: json.containsKey('modifiers')
          ? (json['modifiers'] as List)
              .map((e) => RoveActionModifier.fromJson(e as String))
              .toList()
          : const [],
      buffType: json.containsKey('buff_type')
          ? BuffType.fromJson(json['buff_type'] as String)
          : null,
      buffScope: json.containsKey('buff_scope')
          ? BuffScope.fromJson(json['buff_scope'] as String)
          : null,
      augments: json.containsKey('augments')
          ? (json['augments'] as List)
              .map((e) => ActionAugment.fromJson(e as Map<String, dynamic>))
              .toList()
          : const [],
      requiresPrevious: json.containsKey('requires_previous')
          ? json['requires_previous'] as bool
          : _defaultRequiresPrevious,
      retreat: json.containsKey('retreat')
          ? json['retreat'] as bool
          : _defaultRetreat,
      xDefinition: json.containsKey('x_definition')
          ? RoveActionXDefinition.fromJson(json['x_definition'] as String)
          : null,
      exclusiveGroup: json.containsKey('exclusive_group')
          ? json['exclusive_group'] as int
          : _defaultExclusiveGroup,
      staticDescription: json.containsKey('static_description')
          ? RoveActionDescription.fromJson(
              json['static_description'] as Map<String, dynamic>)
          : null,
      children: json.containsKey('commands')
          ? (json['commands'] as List)
              .map((e) => RoveAction.fromJson(e as Map<String, dynamic>))
              .toList()
          : const [],
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      if (actor != _defaultActor) 'actor': actor.toJson(),
      if (actorRange != _defaultActorRange)
        'actor_range': rangeToString(actorRange),
      'type': type.toJson(),
      if (object case final value?) 'object': value,
      if (amount != _defaultAmount) 'amount': amount,
      if (amountFormula case final value?) 'amount_formula': value,
      if (targetCount != _defaultTargetCount) 'target_count': targetCount,
      if (targetMode != _defaultTargetMode) 'target_mode': targetMode.toJson(),
      if (targetKind != _defaultTargetKind) 'target_kind': targetKind.toJson(),
      if (rangeOrigin != _defaultRangeOrigin)
        'range_origin': rangeOrigin.toJson(),
      if (range != _defaultRange) 'range': rangeToString(range),
      if (rangeFormula case final value?) 'range_formula': value,
      if (aoe case final value?) 'aoe': value.toJson(),
      if (push != _defaultPush) 'push': push,
      if (pushFormula case final value?) 'push_formula': value,
      if (pull != _defaultPull) 'pull': pull,
      if (field case final value?) 'field': value.toJson(),
      if (pierce != _defaultPierce) 'pierce': pierce,
      if (modifiers.isNotEmpty)
        'modifiers': modifiers.map((e) => e.toString()).toList(),
      if (buffType case final value?) 'buff_type': value.toJson(),
      if (buffScope case final value?) 'buff_scope': value.toJson(),
      if (augments.isNotEmpty)
        'augments': augments.map((a) => a.toJson()).toList(),
      if (requiresPrevious != _defaultRequiresPrevious)
        'requires_previous': requiresPrevious,
      if (retreat != _defaultRetreat) 'retreat': retreat,
      if (xDefinition case final value?) 'x_definition': value.toJson(),
      if (exclusiveGroup != _defaultExclusiveGroup)
        'exclusive_group': exclusiveGroup,
      if (staticDescription case final value?)
        'static_description': value.toJson(),
      if (children.isNotEmpty)
        'commands': children.map((c) => c.toJson()).toList(),
    };
  }

  factory RoveAction.buff(BuffType buffType, int amount,
      {BuffScope scope = BuffScope.action, EtherField? field}) {
    return RoveAction(
        type: RoveActionType.buff,
        targetKind: TargetKind.self,
        buffType: buffType,
        buffScope: scope,
        amount: amount,
        field: field);
  }

  factory RoveAction.createGlyph(RoveGlyph glyph) {
    return RoveAction(
        type: RoveActionType.createGlyph,
        object: glyph.name,
        targetKind: TargetKind.self,
        range: (0, 1));
  }

  factory RoveAction.createTrap(int amount, {int endRange = 1}) {
    return RoveAction(
        type: RoveActionType.createTrap,
        amount: amount,
        targetKind: TargetKind.self,
        range: (1, endRange));
  }

  factory RoveAction.flip(FlipCondition condition) {
    return RoveAction(
        type: RoveActionType.flipCard,
        amount: 1,
        object: condition.key,
        targetKind: TargetKind.self);
  }

  factory RoveAction.forceMove(int amount,
      {int startRange = 1, int endRange = 1}) {
    return RoveAction(
        type: RoveActionType.forceMove,
        amount: amount,
        targetKind: TargetKind.enemy,
        range: (startRange, endRange));
  }

  factory RoveAction.generateEther(
      {Ether? ether, bool requiresPrevious = true}) {
    return RoveAction(
        type: RoveActionType.generateEther,
        object: ether?.name,
        targetKind: TargetKind.self,
        requiresPrevious: requiresPrevious);
  }

  factory RoveAction.group(List<RoveAction> actions) {
    return RoveAction(type: RoveActionType.group, children: actions);
  }

  factory RoveAction.infuseEther() {
    return RoveAction(
        type: RoveActionType.infuseEther, targetKind: TargetKind.self);
  }

  factory RoveAction.heal(int amount,
      {String? amountFormula,
      int startRange = 0,
      int endRange = 0,
      targetKind = TargetKind.selfOrAlly,
      int targetCount = 1,
      EtherField? field,
      bool requiresPrevious = _defaultRequiresPrevious}) {
    return RoveAction(
        type: RoveActionType.heal,
        targetKind: targetKind,
        targetCount: targetCount,
        amount: amount,
        amountFormula: amountFormula,
        range: (startRange, endRange),
        field: field,
        requiresPrevious: requiresPrevious);
  }

  factory RoveAction.jump(int amount) {
    return RoveAction(
        type: RoveActionType.jump, amount: amount, targetKind: TargetKind.self);
  }

  factory RoveAction.loot() {
    return RoveAction(type: RoveActionType.loot);
  }

  factory RoveAction.leave({bool requiresPrevious = false}) {
    return RoveAction(
        type: RoveActionType.leave, requiresPrevious: requiresPrevious);
  }

  factory RoveAction.meleeAttack(int amount,
      {String? amountFormula,
      RoveActionActorKind actor = RoveActionActorKind.self,
      int endRange = 1,
      AOEDef? aoe,
      int targetCount = 1,
      TargetKind targetKind = TargetKind.enemy,
      bool pierce = false,
      int push = 0,
      int pull = 0,
      EtherField? field,
      int exclusiveGroup = _defaultExclusiveGroup}) {
    return RoveAction(
        actor: actor,
        type: RoveActionType.attack,
        amount: amount,
        amountFormula: amountFormula,
        range: (1, endRange),
        aoe: aoe,
        targetCount: targetCount,
        targetKind: targetKind,
        pierce: pierce,
        push: push,
        pull: pull,
        field: field,
        exclusiveGroup: exclusiveGroup);
  }

  factory RoveAction.move(int amount,
      {bool retreat = false,
      List<RoveActionModifier> modifiers = const [],
      int exclusiveGroup = _defaultExclusiveGroup,
      bool requiresPrevious = _defaultRequiresPrevious}) {
    return RoveAction(
        type: RoveActionType.dash,
        amount: amount,
        targetKind: TargetKind.self,
        retreat: retreat,
        modifiers: modifiers,
        exclusiveGroup: exclusiveGroup,
        requiresPrevious: requiresPrevious);
  }

  factory RoveAction.placeField(EtherField field, {range = (0, 1)}) {
    return RoveAction(
        type: RoveActionType.placeField, field: field, range: range);
  }

  factory RoveAction.pull(int amount,
      {range = (0, 0), targetMode = RoveActionTargetMode.previous}) {
    return RoveAction(
        type: RoveActionType.pull,
        amount: amount,
        range: range,
        targetMode: targetMode);
  }

  factory RoveAction.push(int amount,
      {range = (0, 0), targetMode = RoveActionTargetMode.previous}) {
    return RoveAction(
        type: RoveActionType.push,
        amount: amount,
        range: range,
        targetMode: targetMode);
  }

  factory RoveAction.rangeAttack(int amount,
      {String? amountFormula,
      int startRange = 2,
      int endRange = 2,
      int push = 0,
      int pull = 0,
      bool pierce = false,
      EtherField? field,
      List<RoveActionModifier> modifiers = const [],
      int exclusiveGroup = _defaultExclusiveGroup}) {
    return RoveAction(
        type: RoveActionType.attack,
        amount: amount,
        amountFormula: amountFormula,
        range: (startRange, endRange),
        push: push,
        pull: pull,
        pierce: pierce,
        field: field,
        modifiers: modifiers,
        exclusiveGroup: exclusiveGroup);
  }

  factory RoveAction.removeEther() {
    return RoveAction(
        type: RoveActionType.removeEther, targetKind: TargetKind.self);
  }

  factory RoveAction.teleport(int amount) {
    return RoveAction(
        type: RoveActionType.teleport,
        amount: amount,
        targetKind: TargetKind.self);
  }

  factory RoveAction.trade() {
    return RoveAction(
        type: RoveActionType.trade,
        targetKind: TargetKind.ally,
        range: RoveAction.anyRange);
  }

  bool get hasPush => push > 0 || pushFormula != null;

  String get augmentDescription {
    final body = staticDescription?.body;
    if (body != null) {
      return body;
    }
    return shortDescription;
  }

  String get shortDescription {
    switch (type) {
      case RoveActionType.attack:
        return range.$1 > 1 ? 'Range Attack' : 'Melee Attack';
      case RoveActionType.generateEther:
        return description;
      case RoveActionType.teleport:
        return '[Teleport]';
      default:
        final retreatPrefix = retreat ? 'Retreat: ' : '';
        return '$retreatPrefix${type.label}';
    }
  }

  bool get targetsAllInAreaOfEffect => targetCount == 0;

  RoveBuff? get toBuff => buffType != null
      ? RoveBuff(
          type: buffType!,
          scope: buffScope ?? BuffScope.action,
          amount: amount,
          field: field)
      : null;

  String get targetKindDescription {
    switch (polarity) {
      case RoveActionPolarity.positive:
        return targetKind == TargetKind.selfOrAlly
            ? ''
            : targetKind.descriptionForTargetMode(targetMode);
      case RoveActionPolarity.negative:
        return targetKind == TargetKind.enemy
            ? ''
            : targetKind.descriptionForTargetMode(targetMode);
      case RoveActionPolarity.neutral:
        return '';
    }
  }

  String get description {
    final resolvedPrefix = prefix;
    final suffix = staticDescription?.suffix;
    return '${resolvedPrefix == null || resolvedPrefix.isEmpty ? '' : '$resolvedPrefix\n\n'}$actionDescription${suffix != null ? '\n\n$suffix' : ''}';
  }

  String get actionDescription {
    String modifiers() {
      final modifiers = [
        field?.label,
        pierce ? 'Pierce' : null,
        pull > 0 ? 'Pull $pull' : null,
        push > 0 || pushFormula != null ? 'Push ${pushFormula ?? push}' : null
      ];
      if (modifiers.whereNot((m) => m == null).isEmpty) {
        return '';
      }
      final result = modifiers.fold(
          '', (prev, desc) => desc != null ? '$prev | $desc' : prev);
      return result;
    }

    final targetCountDescription = () {
      if (targetCount <= 1) {
        return '';
      }
      if (aoe != null) {
        return '\n${aoe!.cubeVectors.length <= targetCount ? 'all' : '$targetCount'} targets within the area of effect';
      } else {
        return '\n${allTargets == targetCount ? 'all' : '$targetCount'} targets';
      }
    }();

    final amountString = amountFormula ?? amount.toString();
    final rangeString = rangeDescription;
    final aoeString = aoe != null ? '\n${aoe!.name}' : '';
    final targetKindStringWithSpace =
        targetKindDescription.isEmpty ? '' : ' $targetKindDescription';
    String body() {
      if (staticDescription?.body != null) {
        return staticDescription!.body!;
      }

      switch (type) {
        case RoveActionType.attack:
        case RoveActionType.push:
        case RoveActionType.pull:
        case RoveActionType.heal:
        case RoveActionType.revive:
          return '${type.label} $amountString$rangeString${modifiers()}$targetKindStringWithSpace$aoeString$targetCountDescription';
        case RoveActionType.buff:
          return '${type.label} $buffDescription$rangeString$targetKindStringWithSpace';
        case RoveActionType.command:
          return type.label;
        case RoveActionType.createGlyph:
          return 'Create ${RoveGlyph.fromName(object!).label}$rangeString';
        case RoveActionType.createTrap:
          return 'Create $amountString [DMG] Trap$rangeString';
        case RoveActionType.placeField:
          return 'Place ${field!.label}$rangeString';
        case RoveActionType.flipCard:
          return '[flip] ${flipCondition?.description}';
        case RoveActionType.forceAttack:
          return 'Force ${targetKind.description} within $range to perform:\nAttack $amountString to ${TargetKind.ally.description}';
        case RoveActionType.forceMove:
          return '${type.label} $amountString$rangeString$targetKindStringWithSpace';
        case RoveActionType.group:
          return type.label;
        case RoveActionType.generateEther:
          return generateEtherOptions.isEmpty
              ? '[generate]'
              : 'Generate ${generateEtherOptions.map((e) => e.label).join(' or ')}';
        case RoveActionType.infuseEther:
          return type.label;
        case RoveActionType.jump:
          return '[jump] $amountString';
        case RoveActionType.leave:
          return type.label;
        case RoveActionType.loot:
          return type.label;
        case RoveActionType.dash:
          return '[dash] $amountString';
        case RoveActionType.rerollEther:
          return type.label;
        case RoveActionType.select:
          return '${type.label} ${targetKind.description} within $range';
        case RoveActionType.addDefense:
          return '${type.label} $amountString';
        case RoveActionType.special:
          return object!;
        case RoveActionType.suffer:
          return '${type.label} $amountString$rangeString${modifiers()}';
        case RoveActionType.spawn:
          return '${type.label} $amountString $object ';
        case RoveActionType.summon:
          return '${type.label} $object';
        case RoveActionType.swapSpace:
          return 'You and ${targetKind.description} swap spaces';
        case RoveActionType.teleport:
          return '[teleport] $amountString';
        case RoveActionType.removeEther:
          return type.label;
        case RoveActionType.trade:
          return '[trade]';
        case RoveActionType.transformEther:
          assert(object != null);
          if (object case final value?) {
            return 'Transform one ether from the personal pool into ${Ether.fromJson(value).label}';
          } else {
            return 'Invalid action';
          }
        case RoveActionType.triggerFields:
          return 'Trigger the effects of any number of ${field?.label} within $rangeString';
      }
    }

    return body();
  }

  String get rangeDescription {
    if (range.$1 == range.$2) {
      return '[range] ${range.$1}';
    }
    return '[range] ${range.$1}-${range.$2}';
  }

  String get targetDescription {
    final targetKindDes = targetKindDescription;
    return staticDescription?.target ??
        (targetKindDes.isEmpty
            ? '${targetCount == allTargets ? 'all' : targetCount}'
            : targetKindDes);
  }

  String get aoeTargetDescription {
    if (aoe == null) {
      return '';
    }
    return '[target] ${targetCount == RoveAction.allTargets ? 'all' : targetCount} ${targetKind.descriptionForTargetCount(targetCount)} within [target_pattern]';
  }

  String? get prefix {
    final prefix = staticDescription?.prefix;
    if (prefix != null) {
      return prefix.isEmpty ? null : prefix;
    }
    if (retreat) {
      return '**Logic**: Retreat.';
    }
    if (actor != RoveActionActorKind.self) {
      final actorPrefix = actor.descriptionForAction(this);
      if (staticDescription?.body?.startsWith(actorPrefix) != true) {
        return actorPrefix;
      }
    }
    return null;
  }

  String descriptionForAugmentingAction(RoveAction action,
      {bool short = false}) {
    final buff = toBuff;
    return staticDescription != null
        ? augmentDescription
        : buff != null
            ? buff.descriptionForAction(action, short: short)
            : augmentDescription;
  }

  bool get requiresTargetSelection {
    switch (targetMode) {
      case RoveActionTargetMode.all:
      case RoveActionTargetMode.eventActor:
      case RoveActionTargetMode.eventTarget:
      case RoveActionTargetMode.previous:
        return false;
      case RoveActionTargetMode.range:
        switch (type) {
          case RoveActionType.attack:
          case RoveActionType.command:
          case RoveActionType.forceAttack:
          case RoveActionType.forceMove:
          case RoveActionType.pull:
          case RoveActionType.push:
          case RoveActionType.select:
          case RoveActionType.suffer:
          case RoveActionType.swapSpace:
          case RoveActionType.trade:
          case RoveActionType.transformEther:
            return true;
          case RoveActionType.buff:
          case RoveActionType.heal:
          case RoveActionType.revive:
            return targetKind != TargetKind.self;
          case RoveActionType.createGlyph:
          case RoveActionType.createTrap:
          case RoveActionType.flipCard:
          case RoveActionType.generateEther:
          case RoveActionType.infuseEther:
          case RoveActionType.jump:
          case RoveActionType.leave:
          case RoveActionType.loot:
          case RoveActionType.dash:
          case RoveActionType.placeField:
          case RoveActionType.removeEther:
          case RoveActionType.rerollEther:
          case RoveActionType.addDefense:
            return targetKind != TargetKind.self;
          case RoveActionType.group:
          case RoveActionType.special:
          case RoveActionType.spawn:
          case RoveActionType.summon:
          case RoveActionType.teleport:
          case RoveActionType.triggerFields:
            return false;
        }
    }
  }

  RoveActionPolarity get polarity {
    switch (type) {
      case RoveActionType.placeField:
        return field!.isPositive
            ? RoveActionPolarity.positive
            : RoveActionPolarity.negative;
      case RoveActionType.command:
        return targetKind == TargetKind.ally
            ? RoveActionPolarity.positive
            : RoveActionPolarity.negative;
      case RoveActionType.attack:
      case RoveActionType.createTrap:
      case RoveActionType.forceAttack:
      case RoveActionType.pull:
      case RoveActionType.push:
      case RoveActionType.suffer:
        return RoveActionPolarity.negative;
      case RoveActionType.buff:
      case RoveActionType.heal:
      case RoveActionType.revive:
      case RoveActionType.trade:
      case RoveActionType.summon:
        return RoveActionPolarity.positive;
      case RoveActionType.createGlyph:
      case RoveActionType.generateEther:
      case RoveActionType.group:
      case RoveActionType.infuseEther:
      case RoveActionType.flipCard:
      case RoveActionType.forceMove:
      case RoveActionType.jump:
      case RoveActionType.leave:
      case RoveActionType.loot:
      case RoveActionType.dash:
      case RoveActionType.removeEther:
      case RoveActionType.rerollEther:
      case RoveActionType.addDefense:
      case RoveActionType.select:
      case RoveActionType.special:
      case RoveActionType.spawn:
      case RoveActionType.swapSpace:
      case RoveActionType.teleport:
      case RoveActionType.transformEther:
        return RoveActionPolarity.neutral;
      case RoveActionType.triggerFields:
        if (field?.isPositive == true) {
          return RoveActionPolarity.positive;
        } else if (field?.isPositive == false) {
          return RoveActionPolarity.negative;
        } else {
          return RoveActionPolarity.neutral;
        }
    }
  }

  List<Ether> get generateEtherOptions {
    if (type != RoveActionType.generateEther || object == null) return [];
    return Ether.etherOptionsFromString(object!);
  }

  FlipCondition? get flipCondition {
    final key = object;
    if (type != RoveActionType.flipCard || key == null) return null;
    return FlipCondition.fromKey(key);
  }

  bool get isRangeAttack => type == RoveActionType.attack && range.$1 > 1;

  bool get isTargetActor =>
      targetMode != RoveActionTargetMode.previous &&
      range.$1 == 0 &&
      range.$2 == 0;

  String get buffDescription => toBuff?.descriptionForAction(this) ?? '';

  RoveAction withBuff(RoveBuff buff) {
    assert(buff.canBuffAction(this));

    if (type == RoveActionType.group) {
      return RoveAction.group(children.map((e) => e.withBuff(buff)).toList());
    }

    var range = this.range;
    var amount = this.amount;
    var push = this.push;
    var pierce = this.pierce;
    var modifiers = this.modifiers;
    var field = this.field;
    var targetCount = this.targetCount;
    switch (buff.type) {
      case BuffType.endRange:
      case BuffType.rangeAttackEndRange:
        range = (range.$1, range.$2 + buff.amount);
        break;
      case BuffType.amount:
      case BuffType.attack:
        amount += buff.amount;
        if (buff.field != null) {
          field = buff.field;
        }
        break;
      case BuffType.defense:
        throw UnimplementedError();
      case BuffType.field:
        field = buff.field;
        break;
      case BuffType.ignoreTerrainEffects:
        modifiers.add(IgnoreTerrainEffectsModifier());
        break;
      case BuffType.pierce:
        pierce = true;
        break;
      case BuffType.push:
        push += buff.amount;
        break;
      case BuffType.targetCount:
        targetCount += buff.amount;
      case BuffType.maxHealth:
      case BuffType.trapDamage:
        throw UnimplementedError();
    }
    return RoveAction(
        actor: actor,
        actorRange: actorRange,
        type: type,
        object: object,
        amount: amount,
        amountFormula: amountFormula,
        targetCount: targetCount,
        targetMode: targetMode,
        targetKind: targetKind,
        rangeOrigin: rangeOrigin,
        range: range,
        rangeFormula: rangeFormula,
        aoe: aoe,
        pull: pull,
        push: push,
        pushFormula: pushFormula,
        pierce: pierce,
        field: field,
        modifiers: modifiers,
        buffType: buffType,
        buffScope: buffScope,
        augments: augments,
        requiresPrevious: requiresPrevious,
        retreat: retreat,
        xDefinition: xDefinition,
        exclusiveGroup: exclusiveGroup,
        staticDescription: staticDescription,
        children: children);
  }

  RoveAction withAmount(int amount) {
    return RoveAction(
        actor: actor,
        actorRange: actorRange,
        type: type,
        object: object,
        amount: amount,
        amountFormula: amountFormula,
        targetCount: targetCount,
        targetMode: targetMode,
        targetKind: targetKind,
        rangeOrigin: rangeOrigin,
        range: range,
        rangeFormula: rangeFormula,
        aoe: aoe,
        pull: pull,
        push: push,
        pushFormula: pushFormula,
        pierce: pierce,
        modifiers: modifiers,
        field: field,
        buffType: buffType,
        buffScope: buffScope,
        augments: augments,
        requiresPrevious: requiresPrevious,
        retreat: retreat,
        xDefinition: xDefinition,
        exclusiveGroup: exclusiveGroup,
        staticDescription: staticDescription,
        children: children);
  }

  RoveAction withEtherCheckAugment(
      {required Ether ether, required RoveAction action}) {
    final augment = ActionAugment(
        condition: EtherCheckCondition(ethers: [ether]), action: action);
    return withAugments([augment]);
  }

  RoveAction withEtherPoolAugment(
      {required Ether ether,
      required RoveAction action,
      bool isReplacement = false}) {
    final augment = ActionAugment(
        condition: PersonalPoolEtherCondition(ether: ether),
        action: action,
        isReplacement: isReplacement);
    return withAugments([augment]);
  }

  RoveAction withAugment(ActionAugment augment) {
    return withAugments([augment]);
  }

  RoveAction withAugments(List<ActionAugment> augments) {
    return _byReplacingAugments([...this.augments, ...augments]);
  }

  RoveAction withoutAugments() {
    return _byReplacingAugments([]);
  }

  RoveAction _byReplacingAugments(List<ActionAugment> augments) {
    return RoveAction(
        actor: actor,
        actorRange: actorRange,
        type: type,
        object: object,
        amount: amount,
        amountFormula: amountFormula,
        targetCount: targetCount,
        targetMode: targetMode,
        targetKind: targetKind,
        rangeOrigin: rangeOrigin,
        range: range,
        rangeFormula: rangeFormula,
        aoe: aoe,
        pull: pull,
        push: push,
        pushFormula: pushFormula,
        pierce: pierce,
        modifiers: modifiers,
        field: field,
        buffType: buffType,
        buffScope: buffScope,
        augments: augments,
        requiresPrevious: requiresPrevious,
        retreat: retreat,
        xDefinition: xDefinition,
        exclusiveGroup: exclusiveGroup,
        staticDescription: staticDescription,
        children: children);
  }

  RoveAction withSingleTarget({bool requiresPrevious = true}) {
    return RoveAction(
        actor: actor,
        actorRange: actorRange,
        type: type,
        object: object,
        amount: amount,
        amountFormula: amountFormula,
        targetCount: 1,
        targetMode: targetMode,
        targetKind: targetKind,
        rangeOrigin: rangeOrigin,
        range: range,
        rangeFormula: rangeFormula,
        aoe: aoe,
        pull: pull,
        push: push,
        pushFormula: pushFormula,
        pierce: pierce,
        modifiers: modifiers,
        field: field,
        buffType: buffType,
        buffScope: buffScope,
        augments: augments,
        requiresPrevious: requiresPrevious,
        retreat: retreat,
        xDefinition: xDefinition,
        exclusiveGroup: exclusiveGroup,
        staticDescription: staticDescription,
        children: children);
  }

  RoveAction withDescription(String description) {
    return _withDescription(RoveActionDescription(body: description));
  }

  RoveAction withHidden() {
    return _withDescription(RoveActionDescription(body: ''));
  }

  bool get hidden => staticDescription?.body?.isEmpty ?? false;

  RoveAction withoutPrefix() {
    return _withDescription(RoveActionDescription(prefix: ''));
  }

  RoveAction withPrefix(String prefix) {
    return _withDescription(RoveActionDescription(prefix: prefix));
  }

  RoveAction withSuffix(String suffix) {
    return _withDescription(RoveActionDescription(suffix: suffix));
  }

  RoveAction withTargetDescription(String target) {
    return _withDescription(RoveActionDescription(target: target));
  }

  RoveAction _withDescription(RoveActionDescription description) {
    return RoveAction(
        actor: actor,
        actorRange: actorRange,
        type: type,
        object: object,
        amount: amount,
        amountFormula: amountFormula,
        targetCount: targetCount,
        targetMode: targetMode,
        targetKind: targetKind,
        rangeOrigin: rangeOrigin,
        range: range,
        rangeFormula: rangeFormula,
        aoe: aoe,
        pull: pull,
        push: push,
        pushFormula: pushFormula,
        pierce: pierce,
        modifiers: modifiers,
        field: field,
        buffType: buffType,
        buffScope: buffScope,
        augments: augments,
        requiresPrevious: requiresPrevious,
        retreat: retreat,
        xDefinition: xDefinition,
        exclusiveGroup: exclusiveGroup,
        staticDescription: RoveActionDescription(
          prefix: description.prefix ?? staticDescription?.prefix,
          body: description.body ?? staticDescription?.body,
          target: description.target ?? staticDescription?.target,
          suffix: description.suffix ?? staticDescription?.suffix,
        ),
        children: children);
  }

  RoveAction withPull() {
    return RoveAction(
        type: RoveActionType.pull,
        amount: pull,
        targetMode: RoveActionTargetMode.previous);
  }

  RoveAction withPush() {
    return RoveAction(
        type: RoveActionType.push,
        amount: push,
        targetMode: RoveActionTargetMode.previous);
  }
}

enum RoveActionXDefinition {
  previousMovementEffort,
  targetDefense;

  String toJson() {
    switch (this) {
      case previousMovementEffort:
        return 'previous_movement_effort';
      case targetDefense:
        return 'target_defense';
    }
  }

  static RoveActionXDefinition fromJson(String value) {
    return _xDefinitionJsonMap[value]!;
  }
}

final Map<String, RoveActionXDefinition> _xDefinitionJsonMap =
    Map<String, RoveActionXDefinition>.fromEntries(
        RoveActionXDefinition.values.map((v) => MapEntry(v.toJson(), v)));
