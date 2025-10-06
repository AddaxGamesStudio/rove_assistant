import 'dart:ui';

import 'encounter_def_utils.dart';
import 'package:rove_data_types/rove_data_types.dart';

extension Quest1 on EncounterDef {
  static EncounterDef get encounter1dot1 => EncounterDef(
        questId: '1',
        number: '1',
        title: 'In Search of the Yanshif',
        setup: EncounterSetup(
            box: '1/6', map: '6', adversary: '6', tiles: '3x Bursting Bells'),
        victoryDescription: 'Slay Zipahudi the Briarbull.',
        terrain: [
          dangerousBramble(1),
          trapBell(2),
          etherWater(),
        ],
        roundLimit: 8,
        baseLystReward: 15,
        etherRewards: const [Ether.water],
        campaignLink:
            '''Encounter 1.2 - “**Then Came too Late the Warning**” [campaign] **18**.''',
        challenges: const [
          'Briarwogs gain +2 [HP].',
          'Zipahudi the Briarbull is immune to all forced movement.',
          'Zipahudi the Briarbull gains +1 [DEF] while there is at least one Briarwog on the map.'
        ],
        dialogs: [
          introductionFromText('quest_1_encounter_1_intro'),
        ],
        onLoad: [
          dialog('Introduction'),
          codexLink('Silvan Theory',
              number: 16,
              body:
                  '''The first time a Grovetender is slain, read [title], [codex] 12.'''),
          codexLink('The Airs That Brood',
              number: 17,
              body:
                  '''When Zipahudi the Briarbull is slain, read [title], [codex] 13.'''),
        ],
        startingMap: MapDef(
          id: '1.1',
          columnCount: 13,
          rowCount: 11,
          backgroundRect: Rect.fromLTWH(71, 26, 1593 - 71, 1475 - 26),
          terrain: {
            (0, 0): TerrainType.difficult,
            (0, 1): TerrainType.difficult,
            (0, 4): TerrainType.barrier,
            (0, 7): TerrainType.barrier,
            (0, 8): TerrainType.barrier,
            (1, 0): TerrainType.difficult,
            (1, 1): TerrainType.difficult,
            (1, 2): TerrainType.dangerous,
            (1, 4): TerrainType.barrier,
            (1, 5): TerrainType.barrier,
            (1, 8): TerrainType.barrier,
            (2, 0): TerrainType.difficult,
            (2, 1): TerrainType.difficult,
            (3, 0): TerrainType.difficult,
            (3, 1): TerrainType.difficult,
            (3, 2): TerrainType.difficult,
            (3, 10): TerrainType.start,
            (4, 0): TerrainType.difficult,
            (4, 1): TerrainType.difficult,
            (5, 0): TerrainType.difficult,
            (5, 5): TerrainType.dangerous,
            (5, 10): TerrainType.start,
            (6, 6): TerrainType.dangerous,
            (7, 0): TerrainType.difficult,
            (7, 5): TerrainType.dangerous,
            (7, 10): TerrainType.start,
            (8, 0): TerrainType.difficult,
            (8, 1): TerrainType.difficult,
            (9, 0): TerrainType.difficult,
            (9, 1): TerrainType.difficult,
            (9, 2): TerrainType.difficult,
            (9, 10): TerrainType.start,
            (10, 0): TerrainType.difficult,
            (10, 1): TerrainType.difficult,
            (10, 2): TerrainType.difficult,
            (11, 0): TerrainType.difficult,
            (11, 1): TerrainType.difficult,
            (11, 2): TerrainType.difficult,
            (11, 3): TerrainType.difficult,
            (11, 4): TerrainType.dangerous,
            (11, 5): TerrainType.barrier,
            (11, 9): TerrainType.barrier,
            (11, 10): TerrainType.barrier,
            (12, 0): TerrainType.difficult,
            (12, 1): TerrainType.difficult,
            (12, 2): TerrainType.difficult,
            (12, 3): TerrainType.difficult,
            (12, 4): TerrainType.barrier,
            (12, 5): TerrainType.barrier,
            (12, 9): TerrainType.barrier,
          },
        ),
        placements: [
          const PlacementDef(name: 'Briarwog', c: 2, r: 5),
          const PlacementDef(
              name: 'Bursting Bell',
              alias: 'Bursting Bell Trap',
              type: PlacementType.trap,
              c: 2,
              r: 6,
              trapDamage: 2),
          const PlacementDef(name: 'Briarwog', c: 3, r: 2),
          const PlacementDef(name: 'Briarwog', c: 3, r: 5, minPlayers: 3),
          const PlacementDef(
              name: 'Bursting Bell',
              alias: 'Bursting Bell Trap',
              type: PlacementType.trap,
              c: 4,
              r: 3,
              trapDamage: 2),
          PlacementDef(
              name: Ether.water.label, type: PlacementType.ether, c: 5, r: 1),
          const PlacementDef(name: 'Grovetender', c: 5, r: 4, minPlayers: 4),
          const PlacementDef(name: 'Zipahudi the Briarbull', c: 6, r: 1),
          const PlacementDef(name: 'Grovetender', c: 6, r: 5),
          PlacementDef(
              name: Ether.water.label, type: PlacementType.ether, c: 7, r: 1),
          const PlacementDef(name: 'Grovetender', c: 7, r: 4, minPlayers: 3),
          const PlacementDef(name: 'Briarwog', c: 9, r: 5, minPlayers: 4),
          const PlacementDef(
              name: 'Bursting Bell',
              alias: 'Bursting Bell Trap',
              type: PlacementType.trap,
              c: 9,
              r: 7,
              trapDamage: 2),
          const PlacementDef(name: 'Briarwog', c: 10, r: 2),
          const PlacementDef(name: 'Briarwog', c: 11, r: 6),
        ],
        adversaries: [
          EncounterFigureDef(
            name: 'Briarwog',
            letter: 'A',
            standeeCount: 6,
            healthFormula: '6+2*(C1)',
            affinities: const {
              Ether.fire: -1,
              Ether.earth: -1,
              Ether.water: 1,
              Ether.morph: 1,
            },
/*            abilities: [
              AbilityDef(name: 'Tongue Pluck', actions: [
                RoveAction.jump(2),
                RoveAction(
                    type: RoveActionType.attack,
                    amount: 2,
                    range: (1, 2),
                    pull: 1)
              ]),
              AbilityDef(name: 'Leaping Tackle', actions: [
                RoveAction.jump(3),
                RoveAction(
                    type: RoveActionType.attack, amount: 2, range: (1, 1))
              ]),
              AbilityDef(name: 'Water Baloon', actions: [
                RoveAction.move(2),
                RoveAction(
                    type: RoveActionType.attack,
                    amount: 1,
                    range: (1, 2),
                    push: 2,
                    targetCount: RoveAction.allTargets)
              ]),
              AbilityDef(name: 'Venomous Splatter', actions: [
                RoveAction.jump(2),
                RoveAction(
                    type: RoveActionType.attack, amount: 2, range: (2, 3)),
                RoveAction(
                    type: RoveActionType.suffer,
                    amount: 1,
                    rangeOrigin: RoveActionRangeOrigin.previousTarget,
                    range: (1, 1),
                    requiresPrevious: true,
                    staticDescription: RoveActionDescription(
                        body:
                            'One enemy adjacent to the attacked target suffers [DMG]1.'))
              ]),
            ], */
          ),
          EncounterFigureDef(
            name: 'Grovetender',
            letter: 'B',
            standeeCount: 3,
            health: 10,
            defense: 1,
            traits: const [
              'If a Rover slays this unit, that Rover [plus_water_earth].'
            ],
            affinities: const {
              Ether.fire: -1,
              Ether.earth: 1,
              Ether.water: 1,
            },
/*            abilities: [
              AbilityDef(name: 'Soothing Pollen', actions: [
                RoveAction.jump(2),
                RoveAction(
                    type: RoveActionType.heal,
                    amount: 2,
                    range: (0, 4),
                    field: EtherField.aura)
              ]),
              AbilityDef(name: 'Toxic Spores', actions: [
                RoveAction(
                    type: RoveActionType.attack,
                    amount: 2,
                    range: (2, 4),
                    pierce: true,
                    targetCount: 2)
              ]),
              AbilityDef(name: 'Verdant Cleave', actions: [
                RoveAction.move(4),
                RoveAction(
                    type: RoveActionType.attack,
                    amount: 3,
                    range: (1, 1),
                    aoe: AOEDef.x4Cleave(),
                    targetCount: RoveAction.allTargets)
              ]),
              AbilityDef(name: 'Creeping Roots', actions: [
                RoveAction.move(4),
                RoveAction(
                    type: RoveActionType.attack, amount: 4, range: (1, 1)),
              ]),
            ], */
            onSlain: [
              codex(16),
              ether([Ether.water, Ether.earth]),
            ],
          ),
          EncounterFigureDef(
              name: 'Zipahudi the Briarbull',
              letter: 'C',
              type: AdversaryType.miniboss,
              standeeCount: 1,
              healthFormula: '10*R',
              defenseFormula: '1*C3*ceil(X/(X+1))',
              xDefinition: 'count_adversary(Briarwog)',
              traits: const [
                '''[React] After this unit is attacked from within [Range] 1:
                
 The attacker suffers [DMG]2.'''
              ],
              affinities: const {
                Ether.earth: -1,
                Ether.water: 2,
                Ether.morph: 1,
              },
/*              abilities: [
                AbilityDef(name: 'Soothing Pollen', actions: [
                  RoveAction.jump(2),
                  RoveAction(
                      type: RoveActionType.heal,
                      amount: 2,
                      range: (0, 4),
                      field: EtherField.aura)
                ]),
                AbilityDef(name: 'Toxic Spores', actions: [
                  RoveAction(
                      type: RoveActionType.attack,
                      amount: 2,
                      range: (2, 4),
                      pierce: true,
                      targetCount: 2)
                ]),
                AbilityDef(name: 'Verdant Cleave', actions: [
                  RoveAction.move(4),
                  RoveAction(
                      type: RoveActionType.attack,
                      amount: 3,
                      range: (1, 1),
                      aoe: AOEDef.x4Cleave(),
                      targetCount: RoveAction.allTargets)
                ]),
                AbilityDef(name: 'Creeping Roots', actions: [
                  RoveAction.move(4),
                  RoveAction(
                      type: RoveActionType.attack, amount: 4, range: (1, 1)),
                ]),
              ], */
              reactions: [
                EnemyReactionDef(
                    trigger: ReactionTriggerDef(
                        type: RoveEventType.afterAttack, range: (1, 1)),
                    actions: [
                      RoveAction(
                          type: RoveActionType.suffer,
                          amount: 2,
                          targetMode: RoveActionTargetMode.eventActor)
                    ])
              ],
              onSlain: [
                codex(17),
                victory(),
              ])
        ],
      );

