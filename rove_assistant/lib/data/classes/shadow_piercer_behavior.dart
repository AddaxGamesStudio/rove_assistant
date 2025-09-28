import 'package:rove_data_types/rove_data_types.dart';
import 'rover_class_behavior.dart';

class ShadowPiercerBehavior extends RoverClassBehavior {
  @override
  FieldEffect get auraEffect {
    return FieldEffect(
        buff: RoveBuff(amount: 1, type: BuffType.attack),
        action: RoveAction.heal(1, targetKind: TargetKind.self));
  }

  @override
  FieldEffect get miasmaEffect {
    return FieldEffect(
        buff: RoveBuff(amount: -2, type: BuffType.attack), action: null);
  }

  @override
  List<AbilityDef> get abilities {
    return [
      AbilityDef(
        id: 'C-025',
        name: 'Bound',
        actions: [
          RoveAction.move(3),
        ],
      ),
      AbilityDef(
        id: 'C-026',
        name: 'Brace',
        actions: [
          RoveAction.buff(BuffType.rangeAttackEndRange, 1,
                  scope: BuffScope.untilEndOfTurn)
              .withDescription(
                  'Gain +1 [range] to your next [r_attack] this turn.'),
        ],
      ),
      AbilityDef(
        id: 'C-027',
        name: 'Ambush',
        actions: [
          RoveAction.rangeAttack(2, endRange: 3),
        ],
      ),
      AbilityDef(
        id: 'C-028',
        name: 'Reknit',
        actions: [
          RoveAction.heal(1,
              startRange: 1, endRange: 3, targetKind: TargetKind.ally),
        ],
      ),
    ];
  }

