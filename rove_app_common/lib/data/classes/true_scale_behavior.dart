import 'package:rove_data_types/rove_data_types.dart';
import 'package:rove_app_common/data/classes/rover_class_behavior.dart';

class TrueScaleBehavior extends RoverClassBehavior {
  @override
  FieldEffect get auraEffect => FieldEffect.empty();

  @override
  FieldEffect get miasmaEffect {
    return FieldEffect(
        buff: RoveBuff(amount: -1, type: BuffType.attack),
        action: RoveAction(
            type: RoveActionType.suffer,
            amount: 1,
            targetKind: TargetKind.self));
  }

  @override
  List<AbilityDef> get abilities {
    return [
      AbilityDef(name: 'Skitter', actions: [
        RoveAction.move(4),
      ]),
      AbilityDef(name: 'Take Stock', actions: [
        RoveAction.heal(1, targetKind: TargetKind.self).withAugment(
            ActionAugment(
                condition: PersonalPoolEtherCondition(ether: Ether.morph),
                action: RoveAction.buff(BuffType.amount, 1))),
      ]),
      AbilityDef(name: 'Strike', actions: [
        RoveAction.meleeAttack(2, endRange: 1),
      ]),
      AbilityDef(name: 'Seize', actions: [
        RoveAction.forceMove(1, endRange: 3),
      ]),
    ];
  }

  @override
  List<SkillDef> get skills {
    return [
      SkillDef(
          name: 'Blast Step',
          type: SkillType.rally,
          subtype: 'Rasska',
          back: 'Traitorous Thoughts',
          actions: [
            RoveAction.jump(3).withAugment(ActionAugment(
                condition: PersonalPoolEtherCondition(ether: Ether.fire),
                action: RoveAction.buff(BuffType.amount, 2))),
            RoveAction.generateEther(ether: Ether.fire)
          ]),
      SkillDef(
          name: 'Traitorous Thoughts',
          type: SkillType.rave,
          subtype: 'Keb',
          back: 'Blast Step',
          etherCost: 3,
          actions: [
            RoveAction(
                    type: RoveActionType.forceAttack,
                    amount: 5,
                    range: (1, 3),
                    targetKind: TargetKind.enemy)
                .withAugment(ActionAugment(
                    condition: EtherCheckCondition(ethers: const [Ether.morph]),
                    action: RoveAction.buff(BuffType.field, 0,
                        field: EtherField.miasma))),
            RoveAction.generateEther(ether: Ether.fire)
          ]),
      SkillDef(
          name: 'Intrusive Thoughts',
          type: SkillType.rally,
          subtype: 'Keb',
          back: 'Ruthless Assault',
          actions: [
            RoveAction.forceMove(2, endRange: 3),
            RoveAction.generateEther(ether: Ether.morph)
          ]),
      SkillDef(
          name: 'Ruthless Assault',
          type: SkillType.rave,
          subtype: 'Rasska',
          back: 'Intrusive Thoughts',
          etherCost: 2,
          actions: [
            RoveAction(
                    type: RoveActionType.attack,
                    amount: 2,
                    range: (1, 1),
                    field: EtherField.wildfire)
                .withAugment(ActionAugment(
                    condition: EtherCheckCondition(ethers: const [Ether.fire]),
                    action: RoveAction.buff(BuffType.amount, 1))),
            RoveAction(
                type: RoveActionType.attack,
                amount: 2,
                range: (1, 1),
                field: EtherField.wildfire),
          ]),
      SkillDef(
          name: 'Settling Groundwork',
          type: SkillType.rally,
          subtype: 'Keb/Rasska',
          back: 'Coordinated Assault',
          actions: [
            RoveAction.heal(2, targetKind: TargetKind.self),
            RoveAction.generateEther()
          ]),
      SkillDef(
          name: 'Coordinated Assault',
          type: SkillType.rave,
          subtype: 'Keb/Rasska',
          back: 'Settling Groundwork',
          etherCost: 3,
          actions: [
            RoveAction(
              type: RoveActionType.attack,
              amount: 2,
              range: (1, 1),
              aoe: AOEDef.x2Front(),
              targetCount: 0,
            ).withAugment(ActionAugment(
                condition: EtherCheckCondition(ethers: const [Ether.fire]),
                action: RoveAction.buff(BuffType.push, 1))),
            RoveAction.rangeAttack(2, endRange: 3).withAugment(ActionAugment(
                condition: EtherCheckCondition(ethers: const [Ether.morph]),
                action: RoveAction.buff(BuffType.pierce, 0))),
          ]),
      SkillDef(
          name: 'Strange Chatter',
          type: SkillType.rally,
          subtype: 'Keb',
          back: 'Sweeping Cleave',
          etherCost: 2,
          actions: [
            RoveAction.rangeAttack(3, endRange: 3, field: EtherField.miasma)
                .withAugment(ActionAugment(
                    condition: EtherCheckCondition(ethers: const [Ether.morph]),
                    action: RoveAction.buff(BuffType.amount, 1))),
            RoveAction.flip(SubtypeFlipCondition(subtype: 'keb'))
          ]),
      SkillDef(
          name: 'Sweeping Cleave',
          type: SkillType.rally,
          subtype: 'Keb',
          back: 'Strange Chatter',
          etherCost: 1,
          actions: [
            RoveAction(
              type: RoveActionType.attack,
              amount: 2,
              range: (1, 1),
              aoe: AOEDef.x3Front(),
              targetCount: 0,
            ),
            RoveAction.flip(SubtypeFlipCondition(subtype: 'rasska'))
          ]),
      SkillDef(
          name: 'Shell Games',
          type: SkillType.rally,
          subtype: 'Keb',
          back: 'Knock Senseless',
          actions: [
            RoveAction(
                type: RoveActionType.buff,
                amount: 1,
                buffType: BuffType.defense,
                buffScope: BuffScope.untilStartOfTurn,
                range: (0, 2),
                targetKind: TargetKind.selfOrAlly),
            RoveAction.generateEther()
          ]),
      SkillDef(
          name: 'Knock Senseless',
          type: SkillType.rally,
          subtype: 'Rasska',
          back: 'Shell Games',
          actions: [
            RoveAction(
                type: RoveActionType.attack,
                amount: 1,
                range: (1, 1),
                field: EtherField.wildfire),
            RoveAction.generateEther()
          ]),
    ];
  }