  static EncounterDef get encounter1dot2 => EncounterDef(
        questId: '1',
        number: '2',
        title: 'Then Came too Late the Warning',
        setup: EncounterSetup(
            box: '1/6', map: '7', adversary: '7', tiles: '6x Bursting Bells'),
        victoryDescription: 'Survive for seven rounds.',
        lossDescription: 'Lose if Zeepurah is slain.',
        terrain: [
          EncounterTerrain('dangerous_thick_bramble',
              title: 'Thick Bramble',
              damage: 1,
              body:
                  'Non-flying units that enter a thick bramble space suffer [DMG] 1.'),
          EncounterTerrain('trap_bursting_bell',
              title: 'Bursting Bell Trap',
              damage: 2,
              body: 'Units that trigger Bursting Bell traps suffer [DMG] 2.'),
          etherWind(),
        ],
        roundLimit: 7,
        baseLystReward: 15,
        campaignLink:
            '''Encounter 1.3 - “**Swallowed by the Night**” [campaign] **20**.''',
        challenges: [
          'Zeepurah is injured and can not move during this encounter.',
          'Nahoots will always attack Zeepurah if she is within range of their attacks.',
          'Terranapes always gain the benefit of their [HP] threshold augments.'
        ],
        dialogs: [
          introductionFromText('quest_1_encounter_2_intro'),
        ],
        onLoad: [
          dialog('Introduction'),
          rules('Consuming Corruption',
              '''Taharik is under assault by a seemingly endless horde. There are six ether icons on the edges of the map. These icons represent possible spawn locations throughout the encounter.

When an adversary is slain, place it off to the side of the map on its side. During the **Start Phase**, for each adversary that is both off to the side and flipped vertically, roll an ether dice from the general pool, then spawn that adversary at the space with the ether icon corresponding to the result that was just rolled. Then, for each adversary that is both off to the side and placed on its side, flip them vertically.'''),
          rules('Champion of the Yanshif',
              'Zeepurah is a character ally to Rovers. For this encounter Zeepurah will only use the "Left of the Yanshif" side and will not flip.'),
          rules('Thinning the Ranks',
              'Keep track of the number of nahoot slain during this encounter. *[The app does this automatically.]*'),
          codexLink('Creeping Darkness',
              number: 18,
              body:
                  '''The first time a Nahoot is slain, read [title], [codex] 13.'''),
          codexLink('Unnatural Stillness',
              number: 19,
              body: '''At the end of round 7, read [title], [codex] 14.'''),
        ],
        onMilestone: {
          '_victory': [
            codex(19),
            victory(),
          ]
        },
        onWillEndRound: [
          milestone('_victory', condition: RoundCondition(7)),
        ],
        startingMap: MapDef(
          id: '1.2',
          columnCount: 13,
          rowCount: 11,
          backgroundRect: Rect.fromLTWH(110.0, 44.0, 1481.0, 1411.0),
          terrain: {
            (0, 6): TerrainType.barrier,
            (0, 7): TerrainType.barrier,
            (1, 6): TerrainType.object,
            (1, 7): TerrainType.barrier,
            (2, 1): TerrainType.barrier,
            (2, 2): TerrainType.barrier,
            (3, 2): TerrainType.barrier,
            (3, 3): TerrainType.dangerous,
            (3, 9): TerrainType.barrier,
            (3, 10): TerrainType.barrier,
            (4, 8): TerrainType.dangerous,
            (4, 9): TerrainType.barrier,
            (5, 9): TerrainType.start,
            (5, 10): TerrainType.start,
            (6, 8): TerrainType.start,
            (6, 9): TerrainType.start,
            (7, 0): TerrainType.barrier,
            (7, 1): TerrainType.barrier,
            (7, 9): TerrainType.start,
            (7, 10): TerrainType.start,
            (8, 0): TerrainType.barrier,
            (8, 1): TerrainType.dangerous,
            (8, 7): TerrainType.dangerous,
            (9, 7): TerrainType.barrier,
            (9, 8): TerrainType.barrier,
            (10, 7): TerrainType.barrier,
            (11, 3): TerrainType.barrier,
            (11, 4): TerrainType.object,
            (11, 9): TerrainType.barrier,
            (11, 10): TerrainType.barrier,
            (12, 2): TerrainType.barrier,
            (12, 3): TerrainType.barrier,
            (12, 9): TerrainType.barrier,
          },
          spawnPoints: {
            (0, 5): Ether.crux,
            (0, 9): Ether.earth,
            (5, 0): Ether.fire,
            (9, 0): Ether.water,
            (12, 5): Ether.morph,
            (12, 8): Ether.wind,
          },
        ),
        allies: [
          AllyDef(name: 'Zeepurah', cardId: 'A-012', behaviors: [
            EncounterFigureDef(
              name: 'Left of the Yanshif',
              health: 8,
              affinities: {
                Ether.fire: -1,
                Ether.earth: -1,
                Ether.water: 1,
                Ether.wind: 1,
              },
              abilities: [
                AbilityDef(name: 'Ability', actions: [
                  RoveAction(
                      type: RoveActionType.dash,
                      amount: 2,
                      targetKind: TargetKind.self,
                      exclusiveGroup: 1),
                  RoveAction(
                      type: RoveActionType.attack,
                      amount: 2,
                      range: (2, 3),
                      exclusiveGroup: 1),
                  RoveAction(
                      type: RoveActionType.jump,
                      amount: 3,
                      targetKind: TargetKind.self,
                      exclusiveGroup: 2),
                  RoveAction(
                      type: RoveActionType.heal,
                      amount: 2,
                      range: (0, 2),
                      exclusiveGroup: 2),
                ]),
              ],
              onSlain: [fail()],
            ),
          ]),
        ],
        adversaries: [
          EncounterFigureDef(
            name: 'Briarwog',
            letter: 'A',
            standeeCount: 6,
            health: 6,
            respawns: true,
            affinities: {
              Ether.earth: -1,
              Ether.fire: -1,
              Ether.morph: 1,
              Ether.water: 1,
            },
            /*abilities: [
              AbilityDef(name: 'Tongue Pluck', actions: [
                RoveAction.jump(2),
                RoveAction(
                    type: RoveActionType.attack,
                    amount: 2,
                    range: (1, 2),
                    pull: 1)
              ]),
              AbilityDef(name: 'Leaping Tackle', actions: [
                RoveAction.jump(3),
                RoveAction(
                    type: RoveActionType.attack, amount: 2, range: (1, 1))
              ]),
              AbilityDef(name: 'Water Baloon', actions: [
                RoveAction.move(2),
                RoveAction(
                    type: RoveActionType.attack,
                    amount: 1,
                    range: (1, 2),
                    push: 2,
                    targetCount: RoveAction.allTargets)
              ]),
              AbilityDef(name: 'Venomous Splatter', actions: [
                RoveAction.jump(2),
                RoveAction(
                    type: RoveActionType.attack, amount: 2, range: (2, 3)),
                RoveAction(
                    type: RoveActionType.suffer,
                    amount: 1,
                    rangeOrigin: RoveActionRangeOrigin.previousTarget,
                    range: (1, 1),
                    requiresPrevious: true,
                    staticDescription: RoveActionDescription(
                        body:
                            'One enemy adjacent to the attacked target suffers [DMG]1.'))
              ]),
            ],*/
          ),
          EncounterFigureDef(
              name: 'Nahoot',
              letter: 'B',
              standeeCount: 7,
              health: 12,
              respawns: true,
              affinities: {
                Ether.wind: 1,
                Ether.crux: -1,
                Ether.fire: -1,
                Ether.morph: 2,
              },
              traits: [
                'If a Rover slays this unit, that Rover [plus_wind_morph].'
              ],
              /* abilities: [
                AbilityDef(name: 'Miasmic Arrow', actions: [
                  RoveAction.move(2),
                  RoveAction(
                      type: RoveActionType.attack,
                      amount: 2,
                      range: (2, 3),
                      field: EtherField.miasma)
                ]),
                AbilityDef(name: 'Morphic Agitation', actions: [
                  RoveAction.jump(4),
                  RoveAction.meleeAttack(3).withAugment(ActionAugment(
                      condition: TargetHasEtherCondition(Ether.morph),
                      action: RoveAction.heal(2, targetKind: TargetKind.self)
                          .withDescription(
                              'If the target has a [Morph] dice in their personal or infusion pools, recover [RCV] 2.')))
                ]),
                AbilityDef(name: 'Split Strike', actions: [
                  RoveAction.move(3),
                  RoveAction(
                      type: RoveActionType.attack,
                      amount: 2,
                      range: (2, 2),
                      targetCount: 2)
                ]),
                AbilityDef(name: 'Visceral Frenzy', actions: [
                  RoveAction.meleeAttack(3),
                  RoveAction.jump(4),
                  RoveAction.meleeAttack(2)
                ]),
              ],*/
              onSlain: [
                ether([Ether.wind, Ether.morph]),
                codex(18),
                lyst('10', title: 'Thinning the Ranks'),
              ]),
          EncounterFigureDef(
              name: 'Terranape',
              letter: 'C',
              standeeCount: 2,
              health: 15,
              respawns: true,
              affinities: {
                Ether.wind: -1,
                Ether.earth: 2,
                Ether.fire: -2,
                Ether.morph: 1,
                Ether.water: 1,
              },
              traits: [
                'At the start of this unit\'s turn, it recovers [RCV] R-1.'
              ],
/*              abilities: [
                AbilityDef(name: 'Hammer Slam', actions: [
                  RoveAction.move(3),
                  RoveAction.meleeAttack(3).withAugment(ActionAugment(
                      condition: ActorHasHealthCondition('9-H'),
                      action: RoveAction.buff(BuffType.amount, 1).withDescription(
                          'If this unit has 9 or fewer [HP], gain +1 [DMG].')))
                ]),
                AbilityDef(name: 'Seismic Leap', actions: [
                  RoveAction.jump(4),
                  RoveAction.meleeAttack(2, targetCount: RoveAction.allTargets)
                      .withAugment(ActionAugment(
                          condition: ActorHasHealthCondition('9-H'),
                          action: RoveAction.buff(BuffType.endRange, 1)
                              .withDescription(
                                  'If this unit has 9 or fewer [HP], +1 [Range].')))
                ]),
                AbilityDef(name: 'Boulder Fling', actions: [
                  RoveAction.rangeAttack(4, endRange: 4).withAugment(ActionAugment(
                      condition: ActorHasHealthCondition('9-H'),
                      action: RoveAction.buff(BuffType.pierce, 0).withDescription(
                          'If this unit has 9 or fewer [HP], gain [pierce].')))
                ]),
                AbilityDef(name: 'Quake Stomp', actions: [
                  RoveAction.move(2),
                  RoveAction(
                          type: RoveActionType.attack,
                          amount: 3,
                          range: (1, 1),
                          aoe: AOEDef.x9Cone(),
                          targetCount: RoveAction.allTargets)
                      .withAugment(ActionAugment(
                          condition: ActorHasHealthCondition('9-H'),
                          action: RoveAction.buff(BuffType.push, 2).withDescription(
                              'If this unit has 9 or fewer [HP], gain [Push] 2.')))
                ]),
              ],*/
              reactions: [
                EnemyReactionDef(
                    trigger: ReactionTriggerDef(
                        type: RoveEventType.startTurn,
                        targetKind: TargetKind.self),
                    actions: [
                      RoveAction.heal(2, targetKind: TargetKind.self),
                    ]),
              ]),
        ],
        placements: const [
          PlacementDef(name: 'Briarwog', c: 1, r: 8, minPlayers: 4),
          PlacementDef(name: 'Briarwog', c: 2, r: 3, minPlayers: 3),
          PlacementDef(name: 'Briarwog', c: 6, r: 1, minPlayers: 3),
          PlacementDef(name: 'Briarwog', c: 9, r: 3),
          PlacementDef(name: 'Briarwog', c: 12, r: 6, minPlayers: 4),
          PlacementDef(name: 'Nahoot', c: 1, r: 5),
          PlacementDef(name: 'Nahoot', c: 8, r: 2, minPlayers: 3),
          PlacementDef(name: 'Nahoot', c: 10, r: 2, minPlayers: 4),
          PlacementDef(name: 'Nahoot', c: 12, r: 4),
          PlacementDef(name: 'Terranape', c: 4, r: 2),
          PlacementDef(
              name: 'Bursting Bell',
              type: PlacementType.trap,
              c: 1,
              r: 4,
              trapDamage: 2),
          PlacementDef(
              name: 'Bursting Bell',
              type: PlacementType.trap,
              c: 2,
              r: 6,
              trapDamage: 2),
          PlacementDef(
              name: 'Bursting Bell',
              type: PlacementType.trap,
              c: 6,
              r: 5,
              trapDamage: 2),
          PlacementDef(
              name: 'Bursting Bell',
              type: PlacementType.trap,
              c: 10,
              r: 6,
              trapDamage: 2),
          PlacementDef(
              name: 'Bursting Bell',
              type: PlacementType.trap,
              c: 10,
              r: 3,
              trapDamage: 2),
          PlacementDef(
              name: 'Bursting Bell',
              type: PlacementType.trap,
              c: 5,
              r: 2,
              trapDamage: 2),
          PlacementDef(name: 'wind', type: PlacementType.ether, c: 1, r: 6),
          PlacementDef(name: 'wind', type: PlacementType.ether, c: 11, r: 4),
        ],
      );

