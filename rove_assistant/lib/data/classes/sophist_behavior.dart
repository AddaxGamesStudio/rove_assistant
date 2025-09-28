import 'package:rove_data_types/rove_data_types.dart';
import 'rover_class_behavior.dart';

class SophistBehavior extends RoverClassBehavior {
  @override
  FieldEffect get auraEffect {
    return FieldEffect(
        buff: RoveBuff(amount: 2, type: BuffType.attack), action: null);
  }

  @override
  FieldEffect get miasmaEffect {
    return FieldEffect.empty();
  }

  @override
  List<AbilityDef> get abilities {
    return [
      AbilityDef(
        id: 'C-037',
        name: 'Vault',
        actions: [
          RoveAction.jump(3),
        ],
      ),
      AbilityDef(
        id: 'C-038',
        name: 'Inspire',
        actions: [
          RoveAction(
            actor: RoveActionActorKind.allyOrGlyph,
            type: RoveActionType.dash,
            amount: 3,
          ).withDescription(
              'One ally or glyph within [range] 0-3 may perform [dash] 3.'),
        ],
      ),
      AbilityDef(
        id: 'C-039',
        name: 'Beset',
        actions: [
          RoveAction.meleeAttack(1, endRange: 2),
        ],
      ),
      AbilityDef(
        id: 'C-040',
        name: 'Manifest',
        actions: [
          RoveAction.createGlyph(RoveGlyph.hyperbola)
              .withDescription('Create one Luminiscent Hyperbola.'),
        ],
      ),
    ];
  }

