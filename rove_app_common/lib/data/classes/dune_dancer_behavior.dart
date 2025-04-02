import 'package:rove_data_types/rove_data_types.dart';
import 'package:rove_app_common/data/classes/rover_class_behavior.dart';

class DuneDancerBehavior extends RoverClassBehavior {
  @override
  FieldEffect get auraEffect {
    return FieldEffect(
        buff: RoveBuff(amount: 1, type: BuffType.attack),
        action: RoveAction.placeField(EtherField.everbloom));
  }

  @override
  FieldEffect get miasmaEffect {
    return FieldEffect(
        buff: RoveBuff(amount: -1, type: BuffType.attack),
        action: RoveAction.placeField(EtherField.snapfrost));
  }

  @override
  List<AbilityDef> get abilities {
    return [
      AbilityDef(name: 'Stride', actions: [
        RoveAction.move(3).withAugment(ActionAugment(
            condition: PersonalPoolEtherCondition(ether: Ether.earth),
            action: RoveAction.buff(BuffType.ignoreTerrainEffects, 0))),
      ]),
      AbilityDef(name: 'Barter', actions: [
        RoveAction.trade(),
      ]),
      AbilityDef(
          name: 'Carve',
          requirement: DidNotPlayCardAbilityRequirement(cardName: 'Erosion'),
          actions: [
            RoveAction(
                    type: RoveActionType.attack,
                    amount: 2,
                    range: (1, 1),
                    staticDescription: RoveActionDescription(
                        prefix:
                            'Can only be activated if Erosion was not activated:'))
                .withAugment(ActionAugment(
                    condition: PersonalPoolEtherCondition(ether: Ether.earth),
                    action: RoveAction.buff(BuffType.amount, 1)))
          ]),
      AbilityDef(
          name: 'Erosion',
          requirement: DidNotPlayCardAbilityRequirement(cardName: 'Carve'),
          actions: [
            RoveAction(
                    type: RoveActionType.attack,
                    amount: 2,
                    range: (2, 2),
                    staticDescription: RoveActionDescription(
                        prefix:
                            'Can only be activated if Carve was not activated:'))
                .withAugment(ActionAugment(
                    condition: PersonalPoolEtherCondition(ether: Ether.water),
                    action: RoveAction.buff(BuffType.endRange, 2)))
          ]),
    ];
  }