  static EncounterDef get encounter1dot3 => EncounterDef(
      questId: '1',
      number: '3',
      title: 'Swallowed by the Night',
      setup: EncounterSetup(
          box: '1/6', map: '8', adversary: '8', tiles: '1x Hoard'),
      victoryDescription: 'Slay the Zaghan Nahadir.',
      lossDescription: 'Lose if Zeepurah is slain.',
      terrain: [
        etherWind(),
      ],
      roundLimit: 8,
      baseLystReward: 15,
      unlocksRoverLevel: 3,
      campaignLink:
          '''Encounter 1.4 - “**The River of Black Bile Flows**” [campaign] 22.''',
      challenges: [
        'All skills that [generate], [generate_morph] instead.',
        'Dark Conversion spawns Nahoot at the start of rounds 2, 4, and 6 instead.',
        'All spawned nahoot must be slain before reading “**Taken a Toll**”.',
      ],
      dialogs: [
        introductionFromText('quest_1_encounter_3_intro'),
      ],
      onLoad: [
        dialog('Introduction'),
        rules('Dark Conversion',
            'The Zagan Nahadir is transforming the Yanshif into monsters. During the Start Phase of rounds 3 and 6, spawn one nahoot in the space at the bottom right corner marked with a [Morph] icon.'),
        rules('Champion of the Yanshif',
            'Zeepurah is a character ally to Rovers. At the start of the Rover Phase, if Zeepurah is within [Range] 1-3 of any nahoot or Zaghan Nahadir, flip her ally card over to its “Eyes in the Dark” side, otherwise flip her ally card over to its “Left of Yanshif” side.'),
        codexLink('Knock on Wood',
            number: 20,
            body:
                'If a Rover enters into the space with the hoard tile, remove the tile and read [title], [codex] 14.'),
        codexLink('Into the Tainted Air',
            number: 21,
            body: 'At the end of Round 2, read [title], [codex] 15.'),
        codexLink('Taken a Toll',
            number: 22,
            body:
                'Immediately when the Zaghan Nahadir is slain, read [title], [codex] 15.'),
      ],
      onWillEndRound: [
        codex(21, condition: RoundCondition(2)),
      ],
      onDidStartRound: [
        placementGroup(
          'Dark Conversion',
          body:
              'Spawn one Nahoot in the space at the bottom right corner marked with a [Morph] icon.',
          conditions: [RoundCondition(2), ChallengeOnCondition(2)],
        ),
        placementGroup(
          'Dark Conversion',
          body:
              'Spawn one Nahoot in the space at the bottom right corner marked with a [Morph] icon.',
          conditions: [RoundCondition(3), ChallengeOffCondition(2)],
        ),
        placementGroup(
          'Dark Conversion',
          body:
              'Spawn one Nahoot in the space at the bottom right corner marked with a [Morph] icon.',
          conditions: [RoundCondition(4), ChallengeOnCondition(2)],
        ),
        placementGroup(
          'Dark Conversion',
          body:
              'Spawn one Nahoot in the space at the bottom right corner marked with a [Morph] icon.',
          conditions: [RoundCondition(6)],
        ),
      ],
      startingMap: MapDef(
        id: '1.3',
        columnCount: 13,
        rowCount: 11,
        backgroundRect: Rect.fromLTWH(110.0, 44.0, 1481.0, 1411.0),
        terrain: {
          (0, 0): TerrainType.start,
          (0, 1): TerrainType.start,
          (0, 2): TerrainType.difficult,
          (0, 7): TerrainType.barrier,
          (0, 8): TerrainType.barrier,
          (1, 0): TerrainType.start,
          (1, 1): TerrainType.start,
          (1, 7): TerrainType.object,
          (1, 8): TerrainType.barrier,
          (2, 0): TerrainType.start,
          (2, 3): TerrainType.object,
          (2, 4): TerrainType.object,
          (3, 0): TerrainType.start,
          (3, 4): TerrainType.object,
          (4, 6): TerrainType.difficult,
          (5, 0): TerrainType.object,
          (5, 1): TerrainType.object,
          (5, 3): TerrainType.difficult,
          (5, 9): TerrainType.barrier,
          (5, 10): TerrainType.barrier,
          (6, 0): TerrainType.object,
          (6, 9): TerrainType.barrier,
          (7, 5): TerrainType.object,
          (7, 6): TerrainType.object,
          (7, 8): TerrainType.difficult,
          (8, 0): TerrainType.barrier,
          (8, 1): TerrainType.object,
          (8, 5): TerrainType.object,
          (8, 9): TerrainType.object,
          (9, 0): TerrainType.barrier,
          (9, 1): TerrainType.barrier,
          (9, 3): TerrainType.difficult,
          (9, 7): TerrainType.difficult,
          (11, 2): TerrainType.object,
          (11, 3): TerrainType.object,
          (11, 5): TerrainType.barrier,
          (11, 6): TerrainType.barrier,
          (12, 2): TerrainType.object,
          (12, 5): TerrainType.barrier,
          (12, 7): TerrainType.object,
        },
        spawnPoints: {
          (11, 9): Ether.morph,
        },
      ),
      allies: [
        AllyDef(name: 'Zeepurah', cardId: 'A-012', behaviors: [
          EncounterFigureDef(
              name: 'Left of the Yanshif',
              health: 8,
              affinities: {
                Ether.fire: -1,
                Ether.earth: -1,
                Ether.water: 1,
                Ether.wind: 1,
              },
              abilities: [
                AbilityDef(name: 'Ability', actions: [
                  RoveAction(
                      type: RoveActionType.dash,
                      amount: 2,
                      targetKind: TargetKind.self,
                      exclusiveGroup: 1),
                  RoveAction(
                      type: RoveActionType.attack,
                      amount: 2,
                      range: (2, 3),
                      exclusiveGroup: 1),
                  RoveAction(
                      type: RoveActionType.jump,
                      amount: 3,
                      targetKind: TargetKind.self,
                      exclusiveGroup: 2),
                  RoveAction(
                      type: RoveActionType.heal,
                      amount: 2,
                      range: (0, 2),
                      exclusiveGroup: 2),
                ]),
              ],
              onSlain: [
                fail()
              ],
              onStartPhase: [
                EncounterAction(conditions: [
                  PhaseCondition(RoundPhase.rover),
                  InRangeOfAny(range: (1, 3), targets: ['Nahoot', 'Nahadir'])
                ], type: EncounterActionType.toggleBehavior),
              ]),
          EncounterFigureDef(
              name: 'Eyes in the Dark',
              health: 8,
              flies: true,
              affinities: {
                Ether.fire: -1,
                Ether.crux: -1,
                Ether.morph: 1,
                Ether.wind: 1,
              },
              abilities: [
                AbilityDef(
                  name: 'Ability',
                  actions: [
                    RoveAction.move(4),
                    RoveAction.meleeAttack(3),
                  ],
                ),
              ],
              onSlain: [
                fail()
              ],
              onStartPhase: [
                EncounterAction(conditions: [
                  PhaseCondition(RoundPhase.rover),
                  InRangeOfNone(range: (1, 3), targets: ['Nahoot', 'Nahadir'])
                ], type: EncounterActionType.toggleBehavior),
              ]),
        ]),
      ],
      overlays: [EncounterFigureDef(name: 'Hoard', lootable: true)],
      adversaries: [
        EncounterFigureDef(
          name: 'Galeaper',
          letter: 'A',
          standeeCount: 8,
          health: 5,
          flies: true,
          affinities: const {
            Ether.fire: -1,
            Ether.earth: -1,
            Ether.wind: 1,
            Ether.morph: 1,
          },
/*            abilities: [
              AbilityDef(name: 'Gale Shot', actions: [
                RoveAction.move(2),
                RoveAction.rangeAttack(2, endRange: 2),
              ]),
              AbilityDef(name: 'Power Strike', actions: [
                RoveAction.rangeAttack(2, endRange: 4, push: 2),
              ]),
              AbilityDef(name: 'Rending Swoop', actions: [
                RoveAction.move(3),
                RoveAction.meleeAttack(3, pierce: true),
                RoveAction(
                    type: RoveActionType.dash,
                    amount: 2,
                    retreat: true,
                    requiresPrevious: true),
              ]),
              AbilityDef(name: 'Swarn Instinct', actions: [
                RoveAction.move(4),
                RoveAction.meleeAttack(3).withAugment(ActionAugment(
                    condition: AllyAdjacentToTargetAugmentCondition(),
                    action: RoveAction(
                        type: RoveActionType.buff,
                        buffType: BuffType.amount,
                        amount: 1,
                        staticDescription: RoveActionDescription(
                            body:
                                'If at least one ally is adjacent to the target, gain +1 [DMG].'))))
              ]),
            ]*/
        ),
        EncounterFigureDef(
          name: 'Nahoot',
          letter: 'B',
          standeeCount: 7,
          health: 12,
          affinities: {
            Ether.crux: -1,
            Ether.fire: -1,
            Ether.morph: 2,
            Ether.wind: 1,
          },
          spawnable: true,
          traits: ['If a Rover slays this unit, that Rover [plus_wind_morph].'],
/*          abilities: [
            AbilityDef(name: 'Miasmic Arrow', actions: [
              RoveAction.move(2),
              RoveAction(
                  type: RoveActionType.attack,
                  amount: 2,
                  range: (2, 3),
                  field: EtherField.miasma)
            ]),
            AbilityDef(name: 'Morphic Agitation', actions: [
              RoveAction.jump(4),
              RoveAction.meleeAttack(3).withAugment(ActionAugment(
                  condition: TargetHasEtherCondition(Ether.morph),
                  action: RoveAction.heal(2, targetKind: TargetKind.self)
                      .withDescription(
                          'If the target has a [Morph] dice in their personal or infusion pools, recover [RCV] 2.')))
            ]),
            AbilityDef(name: 'Split Strike', actions: [
              RoveAction.move(3),
              RoveAction(
                  type: RoveActionType.attack,
                  amount: 2,
                  range: (2, 2),
                  targetCount: 2)
            ]),
            AbilityDef(name: 'Visceral Frenzy', actions: [
              RoveAction.meleeAttack(3),
              RoveAction.jump(4),
              RoveAction.meleeAttack(2)
            ]),
          ], */
          onSlain: [
            EncounterAction(
                type: EncounterActionType.rewardEther,
                value: Ether.etherOptionsToString([Ether.wind, Ether.morph])),
          ],
        ),
        EncounterFigureDef(
          name: 'Zaghan Nahadir',
          letter: 'C',
          standeeCount: 4,
          type: AdversaryType.miniboss,
          healthFormula: '8*R',
          flies: true,
          affinities: {
            Ether.morph: 2,
            Ether.wind: 1,
            Ether.crux: -1,
            Ether.water: 1,
          },
/*            abilities: [
              AbilityDef(name: 'Passing Knell', actions: [
                RoveAction(
                    type: RoveActionType.command,
                    object: 'Nahoot',
                    range: RoveAction.anyRange,
                    targetCount: 2,
                    targetKind: TargetKind.ally,
                    staticDescription: RoveActionDescription(
                        body: 'The nearest Nahoot performs:'),
                    children: [
                      RoveAction.jump(4),
                      RoveAction(
                          type: RoveActionType.attack,
                          amount: 3,
                          range: (1, 1),
                          pierce: true,
                          requiresPrevious: true)
                    ]),
              ]),
              AbilityDef(name: 'Ariose Incantation', actions: [
                RoveAction(
                    type: RoveActionType.heal,
                    amount: 2,
                    range: (0, 5),
                    targetKind: TargetKind.self,
                    field: EtherField.aura),
                RoveAction(
                    type: RoveActionType.heal,
                    amount: 2,
                    range: (0, 5),
                    targetKind: TargetKind.ally,
                    field: EtherField.aura),
              ]),
              AbilityDef(name: 'Debase Form', actions: [
                RoveAction.move(3),
                RoveAction.meleeAttack(3, endRange: 5),
                RoveAction(
                        type: RoveActionType.transformEther,
                        object: Ether.morph.toJson(),
                        targetMode: RoveActionTargetMode.previous,
                        requiresPrevious: true)
                    .withDescription(
                        'The target must change one non-[Morph] dice in their personal pool into a [Morph] dice, if able to.')
              ]),
              AbilityDef(name: 'Bell Tolls', actions: [
                RoveAction.rangeAttack(4, endRange: 5).withAugment(ActionAugment(
                    condition: TargetHasEtherCondition(Ether.morph),
                    action: RoveAction.buff(BuffType.field, 0,
                            field: EtherField.miasma)
                        .withDescription(
                            'If the target has a [Morph] dice in their personal or infusion pools, gain [miasma]'))),
              ]),
            ],*/
        ),
      ],
      placements: [
        PlacementDef(
          name: 'Galeaper',
          c: 2,
          r: 7,
        ),
        PlacementDef(
          name: 'Galeaper',
          c: 6,
          r: 6,
          minPlayers: 4,
        ),
        PlacementDef(
          name: 'Galeaper',
          c: 9,
          r: 2,
        ),
        PlacementDef(
          name: 'Galeaper',
          c: 11,
          r: 10,
        ),
        PlacementDef(
          name: 'Galeaper',
          c: 12,
          r: 9,
        ),
        PlacementDef(
          name: 'Nahoot',
          c: 4,
          r: 4,
        ),
        PlacementDef(
          name: 'Nahoot',
          c: 7,
          r: 2,
        ),
        PlacementDef(
          name: 'Nahoot',
          c: 12,
          r: 4,
          minPlayers: 4,
        ),
        PlacementDef(
          name: 'Nahoot',
          c: 7,
          r: 9,
          minPlayers: 3,
        ),
        PlacementDef(
          name: 'Zaghan Nahadir',
          c: 10,
          r: 8,
          onSlain: [
            codex(22),
            victory(),
          ],
        ),
        PlacementDef(
          name: 'Galeaper',
          c: 8,
          r: 4,
          minPlayers: 3,
        ),
        PlacementDef(
            name: 'Hoard',
            type: PlacementType.object,
            c: 12,
            r: 1,
            onLoot: [
              codex(20),
              lyst('5*R'),
              item('Imbuing Potion',
                  body:
                      'The Rover that collected the hoard tile gains one “Imbuing Potion” item. They may equip this item. If they don’t have the required item slot(s) available, they may unequip items as needed.'),
              item('Tihfur Claw',
                  body:
                      'The Rover that collected the hoard tile gains one “Tihfur Claw” item. They may equip this item. If they don’t have the required item slot(s) available, they may unequip items as needed.'),
            ]),
        PlacementDef(
          name: 'wind',
          type: PlacementType.ether,
          c: 1,
          r: 7,
        ),
        PlacementDef(
          name: 'wind',
          type: PlacementType.ether,
          c: 8,
          r: 1,
        ),
      ],
      placementGroups: [
        PlacementGroupDef(name: 'Dark Conversion', placements: [
          PlacementDef(name: 'Nahoot', c: 11, r: 9),
        ])
      ]);