  @override
  List<ReactionDef> get reactions {
    return [
      ReactionDef(
          name: 'Amidst the Fray',
          subtype: 'Rasska',
          back: 'Watch the Back',
          trigger: ReactionTriggerDef(
              type: RoveEventType.afterAttack,
              actorKind: TargetKind.self,
              staticDescription: 'After you attack:'),
          actions: [
            RoveAction.heal(1, targetKind: TargetKind.self).withAugment(
                ActionAugment(
                    condition: PersonalPoolEtherCondition(ether: Ether.morph),
                    action: RoveAction.buff(BuffType.amount, 1)))
          ]),
      ReactionDef(
          name: 'Watch the Back',
          subtype: 'Keb',
          back: 'Amidst the Fray',
          trigger: ReactionTriggerDef(
              type: RoveEventType.afterAttack,
              actorKind: TargetKind.self,
              staticDescription: 'After you attack:'),
          actions: [
            RoveAction.push(1,
                range: (1, 2), targetMode: RoveActionTargetMode.range),
            RoveAction.generateEther()
          ]),
      ReactionDef(
          name: 'Press the Advantage',
          subtype: 'Rasska',
          back: 'Against the Odds',
          trigger: ReactionTriggerDef(
              type: RoveEventType.beforeAttack,
              targetKind: TargetKind.self,
              staticDescription: 'Before you are attacked:'),
          actions: [
            RoveAction.meleeAttack(1).withAugment(ActionAugment(
                condition: PersonalPoolEtherCondition(ether: Ether.fire),
                action: RoveAction.buff(BuffType.amount, 1)))
          ]),
      ReactionDef(
          name: 'Against the Odds',
          subtype: 'Keb',
          back: 'Press the Advantage',
          trigger: ReactionTriggerDef(
              type: RoveEventType.beforeAttack,
              targetKind: TargetKind.self,
              staticDescription: 'Before you are attacked:'),
          actions: [
            RoveAction.buff(BuffType.defense, 1),
            RoveAction.generateEther()
          ]),
    ];
  }
}