  @override
  List<SkillDef> get skills {
    return [
      SkillDef(
        name: 'Granite Phalanx',
        type: SkillType.rally,
        subtype: 'Circle',
        back: 'Dual Assault',
        actions: [
          RoveAction.buff(BuffType.defense, 1,
              scope: BuffScope.untilStartOfTurn),
          RoveAction(
              type: RoveActionType.buff,
              buffType: BuffType.defense,
              buffScope: BuffScope.untilStartOfTurn,
              amount: 1,
              targetKind: TargetKind.ally,
              range: (1, 1)),
          RoveAction.generateEther()
        ],
      ),
      SkillDef(
        name: 'Dual Assault',
        type: SkillType.rave,
        subtype: 'Circle',
        back: 'Granite Phalanx',
        etherCost: 3,
        actions: [
          RoveAction.meleeAttack(3).withAugment(ActionAugment(
              condition: EtherCheckCondition(ethers: const [Ether.earth]),
              action: RoveAction.buff(BuffType.amount, 1))),
          RoveAction(
                  actor: RoveActionActorKind.ally,
                  actorRange: (1, 2),
                  type: RoveActionType.attack,
                  amount: 3,
                  range: (1, 1))
              .withAugment(ActionAugment(
                  condition: EtherCheckCondition(ethers: const [Ether.earth]),
                  action: RoveAction.buff(BuffType.amount, 1)))
        ],
      ),
      SkillDef(
        name: 'Ice Blast',
        type: SkillType.rave,
        subtype: 'Drop',
        back: 'Crag Smash',
        etherCost: 2,
        actions: [
          RoveAction(
                  type: RoveActionType.attack,
                  amount: 2,
                  range: (2, 3),
                  aoe: AOEDef.x3Triangle(),
                  targetCount: AOEDef.x3Triangle().cubeVectors.length)
              .withEtherCheckAugment(
                  ether: Ether.water,
                  action: RoveAction.buff(BuffType.field, 0,
                      field: EtherField.snapfrost)),
          RoveAction.flip(SubtypeFlipCondition(subtype: 'circle')),
        ],
      ),
      SkillDef(
        name: 'Crag Smash',
        type: SkillType.rave,
        subtype: 'Circle',
        back: 'Ice Blast',
        etherCost: 2,
        actions: [
          RoveAction.meleeAttack(4).withEtherCheckAugment(
              ether: Ether.earth,
              action: RoveAction(
                  type: RoveActionType.suffer,
                  amount: 1,
                  targetCount: 2,
                  rangeOrigin: RoveActionRangeOrigin.previousTarget,
                  range: (1, 1),
                  staticDescription: RoveActionDescription(
                      body:
                          'Two other enemies within [RNG] 1 of the target suffer 1 [DMG]'))),
        ],
      ),
      SkillDef(
        name: 'Suffocating Spray',
        type: SkillType.rave,
        subtype: 'Drop',
        back: 'Calm Rivers',
        etherCost: 3,
        actions: [
          RoveAction(
                  type: RoveActionType.attack,
                  amount: 2,
                  range: (1, 1),
                  targetCount: 3,
                  aoe: AOEDef.x5FrontSpray())
              .withEtherCheckAugment(
                  ether: Ether.water, action: RoveAction.buff(BuffType.push, 1))
        ],
      ),
      SkillDef(
        name: 'Calm Rivers',
        type: SkillType.rally,
        subtype: 'Drop',
        back: 'Suffocating Spray',
        actions: [
          RoveAction(
              type: RoveActionType.heal,
              amount: 1,
              aoe: AOEDef.x3Line(),
              targetCount: 3,
              targetKind: TargetKind.ally,
              range: (1, 1)),
          RoveAction.generateEther()
        ],
      ),
      SkillDef(
        name: 'Dearest Friend',
        type: SkillType.rave,
        subtype: 'Circle',
        back: 'Gift of the Oasis',
        etherCost: 2,
        actions: [
          RoveAction(
              type: RoveActionType.summon,
              object: 'Curious Ardorok',
              range: (1, 1),
              exclusiveGroup: 1),
          RoveAction(
              actor: RoveActionActorKind.named,
              object: 'Curious Ardorok',
              type: RoveActionType.attack,
              amount: 4,
              range: (1, 1),
              push: 1,
              exclusiveGroup: 2)
        ],
      ),
      SkillDef(
        name: 'Gift of the Oasis',
        type: SkillType.rally,
        subtype: 'Drop',
        back: 'Dearest Friend',
        actions: [
          RoveAction.heal(1, endRange: 2, field: EtherField.everbloom),
          RoveAction.generateEther()
        ],
      ),
      SkillDef(
        name: 'Dessiccating Blast',
        type: SkillType.rally,
        subtype: 'Drop',
        back: 'Clay Grasp',
        actions: [
          RoveAction.rangeAttack(1, endRange: 3, field: EtherField.miasma),
          RoveAction.generateEther(ether: Ether.water)
        ],
      ),
      SkillDef(
        name: 'Clay Grasp',
        type: SkillType.rally,
        subtype: 'Circle',
        back: 'Dessiccating Blast',
        actions: [
          RoveAction.meleeAttack(1, field: EtherField.snapfrost),
          RoveAction.generateEther(ether: Ether.earth)
        ],
      ),
      SkillDef(
        id: 'S-015',
        name: 'Desert\'s Gift',
        type: SkillType.rally,
        subtype: 'Circle',
        isUpgrade: true,
        back: 'Deep Freeze',
        actions: [
          RoveAction.placeField(EtherField.aura, range: (0, 2)),
          RoveAction.generateEther(),
          RoveAction.trade(),
        ],
      ),
      SkillDef(
        id: 'S-016',
        name: 'Deep Freeze',
        type: SkillType.rave,
        subtype: 'Drop',
        isUpgrade: true,
        back: 'Desert\'s Gift',
        etherCost: 2,
        actions: [
          RoveAction.rangeAttack(4, endRange: 4, field: EtherField.snapfrost)
              .withAugment(ActionAugment(
                  condition: EtherCheckCondition(ethers: const [Ether.water]),
                  action: RoveAction(
                      type: RoveActionType.placeField,
                      rangeOrigin: RoveActionRangeOrigin.previousTarget,
                      range: (1, 1),
                      field: EtherField.snapfrost)))
        ],
      ),
      SkillDef(
        id: 'S-017',
        name: 'Oasis Reprieve',
        type: SkillType.rally,
        subtype: 'Drop',
        isUpgrade: true,
        back: 'Sand Wedge',
        actions: [
          RoveAction.heal(2, endRange: 4),
          RoveAction.generateEther(),
        ],
      ),
      SkillDef(
        id: 'S-018',
        name: 'Sand Wedge',
        type: SkillType.rave,
        subtype: 'Drop',
        isUpgrade: true,
        back: 'Oasis Reprieve',
        etherCost: 3,
        actions: [
          RoveAction(
                  type: RoveActionType.attack,
                  amount: 3,
                  push: 1,
                  range: (1, 1),
                  aoe: AOEDef.x5Line(),
                  targetCount: 3)
              .withAugment(
            ActionAugment(
                condition: EtherCheckCondition(ethers: const [Ether.earth]),
                action: RoveAction.buff(BuffType.push, 1)),
          )
        ],
      ),
      SkillDef(
        id: 'S-019',
        name: 'Flow of Foes',
        type: SkillType.rave,
        subtype: 'Drop',
        isUpgrade: true,
        back: 'Chill Touch',
        etherCost: 3,
        actions: [
          RoveAction(
                  type: RoveActionType.attack,
                  amount: 2,
                  range: (2, 3),
                  aoe: AOEDef.x7Honeycomb(),
                  targetCount: 3)
              .withAugment(
            ActionAugment(
                condition: EtherCheckCondition(ethers: const [Ether.water]),
                action: RoveAction.buff(BuffType.amount, 1)),
          ),
          RoveAction.flip(SubtypeFlipCondition(subtype: 'Drop')),
        ],
      ),
      SkillDef(
        id: 'S-20',
        name: 'Chill Touch',
        type: SkillType.rally,
        subtype: 'Drop',
        isUpgrade: true,
        back: 'Flow of Foes',
        actions: [
          RoveAction.meleeAttack(2, field: EtherField.miasma),
          RoveAction.generateEther(ether: Ether.water)
        ],
      ),
      SkillDef(
        id: 'S-021',
        name: 'War Beast',
        type: SkillType.rave,
        subtype: 'Circle',
        isUpgrade: true,
        back: 'Revitalizing Clay',
        etherCost: 2,
        actions: [
          RoveAction(
              type: RoveActionType.summon,
              object: 'Pouncing Borejaw',
              range: (1, 1),
              exclusiveGroup: 1),
          RoveAction(
              actor: RoveActionActorKind.named,
              object: 'Pouncing Borejaw',
              type: RoveActionType.jump,
              amount: 3,
              exclusiveGroup: 2),
          RoveAction(
              actor: RoveActionActorKind.named,
              object: 'Pouncing Borejaw',
              type: RoveActionType.attack,
              amount: 3,
              range: (1, 1),
              field: EtherField.snapfrost,
              exclusiveGroup: 2),
          RoveAction.flip(SubtypeFlipCondition(subtype: 'circle'))
        ],
      ),
      SkillDef(
        id: 'S-022',
        name: 'Revitalizing Clay',
        type: SkillType.rally,
        subtype: 'Circle',
        isUpgrade: true,
        back: 'War Beast',
        actions: [
          RoveAction(
              type: RoveActionType.placeField,
              field: EtherField.everbloom,
              range: (0, 2),
              targetCount: 2),
          RoveAction(
              type: RoveActionType.triggerFields,
              field: EtherField.everbloom,
              range: (0, 2),
              requiresPrevious: true),
          RoveAction.generateEther(ether: Ether.earth)
        ],
      ),
    ];
  }