  @override
  List<SkillDef> get skills {
    return [
      SkillDef(
          id: 'S-105',
          name: 'Lifeblood',
          type: SkillType.rave,
          subtype: 'pact',
          back: 'Bell Tolls',
          etherCost: 1,
          actions: [
            RoveAction.heal(3, endRange: 3, field: EtherField.aura).withAugment(
                ActionAugment(
                    condition: EtherCheckCondition(ethers: const [Ether.morph]),
                    action: RoveAction.buff(BuffType.amount, 1)))
          ]),
      SkillDef(
          id: 'S-106',
          name: 'Bell Tolls',
          type: SkillType.rave,
          subtype: 'pact',
          back: 'Lifeblood',
          etherCost: 2,
          actions: [
            RoveAction.rangeAttack(3, endRange: 4, field: EtherField.miasma)
                .withAugment(ActionAugment(
                    condition: EtherCheckCondition(ethers: const [Ether.water]),
                    action: RoveAction.buff(BuffType.amount, 1)))
          ]),
      SkillDef(
          id: 'S-107',
          name: 'Passing Knell',
          type: SkillType.rally,
          subtype: 'pact',
          back: 'Eviscerate',
          actions: [
            RoveAction.rangeAttack(1, endRange: 3, field: EtherField.snapfrost),
            RoveAction.generateEther(ether: Ether.water),
          ]),
      SkillDef(
          id: 'S-108',
          name: 'Eviscerate',
          type: SkillType.rave,
          subtype: 'transform',
          back: 'Passing Knell',
          actions: [
            RoveAction.jump(5),
            RoveAction(type: RoveActionType.attack, amount: 5, range: (1, 1))
                .withAugment(ActionAugment(
                    condition: EtherCheckCondition(ethers: const [Ether.morph]),
                    action: RoveAction.buff(BuffType.amount, 2))),
          ],
          etherCost: 3,
          abilityCost: 1),
      SkillDef(
          id: 'S-109',
          name: 'Careful Aim',
          type: SkillType.rally,
          subtype: 'pact',
          back: 'Devour Prey',
          actions: [
            RoveAction.rangeAttack(2, endRange: 4),
            RoveAction.generateEther(),
          ]),
      SkillDef(
          id: 'S-110',
          name: 'Devour Prey',
          type: SkillType.rave,
          subtype: 'transform',
          back: 'Careful Aim',
          actions: [
            RoveAction.jump(4),
            RoveAction(
                type: RoveActionType.attack,
                amount: 4,
                range: (1, 1),
                pierce: true),
            RoveAction(
                    type: RoveActionType.heal,
                    amount: 1,
                    targetKind: TargetKind.self,
                    requiresPrevious: true)
                .withAugment(ActionAugment(
                    condition: EtherCheckCondition(ethers: const [Ether.morph]),
                    action: RoveAction.buff(BuffType.amount, 1))),
          ],
          etherCost: 3,
          abilityCost: 1),
      SkillDef(
          id: 'S-111',
          name: 'Incant',
          type: SkillType.rally,
          subtype: 'pact',
          back: 'Drag Away',
          actions: [
            RoveAction(
                type: RoveActionType.placeField,
                field: EtherField.aura,
                targetKind: TargetKind.self),
            RoveAction.generateEther(),
            RoveAction.flip(AnySkillFlipCondition())
          ]),
      SkillDef(
          id: 'S-112',
          name: 'Drag Away',
          type: SkillType.rave,
          subtype: 'transform',
          back: 'Incant',
          actions: [
            RoveAction.jump(4).withAugment(ActionAugment(
                condition: EtherCheckCondition(ethers: const [Ether.morph]),
                action: RoveAction.move(2))),
            RoveAction(
                type: RoveActionType.pull,
                amount: 3,
                range: (2, 4),
                requiresPrevious: true),
            RoveAction(
                type: RoveActionType.attack,
                amount: 4,
                range: (1, 1),
                requiresPrevious: true),
            RoveAction.flip(SubtypeFlipCondition(subtype: 'transform'))
          ],
          etherCost: 2),
      SkillDef(
          id: 'S-113',
          name: 'Miasmic Arrow',
          type: SkillType.rally,
          subtype: 'pact',
          back: 'Invigorate',
          actions: [
            RoveAction(
                type: RoveActionType.placeField,
                field: EtherField.miasma,
                range: (0, 3)),
            RoveAction.generateEther(ether: Ether.morph),
          ]),
      SkillDef(
          id: 'S-114',
          name: 'Invigorate',
          type: SkillType.rally,
          subtype: 'pact',
          back: 'Miasmic Arrow',
          actions: [
            RoveAction.heal(2, endRange: 3),
            RoveAction.generateEther(),
          ]),
      SkillDef(
          id: 'S-119',
          name: 'Lithe Form',
          type: SkillType.rally,
          subtype: 'transform',
          isUpgrade: true,
          back: 'Pounce',
          actions: [
            RoveAction.jump(3),
            RoveAction.generateEther(),
          ]),
      SkillDef(
          id: 'S-120',
          name: 'Pounce',
          type: SkillType.rave,
          subtype: 'transform',
          isUpgrade: true,
          back: 'Lithe Form',
          etherCost: 2,
          abilityCost: 1,
          actions: [
            RoveAction.jump(3),
            RoveAction.meleeAttack(5, field: EtherField.snapfrost),
            RoveAction(
                    type: RoveActionType.jump,
                    amount: 2,
                    targetKind: TargetKind.self,
                    requiresPrevious: true)
                .withEtherCheckAugment(
                    ether: Ether.morph,
                    action: RoveAction.buff(BuffType.amount, 2)),
          ]),
      SkillDef(
          id: 'S-121',
          name: 'Crimson Curse',
          type: SkillType.rally,
          subtype: 'pact',
          isUpgrade: true,
          back: 'Ebony Blessing',
          actions: [
            RoveAction.meleeAttack(1, field: EtherField.miasma),
            RoveAction.generateEther(ether: Ether.morph),
          ]),
      SkillDef(
          id: 'S-122',
          name: 'Ebony Blessing',
          type: SkillType.rally,
          subtype: 'transform',
          isUpgrade: true,
          back: 'Crimson Curse',
          actions: [
            RoveAction.heal(1, endRange: 3, field: EtherField.aura),
            RoveAction.generateEther(ether: Ether.water),
          ]),
      SkillDef(
          id: 'S-123',
          name: 'Drain Essence',
          type: SkillType.rally,
          subtype: 'pact',
          isUpgrade: true,
          back: 'Keen Bolter',
          actions: [
            RoveAction.rangeAttack(1, endRange: 3),
            RoveAction(
                type: RoveActionType.heal,
                amount: 1,
                targetKind: TargetKind.selfOrAlly,
                range: (0, 3),
                requiresPrevious: true),
            RoveAction.generateEther(),
          ]),
      SkillDef(
          id: 'S-124',
          name: 'Keen Bolter',
          type: SkillType.rave,
          subtype: 'pact',
          isUpgrade: true,
          back: 'Drain Essence',
          etherCost: 3,
          actions: [
            RoveAction.rangeAttack(6, endRange: 3).withEtherCheckAugment(
                ether: Ether.water,
                action: RoveAction.buff(BuffType.field, 0,
                    field: EtherField.snapfrost))
          ]),
      SkillDef(
          id: 'S-125',
          name: 'Grace Note',
          type: SkillType.rally,
          subtype: 'transform',
          isUpgrade: true,
          back: 'Umbral Howl',
          actions: [
            RoveAction(
                type: RoveActionType.attack,
                amount: 1,
                pierce: true,
                range: (1, 1),
                aoe: AOEDef.x2Sides(),
                targetCount: RoveAction.allTargets),
            RoveAction.generateEther(ether: Ether.morph),
          ]),
      SkillDef(
          id: 'S-126',
          name: 'Umbral Howl',
          type: SkillType.rave,
          subtype: 'transform',
          isUpgrade: true,
          back: 'Grace Note',
          etherCost: 3,
          abilityCost: 1,
          actions: [
            RoveAction(
                    type: RoveActionType.attack,
                    amount: 1,
                    range: (1, 2),
                    pierce: true,
                    push: 1,
                    targetCount: 3)
                .withEtherCheckAugment(
                    ether: Ether.morph,
                    action: RoveAction.buff(BuffType.push, 1)),
            RoveAction(
                type: RoveActionType.jump,
                amount: 3,
                targetKind: TargetKind.self,
                requiresPrevious: true),
            RoveAction(
                type: RoveActionType.attack,
                amount: 4,
                range: (1, 1),
                requiresPrevious: true),
            RoveAction.flip(SubtypeFlipCondition(subtype: 'transform'))
          ]),
      SkillDef(
          id: 'S-127',
          name: 'Refrain',
          type: SkillType.rave,
          subtype: 'pact',
          isUpgrade: true,
          back: 'Forte',
          etherCost: 2,
          actions: [
            RoveAction(
                    type: RoveActionType.attack,
                    amount: 2,
                    range: (2, 3),
                    aoe: AOEDef.x7Honeycomb(),
                    targetCount: 3)
                .withEtherCheckAugment(
                    ether: Ether.water,
                    action: RoveAction.buff(BuffType.targetCount, 1)),
          ]),
      SkillDef(
          id: 'S-128',
          name: 'Forte',
          type: SkillType.rave,
          subtype: 'pact',
          isUpgrade: true,
          back: 'Refrain',
          etherCost: 2,
          actions: [
            RoveAction.meleeAttack(5, pierce: true).withEtherCheckAugment(
                ether: Ether.morph,
                action: RoveAction.buff(BuffType.amount, 1,
                    field: EtherField.miasma)),
          ]),
    ];
  }

