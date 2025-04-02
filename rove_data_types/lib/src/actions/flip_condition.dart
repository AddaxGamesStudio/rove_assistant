import 'package:rove_data_types/src/actions/reaction_def.dart';
import 'package:rove_data_types/src/actions/skill_def.dart';

abstract class FlipCondition {
  String get description;
  String get shortDescription;
  String get key;
  bool get requiresUserInput;
  bool matchesSkill(SkillDef skill);
  bool matchesReaction(ReactionDef reaction);

  FlipCondition();

  factory FlipCondition.fromKey(String key) {
    if (SkillType.values.map((s) => s.name).contains(key)) {
      return SkillTypeFlipCondition(type: SkillType.fromName(key));
    }
    switch (key) {
      case 'any':
        return AnyFlipCondition();
      case 'any_skill':
        return AnySkillFlipCondition();
      case 'all(rave)':
        return AllRaveFlipCondition();
    }

    return SubtypeFlipCondition(subtype: key);
  }
}

class SubtypeFlipCondition extends FlipCondition {
  final String subtype;

  SubtypeFlipCondition({required this.subtype});

  @override
  String get description => '$subtype card';

  @override
  String get key => subtype;

  @override
  bool matchesSkill(SkillDef skill) {
    return skill.subtype.toLowerCase() == subtype.toLowerCase();
  }

  @override
  bool matchesReaction(ReactionDef reaction) {
    return reaction.subtype.toLowerCase() == subtype.toLowerCase();
  }

  @override
  bool get requiresUserInput => true;

  @override
  String get shortDescription => subtype;
}

class SkillTypeFlipCondition extends FlipCondition {
  final SkillType type;

  SkillTypeFlipCondition({required this.type});

  @override
  String get description => '${type.label} card';

  @override
  String get key => type.name;

  @override
  bool matchesSkill(SkillDef skill) {
    return skill.type == type;
  }

  @override
  bool matchesReaction(ReactionDef reaction) {
    return false;
  }

  @override
  bool get requiresUserInput => true;

  @override
  String get shortDescription => type.label;
}

class AnyFlipCondition extends FlipCondition {
  @override
  String get description => 'any card';

  @override
  String get key => 'any';

  @override
  bool matchesSkill(SkillDef skill) {
    return true;
  }

  @override
  bool matchesReaction(ReactionDef reaction) {
    return true;
  }

  @override
  bool get requiresUserInput => true;

  @override
  String get shortDescription => 'any';
}

class AnySkillFlipCondition extends FlipCondition {
  @override
  String get description =>
      '${SkillType.rave.label} or ${SkillType.rally.label} card';

  @override
  String get key => 'any_skill';

  @override
  bool matchesSkill(SkillDef skill) {
    return true;
  }

  @override
  bool matchesReaction(ReactionDef reaction) {
    return false;
  }

  @override
  bool get requiresUserInput => true;

  @override
  String get shortDescription =>
      '${SkillType.rave.label} or ${SkillType.rally.label}';
}

class AllRaveFlipCondition extends FlipCondition {
  @override
  String get description => 'all Rave cards';

  @override
  String get key => 'all(rave)';

  @override
  bool matchesSkill(SkillDef skill) {
    return skill.type == SkillType.rave;
  }

  @override
  bool matchesReaction(ReactionDef reaction) {
    return false;
  }

  @override
  bool get requiresUserInput => false;

  @override
  String get shortDescription => 'all Rave';
}
