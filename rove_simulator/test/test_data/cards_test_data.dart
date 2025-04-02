import 'package:rove_simulator/model/cards/reaction_model.dart';
import 'package:rove_simulator/model/cards/skill_model.dart';
import 'package:rove_data_types/rove_data_types.dart';

import 'rover_class_test_data.dart';

extension SkillDefTestData on SkillDef {
  static SkillDef testSkillFront() {
    return SkillDef(
        name: 'Test Skill Front',
        type: SkillType.rally,
        subtype: 'Test',
        back: 'Test Skill Back',
        actions: [RoveAction.move(3)]);
  }

  static SkillDef testSkillBack() {
    return SkillDef(
        name: 'Test Skill Back',
        type: SkillType.rally,
        subtype: 'Test',
        back: 'Test Skill Front',
        actions: [RoveAction.meleeAttack(3)]);
  }
}

extension ReactionDefTestData on ReactionDef {
  static ReactionDef testReactionFront() {
    return ReactionDef(
        name: 'Test Reaction Front',
        subtype: 'Test',
        back: 'Test Reaction Back',
        trigger: ReactionTriggerDef(type: RoveEventType.startTurn),
        actions: [RoveAction.move(3)]);
  }

  static ReactionDef testReactionBack() {
    return ReactionDef(
        name: 'Test Reaction Back',
        subtype: 'Test',
        back: 'Test Reaction Front',
        trigger: ReactionTriggerDef(type: RoveEventType.startTurn),
        actions: [RoveAction.meleeAttack(3)]);
  }
}

extension SkillModelTestData on SkillModel {
  static SkillModel testSkill() {
    return SkillModel(
        front: SkillDefTestData.testSkillFront(),
        back: SkillDefTestData.testSkillBack(),
        roverClass: RoverClassTestData.testClass());
  }
}

extension ReactionModelTestData on ReactionModel {
  static ReactionModel testReaction() {
    return ReactionModel(
        front: ReactionDefTestData.testReactionFront(),
        back: ReactionDefTestData.testReactionBack());
  }
}
