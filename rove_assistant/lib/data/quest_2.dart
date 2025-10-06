import 'dart:ui';

import 'encounter_def_utils.dart';
import 'package:rove_data_types/rove_data_types.dart';

extension Quest2 on EncounterDef {
  static EncounterDef get encounter2dot1 => EncounterDef(
        questId: '2',
        number: '1',
        title: 'Rolling the Top',
        setup: EncounterSetup(box: '2/5', map: '11', adversary: '14'),
        victoryDescription: 'Slay the Gruv.',
        terrain: [
          etherEarth(),
        ],
        roundLimit: 8,
        baseLystReward: 10,
        itemRewards: const ['Gruv Scale-Mail'],
        campaignLink:
            '''Encounter 2.2 - “**A Visit to a Mine**”, [campaign] **30**.''',
        challenges: const [
          'Before a zinix is slain, all of their allies within [Range] 1 of them recover [RCV] 1.',
          'The gruv’s ability token starts on their "Power Dive" ability.',
          'Kifa gain +1 movement point to all of their movement actions.',
        ],
        dialogs: [introductionFromText('quest_2_encounter_1_intro')],
        onLoad: [
          dialog('Introduction'),
          codexLink('The Bush is the Obstacle',
              number: 30,
              body:
                  '''The first time a Zinix is slain, read [title], [codex] 19.'''),
          codexLink('Dust Endures no Restraint',
              number: 31,
              body:
                  '''Immediately when the gruv is slain, read [title], [codex] 19.'''),
        ],
        startingMap: MapDef(
          id: '2.1',
          columnCount: 13,
          rowCount: 11,
          backgroundRect: Rect.fromLTWH(71, 26, 1593 - 71, 1475 - 26),
          terrain: {
            (0, 2): TerrainType.openAir,
            (0, 3): TerrainType.openAir,
            (0, 4): TerrainType.openAir,
            (0, 5): TerrainType.openAir,
            (0, 6): TerrainType.openAir,
            (0, 7): TerrainType.openAir,
            (0, 8): TerrainType.openAir,
            (0, 9): TerrainType.openAir,
            (1, 3): TerrainType.openAir,
            (1, 4): TerrainType.openAir,
            (1, 5): TerrainType.openAir,
            (1, 6): TerrainType.openAir,
            (1, 7): TerrainType.openAir,
            (1, 8): TerrainType.openAir,
            (1, 9): TerrainType.openAir,
            (1, 10): TerrainType.openAir,
            (2, 3): TerrainType.openAir,
            (2, 4): TerrainType.openAir,
            (2, 5): TerrainType.openAir,
            (2, 6): TerrainType.openAir,
            (2, 7): TerrainType.openAir,
            (2, 8): TerrainType.openAir,
            (2, 9): TerrainType.openAir,
            (3, 4): TerrainType.openAir,
            (3, 5): TerrainType.openAir,
            (3, 6): TerrainType.openAir,
            (3, 7): TerrainType.openAir,
            (3, 8): TerrainType.openAir,
            (3, 9): TerrainType.openAir,
            (3, 10): TerrainType.openAir,
            (9, 4): TerrainType.openAir,
            (9, 5): TerrainType.openAir,
            (9, 6): TerrainType.openAir,
            (9, 7): TerrainType.openAir,
            (9, 8): TerrainType.openAir,
            (9, 9): TerrainType.openAir,
            (9, 10): TerrainType.openAir,
            (10, 3): TerrainType.openAir,
            (10, 4): TerrainType.openAir,
            (10, 5): TerrainType.openAir,
            (10, 6): TerrainType.openAir,
            (10, 7): TerrainType.openAir,
            (10, 8): TerrainType.openAir,
            (10, 9): TerrainType.openAir,
            (11, 3): TerrainType.openAir,
            (11, 4): TerrainType.openAir,
            (11, 5): TerrainType.openAir,
            (11, 6): TerrainType.openAir,
            (11, 7): TerrainType.openAir,
            (11, 8): TerrainType.openAir,
            (11, 9): TerrainType.openAir,
            (11, 10): TerrainType.openAir,
            (12, 2): TerrainType.openAir,
            (12, 3): TerrainType.openAir,
            (12, 4): TerrainType.openAir,
            (12, 5): TerrainType.openAir,
            (12, 6): TerrainType.openAir,
            (12, 7): TerrainType.openAir,
            (12, 8): TerrainType.openAir,
            (12, 9): TerrainType.openAir,
            (1, 1): TerrainType.object,
            (4, 5): TerrainType.object,
            (8, 4): TerrainType.object,
            (9, 0): TerrainType.object,
            (3, 2): TerrainType.difficult,
            (7, 7): TerrainType.difficult,
            (9, 2): TerrainType.difficult,
            (4, 9): TerrainType.start,
            (5, 10): TerrainType.start,
            (6, 9): TerrainType.start,
            (7, 10): TerrainType.start,
            (8, 9): TerrainType.start,
          },
        ),
        placements: const [
          PlacementDef(name: 'Kifa', c: 0, r: 3),
          PlacementDef(name: 'Zinix', c: 1, r: 1, minPlayers: 4),
          PlacementDef(name: 'Kifa', c: 1, r: 7, minPlayers: 3),
          PlacementDef(name: 'Kifa', c: 3, r: 5),
          PlacementDef(name: 'Zinix', c: 4, r: 5),
          PlacementDef(name: 'Gruv (miniboss)', c: 6, r: 0),
          PlacementDef(name: 'Earth', type: PlacementType.ether, c: 6, r: 2),
          PlacementDef(name: 'Zinix', c: 6, r: 3, minPlayers: 4),
          PlacementDef(name: 'Zinix', c: 7, r: 2, minPlayers: 3),
          PlacementDef(name: 'Zinix', c: 8, r: 4),
          PlacementDef(name: 'Zinix', c: 9, r: 0, minPlayers: 4),
          PlacementDef(name: 'Kifa', c: 10, r: 4, minPlayers: 3),
          PlacementDef(name: 'Kifa', c: 11, r: 3),
          PlacementDef(name: 'Kifa', c: 12, r: 7),
        ],
        adversaries: [
          EncounterFigureDef(
            name: 'Kifa',
            letter: 'A',
            standeeCount: 6,
            flies: true,
            health: 5,
            affinities: const {
              Ether.fire: -1,
              Ether.water: -1,
              Ether.earth: 1,
              Ether.wind: 1,
            },
            /* abilities: [
                AbilityDef(name: 'Wingbeat Onslaught', actions: [
                  RoveAction.move(3),
                  RoveAction(
                      type: RoveActionType.attack,
                      amount: 2,
                      range: (1, 1),
                      push: 1)
                ]),
                AbilityDef(name: 'Stone Fling', actions: [
                  RoveAction.move(2),
                  RoveAction(
                      type: RoveActionType.attack, amount: 3, range: (2, 2))
                ]),
                AbilityDef(name: 'Hook and Drag', actions: [
                  RoveAction.move(2),
                  RoveAction(
                      type: RoveActionType.attack,
                      amount: 2,
                      range: (2, 2),
                      pull: 1)
                ]),
                AbilityDef(name: 'Sonic Screech', actions: [
                  RoveAction.move(2),
                  RoveAction(
                      type: RoveActionType.attack,
                      amount: 2,
                      range: (1, 1),
                      pierce: true,
                      aoe: AOEDef.x6Screech())
                ]),
              ],*/
          ),
          EncounterFigureDef(
              name: 'Zinix',
              letter: 'B',
              standeeCount: 6,
              entersObjectSpaces: true,
              health: 5,
              defense: 1,
              affinities: const {
                Ether.wind: -1,
                Ether.fire: -1,
                Ether.earth: 1,
                Ether.water: 1,
              },
              /* abilities: [
                AbilityDef(
                    name: 'Iron Jaw',
                    actions: [RoveAction.move(2), RoveAction.meleeAttack(3)]),
                AbilityDef(name: 'Dust Bloom', actions: [
                  RoveAction.move(1),
                  RoveAction(
                      type: RoveActionType.attack,
                      amount: 2,
                      range: (2, 3),
                      aoe: AOEDef.x3Triangle(),
                      targetCount: RoveAction.allTargets)
                ]),
                AbilityDef(name: 'Chew Cladrind', actions: [
                  RoveAction.move(2),
                  RoveAction.meleeAttack(2),
                  RoveAction.heal(1, field: EtherField.everbloom),
                ]),
                AbilityDef(name: 'Hail of Stones', actions: [
                  RoveAction(
                      type: RoveActionType.attack,
                      amount: 1,
                      range: (1, 3),
                      pierce: true,
                      targetCount: RoveAction.allTargets),
                ]),
              ],*/
              onSlain: [
                codex(30),
              ]),
          EncounterFigureDef(
              name: 'Gruv (miniboss)',
              alias: 'Gruv',
              letter: 'C',
              type: AdversaryType.miniboss,
              standeeCount: 2,
              healthFormula: '8*R',
              defenseFormula: '3*(1-T%2)',
              traits: const [
                'During even rounds, this unit gains [DEF] 3.'
              ],
              affinities: const {
                Ether.water: -1,
                Ether.fire: 1,
                Ether.earth: 2,
              },
              /* abilities: [
                AbilityDef(name: 'Grasping Tongues', actions: [
                  RoveAction.move(2),
                  RoveAction.meleeAttack(3, endRange: 3, pull: 2),
                  RoveAction(
                      type: RoveActionType.heal,
                      targetKind: TargetKind.self,
                      amount: 1,
                      field: EtherField.everbloom,
                      requiresPrevious: true)
                ]),
                AbilityDef(name: 'Piercing Claws', actions: [
                  RoveAction.move(3),
                  RoveAction(
                      type: RoveActionType.attack,
                      amount: 2,
                      pierce: true,
                      range: (1, 1),
                      aoe: AOEDef.x2Sides(),
                      targetCount: RoveAction.allTargets),
                ]),
                AbilityDef(name: 'Power Dive', actions: [
                  RoveAction.jump(4),
                  RoveAction(
                      type: RoveActionType.attack,
                      amount: 2,
                      range: (1, 2),
                      targetCount: RoveAction.allTargets),
                ]),
                AbilityDef(name: 'Power Ball', actions: [
                  RoveAction(
                      type: RoveActionType.dash,
                      amount: 3,
                      targetKind: TargetKind.self,
                      modifiers: const [TargetFarthestModifier()],
                      staticDescription: RoveActionDescription(
                          prefix:
                              'Logic: Moves to the enemy furthest away, within range of the following attack.')),
                  RoveAction(
                      type: RoveActionType.attack,
                      amountFormula: '2+X',
                      range: (1, 1),
                      pushFormula: 'X',
                      xDefinition: RoveActionXDefinition.previousMovementEffort,
                      staticDescription: RoveActionDescription(
                          suffix:
                              'Where X equals the number of spaces moved with the [Dash] action.')),
                ]),
              ],*/
              onSlain: [
                codex(31),
                victory(),
              ])
        ],
      );