  @override
  List<ReactionDef> get reactions {
    return [
      ReactionDef(
          name: 'Rallying Cry',
          subtype: 'Circle',
          back: 'Quickening Sand',
          trigger: ReactionTriggerDef(
              type: RoveEventType.afterAttack,
              actorKind: TargetKind.ally,
              range: (1, 2)),
          actions: [
            RoveAction(
                type: RoveActionType.placeField,
                field: EtherField.aura,
                targetKind: TargetKind.selfOrAlly,
                targetMode: RoveActionTargetMode.eventActor),
            RoveAction.generateEther(),
          ]),
      ReactionDef(
          name: 'Quickening Sand',
          subtype: 'Drop',
          back: 'Rallying Cry',
          trigger: ReactionTriggerDef(
              type: RoveEventType.afterAttack,
              actorKind: TargetKind.ally,
              range: (1, 2)),
          actions: [
            RoveAction(
                    actor: RoveActionActorKind.eventActor,
                    type: RoveActionType.move,
                    amount: 2)
                .withEtherPoolAugment(
                    ether: Ether.earth,
                    action: RoveAction.buff(BuffType.amount, 2))
          ]),
      ReactionDef(
          name: 'Earthen Shield',
          subtype: 'Circle',
          back: 'Healing Surge',
          trigger: ReactionTriggerDef(
              type: RoveEventType.beforeAttack,
              targetKind: TargetKind.selfOrAlly,
              range: (0, 2)),
          actions: [
            RoveAction(
                type: RoveActionType.buff,
                buffType: BuffType.defense,
                targetKind: TargetKind.selfOrAlly,
                targetMode: RoveActionTargetMode.eventTarget,
                amount: 1),
            RoveAction.generateEther(ether: Ether.earth)
          ]),
      ReactionDef(
          name: 'Healing Surge',
          subtype: 'Drop',
          back: 'Earthen Shield',
          trigger: ReactionTriggerDef(
              type: RoveEventType.beforeAttack,
              targetKind: TargetKind.selfOrAlly,
              range: (0, 2)),
          actions: [
            RoveAction(
              type: RoveActionType.heal,
              amount: 1,
              targetKind: TargetKind.selfOrAlly,
              targetMode: RoveActionTargetMode.eventTarget,
            ).withEtherPoolAugment(
                ether: Ether.water, action: RoveAction.buff(BuffType.amount, 2))
          ]),
      ReactionDef(
          id: 'S-023',
          name: 'Camaraderie',
          subtype: 'Circle',
          isUpgrade: true,
          back: 'Enchant Body',
          trigger: ReactionTriggerDef(
              type: RoveEventType.startTurn,
              actorKind: TargetKind.ally,
              range: (1, 1)),
          actions: [
            RoveAction(
              type: RoveActionType.buff,
              buffType: BuffType.defense,
              buffScope: BuffScope.untilStartOfTurn,
              amount: 1,
              targetKind: TargetKind.selfOrEventActor,
              range: RoveAction.anyRange,
            ).withEtherPoolAugment(
                ether: Ether.earth,
                action: RoveAction(
                    type: RoveActionType.buff,
                    buffType: BuffType.defense,
                    buffScope: BuffScope.untilStartOfTurn,
                    amount: 1,
                    targetKind: TargetKind.selfOrEventActor,
                    targetMode: RoveActionTargetMode.all,
                    staticDescription: RoveActionDescription(
                        body: '[target] self and that ally instead.')),
                isReplacement: true),
          ]),
      ReactionDef(
          id: 'S-024',
          name: 'Enchant Body',
          subtype: 'Drop',
          isUpgrade: true,
          back: 'Camaraderie',
          trigger: ReactionTriggerDef(
              type: RoveEventType.startTurn,
              actorKind: TargetKind.ally,
              range: (1, 1)),
          actions: [
            RoveAction(
                type: RoveActionType.heal,
                amount: 1,
                targetKind: TargetKind.selfOrEventActor,
                targetMode: RoveActionTargetMode.all)
          ]),
    ];
  }
}