  @override
  List<SkillDef> get skills {
    return [
      SkillDef(
          id: 'S-157',
          name: 'Blustery Rebuke',
          type: SkillType.rally,
          subtype: 'warden',
          back: 'Echo Chamber',
          actions: [
            RoveAction(type: RoveActionType.push, amount: 2, range: (1, 2)),
            RoveAction.generateEther()
          ]),
      SkillDef(
        id: 'S-158',
        name: 'Echo Chamber',
        type: SkillType.rave,
        subtype: 'warden',
        back: 'Blustery Rebuke',
        etherCost: 3,
        actions: [
          RoveAction.group([
            RoveAction.meleeAttack(3, endRange: 2),
            RoveAction.meleeAttack(3,
                actor: RoveActionActorKind.glyph, endRange: 2),
          ]).withPrefix('You and one of your glyphs perform:').withAugment(
              ActionAugment(
                  condition: EtherCheckCondition(ethers: const [Ether.wind]),
                  action: RoveAction.buff(BuffType.endRange, 2)))
        ],
      ),
      SkillDef(
          id: 'S-159',
          name: 'Moment\'s Respite',
          type: SkillType.rally,
          subtype: 'trickster',
          back: 'Dazzling Strike',
          actions: [
            RoveAction(
                    actor: RoveActionActorKind.selfOrGlyph,
                    type: RoveActionType.placeField,
                    field: EtherField.aura,
                    range: (0, 1))
                .withAugment(ActionAugment(
                    condition: PersonalPoolEtherCondition(ether: Ether.crux),
                    action: RoveAction(
                        type: RoveActionType.buff,
                        buffType: BuffType.endRange,
                        amount: 2))),
            RoveAction.generateEther()
          ]),
      SkillDef(
          id: 'S-160',
          name: 'Dazzling Strike',
          type: SkillType.rave,
          subtype: 'warden',
          back: 'Moment\'s Respite',
          etherCost: 2,
          actions: [
            RoveAction.meleeAttack(3, endRange: 3).withAugment(ActionAugment(
                condition: EtherCheckCondition(ethers: const [Ether.crux]),
                action: RoveAction.buff(BuffType.field, 0,
                    field: EtherField.snapfrost)))
          ]),
      SkillDef(
        id: 'S-161',
        name: 'Shifts in the Wind',
        type: SkillType.rally,
        subtype: 'warden',
        back: 'Trick of the Light',
        actions: [
          RoveAction.placeField(EtherField.windscreen, range: (0, 3)),
          RoveAction.generateEther(ether: Ether.wind)
        ],
      ),
      SkillDef(
          id: 'S-162',
          name: 'Trick of the Light',
          type: SkillType.rave,
          subtype: 'trickster',
          back: 'Shifts in the Wind',
          etherCost: 2,
          actions: [
            RoveAction(
                    type: RoveActionType.swapSpace,
                    targetKind: TargetKind.glyph,
                    range: RoveAction.anyRange)
                .withDescription('You and one of your glyphs swap spaces.'),
            RoveAction(
                    actor: RoveActionActorKind.previousTarget,
                    type: RoveActionType.attack,
                    amount: 3,
                    range: (1, 2),
                    requiresPrevious: true,
                    staticDescription:
                        RoveActionDescription(prefix: 'That glyph performs:'))
                .withAugment(ActionAugment(
                    condition: EtherCheckCondition(ethers: const [Ether.wind]),
                    action: RoveAction(
                        type: RoveActionType.buff,
                        buffType: BuffType.push,
                        amount: 2))),
            RoveAction.flip(AnyFlipCondition())
          ]),
      SkillDef(
          id: 'S-163',
          name: 'Bask in the Light',
          type: SkillType.rally,
          subtype: 'trickster',
          back: 'Dance of Fronds',
          actions: [
            RoveAction(
                actor: RoveActionActorKind.selfOrGlyph,
                type: RoveActionType.heal,
                amount: 2,
                targetKind: TargetKind.selfOrAlly,
                range: (0, 2)),
            RoveAction.generateEther(ether: Ether.crux)
                .withPrefix('You or one of your glyphs perform:')
          ]),
      SkillDef(
          id: 'S-164',
          name: 'Dance of Fronds',
          type: SkillType.rally,
          subtype: 'warden',
          back: 'Bask in the Light',
          actions: [
            RoveAction.move(3),
            RoveAction(
                    actor: RoveActionActorKind.glyph,
                    type: RoveActionType.dash,
                    amount: 3)
                .withPrefix('One of your glyphs performs:'),
            RoveAction.generateEther(),
          ]),
      SkillDef(
          id: 'S-165',
          name: 'Unnatural Defenses',
          type: SkillType.rave,
          subtype: 'warden',
          back: 'Lustrous Flare',
          etherCost: 1,
          actions: [
            RoveAction(
                    type: RoveActionType.createGlyph,
                    object: RoveGlyph.armoroll.name,
                    range: (0, 1),
                    exclusiveGroup: 1)
                .withDescription('Create one Alluring Armoroll.'),
            RoveAction(
                    type: RoveActionType.buff,
                    buffType: BuffType.defense,
                    amount: 1,
                    buffScope: BuffScope.untilStartOfTurn,
                    rangeOrigin: RoveActionRangeOrigin.armoroll,
                    object: RoveGlyph.armoroll.name,
                    range: (0, 0),
                    targetKind: TargetKind.selfOrAlly,
                    exclusiveGroup: 2)
                .withTargetDescription(
                    'The unit occupying the Alluring Armoroll\'s space.'),
            RoveAction.flip(AnyFlipCondition()),
          ]),
      SkillDef(
          id: 'S-166',
          name: 'Lustrous Flare',
          type: SkillType.rave,
          subtype: 'trickster',
          back: 'Unnatural Defenses',
          etherCost: 3,
          actions: [
            RoveAction(
                    actor: RoveActionActorKind.selfOrGlyph,
                    type: RoveActionType.attack,
                    amount: 4,
                    range: (2, 3),
                    pierce: true)
                .withPrefix('You or one of your glyphs perform:'),
            RoveAction(
                    type: RoveActionType.suffer,
                    amount: 1,
                    rangeOrigin: RoveActionRangeOrigin.previousTarget,
                    targetCount: 2,
                    range: (1, 2),
                    requiresPrevious: true)
                .withDescription(
                    'Two other enemies within [range] 1-2 of the attacked target suffer [dmg] 1.')
                .withAugment(ActionAugment(
                    condition: EtherCheckCondition(ethers: const [Ether.crux]),
                    action: RoveAction.buff(BuffType.amount, 1))),
            RoveAction.flip(AnyFlipCondition()),
          ]),
      SkillDef(
          id: 'S-171',
          name: 'Ready in Mind',
          type: SkillType.rally,
          subtype: 'warden',
          back: 'Bitter Realization',
          isUpgrade: true,
          actions: [
            RoveAction.group([
              RoveAction.flip(AnySkillFlipCondition()),
              RoveAction(
                  type: RoveActionType.flipCard,
                  amount: 1,
                  object: AnySkillFlipCondition().key,
                  targetKind: TargetKind.ally,
                  range: (1, 2),
                  targetCount: 1),
            ]).withDescription(
                'You and one ally within [range] 1-2 may flip one skill card.'),
            RoveAction.generateEther(),
          ]),
      SkillDef(
          id: 'S-172',
          name: 'Bitter Realization',
          type: SkillType.rave,
          subtype: 'trickster',
          back: 'Ready in Mind',
          isUpgrade: true,
          etherCost: 2,
          actions: [
            RoveAction.rangeAttack(3, endRange: 5).withAugment(ActionAugment(
                condition: RemoveGlyphCondition(),
                action: RoveAction.buff(BuffType.amount, 2).withDescription(
                    'Remove one your glyphs from the map to gain +2 [dmg].'))),
            RoveAction.flip(AnyFlipCondition()),
          ]),
      SkillDef(
          id: 'S-173',
          name: 'Scintillating Darts',
          type: SkillType.rally,
          subtype: 'trickster',
          back: 'Sudden Debate',
          isUpgrade: true,
          actions: [
            RoveAction.rangeAttack(2, endRange: 3),
            RoveAction.generateEther(ether: Ether.crux),
          ]),
      SkillDef(
          id: 'S-174',
          name: 'Sudden Debate',
          type: SkillType.rave,
          subtype: 'trickster',
          back: 'Scintillating Darts',
          isUpgrade: true,
          etherCost: 3,
          actions: [
            RoveAction.meleeAttack(4, endRange: 3, pull: 3),
            RoveAction(
                type: RoveActionType.placeField,
                field: EtherField.windscreen,
                requiresPrevious: true),
            RoveAction.flip(AnyFlipCondition()),
          ]),
      SkillDef(
          id: 'S-177',
          name: 'Conceptualism',
          type: SkillType.rally,
          subtype: 'warden',
          back: 'Second Wind',
          isUpgrade: true,
          actions: [
            RoveAction(
                type: RoveActionType.push,
                amount: 2,
                range: (1, 3),
                targetCount: RoveAction.allTargets,
                aoe: AOEDef.x3Line()),
            RoveAction.generateEther(ether: Ether.wind),
          ]),
      SkillDef(
          id: 'S-178',
          name: 'Second Wind',
          type: SkillType.rally,
          subtype: 'warden',
          back: 'Conceptualism',
          isUpgrade: true,
          etherCost: 1,
          actions: [
            RoveAction(
                    type: RoveActionType.createGlyph,
                    object: RoveGlyph.aerios.name,
                    range: (0, 1),
                    exclusiveGroup: 1)
                .withDescription('Create one Radiant Aerios.'),
            RoveAction(
                    type: RoveActionType.heal,
                    amount: 2,
                    rangeOrigin: RoveActionRangeOrigin.aerios,
                    object: RoveGlyph.aerios.name,
                    range: (0, 0),
                    targetKind: TargetKind.selfOrAlly,
                    field: EtherField.aura,
                    exclusiveGroup: 2)
                .withTargetDescription(
                    'the unit occupying the Radiant Aerios\'s space.'),
          ]),
      SkillDef(
          id: 'S-179',
          name: 'Intense Curiosity',
          type: SkillType.rave,
          subtype: 'trickster',
          back: 'Isolation Agitation',
          isUpgrade: true,
          etherCost: 2,
          actions: [
            RoveAction(
                    type: RoveActionType.select,
                    targetKind: TargetKind.glyph,
                    range: (1, 4))
                .withDescription('Select a glyph within [range] 1-4.'),
            RoveAction(
              type: RoveActionType.command,
              range: RoveAction.anyRange,
              targetCount: 3,
              requiresPrevious: true,
              children: [
                RoveAction(
                    type: RoveActionType.dash,
                    amount: 3,
                    modifiers: const [MoveTowardsSelectionModifier()]),
                RoveAction(
                    type: RoveActionType.suffer,
                    amount: 1,
                    targetKind: TargetKind.self)
              ],
            )
                .withDescription(
                    'Force up to three enemies to perform [dash] 3 towards the selected glyph.\n\nThose enemies suffer [dmg] 1.')
                .withEtherCheckAugment(
                    ether: Ether.crux,
                    action: RoveAction(
                        type: RoveActionType.placeField,
                        field: EtherField.snapfrost,
                        rangeOrigin: RoveActionRangeOrigin.selection,
                        range: (0, 0),
                        staticDescription: RoveActionDescription(
                            body:
                                'Place one [snapfrost] where the glyph is.'))),
          ]),
      SkillDef(
          id: 'S-180',
          name: 'Isolation Agitation',
          type: SkillType.rave,
          subtype: 'warden',
          back: 'Intense Curiosity',
          isUpgrade: true,
          etherCost: 2,
          actions: [
            RoveAction(
                    type: RoveActionType.attack,
                    amount: 2,
                    range: (1, 2),
                    push: 2,
                    modifiers: const [DoubleImpactDamageModifier()])
                .withEtherCheckAugment(
                    ether: Ether.wind,
                    action: RoveAction.buff(BuffType.push, 1))
                .withSuffix('Impact damage is doubled.')
          ]),
    ];
  }

