import 'package:rove_data_types/rove_data_types.dart';
import 'rover_class_behavior.dart';

class FlashBehavior extends RoverClassBehavior {
  @override
  FieldEffect get auraEffect {
    return FieldEffect(
        buff: RoveBuff(amount: 1, type: BuffType.attack),
        action: RoveAction.generateEther(requiresPrevious: false));
  }

  @override
  FieldEffect get miasmaEffect {
    return FieldEffect(
        buff: null,
        action: RoveAction(
            type: RoveActionType.suffer,
            amount: 2,
            targetKind: TargetKind.self));
  }

  @override
  List<AbilityDef> get abilities {
    return [
      AbilityDef(
        id: 'C-016',
        name: 'Sear',
        actions: [
          RoveAction.meleeAttack(2, endRange: 2).withAugment(ActionAugment(
              condition: PersonalPoolEtherCondition(ether: Ether.fire),
              action: RoveAction.buff(BuffType.pierce, 0))),
        ],
      ),
      AbilityDef(
        id: 'C-013',
        name: 'Glide',
        actions: [
          RoveAction.move(3).withAugment(ActionAugment(
              condition: PersonalPoolEtherCondition(ether: Ether.crux),
              action: RoveAction.teleport(3)
                  .withDescription('Perform [teleport] 3 instead.'),
              isReplacement: true)),
        ],
      ),
      AbilityDef(
        id: 'C-014',
        name: 'Channel',
        actions: [
          RoveAction.infuseEther(),
          RoveAction.generateEther(),
        ],
      ),
      AbilityDef(
        id: 'C-015',
        name: 'Gale',
        actions: [
          RoveAction.rangeAttack(1, endRange: 3, push: 1).withAugment(
              ActionAugment(
                  condition: PersonalPoolEtherCondition(ether: Ether.wind),
                  action: RoveAction.buff(BuffType.push, 1))),
        ],
      ),
    ];
  }

