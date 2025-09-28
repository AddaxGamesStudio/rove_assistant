import 'package:rove_data_types/rove_data_types.dart';
import 'rover_class_behavior.dart';

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
      AbilityDef(
        id: 'C-049',
        name: 'Skitter',
        actions: [
          RoveAction.move(4),
        ],
      ),
      AbilityDef(
        id: 'C-050',
        name: 'Strike',
        actions: [
          RoveAction.meleeAttack(2, endRange: 1),
        ],
      ),
      AbilityDef(
        id: 'C-051',
        name: 'Take Stock',
        actions: [
          RoveAction.heal(1, targetKind: TargetKind.self).withAugment(
              ActionAugment(
                  condition: PersonalPoolEtherCondition(ether: Ether.morph),
                  action: RoveAction.buff(BuffType.amount, 1))),
        ],
      ),
      AbilityDef(
        id: 'C-052',
        name: 'Seize',
        actions: [
          RoveAction.forceMove(1, endRange: 3).withDescription(
              'Force one enemy within [range] 1-3 to perform [dash] 1.'),
        ],
      ),
    ];
  }

  @override
  List<SkillDef> get skills {
    return [
      SkillDef(
          id: 'S-209',
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
          id: 'S-210',
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
      SkillDef(
          id: 'S-211',
          name: 'Strange Chatter',
          type: SkillType.rave,
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
          id: 'S-212',
          name: 'Sweeping Cleave',
          type: SkillType.rave,
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
          id: 'S-213',
          name: 'Settling Groundwork',
          type: SkillType.rally,
          subtype: 'KebRasska',
          back: 'Coordinated Assault',
          actions: [
            RoveAction.heal(2, targetKind: TargetKind.self),
            RoveAction.generateEther()
          ]),
      SkillDef(
          id: 'S-214',
          name: 'Coordinated Assault',
          type: SkillType.rave,
          subtype: 'KebRasska',
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
          id: 'S-215',
          name: 'Intrusive Thoughts',
          type: SkillType.rally,
          subtype: 'Keb',
          back: 'Ruthless Assault',
          actions: [
            RoveAction.forceMove(2, endRange: 3).withDescription(
                'Force one enemy within [range] 1-3 to perform [dash] 2.'),
            RoveAction.generateEther(ether: Ether.morph)
          ]),
      SkillDef(
          id: 'S-216',
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
          id: 'S-217',
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
          id: 'S-218',
          name: 'Traitorous Thoughts',
          type: SkillType.rave,
          subtype: 'Keb',
          back: 'Blast Step',
          etherCost: 3,
          actions: [
            RoveAction(
                    type: RoveActionType.command,
                    range: (1, 3),
                    targetKind: TargetKind.enemy,
                    children: [
                      RoveAction.meleeAttack(5, targetKind: TargetKind.ally)
                    ])
                .withPrefix('Force one enemy within [range] 1-3 to perform:')
                .withAugment(ActionAugment(
                    condition: EtherCheckCondition(ethers: const [Ether.morph]),
                    action: RoveAction.buff(BuffType.field, 0,
                        field: EtherField.miasma))),
          ]),
    ];
  }

  @override
  List<ReactionDef> get reactions {
    return [
      ReactionDef(
          id: 'S-219',
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
          id: 'S-220',
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
          id: 'S-221',
          name: 'Against the Odds',
          subtype: 'Keb',
          back: 'Press the Advantage',
          trigger: ReactionTriggerDef(
              type: RoveEventType.beforeAttack,
              targetKind: TargetKind.self,
              staticDescription: 'Before you are attacked:'),
          actions: [
            RoveAction.buff(BuffType.defense, 1)
                .withDescription('Gain +1 [def] for that attack.'),
            RoveAction.generateEther()
          ]),
      ReactionDef(
          id: 'S-222',
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
    ];
  }
}
