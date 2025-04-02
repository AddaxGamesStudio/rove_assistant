import 'package:meta/meta.dart';
import 'package:rove_data_types/rove_data_types.dart';
import 'package:rove_data_types/src/utils/vector_utils.dart';

enum AugmentConditionType {
  actorAdjacentToTarget,
  actorHasHealth,
  actorInRangeOf,
  personalPoolEther,
  personalPoolNonDim,
  etherCheck,
  reactionTrigger,
  allyAdjacentToTarget,
  targetHasEther,
  infuse,
  removeGlyph,
  sufferDamage,
  targetOnField;

  String toJson() {
    switch (this) {
      case actorAdjacentToTarget:
        return 'actor_adjacent_to_target';
      case actorHasHealth:
        return 'actor_has_health';
      case actorInRangeOf:
        return 'actor_in_range_of';
      case personalPoolEther:
        return 'personal_pool_ether';
      case personalPoolNonDim:
        return 'personal_pool_any_active_ether';
      case etherCheck:
        return 'skill_ether_check';
      case reactionTrigger:
        return 'reaction_trigger';
      case allyAdjacentToTarget:
        return 'ally_adjacent_to_target';
      case targetHasEther:
        return 'target_has_ether';
      case infuse:
        return 'infuse';
      case removeGlyph:
        return 'remove_glyph';
      case sufferDamage:
        return 'suffer_damage';
      case targetOnField:
        return 'target_on_field';
    }
  }

  static AugmentConditionType fromJson(String value) {
    return _jsonMap[value]!;
  }
}

abstract class AugmentCondition {
  final List<Ether> ethers;

  AugmentCondition({required this.ethers});

  bool matchesEther(List<Ether> etherToMatch) {
    var etherToMatchCopy = etherToMatch.toList();
    return ethers.every((e) {
      if (etherToMatchCopy.contains(e)) {
        etherToMatchCopy.remove(e);
        return true;
      }
      return false;
    });
  }

  AugmentConditionType get type;
  Map<String, dynamic> get _additionalJsonFields => {};
  String get description;

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'type': type.toJson(),
      if (ethers.isNotEmpty) 'ethers': ethers.map((e) => e.toJson()).toList()
    };
    json.addAll(_additionalJsonFields);
    return json;
  }

  static List<Ether> _ethersFromJson(Map<String, dynamic> json) {
    return (json['ethers'] as List).map((e) => Ether.fromJson(e)).toList();
  }

  factory AugmentCondition.fromJson(Map<String, dynamic> json) {
    final type = AugmentConditionType.fromJson(json['type'] as String);
    switch (type) {
      case AugmentConditionType.actorAdjacentToTarget:
        return ActorAdjacentToTarget.fromJson(json);
      case AugmentConditionType.actorHasHealth:
        return ActorHasHealthCondition.fromJson(json);
      case AugmentConditionType.actorInRangeOf:
        return ActorHasHealthCondition.fromJson(json);
      case AugmentConditionType.personalPoolEther:
        return PersonalPoolEtherCondition.fromJson(json);
      case AugmentConditionType.personalPoolNonDim:
        return PersonalPoolNonDimCondition.fromJson(json);
      case AugmentConditionType.etherCheck:
        return EtherCheckCondition.fromJson(json);
      case AugmentConditionType.reactionTrigger:
        return ReactionTriggerAugmentCondition.fromJson(json);
      case AugmentConditionType.allyAdjacentToTarget:
        return AllyAdjacentToTargetAugmentCondition.fromJson(json);
      case AugmentConditionType.targetHasEther:
        return TargetHasEtherCondition.fromJson(json);
      case AugmentConditionType.infuse:
        return InfuseEtherCondition.fromJson(json);
      case AugmentConditionType.removeGlyph:
        return RemoveGlyphCondition.fromJson(json);
      case AugmentConditionType.sufferDamage:
        return SufferDamageCondition.fromJson(json);
      case AugmentConditionType.targetOnField:
        return TargetOnFieldCondition.fromJson(json);
    }
  }

  bool get usesPersonalPool;
}

final Map<String, AugmentConditionType> _jsonMap =
    Map<String, AugmentConditionType>.fromEntries(
        AugmentConditionType.values.map((v) => MapEntry(v.toJson(), v)));