  static EncounterDef get encounter1dot4 => EncounterDef(
        questId: '1',
        number: '4',
        title: 'The River of Black Bile Flows',
        setup: EncounterSetup(
            box: '1/6',
            map: '9',
            adversary: '10-11',
            tiles: '2x Nektari Hives'),
        victoryDescription: 'Slay Hokmala.',
        lossDescription: 'Lose if Zeepurah is slain.',
        terrain: [
          dangerousPool(1),
          EncounterTerrain('nektari_hive',
              title: 'Nektari Hive',
              body: 'Nektari Hives are special objects and have R*2 [HP].'),
          EncounterTerrain('poison',
              title: 'Poisoned Water',
              body:
                  'An incredibly deadly river of poisonous sludge runs through the map. Poisoned water spaces have a white border and follow all the rules of open air spaces.'),
          etherWater(),
          etherMorph(),
        ],
        roundLimit: 8,
        baseLystReward: 10,
        campaignLink:
            '''Encounter 1.5 - “**There is Always a Bigger Beast**” [campaign] **24**.''',
        itemRewards: [
          'Tendervine Ward',
        ],
        challenges: [
          'Dekahas gain +2 [DEF].',
          'Zeepurah flips to “Eyes of the Dark” when within [Range] 1-3 of Hokmala.',
          'Replace Hokmala’s trait with: [React] After each turn where this unit suffers damage: Spawn R-1 galeapers in empty spaces within [Range] 1 of it.',
        ],
        dialogs: [
          introductionFromText('quest_1_encounter_4_intro'),
        ],
        onLoad: [
          dialog('Introduction'),
          rules('Champion of the Yanshif',
              'Zeepurah is a character ally to Rovers. She starts on the “Left of the Yanshif” side. At the start of the Rover Phase, if Zeepurah is within [Range] 1-3 of a [Morph] node, flip her ally card over to its “Eyes in the Dark” side, otherwise flip her ally card over to its “Left of Yanshif” side.'),
          codexLink('Marsh Mallow',
              number: 23,
              body:
                  '''The first time a Terranape is slain, read [title], [codex] 16.'''),
          codexLink('Not-So-Sweet Nektar',
              number: 24,
              body:
                  '''Each time a Nektari Hive is destroyed, read [title], [codex] 16.'''),
          codexLink('Midst of Black Waters',
              number: 25,
              body:
                  '''Immediately when Hokmala is slain, read [title], [codex] 16.'''),
        ],
        startingMap: MapDef(
          id: '1.4',
          columnCount: 13,
          rowCount: 11,
          backgroundRect: Rect.fromLTWH(110.0, 44.0, 1481.0, 1411.0),
          terrain: {
            (1, 0): TerrainType.barrier,
            (1, 1): TerrainType.barrier,
            (1, 8): TerrainType.object,
            (2, 0): TerrainType.barrier,
            (2, 3): TerrainType.difficult,
            (2, 9): TerrainType.object,
            (3, 2): TerrainType.difficult,
            (3, 3): TerrainType.dangerous,
            (3, 4): TerrainType.dangerous,
            (3, 8): TerrainType.dangerous,
            (3, 9): TerrainType.dangerous,
            (3, 10): TerrainType.openAir,
            (4, 2): TerrainType.object,
            (4, 3): TerrainType.dangerous,
            (4, 4): TerrainType.difficult,
            (4, 8): TerrainType.dangerous,
            (4, 9): TerrainType.openAir,
            (5, 0): TerrainType.start,
            (5, 9): TerrainType.openAir,
            (5, 10): TerrainType.openAir,
            (6, 0): TerrainType.start,
            (6, 8): TerrainType.difficult,
            (6, 9): TerrainType.openAir,
            (7, 0): TerrainType.start,
            (7, 4): TerrainType.difficult,
            (7, 9): TerrainType.openAir,
            (7, 10): TerrainType.openAir,
            (8, 0): TerrainType.start,
            (8, 2): TerrainType.difficult,
            (8, 3): TerrainType.dangerous,
            (8, 8): TerrainType.object,
            (8, 9): TerrainType.openAir,
            (9, 0): TerrainType.start,
            (9, 3): TerrainType.dangerous,
            (9, 4): TerrainType.dangerous,
            (9, 7): TerrainType.dangerous,
            (9, 8): TerrainType.dangerous,
            (9, 9): TerrainType.openAir,
            (9, 10): TerrainType.openAir,
            (10, 3): TerrainType.object,
            (10, 4): TerrainType.difficult,
            (10, 7): TerrainType.dangerous,
            (10, 8): TerrainType.openAir,
            (10, 9): TerrainType.openAir,
            (11, 0): TerrainType.barrier,
            (11, 1): TerrainType.barrier,
            (11, 8): TerrainType.openAir,
            (11, 9): TerrainType.openAir,
            (11, 10): TerrainType.openAir,
            (12, 0): TerrainType.barrier,
            (12, 6): TerrainType.object,
            (12, 8): TerrainType.openAir,
            (12, 9): TerrainType.openAir,
          },
        ),
        allies: [
          AllyDef(name: 'Zeepurah', cardId: 'A-012', behaviors: [
            EncounterFigureDef(
              name: 'Left of the Yanshif',
              health: 8,
              affinities: {
                Ether.fire: -1,
                Ether.earth: -1,
                Ether.water: 1,
                Ether.wind: 1,
              },
              abilities: [
                AbilityDef(name: 'Ability', actions: [
                  RoveAction(
                      type: RoveActionType.dash,
                      amount: 2,
                      targetKind: TargetKind.self,
                      exclusiveGroup: 1),
                  RoveAction(
                      type: RoveActionType.attack,
                      amount: 2,
                      range: (2, 3),
                      exclusiveGroup: 1),
                  RoveAction(
                      type: RoveActionType.jump,
                      amount: 3,
                      targetKind: TargetKind.self,
                      exclusiveGroup: 2),
                  RoveAction(
                      type: RoveActionType.heal,
                      amount: 2,
                      range: (0, 2),
                      exclusiveGroup: 2),
                ]),
              ],
              onSlain: [fail()],
              onStartPhase: [
                EncounterAction(conditions: [
                  PhaseCondition(RoundPhase.rover),
                  InRangeOfAny(range: (1, 3), targets: ['Morph'])
                ], type: EncounterActionType.toggleBehavior),
              ],
            ),
            EncounterFigureDef(
              name: 'Eyes in the Dark',
              health: 8,
              flies: true,
              affinities: {
                Ether.fire: -1,
                Ether.crux: -1,
                Ether.morph: 1,
                Ether.wind: 1,
              },
              abilities: [
                AbilityDef(
                  name: 'Ability',
                  actions: [
                    RoveAction.move(4),
                    RoveAction.meleeAttack(3),
                  ],
                ),
              ],
              onSlain: [fail()],
              onStartPhase: [
                EncounterAction(conditions: [
                  PhaseCondition(RoundPhase.rover),
                  InRangeOfNone(range: (1, 3), targets: ['Morph'])
                ], type: EncounterActionType.toggleBehavior),
              ],
            ),
          ]),
        ],
        overlays: [
          EncounterFigureDef(
            name: 'Nektari Hive',
            healthFormula: '2*R',
          ),
        ],
        adversaries: [
          EncounterFigureDef(
            name: 'Galeaper',
            letter: 'A',
            standeeCount: 8,
            health: 5,
            flies: true,
            affinities: const {
              Ether.fire: -1,
              Ether.earth: -1,
              Ether.wind: 1,
              Ether.morph: 1,
            },
/*              abilities: [
                AbilityDef(name: 'Gale Shot', actions: [
                  RoveAction.move(2),
                  RoveAction.rangeAttack(2, endRange: 2),
                ]),
                AbilityDef(name: 'Power Strike', actions: [
                  RoveAction.rangeAttack(1, endRange: 4, push: 2),
                ]),
                AbilityDef(name: 'Rending Swoop', actions: [
                  RoveAction.move(3),
                  RoveAction.meleeAttack(2, pierce: true),
                  RoveAction(
                      type: RoveActionType.dash,
                      amount: 2,
                      retreat: true,
                      requiresPrevious: true),
                ]),
                AbilityDef(name: 'Swarn Instinct', actions: [
                  RoveAction.move(4),
                  RoveAction.meleeAttack(3).withAugment(ActionAugment(
                      condition: AllyAdjacentToTargetAugmentCondition(),
                      action: RoveAction(
                          type: RoveActionType.buff,
                          buffType: BuffType.amount,
                          amount: 1,
                          staticDescription: RoveActionDescription(
                              body:
                                  'If at least one ally is adjacent to the target, gain +1 [DMG].'))))
                ]),
              ],*/
          ),
          EncounterFigureDef(
            name: 'Dekaha',
            letter: 'B',
            standeeCount: 6,
            health: 6,
            immuneToForcedMovement: true,
            affinities: const {
              Ether.fire: -2,
              Ether.wind: -1,
              Ether.earth: 1,
              Ether.water: 2,
            },
/*              abilities: [
                AbilityDef(name: 'Hydraulic Whip', actions: [
                  RoveAction.meleeAttack(2, endRange: 4, push: 2),
                ]),
                AbilityDef(name: 'Sap Trap', actions: [
                  RoveAction(
                      type: RoveActionType.createTrap,
                      amount: 2,
                      range: (1, 3),
                      staticDescription: RoveActionDescription(
                          body:
                              'Create one [DMG]2 trap in an empty space within [Range] 1-3, closest to the nearest enemy.')),
                ]),
                AbilityDef(name: 'Water Spout', actions: [
                  RoveAction.heal(2, endRange: 4),
                ]),
                AbilityDef(name: 'Draining Tendrils', actions: [
                  RoveAction.meleeAttack(2, endRange: 4),
                  RoveAction(
                      type: RoveActionType.heal,
                      amount: 2,
                      targetKind: TargetKind.self,
                      field: EtherField.aura,
                      requiresPrevious: true)
                ]),
              ],*/
          ),
          EncounterFigureDef(
              name: 'Terranape',
              letter: 'C',
              standeeCount: 2,
              health: 15,
              affinities: {
                Ether.wind: -1,
                Ether.earth: 2,
                Ether.fire: -2,
                Ether.morph: 1,
                Ether.water: 1,
              },
              traits: [
                'At the start of this unit\'s turn, it recovers [RCV] R-1.'
              ],
              /* abilities: [
                AbilityDef(name: 'Hammer Slam', actions: [
                  RoveAction.move(3),
                  RoveAction.meleeAttack(3).withAugment(ActionAugment(
                      condition: ActorHasHealthCondition('9-H'),
                      action: RoveAction.buff(BuffType.amount, 1).withDescription(
                          'If this unit has 9 or fewer [HP], gain +1 [DMG].')))
                ]),
                AbilityDef(name: 'Seismic Leap', actions: [
                  RoveAction.jump(4),
                  RoveAction.meleeAttack(2, targetCount: RoveAction.allTargets)
                      .withAugment(ActionAugment(
                          condition: ActorHasHealthCondition('9-H'),
                          action: RoveAction.buff(BuffType.endRange, 1)
                              .withDescription(
                                  'If this unit has 9 or fewer [HP], +1 [Range].')))
                ]),
                AbilityDef(name: 'Boulder Fling', actions: [
                  RoveAction.rangeAttack(4, endRange: 4).withAugment(ActionAugment(
                      condition: ActorHasHealthCondition('9-H'),
                      action: RoveAction.buff(BuffType.pierce, 0).withDescription(
                          'If this unit has 9 or fewer [HP], gain [pierce].')))
                ]),
                AbilityDef(name: 'Quake Stomp', actions: [
                  RoveAction.move(2),
                  RoveAction(
                          type: RoveActionType.attack,
                          amount: 3,
                          range: (1, 1),
                          aoe: AOEDef.x9Cone(),
                          targetCount: RoveAction.allTargets)
                      .withAugment(ActionAugment(
                          condition: ActorHasHealthCondition('9-H'),
                          action: RoveAction.buff(BuffType.push, 2).withDescription(
                              'If this unit has 9 or fewer [HP], gain [Push] 2.')))
                ]),
              ], */
              reactions: [
                EnemyReactionDef(
                    trigger: ReactionTriggerDef(
                        type: RoveEventType.startTurn,
                        targetKind: TargetKind.self),
                    actions: [
                      RoveAction.heal(2, targetKind: TargetKind.self),
                    ]),
              ],
              onSlain: [
                codex(23),
              ]),
          EncounterFigureDef(
              name: 'Hokmala',
              letter: 'D',
              standeeCount: 3,
              type: AdversaryType.miniboss,
              healthFormula: '10*R',
              defense: 1,
              traits: const [
                '''[React] After the turn where this unit suffers damage for the first time: 

Spawn R-1 galeapers in empty spaces within [Range] 1 of it.'''
              ],
              affinities: const {
                Ether.fire: -1,
                Ether.crux: -1,
                Ether.earth: 2,
                Ether.water: 2,
              },
/*              abilities: [
                AbilityDef(name: 'Soothing Pollen', actions: [
                  RoveAction.jump(2),
                  RoveAction(
                      type: RoveActionType.heal,
                      amount: 2,
                      range: (0, 4),
                      targetCount: 2,
                      field: EtherField.aura)
                ]),
                AbilityDef(name: 'Toxic Spores', actions: [
                  RoveAction(
                      type: RoveActionType.attack,
                      amount: 2,
                      range: (2, 4),
                      pierce: true,
                      targetCount: 2)
                ]),
                AbilityDef(name: 'Verdant Cleave', actions: [
                  RoveAction.move(4),
                  RoveAction(
                      type: RoveActionType.attack,
                      amount: 3,
                      range: (1, 1),
                      aoe: AOEDef.x4Cleave(),
                      targetCount: RoveAction.allTargets)
                ]),
                AbilityDef(name: 'Creeping Roots', actions: [
                  RoveAction.move(4),
                  RoveAction(
                      type: RoveActionType.attack,
                      amount: 4,
                      range: (1, 1),
                      field: EtherField.snapfrost),
                ]),
              ], */
              reactions: [
                EnemyReactionDef(
                    title: 'Hokmala.spawn',
                    limit: 1,
                    trigger: ReactionTriggerDef(
                        type: RoveEventType.endTurn,
                        condition: SufferedDamageThisTurnCondition()),
                    actions: [
                      RoveAction(
                          type: RoveActionType.spawn,
                          object: 'Galeaper',
                          amountFormula: 'R-1',
                          range: (1, 1))
                    ])
              ]),
          EncounterFigureDef(
            name: 'Nektari Swarm',
            letter: 'E',
            standeeCount: 8,
            health: 1,
            flies: true,
            affinities: const {
              Ether.morph: -1,
              Ether.water: -1,
              Ether.earth: 1,
              Ether.crux: 1,
            },
/*              abilities: [
                AbilityDef(name: 'Revenge Swarn', actions: [
                  RoveAction.move(3),
                  RoveAction.meleeAttack(1, pierce: true),
                ]),
                AbilityDef(name: 'Pollen Burst', actions: [
                  RoveAction.move(4),
                  RoveAction.heal(1,
                      startRange: 1,
                      endRange: 1,
                      targetCount: RoveAction.allTargets)
                ]),
                AbilityDef(name: 'Catalytic Sting', actions: [
                  RoveAction.move(3),
                  RoveAction.meleeAttack(1, field: EtherField.wildfire)
                ]),
                AbilityDef(name: '47 Vibrations', actions: [
                  RoveAction.move(3),
                  RoveAction.meleeAttack(1).withAugment(ActionAugment(
                      condition: AllyAdjacentToTargetAugmentCondition(),
                      action: RoveAction(
                          type: RoveActionType.buff,
                          buffType: BuffType.amount,
                          amount: 1,
                          staticDescription: RoveActionDescription(
                              body:
                                  'If at least one ally is adjacent to the target, gain +1 [DMG].'))))
                ]),
              ],*/
          ),
        ],
        placements: [
          PlacementDef(name: 'Galeaper', c: 1, r: 6),
          PlacementDef(name: 'Galeaper', c: 3, r: 5),
          PlacementDef(name: 'Galeaper', c: 4, r: 6),
          PlacementDef(name: 'Galeaper', c: 6, r: 7, minPlayers: 3),
          PlacementDef(name: 'Dekaha', c: 2, r: 3, minPlayers: 3),
          PlacementDef(name: 'Dekaha', c: 4, r: 4),
          PlacementDef(name: 'Dekaha', c: 10, r: 4, minPlayers: 3),
          PlacementDef(name: 'Dekaha', c: 7, r: 4),
          PlacementDef(name: 'Hokmala', c: 6, r: 8, onSlain: [
            codex(25),
            victory(),
          ]),
          PlacementDef(name: 'Terranape', c: 2, r: 8, minPlayers: 4),
          PlacementDef(name: 'Terranape', c: 12, r: 4),
          PlacementDef(
              name: 'Nektari Hive',
              type: PlacementType.object,
              c: 1,
              r: 8,
              onSlain: [
                codex(24),
                lyst('5*R'),
                item('Captured Anima',
                    body:
                        'The Rover that destroyed the Nektari Hive gains one “Captured Anima” item. They may equip this item. If they don’t have the required item slot(s) available, they may unequip items as needed.'),
                placementGroup('Not-So-Sweet Nektar (Left)',
                    body:
                        'Spawn R nektari swarms within [Range] 0-1 of the destroyed hive.')
              ]),
          PlacementDef(
              name: 'Nektari Hive',
              type: PlacementType.object,
              c: 12,
              r: 6,
              onSlain: [
                codex(24),
                lyst('5*R'),
                item('Captured Anima',
                    body:
                        'The Rover that destroyed the Nektari Hive gains one “Captured Anima” item. They may equip this item. If they don’t have the required item slot(s) available, they may unequip items as needed.'),
                placementGroup('Not-So-Sweet Nektar (Right)',
                    body:
                        'Spawn R nektari swarms within [Range] 0-1 of the destroyed hive.')
              ]),
          PlacementDef(name: 'water', type: PlacementType.ether, c: 4, r: 2),
          PlacementDef(name: 'water', type: PlacementType.ether, c: 10, r: 3),
          PlacementDef(name: 'morph', type: PlacementType.ether, c: 2, r: 9),
          PlacementDef(name: 'morph', type: PlacementType.ether, c: 8, r: 8),
        ],
        placementGroups: const [
          PlacementGroupDef(name: 'Not-So-Sweet Nektar (Left)', placements: [
            PlacementDef(name: 'Nektari Swarm', c: 1, r: 8),
            PlacementDef(name: 'Nektari Swarm', c: 1, r: 8),
            PlacementDef(name: 'Nektari Swarm', c: 1, r: 8, minPlayers: 3),
            PlacementDef(name: 'Nektari Swarm', c: 1, r: 8, minPlayers: 4),
          ]),
          PlacementGroupDef(name: 'Not-So-Sweet Nektar (Right)', placements: [
            PlacementDef(name: 'Nektari Swarm', c: 12, r: 6),
            PlacementDef(name: 'Nektari Swarm', c: 12, r: 6),
            PlacementDef(name: 'Nektari Swarm', c: 12, r: 6, minPlayers: 3),
            PlacementDef(name: 'Nektari Swarm', c: 12, r: 6, minPlayers: 4),
          ])
        ],
      );

