import 'dart:ui';
import 'encounter_def_utils.dart';
import 'package:rove_data_types/rove_data_types.dart';

extension Quest5 on EncounterDef {
  static EncounterDef get encounter5dot1 => EncounterDef(
        questId: '5',
        number: '1',
        title: 'A Poor Translation',
        setup: EncounterSetup(
            box: '2/5',
            map: '33',
            adversary: '54-55',
            tiles: '3x Crumbling Columns'),
        victoryDescription: 'Slay all adversaries, not including the urn.',
        roundLimit: 8,
        terrain: [
          trapColumn(3),
          etherFire(),
          etherEarth(),
        ],
        baseLystReward: 20,
        campaignLink:
            '''Encounter 5.2 - “**A Cage In Search**”, [campaign] **76**.''',
        challenges: [
          'Bulwauros ignore the [pierce] effect.',
          'If a Rover deals 0 damage with an attack, place a [wildfire] in their space.',
          'When rolling the damage dice for adversary attacks, treat a result of [DIM] as +1 [DMG].',
        ],
        onLoad: [
          dialog('Introduction'),
          rules('Mastered Beasts',
              '''This encounter is pretty straightforward. Fight your way through the Keb Raska forces, slaying all adversaries to win. However, pay close attention to the bulwarous and wrathbone traits. While the Zisafi Principal is alive, the bulwarous and wrathbone are more resilient and deadly.'''),
          codexLink('Unknown Nourishment',
              number: 87,
              body:
                  '''The first time a bulwarous is slain, read [title], [codex] 44.'''),
          codexLink('Letting Them Devour',
              number: 88,
              body: '''If the urn is slain, read [title], [codex] 44.'''),
          codexLink('Beyond a Certain Point',
              number: 89,
              body:
                  '''At the end of the round where all adversaries not including the urn are slain, read [title], [codex] 44.'''),
        ],
        onMilestone: {
          '_slayed_all': [
            codex(89),
            victory(),
          ]
        },
        dialogs: [
          introductionFromText('quest_5_encounter_1_intro'),
        ],
        startingMap: MapDef(
          id: '5.1',
          columnCount: 13,
          rowCount: 11,
          backgroundRect: Rect.fromLTWH(110.0, 44.0, 1481.0, 1411.0),
          starts: [
            (1, 10),
            (3, 10),
            (5, 10),
            (7, 10),
            (9, 10),
            (11, 10),
          ],
          terrain: {
            (0, 0): TerrainType.openAir,
            (0, 1): TerrainType.openAir,
            (0, 2): TerrainType.openAir,
            (0, 3): TerrainType.openAir,
            (0, 4): TerrainType.openAir,
            (0, 5): TerrainType.openAir,
            (0, 6): TerrainType.openAir,
            (0, 7): TerrainType.openAir,
            (0, 8): TerrainType.openAir,
            (0, 9): TerrainType.openAir,
            (1, 1): TerrainType.openAir,
            (1, 2): TerrainType.openAir,
            (1, 3): TerrainType.openAir,
            (1, 4): TerrainType.openAir,
            (1, 5): TerrainType.openAir,
            (1, 6): TerrainType.openAir,
            (1, 7): TerrainType.openAir,
            (1, 8): TerrainType.openAir,
            (1, 9): TerrainType.openAir,
            (2, 1): TerrainType.openAir,
            (2, 2): TerrainType.openAir,
            (2, 3): TerrainType.openAir,
            (2, 4): TerrainType.openAir,
            (4, 6): TerrainType.object,
            (5, 1): TerrainType.object,
            (6, 7): TerrainType.difficult,
            (8, 4): TerrainType.object,
            (9, 6): TerrainType.difficult,
            (10, 1): TerrainType.openAir,
            (10, 2): TerrainType.openAir,
            (10, 3): TerrainType.openAir,
            (10, 4): TerrainType.openAir,
            (11, 1): TerrainType.openAir,
            (11, 2): TerrainType.openAir,
            (11, 3): TerrainType.openAir,
            (11, 4): TerrainType.openAir,
            (11, 5): TerrainType.openAir,
            (11, 6): TerrainType.openAir,
            (11, 7): TerrainType.openAir,
            (11, 8): TerrainType.openAir,
            (11, 9): TerrainType.openAir,
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
        adversaries: [
          EncounterFigureDef(
            name: 'Bulwauros',
            letter: 'A',
            health: 6,
            defenseFormula: '3+X',
            xDefinition: 'count_adversary(Zisafi Principal)',
            traits: [
              'If this unit is damaged, reduce its [DEF] by 3.',
              'If the Zisafi Principal is alive, this unit gains +1 [DEF] and +1 [DMG] to all attacks they perform.'
            ],
            affinities: {
              Ether.water: -2,
              Ether.morph: -1,
              Ether.earth: 2,
            },
            reactions: [
              EnemyReactionDef(
                  trigger: ReactionTriggerDef(
                      type: RoveEventType.afterSuffer,
                      targetKind: TargetKind.self),
                  actions: [
                    RoveAction(
                        type: RoveActionType.addDefense,
                        amount: -3,
                        targetKind: TargetKind.self)
                  ])
            ],
            onSlain: [
              codex(87),
              milestone('_slayed_all',
                  condition: AllAdversariesSlainExceptCondition('Urn')),
            ],
          ),
          EncounterFigureDef(
            name: 'Wrathbone',
            letter: 'B',
            health: 16,
            defenseFormula: 'X',
            xDefinition: 'count_adversary(Zisafi Principal)',
            traits: [
              '[React] At the end of the Rover phase: All enemies within [Range] 1-2 suffer [DMG]1.',
            ],
            affinities: {
              Ether.water: -2,
              Ether.fire: 2,
              Ether.earth: 1,
            },
            onSlain: [
              milestone('_slayed_all',
                  condition: AllAdversariesSlainExceptCondition('Urn')),
            ],
          ),
          EncounterFigureDef(
            name: 'Sek',
            letter: 'C',
            health: 12,
            affinities: {
              Ether.crux: -1,
              Ether.fire: 1,
              Ether.morph: 2,
            },
            onSlain: [
              milestone('_slayed_all',
                  condition: AllAdversariesSlainExceptCondition('Urn')),
            ],
          ),
          EncounterFigureDef(
            name: 'Zisafi Principal',
            letter: 'D',
            type: AdversaryType.miniboss,
            healthFormula: '9*R',
            affinities: {
              Ether.crux: -1,
              Ether.morph: 1,
              Ether.fire: 2,
            },
            onSlain: [
              milestone('_slayed_all',
                  condition: AllAdversariesSlainExceptCondition('Urn')),
            ],
          ),
          EncounterFigureDef(
            name: 'Urn',
            letter: 'E',
            healthFormula: '3*R',
            defense: 3,
            affinities: {
              Ether.fire: 2,
              Ether.earth: 2,
              Ether.water: 2,
              Ether.wind: 2,
            },
            onSlain: [
              codex(88),
              lyst('5*R'),
              item('Arcana Pigment',
                  body:
                      'The Rover that slayed the urn gains an “Arcana Pigment” item. They may equip this item. If they don’t have the required item slot(s) available, they may unequip items as needed.'),
              item('Arcana Pigment',
                  body:
                      'The Rover that slayed the urn gains another “Arcana Pigment” item. They may equip this item. If they don’t have the required item slot(s) available, they may unequip items as needed.'),
            ],
          ),
        ],
        placements: const [
          PlacementDef(name: 'Bulwauros', c: 2, r: 5),
          PlacementDef(name: 'Bulwauros', c: 4, r: 5, minPlayers: 4),
          PlacementDef(name: 'Bulwauros', c: 8, r: 5, minPlayers: 3),
          PlacementDef(name: 'Bulwauros', c: 10, r: 5),
          PlacementDef(name: 'Urn', c: 6, r: 4),
          PlacementDef(name: 'Wrathbone', c: 5, r: 3, minPlayers: 3),
          PlacementDef(name: 'Wrathbone', c: 7, r: 3),
          PlacementDef(name: 'Sek', c: 6, r: 2),
          PlacementDef(name: 'Sek', c: 8, r: 2, minPlayers: 4),
          PlacementDef(name: 'Zisafi Principal', c: 7, r: 1),
          PlacementDef(
              name: 'Crumbling Column',
              type: PlacementType.trap,
              c: 3,
              r: 2,
              trapDamage: 3),
          PlacementDef(
              name: 'Crumbling Column',
              type: PlacementType.trap,
              c: 6,
              r: 8,
              trapDamage: 3),
          PlacementDef(
              name: 'Crumbling Column',
              type: PlacementType.trap,
              c: 9,
              r: 5,
              trapDamage: 3),
          PlacementDef(name: 'earth', type: PlacementType.ether, c: 4, r: 6),
          PlacementDef(name: 'earth', type: PlacementType.ether, c: 8, r: 4),
          PlacementDef(name: 'fire', type: PlacementType.ether, c: 5, r: 1),
        ],
      );

  static EncounterDef get encounter5dot2 => EncounterDef(
        questId: '5',
        number: '2',
        title: 'A Cage In Search',
        setup: EncounterSetup(
            box: '2/5',
            map: '34',
            adversary: '56-57',
            tiles: '3x Crumbling Columns'),
        victoryDescription: 'Slay all adversaries.',
        roundLimit: 8,
        terrain: [
          EncounterTerrain('dangerous_fire',
              title: 'Fire',
              damage: 1,
              body:
                  'Non-flying units that enter fire suffer [DMG] 1. Wrathbone ignores this effect.'),
          trapColumn(3),
          etherMorph(),
          etherEarth(),
        ],
        baseLystReward: 15,
        unlocksRoverLevel: 6,
        campaignLink:
            '''Encounter 5.3 - “**Apathetic, Witless, Fearful**”, [campaign] **78**.''',
        challenges: [
          'Zisafi Taskmasters have +4 [HP].',
          'Seks gain +1 [DMG] to all of their attacks.',
          'Each time a Rover places an ether field in an enemy space, they place the same ether field in their own space.',
        ],
        dialogs: [
          introductionFromText('quest_5_encounter_2_intro'),
        ],
        onLoad: [
          dialog('Introduction'),
          rules('Enslavement',
              '''For this encounter, seks represent a clan forced into enslavement by the cruel zisafi taskmasters. On the map each pairing of zisafi and sek are marked with an elemental icon as a note. Zisafi can command their specifically enslaved target. While the seks are part of the adversary faction, take note of their trait. They have a special defeat state. If the zisafi the sek is enslaved to is slain, that sek regains their wits and leaves the battlefield (they are defeated and removed from the map).

Keep track of the number of seks you are able to free from enslavement during this encounter. *[The app does this automatically.]*'''),
          codexLink('Means of Intoxication',
              number: 90,
              body:
                  '''The first time a skara is slain, read [title], [codex] 44.'''),
          codexLink('Sleep-Walkers, Not Evildoers',
              number: 91,
              body:
                  '''At the end of the round where all adversaries are slain, read [title], [codex] 45.'''),
        ],
        onMilestone: {
          '_slayed_all': [
            codex(91),
            victory(),
          ]
        },
        startingMap: MapDef(
          id: '5.2',
          columnCount: 13,
          rowCount: 11,
          backgroundRect: Rect.fromLTWH(110.0, 44.0, 1481.0, 1411.0),
          starts: [
            (1, 10),
            (3, 10),
            (5, 10),
            (7, 10),
            (9, 10),
            (11, 10),
          ],
          terrain: {
            (0, 0): TerrainType.object,
            (0, 2): TerrainType.object,
            (0, 6): TerrainType.object,
            (0, 7): TerrainType.object,
            (1, 0): TerrainType.object,
            (1, 2): TerrainType.object,
            (1, 3): TerrainType.object,
            (1, 7): TerrainType.object,
            (1, 8): TerrainType.object,
            (3, 0): TerrainType.object,
            (3, 1): TerrainType.object,
            (4, 0): TerrainType.object,
            (4, 2): TerrainType.dangerous,
            (4, 5): TerrainType.object,
            (6, 1): TerrainType.object,
            (7, 1): TerrainType.object,
            (7, 2): TerrainType.object,
            (8, 7): TerrainType.object,
            (9, 0): TerrainType.dangerous,
            (9, 2): TerrainType.object,
            (9, 3): TerrainType.object,
            (10, 2): TerrainType.object,
            (11, 0): TerrainType.object,
            (11, 1): TerrainType.object,
            (11, 7): TerrainType.object,
            (11, 8): TerrainType.object,
            (12, 0): TerrainType.object,
            (12, 2): TerrainType.object,
            (12, 3): TerrainType.object,
            (12, 7): TerrainType.object,
            (12, 8): TerrainType.object,
          },
        ),
        adversaries: [
          EncounterFigureDef(
            name: 'Skara',
            letter: 'A',
            health: 7,
            defense: 1,
            affinities: {
              Ether.crux: -1,
              Ether.earth: 1,
              Ether.morph: 1,
            },
            onSlain: [
              codex(90),
              milestone('_slayed_all',
                  condition: AllAdversariesSlainCondition()),
            ],
          ),
          EncounterFigureDef(
            name: 'Wrathbone',
            letter: 'B',
            health: 16,
            traits: [
              '''[React] At the end of the Rover phase:
              
All enemies within [Range] 1-2 suffer [DMG]1.''',
              'Ignores the effect of fire dangerous terrain.',
            ],
            affinities: {
              Ether.fire: 2,
              Ether.earth: 1,
              Ether.water: -2,
            },
            onSlain: [
              milestone('_slayed_all',
                  condition: AllAdversariesSlainCondition()),
            ],
          ),
          EncounterFigureDef(
            name: 'Sek',
            letter: 'C',
            health: 12,
            defense: 1,
            traits: [
              '''[React] When the Zisafi Taskmaster enslaving this unit is slain:
              
This unit is immediately defeated and removed from the map.''',
            ],
            affinities: {
              Ether.crux: -1,
              Ether.fire: 1,
              Ether.morph: 2,
            },
            onSlain: [
              milestone('_slayed_all',
                  condition: AllAdversariesSlainCondition()),
            ],
          ),
          EncounterFigureDef(
            name: 'Zisafi Taskmaster',
            letter: 'D',
            health: 11,
            traits: [
              'When this unit suffers [DMG] from any source, if its enslaved sek is active, divide that [DMG] by 2.',
            ],
            affinities: {
              Ether.crux: -1,
              Ether.morph: 1,
              Ether.fire: 2,
            },
            onSlain: [
              milestone('_slayed_all',
                  condition: AllAdversariesSlainCondition()),
            ],
          ),
        ],
        placements: [
          PlacementDef(name: 'Skara', c: 1, r: 5),
          PlacementDef(name: 'Skara', c: 12, r: 5),
          PlacementDef(name: 'Wrathbone', c: 6, r: 4, minPlayers: 3),
          PlacementDef(name: 'Wrathbone', c: 6, r: 2, minPlayers: 4),
          PlacementDef(
            name: 'Sek',
            alias: 'Sek [Fire]',
            fixedTokens: ['Fire'],
            c: 2,
            r: 2,
            minPlayers: 3,
          ),
          PlacementDef(
            name: 'Sek',
            alias: 'Sek [Crux]',
            fixedTokens: ['Crux'],
            c: 3,
            r: 4,
          ),
          PlacementDef(
            name: 'Sek',
            alias: 'Sek [Wind]',
            fixedTokens: ['Wind'],
            c: 9,
            r: 4,
          ),
          PlacementDef(
            name: 'Sek',
            alias: 'Sek [Water]',
            fixedTokens: ['Water'],
            c: 11,
            r: 2,
            minPlayers: 4,
          ),
          PlacementDef(
            name: 'Zisafi Taskmaster',
            alias: 'Zisafi Taskmaster [Fire]',
            fixedTokens: ['Fire'],
            c: 2,
            r: 1,
            minPlayers: 3,
            onSlain: [
              lyst(
                '10',
                title: 'Sek Freed',
                condition: IsAliveCondition('Sek [Fire]'),
                silent: true,
              ),
              remove('Sek [Fire]', condition: IsAliveCondition('Sek [Fire]')),
            ],
          ),
          PlacementDef(
            name: 'Zisafi Taskmaster',
            alias: 'Zisafi Taskmaster [Crux]',
            fixedTokens: ['Crux'],
            c: 4,
            r: 3,
            onSlain: [
              lyst(
                '10',
                title: 'Sek Freed',
                condition: IsAliveCondition('Sek [Crux]'),
                silent: true,
              ),
              remove('Sek [Crux]', condition: IsAliveCondition('Sek [Crux]')),
            ],
          ),
          PlacementDef(
            name: 'Zisafi Taskmaster',
            alias: 'Zisafi Taskmaster [Wind]',
            fixedTokens: ['Wind'],
            c: 8,
            r: 3,
            onSlain: [
              lyst(
                '10',
                title: 'Sek Freed',
                condition: IsAliveCondition('Sek [Wind]'),
                silent: true,
              ),
              remove('Sek [Wind]', condition: IsAliveCondition('Sek [Wind]')),
            ],
          ),
          PlacementDef(
            name: 'Zisafi Taskmaster',
            alias: 'Zisafi Taskmaster [Water]',
            fixedTokens: ['Water'],
            c: 10,
            r: 1,
            minPlayers: 4,
            onSlain: [
              lyst(
                '10',
                title: 'Sek Freed',
                condition: IsAliveCondition('Sek [Water]'),
                silent: true,
              ),
              remove('Sek [Water]', condition: IsAliveCondition('Sek [Water]')),
            ],
          ),
          PlacementDef(
              name: 'Crumbling Column',
              type: PlacementType.trap,
              c: 0,
              r: 5,
              trapDamage: 3),
          PlacementDef(
              name: 'Crumbling Column',
              type: PlacementType.trap,
              c: 12,
              r: 6,
              trapDamage: 3),
          PlacementDef(name: 'morph', type: PlacementType.ether, c: 8, r: 7),
          PlacementDef(name: 'earth', type: PlacementType.ether, c: 4, r: 5),
        ],
      );

  static EncounterDef get encounter5dot3 => EncounterDef(
        questId: '5',
        number: '3',
        title: 'Apathetic, Witless, Fearful',
        setup: EncounterSetup(
            box: '2/5',
            map: '35',
            adversary: '58-59',
            tiles: '4x Crumbling Columns'),
        victoryDescription: 'Slay Kelo and Saras.',
        roundLimit: 8,
        terrain: [
          dangerousCrystals(1),
          trapColumn(3),
          etherEarth(),
          etherMorph(),
        ],
        baseLystReward: 15,
        campaignLink:
            '''Encounter 5.4 - “**Fearless, Powerful, Surprisng**”, [campaign] **80**.''',
        itemRewards: [
          'Serrated Requital',
        ],
        challenges: [
          'Each time a Rover deals 3 or more [DMG] with an attack, they drain an ether dice in their personal supply, if able to.',
          'Skara have +2 [HP].',
          'Kelo takes two turns each round. Roll the ability dice to determine a new ability before Kelo’s second turn.',
        ],
        dialogs: [
          introductionFromText('quest_5_encounter_3_intro'),
        ],
        onLoad: [
          dialog('Introduction'),
          rules('Saras',
              '''Only Saras can be targeted for now. Kelo is attached to Saras and is using Saras to hide from your attacks. Kelo still takes turns each round. Perform all of Kelo’s abilities from the Kelo and Saras standee

You will have to slay both Kelo and Saras to win this encounter. Once you slay Saras, you will get a chance to attack Kelo directly. Move quickly.'''),
          codexLink('The Only Truth is Longing',
              number: 92,
              body:
                  '''Immediately after the action where Saras is slain, read [title], [codex] 45.'''),
        ],
        startingMap: MapDef(
          id: '5.3',
          columnCount: 13,
          rowCount: 11,
          backgroundRect: Rect.fromLTWH(110.0, 44.0, 1481.0, 1411.0),
          starts: [
            (0, 0),
            (0, 1),
            (1, 0),
            (1, 1),
            (2, 0),
            (3, 0),
          ],
          terrain: {
            (0, 3): TerrainType.barrier,
            (0, 4): TerrainType.barrier,
            (1, 10): TerrainType.barrier,
            (2, 3): TerrainType.difficult,
            (2, 5): TerrainType.object,
            (2, 9): TerrainType.barrier,
            (3, 2): TerrainType.object,
            (3, 10): TerrainType.barrier,
            (5, 1): TerrainType.difficult,
            (5, 6): TerrainType.difficult,
            (5, 9): TerrainType.object,
            (7, 2): TerrainType.object,
            (7, 9): TerrainType.object,
            (7, 10): TerrainType.object,
            (8, 5): TerrainType.object,
            (8, 9): TerrainType.object,
            (9, 4): TerrainType.difficult,
            (9, 9): TerrainType.barrier,
            (9, 10): TerrainType.object,
            (10, 9): TerrainType.barrier,
            (11, 0): TerrainType.barrier,
            (11, 4): TerrainType.object,
            (11, 6): TerrainType.barrier,
            (11, 7): TerrainType.object,
            (11, 8): TerrainType.barrier,
            (11, 10): TerrainType.barrier,
            (12, 0): TerrainType.barrier,
            (12, 5): TerrainType.barrier,
            (12, 6): TerrainType.barrier,
            (12, 7): TerrainType.object,
            (12, 8): TerrainType.barrier,
          },
        ),
        adversaries: [
          EncounterFigureDef(
            name: 'Bulwauros',
            letter: 'A',
            health: 6,
            defense: 3,
            traits: [
              'If this unit is damaged, reduce its [DEF] by 3.',
            ],
            affinities: {
              Ether.water: -2,
              Ether.morph: -1,
              Ether.earth: 2,
            },
            reactions: [
              EnemyReactionDef(
                  trigger: ReactionTriggerDef(
                      type: RoveEventType.afterSuffer,
                      targetKind: TargetKind.self),
                  actions: [
                    RoveAction(
                        type: RoveActionType.addDefense,
                        amount: -3,
                        targetKind: TargetKind.self)
                  ])
            ],
          ),
          EncounterFigureDef(
            name: 'Skara',
            letter: 'B',
            health: 7,
            defense: 1,
            affinities: {
              Ether.crux: -1,
              Ether.earth: 1,
              Ether.morph: 1,
            },
          ),
          EncounterFigureDef(
            name: 'Gruv',
            letter: 'C',
            health: 18,
            defenseFormula: '3*(1-T%2)',
            traits: [
              'During even rounds, this unit gains [Def] 3.',
            ],
            affinities: {
              Ether.water: -1,
              Ether.fire: 1,
              Ether.earth: 2,
            },
          ),
          EncounterFigureDef(
              name: 'Saras',
              letter: 'D',
              type: AdversaryType.miniboss,
              healthFormula: '10*R',
              defenseFormula: 'X',
              xDefinition: 'count_adversary(Skara)',
              traits: [
                'Saras gains +X [DEF], where X equals the number of Skara on the map.'
              ],
              affinities: {
                Ether.fire: 2,
                Ether.crux: 1,
                Ether.wind: -1,
              },
              onSlain: [
                removeRule('Saras'),
                codex(92),
                replace('Kelo', silent: true),
                rules('Kelo', '''*Saras is dead.*
                    
Continue the encounter fighting Kelo using the same standee. Kelo can now be targeted.

Saras still takes turns each round. Perform all of Saras’ abilities from the Kelo and Saras standee. You can no longer target Saras as no amount of damage will stop Kelo’s control of their body.

Saras gains +2 [DMG] to all of their attacks.'''),
                codexLink('A Grave, Deep and Narrow',
                    number: 93,
                    body:
                        '''Immediately when Kelo is slain, read [title], [codex] 46.'''),
              ]),
          EncounterFigureDef(
              name: 'Kelo',
              letter: 'D',
              type: AdversaryType.miniboss,
              healthFormula: '8*R',
              defense: 2,
              affinities: {
                Ether.water: 1,
                Ether.crux: -1,
                Ether.morph: 2,
              },
              onSlain: [
                codex(93),
                victory(),
              ]),
        ],
        placements: const [
          PlacementDef(name: 'Bulwauros', c: 4, r: 4),
          PlacementDef(name: 'Bulwauros', c: 1, r: 5, minPlayers: 3),
          PlacementDef(name: 'Bulwauros', c: 7, r: 1, minPlayers: 3),
          PlacementDef(name: 'Bulwauros', c: 11, r: 2, minPlayers: 4),
          PlacementDef(name: 'Bulwauros', c: 6, r: 9, minPlayers: 4),
          PlacementDef(name: 'Skara', c: 2, r: 7, minPlayers: 4),
          PlacementDef(name: 'Skara', c: 9, r: 0, minPlayers: 3),
          PlacementDef(name: 'Skara', c: 10, r: 5),
          PlacementDef(name: 'Skara', c: 7, r: 8),
          PlacementDef(name: 'Gruv', c: 6, r: 2),
          PlacementDef(name: 'Saras', c: 7, r: 6),
          PlacementDef(
              name: 'Crumbling Column',
              type: PlacementType.trap,
              c: 0,
              r: 5,
              trapDamage: 3),
          PlacementDef(
              name: 'Crumbling Column',
              type: PlacementType.trap,
              c: 3,
              r: 8,
              trapDamage: 3),
          PlacementDef(
              name: 'Crumbling Column',
              type: PlacementType.trap,
              c: 11,
              r: 1,
              trapDamage: 3),
          PlacementDef(
              name: 'Crumbling Column',
              type: PlacementType.trap,
              c: 11,
              r: 3,
              trapDamage: 3),
          PlacementDef(name: 'earth', type: PlacementType.ether, c: 2, r: 5),
          PlacementDef(name: 'morph', type: PlacementType.ether, c: 7, r: 2),
        ],
      );

  static EncounterDef get encounter5dot4 => EncounterDef(
      questId: '5',
      number: '4',
      title: 'Fearless, Powerful, Surprising',
      setup: EncounterSetup(box: '2/5', map: '36', adversary: '60-61'),
      victoryDescription: 'Slay Marii.',
      roundLimit: 8,
      terrain: [
        dangerousCrystals(1),
        etherFire(),
        etherMorph(),
      ],
      baseLystReward: 15,
      itemRewards: ['Ezmenite Lance'],
      campaignLink:
          '''Encounter 5.5 - “**More Worthless Than Freedom**”, [campaign] **82**.''',
      playerPossibleTokens: [
        'Crystalline Spear',
        'Crystalline Spear',
        'Crystalline Spear',
        'Crystalline Spear'
      ],
      challenges: [
        '**Her People Love her** triggers when Marii has suffered 12, 24, 36, and 48 damage. This does mean more sek and zisafi spawn at all Rover counts.',
        'Adversaries gain +1 [DEF] while within [Range] 0-1 of a [wildfire].',
        'Rovers trigger the effects of [wildfire] while within [Range] 0-1 of the tile and Rovers cannot replace [wildfire] with a different ether field.',
      ],
      dialogs: [
        introductionFromText('quest_5_encounter_4_intro'),
      ],
      onLoad: [
        dialog('Introduction'),
        rules('Crystalline Armor',
            '''*Marii is armored in resplendent crystalline and nearly unassailable.*
            
Marii has R [DEF] tokens on her statistic block. These tokens are not discarded at the beginning of her turn.'''),
        rules('Crystalline Spears',
            '''*Seks and zisafi have been equipped with crystalline spears, empowering their attacks (this is reflected in their stat blocks).*
            
When a Rover slays a sek or zisafi, that Rover gains a Crystalline Spear. To indicate this, place a hoard tile on your class board.

Each time a Rover attacks, you may remove one crystalline spear (hoard tile) from your class board to gain +1 [DMG] to that attack. After attacking Marii using a crystalline spear, remove one [DEF] token from her statistic block.'''),
        rules('She Loves Her People',
            '''*Marii loves her people and will avenge them when slain.*
            
Each time a sek or zisafi are slain, place one [Fire] dice on Marii’s statistic block. When there are R [Fire] dice on Marii’s statistic block, remove R [Fire] dice (return them to the general pool) and place a [wildfire] on her statistic block.'''),
        rules('Her People Love Her',
            '''*Marii’s people will rush to their queen’s side in her time of need.*
            
After the turn where Marii has suffered a total of 18, 36, and 54 damage, spawn one sek and one zisafi at [Range] 2 from Marii, closest to the [Fire] ether node.

This means adversaries will spawn once for 2 Rovers, twice for 3 Rovers, and three times for 4 Rovers.'''),
        codexLink('No Salvation Should Come',
            number: 94,
            body:
                '''Immediately when Marii is slain, read [title], [codex] 46.'''),
      ],
      startingMap: MapDef(
        id: '5.4',
        columnCount: 13,
        rowCount: 11,
        backgroundRect: Rect.fromLTWH(110.0, 44.0, 1481.0, 1411.0),
        starts: [
          (0, 3),
          (0, 4),
          (0, 5),
          (0, 6),
        ],
        terrain: {
          (3, 0): TerrainType.openAir,
          (3, 1): TerrainType.openAir,
          (3, 9): TerrainType.openAir,
          (3, 10): TerrainType.openAir,
          (4, 0): TerrainType.openAir,
          (4, 1): TerrainType.dangerous,
          (4, 9): TerrainType.openAir,
          (5, 0): TerrainType.openAir,
          (5, 3): TerrainType.object,
          (5, 8): TerrainType.object,
          (5, 10): TerrainType.openAir,
          (7, 2): TerrainType.openAir,
          (7, 5): TerrainType.object,
          (7, 8): TerrainType.openAir,
          (7, 9): TerrainType.dangerous,
          (8, 0): TerrainType.openAir,
          (8, 1): TerrainType.openAir,
          (8, 8): TerrainType.openAir,
          (8, 9): TerrainType.openAir,
          (9, 0): TerrainType.openAir,
          (9, 10): TerrainType.openAir,
          (10, 2): TerrainType.dangerous,
          (10, 3): TerrainType.openAir,
          (10, 6): TerrainType.openAir,
          (11, 0): TerrainType.object,
          (11, 2): TerrainType.openAir,
          (11, 3): TerrainType.openAir,
          (11, 4): TerrainType.openAir,
          (11, 5): TerrainType.object,
          (11, 6): TerrainType.openAir,
          (11, 7): TerrainType.openAir,
          (11, 8): TerrainType.openAir,
          (11, 10): TerrainType.object,
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
      adversaries: [
        EncounterFigureDef(
          name: 'Skara',
          letter: 'A',
          health: 7,
          defense: 1,
          affinities: {
            Ether.crux: -1,
            Ether.earth: 1,
            Ether.morph: 1,
          },
        ),
        EncounterFigureDef(
          name: 'Sek',
          letter: 'B',
          health: 12,
          defense: 1,
          traits: [
            'When slain the acting Rover gains a Crystalline Spear.',
            'When slain place one [Fire] dice on Marii’s statistic block.'
          ],
          affinities: {
            Ether.crux: -1,
            Ether.fire: 1,
            Ether.morph: 2,
          },
          onSlain: [
            EncounterAction(
                type: EncounterActionType.addToken, value: 'Crystalline Spear'),
            function('increase_marii_fire_token'),
          ],
        ),
        EncounterFigureDef(
          name: 'Zisafi',
          letter: 'C',
          health: 11,
          affinities: {
            Ether.crux: -1,
            Ether.morph: 1,
            Ether.fire: 2,
          },
          traits: [
            'When slain the acting Rover gains a Crystalline Spear.',
            'When slain place one [Fire] dice on Marii’s statistic block.'
          ],
          onSlain: [
            EncounterAction(
                type: EncounterActionType.addToken, value: 'Crystalline Spear'),
            function('increase_marii_fire_token'),
          ],
        ),
        EncounterFigureDef(
            name: 'Marii',
            letter: 'D',
            type: AdversaryType.miniboss,
            healthFormula: '18*R',
            defenseFormula: 'R-X',
            xDefinition: 'count_token(Hoard)',
            possibleTokens: [
              'RxHoard',
              'RxFire',
              'RxWildfire',
            ],
            traits: [
              'X equals the number of [wildfire] tiles on Marii\'s statistic block.',
            ],
            affinities: {
              Ether.fire: 2,
              Ether.water: -2,
              Ether.earth: 1,
              Ether.crux: -1,
              Ether.morph: 1,
            },
            onDamage: [
              placementGroup('Her People Love Her',
                  key: 'spawns_1',
                  title: 'Her People Love Her',
                  limit: 1,
                  condition: DamageCondition('X-18+1')),
              placementGroup('Her People Love Her',
                  key: 'spawns_2',
                  title: 'Her People Love Her',
                  limit: 1,
                  condition: DamageCondition('X-36+1')),
              placementGroup('Her People Love Her',
                  key: 'spawns_3',
                  title: 'Her People Love Her',
                  limit: 1,
                  condition: DamageCondition('X-54+1')),
            ],
            onSlain: [
              codex(94),
              victory(),
            ]),
      ],
      placements: const [
        PlacementDef(name: 'Skara', c: 5, r: 5),
        PlacementDef(name: 'Skara', c: 10, r: 7, minPlayers: 3),
        PlacementDef(name: 'Skara', c: 10, r: 1, minPlayers: 3),
        PlacementDef(name: 'Sek', c: 1, r: 0, minPlayers: 3),
        PlacementDef(name: 'Sek', c: 6, r: 3),
        PlacementDef(name: 'Sek', c: 7, r: 10, minPlayers: 4),
        PlacementDef(name: 'Zisafi', c: 6, r: 6),
        PlacementDef(name: 'Zisafi', c: 7, r: 0, minPlayers: 4),
        PlacementDef(name: 'Zisafi', c: 1, r: 10, minPlayers: 3),
        PlacementDef(name: 'Marii', c: 9, r: 5),
        PlacementDef(name: 'earth', type: PlacementType.ether, c: 5, r: 3),
        PlacementDef(name: 'earth', type: PlacementType.ether, c: 5, r: 8),
        PlacementDef(name: 'fire', type: PlacementType.ether, c: 11, r: 5),
      ],
      placementGroups: [
        PlacementGroupDef(
          name: 'Her People Love Her',
          placements: [
            PlacementDef(name: 'Sek'),
            PlacementDef(name: 'Zisafi'),
          ],
        ),
      ]);

  static EncounterDef get encounter5dot5 => EncounterDef(
        questId: '5',
        number: '5',
        title: 'More Worthless Than Freedom',
        setup: EncounterSetup(box: '2/5', map: '37', adversary: '62'),
        victoryDescription: 'Slay the Svaraka.',
        roundLimit: 7,
        terrain: [
          dangerousCrystals(1),
          etherEarth(),
          etherMorph(),
        ],
        baseLystReward: 30,
        itemRewards: [
          'Ezmenite Guard',
        ],
        unlocksRoverLevel: 7,
        unlocksShopLevel: 4,
        milestone: CampaignMilestone.milestone5dot5,
        campaignLink:
            '''Chapter 4 - “**A Consequence**”, [campaign] **100**.''',
        challenges: [
          'Ignore the gruv’s trait. It gains +3 [DEF].',
          'Femii has +R*4 [HP].',
          'The Svaraka’s abilities lose the On Advance mechanic. This means the Svaraka takes its turns normally, performing its abilities immediately.',
        ],
        dialogs: [
          introductionFromText('quest_5_encounter_5_intro'),
        ],
        onLoad: [
          dialog('Introduction'),
          rules('The Svaraka',
              '''This is a 3 phase encounter. Each phase has its own round limit.'''),
          rules('Crystal Nerves',
              '''*You are on the back of the Svaraka and must ground the creature first in order to defeat it.*

The crystal objects on this map are crystal nerves. You will need to destroy R of them to advance to the next map and progress the encounter. Place a [DIM] dice on each crystal object. Units in the Rover faction can target crystal objects as if they were enemies. They have 4 [HP] and 4 [DEF] each. Once a crystal nerve has been destroyed, remove the [DIM] dice from it to represent its destruction. A crystal without a [DIM] dice is treated as an open space.'''),
          subtitle('Phase 1 of 3: Crystal Nerves'),
          codexLink('Control Me Without Pause',
              number: 95,
              body:
                  '''At the end of the round where R crystal nerves have been destroyed, read [title], [codex] 47.'''),
        ],
        onWillEndRound: [
          milestone('_phase_2',
              condition: IsSlainCondition('Crystal Nerve', countFormula: 'R')),
          milestone('_phase_2',
              condition:
                  IsSlainCondition('Crystal Nerve', countFormula: 'R+1')),
          milestone('_phase_2',
              condition:
                  IsSlainCondition('Crystal Nerve', countFormula: 'R+2')),
        ],
        onMilestone: {
          '_phase_2': [
            removeRule('Crystal Nerves'),
            codex(95),
            subtitle('Phase 2 of 3: Crystal Throne'),
            placementGroup('Crystal Throne', silent: true),
            rules('Phase 2',
                '''Proceed to page 63 of the adversary book and page 38 of the map book.

Place Rovers in [start] spaces and spawn adversaries according to Rover count as shown on the map. Rover [HP], ether dice, and infusion dice carry over. Glyphs and summons carry over and are placed within [Range] 1 of their owner.'''),
            resetRound(
                body:
                    'The round limit has been reset. You have 7 rounds to complete the next area.'),
            rules('Crystal Throne',
                '''*Femii controls the Svaraka. There is no chance of victory while she lives.*
                
Slay Femii to free the Svaraka of its enthrallment.'''),
            codexLink('How the Guilty Speak',
                number: 96,
                body:
                    '''At the end of the round where Femii was slain, read [title], [codex] 48.'''),
          ],
          '_phase_3': [
            removeRule('Phase 2'),
            removeRule('Crystal Throne'),
            codex(96),
            subtitle('Phase 3 of 3: The Svaraka'),
            placementGroup('The Svaraka', silent: true),
            rules('Phase 3',
                '''*The Svaraka's mind is broken. It will destroy everything in its enraged state. Slay this magnificent creature to preserve the wilds.*

Proceed to page 64 of the adversary book and page 39 of the map book.

Place Rovers in [start] spaces and spawn adversaries according to Rover count as shown on the map. Rover [HP], ether dice, and infusion dice carry over. Glyphs and summons carry over and are placed within [Range] 1 of their owner.'''),
            rules('On Advance',
                '''Adversaries in this encounter use the On Advance mechanic, which is found on page 47 of the rulebook.

Read Svaraka's abilities carefully. The mighty crystal dragon is terribly strong, but much of the damage it deals can be avoided by careful positioning.'''),
            resetRound(
                body:
                    'The round limit has been reset. You have 7 rounds to complete the next area.'),
            codexLink('Disturb Their Balance',
                number: 97,
                body:
                    '''Immediately when Svaraka is slain, read [title], [codex] 48.'''),
          ]
        },
        startingMap: MapDef(
          id: '5.5.1',
          columnCount: 13,
          rowCount: 11,
          backgroundRect: Rect.fromLTWH(110.0, 44.0, 1481.0, 1411.0),
          starts: [
            (0, 8),
            (0, 9),
            (1, 9),
            (1, 10),
            (2, 9),
            (3, 10),
          ],
          terrain: {
            (0, 0): TerrainType.openAir,
            (0, 1): TerrainType.openAir,
            (0, 2): TerrainType.openAir,
            (1, 0): TerrainType.openAir,
            (1, 1): TerrainType.openAir,
            (1, 2): TerrainType.openAir,
            (2, 0): TerrainType.openAir,
            (2, 1): TerrainType.openAir,
            (2, 4): TerrainType.dangerous,
            (3, 0): TerrainType.openAir,
            (3, 1): TerrainType.openAir,
            (4, 0): TerrainType.openAir,
            (5, 0): TerrainType.openAir,
            (5, 3): TerrainType.object,
            (6, 1): TerrainType.dangerous,
            (6, 4): TerrainType.object,
            (7, 8): TerrainType.dangerous,
            (7, 10): TerrainType.openAir,
            (8, 1): TerrainType.object,
            (8, 5): TerrainType.object,
            (8, 9): TerrainType.openAir,
            (9, 9): TerrainType.openAir,
            (9, 10): TerrainType.openAir,
            (10, 3): TerrainType.object,
            (10, 8): TerrainType.openAir,
            (10, 9): TerrainType.openAir,
            (11, 2): TerrainType.dangerous,
            (11, 8): TerrainType.openAir,
            (11, 9): TerrainType.openAir,
            (11, 10): TerrainType.openAir,
            (12, 7): TerrainType.openAir,
            (12, 8): TerrainType.openAir,
            (12, 9): TerrainType.openAir,
          },
        ),
        overlays: [
          EncounterFigureDef(
            name: 'Crystal Nerve',
            health: 4,
            defense: 4,
          ),
        ],
        adversaries: [
          EncounterFigureDef(
            name: 'Bulwauros',
            letter: 'A',
            health: 6,
            defense: 3,
            traits: [
              'If this unit is damaged, reduce its [DEF] by 3.',
            ],
            affinities: {
              Ether.water: -2,
              Ether.morph: -1,
              Ether.earth: 2,
            },
            reactions: [
              EnemyReactionDef(
                  trigger: ReactionTriggerDef(
                      type: RoveEventType.afterSuffer,
                      targetKind: TargetKind.self),
                  actions: [
                    RoveAction(
                        type: RoveActionType.addDefense,
                        amount: -3,
                        targetKind: TargetKind.self)
                  ])
            ],
          ),
          EncounterFigureDef(
            name: 'Wrathbone',
            letter: 'B',
            health: 16,
            traits: [
              '''[React] At the end of the Rover phase:
              
All enemies within [Range] 1-2 suffer [DMG]1.''',
            ],
            affinities: {
              Ether.fire: 2,
              Ether.earth: 1,
              Ether.water: -2,
            },
          ),
          EncounterFigureDef(
            name: 'Gruv',
            letter: 'C',
            health: 18,
            defenseFormula: '3*(1-T%2)',
            traits: [
              'During even rounds, this unit gains [Def] 3.',
            ],
            affinities: {
              Ether.water: -1,
              Ether.fire: 1,
              Ether.earth: 2,
            },
          ),
          EncounterFigureDef(
            name: 'Sek',
            letter: 'A',
            health: 12,
            defense: 1,
            affinities: {
              Ether.crux: -1,
              Ether.fire: 1,
              Ether.morph: 2,
            },
          ),
          EncounterFigureDef(
            name: 'Zisafi',
            letter: 'B',
            health: 11,
            affinities: {
              Ether.crux: -1,
              Ether.morph: 1,
              Ether.fire: 2,
            },
          ),
          EncounterFigureDef(
            name: 'Femii',
            letter: 'C',
            type: AdversaryType.miniboss,
            healthFormula: '12*R',
            defenseFormula: 'R',
            traits: [
              'This unit treats all [miasma] as if they were adversary [aura].',
            ],
            affinities: {
              Ether.morph: 2,
              Ether.earth: 1,
              Ether.fire: -1,
              Ether.crux: -2,
            },
            onSlain: [
              milestone('_phase_3'),
            ],
          ),
          EncounterFigureDef(
            name: 'Skara',
            letter: 'A',
            health: 7,
            defense: 1,
            affinities: {
              Ether.crux: -1,
              Ether.earth: 1,
              Ether.morph: 1,
            },
          ),
          EncounterFigureDef(
              name: 'Svaraka',
              letter: 'B',
              type: AdversaryType.boss,
              healthFormula: '25*R',
              large: true,
              immuneToForcedMovement: true,
              traits: [
                'Ignores sources of [DMG] equal to 2 or less.',
              ],
              affinities: {
                Ether.crux: 2,
                Ether.earth: 1,
                Ether.fire: 1,
                Ether.morph: -1,
                Ether.wind: -1,
              },
              onSlain: [
                codex(97),
                victory(),
                codex(98),
              ]),
        ],
        placements: const [
          PlacementDef(name: 'Bulwauros', c: 3, r: 5),
          PlacementDef(name: 'Bulwauros', c: 5, r: 6),
          PlacementDef(name: 'Bulwauros', c: 7, r: 7),
          PlacementDef(name: 'Bulwauros', c: 4, r: 1, minPlayers: 3),
          PlacementDef(name: 'Bulwauros', c: 7, r: 0, minPlayers: 4),
          PlacementDef(name: 'Bulwauros', c: 12, r: 6, minPlayers: 3),
          PlacementDef(name: 'Wrathbone', c: 7, r: 4),
          PlacementDef(name: 'Wrathbone', c: 9, r: 6, minPlayers: 3),
          PlacementDef(name: 'Gruv', c: 9, r: 2),
          PlacementDef(name: 'Gruv', c: 11, r: 0, minPlayers: 4),
          PlacementDef(
              name: 'Crystal Nerve', type: PlacementType.object, c: 5, r: 3),
          PlacementDef(
              name: 'Crystal Nerve', type: PlacementType.object, c: 8, r: 5),
          PlacementDef(
              name: 'Crystal Nerve', type: PlacementType.object, c: 10, r: 3),
          PlacementDef(
              name: 'Crystal Nerve', type: PlacementType.object, c: 8, r: 1),
          PlacementDef(name: 'earth', type: PlacementType.ether, c: 6, r: 4),
        ],
        placementGroups: [
          PlacementGroupDef(
            name: 'Crystal Throne',
            map: MapDef(
              id: '5.5.2',
              columnCount: 13,
              rowCount: 11,
              backgroundRect: Rect.fromLTWH(110.0, 44.0, 1481.0, 1411.0),
              starts: [
                (1, 10),
                (3, 10),
                (5, 10),
                (7, 10),
                (9, 10),
                (11, 10),
              ],
              terrain: {
                (0, 0): TerrainType.openAir,
                (0, 1): TerrainType.openAir,
                (0, 2): TerrainType.openAir,
                (0, 3): TerrainType.openAir,
                (0, 4): TerrainType.openAir,
                (0, 5): TerrainType.openAir,
                (0, 7): TerrainType.openAir,
                (0, 9): TerrainType.openAir,
                (1, 0): TerrainType.openAir,
                (1, 1): TerrainType.openAir,
                (1, 4): TerrainType.openAir,
                (1, 5): TerrainType.openAir,
                (2, 0): TerrainType.openAir,
                (2, 7): TerrainType.dangerous,
                (3, 2): TerrainType.object,
                (3, 5): TerrainType.object,
                (6, 5): TerrainType.object,
                (6, 8): TerrainType.object,
                (9, 2): TerrainType.object,
                (9, 5): TerrainType.object,
                (10, 0): TerrainType.openAir,
                (10, 6): TerrainType.dangerous,
                (11, 0): TerrainType.openAir,
                (11, 1): TerrainType.openAir,
                (11, 4): TerrainType.openAir,
                (11, 5): TerrainType.openAir,
                (12, 0): TerrainType.openAir,
                (12, 1): TerrainType.openAir,
                (12, 2): TerrainType.openAir,
                (12, 3): TerrainType.openAir,
                (12, 4): TerrainType.openAir,
                (12, 5): TerrainType.openAir,
                (12, 7): TerrainType.openAir,
                (12, 9): TerrainType.openAir,
              },
            ),
            placements: [
              PlacementDef(name: 'Sek', c: 5, r: 1, minPlayers: 4),
              PlacementDef(name: 'Sek', c: 4, r: 4),
              PlacementDef(name: 'Sek', c: 9, r: 3, minPlayers: 3),
              PlacementDef(name: 'Zisafi', c: 8, r: 4),
              PlacementDef(name: 'Zisafi', c: 3, r: 3, minPlayers: 3),
              PlacementDef(name: 'Zisafi', c: 7, r: 1, minPlayers: 4),
              PlacementDef(name: 'Femii', c: 6, r: 2),
              PlacementDef(
                  name: 'morph', type: PlacementType.ether, c: 3, r: 2),
              PlacementDef(
                  name: 'morph', type: PlacementType.ether, c: 6, r: 5),
              PlacementDef(
                  name: 'morph', type: PlacementType.ether, c: 9, r: 2),
            ],
          ),
          PlacementGroupDef(
            name: 'The Svaraka',
            map: MapDef(
              id: '5.5.3',
              columnCount: 13,
              rowCount: 11,
              backgroundRect: Rect.fromLTWH(110.0, 44.0, 1481.0, 1411.0),
              starts: [
                (8, 4),
                (8, 5),
                (9, 4),
                (9, 5),
                (9, 6),
                (10, 4),
                (10, 5),
              ],
              terrain: {
                (0, 0): TerrainType.barrier,
                (0, 1): TerrainType.barrier,
                (0, 3): TerrainType.barrier,
                (0, 4): TerrainType.barrier,
                (0, 7): TerrainType.barrier,
                (0, 8): TerrainType.barrier,
                (0, 9): TerrainType.barrier,
                (1, 0): TerrainType.barrier,
                (1, 1): TerrainType.barrier,
                (1, 2): TerrainType.barrier,
                (1, 4): TerrainType.barrier,
                (1, 6): TerrainType.object,
                (1, 8): TerrainType.barrier,
                (1, 9): TerrainType.barrier,
                (1, 10): TerrainType.barrier,
                (2, 0): TerrainType.barrier,
                (2, 1): TerrainType.barrier,
                (2, 8): TerrainType.barrier,
                (2, 9): TerrainType.barrier,
                (3, 1): TerrainType.barrier,
                (3, 9): TerrainType.barrier,
                (3, 10): TerrainType.barrier,
                (4, 5): TerrainType.object,
                (4, 7): TerrainType.dangerous,
                (4, 9): TerrainType.barrier,
                (5, 0): TerrainType.barrier,
                (6, 0): TerrainType.dangerous,
                (6, 8): TerrainType.object,
                (7, 2): TerrainType.object,
                (8, 6): TerrainType.object,
                (10, 1): TerrainType.object,
                (10, 3): TerrainType.object,
                (10, 7): TerrainType.barrier,
                (11, 7): TerrainType.barrier,
                (11, 8): TerrainType.barrier,
                (12, 7): TerrainType.barrier,
                (12, 8): TerrainType.barrier,
                (12, 9): TerrainType.barrier,
              },
            ),
            placements: [
              PlacementDef(name: 'Svaraka', c: 3, r: 3),
              PlacementDef(name: 'Skara', c: 0, r: 2),
              PlacementDef(name: 'Skara', c: 3, r: 5),
              PlacementDef(name: 'Skara', c: 3, r: 7, minPlayers: 4),
              PlacementDef(name: 'Skara', c: 5, r: 10, minPlayers: 3),
              PlacementDef(name: 'Skara', c: 5, r: 4, minPlayers: 3),
              PlacementDef(name: 'Skara', c: 6, r: 2),
              PlacementDef(name: 'Skara', c: 3, r: 0),
              PlacementDef(name: 'Skara', c: 7, r: 0, minPlayers: 4),
            ],
          ),
        ],
      );
}