  @override
  List<SkillDef> get skills {
    return [
      SkillDef(
          id: 'S-053',
          name: 'Suffuse',
          type: SkillType.rally,
          subtype: 'Blaze',
          back: 'Swell',
          actions: [
            RoveAction.heal(1, endRange: 3).withAugments([
              ActionAugment(
                  condition: PersonalPoolNonDimCondition(),
                  action: RoveAction.buff(BuffType.amount, 1)),
              ActionAugment(
                  condition: PersonalPoolNonDimCondition(),
                  action: RoveAction.buff(BuffType.field, 0,
                      field: EtherField.aura))
            ]),
          ]),
      SkillDef(
          id: 'S-054',
          name: 'Swell',
          type: SkillType.rave,
          subtype: 'Billow',
          back: 'Suffuse',
          actions: [
            RoveAction.createTrap(3, endRange: 3).withDescription(
                'Create one [dmg] 3 trap in an empty space within [range] 1-3.'),
          ],
          etherCost: 1),
      SkillDef(
          id: 'S-055',
          name: 'Alar',
          type: SkillType.rally,
          subtype: 'Blaze',
          back: 'Bolt',
          actions: [
            RoveAction.jump(4),
            RoveAction.generateEther(),
          ]),
      SkillDef(
          id: 'S-056',
          name: 'Bolt',
          type: SkillType.rave,
          subtype: 'Billow',
          back: 'Alar',
          actions: [
            RoveAction.rangeAttack(3, endRange: 4, field: EtherField.miasma)
                .withAugments([
              ActionAugment(
                  condition: EtherCheckCondition(ethers: const [Ether.wind]),
                  action: RoveAction.buff(BuffType.push, 2)),
              ActionAugment(
                  condition: EtherCheckCondition(ethers: const [Ether.crux]),
                  action: RoveAction.buff(BuffType.rangeAttackEndRange, 2))
            ]),
          ],
          etherCost: 2),
      SkillDef(
          id: 'S-057',
          name: 'Transcend',
          type: SkillType.rally,
          subtype: 'Billow',
          back: 'Blast',
          actions: [
            RoveAction.infuseEther(),
            RoveAction.generateEther(requiresPrevious: false),
            RoveAction.generateEther(requiresPrevious: false)
          ]),
      SkillDef(
          id: 'S-058',
          name: 'Blast',
          type: SkillType.rave,
          subtype: 'Blaze',
          back: 'Transcend',
          actions: [
            RoveAction.rangeAttack(4, endRange: 3, field: EtherField.wildfire)
                .withAugments([
              ActionAugment(
                  condition: EtherCheckCondition(ethers: const [Ether.fire]),
                  action: RoveAction.buff(BuffType.pierce, 0)),
              ActionAugment(
                  condition: EtherCheckCondition(ethers: const [Ether.crux]),
                  action: RoveAction.buff(BuffType.amount, 1))
            ])
          ],
          etherCost: 2),
      SkillDef(
          id: 'S-059',
          name: 'Tempest',
          type: SkillType.rave,
          subtype: 'Blaze',
          back: 'Eruption',
          actions: [
            RoveAction(
                    type: RoveActionType.attack,
                    amount: 3,
                    range: (2, 4),
                    aoe: AOEDef.x7Honeycomb(),
                    targetCount: 3,
                    push: 2)
                .withAugment(ActionAugment(
                    condition: EtherCheckCondition(
                        ethers: const [Ether.fire, Ether.fire]),
                    action: RoveAction(
                            type: RoveActionType.special,
                            object: 'Tempest Augment')
                        .withDescription(
                            'The attack targeting the unit occupying the center hex gains +2 [DMG].'))),
            RoveAction.flip(AllRaveFlipCondition())
          ],
          etherCost: 4),
      SkillDef(
          id: 'S-060',
          name: 'Eruption',
          type: SkillType.rave,
          subtype: 'Blaze',
          back: 'Tempest',
          actions: [
            RoveAction(
                    type: RoveActionType.attack,
                    amount: 6,
                    range: (2, 6),
                    field: EtherField.wildfire)
                .withAugment(ActionAugment(
                    condition: EtherCheckCondition(
                        ethers: const [Ether.wind, Ether.wind]),
                    action: RoveAction(
                      type: RoveActionType.suffer,
                      amount: 2,
                      rangeOrigin: RoveActionRangeOrigin.previousTarget,
                      range: (1, 2),
                      targetCount: 2,
                    ).withDescription(
                        'Two other enemies within [range] 1-2 of the attacked target suffer [dmg] 2.'))),
            RoveAction.flip(AllRaveFlipCondition())
          ],
          etherCost: 4),
      SkillDef(
          id: 'S-061',
          name: 'Charge',
          type: SkillType.rally,
          subtype: 'Billow',
          back: 'Kindle',
          actions: [
            RoveAction.placeField(EtherField.windscreen, range: (0, 3)),
            RoveAction.generateEther(ether: Ether.wind)
          ]),
      SkillDef(
          id: 'S-062',
          name: 'Kindle',
          type: SkillType.rally,
          subtype: 'Blaze',
          back: 'Charge',
          actions: [
            RoveAction(type: RoveActionType.suffer, amount: 1, range: (1, 3))
                .withDescription(
                    'One enemy within [range] 1-3 suffers [dmg] 1.'),
            RoveAction.generateEther(ether: Ether.fire)
          ]),
      SkillDef(
          id: 'S-067',
          name: 'Singe',
          type: SkillType.rally,
          subtype: 'Blaze',
          isUpgrade: true,
          back: 'Vacuum',
          actions: [
            RoveAction.meleeAttack(2, endRange: 3),
            RoveAction.generateEther()
          ]),
      SkillDef(
          id: 'S-068',
          name: 'Vacuum',
          type: SkillType.rave,
          subtype: 'Billow',
          isUpgrade: true,
          back: 'Singe',
          etherCost: 2,
          actions: [
            RoveAction(
                    type: RoveActionType.attack,
                    amount: 2,
                    range: (1, 3),
                    targetCount: 3,
                    pull: 2,
                    rangeOrigin: RoveActionRangeOrigin.range4)
                .withPrefix('Select one space within [range] 1-4 to perform:')
                .withTargetDescription(
                    '3 enemies within [range] 1-3 of the selected space')
                .withSuffix('Pull all targets toward the selected space.')
                .withEtherCheckAugment(
                    ether: Ether.wind,
                    action: RoveAction.buff(BuffType.targetCount, 1))
                .withEtherCheckAugment(
                    ether: Ether.crux,
                    action: RoveAction.buff(BuffType.amount, 1)),
          ]),
      SkillDef(
          id: 'S-069',
          name: 'Buffet',
          type: SkillType.rally,
          subtype: 'Billow',
          isUpgrade: true,
          back: 'Flare',
          actions: [
            RoveAction(
                type: RoveActionType.push,
                range: (1, 3),
                amount: 1,
                field: EtherField.miasma),
            RoveAction.generateEther()
          ]),
      SkillDef(
          id: 'S-070',
          name: 'Flare',
          type: SkillType.rally,
          subtype: 'Billow',
          isUpgrade: true,
          back: 'Buffet',
          etherCost: 3,
          actions: [
            RoveAction(type: RoveActionType.attack, range: (3, 4), amount: 5)
                .withEtherCheckAugment(
                    ether: Ether.fire,
                    action: RoveAction.buff(BuffType.field, 0,
                        field: EtherField.wildfire))
                .withEtherCheckAugment(
                    ether: Ether.wind,
                    action: RoveAction.buff(BuffType.push, 2)),
          ]),
      SkillDef(
          id: 'S-071',
          name: 'Mistral',
          type: SkillType.rally,
          subtype: 'Billow',
          isUpgrade: true,
          back: 'Zephyr',
          actions: [
            RoveAction.createTrap(2, endRange: 3).withDescription(
                'Create one [dmg] 2 trap in an empty space within [range] 1-3.'),
            RoveAction.generateEther(ether: Ether.wind)
          ]),
      SkillDef(
          id: 'S-072',
          name: 'Zephyr',
          type: SkillType.rave,
          subtype: 'Billow',
          isUpgrade: true,
          etherCost: 3,
          back: 'Mistral',
          actions: [
            RoveAction.buff(BuffType.trapDamage, 2).withHidden(),
            RoveAction.rangeAttack(4, endRange: 4, push: 2)
                .withAugment(ActionAugment(
                    condition: EtherCheckCondition(
                        ethers: const [Ether.wind, Ether.wind]),
                    action: RoveAction.buff(BuffType.push, 2)))
                .withSuffix(
                    'The first trap triggered with this action deals +2 [DMG].'),
            RoveAction.flip(AllRaveFlipCondition()),
          ]),
      SkillDef(
          id: 'S-073',
          name: 'Scorch',
          type: SkillType.rally,
          subtype: 'Blaze',
          isUpgrade: true,
          back: 'Helion',
          actions: [
            RoveAction.placeField(EtherField.wildfire, range: (0, 3)),
            RoveAction.generateEther(ether: Ether.fire)
          ]),
      SkillDef(
          id: 'S-074',
          name: 'Helion',
          type: SkillType.rave,
          subtype: 'Blaze',
          isUpgrade: true,
          back: 'Scorch',
          etherCost: 3,
          actions: [
            RoveAction.meleeAttack(5, endRange: 3)
                .withAugment(ActionAugment(
                    condition: EtherCheckCondition(
                        ethers: const [Ether.fire, Ether.fire]),
                    action: RoveAction.buff(BuffType.amount, 2),
                    exclusive: true))
                .withAugment(ActionAugment(
                    condition: SufferDamageCondition(),
                    action: RoveAction.buff(BuffType.amount, 2),
                    exclusive: true)),
            RoveAction.flip(AllRaveFlipCondition()),
          ]),
      SkillDef(
          id: 'S-075',
          name: 'Link',
          type: SkillType.rally,
          subtype: 'Billow',
          isUpgrade: true,
          back: 'Galvanize',
          actions: [
            RoveAction(
                type: RoveActionType.attack,
                amount: 1,
                range: (1, 1),
                aoe: AOEDef.x4Line(),
                pierce: true,
                targetCount: RoveAction.allTargets),
            RoveAction.generateEther()
          ]),
      SkillDef(
          id: 'S-076',
          name: 'Galvanize',
          type: SkillType.rally,
          subtype: 'Blaze',
          isUpgrade: true,
          back: 'Link',
          actions: [
            RoveAction.infuseEther(),
            RoveAction.generateEther(),
            RoveAction.placeField(EtherField.aura, range: (0, 0))
          ]),
    ];
  }