@immutable
class PersonalPoolEtherCondition extends AugmentCondition {
  PersonalPoolEtherCondition({required Ether ether}) : super(ethers: [ether]);

  @override
  AugmentConditionType get type => AugmentConditionType.personalPoolEther;

  @override
  bool get usesPersonalPool => true;

  @override
  String get description => ethers.map((e) => e.label).join(', ');

  factory PersonalPoolEtherCondition.fromJson(Map<String, dynamic> json) {
    return PersonalPoolEtherCondition(
        ether: AugmentCondition._ethersFromJson(json).first);
  }
}

@immutable
class PersonalPoolNonDimCondition extends AugmentCondition {
  PersonalPoolNonDimCondition() : super(ethers: []);

  @override
  AugmentConditionType get type => AugmentConditionType.personalPoolNonDim;

  factory PersonalPoolNonDimCondition.fromJson(Map<String, dynamic> json) {
    return PersonalPoolNonDimCondition();
  }

  @override
  String get description => 'Dim Pool Ether';

  @override
  bool get usesPersonalPool => true;

  @override
  bool matchesEther(List<Ether> etherToMatch) {
    return etherToMatch.any((e) => e != Ether.dim);
  }
}

@immutable
class EtherCheckCondition extends AugmentCondition {
  EtherCheckCondition({required super.ethers});

  @override
  AugmentConditionType get type => AugmentConditionType.etherCheck;

  factory EtherCheckCondition.fromJson(Map<String, dynamic> json) {
    return EtherCheckCondition(ethers: AugmentCondition._ethersFromJson(json));
  }

  @override
  String get description => ethers.map((e) => e.label).join(',');

  @override
  bool get usesPersonalPool => false;
}

@immutable
class ReactionTriggerAugmentCondition extends AugmentCondition {
  final ReactionTriggerDef trigger;

  @override
  AugmentConditionType get type => AugmentConditionType.reactionTrigger;

  @override
  Map<String, dynamic> get _additionalJsonFields => {
        'trigger': trigger.toJson(),
      };

  factory ReactionTriggerAugmentCondition.fromJson(Map<String, dynamic> json) {
    return ReactionTriggerAugmentCondition(
        trigger: ReactionTriggerDef.fromJson(
            json['trigger'] as Map<String, dynamic>));
  }

  ReactionTriggerAugmentCondition({required this.trigger}) : super(ethers: []);

  @override
  String get description => trigger.description;

  @override
  bool matchesEther(List<Ether> etherToMatch) {
    return false;
  }

  @override
  bool get usesPersonalPool => false;
}

@immutable
class ActorAdjacentToTarget extends AugmentCondition {
  ActorAdjacentToTarget() : super(ethers: []);

  @override
  AugmentConditionType get type => AugmentConditionType.allyAdjacentToTarget;

  factory ActorAdjacentToTarget.fromJson(Map<String, dynamic> json) {
    return ActorAdjacentToTarget();
  }

  @override
  bool matchesEther(List<Ether> etherToMatch) {
    return false;
  }

  @override
  String get description => 'Actor adjacent to target';

  @override
  bool get usesPersonalPool => false;
}

@immutable
class AllyAdjacentToTargetAugmentCondition extends AugmentCondition {
  AllyAdjacentToTargetAugmentCondition() : super(ethers: []);

  @override
  AugmentConditionType get type => AugmentConditionType.allyAdjacentToTarget;

  factory AllyAdjacentToTargetAugmentCondition.fromJson(
      Map<String, dynamic> json) {
    return AllyAdjacentToTargetAugmentCondition();
  }

  @override
  bool matchesEther(List<Ether> etherToMatch) {
    return false;
  }

  @override
  String get description => 'Ally Adjacent To Target';

  @override
  bool get usesPersonalPool => false;
}

@immutable
class TargetHasEtherCondition extends AugmentCondition {
  TargetHasEtherCondition(Ether ether) : super(ethers: [ether]);

  @override
  AugmentConditionType get type => AugmentConditionType.targetHasEther;

  @override
  Map<String, dynamic> get _additionalJsonFields => {
        'ether': ether.toJson(),
      };

  factory TargetHasEtherCondition.fromJson(Map<String, dynamic> json) {
    return TargetHasEtherCondition(Ether.fromJson(json['ether'] as String));
  }

