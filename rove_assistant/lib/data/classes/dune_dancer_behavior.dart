import 'package:rove_data_types/rove_data_types.dart';
import 'rover_class_behavior.dart';

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
      AbilityDef(
        id: 'C-001',
        name: 'Stride',
        actions: [
          RoveAction.move(3).withAugment(ActionAugment(
              condition: PersonalPoolEtherCondition(ether: Ether.earth),
              action: RoveAction.buff(BuffType.ignoreTerrainEffects, 0))),
        ],
      ),
      AbilityDef(
        id: 'C-002',
        name: 'Barter',
        actions: [
          RoveAction.trade(),
        ],
      ),
      AbilityDef(
        id: 'C-003',
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
        ],
      ),
      AbilityDef(
          id: 'C-004',
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
        id: 'S-001',
        name: 'Clay Grasp',
        type: SkillType.rally,
        subtype: 'striker',
        back: 'Desiccating Blast',
        actions: [
          RoveAction.meleeAttack(1, field: EtherField.snapfrost),
          RoveAction.generateEther(ether: Ether.earth)
        ],
      ),
      SkillDef(
        id: 'S-002',
        name: 'Desiccating Blast',
        type: SkillType.rally,
        subtype: 'caller',
        back: 'Clay Grasp',
        actions: [
          RoveAction.rangeAttack(1, endRange: 3, field: EtherField.miasma),
          RoveAction.generateEther(ether: Ether.water)
        ],
      ),
      SkillDef(
        id: 'S-003',
        name: 'Gift of the Oasis',
        type: SkillType.rally,
        subtype: 'caller',
        back: 'Dearest Friend',
        actions: [
          RoveAction.heal(1, endRange: 2, field: EtherField.everbloom),
          RoveAction.generateEther()
        ],
      ),
      SkillDef(
        id: 'S-004',
        name: 'Dearest Friend',
        type: SkillType.rave,
        subtype: 'striker',
        back: 'Gift of the Oasis',
        etherCost: 2,
        actions: [
          RoveAction(
                  type: RoveActionType.summon,
                  object: 'Curious Ardorok',
                  range: (1, 1),
                  exclusiveGroup: 1)
              .withDescription('Summon one Curious Ardorok.'),
          RoveAction(
                  actor: RoveActionActorKind.named,
                  object: 'Curious Ardorok',
                  type: RoveActionType.attack,
                  amount: 4,
                  range: (1, 1),
                  push: 1,
                  exclusiveGroup: 2)
              .withPrefix('Your Curious Ardorok performs:'),
        ],
      ),
      SkillDef(
        id: 'S-005',
        name: 'Calm Rivers',
        type: SkillType.rally,
        subtype: 'caller',
        back: 'Suffocating Spray',
        actions: [
          RoveAction(
              type: RoveActionType.heal,
              amount: 1,
              aoe: AOEDef.x3Line(),
              targetCount: RoveAction.allTargets,
              targetKind: TargetKind.ally,
              range: (1, 1)),
          RoveAction.generateEther()
        ],
      ),
      SkillDef(
        id: 'S-006',
        name: 'Suffocating Spray',
        type: SkillType.rave,
        subtype: 'caller',
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
        id: 'S-007',
        name: 'Crag Smash',
        type: SkillType.rave,
        subtype: 'striker',
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
                  range: (
                    1,
                    1
                  )).withDescription(
                  'Two other enemies within [range] 1 of the target suffer [DMG] 1.')),
          RoveAction.flip(SubtypeFlipCondition(subtype: 'caller')),
        ],
      ),
      SkillDef(
        id: 'S-008',
        name: 'Ice Blast',
        type: SkillType.rave,
        subtype: 'caller',
        back: 'Crag Smash',
        etherCost: 2,
        actions: [
          RoveAction(
                  type: RoveActionType.attack,
                  amount: 2,
                  range: (2, 3),
                  aoe: AOEDef.x3Triangle(),
                  targetCount: RoveAction.allTargets)
              .withEtherCheckAugment(
                  ether: Ether.water,
                  action: RoveAction.buff(BuffType.field, 0,
                      field: EtherField.snapfrost)),
          RoveAction.flip(SubtypeFlipCondition(subtype: 'striker')),
        ],
      ),
      SkillDef(
        id: 'S-009',
        name: 'Granite Phalanx',
        type: SkillType.rally,
        subtype: 'striker',
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
          RoveAction.generateEther(requiresPrevious: false)
        ],
      ),
      SkillDef(
        id: 'S-010',
        name: 'Dual Assault',
        type: SkillType.rave,
        subtype: 'striker',
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
              .withPrefix('One ally within [range] 1-2 performs:')
              .withAugment(ActionAugment(
                  condition: EtherCheckCondition(ethers: const [Ether.earth]),
                  action: RoveAction.buff(BuffType.amount, 1)))
        ],
      ),
      SkillDef(
        id: 'S-015',
        name: 'Desert\'s Gift',
        type: SkillType.rally,
        subtype: 'striker',
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
        subtype: 'caller',
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
                          field: EtherField.snapfrost)
                      .withDescription(
                          'Place one [snapfrost] within [range] 1 of the attacked target.'))),
        ],
      ),
      SkillDef(
        id: 'S-017',
        name: 'Oasis Reprieve',
        type: SkillType.rally,
        subtype: 'caller',
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
        subtype: 'caller',
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
        subtype: 'caller',
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
          RoveAction.flip(SubtypeFlipCondition(subtype: 'caller')),
        ],
      ),
      SkillDef(
        id: 'S-020',
        name: 'Chill Touch',
        type: SkillType.rally,
        subtype: 'caller',
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
        subtype: 'striker',
        isUpgrade: true,
        back: 'Revitalizing Clay',
        etherCost: 2,
        actions: [
          RoveAction(
                  type: RoveActionType.summon,
                  object: 'Pouncing Borejaw',
                  range: (1, 1),
                  exclusiveGroup: 1)
              .withDescription('Summon one Pouncing Borejaw.'),
          RoveAction(
                  actor: RoveActionActorKind.named,
                  object: 'Pouncing Borejaw',
                  type: RoveActionType.jump,
                  amount: 3,
                  exclusiveGroup: 2)
              .withPrefix('Your Pouncing Borejaw performs:'),
          RoveAction(
                  actor: RoveActionActorKind.named,
                  object: 'Pouncing Borejaw',
                  type: RoveActionType.attack,
                  amount: 3,
                  range: (1, 1),
                  field: EtherField.snapfrost,
                  exclusiveGroup: 2)
              .withoutPrefix(),
          RoveAction.flip(SubtypeFlipCondition(subtype: 'striker'))
        ],
      ),
      SkillDef(
        id: 'S-022',
        name: 'Revitalizing Clay',
        type: SkillType.rally,
        subtype: 'striker',
        isUpgrade: true,
        back: 'War Beast',
        actions: [
          RoveAction(
              type: RoveActionType.placeField,
              field: EtherField.everbloom,
              targetKind: TargetKind.selfOrAlly,
              range: (0, 2),
              targetCount: 2),
          RoveAction(
                  type: RoveActionType.triggerFields,
                  field: EtherField.everbloom,
                  range: (0, 2),
                  requiresPrevious: true)
              .withDescription(
                  'Trigger the effects of any number of [everbloom] within [range] 0-2.'),
          RoveAction.generateEther(ether: Ether.earth)
        ],
      ),
    ];
  }

  @override
  List<ReactionDef> get reactions {
    return [
      ReactionDef(
          id: 'S-011',
          name: 'Rallying Cry',
          subtype: 'striker',
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
                    targetMode: RoveActionTargetMode.eventActor)
                .withTargetDescription('the ally that attacked'),
            RoveAction.generateEther(),
          ]),
      ReactionDef(
          id: 'S-012',
          name: 'Quickening Sand',
          subtype: 'caller',
          back: 'Rallying Cry',
          trigger: ReactionTriggerDef(
              type: RoveEventType.afterAttack,
              actorKind: TargetKind.ally,
              range: (1, 2)),
          actions: [
            RoveAction(
                    actor: RoveActionActorKind.eventActor,
                    type: RoveActionType.dash,
                    amount: 2)
                .withoutPrefix()
                .withDescription('That ally may perform [dash] 2.')
                .withEtherPoolAugment(
                    ether: Ether.earth,
                    action: RoveAction.buff(BuffType.amount, 2))
          ]),
      ReactionDef(
          id: 'S-013',
          name: 'Earthen Shield',
          subtype: 'striker',
          back: 'Healing Surge',
          trigger: ReactionTriggerDef(
            type: RoveEventType.beforeAttack,
            targetKind: TargetKind.selfOrAlly,
            range: (0, 2),
            staticDescription:
                'Before you or an ally within [range] 1-2 are attacked:',
          ),
          actions: [
            RoveAction(
                    type: RoveActionType.buff,
                    buffType: BuffType.defense,
                    targetKind: TargetKind.selfOrAlly,
                    targetMode: RoveActionTargetMode.eventTarget,
                    amount: 1)
                .withDescription('That unit gains +1 [def] for that attack.'),
            RoveAction.generateEther(ether: Ether.earth)
          ]),
      ReactionDef(
          id: 'S-014',
          name: 'Healing Surge',
          subtype: 'caller',
          back: 'Earthen Shield',
          trigger: ReactionTriggerDef(
            type: RoveEventType.beforeAttack,
            targetKind: TargetKind.selfOrAlly,
            range: (0, 2),
            staticDescription:
                'Before you or an ally within [range] 1-2 are attacked:',
          ),
          actions: [
            RoveAction(
              type: RoveActionType.heal,
              amount: 1,
              targetKind: TargetKind.selfOrAlly,
              targetMode: RoveActionTargetMode.eventTarget,
            ).withTargetDescription('that unit').withEtherPoolAugment(
                ether: Ether.water, action: RoveAction.buff(BuffType.amount, 1))
          ]),
      ReactionDef(
          id: 'S-023',
          name: 'Camaraderie',
          subtype: 'striker',
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
                ).withDescription('[target] self and that ally instead.'),
                isReplacement: true),
          ]),
      ReactionDef(
          id: 'S-024',
          name: 'Enchant Body',
          subtype: 'caller',
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
                    range: RoveAction.anyRange,
                    targetKind: TargetKind.selfOrEventActor,
                    targetMode: RoveActionTargetMode.all)
                .withTargetDescription('self and that ally'),
            RoveAction.generateEther(ether: Ether.water)
          ]),
    ];
  }
}