  static EncounterDef get encounter2dot2 => EncounterDef(
        questId: '2',
        number: '2',
        title: 'A Visit to a Mine',
        setup: EncounterSetup(
            box: '2/5',
            map: '12',
            adversary: '15',
            tiles: '5x Crumbling Column, 3x Hoard'),
        victoryDescription:
            'All Rovers and Kelo & Saras end the round within [Range] 1 of the Crystal [A].',
        lossDescription: 'Lose if Kelo & Saras are slain.',
        terrain: [
          trapColumn(2),
          etherEarth(),
        ],
        roundLimit: 8,
        baseLystReward: 15,
        campaignLink:
            '''Encounter 2.3 - “**Description of a Struggle**”, [campaign] **32**.''',
        challenges: [
          'Set the Round Limit to 6.',
          'All adversaries within The Deep Caves add [Push] 1 to all of their attacks.',
          'Onisski always benefit from their action augments as if they were adjacent to a mushroom space.',
        ],
        trackerEvents: [
          EncounterTrackerEventDef(
              title:
                  'Mark when all Rovers and Kelo & Saras end the round adjacent to the Crystal [A].',
              recordMilestone: '_victory'),
        ],
        dialogs: [introductionFromText('quest_2_encounter_2_intro')],
        onLoad: <EncounterAction>[
          dialog('Introduction'),
          rules('The Deep Caves',
              'The spaces outlined in white are the deep caves. During the encounter set up, place these adversaries in their spaces as normal, but they are not active when the encounter starts. This means they do not perform abilities during the adversary phase. These adversaries activate after the first time any unit a part of the Rover faction enters a space within the white border. Once these adversaries are active, they act normally during the Adversary phase.'),
          rules(
              'Queens’ Defectors',
              'Kelo & Saras are character allies to Rovers. They start on either the “Kelo” side or the “Saras'
                  ' side. At the start of the Rover phase, flip Kelo & Saras over to their other side. *[The app does this automatically.]*'),
          codexLink('Crystalline Depression',
              number: 32,
              body:
                  '''If a Rover enters into a space with a hoard tile, remove the tile and read [title], [codex] 19.'''),
          codexLink('Such a Fuss',
              number: 33,
              body:
                  '''The first time an onisski is slain, read [title], [codex] 20.'''),
          codexLink('The Crystal and its Story',
              number: 34,
              body:
                  '''When all Rovers and Kelo & Saras end the round adjacent to the Crystal [A], read [title], [codex] 20.'''),
        ],
        onMilestone: {
          '_victory': [
            codex(34),
            victory(),
          ]
        },
        startingMap: MapDef(
          id: '2.2',
          columnCount: 13,
          rowCount: 11,
          backgroundRect: Rect.fromLTWH(110.0, 44.0, 1481.0, 1411.0),
          terrain: {
            (0, 0): TerrainType.difficult,
            (0, 4): TerrainType.difficult,
            (0, 9): TerrainType.object,
            (1, 1): TerrainType.difficult,
            (2, 0): TerrainType.openAir,
            (2, 5): TerrainType.object,
            (2, 6): TerrainType.difficult,
            (3, 0): TerrainType.openAir,
            (4, 0): TerrainType.openAir,
            (4, 1): TerrainType.difficult,
            (4, 2): TerrainType.difficult,
            (4, 3): TerrainType.openAir,
            (4, 5): TerrainType.object,
            (5, 3): TerrainType.openAir,
            (5, 4): TerrainType.openAir,
            (5, 5): TerrainType.openAir,
            (5, 6): TerrainType.openAir,
            (5, 10): TerrainType.start,
            (6, 3): TerrainType.openAir,
            (6, 4): TerrainType.openAir,
            (6, 5): TerrainType.openAir,
            (6, 6): TerrainType.openAir,
            (6, 7): TerrainType.openAir,
            (6, 9): TerrainType.start,
            (7, 4): TerrainType.openAir,
            (7, 5): TerrainType.openAir,
            (7, 6): TerrainType.openAir,
            (7, 7): TerrainType.openAir,
            (7, 8): TerrainType.openAir,
            (7, 9): TerrainType.start,
            (7, 10): TerrainType.start,
            (8, 4): TerrainType.openAir,
            (8, 5): TerrainType.openAir,
            (8, 6): TerrainType.openAir,
            (8, 7): TerrainType.openAir,
            (8, 8): TerrainType.openAir,
            (8, 9): TerrainType.start,
            (9, 2): TerrainType.object,
            (9, 7): TerrainType.openAir,
            (9, 8): TerrainType.openAir,
            (9, 9): TerrainType.openAir,
            (10, 5): TerrainType.openAir,
            (10, 6): TerrainType.openAir,
            (10, 7): TerrainType.openAir,
            (10, 8): TerrainType.openAir,
            (11, 1): TerrainType.object,
            (11, 2): TerrainType.object,
            (11, 4): TerrainType.openAir,
            (11, 5): TerrainType.openAir,
            (11, 6): TerrainType.openAir,
            (11, 7): TerrainType.openAir,
            (11, 8): TerrainType.openAir,
            (11, 9): TerrainType.openAir,
            (12, 0): TerrainType.object,
            (12, 1): TerrainType.object,
            (12, 2): TerrainType.object,
            (12, 3): TerrainType.openAir,
            (12, 4): TerrainType.openAir,
            (12, 5): TerrainType.openAir,
            (12, 6): TerrainType.openAir,
            (12, 7): TerrainType.openAir,
            (12, 8): TerrainType.openAir,
          },
        ),
        allies: [
          AllyDef(
              name: 'Kelo & Saras',
              cardId: 'A-013',
              defaultBehaviorIndex: AllyDef.userSelectsDefaultBehavior,
              behaviors: [
                EncounterFigureDef(
                  name: 'Kelo',
                  health: 8,
                  defense: 1,
                  affinities: const {
                    Ether.fire: -1,
                    Ether.crux: -1,
                    Ether.earth: 1,
                    Ether.morph: 1,
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
                          amount: 1,
                          range: (2, 2),
                          push: 1,
                          exclusiveGroup: 1),
                      RoveAction(
                          type: RoveActionType.jump,
                          amount: 3,
                          targetKind: TargetKind.self,
                          exclusiveGroup: 2),
                      RoveAction(
                          type: RoveActionType.heal,
                          amount: 1,
                          range: (0, 2),
                          targetKind: TargetKind.selfOrAlly,
                          pull: 1,
                          exclusiveGroup: 2),
                    ]),
                  ],
                  onStartPhase: [
                    EncounterAction(
                        type: EncounterActionType.toggleBehavior,
                        conditions: [PhaseCondition(RoundPhase.rover)]),
                  ],
                  onSlain: [fail()],
                ),
                EncounterFigureDef(
                  name: 'Saras',
                  health: 8,
                  affinities: const {
                    Ether.water: -1,
                    Ether.wind: -1,
                    Ether.fire: 1,
                    Ether.earth: 1,
                  },
                  abilities: [
                    AbilityDef(name: 'Ability', actions: [
                      RoveAction(
                          type: RoveActionType.dash,
                          amount: 4,
                          targetKind: TargetKind.self,
                          exclusiveGroup: 1),
                      RoveAction(
                          type: RoveActionType.attack,
                          amount: 1,
                          range: (1, 1),
                          pierce: true,
                          exclusiveGroup: 1),
                      RoveAction(
                          type: RoveActionType.dash,
                          amount: 3,
                          targetKind: TargetKind.self,
                          exclusiveGroup: 2),
                      RoveAction(
                          type: RoveActionType.attack,
                          amount: 2,
                          range: (1, 2),
                          aoe: AOEDef.x2Line(),
                          targetCount: RoveAction.allTargets,
                          exclusiveGroup: 2),
                    ]),
                  ],
                  onStartPhase: [
                    EncounterAction(
                        type: EncounterActionType.toggleBehavior,
                        conditions: [PhaseCondition(RoundPhase.rover)]),
                  ],
                  onSlain: [fail()],
                ),
              ]),
        ],
        overlays: [
          EncounterFigureDef(name: 'Hoard', onLoot: [
            codex(32),
            lyst('10'),
          ])
        ],
        adversaries: [
          EncounterFigureDef(
              name: 'Onisski',
              letter: 'A',
              standeeCount: 4,
              health: 6,
              ignoresDifficultTerrain: true,
              affinities: const {
                Ether.fire: -1,
                Ether.crux: -1,
                Ether.water: 1,
                Ether.morph: 1,
              },
              /* abilities: [
                AbilityDef(name: 'Frenzy Spores', actions: [
                  RoveAction.heal(2, endRange: 3).withAugment(ActionAugment(
                      condition: ActorIsInRangeOfCondition(
                          range: (0, 1), target: 'Mushroom'),
                      action: RoveAction.buff(BuffType.amount, 1).withDescription(
                          'If this unit is within [Range] 0-1 of a mushroom space, gain +1 [RCV].'))),
                ]),
                AbilityDef(name: 'Roll Up', actions: [
                  RoveAction.jump(3),
                  RoveAction.meleeAttack(2).withAugment(ActionAugment(
                      condition: ActorIsInRangeOfCondition(
                          range: (0, 1), target: 'Mushroom'),
                      action: RoveAction.buff(BuffType.amount, 1).withDescription(
                          'If this unit is within [Range] 0-1 of a mushroom space, gain +1 [DMG].')))
                ]),
                AbilityDef(name: 'Fungal Spit', actions: [
                  RoveAction(
                      type: RoveActionType.dash,
                      amount: 2,
                      targetKind: TargetKind.self,
                      modifiers: [
                        MoveTowardsModifier('Mushroom')
                      ]).withPrefix(
                      'Logic: Wants to move toward the nearest mushroom space.'),
                  RoveAction.rangeAttack(2, endRange: 4).withAugment(ActionAugment(
                      condition: ActorIsInRangeOfCondition(
                          range: (0, 1), target: 'Mushroom'),
                      action: RoveAction.buff(BuffType.field, 0,
                              field: EtherField.snapfrost)
                          .withDescription(
                              'If this unit is within [Range] 0-1 of a mushroom space, gain [snapfrost].')))
                ]),
                AbilityDef(name: 'Desperate Contest', actions: [
                  RoveAction.move(3),
                  RoveAction.meleeAttack(2, push: 2),
                  RoveAction(
                      type: RoveActionType.dash,
                      amount: 2,
                      targetKind: TargetKind.self,
                      modifiers: const [
                        MoveTowardsModifier('Mushroom')
                      ]).withPrefix(
                      'Logic: Wants to move toward the nearest mushroom space.'),
                ]),
              ],*/
              onSlain: [
                codex(33),
              ]),
          EncounterFigureDef(
            name: 'Zinix',
            letter: 'B',
            standeeCount: 6,
            entersObjectSpaces: true,
            health: 5,
            defense: 1,
            affinities: const {
              Ether.wind: -1,
              Ether.fire: -1,
              Ether.earth: 1,
              Ether.water: 1,
            },
            /* abilities: [
                AbilityDef(
                    name: 'Iron Jaw',
                    actions: [RoveAction.move(2), RoveAction.meleeAttack(3)]),
                AbilityDef(name: 'Dust Bloom', actions: [
                  RoveAction.move(1),
                  RoveAction(
                      type: RoveActionType.attack,
                      amount: 2,
                      range: (2, 3),
                      aoe: AOEDef.x3Triangle(),
                      targetCount: RoveAction.allTargets)
                ]),
                AbilityDef(name: 'Chew Cladrind', actions: [
                  RoveAction.move(2),
                  RoveAction.meleeAttack(2),
                  RoveAction.heal(1, field: EtherField.everbloom),
                ]),
                AbilityDef(name: 'Hail of Stones', actions: [
                  RoveAction(
                      type: RoveActionType.attack,
                      amount: 1,
                      range: (1, 3),
                      pierce: true,
                      targetCount: RoveAction.allTargets),
                ]),
              ],*/
          ),
          EncounterFigureDef(
              name: 'Wrathbone',
              letter: 'C',
              standeeCount: 4,
              health: 12,
              traits: const [
                '''[React] At the end of the Rover phase: 
            
All enemies within [Range] 1 suffer [DMG]1.'''
              ],
              affinities: const {
                Ether.water: -1,
                Ether.morph: -1,
                Ether.earth: 1,
                Ether.fire: 2,
              },
              /* abilities: [
                AbilityDef(name: 'Searing Bite', actions: [
                  RoveAction.move(3),
                  RoveAction.meleeAttack(2, field: EtherField.wildfire)
                ]),
                AbilityDef(name: 'Tailbone Sweep', actions: [
                  RoveAction.move(4),
                  RoveAction(
                      type: RoveActionType.attack,
                      amount: 2,
                      range: (1, 1),
                      aoe: AOEDef.x3Front(),
                      targetCount: RoveAction.allTargets)
                ]),
                AbilityDef(name: 'Burnbile Vomit', actions: [
                  RoveAction.move(2),
                  RoveAction.rangeAttack(1,
                      endRange: 3, field: EtherField.wildfire),
                  RoveAction(
                          type: RoveActionType.suffer,
                          amount: 1,
                          range: (1, 1),
                          rangeOrigin: RoveActionRangeOrigin.previousTarget,
                          targetCount: RoveAction.allTargets,
                          requiresPrevious: true)
                      .withDescription(
                          'All other enemies within [Range] 1 of the target suffer [DMG]1')
                ]),
                AbilityDef(name: 'Combustion Flare', actions: [
                  RoveAction(
                          type: RoveActionType.attack,
                          amount: 2,
                          range: (1, 3),
                          targetCount: RoveAction.allTargets)
                      .withAugment(ActionAugment(
                          condition: ActorAdjacentToTarget(),
                          action: RoveAction.buff(BuffType.amount, 1)
                              .withDescription(
                                  'If the target of the attack is within [Range] 1, that attack gains +1 [DMG].')))
                ]),
              ],*/
              reactions: [
                EnemyReactionDef(
                    trigger:
                        ReactionTriggerDef(type: RoveEventType.endRoverPhase),
                    actions: [
                      RoveAction(
                          type: RoveActionType.suffer,
                          amount: 1,
                          range: (1, 1),
                          targetCount: RoveAction.allTargets)
                    ])
              ]),
        ],
        onOccupiedSpace: [
          EncounterAction(
              type: EncounterActionType.awaken,
              title: 'The Deep Caves',
              conditions: [
                FactionCondition(RoundPhase.rover),
                InRangeOfAny(range: (0, 0), targets: ['Deep Caves'])
              ]),
          EncounterAction(
              type: EncounterActionType.milestone,
              value: '_victory',
              conditions: [RoversInRangeOf(range: (0, 1), target: 'Crystal')]),
        ],
        placements: const [
          PlacementDef(name: 'Zinix', c: 0, r: 9),
          PlacementDef(name: 'Zinix', c: 4, r: 5),
          PlacementDef(name: 'Zinix', c: 2, r: 4, minPlayers: 3),
          PlacementDef(
              name: 'Zinix', c: 10, r: 2, sleeping: true, minPlayers: 4),
          PlacementDef(
              name: 'Zinix', c: 10, r: 0, sleeping: true, minPlayers: 4),
          PlacementDef(name: 'Zinix', c: 10, r: 3, sleeping: true),
          PlacementDef(name: 'Onisski', c: 4, r: 2),
          PlacementDef(name: 'Onisski', c: 4, r: 1, minPlayers: 3),
          PlacementDef(name: 'Onisski', c: 2, r: 6),
          PlacementDef(name: 'Wrathbone', c: 0, r: 7, minPlayers: 4),
          PlacementDef(name: 'Wrathbone', c: 1, r: 2),
          PlacementDef(name: 'Wrathbone', c: 10, r: 1, sleeping: true),
          PlacementDef(
              name: 'Wrathbone', c: 10, r: 4, sleeping: true, minPlayers: 3),
          PlacementDef(name: 'Hoard', type: PlacementType.object, c: 9, r: 6),
          PlacementDef(name: 'Hoard', type: PlacementType.object, c: 1, r: 0),
          PlacementDef(name: 'Hoard', type: PlacementType.object, c: 12, r: 9),
          PlacementDef(
              name: 'Crumbling Column',
              type: PlacementType.trap,
              c: 4,
              r: 4,
              trapDamage: 2),
          PlacementDef(
              name: 'Crumbling Column',
              type: PlacementType.trap,
              c: 5,
              r: 7,
              trapDamage: 2),
          PlacementDef(
              name: 'Crumbling Column',
              type: PlacementType.trap,
              c: 11,
              r: 3,
              trapDamage: 2),
          PlacementDef(
              name: 'Crumbling Column',
              type: PlacementType.trap,
              c: 11,
              r: 0,
              trapDamage: 2),
          PlacementDef(
              name: 'Crumbling Column',
              type: PlacementType.trap,
              c: 9,
              r: 5,
              trapDamage: 2),
          PlacementDef(name: 'earth', type: PlacementType.ether, c: 2, r: 5),
          PlacementDef(name: 'earth', type: PlacementType.ether, c: 9, r: 2),
          PlacementDef(
              name: 'Mushroom', type: PlacementType.feature, c: 0, r: 0),
          PlacementDef(
              name: 'Mushroom', type: PlacementType.feature, c: 1, r: 1),
          PlacementDef(
              name: 'Mushroom', type: PlacementType.feature, c: 4, r: 1),
          PlacementDef(
              name: 'Mushroom', type: PlacementType.feature, c: 4, r: 2),
          PlacementDef(
              name: 'Mushroom', type: PlacementType.feature, c: 0, r: 4),
          PlacementDef(
              name: 'Mushroom', type: PlacementType.feature, c: 2, r: 6),
          PlacementDef(
              name: 'Deep Caves', type: PlacementType.feature, c: 5, r: 1),
          PlacementDef(
              name: 'Deep Caves', type: PlacementType.feature, c: 5, r: 2),
          PlacementDef(
              name: 'Deep Caves', type: PlacementType.feature, c: 5, r: 0),
          PlacementDef(
              name: 'Deep Caves', type: PlacementType.feature, c: 6, r: 0),
          PlacementDef(
              name: 'Deep Caves', type: PlacementType.feature, c: 6, r: 1),
          PlacementDef(
              name: 'Deep Caves', type: PlacementType.feature, c: 6, r: 2),
          PlacementDef(
              name: 'Deep Caves', type: PlacementType.feature, c: 7, r: 3),
          PlacementDef(
              name: 'Deep Caves', type: PlacementType.feature, c: 8, r: 3),
          PlacementDef(
              name: 'Deep Caves', type: PlacementType.feature, c: 9, r: 4),
          PlacementDef(
              name: 'Deep Caves', type: PlacementType.feature, c: 9, r: 5),
          PlacementDef(
              name: 'Deep Caves', type: PlacementType.feature, c: 9, r: 6),
          PlacementDef(
              name: 'Deep Caves', type: PlacementType.feature, c: 10, r: 4),
          PlacementDef(
              name: 'Deep Caves', type: PlacementType.feature, c: 10, r: 3),
          PlacementDef(
              name: 'Deep Caves', type: PlacementType.feature, c: 11, r: 3),
          PlacementDef(
              name: 'Deep Caves', type: PlacementType.feature, c: 10, r: 2),
          PlacementDef(
              name: 'Deep Caves', type: PlacementType.feature, c: 10, r: 1),
          PlacementDef(
              name: 'Deep Caves', type: PlacementType.feature, c: 10, r: 0),
          PlacementDef(
              name: 'Deep Caves', type: PlacementType.feature, c: 11, r: 0),
          PlacementDef(
              name: 'Deep Caves', type: PlacementType.feature, c: 9, r: 0),
          PlacementDef(
              name: 'Deep Caves', type: PlacementType.feature, c: 9, r: 1),
          PlacementDef(
              name: 'Deep Caves', type: PlacementType.feature, c: 8, r: 1),
          PlacementDef(
              name: 'Deep Caves', type: PlacementType.feature, c: 7, r: 1),
          PlacementDef(
              name: 'Deep Caves', type: PlacementType.feature, c: 7, r: 0),
          PlacementDef(
              name: 'Deep Caves', type: PlacementType.feature, c: 8, r: 0),
          PlacementDef(
              name: 'Deep Caves', type: PlacementType.feature, c: 7, r: 2),
          PlacementDef(
              name: 'Deep Caves', type: PlacementType.feature, c: 8, r: 2),
          PlacementDef(
              name: 'Deep Caves', type: PlacementType.feature, c: 9, r: 3),
          PlacementDef(
              name: 'Deep Caves', type: PlacementType.feature, c: 9, r: 2),
          PlacementDef(
              name: 'Crystal', type: PlacementType.feature, c: 11, r: 1),
          PlacementDef(
              name: 'Crystal', type: PlacementType.feature, c: 12, r: 0),
          PlacementDef(
              name: 'Crystal', type: PlacementType.feature, c: 12, r: 1),
          PlacementDef(
              name: 'Crystal', type: PlacementType.feature, c: 11, r: 2),
          PlacementDef(
              name: 'Crystal', type: PlacementType.feature, c: 12, r: 2),
        ],
      );

  static EncounterDef get encounter2dot3 => EncounterDef(
      questId: '2',
      number: '3',
      title: 'Description of a Struggle',
      setup: EncounterSetup(
          box: '2/5',
          map: '13',
          adversary: '16',
          tiles: ' 1x Treasure Chest, 4x Hoard'),
      victoryDescription:
          'Place R bomb satchels onto the Ashemak seed pod pile.',
      lossDescription: 'Lose if Kelo & Saras are slain.',
      terrain: [
        EncounterTerrain('dangerous_fire',
            title: 'Fire',
            damage: 1,
            body:
                'Non-flying units that enter fire suffer [DMG] 1. Wrathbone ignores this effect.'),
        etherFire(),
        EncounterTerrain('hoard',
            title: 'Bomb Satchels',
            body:
                'Hoard tiles [A] are bomb satchels. A Rover that enters a space with a hoard tile picks up that tile. To indicate this, place the hoard tile on your class board.Rovers may carry only one bomb satchel.'),
        EncounterTerrain('ashemak_seed_pod_pile',
            title: 'Ashemak Seed Pod Pile',
            body:
                'The Ashemak seed pod pile is in space [B]. Rovers that end their turn adjacent to the ashemak seed pod pile may place a bomb satchel on it. To do this, move the hoard tile from your class board onto the seed pod pile.'),
        EncounterTerrain('treasure',
            title: 'Treasure Chest',
            body:
                'The treasure chest [C] is locked and requires a key to open.'),
      ],
      roundLimit: 8,
      baseLystReward: 15,
      unlocksRoverLevel: 3,
      campaignLink: '''Encounter 2.4 - “**The Burrow**”, [campaign] **34**.''',
      challenges: [
        'Rovers that are carrying a bomb satchel reduce all of their movement actions by 1.',
        'At the end of round 4, spawn R Seks in [start] spaces closest to the Rovers.',
        'The Zisafi Principal gains +1 [DMG] to all of their attacks.',
      ],
      dialogs: [introductionFromText('quest_2_encounter_3_intro')],
      onLoad: [
        dialog('Introduction'),
        rules(
            'Queens’ Defectors',
            'Kelo & Saras are character allies to Rovers. They start on either the “Kelo” side or the “Saras'
                ' side. At the start of each round, flip Kelo & Saras over to their other side. *[The app does this automatically.]*'),
        codexLink('It Must Catch Fire',
            number: 35,
            body:
                '''The first time a wrathbone is slain, read [title], [codex] 20.'''),
        codexLink('Agreement is the Best Weapon',
            number: 36,
            body:
                '''If the Zisafi Principal is slain, read [title], [codex] 20.'''),
        codexLink('Hot and Dreadful',
            number: 38,
            body:
                '''Immediately when R bomb satchels have been placed onto the ashemak seed pod pile, read [title], [codex] 21.'''),
      ],
      onWillEndRound: [
        placementGroup(
          'Challenge 2',
          title: 'Challenge 2',
          body: 'Spawn R Seks in [start] spaces closest to the Rovers.',
          conditions: [RoundCondition(4), ChallengeOnCondition(2)],
        )
      ],
      onMilestone: {
        '_victory': [
          codex(38),
          victory(),
        ]
      },
      playerPossibleTokens: ['Hoard', 'Key'],
      startingMap: MapDef(
        id: '2.3',
        columnCount: 13,
        rowCount: 11,
        backgroundRect: Rect.fromLTWH(110.0, 44.0, 1481.0, 1411.0),
        terrain: {
          (0, 7): TerrainType.object,
          (0, 8): TerrainType.start,
          (0, 9): TerrainType.start,
          (1, 1): TerrainType.dangerous,
          (1, 5): TerrainType.dangerous,
          (1, 8): TerrainType.object,
          (1, 9): TerrainType.start,
          (1, 10): TerrainType.start,
          (2, 9): TerrainType.start,
          (3, 2): TerrainType.object,
          (3, 9): TerrainType.object,
          (3, 10): TerrainType.start,
          (4, 4): TerrainType.object,
          (4, 5): TerrainType.object,
          (4, 9): TerrainType.object,
          (5, 0): TerrainType.object,
          (5, 1): TerrainType.object,
          (6, 0): TerrainType.object,
          (6, 2): TerrainType.object,
          (6, 4): TerrainType.object,
          (6, 5): TerrainType.object,
          (7, 1): TerrainType.object,
          (7, 2): TerrainType.object,
          (7, 3): TerrainType.object,
          (7, 8): TerrainType.object,
          (9, 0): TerrainType.object,
          (9, 1): TerrainType.object,
          (9, 4): TerrainType.dangerous,
          (10, 0): TerrainType.object,
          (11, 6): TerrainType.object,
          (11, 9): TerrainType.object,
          (11, 10): TerrainType.object,
          (12, 2): TerrainType.object,
          (12, 5): TerrainType.object,
        },
      ),
      allies: [
        AllyDef(
            name: 'Kelo & Saras',
            cardId: 'A-013',
            defaultBehaviorIndex: AllyDef.userSelectsDefaultBehavior,
            behaviors: [
              EncounterFigureDef(
                name: 'Kelo',
                health: 8,
                defense: 1,
                affinities: const {
                  Ether.fire: -1,
                  Ether.crux: -1,
                  Ether.earth: 1,
                  Ether.morph: 1,
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
                        amount: 1,
                        range: (2, 2),
                        push: 1,
                        exclusiveGroup: 1),
                    RoveAction(
                        type: RoveActionType.jump,
                        amount: 3,
                        targetKind: TargetKind.self,
                        exclusiveGroup: 2),
                    RoveAction(
                        type: RoveActionType.heal,
                        amount: 1,
                        range: (0, 2),
                        targetKind: TargetKind.selfOrAlly,
                        pull: 1,
                        exclusiveGroup: 2),
                  ]),
                ],
                onStartPhase: [
                  EncounterAction(
                      type: EncounterActionType.toggleBehavior,
                      conditions: [PhaseCondition(RoundPhase.rover)]),
                ],
                onSlain: [fail()],
              ),
              EncounterFigureDef(
                name: 'Saras',
                health: 8,
                affinities: const {
                  Ether.water: -1,
                  Ether.wind: -1,
                  Ether.fire: 1,
                  Ether.earth: 1,
                },
                abilities: [
                  AbilityDef(name: 'Ability', actions: [
                    RoveAction(
                        type: RoveActionType.dash,
                        amount: 4,
                        targetKind: TargetKind.self,
                        exclusiveGroup: 1),
                    RoveAction(
                        type: RoveActionType.attack,
                        amount: 1,
                        range: (1, 1),
                        pierce: true,
                        exclusiveGroup: 1),
                    RoveAction(
                        type: RoveActionType.dash,
                        amount: 3,
                        targetKind: TargetKind.self,
                        exclusiveGroup: 2),
                    RoveAction(
                        type: RoveActionType.attack,
                        amount: 2,
                        range: (1, 2),
                        aoe: AOEDef.x2Line(),
                        targetCount: RoveAction.allTargets,
                        exclusiveGroup: 2),
                  ]),
                ],
                onStartPhase: [
                  EncounterAction(
                      type: EncounterActionType.toggleBehavior,
                      conditions: [PhaseCondition(RoundPhase.rover)]),
                ],
                onSlain: [fail()],
              ),
            ]),
      ],
      overlays: [
        EncounterFigureDef(
          name: 'Ashemak Seed Pod Pile',
          possibleTokens: ['RxHoard'],
          traits: [
            'Rovers that end their turn adjacent to the Ashemak seed pod pile may place a bomb satchel on it. To do this, move the hoard tile from your class board onto the seed pod pile.'
          ],
          onTokensChanged: [
            milestone('_victory', condition: TokenCountCondition('R')),
          ],
        ),
        EncounterFigureDef(name: 'Treasure', traits: [
          'The treasure chest [C] is locked and requires a key to open. At the end of the round, if the Rover with “Quartermaster’s key” is within [Range] 1 of the treasure chest [C], the Rover can loot this item.'
        ]),
        EncounterFigureDef(
          name: 'Hoard',
          alias: 'Bomb Satchel',
          traits: [
            'Hoard tiles [A] are bomb satchels. A Rover that enters a hex with a hoard tile picks up that tile. To indicate this, place the hoard tile on your class board. Rovers may carry only one bomb satchel.'
          ],
          onLoot: [
            EncounterAction(type: EncounterActionType.addToken),
          ],
        )
      ],
      adversaries: [
        EncounterFigureDef(
            name: 'Wrathbone',
            letter: 'A',
            standeeCount: 4,
            health: 12,
            traits: const [
              '''[React] At the end of the Rover phase: 
            
All enemies within [Range] 1 suffer [DMG]1.'''
            ],
            affinities: const {
              Ether.water: -1,
              Ether.morph: -1,
              Ether.earth: 1,
              Ether.fire: 2,
            },
            /* abilities: [
                AbilityDef(name: 'Searing Bite', actions: [
                  RoveAction.move(3),
                  RoveAction.meleeAttack(2, field: EtherField.wildfire)
                ]),
                AbilityDef(name: 'Tailbone Sweep', actions: [
                  RoveAction.move(4),
                  RoveAction(
                      type: RoveActionType.attack,
                      amount: 2,
                      range: (1, 1),
                      aoe: AOEDef.x3Front(),
                      targetCount: RoveAction.allTargets)
                ]),
                AbilityDef(name: 'Burnbile Vomit', actions: [
                  RoveAction.move(2),
                  RoveAction.rangeAttack(1,
                      endRange: 3, field: EtherField.wildfire),
                  RoveAction(
                          type: RoveActionType.suffer,
                          amount: 1,
                          range: (1, 1),
                          rangeOrigin: RoveActionRangeOrigin.previousTarget,
                          targetCount: RoveAction.allTargets,
                          requiresPrevious: true)
                      .withDescription(
                          'All other enemies within [Range] 1 of the target suffer [DMG]1')
                ]),
                AbilityDef(name: 'Combustion Flare', actions: [
                  RoveAction(
                          type: RoveActionType.attack,
                          amount: 2,
                          range: (1, 3),
                          targetCount: RoveAction.allTargets)
                      .withAugment(ActionAugment(
                          condition: ActorAdjacentToTarget(),
                          action: RoveAction.buff(BuffType.amount, 1)
                              .withDescription(
                                  'If the target of the attack is within [Range] 1, that attack gains +1 [DMG].')))
                ]),
              ],*/
            reactions: [
              EnemyReactionDef(
                  trigger:
                      ReactionTriggerDef(type: RoveEventType.endRoverPhase),
                  actions: [
                    RoveAction(
                        type: RoveActionType.suffer,
                        amount: 1,
                        range: (1, 1),
                        targetCount: RoveAction.allTargets)
                  ])
            ],
            onSlain: [
              codex(35),
            ]),
        EncounterFigureDef(
          name: 'Sek',
          letter: 'B',
          standeeCount: 8,
          spawnable: true,
          health: 10,
          defense: 1,
          affinities: const {
            Ether.crux: -1,
            Ether.fire: 1,
            Ether.morph: 1,
          },
          /* abilities: [
              AbilityDef(
                name: 'Dual Strike',
                actions: [
                  RoveAction.jump(3),
                  RoveAction.meleeAttack(2),
                  RoveAction.rangeAttack(2,
                          endRange: 3, modifiers: [TargetNextClosestModifier()])
                      .withPrefix(
                          'Logic: Wants to attack the next closest enemy.')
                ],
              ),
              AbilityDef(
                name: 'Living Shell',
                actions: [
                  RoveAction.heal(1, field: EtherField.windscreen),
                  RoveAction.meleeAttack(1,
                      endRange: 3, push: 2, targetCount: RoveAction.allTargets),
                ],
              ),
              AbilityDef(name: 'Safe Cracker', actions: [
                RoveAction.move(4),
                RoveAction(
                        type: RoveActionType.attack,
                        amountFormula: '3+X',
                        pierce: true,
                        xDefinition: RoveActionXDefinition.targetDefense)
                    .withSuffix('Where X equal\'s the target\'s [DEF].')
              ]),
              AbilityDef(name: 'Strange Chatter', actions: [
                RoveAction.move(2),
                RoveAction.rangeAttack(3, endRange: 3, field: EtherField.miasma)
              ]),
            ],*/
        ),
        EncounterFigureDef(
          name: 'Zisafi Principal',
          letter: 'C',
          type: AdversaryType.miniboss,
          standeeCount: 8,
          healthFormula: '7*R',
          affinities: const {
            Ether.crux: -1,
            Ether.fire: 1,
            Ether.morph: 2,
          },
          traits: [
            'During even rounds, this unit gains +1 [DMG] to all of its attacks.'
          ],
/*            abilities: [
              AbilityDef(
                name: 'Surprise Attack',
                actions: [
                  RoveAction.move(3),
                  RoveAction.rangeAttack(0,
                      amountFormula: '3+1*(1-T%2)',
                      endRange: 3,
                      pierce: true,
                      field: EtherField.snapfrost),
                  RoveAction.move(3, retreat: true, requiresPrevious: true),
                ],
              ),
              AbilityDef(
                name: 'Cleaving Blow',
                actions: [
                  RoveAction.move(4),
                  RoveAction.meleeAttack(0,
                      amountFormula: '2+1*(1-T%2)',
                      push: 2,
                      targetCount: RoveAction.allTargets,
                      aoe: AOEDef.x4Cleave()),
                  RoveAction.move(1, retreat: true, requiresPrevious: true),
                ],
              ),
              AbilityDef(name: 'Hooked Spear', actions: [
                RoveAction.jump(5).withPrefix(
                    'Logic: Wants to maximize distance of the [Pull].'),
                RoveAction.rangeAttack(0,
                    amountFormula: '4+1*(1-T%2)',
                    endRange: 3,
                    pull: 3,
                    modifiers: [
                      MaximizePullDistanceModifier(),
                    ])
              ]),
              AbilityDef(name: 'Piercing Lunge', actions: [
                RoveAction.move(3),
                RoveAction.meleeAttack(0,
                    amountFormula: '3+1*(1-T%2)',
                    pierce: true,
                    targetCount: RoveAction.allTargets,
                    aoe: AOEDef.x3Line())
              ]),
            ],*/
        ),
      ],
      placements: [
        PlacementDef(name: 'Wrathbone', c: 1, r: 5),
        PlacementDef(name: 'Wrathbone', c: 9, r: 4),
        PlacementDef(name: 'Wrathbone', c: 1, r: 1, minPlayers: 3),
        PlacementDef(name: 'Sek', c: 11, r: 8),
        PlacementDef(name: 'Sek', c: 12, r: 1),
        PlacementDef(name: 'Sek', c: 8, r: 0, minPlayers: 3),
        PlacementDef(name: 'Zisafi Principal', c: 6, r: 1, onSlain: [
          codex(36),
          addToken('Key',
              title: 'Reward',
              body:
                  '''Make a note that the Rover that slew the Zisafi Principal “has the Quartermaster's key”. If Kelo & Saras slew the Zisafi Principal, the Rover that is controlling Kelo & Saras has the Quartermaster’s key.'''),
          codexLink('Better to Have',
              number: 37,
              body:
                  '''At the end of the round, if the Rover with “Quartermaster’s key” is within [Range] 1 of the treasure chest [C], read [title], [codex] 21.'''),
        ]),
        PlacementDef(
            name: 'Treasure',
            type: PlacementType.object,
            c: 7,
            r: 1,
            fixedTokens: ['C'],
            unlockCondition: HasItemCondition('Metal Key'),
            onWillEndRound: [
              EncounterAction(
                  type: EncounterActionType.unlockFromAdjacentAndLoot)
            ],
            onLoot: [
              codex(37),
              lyst('5*R', title: 'Better to Have'),
              item('Vigor Juice',
                  body:
                      '''The Rover that unlocked treasure chest [C] gains one “Vigor Juice” item. They may equip this items. If they don’t have the required item slot(s) available, they may unequip items as needed.'''),
              item('Slagblade',
                  body:
                      '''The Rover that unlocked treasure chest [C] gains one “Slagblade” item. They may equip this items. If they don’t have the required item slot(s) available, they may unequip items as needed.'''),
            ]),
        PlacementDef(
          name: 'Hoard',
          type: PlacementType.object,
          c: 12,
          r: 9,
          fixedTokens: ['A'],
        ),
        PlacementDef(
          name: 'Hoard',
          type: PlacementType.object,
          c: 12,
          r: 8,
          fixedTokens: ['A'],
        ),
        PlacementDef(
          name: 'Hoard',
          type: PlacementType.object,
          c: 12,
          r: 7,
          fixedTokens: ['A'],
        ),
        PlacementDef(
          name: 'Hoard',
          type: PlacementType.object,
          c: 12,
          r: 6,
          fixedTokens: ['A'],
        ),
        PlacementDef(name: 'fire', type: PlacementType.ether, c: 7, r: 8),
        PlacementDef(name: 'fire', type: PlacementType.ether, c: 3, r: 2),
        PlacementDef(
            name: 'Ashemak Seed Pod Pile',
            type: PlacementType.object,
            c: 12,
            r: 2,
            fixedTokens: ['B']),
      ],
      placementGroups: [
        PlacementGroupDef(
          name: 'Challenge 2',
          placements: [
            PlacementDef(name: 'Sek', c: 0, r: 0),
            PlacementDef(name: 'Sek', c: 0, r: 0),
            PlacementDef(name: 'Sek', c: 0, r: 0, minPlayers: 3),
            PlacementDef(name: 'Sek', c: 0, r: 0, minPlayers: 4),
          ],
        )
      ]);

  static EncounterDef get encounter2dot4 => EncounterDef(
        questId: '2',
        number: '4',
        title: 'The Burrow',
        setup: EncounterSetup(
            box: '2/5',
            map: '14',
            adversary: '18-19',
            tiles: '4x Crumbling Column'),
        victoryDescription: 'Escort the skara grub to the [exit] space.',
        lossDescription: 'Lose if Kelo & Saras or the skara grub are slain.',
        terrain: [
          trapColumn(2),
          etherFire(),
        ],
        roundLimit: 8,
        baseLystReward: 15,
        etherRewards: [Ether.earth],
        campaignLink:
            '''Encounter 2.5 - “**Kenyn and Keb*”, [campaign] **36**.''',
        challenges: [
          'When performing the Hurry up! ability, the skara grub performs [Dash] 2 instead.',
          'Zisafis will always attack the skara grub if the grub is within range of their attacks.',
          'The Sek Principal loses their trait and gains +1 [DEF].',
        ],
        trackerEvents: [
          EncounterTrackerEventDef(
              title:
                  'Mark when the skara grub ends the round occupying the exit space [A].',
              recordMilestone: '_double_cross'),
        ],
        dialogs: [introductionFromText('quest_2_encounter_4_intro')],
        onLoad: [
          dialog('Introduction'),
          rules('Queens’ Defectors',
              '''Kelo & Saras are character allies to Rovers. They start on either the “Kelo” side or the “Saras” side. At the start of each round, flip Kelo & Saras over to their other side. *[The app does this automatically.]*'''),
          rules('Somewhere, There is a Worm',
              '''The skara grub is a character ally to Rovers, has 6 [HP], [DEF] 1, and is immune to forced movement. At the end of the round, the skara grub performs [Dash] 3, controlled by a consensus from among the players.

Once each round, one Rover may perform the following ability:

**Hurry up!**: The skara grub performs [Dash] 3, with you controlling the action.

**Note**: **Hurry up!** is an ability and requires an ability activation to use.'''),
          codexLink('Ready to Release',
              number: 39,
              body:
                  '''The first time an ashemak is slain, read [title], [codex] 22.'''),
          codexLink('Absorption Without Assimilation',
              number: 40,
              body: '''Each time an urn is slain, read [title], [codex] 22.'''),
          codexLink('Truth Cannot Know Itself',
              number: 41,
              body:
                  '''When the skara grub ends the round occupying the exit space [A], read [title], [codex] 22.'''),
        ],
        startingMap: MapDef(
          id: '2.4',
          columnCount: 13,
          rowCount: 11,
          backgroundRect: Rect.fromLTWH(110.0, 44.0, 1481.0, 1411.0),
          terrain: {
            (0, 0): TerrainType.start,
            (0, 3): TerrainType.barrier,
            (0, 4): TerrainType.barrier,
            (0, 8): TerrainType.barrier,
            (1, 0): TerrainType.start,
            (1, 1): TerrainType.start,
            (1, 10): TerrainType.barrier,
            (2, 0): TerrainType.start,
            (2, 3): TerrainType.object,
            (3, 0): TerrainType.start,
            (3, 3): TerrainType.barrier,
            (3, 6): TerrainType.barrier,
            (3, 8): TerrainType.difficult,
            (4, 1): TerrainType.barrier,
            (4, 2): TerrainType.object,
            (4, 6): TerrainType.barrier,
            (5, 2): TerrainType.object,
            (5, 5): TerrainType.difficult,
            (5, 7): TerrainType.barrier,
            (5, 8): TerrainType.barrier,
            (5, 9): TerrainType.object,
            (6, 1): TerrainType.barrier,
            (6, 3): TerrainType.difficult,
            (6, 6): TerrainType.object,
            (7, 2): TerrainType.barrier,
            (7, 5): TerrainType.barrier,
            (7, 6): TerrainType.barrier,
            (7, 9): TerrainType.object,
            (7, 10): TerrainType.barrier,
            (8, 3): TerrainType.object,
            (8, 7): TerrainType.barrier,
            (9, 3): TerrainType.barrier,
            (9, 4): TerrainType.barrier,
            (9, 5): TerrainType.barrier,
            (9, 6): TerrainType.object,
            (9, 7): TerrainType.barrier,
            (9, 10): TerrainType.barrier,
            (10, 1): TerrainType.difficult,
            (10, 3): TerrainType.object,
            (11, 0): TerrainType.barrier,
            (11, 3): TerrainType.barrier,
            (11, 5): TerrainType.barrier,
            (11, 6): TerrainType.barrier,
            (11, 9): TerrainType.exit,
            (12, 1): TerrainType.barrier,
            (12, 4): TerrainType.barrier,
          },
        ),
        onMilestone: {
          '_double_cross': [
            codex(41),
            rules('Double Cross',
                '''Kelo & Saras have revealed their true allegiance to you; discard their ally card. They are now enemies to the Rovers and use the Sek Principal statistic block. Set their current [HP] to their new maximum [HP]. Kelo & Saras immediately perform their “Coordinated Assault” ability. You have 4 rounds to defeat them.'''),
            victoryCondition('Slay Kelo & Saras.'),
            EncounterAction(
                type: EncounterActionType.setLossCondition,
                value: '',
                silent: true),
            codexLink('Don’t Touch my Chains',
                number: 42,
                body:
                    '''Immediately when Kelo & Saras are slain, read [title], [codex] 23.''')
          ],
        },
        allies: [
          AllyDef(
              name: 'Kelo & Saras',
              cardId: 'A-013',
              defaultBehaviorIndex: AllyDef.userSelectsDefaultBehavior,
              behaviors: [
                EncounterFigureDef(
                  name: 'Kelo',
                  health: 8,
                  defense: 1,
                  affinities: const {
                    Ether.fire: -1,
                    Ether.crux: -1,
                    Ether.earth: 1,
                    Ether.morph: 1,
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
                          amount: 1,
                          range: (2, 2),
                          push: 1,
                          exclusiveGroup: 1),
                      RoveAction(
                          type: RoveActionType.jump,
                          amount: 3,
                          targetKind: TargetKind.self,
                          exclusiveGroup: 2),
                      RoveAction(
                          type: RoveActionType.heal,
                          amount: 1,
                          range: (0, 2),
                          targetKind: TargetKind.selfOrAlly,
                          pull: 1,
                          exclusiveGroup: 2),
                    ]),
                  ],
                  onStartPhase: [
                    EncounterAction(
                        type: EncounterActionType.toggleBehavior,
                        conditions: [PhaseCondition(RoundPhase.rover)]),
                  ],
                  onSlain: [fail()],
                  onMilestone: {
                    '_double_cross': [
                      EncounterAction(
                          type: EncounterActionType.replace,
                          value: 'Sek Principal',
                          title: 'Truth Cannot Know Itself'),
                      resetRound(newLimit: 4, silent: true),
                    ]
                  },
                ),
                EncounterFigureDef(
                  name: 'Saras',
                  health: 8,
                  affinities: const {
                    Ether.water: -1,
                    Ether.wind: -1,
                    Ether.fire: 1,
                    Ether.earth: 1,
                  },
                  abilities: [
                    AbilityDef(name: 'Ability', actions: [
                      RoveAction(
                          type: RoveActionType.dash,
                          amount: 4,
                          targetKind: TargetKind.self,
                          exclusiveGroup: 1),
                      RoveAction(
                          type: RoveActionType.attack,
                          amount: 1,
                          range: (1, 1),
                          pierce: true,
                          exclusiveGroup: 1),
                      RoveAction(
                          type: RoveActionType.dash,
                          amount: 3,
                          targetKind: TargetKind.self,
                          exclusiveGroup: 2),
                      RoveAction(
                          type: RoveActionType.attack,
                          amount: 2,
                          range: (1, 2),
                          aoe: AOEDef.x2Line(),
                          targetCount: RoveAction.allTargets,
                          exclusiveGroup: 2),
                    ]),
                  ],
                  onStartPhase: [
                    EncounterAction(
                        type: EncounterActionType.toggleBehavior,
                        conditions: [PhaseCondition(RoundPhase.rover)]),
                  ],
                  onSlain: [fail()],
                  onMilestone: {
                    '_double_cross': [
                      EncounterAction(
                          type: EncounterActionType.replace,
                          value: 'Sek Principal',
                          title: 'Truth Cannot Know Itself'),
                      resetRound(newLimit: 4, silent: true),
                    ]
                  },
                ),
              ]),
          AllyDef(name: 'Skara Grub', behaviors: [
            EncounterFigureDef(
                name: 'Skara Grub',
                health: 6,
                defense: 1,
                reactions: [],
                onSlain: [
                  EncounterAction(type: EncounterActionType.loss),
                ],
                onWillEndRound: [
                  EncounterAction(
                      type: EncounterActionType.milestone,
                      conditions: [
                        OnExitCondition(),
                      ],
                      title: 'Truth Cannot Know Itself',
                      value: '_double_cross')
                ]),
          ])
        ],
        adversaries: [
          EncounterFigureDef(
            name: 'Onisski',
            letter: 'A',
            standeeCount: 4,
            health: 6,
            ignoresDifficultTerrain: true,
            affinities: const {
              Ether.fire: -1,
              Ether.crux: -1,
              Ether.water: 1,
              Ether.morph: 1,
            },
            /* abilities: [
              AbilityDef(name: 'Frenzy Spores', actions: [
                RoveAction.heal(2, endRange: 3).withAugment(ActionAugment(
                    condition: ActorIsInRangeOfCondition(
                        range: (0, 1), target: 'Mushroom'),
                    action: RoveAction.buff(BuffType.amount, 1).withDescription(
                        'If this unit is within [Range] 0-1 of a mushroom space, gain +1 [RCV].'))),
              ]),
              AbilityDef(name: 'Roll Up', actions: [
                RoveAction.jump(3),
                RoveAction.meleeAttack(2).withAugment(ActionAugment(
                    condition: ActorIsInRangeOfCondition(
                        range: (0, 1), target: 'Mushroom'),
                    action: RoveAction.buff(BuffType.amount, 1).withDescription(
                        'If this unit is within [Range] 0-1 of a mushroom space, gain +1 [DMG].')))
              ]),
              AbilityDef(name: 'Fungal Spit', actions: [
                RoveAction(
                    type: RoveActionType.dash,
                    amount: 2,
                    targetKind: TargetKind.self,
                    modifiers: [
                      MoveTowardsModifier('Mushroom')
                    ]).withPrefix(
                    'Logic: Wants to move toward the nearest mushroom space.'),
                RoveAction.rangeAttack(2, endRange: 4).withAugment(ActionAugment(
                    condition: ActorIsInRangeOfCondition(
                        range: (0, 1), target: 'Mushroom'),
                    action: RoveAction.buff(BuffType.field, 0,
                            field: EtherField.snapfrost)
                        .withDescription(
                            'If this unit is within [Range] 0-1 of a mushroom space, gain [snapfrost].')))
              ]),
              AbilityDef(name: 'Desperate Contest', actions: [
                RoveAction.move(3),
                RoveAction.meleeAttack(2, push: 2),
                RoveAction(
                    type: RoveActionType.dash,
                    amount: 2,
                    targetKind: TargetKind.self,
                    modifiers: const [
                      MoveTowardsModifier('Mushroom')
                    ]).withPrefix(
                    'Logic: Wants to move toward the nearest mushroom space.'),
              ]),
            ],*/
          ),
          EncounterFigureDef(
              name: 'Ashemak',
              letter: 'B',
              standeeCount: 6,
              health: 5,
              immuneToForcedMovement: true,
              traits: [
                '''[React] Before this unit is slain:
                
All units within [Range] 1 suffer [DMG]2.'''
              ],
              affinities: const {
                Ether.water: -2,
                Ether.fire: 2,
              },
              /* abilities: [
                AbilityDef(
                    name: 'Burst Pod',
                    actions: [RoveAction.rangeAttack(2, endRange: 4, push: 1)]),
                AbilityDef(
                    name: 'Backdraft',
                    actions: [RoveAction.rangeAttack(2, endRange: 4, pull: 1)]),
                AbilityDef(name: 'Absorb Nutrients', actions: [
                  RoveAction.meleeAttack(2, endRange: 2),
                  RoveAction.heal(2)
                ]),
                AbilityDef(name: 'Throw Pod', actions: [
                  RoveAction.rangeAttack(1,
                      endRange: 4, field: EtherField.wildfire)
                ]),
              ],*/
              reactions: [
                EnemyReactionDef(
                    trigger: ReactionTriggerDef(type: RoveEventType.afterSlain),
                    actions: [
                      RoveAction(
                          type: RoveActionType.suffer,
                          amount: 2,
                          range: (1, 1),
                          targetCount: RoveAction.allTargets)
                    ])
              ],
              onSlain: [
                codex(39),
              ]),
          EncounterFigureDef(
            name: 'Zisafi',
            letter: 'C',
            standeeCount: 8,
            health: 9,
            affinities: const {
              Ether.crux: -1,
              Ether.fire: 1,
              Ether.morph: 1,
            },
/*            abilities: [
              AbilityDef(name: 'Dancing Death', actions: [
                RoveAction.move(3),
                RoveAction.meleeAttack(3),
                RoveAction.move(2, retreat: true, requiresPrevious: true),
              ]),
              AbilityDef(name: 'Flexile Sentry', actions: [
                RoveAction.move(4),
                RoveAction.meleeAttack(2, targetCount: 2),
                RoveAction.heal(1,
                    field: EtherField.windscreen, requiresPrevious: true),
              ]),
              AbilityDef(name: 'Ruthless Skirmsher', actions: [
                RoveAction.move(2),
                RoveAction.rangeAttack(2, endRange: 3),
                RoveAction.move(2, retreat: true, requiresPrevious: true),
              ]),
              AbilityDef(name: 'Go For the Kill', actions: [
                RoveAction.move(4, modifiers: [
                  TargetLowestHealthModifier()
                ]).withPrefix(
                    'Logic: Wants to attack the enemy with the fewest [HP].'),
                RoveAction.meleeAttack(4, pierce: true),
              ]),
            ],*/
          ),
          EncounterFigureDef(
            name: 'Gruv',
            letter: 'D',
            standeeCount: 2,
            healthFormula: '15',
            defenseFormula: '2*(1-T%2)',
            traits: const ['During even rounds, this unit gains [DEF] 2.'],
            affinities: const {
              Ether.water: -1,
              Ether.fire: 1,
              Ether.earth: 2,
            },
            /* abilities: [
              AbilityDef(name: 'Grasping Tongues', actions: [
                RoveAction.move(2),
                RoveAction.meleeAttack(3, endRange: 3, pull: 2),
                RoveAction(
                    type: RoveActionType.heal,
                    targetKind: TargetKind.self,
                    amount: 1,
                    field: EtherField.everbloom,
                    requiresPrevious: true)
              ]),
              AbilityDef(name: 'Piercing Claws', actions: [
                RoveAction.move(3),
                RoveAction(
                    type: RoveActionType.attack,
                    amount: 2,
                    pierce: true,
                    range: (1, 1),
                    aoe: AOEDef.x2Sides(),
                    targetCount: RoveAction.allTargets),
              ]),
              AbilityDef(name: 'Power Dive', actions: [
                RoveAction.jump(4),
                RoveAction(
                    type: RoveActionType.attack,
                    amount: 2,
                    range: (1, 2),
                    targetCount: RoveAction.allTargets),
              ]),
              AbilityDef(name: 'Power Ball', actions: [
                RoveAction(
                    type: RoveActionType.dash,
                    amount: 3,
                    targetKind: TargetKind.self,
                    modifiers: const [TargetFarthestModifier()],
                    staticDescription: RoveActionDescription(
                        prefix:
                            'Logic: Moves to the enemy furthest away, within range of the following attack.')),
                RoveAction(
                    type: RoveActionType.attack,
                    amountFormula: '2+X',
                    range: (1, 1),
                    pushFormula: 'X',
                    xDefinition: RoveActionXDefinition.previousMovementEffort,
                    staticDescription: RoveActionDescription(
                        suffix:
                            'Where X equals the number of spaces moved with the [Dash] action.')),
              ]),
            ],*/
          ),
          EncounterFigureDef(
              name: 'Sek Principal',
              letter: 'E',
              type: AdversaryType.miniboss,
              standeeCount: 1,
              alias: 'Kelo & Saras',
              healthFormula: '8*R',
              defenseFormula: '1+(1*(1-T%2)*(1-C3))+(1*C3)',
              affinities: const {
                Ether.crux: -1,
                Ether.morph: 1,
                Ether.fire: 2,
              },
              traits: const [
                'During even rounds, this unit gains +1 [DEF].'
              ],
              /* abilities: [
                AbilityDef(name: 'Coordinated Assault', actions: [
                  RoveAction.move(4),
                  RoveAction.meleeAttack(2, field: EtherField.wildfire),
                  RoveAction.rangeAttack(2,
                          endRange: 3,
                          field: EtherField.miasma,
                          modifiers: [TargetNextClosestModifier()])
                      .withPrefix(
                          'Logic: Wants to attack the next closest enemy.'),
                ]),
                AbilityDef(name: 'Unnatural Lure', actions: [
                  RoveAction.rangeAttack(
                    2,
                    endRange: 5,
                    pull: 4,
                    modifiers: const [TargetFarthestModifier()],
                  ).withPrefix(
                      'Logic: Wants to attack the enemy that is both furthest away and within range of the attack.'),
                ]),
                AbilityDef(name: 'Safe Cracker', actions: [
                  RoveAction.jump(3),
                  RoveAction(
                          type: RoveActionType.attack,
                          amountFormula: '3+X',
                          range: (1, 1),
                          pierce: true,
                          xDefinition: RoveActionXDefinition.targetDefense)
                      .withSuffix('Where X equals the target\'s [DEF].'),
                ]),
                AbilityDef(name: 'Divesting Thoughts', actions: [
                  RoveAction(type: RoveActionType.command, range: (
                    1,
                    3
                  ), children: [
                    RoveAction.meleeAttack(3, targetKind: TargetKind.self),
                    RoveAction.meleeAttack(3, targetKind: TargetKind.ally),
                  ]),
                ]),
              ],*/
              onSlain: [
                codex(42),
                victory(),
              ]),
          EncounterFigureDef(
              name: 'Urn',
              letter: 'F',
              standeeCount: 2,
              healthFormula: '2*R',
              defense: 2,
              affinities: const {
                Ether.fire: 1,
                Ether.wind: 1,
                Ether.earth: 1,
                Ether.water: 1
              },
              /* abilities: [
                AbilityDef(name: 'Absorb Mucus', actions: [
                  RoveAction.heal(0, amountFormula: 'R'),
                ]),
                AbilityDef(name: 'Slime Trail', actions: [
                  RoveAction.move(1,
                      retreat: true,
                      modifiers: [PlaceTrapOnExitedSpacesModifier(1)]),
                ]),
                AbilityDef(name: 'Interior Renovations', actions: [
                  RoveAction.move(2, retreat: true),
                  RoveAction.heal(1, field: EtherField.everbloom),
                ]),
                AbilityDef(name: 'Elemental Calcifcation', actions: [
                  RoveAction.move(1),
                  RoveAction.meleeAttack(1),
                  RoveAction(
                      type: RoveActionType.removeEther,
                      object: Ether.dim.toJson(),
                      targetMode: RoveActionTargetMode.previous,
                      requiresPrevious: true),
                  RoveAction(
                      type: RoveActionType.generateEther,
                      targetMode: RoveActionTargetMode.previous,
                      requiresPrevious: true),
                ]),
              ],*/
              onSlain: [
                codex(40),
                lyst('5*R'),
                item('Arcana Pigment',
                    body:
                        'The Rover that slayed the urn gains one “Arcana Pigment” item. They may equip this item. If they don’t have the required item slot(s) available, they may unequip items as needed.'),
              ]),
        ],
        placements: const [
          PlacementDef(name: 'Onisski', c: 3, r: 8),
          PlacementDef(name: 'Onisski', c: 5, r: 5, minPlayers: 3),
          PlacementDef(name: 'Onisski', c: 6, r: 3, minPlayers: 4),
          PlacementDef(name: 'Onisski', c: 10, r: 1),
          PlacementDef(name: 'Ashemak', c: 8, r: 0),
          PlacementDef(name: 'Ashemak', c: 12, r: 2),
          PlacementDef(name: 'Ashemak', c: 12, r: 8, minPlayers: 3),
          PlacementDef(name: 'Ashemak', c: 10, r: 9, minPlayers: 3),
          PlacementDef(name: 'Ashemak', c: 4, r: 9),
          PlacementDef(name: 'Ashemak', c: 1, r: 6),
          PlacementDef(name: 'Zisafi', c: 8, r: 1),
          PlacementDef(name: 'Zisafi', c: 12, r: 3, minPlayers: 4),
          PlacementDef(name: 'Zisafi', c: 12, r: 5),
          PlacementDef(name: 'Zisafi', c: 8, r: 9),
          PlacementDef(name: 'Zisafi', c: 2, r: 9, minPlayers: 3),
          PlacementDef(name: 'Zisafi', c: 4, r: 5),
          PlacementDef(name: 'Urn', c: 0, r: 9),
          PlacementDef(name: 'Urn', c: 12, r: 0),
          PlacementDef(name: 'Gruv', c: 10, r: 8),
          PlacementDef(
              name: 'Crumbling Column',
              type: PlacementType.trap,
              c: 1,
              r: 7,
              trapDamage: 2),
          PlacementDef(
              name: 'Crumbling Column',
              type: PlacementType.trap,
              c: 9,
              r: 0,
              trapDamage: 2),
          PlacementDef(
              name: 'Crumbling Column',
              type: PlacementType.trap,
              c: 11,
              r: 7,
              trapDamage: 2),
          PlacementDef(
              name: 'Crumbling Column',
              type: PlacementType.trap,
              c: 9,
              r: 9,
              trapDamage: 2),
          PlacementDef(name: 'fire', type: PlacementType.ether, c: 6, r: 6),
          PlacementDef(name: 'fire', type: PlacementType.ether, c: 10, r: 3),
          PlacementDef(
              name: 'Mushroom', type: PlacementType.feature, c: 3, r: 8),
          PlacementDef(
              name: 'Mushroom', type: PlacementType.feature, c: 5, r: 5),
          PlacementDef(
              name: 'Mushroom', type: PlacementType.feature, c: 6, r: 3),
          PlacementDef(
              name: 'Mushroom', type: PlacementType.feature, c: 10, r: 1),
        ],
      );

  static EncounterDef get encounter2dot5 => EncounterDef(
        questId: '2',
        number: '5',
        title: 'Kenyn and Keb',
        setup: EncounterSetup(
            box: '2/5', map: '15', adversary: '20-23', tiles: '8x Hoard'),
        victoryDescription: 'Slay Marii and Femii.',
        terrain: [
          dangerousCrystals(2),
          EncounterTerrain('hoard',
              title: 'Crystal Spears',
              body:
                  'Hoard tiles are crystal spears. A Rover that enters a space with a hoard tile picks up that tile. To indicate this, place the hoard tile on your class board.'),
          EncounterTerrain('a',
              title: 'Aid Markers',
              body:
                  'There are several spaces marked [a], [b], [c], [d], and [e]. Ignore these encounter aid markers for now. As the encounter progresses, these aid markers will be referenced when it becomes relevant.'),
        ],
        roundLimit: 6,
        baseLystReward: 25,
        unlocksRoverLevel: 4,
        unlocksShopLevel: 2,
        campaignLink: '''Chapter 2 - “A Choice”, [campaign] 38.''',
        challenges: [
          'The lowest crystalline spears can reduce Marii or Femii’s [DEF] is to 1.',
          'When rolling the adversary dice to advance a boss ability token, if the token is not on ability 4, move the token to ability 4 instead.',
          'You start the encounter with 0 ether dice in your personal pool.',
        ],
        playerPossibleTokens: ['Hoard', 'Hoard', 'Hoard', 'Hoard'],
        dialogs: [
          introductionFromText('quest_2_encounter_5_intro'),
        ],
        onLoad: [
          dialog('Introduction'),
          rules('2 Phase Encounter',
              'This is a 2 phase encounter. Each phase has its own round limit.'),
          rules('Crystalline Amor',
              '''*Marii and Femii are well armored in resplendent crystalline armor and are nearly unassailable.*

They have [DEF] R-X, where X equals the number of crystalline spears (hoard tiles) on their statistic block. Use crystalline spears to weaken their defense.'''),
          rules('Crystalline Spears',
              '''Each time a Rover attacks Marii or Femii, you may empower that attack with a crystalline spear (hoard tile). When attacking Marii or Femii, a Rover may move one crystalline spear from their class board to their target’s statistic block to gain +1 [DMG] to that attack.'''),
          rules('On Advance',
              'Adversaries in this encounter use the On Advance mechanic, which is found on page 47 of the rulebook.'),
          codexLink('Usurpation',
              number: 43,
              body:
                  '''Immediately after the turn where Marii is slain first, read [title], [codex] 24.'''),
          codexLink('Desperation',
              number: 45,
              body:
                  '''Immediately after the turn where Femii is slain first, read [title], [codex] 25.'''),
        ],
        startingMap: MapDef(
          id: '2.5',
          columnCount: 13,
          rowCount: 11,
          backgroundRect: Rect.fromLTWH(110.0, 44.0, 1481.0, 1411.0),
          terrain: {
            (1, 3): TerrainType.start,
            (1, 4): TerrainType.start,
            (1, 5): TerrainType.start,
            (1, 6): TerrainType.start,
            (1, 7): TerrainType.start,
            (3, 0): TerrainType.openAir,
            (3, 1): TerrainType.openAir,
            (3, 3): TerrainType.object,
            (3, 8): TerrainType.object,
            (3, 9): TerrainType.openAir,
            (3, 10): TerrainType.openAir,
            (4, 0): TerrainType.openAir,
            (4, 1): TerrainType.dangerous,
            (4, 9): TerrainType.openAir,
            (5, 0): TerrainType.openAir,
            (5, 10): TerrainType.openAir,
            (7, 2): TerrainType.openAir,
            (7, 5): TerrainType.object,
            (7, 8): TerrainType.openAir,
            (8, 0): TerrainType.openAir,
            (8, 1): TerrainType.openAir,
            (8, 8): TerrainType.openAir,
            (8, 9): TerrainType.openAir,
            (9, 0): TerrainType.openAir,
            (9, 10): TerrainType.openAir,
            (10, 2): TerrainType.dangerous,
            (10, 3): TerrainType.openAir,
            (10, 6): TerrainType.openAir,
            (11, 2): TerrainType.openAir,
            (11, 3): TerrainType.openAir,
            (11, 4): TerrainType.openAir,
            (11, 6): TerrainType.openAir,
            (11, 7): TerrainType.openAir,
            (11, 8): TerrainType.openAir,
            (12, 0): TerrainType.openAir,
            (12, 1): TerrainType.openAir,
            (12, 2): TerrainType.openAir,
            (12, 3): TerrainType.openAir,
            (12, 4): TerrainType.openAir,
            (12, 5): TerrainType.openAir,
            (12, 6): TerrainType.openAir,
            (12, 7): TerrainType.openAir,
            (12, 8): TerrainType.openAir,
            (12, 9): TerrainType.openAir,
          },
        ),
        overlays: [
          EncounterFigureDef(
            name: 'Hoard',
            alias: 'Crystal Spear',
            traits: [
              'Hoard tiles are crystal spears. A Rover that enters a space with a hoard tile picks up that tile. To indicate this, place the hoard tile on your class board.'
            ],
            onLoot: [
              EncounterAction(type: EncounterActionType.addToken),
            ],
          )
        ],
        adversaries: [
          EncounterFigureDef(
            name: 'Marii',
            letter: 'A',
            type: AdversaryType.boss,
            standeeCount: 1,
            healthFormula: '12*R',
            defenseFormula: 'R-X',
            xDefinition: 'count_token(Hoard)',
            possibleTokens: ['RxHoard'],
            traits: [
              '''[React] When this unit would suffer the effects of [wildfire]:
              
It ignores the effects of [wildfire] and instead recovers [RCV] 2.'''
            ],
            affinities: {
              Ether.fire: 2,
              Ether.water: -2,
              Ether.crux: -1,
              Ether.morph: 1,
            },
            onSlain: [
              removeCodexLink(45),
              codex(43),
              milestone('_usurpation'),
              rules('Gambit', '''Proceed to page 23 of the adversary book.

Femii now uses the Femii Sovereign statistic block, recovering her current [HP] to maximum. Move the Femii ability token to the same ability number on the Femii Sovereign statistic block.

Move all crystalline spears (hoard tiles) from the Femii statistic block to the Femii Sovereign statistic block.'''),
              rules('Earth Resonance',
                  '''Place an [Earth] dice on ether node [A]. This is now:

**[Earth] Node**:  Units that end their turn within [Range] 1 of this object recover [recover] 1.'''),
              resetRound(
                  title: 'Phase 2',
                  body:
                      'The round limit has been reset. You have 6 rounds to defeat Femii Sovereign.'),
              placementGroup('Usurpation',
                  title: 'Royalist Loyalists',
                  body:
                      '''Femii has called for reinforcements. Spawn adversaries in the following spaces according to R:

2: Spawn one zisafi in each [B] space.
3: Spawn one zisafi in each [B] space. Spawn one zinix in each [D] and [E] space.
4: Spawn one zisafi in each [B] and [C] space. Spawn one zinix in each [D] and [E] space.'''),
              codexLink('Communicate Something Incommunicable',
                  number: 44,
                  body:
                      '''Immediately when Femii is slain, read [title], [codex] 25.''')
            ],
            onMilestone: {
              '_desperation': [
                replace('Marii Advocate', silent: true),
              ]
            },
          ),
          EncounterFigureDef(
            name: 'Femii',
            letter: 'B',
            type: AdversaryType.boss,
            standeeCount: 1,
            healthFormula: '10*R',
            defenseFormula: 'R-X',
            xDefinition: 'count_token(Hoard)',
            possibleTokens: ['RxHoard'],
            traits: [
              'This unit treats all [miasma] as if they were adversary [aura].'
            ],
            affinities: {
              Ether.fire: -1,
              Ether.earth: 1,
              Ether.crux: -2,
              Ether.morph: 2,
            },
            onSlain: [
              removeCodexLink(43),
              codex(45),
              milestone('_desperation'),
              rules('Gambit', '''Proceed to page 22 of the adversary book.

Marii now uses the Marii Advocate statistic block, recovering her current [HP] to maximum. Move the Marii ability token to the same ability number on the Marii Advocate statistic block.

Move all crystalline spears (hoard tiles) from the Marii statistic block to the Marii Advocate statistic block.'''),
              resetRound(
                  title: 'Phase 2',
                  body:
                      'The round limit has been reset. You have 6 rounds to defeat Marii Advocate.'),
              rules('Fire Resonance',
                  '''Fire Resonance:  Place a [Fire] dice on ether node [A]. This is now:
                  
**[Fire] Node**:  Units that end their turn within [Range] 1 of this object suffer [DMG]1.'''),
              placementGroup('Desperation',
                  title: 'Royalist Loyalists',
                  body:
                      '''Marii has called for reinforcements. Spawn adversaries in the following spaces according to R:

2: Spawn one sek in each [B] space.
3: Spawn one sek in each [B] space. Spawn one ashemak in each [D] and [E] space.
4: Spawn one sek in each [B] and [C] space. Spawn one ashemak in each [D] and [E] space.'''),
              codexLink('Explain Something Inexplicable',
                  number: 46,
                  body:
                      '''Immediately when Marii is slain, read [title], [codex] 26.'''),
            ],
            onMilestone: {
              '_usurpation': [
                replace('Femii Sovereign', silent: true),
              ],
            },
          ),
          EncounterFigureDef(
            name: 'Zinix',
            letter: 'A',
            standeeCount: 6,
            entersObjectSpaces: true,
            health: 5,
            defense: 1,
            affinities: const {
              Ether.wind: -1,
              Ether.fire: -1,
              Ether.earth: 1,
              Ether.water: 1,
            },
/*              abilities: [
                AbilityDef(
                    name: 'Iron Jaw',
                    actions: [RoveAction.move(2), RoveAction.meleeAttack(3)]),
                AbilityDef(name: 'Dust Bloom', actions: [
                  RoveAction.move(1),
                  RoveAction(
                      type: RoveActionType.attack,
                      amount: 2,
                      range: (2, 3),
                      aoe: AOEDef.x3Triangle(),
                      targetCount: RoveAction.allTargets)
                ]),
                AbilityDef(name: 'Chew Cladrind', actions: [
                  RoveAction.move(2),
                  RoveAction.meleeAttack(2),
                  RoveAction.heal(1, field: EtherField.everbloom),
                ]),
                AbilityDef(name: 'Hail of Stones', actions: [
                  RoveAction(
                      type: RoveActionType.attack,
                      amount: 1,
                      range: (1, 3),
                      pierce: true,
                      targetCount: RoveAction.allTargets),
                ]),
              ].*/
          ),
          EncounterFigureDef(
            name: 'Zisafi',
            letter: 'B',
            standeeCount: 8,
            health: 9,
            affinities: const {
              Ether.crux: -1,
              Ether.fire: 1,
              Ether.morph: 1,
            },
/*            abilities: [
              AbilityDef(name: 'Dancing Death', actions: [
                RoveAction.move(3),
                RoveAction.meleeAttack(3),
                RoveAction.move(2, retreat: true, requiresPrevious: true),
              ]),
              AbilityDef(name: 'Flexile Sentry', actions: [
                RoveAction.move(4),
                RoveAction.meleeAttack(2, targetCount: 2),
                RoveAction.heal(1,
                    field: EtherField.windscreen, requiresPrevious: true),
              ]),
              AbilityDef(name: 'Ruthless Skirmsher', actions: [
                RoveAction.move(2),
                RoveAction.rangeAttack(2, endRange: 3),
                RoveAction.move(2, retreat: true, requiresPrevious: true),
              ]),
              AbilityDef(name: 'Go For the Kill', actions: [
                RoveAction.move(4, modifiers: [
                  TargetLowestHealthModifier()
                ]).withPrefix(
                    'Logic: Wants to attack the enemy with the fewest [HP].'),
                RoveAction.meleeAttack(4, pierce: true),
              ]),
            ],*/
          ),
          EncounterFigureDef(
            name: 'Ashemak',
            letter: 'A',
            standeeCount: 6,
            health: 5,
            immuneToForcedMovement: true,
            traits: [
              '''[React] Before this unit is slain:
                
All units within [Range] 1 suffer [DMG]2.'''
            ],
            affinities: const {
              Ether.water: -2,
              Ether.fire: 2,
            },
            /* abilities: [
                AbilityDef(
                    name: 'Burst Pod',
                    actions: [RoveAction.rangeAttack(2, endRange: 4, push: 1)]),
                AbilityDef(
                    name: 'Backdraft',
                    actions: [RoveAction.rangeAttack(2, endRange: 4, pull: 1)]),
                AbilityDef(name: 'Absorb Nutrients', actions: [
                  RoveAction.meleeAttack(2, endRange: 2),
                  RoveAction.heal(2)
                ]),
                AbilityDef(name: 'Throw Pod', actions: [
                  RoveAction.rangeAttack(1,
                      endRange: 4, field: EtherField.wildfire)
                ]),
              ],
              reactions: [
                EnemyReactionDef(
                    trigger: ReactionTriggerDef(type: RoveEventType.afterSlain),
                    actions: [
                      RoveAction(
                          type: RoveActionType.suffer,
                          amount: 2,
                          range: (1, 1),
                          targetCount: RoveAction.allTargets)
                    ])
              ],*/
          ),
          EncounterFigureDef(
            name: 'Sek',
            letter: 'B',
            standeeCount: 8,
            health: 10,
            defense: 1,
            affinities: const {
              Ether.crux: -1,
              Ether.fire: 1,
              Ether.morph: 1,
            },
/*            abilities: [
              AbilityDef(
                name: 'Dual Strike',
                actions: [
                  RoveAction.jump(3),
                  RoveAction.meleeAttack(2),
                  RoveAction.rangeAttack(2,
                          endRange: 3, modifiers: [TargetNextClosestModifier()])
                      .withPrefix(
                          'Logic: Wants to attack the next closest enemy.')
                ],
              ),
              AbilityDef(
                name: 'Living Shell',
                actions: [
                  RoveAction.heal(1, field: EtherField.windscreen),
                  RoveAction.meleeAttack(1,
                      endRange: 3, push: 2, targetCount: RoveAction.allTargets),
                ],
              ),
              AbilityDef(name: 'Safe Cracker', actions: [
                RoveAction.move(4),
                RoveAction(
                        type: RoveActionType.attack,
                        amountFormula: '3+X',
                        pierce: true,
                        xDefinition: RoveActionXDefinition.targetDefense)
                    .withSuffix('Where X equal\'s the target\'s [DEF].')
              ]),
              AbilityDef(name: 'Strange Chatter', actions: [
                RoveAction.move(2),
                RoveAction.rangeAttack(3, endRange: 3, field: EtherField.miasma)
              ]),
            ],*/
          ),
          EncounterFigureDef(
            name: 'Femii Sovereign',
            letter: 'C',
            type: AdversaryType.boss,
            standeeCount: 1,
            healthFormula: '10*R',
            defenseFormula: 'R-X',
            xDefinition: 'count_token(Hoard)',
            possibleTokens: ['RxHoard'],
            traits: [
              'This unit treats all [miasma] as if they were adversary [aura].'
            ],
            affinities: {
              Ether.fire: -1,
              Ether.earth: 2,
              Ether.crux: -2,
              Ether.morph: 2,
            },
            onSlain: [
              codex(44),
              victory(),
              item('Ezmenite Plate'),
              milestone(CampaignMilestone.milestone2dot5Sovereign),
              codex(47),
            ],
          ),
          EncounterFigureDef(
            name: 'Marii Advocate',
            letter: 'C',
            type: AdversaryType.boss,
            standeeCount: 1,
            healthFormula: '12*R',
            defenseFormula: 'R-X',
            xDefinition: 'count_token(Hoard)',
            possibleTokens: ['RxHoard'],
            traits: [
              '[React] When this unit would suffer the effects of [wildfire]: It ignores the effects of [wildfire] and instead recovers [RCV] 2.'
            ],
            affinities: {
              Ether.fire: 2,
              Ether.water: -2,
              Ether.crux: -1,
              Ether.morph: 2,
            },
            onSlain: [
              codex(46),
              victory(),
              item('Ezmenite Lance'),
              milestone(CampaignMilestone.milestone2dot5Advocate),
              codex(47),
            ],
          ),
        ],
        placements: const [
          PlacementDef(name: 'Femii', c: 11, r: 5),
          PlacementDef(name: 'Marii', c: 9, r: 5),
          PlacementDef(name: 'Hoard', type: PlacementType.object, c: 1, r: 0),
          PlacementDef(name: 'Hoard', type: PlacementType.object, c: 1, r: 10),
          PlacementDef(name: 'Hoard', type: PlacementType.object, c: 6, r: 9),
          PlacementDef(name: 'Hoard', type: PlacementType.object, c: 10, r: 9),
          PlacementDef(name: 'Hoard', type: PlacementType.object, c: 8, r: 7),
          PlacementDef(name: 'Hoard', type: PlacementType.object, c: 8, r: 2),
          PlacementDef(name: 'Hoard', type: PlacementType.object, c: 5, r: 1),
          PlacementDef(name: 'Hoard', type: PlacementType.object, c: 11, r: 1),
          PlacementDef(name: 'B', type: PlacementType.feature, c: 0, r: 4),
          PlacementDef(name: 'A', type: PlacementType.feature, c: 7, r: 5),
          PlacementDef(name: 'C', type: PlacementType.feature, c: 0, r: 5),
          PlacementDef(name: 'D', type: PlacementType.feature, c: 7, r: 4),
          PlacementDef(name: 'D', type: PlacementType.feature, c: 7, r: 6),
          PlacementDef(name: 'E', type: PlacementType.feature, c: 4, r: 2),
          PlacementDef(name: 'E', type: PlacementType.feature, c: 4, r: 8),
        ],
        placementGroups: const [
          PlacementGroupDef(
            name: 'Usurpation',
            placements: [
              PlacementDef(name: 'Zisafi', c: 0, r: 4, fixedTokens: ['B']),
              PlacementDef(
                  name: 'Zinix', c: 7, r: 4, minPlayers: 3, fixedTokens: ['D']),
              PlacementDef(
                  name: 'Zinix', c: 7, r: 6, minPlayers: 3, fixedTokens: ['D']),
              PlacementDef(
                  name: 'Zinix', c: 4, r: 2, minPlayers: 3, fixedTokens: ['E']),
              PlacementDef(
                  name: 'Zinix', c: 4, r: 8, minPlayers: 3, fixedTokens: ['E']),
              PlacementDef(
                  name: 'Zisafi',
                  c: 0,
                  r: 5,
                  minPlayers: 4,
                  fixedTokens: ['C']),
              PlacementDef(
                  name: 'earth', type: PlacementType.ether, c: 7, r: 5),
            ],
          ),
          PlacementGroupDef(
            name: 'Desperation',
            placements: [
              PlacementDef(name: 'Sek', c: 0, r: 4, fixedTokens: ['B']),
              PlacementDef(
                  name: 'Sek', c: 0, r: 5, minPlayers: 4, fixedTokens: ['C']),
              PlacementDef(
                  name: 'Ashemak',
                  c: 7,
                  r: 4,
                  minPlayers: 3,
                  fixedTokens: ['D']),
              PlacementDef(
                  name: 'Ashemak',
                  c: 4,
                  r: 8,
                  minPlayers: 3,
                  fixedTokens: ['D']),
              PlacementDef(
                  name: 'Ashemak',
                  c: 7,
                  r: 6,
                  minPlayers: 3,
                  fixedTokens: ['E']),
              PlacementDef(
                  name: 'Ashemak',
                  c: 4,
                  r: 2,
                  minPlayers: 3,
                  fixedTokens: ['E']),
              PlacementDef(name: 'fire', type: PlacementType.ether, c: 7, r: 5),
            ],
          ),
        ],
      );
}