  @override
  bool matchesEther(List<Ether> etherToMatch) {
    return false;
  }

  @override
  String get description => 'Has ${ether.label} Ether';

  @override
  bool get usesPersonalPool => false;

  Ether get ether => ethers.first;
}

@immutable
class ActorIsInRangeOfCondition extends AugmentCondition {
  final (int, int) range;
  final String target;
  ActorIsInRangeOfCondition({required this.range, required this.target})
      : super(ethers: []);

  @override
  AugmentConditionType get type => AugmentConditionType.actorInRangeOf;

  @override
  Map<String, dynamic> get _additionalJsonFields => {
        'range': rangeToString(range),
        'target': target,
      };

  factory ActorIsInRangeOfCondition.fromJson(Map<String, dynamic> json) {
    return ActorIsInRangeOfCondition(
        range: parseRange(json['range'] as String),
        target: json['target'] as String);
  }

  @override
  bool matchesEther(List<Ether> etherToMatch) {
    return false;
  }

  @override
  String get description => 'Within ${rangeToString(range)} of $target';

  @override
  bool get usesPersonalPool => false;
}

@immutable
class ActorHasHealthCondition extends AugmentCondition {
  final String formula;
  ActorHasHealthCondition(this.formula) : super(ethers: []);

  @override
  AugmentConditionType get type => AugmentConditionType.actorHasHealth;

  @override
  Map<String, dynamic> get _additionalJsonFields => {
        'formula': formula,
      };

  factory ActorHasHealthCondition.fromJson(Map<String, dynamic> json) {
    return ActorHasHealthCondition(json['formula'] as String);
  }

  @override
  bool matchesEther(List<Ether> etherToMatch) {
    return false;
  }

  @override
  String get description => '$formula >= 0';

  @override
  bool get usesPersonalPool => false;

  bool matchesHealth(int health) {
    return roveResolveFormula(formula, {'H': health}) >= 0;
  }
}

@immutable
class InfuseEtherCondition extends AugmentCondition {
  InfuseEtherCondition() : super(ethers: []);

  @override
  AugmentConditionType get type => AugmentConditionType.infuse;

  factory InfuseEtherCondition.fromJson(Map<String, dynamic> json) {
    return InfuseEtherCondition();
  }

  @override
  bool matchesEther(List<Ether> etherToMatch) {
    return etherToMatch.isNotEmpty;
  }

  @override
  String get description => 'Infused Ether';

  @override
  bool get usesPersonalPool => true;
}

@immutable
class RemoveGlyphCondition extends AugmentCondition {
  RemoveGlyphCondition() : super(ethers: []);

  @override
  AugmentConditionType get type => AugmentConditionType.removeGlyph;

  factory RemoveGlyphCondition.fromJson(Map<String, dynamic> json) {
    return RemoveGlyphCondition();
  }

  @override
  bool matchesEther(List<Ether> etherToMatch) {
    return false;
  }

  @override
  String get description => 'Remove one of your glyphs';

  @override
  bool get usesPersonalPool => false;
}

@immutable
class SufferDamageCondition extends AugmentCondition {
  SufferDamageCondition() : super(ethers: []);

  @override
  AugmentConditionType get type => AugmentConditionType.sufferDamage;

  factory SufferDamageCondition.fromJson(Map<String, dynamic> json) {
    return SufferDamageCondition();
  }

  @override
  bool matchesEther(List<Ether> etherToMatch) {
    return false;
  }

  @override
  String get description => 'Suffer [DMG]1';

  @override
  bool get usesPersonalPool => false;
}

@immutable
class TargetOnFieldCondition extends AugmentCondition {
  final EtherField field;

  @override
  AugmentConditionType get type => AugmentConditionType.targetOnField;

  @override
  Map<String, dynamic> get _additionalJsonFields => {
        'field': field.toJson(),
      };

  factory TargetOnFieldCondition.fromJson(Map<String, dynamic> json) {
    return TargetOnFieldCondition(
        field: EtherField.fromJson(json['field'] as String));
  }

  TargetOnFieldCondition({required this.field}) : super(ethers: []);

  @override
  String get description => 'Target on ${field.label}';

  @override
  bool matchesEther(List<Ether> etherToMatch) {
    return false;
  }

  @override
  bool get usesPersonalPool => false;
}