  @override
  List<ReactionDef> get reactions {
    return [
      ReactionDef(
          id: 'S-115',
          name: 'Draw From Blood',
          subtype: 'pact',
          back: 'Consume Vitality',
          trigger: ReactionTriggerDef(
              type: RoveEventType.afterSuffer,
              targetKind: TargetKind.enemy,
              range: (1, 5),
              amount: 3),
          actions: [
            RoveAction.generateEther().withAugment(ActionAugment(
                condition: ReactionTriggerAugmentCondition(
                    trigger: ReactionTriggerDef(
                        type: RoveEventType.afterSuffer,
                        targetKind: TargetKind.enemy,
                        range: (1, 5),
                        amount: 5)),
                action: RoveAction(
                    type: RoveActionType.generateEther,
                    object: Ether.etherOptionsToString(
                        [Ether.water, Ether.morph])).withDescription(
                    'If the enemy suffered 5 or more [dmg], generate [water] or [morph] instead.'),
                isReplacement: true))
          ]),
      ReactionDef(
          id: 'S-116',
          name: 'Consume Vitality',
          subtype: 'pact',
          back: 'Draw From Blood',
          trigger: ReactionTriggerDef(
              type: RoveEventType.afterSuffer,
              targetKind: TargetKind.enemy,
              range: (1, 5),
              amount: 3),
          actions: [
            RoveAction.heal(1, endRange: 3).withAugment(ActionAugment(
                condition: PersonalPoolEtherCondition(ether: Ether.water),
                action: RoveAction.buff(BuffType.amount, 1)))
          ]),
      ReactionDef(
          id: 'S-117',
          name: 'Disengage',
          subtype: 'transform',
          back: 'Feral Swipe',
          trigger: ReactionTriggerDef(
              type: RoveEventType.afterMove,
              actorKind: TargetKind.enemy,
              range: (1, 1)),
          actions: [
            RoveAction.jump(2).withAugment(ActionAugment(
                condition: PersonalPoolEtherCondition(ether: Ether.morph),
                action: RoveAction.buff(BuffType.amount, 2)))
          ]),
      ReactionDef(
          id: 'S-118',
          name: 'Feral Swipe',
          subtype: 'transform',
          back: 'Disengage',
          trigger: ReactionTriggerDef(
              type: RoveEventType.afterMove,
              actorKind: TargetKind.enemy,
              range: (1, 1)),
          actions: [
            RoveAction(
                    type: RoveActionType.attack,
                    amount: 1,
                    range: (1, 1),
                    targetMode: RoveActionTargetMode.eventActor)
                .withTargetDescription('that enemy'),
            RoveAction.generateEther()
          ]),
    ];
  }
}