  @override
  List<ReactionDef> get reactions {
    return [
      ReactionDef(
          id: 'S-063',
          name: 'Pulse',
          subtype: 'Billow',
          back: 'Smolder',
          trigger: ReactionTriggerDef(
            type: RoveEventType.afterAttack,
            targetKind: TargetKind.self,
            staticDescription: 'After you are attacked:',
          ),
          actions: [
            RoveAction.teleport(3),
            RoveAction.generateEther(ether: Ether.crux),
          ]),
      ReactionDef(
          id: 'S-064',
          name: 'Smolder',
          subtype: 'Blaze',
          back: 'Dot',
          trigger: ReactionTriggerDef(
            type: RoveEventType.afterAttack,
            targetKind: TargetKind.self,
            staticDescription: 'After you are attacked:',
          ),
          actions: [
            RoveAction(
                    type: RoveActionType.suffer,
                    amount: 1,
                    targetMode: RoveActionTargetMode.eventActor)
                .withDescription('The attacker suffers [dmg] 1.')
                .withAugment(ActionAugment(
                    condition: PersonalPoolEtherCondition(ether: Ether.fire),
                    action: RoveAction.buff(BuffType.amount, 1))),
          ]),
      ReactionDef(
          id: 'S-065',
          name: 'Attract',
          subtype: 'Billow',
          back: 'Stoke',
          trigger: ReactionTriggerDef(
            type: RoveEventType.generatedEther,
            actorKind: TargetKind.ally,
            range: (1, 3),
            staticDescription:
                'When another Rover within [range] 1-3 generates an ether dice:',
          ),
          actions: [
            RoveAction.generateEther(),
            RoveAction(type: RoveActionType.rerollEther, requiresPrevious: true)
                .withDescription('You may reroll this dice.'),
          ]),
      ReactionDef(
          id: 'S-066',
          name: 'Stoke',
          subtype: 'Blaze',
          back: 'Attract',
          trigger: ReactionTriggerDef(
            type: RoveEventType.generatedEther,
            actorKind: TargetKind.ally,
            range: (1, 3),
            staticDescription:
                'When another Rover within [range] 1-3 generates an ether dice:',
          ),
          actions: [
            RoveAction(
                    type: RoveActionType.heal,
                    targetKind: TargetKind.ally,
                    amount: 1,
                    targetMode: RoveActionTargetMode.eventActor)
                .withTargetDescription('that Rover'),
            RoveAction(
                    type: RoveActionType.trade,
                    targetMode: RoveActionTargetMode.eventActor,
                    requiresPrevious: true)
                .withDescription('[trade] with that Rover.')
          ]),
    ];
  }
}