  @override
  List<ReactionDef> get reactions {
    return [
      ReactionDef(
          id: 'S-167',
          name: 'Watch Your Step',
          subtype: 'trickster',
          back: 'Sound Barrier',
          trigger: ReactionTriggerDef(
              type: RoveEventType.beforeAttack,
              targetKind: TargetKind.selfOrAlly,
              range: (0, 3),
              staticDescription:
                  'Before you or an ally within [range] 1-3 are attacked:'),
          actions: [
            RoveAction(
                    actor: RoveActionActorKind.eventTarget,
                    type: RoveActionType.jump,
                    amount: 1,
                    staticDescription:
                        RoveActionDescription(prefix: 'That unit performs:'))
                .withAugment(ActionAugment(
                    condition: PersonalPoolEtherCondition(ether: Ether.wind),
                    action: RoveAction.buff(BuffType.amount, 2))),
          ]),
      ReactionDef(
          id: 'S-168',
          name: 'Sound Barrier',
          subtype: 'warden',
          back: 'Watch Your Step',
          trigger: ReactionTriggerDef(
              type: RoveEventType.beforeAttack,
              targetKind: TargetKind.selfOrAlly,
              range: (0, 3),
              staticDescription:
                  'Before you or an ally within [range] 1-3 are attacked:'),
          actions: [
            RoveAction(
                type: RoveActionType.buff,
                buffType: BuffType.defense,
                amount: 1,
                targetMode: RoveActionTargetMode.eventTarget,
                staticDescription: RoveActionDescription(
                    body: 'That unit gains +1 [DEF] for that attack.')),
            RoveAction.generateEther()
          ]),
      ReactionDef(
          id: 'S-169',
          name: 'Confound',
          subtype: 'trickster',
          back: 'Dance of Rays',
          trigger: ReactionTriggerDef(
            type: RoveEventType.startTurn,
            actorKind: TargetKind.enemy,
            targetKind: TargetKind.glyph,
            rangeOrigin: ReactionTriggerRangeOrigin.eventActor,
            range: (0, 1),
            staticDescription:
                'Before an enemy starts their turn within [range] 0-1 of one of your glyphs:',
          ),
          actions: [
            RoveAction(
                actor: RoveActionActorKind.eventTarget,
                type: RoveActionType.push,
                amount: 1,
                range: (0, 1),
                staticDescription:
                    RoveActionDescription(prefix: 'That glyph performs:')),
            RoveAction.generateEther(ether: Ether.wind)
          ]),
      ReactionDef(
          id: 'S-170',
          name: 'Dance of Rays',
          subtype: 'trickster',
          back: 'Confound',
          trigger: ReactionTriggerDef(
            type: RoveEventType.startTurn,
            actorKind: TargetKind.enemy,
            targetKind: TargetKind.glyph,
            rangeOrigin: ReactionTriggerRangeOrigin.eventActor,
            range: (0, 1),
            staticDescription:
                'Before an enemy starts their turn within [range] 0-1 of one of your glyphs:',
          ),
          actions: [
            RoveAction(
                    actor: RoveActionActorKind.eventTarget,
                    type: RoveActionType.attack,
                    amount: 1,
                    range: (0, 1),
                    staticDescription:
                        RoveActionDescription(prefix: 'That glyph performs:'))
                .withAugment(
              ActionAugment(
                  condition: PersonalPoolEtherCondition(ether: Ether.crux),
                  action: RoveAction.buff(BuffType.amount, 1)),
            ),
          ]),
      ReactionDef(
          id: 'S-175',
          name: 'Pure Sophistry',
          subtype: 'trickster',
          back: 'Essentialism',
          isUpgrade: true,
          trigger: ReactionTriggerDef(
              type: RoveEventType.beforeAttack,
              targetKind: TargetKind.self,
              staticDescription: 'Before you are attacked:'),
          actions: [
            RoveAction.buff(BuffType.defense, 2, scope: BuffScope.action)
                .withDescription('Gain +2 [DEF] for that attack.'),
            RoveAction.generateEther(),
          ]),
      ReactionDef(
          id: 'S-176',
          name: 'Essentialism',
          subtype: 'trickster',
          back: 'Pure Sophistry',
          isUpgrade: true,
          trigger: ReactionTriggerDef(
              type: RoveEventType.beforeAttack,
              targetKind: TargetKind.self,
              staticDescription: 'Before you are attacked:'),
          actions: [
            RoveAction(
                    actor: RoveActionActorKind.allyOrGlyph,
                    type: RoveActionType.attack,
                    amount: 2,
                    range: (0, 1),
                    targetMode: RoveActionTargetMode.eventActor)
                .withPrefix('One of your allies or glyphs perform:')
                .withTargetDescription('the attacker')
                .withAugment(ActionAugment(
                    condition: InfuseEtherCondition(),
                    action: RoveAction.buff(BuffType.amount, 2))),
          ]),
    ];
  }
}