  static EncounterDef get encounter1dot5 => EncounterDef(
        questId: '1',
        number: '5',
        title: 'There Is Always a Bigger Beast',
        setup: EncounterSetup(
            box: '1/6',
            map: '10',
            adversary: '12-13',
            tiles: '6x Bursting Bells, 4x Nektari Hives'),
        victoryDescription: 'Slay the Ahma.',
        lossDescription: 'Lose if Zeepurah is slain.',
        terrain: [
          EncounterTerrain('dangerous_polluted_pool',
              title: 'Polluted Pool',
              damage: 1,
              body:
                  'Non-flying units that enter a polluted pool space suffer [DMG] 1.'),
          EncounterTerrain('trap_bursting_bell',
              title: 'Bursting Bell Trap',
              damage: 2,
              body: 'Units that trigger Bursting Bell traps suffer [DMG] 2.'),
          EncounterTerrain('nektari_hive',
              title: 'Corrupted Nektari Hive',
              body:
                  'Corrupted Nektari Hives are special objects and have R [HP].'),
          etherMorph(),
        ],
        roundLimit: 6,
        baseLystReward: 25,
        itemRewards: [
          'Ahma Cowl',
        ],
        unlocksRoverLevel: 4,
        unlocksShopLevel: 2,
        milestone: CampaignMilestone.milestone1dot5,
        campaignLink: '''Chapter 2 - “A Choice”, [campaign] 38.''',
        challenges: [
          'The Ahma gains +2 movement points to all of their movement actions.',
          'Add R [Morph] dice to the map, evenly distributed amongst ether nodes. Rover movement actions can not remove more than one dice from an ether node per action.',
          'When the Ahma Corrupter is defeated, Zeepurah is injured. Return her to the nearest [start] space. Zeepurah can no longer perform [Dash] or [Jump] actions.',
        ],
        dialogs: [introductionFromText('quest_1_encounter_5_intro')],
        onLoad: [
          dialog('Introduction'),
          rules('2 Phase Encounter',
              'This is a 2 phase encounter. Each phase has its own round limit.'),
          rules('Deep-Rooted Corruption',
              '''The Ahma uses the Ahma Corrupter statistic block.

The Corrupted Nektari Hives are guarding the [Morph] nodes.

There are several Corrupted Nektari Hives throughout the map. For 2 Rovers, there are Corrupted Nektari Hives at spaces [A] and [B]. For 3 Rovers there is also a Corrupted Nektari Hive at [C], and for 4 Rovers there is another Corrupted Nektari Hive at [D].

Rovers can not take the [Morph] dice from ether nodes that have a Corrupted Nektari Hive within [Range] 1. Destroy Corrupted Nektari Hives so you can then take the [Morph] dice. Try to take as many [Morph] dice as you can before defeating the Ahma.'''),
          rules('Champion of the Yanshif',
              'Zeepurah is a character ally to Rovers. At the start of the Rover Phase, if Zeepurah is within [Range] 1-3 of any nahoot, nahadir, or Ahma, or if Zeepurah is within [Range] 1-3 of a [Morph] node, flip her ally card over to its “Eyes in the Dark” side, otherwise flip her ally card over to its “Left of Yanshif” side.'),
          codexLink('Just Desserts',
              number: 26,
              body:
                  '''Each time a Corrupted Nektari Hive is destroyed, read [title], [codex] 17.'''),
          codexLink('Taste of Morphic Paradise',
              number: 27,
              body:
                  '''Immediately after the turn where the Ahma Corrupter is defeated, read [title], [codex] 17.'''),
        ],
        startingMap: MapDef(
          id: '1.5',
          columnCount: 13,
          rowCount: 11,
          backgroundRect: Rect.fromLTWH(110.0, 44.0, 1481.0, 1411.0),
          terrain: {
            (0, 0): TerrainType.object,
            (0, 2): TerrainType.dangerous,
            (0, 3): TerrainType.dangerous,
            (0, 4): TerrainType.difficult,
            (0, 9): TerrainType.dangerous,
            (1, 0): TerrainType.difficult,
            (1, 3): TerrainType.dangerous,
            (1, 4): TerrainType.object,
            (1, 5): TerrainType.difficult,
            (1, 9): TerrainType.dangerous,
            (1, 10): TerrainType.dangerous,
            (2, 4): TerrainType.object,
            (2, 8): TerrainType.object,
            (2, 9): TerrainType.object,
            (3, 0): TerrainType.start,
            (3, 9): TerrainType.dangerous,
            (3, 10): TerrainType.dangerous,
            (4, 9): TerrainType.dangerous,
            (5, 0): TerrainType.start,
            (5, 5): TerrainType.difficult,
            (5, 10): TerrainType.object,
            (6, 0): TerrainType.start,
            (6, 4): TerrainType.difficult,
            (6, 5): TerrainType.object,
            (7, 0): TerrainType.start,
            (7, 10): TerrainType.object,
            (8, 9): TerrainType.dangerous,
            (9, 0): TerrainType.start,
            (9, 2): TerrainType.difficult,
            (9, 9): TerrainType.dangerous,
            (9, 10): TerrainType.dangerous,
            (10, 0): TerrainType.dangerous,
            (10, 1): TerrainType.object,
            (10, 2): TerrainType.difficult,
            (10, 5): TerrainType.dangerous,
            (10, 8): TerrainType.object,
            (10, 9): TerrainType.object,
            (11, 0): TerrainType.dangerous,
            (11, 1): TerrainType.dangerous,
            (11, 2): TerrainType.object,
            (11, 5): TerrainType.dangerous,
            (11, 6): TerrainType.dangerous,
            (11, 9): TerrainType.dangerous,
            (11, 10): TerrainType.dangerous,
            (12, 0): TerrainType.object,
            (12, 1): TerrainType.object,
            (12, 9): TerrainType.dangerous,
          },
        ),
        allies: [
          AllyDef(name: 'Zeepurah', cardId: 'A-012', behaviors: [
            EncounterFigureDef(
              name: 'Left of the Yanshif',
              health: 8,
              affinities: {
                Ether.fire: -1,
                Ether.earth: -1,
                Ether.water: 1,
                Ether.wind: 1,
              },
              abilities: [
                AbilityDef(name: 'Ability', actions: [
                  RoveAction(
                      type: RoveActionType.dash,
                      amount: 2,
                      targetKind: TargetKind.self,
                      exclusiveGroup: 1),
                  RoveAction(
                      type: RoveActionType.attack,
                      amount: 2,
                      range: (2, 3),
                      exclusiveGroup: 1),
                  RoveAction(
                      type: RoveActionType.jump,
                      amount: 3,
                      targetKind: TargetKind.self,
                      exclusiveGroup: 2),
                  RoveAction(
                      type: RoveActionType.heal,
                      amount: 2,
                      range: (0, 2),
                      exclusiveGroup: 2),
                ]),
              ],
              onSlain: [fail()],
              onStartPhase: [
                EncounterAction(conditions: [
                  PhaseCondition(RoundPhase.rover),
                  InRangeOfAny(range: (
                    1,
                    3
                  ), targets: [
                    'Nahoot',
                    'Nahadir',
                    'Morph',
                    'Ahma Corrupter',
                    'Ahma Wretched'
                  ])
                ], type: EncounterActionType.toggleBehavior),
              ],
            ),
            EncounterFigureDef(
              name: 'Eyes in the Dark',
              health: 8,
              flies: true,
              affinities: {
                Ether.fire: -1,
                Ether.crux: -1,
                Ether.morph: 1,
                Ether.wind: 1,
              },
              abilities: [
                AbilityDef(
                  name: 'Ability',
                  actions: [
                    RoveAction.move(4),
                    RoveAction.meleeAttack(3),
                  ],
                ),
              ],
              onSlain: [fail()],
              onStartPhase: [
                EncounterAction(conditions: [
                  PhaseCondition(RoundPhase.rover),
                  InRangeOfNone(range: (
                    1,
                    3
                  ), targets: [
                    'Nahoot',
                    'Nahadir',
                    'Morph',
                    'Ahma Corrupter',
                    'Ahma Wretched'
                  ])
                ], type: EncounterActionType.toggleBehavior),
              ],
            ),
          ]),
        ],
        overlays: [
          EncounterFigureDef(
              name: 'Nektari Hive',
              alias: 'Corrupted Nektari Hive',
              healthFormula: 'R',
              reactions: [
                EnemyReactionDef(
                    title: 'Just Desserts',
                    body:
                        'Spawn R corrupted nektari swarms within [Range] 0-1 of the destroyed hive.',
                    trigger: ReactionTriggerDef(
                        type: RoveEventType.afterSlain,
                        targetKind: TargetKind.self),
                    actions: [
                      RoveAction(
                          type: RoveActionType.spawn,
                          object: 'Corrupted Nektari Swarm',
                          amountFormula: 'R',
                          range: (0, 1))
                    ])
              ],
              onSlain: [
                codex(26),
              ])
        ],
        adversaries: [
          EncounterFigureDef(
            name: 'Dekaha',
            letter: 'A',
            standeeCount: 6,
            health: 6,
            immuneToForcedMovement: true,
            affinities: const {
              Ether.fire: -2,
              Ether.wind: -1,
              Ether.earth: 1,
              Ether.water: 2,
            },
/*              abilities: [
                AbilityDef(name: 'Hydraulic Whip', actions: [
                  RoveAction.meleeAttack(2, endRange: 4, push: 2),
                ]),
                AbilityDef(name: 'Sap Trap', actions: [
                  RoveAction(
                      type: RoveActionType.createTrap,
                      amount: 2,
                      range: (1, 3),
                      staticDescription: RoveActionDescription(
                          body:
                              'Create one [DMG]2 trap in an empty space within [Range] 1-3, closest to the nearest enemy.')),
                ]),
                AbilityDef(name: 'Water Spout', actions: [
                  RoveAction.heal(2, endRange: 4),
                ]),
                AbilityDef(name: 'Draining Tendrils', actions: [
                  RoveAction.meleeAttack(2, endRange: 4),
                  RoveAction(
                      type: RoveActionType.heal,
                      amount: 2,
                      targetKind: TargetKind.self,
                      field: EtherField.aura,
                      requiresPrevious: true)
                ]),
              ],*/
          ),
          EncounterFigureDef(
              name: 'Nahoot',
              letter: 'B',
              standeeCount: 7,
              health: 12,
              affinities: {
                Ether.crux: -1,
                Ether.fire: -1,
                Ether.morph: 2,
                Ether.wind: 1,
              },
              traits: [
                'If a Rover slays this unit, that Rover [plus_wind_morph].'
              ],
              /* abilities: [
                AbilityDef(name: 'Miasmic Arrow', actions: [
                  RoveAction.move(2),
                  RoveAction(
                      type: RoveActionType.attack,
                      amount: 2,
                      range: (2, 3),
                      field: EtherField.miasma)
                ]),
                AbilityDef(name: 'Morphic Agitation', actions: [
                  RoveAction.jump(4),
                  RoveAction.meleeAttack(3).withAugment(ActionAugment(
                      condition: TargetHasEtherCondition(Ether.morph),
                      action: RoveAction.heal(2, targetKind: TargetKind.self)
                          .withDescription(
                              'If the target has a [Morph] dice in their personal or infusion pools, recover [RCV] 2.')))
                ]),
                AbilityDef(name: 'Split Strike', actions: [
                  RoveAction.move(3),
                  RoveAction(
                      type: RoveActionType.attack,
                      amount: 2,
                      range: (2, 2),
                      targetCount: 2)
                ]),
                AbilityDef(name: 'Visceral Frenzy', actions: [
                  RoveAction.meleeAttack(3),
                  RoveAction.jump(4),
                  RoveAction.meleeAttack(2)
                ]),
              ],*/
              onSlain: [
                EncounterAction(
                    type: EncounterActionType.rewardEther,
                    value:
                        Ether.etherOptionsToString([Ether.wind, Ether.morph])),
              ]),
          EncounterFigureDef(
            name: 'Nahadir',
            letter: 'C',
            standeeCount: 4,
            health: 12,
            flies: true,
            affinities: {
              Ether.morph: 2,
              Ether.wind: 1,
              Ether.fire: -1,
              Ether.crux: -1,
            },
            /* abilities: [
                AbilityDef(name: 'Morphic Crush', actions: [
                  RoveAction.move(4),
                  RoveAction.meleeAttack(3, endRange: 2).withAugment(ActionAugment(
                      condition: TargetHasEtherCondition(Ether.morph),
                      action: RoveAction.buff(BuffType.amount, 2).withDescription(
                          'If the target has a [Morph] dice in their personal or infusion pools, gain +2 [DMG].'))),
                ]),
                AbilityDef(name: 'Ariose Incantation', actions: [
                  RoveAction.move(4),
                  RoveAction(
                      type: RoveActionType.heal,
                      amount: 2,
                      range: (0, 3),
                      targetKind: TargetKind.self,
                      field: EtherField.aura),
                  RoveAction(
                      type: RoveActionType.heal,
                      amount: 2,
                      range: (0, 3),
                      targetKind: TargetKind.ally,
                      field: EtherField.aura),
                ]),
                AbilityDef(name: 'Debase Form', actions: [
                  RoveAction.move(3),
                  RoveAction.meleeAttack(3),
                  RoveAction(
                          type: RoveActionType.transformEther,
                          object: Ether.morph.toJson(),
                          targetMode: RoveActionTargetMode.previous,
                          requiresPrevious: true)
                      .withDescription(
                          'The target must change one non-[Morph] dice in their personal pool into a [Morph] dice, if able to.')
                ]),
                AbilityDef(name: 'Bell Tolls', actions: [
                  RoveAction.move(2),
                  RoveAction.rangeAttack(3, endRange: 3).withAugment(ActionAugment(
                      condition: TargetHasEtherCondition(Ether.morph),
                      action: RoveAction.buff(BuffType.field, 0,
                              field: EtherField.miasma)
                          .withDescription(
                              'If the target has a [Morph] dice in their personal or infusion pools, gain [miasma]'))),
                ]),
              ],*/
          ),
          EncounterFigureDef(
              name: 'Ahma',
              alias: 'Ahma Corrupter',
              letter: 'D',
              standeeCount: 1,
              type: AdversaryType.boss,
              healthFormula: '15*R',
              large: true,
              affinities: {
                Ether.crux: -1,
                Ether.fire: -1,
                Ether.wind: 1,
                Ether.water: 1,
                Ether.morph: 2,
              },
              traits: [
                '''Adversaries treat their own [miasma] as:
                
[+1 [DMG] || You suffer [DMG]1.]'''
              ],
              miasmaEffect: FieldEffect(
                  appliesToAllEnemies: true,
                  buff: RoveBuff(type: BuffType.attack, amount: 1),
                  action: RoveAction(
                      type: RoveActionType.suffer,
                      amount: 1,
                      targetKind: TargetKind.self)),
              /* abilities: [
                AbilityDef(name: 'Caustic Rend', actions: [
                  RoveAction.move(3),
                  RoveAction.meleeAttack(3, field: EtherField.miasma),
                  RoveAction(
                          type: RoveActionType.transformEther,
                          object: Ether.morph.toJson(),
                          targetMode: RoveActionTargetMode.previous,
                          requiresPrevious: true)
                      .withDescription(
                          'The target must change one non-[Morph] dice in their personal pool into a [Morph] dice, if able to.')
                ]),
                AbilityDef(name: 'Pinion Haze', actions: [
                  RoveAction.jump(3),
                  RoveAction(
                      type: RoveActionType.attack,
                      amount: 2,
                      aoe: AOEDef.x6Breath(),
                      targetCount: RoveAction.allTargets,
                      push: 2),
                  RoveAction(
                      type: RoveActionType.jump,
                      amount: 2,
                      retreat: true,
                      requiresPrevious: true)
                ]),
                AbilityDef(name: 'Foul Thirst', actions: [
                  RoveAction.move(5),
                  RoveAction.meleeAttack(3),
                  RoveAction(
                      type: RoveActionType.heal,
                      amount: 2,
                      field: EtherField.miasma,
                      targetKind: TargetKind.self,
                      requiresPrevious: true)
                ]),
                AbilityDef(name: 'Horrifying Screech', actions: [
                  RoveAction.jump(4),
                  RoveAction(
                      type: RoveActionType.attack,
                      amount: 1,
                      range: (1, 2),
                      targetCount: RoveAction.allTargets,
                      pierce: true,
                      pushFormula: 'R'),
                  RoveAction(
                      type: RoveActionType.dash,
                      amount: 3,
                      requiresPrevious: true,
                      modifiers: const [
                        TargetFarthestModifier()
                      ]).withSuffix(
                      'Logic: Wants to move toward the enemy with the fewest [HP].')
                ])
              ], */
              onSlain: [
                removeRule('2 Phase Encounter'),
                removeRule('Deep-Rooted Corruption'),
                codex(27),
                rules('Black Grove',
                    '''The Ahma has consumed all the corruption in the environment.

The Ahma now uses the Ahma Wretched statistic block, recovering its current [HP] to maximum. Move the Ahma Corrupter ability token to the same ability number on the Ahma Wretched statistic block.

Remove all [Morph] dice from all [Morph] nodes and place them on the Ahma Wretched statistic block.'''),
                replace('Ahma Wretched', silent: true),
                milestone('_phase_1_end'),
                resetRound(
                    title: 'Phase 2',
                    body:
                        'The round limit has been reset. You have 6 rounds to defeat the Ahma Wretched.'),
              ]),
          EncounterFigureDef(
              name: 'Ahma Wretched',
              letter: 'D',
              type: AdversaryType.boss,
              standeeCount: 1,
              healthFormula: '15*R',
              large: true,
              possibleTokens: List.generate(5, (_) => Ether.morph.toJson()),
              affinities: {
                Ether.crux: -2,
                Ether.fire: -1,
                Ether.wind: 1,
                Ether.water: 2,
                Ether.morph: 2,
              },
              traits: [
                'Adversaries treat their own [miasma] as: [+2 [DMG] || You suffer [DMG]1.]',
                'Where X equals the number of [Morph] dice on this statistic block.'
              ],
              xDefinition: 'count_token(morph)',
              miasmaEffect: FieldEffect(
                  appliesToAllEnemies: true,
                  buff: RoveBuff(type: BuffType.attack, amount: 1),
                  action: RoveAction(
                      type: RoveActionType.suffer,
                      amount: 1,
                      targetKind: TargetKind.self)),
              /* abilities: [
                AbilityDef(name: 'Change Within', actions: [
                  RoveAction.move(3),
                  RoveAction(
                      type: RoveActionType.attack,
                      amountFormula: '2+X',
                      range: (1, 1),
                      field: EtherField.miasma),
                  RoveAction(
                          type: RoveActionType.transformEther,
                          object: Ether.morph.toJson(),
                          targetMode: RoveActionTargetMode.previous,
                          requiresPrevious: true)
                      .withDescription(
                          'The target must change one non-[Morph] dice in their personal pool into a [Morph] dice, if able to.')
                ]),
                AbilityDef(name: 'Out With the Old', actions: [
                  RoveAction.jump(3),
                  RoveAction(
                      type: RoveActionType.attack,
                      amount: 2,
                      aoe: AOEDef.x6Breath(),
                      targetCount: RoveAction.allTargets,
                      pushFormula: '2+X'),
                  RoveAction(
                      type: RoveActionType.jump,
                      amount: 2,
                      retreat: true,
                      requiresPrevious: true)
                ]),
                AbilityDef(name: 'In With the New', actions: [
                  RoveAction.move(5),
                  RoveAction.meleeAttack(3),
                  RoveAction(
                      type: RoveActionType.heal,
                      amountFormula: '2+X',
                      field: EtherField.miasma,
                      targetKind: TargetKind.self,
                      requiresPrevious: true)
                ]),
                AbilityDef(name: 'Drastic Changes', actions: [
                  RoveAction.jump(4),
                  RoveAction(
                      type: RoveActionType.attack,
                      amount: 1,
                      range: (1, 2),
                      targetCount: RoveAction.allTargets,
                      pierce: true,
                      pushFormula: 'R'),
                  RoveAction(
                      type: RoveActionType.dash,
                      amount: 3,
                      requiresPrevious: true,
                      modifiers: const [
                        TargetFarthestModifier()
                      ]).withSuffix(
                      'Logic: Wants to move toward the enemy with the fewest [HP].')
                ])
              ], */
              onSlain: [
                codex(28),
                victory(),
                codex(29),
              ]),
          EncounterFigureDef(
            name: 'Corrupted Nektari Swarm',
            letter: 'E',
            standeeCount: 8,
            health: 1,
            flies: true,
            affinities: const {
              Ether.crux: -2,
              Ether.water: -1,
              Ether.wind: 1,
              Ether.morph: 1,
            },
/*              abilities: [
                AbilityDef(name: 'Revenge Swarn', actions: [
                  RoveAction.move(3),
                  RoveAction.meleeAttack(1, pierce: true),
                ]),
                AbilityDef(name: 'Corrupting Pollen', actions: [
                  RoveAction.move(4),
                  RoveAction.meleeAttack(1,
                      field: EtherField.miasma,
                      targetCount: RoveAction.allTargets)
                ]),
                AbilityDef(name: 'Catalytic Sting', actions: [
                  RoveAction.move(3),
                  RoveAction.meleeAttack(1, field: EtherField.wildfire)
                ]),
                AbilityDef(name: '47 Vibrations', actions: [
                  RoveAction.move(3),
                  RoveAction.meleeAttack(1).withAugment(ActionAugment(
                      condition: AllyAdjacentToTargetAugmentCondition(),
                      action: RoveAction(
                          type: RoveActionType.buff,
                          buffType: BuffType.amount,
                          amount: 1,
                          staticDescription: RoveActionDescription(
                              body:
                                  'If at least one ally is adjacent to the target, gain +1 [DMG].'))))
                ]),
              ],*/
          ),
        ],
        placements: [
          PlacementDef(name: 'Dekaha', c: 1, r: 5),
          PlacementDef(name: 'Dekaha', c: 10, r: 2),
          PlacementDef(name: 'Nahoot', c: 7, r: 5, minPlayers: 4),
          PlacementDef(name: 'Nahoot', c: 4, r: 8),
          PlacementDef(name: 'Nahadir', c: 5, r: 6, minPlayers: 3),
          PlacementDef(name: 'Nahadir', c: 8, r: 8),
          PlacementDef(name: 'Ahma', c: 6, r: 8),
          PlacementDef(
              key: 'nektari_hive_2_4',
              name: 'Nektari Hive',
              type: PlacementType.object,
              c: 2,
              r: 4),
          PlacementDef(
              name: 'Nektari Hive',
              key: 'nektari_hive_2_8',
              type: PlacementType.object,
              c: 2,
              r: 8,
              minPlayers: 4),
          PlacementDef(
              name: 'Nektari Hive',
              key: 'nektari_hive_10_8',
              type: PlacementType.object,
              c: 10,
              r: 8),
          PlacementDef(
              name: 'Nektari Hive',
              key: 'nektari_hive_11_2',
              type: PlacementType.object,
              c: 11,
              r: 2,
              minPlayers: 3),
          PlacementDef(
              name: 'Bursting Bell',
              type: PlacementType.trap,
              c: 2,
              r: 3,
              trapDamage: 2),
          PlacementDef(
              name: 'Bursting Bell',
              type: PlacementType.trap,
              c: 1,
              r: 1,
              trapDamage: 2),
          PlacementDef(
              name: 'Bursting Bell',
              type: PlacementType.trap,
              c: 5,
              r: 4,
              trapDamage: 2),
          PlacementDef(
              name: 'Bursting Bell',
              type: PlacementType.trap,
              c: 12,
              r: 2,
              trapDamage: 2),
          PlacementDef(
              name: 'Bursting Bell',
              type: PlacementType.trap,
              c: 12,
              r: 8,
              trapDamage: 2),
          PlacementDef(
              name: 'Bursting Bell',
              type: PlacementType.trap,
              c: 0,
              r: 8,
              trapDamage: 2),
          PlacementDef(
              name: 'morph',
              type: PlacementType.ether,
              c: 2,
              r: 9,
              unlockCondition: IsSlainCondition('nektari_hive_2_8'),
              onMilestone: {
                '_phase_1_end': [
                  EncounterAction(
                      type: EncounterActionType.giveTo, value: 'Ahma Wretched')
                ]
              }),
          PlacementDef(
              name: 'morph',
              type: PlacementType.ether,
              c: 1,
              r: 4,
              unlockCondition: IsSlainCondition('nektari_hive_2_4'),
              onMilestone: {
                '_phase_1_end': [
                  EncounterAction(
                      type: EncounterActionType.giveTo, value: 'Ahma Wretched')
                ]
              }),
          PlacementDef(
              name: 'morph',
              type: PlacementType.ether,
              c: 10,
              r: 1,
              unlockCondition: IsSlainCondition('nektari_hive_11_2'),
              onMilestone: {
                '_phase_1_end': [
                  EncounterAction(
                      type: EncounterActionType.giveTo, value: 'Ahma Wretched')
                ]
              }),
          PlacementDef(
              name: 'morph',
              type: PlacementType.ether,
              c: 10,
              r: 9,
              unlockCondition: IsSlainCondition('nektari_hive_10_8'),
              onMilestone: {
                '_phase_1_end': [
                  EncounterAction(
                      type: EncounterActionType.giveTo, value: 'Ahma Wretched')
                ]
              }),
          PlacementDef(
              name: 'morph',
              type: PlacementType.ether,
              c: 6,
              r: 5,
              onMilestone: {
                '_phase_1_end': [
                  EncounterAction(
                      type: EncounterActionType.giveTo, value: 'Ahma Wretched')
                ]
              }),
        ],
      );
}
