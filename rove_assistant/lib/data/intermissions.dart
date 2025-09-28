import 'dart:ui';
import 'encounter_def_utils.dart';
import 'package:rove_data_types/rove_data_types.dart';

extension Intermissions on EncounterDef {
  static EncounterDef get encounterChapter2dotI => EncounterDef(
        questId: 'chapter_2',
        number: 'I',
        title: 'The Island of Doctor Mo',
        setup:
            EncounterSetup(box: 'Intermissions', map: '16', adversary: '24-25'),
        victoryDescription: 'Slay the Hydra.',
        terrain: [
          etherWater(),
          etherCrux(),
          EncounterTerrain('barrier',
              title: 'Zydero Reefs',
              body: 'Barrier [barrier] terrain is Zydero Reefs.'),
        ],
        roundLimit: 8,
        itemRewards: [
          'Zyderos Cuirass',
        ],
        campaignLink:
            '''Return to Chapter 2 - “**A Choice**” [campaign] **39**, skipping directly to the Campaign Link.''',
        challenges: [
          'If there are no dyads on the map, the Hydra gains +2 [DMG] to all of their attacks.',
          'Dyads gain +4 [HP].',
          'Bulwauros lose their trait.',
        ],
        dialogs: [
          introductionFromText('chapter_2_adventure_intro'),
        ],
        onLoad: [
          dialog('Introduction'),
          rules('Ferrorsands',
              '''*The magnetically charged sands are in constant conflux.*

You will notice several lines with arrows showing direction of movement drawn on this map. These arrows represent the flow of magnetic sands within the Zydero Reefs. At the start of both the Rover and Adversary phases, all units a part of the Rover faction are pushed along these lines in the direction of the arrows. Take note that some lines will push you into the Zydero reefs.

The Zydero reefs are hard as iron, jagged, and deadly. Any unit that suffers **impact damage** for being pushed or pulled into a Zydero Reef suffers an additional +1 [DMG].

The adversaries within this encounter are native to the Zydero Reefs and ignore the effects of **Ferrorsands**.'''),
          codexLink('Zydero Reef',
              number: 175,
              body:
                  '''Before the start of the first round, read [title], [codex] 84.'''),
          codexLink('Mineral Shell',
              number: 176,
              body: '''If an urn is slain, read [title], [codex] 84.'''),
          codexLink('Gathering Sands',
              number: 177,
              body:
                  '''Immediately when the Hydra is slain, read [title], [codex] 84.'''),
          codex(175),
        ],
        startingMap: MapDef(
          id: 'I1.1',
          columnCount: 13,
          rowCount: 11,
          backgroundRect: Rect.fromLTWH(110.0, 44.0, 1481.0, 1411.0),
          starts: [
            (12, 3),
            (12, 4),
            (12, 5),
            (12, 6),
          ],
          terrain: {
            (2, 1): TerrainType.barrier,
            (2, 2): TerrainType.barrier,
            (2, 3): TerrainType.barrier,
            (2, 7): TerrainType.barrier,
            (3, 1): TerrainType.barrier,
            (3, 2): TerrainType.barrier,
            (3, 7): TerrainType.barrier,
            (3, 8): TerrainType.barrier,
            (3, 9): TerrainType.barrier,
            (4, 1): TerrainType.barrier,
            (4, 8): TerrainType.barrier,
            (5, 5): TerrainType.object,
            (5, 9): TerrainType.barrier,
            (9, 0): TerrainType.barrier,
            (9, 5): TerrainType.object,
            (9, 10): TerrainType.barrier,
            (10, 0): TerrainType.barrier,
            (10, 9): TerrainType.barrier,
            (11, 0): TerrainType.barrier,
            (11, 1): TerrainType.barrier,
            (11, 9): TerrainType.barrier,
            (11, 10): TerrainType.barrier,
            (12, 0): TerrainType.barrier,
            (12, 1): TerrainType.barrier,
            (12, 8): TerrainType.barrier,
            (12, 9): TerrainType.barrier,
          },
        ),
        adversaries: [
          EncounterFigureDef(
            name: 'Bulwauros',
            letter: 'A',
            health: 5,
            defense: 3,
            traits: [
              'If this unit is damaged, reduce its [DEF] by 3.',
              'Ignores the effects of Ferrorsands.',
            ],
            affinities: {
              Ether.earth: 1,
              Ether.morph: -1,
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
            name: 'Dyad',
            letter: 'B',
            health: 12,
            traits: [
              'Ignores the effects of Ferrorsands.',
            ],
            affinities: {
              Ether.morph: -2,
              Ether.earth: -1,
              Ether.water: 1,
              Ether.crux: 2,
            },
          ),
          EncounterFigureDef(
            name: 'Hydra',
            letter: 'C',
            type: AdversaryType.miniboss,
            healthFormula: '15*R',
            traits: [
              'When this unit suffers [DMG], if a Dyad is active, divide that [DMG] by 2, rounded up.',
              'Ignores the effects of Ferrorsands.',
            ],
            affinities: {
              Ether.morph: -2,
              Ether.earth: -1,
              Ether.water: 2,
              Ether.crux: 2,
            },
            onSlain: [
              codex(177),
              victory(),
            ],
          ),
          EncounterFigureDef(
              name: 'Urn',
              letter: 'D',
              healthFormula: '2*R',
              defenseFormula: '3',
              traits: [
                'Ignores the effects of Ferrorsands.',
              ],
              affinities: {
                Ether.fire: 1,
                Ether.earth: 1,
                Ether.water: 1,
                Ether.wind: 1,
              },
              onSlain: [
                codex(176),
                lyst('5*R'),
                item('Arcana Pigment',
                    body:
                        'The Rover that slayed the urn gains one “Arcana Pigment” item. They may equip this item. If they don’t have the required item slot(s) available, they may unequip items as needed.'),
              ]),
        ],
        placements: const [
          PlacementDef(name: 'Bulwauros', c: 5, r: 8, minPlayers: 3),
          PlacementDef(name: 'Bulwauros', c: 7, r: 10),
          PlacementDef(name: 'Bulwauros', c: 6, r: 0),
          PlacementDef(name: 'Bulwauros', minPlayers: 4),
          PlacementDef(name: 'Dyad', c: 7, r: 3),
          PlacementDef(name: 'Dyad', c: 7, r: 7),
          PlacementDef(name: 'Dyad', minPlayers: 4),
          PlacementDef(name: 'Urn', c: 7, r: 0),
          PlacementDef(name: 'Urn', c: 8, r: 9),
          PlacementDef(name: 'Hydra', c: 4, r: 5),
          PlacementDef(name: 'Dyad', c: 3, r: 4, minPlayers: 3),
          PlacementDef(name: 'water', type: PlacementType.ether, c: 9, r: 5),
          PlacementDef(name: 'crux', type: PlacementType.ether, c: 5, r: 5),
          PlacementDef(name: 'Sand S', type: PlacementType.feature, c: 0, r: 2),
          PlacementDef(name: 'Sand S', type: PlacementType.feature, c: 0, r: 3),
          PlacementDef(name: 'Sand S', type: PlacementType.feature, c: 6, r: 1),
          PlacementDef(name: 'Sand SW', type: PlacementType.feature),
          PlacementDef(
              name: 'Sand SE', type: PlacementType.feature, c: 0, r: 4),
          PlacementDef(
              name: 'Sand SE', type: PlacementType.feature, c: 1, r: 5),
          PlacementDef(name: 'Sand NE', type: PlacementType.feature),
          PlacementDef(
              name: 'Sand NE', type: PlacementType.feature, c: 3, r: 5),
          PlacementDef(
              name: 'Sand NE', type: PlacementType.feature, c: 0, r: 7),
          PlacementDef(name: 'Sand NE', type: PlacementType.feature),
          PlacementDef(
              name: 'Sand NE', type: PlacementType.feature, c: 2, r: 6),
          PlacementDef(
              name: 'Sand NE', type: PlacementType.feature, c: 9, r: 2),
          PlacementDef(
              name: 'Sand SE', type: PlacementType.feature, c: 4, r: 0),
          PlacementDef(
              name: 'Sand SE', type: PlacementType.feature, c: 5, r: 1),
          PlacementDef(
              name: 'Sand SE', type: PlacementType.feature, c: 7, r: 1),
          PlacementDef(
              name: 'Sand SE', type: PlacementType.feature, c: 8, r: 1),
          PlacementDef(
              name: 'Sand SE', type: PlacementType.feature, c: 9, r: 9),
          PlacementDef(
              name: 'Sand SW', type: PlacementType.feature, c: 11, r: 7),
          PlacementDef(
              name: 'Sand SW', type: PlacementType.feature, c: 10, r: 7),
          PlacementDef(
              name: 'Sand SW', type: PlacementType.feature, c: 10, r: 5),
          PlacementDef(
              name: 'Sand SW', type: PlacementType.feature, c: 9, r: 6),
          PlacementDef(
              name: 'Sand SW', type: PlacementType.feature, c: 6, r: 5),
          PlacementDef(
              name: 'Sand SW', type: PlacementType.feature, c: 5, r: 6),
          PlacementDef(name: 'Sand N', type: PlacementType.feature, c: 4, r: 2),
          PlacementDef(name: 'Sand N', type: PlacementType.feature, c: 4, r: 3),
          PlacementDef(name: 'Sand N', type: PlacementType.feature, c: 7, r: 9),
          PlacementDef(name: 'Sand N', type: PlacementType.feature, c: 0, r: 8),
          PlacementDef(
              name: 'Sand NW', type: PlacementType.feature, c: 2, r: 9),
          PlacementDef(
              name: 'Sand NW', type: PlacementType.feature, c: 1, r: 9),
          PlacementDef(
              name: 'Sand NW', type: PlacementType.feature, c: 10, r: 4),
          PlacementDef(
              name: 'Sand NW', type: PlacementType.feature, c: 9, r: 4),
          PlacementDef(
              name: 'Sand N', type: PlacementType.feature, c: 10, r: 1),
          PlacementDef(
              name: 'Sand SW', type: PlacementType.feature, c: 8, r: 3),
          PlacementDef(name: 'Sand S', type: PlacementType.feature, c: 4, r: 6),
          PlacementDef(name: 'Sand S', type: PlacementType.feature, c: 4, r: 7),
          PlacementDef(name: 'Sand S', type: PlacementType.feature, c: 9, r: 8),
          PlacementDef(
              name: 'Sand NE', type: PlacementType.feature, c: 5, r: 10),
          PlacementDef(
              name: 'Sand NE', type: PlacementType.feature, c: 6, r: 9),
          PlacementDef(
              name: 'Sand NW', type: PlacementType.feature, c: 7, r: 8),
          PlacementDef(
              name: 'Sand NW', type: PlacementType.feature, c: 8, r: 6),
        ],
      );

  static EncounterDef get encounterChapter3dotI => EncounterDef(
        questId: 'chapter_3',
        number: 'I',
        title: 'Mind Of My Mind',
        setup: EncounterSetup(
            box: 'Intermissions',
            map: '32',
            adversary: '48-53',
            tiles: '3x Crumbling Columns'),
        victoryDescription: 'Attempt to survive up to 3 waves of adversaries.',
        roundLimit: 6,
        terrain: [
          dangerousPool(1),
          trapColumn(3),
          etherFire(),
          etherEarth(),
          etherWater(),
          etherWind(),
          etherCrux(),
          etherMorph(),
        ],
        campaignLink:
            '''Return to Chapter 3 - “**A Consequence**” [campaign] **66**, skipping directly to the Campaign Link.''',
        challenges: [
          'Set the Round Limit to 5 for all waves.',
          'You can’t use [P] items.',
          'After wave 2 starts, during the end phase of each round, Rovers suffer [DMG]1.',
        ],
        onLoad: [
          dialog('Introduction'),
          rules('Mind Palace',
              '''This encounter will see you battle up to three waves of adversaries to earn an increasing pool of lyst. There are a total of six possible waves you can fight and two ways to determine which wave you will take on.

First, you can reference the table below and select which wave you would like to take on. You can only face each wave once.

Second, if you want an increased challenge, you can randomly determine which wave you will fight. To do this, stack one copy of [Wildfire], [Snapfrost], [Everbloom], [Windscreen], [Aura], and [Miasma] tiles. Remove the top tile and reference the table below, spawning the wave that corresponds to the tile removed.

After you select which wave you will be facing, flip to the page in the adversary book listed in the leftmost column of the table below, and follow the spawning rules.

There are six ether icons on the edges of the map that represent possible spawn locations throughout the encounter. When a wave is selected, spawn each adversary for the Rover count you are playing at. IE. If you are playing with 4 Rovers, spawn all adversaries for 4 Rovers, 3 Rovers, and 2 Rovers.

To do this, for each adversary roll an ether dice from the general pool, then spawn that adversary at the space with the ether icon corresponding to the icon that was just rolled.

Lastly, there are several ether nodes around the map. When you spawn a wave of adversaries, place ether dice on these nodes that correspond to the ether field of the wave you just spawned. IE. if you spawned the [Wildfire] wave of adversaries, place [Fire] ether dice onto the nodes. If there are ether dice already on these nodes, replace them with the new ether dice. If there is a non-flying unit on an ether node, move that unit to an unoccupied space as close as you can to the ether node. 

Because this encounter takes place within your mind palace, any [P] items consumed during battle will be returned at the end of the encounter.'''),
          codexLink('The Arena',
              number: 178,
              body:
                  '''Before the start of the first round, read [title], [codex] 85.'''),
          codexLink('One Down, Two To Go',
              number: 179,
              body:
                  '''At the end of the round where the first wave is defeated, read [title], [codex] 85.'''),
          codexLink('Two Down, One To Go',
              number: 180,
              body:
                  '''At the end of the round where the second wave is defeated, read [title], [codex] 86.'''),
          codexLink('Victory!',
              number: 181,
              body:
                  '''At the end of the round where the third wave is defeated, read [title], [codex] 86.'''),
          codexLink('We Were So Close',
              number: 182,
              body:
                  '''Immediately when all Rovers are downed or if you exceed the number of rounds for your current wave, read [title], [codex] 87.'''),
          codex(178),
          dialog('Wave 1'),
        ],
        dialogs: [
          introductionFromText('chapter_3_adventure_intro'),
          EncounterDialogDef(
              title: 'Wave 1', type: EncounterDialogDef.drawType),
          EncounterDialogDef(
              title: 'Wave 2', type: EncounterDialogDef.drawType),
          EncounterDialogDef(title: 'Wave 3', type: EncounterDialogDef.drawType)
        ],
        onWillEndRound: [
          milestone('_victory', conditions: [
            AllAdversariesSlainCondition(),
            MilestoneCondition('_wave3')
          ]),
          milestone('_wave3', conditions: [
            AllAdversariesSlainCondition(),
            MilestoneCondition('_wave2')
          ]),
          milestone('_wave2', condition: AllAdversariesSlainCondition()),
        ],
        onMilestone: {
          '_wave2': [
            codex(179),
            lyst('10*R', title: 'Wave 1'),
            rules('More to Go',
                '''Congratulations, you’ve defeated the first wave of adversaries!  Follow the rules of **Mind Palace** (determine the next wave the same way you did the first wave) and spawn the next wave of enemies.'''),
            dialog('Wave 2'),
          ],
          '_wave3': [
            codex(180),
            lyst('20*R', title: 'Wave 2'),
            rules('More to Go',
                '''Congratulations, you’ve defeated the second wave of adversaries!  Follow the rules of **Mind Palace** (determine the next wave the same way you did the first wave) and spawn the next wave of enemies.'''),
            dialog('Wave 3'),
          ],
          '_victory': [
            codex(181),
            victory(),
            lyst('30*R', title: 'Wave 3'),
            dialog(null,
                title: '[P] Items',
                body:
                    'All [P] items that were consumed during this encounter are returned to their owners.'),
          ],
        },
        onDraw: {
          EtherField.wildfire.toJson(): [
            placementGroup('Wildfire',
                body:
                    'Go to [adversary] page 48 and spawn the following adversaries.'),
            resetRound(
                body:
                    'The round limit has been reset. You have 6 rounds to complete this wave.',
                condition: MilestoneCondition('_did_draw')),
            milestone('_did_draw'),
          ],
          EtherField.snapfrost.toJson(): [
            placementGroup('Snapfrost',
                body:
                    'Go to [adversary] page 49 and spawn the following adversaries.'),
            resetRound(
                body:
                    'The round limit has been reset. You have 6 rounds to complete this wave.',
                condition: MilestoneCondition('_did_draw')),
            milestone('_did_draw'),
          ],
          EtherField.everbloom.toJson(): [
            placementGroup('Everbloom',
                body:
                    'Go to [adversary] page 50 and spawn the following adversaries.'),
            resetRound(
                body:
                    'The round limit has been reset. You have 6 rounds to complete this wave.',
                condition: MilestoneCondition('_did_draw')),
            milestone('_did_draw'),
          ],
          EtherField.windscreen.toJson(): [
            placementGroup('Windscreen',
                body:
                    'Go to [adversary] page 51 and spawn the following adversaries.'),
            resetRound(
                body:
                    'The round limit has been reset. You have 6 rounds to complete this wave.',
                condition: MilestoneCondition('_did_draw')),
            milestone('_did_draw'),
          ],
          EtherField.aura.toJson(): [
            placementGroup('Aura',
                body:
                    'Go to [adversary] page 52 and spawn the following adversaries.'),
            resetRound(
                body:
                    'The round limit has been reset. You have 6 rounds to complete this wave.',
                condition: MilestoneCondition('_did_draw')),
            milestone('_did_draw'),
          ],
          EtherField.miasma.toJson(): [
            placementGroup('Miasma',
                body:
                    'Go to [adversary] page 53 and spawn the following adversaries.'),
            resetRound(
                body:
                    'The round limit has been reset. You have 6 rounds to complete this wave.',
                condition: MilestoneCondition('_did_draw')),
            milestone('_did_draw'),
          ],
        },
        onFailure: [
          codex(182),
        ],
        startingMap: MapDef(
          id: 'I2.1',
          columnCount: 13,
          rowCount: 11,
          backgroundRect: Rect.fromLTWH(110.0, 44.0, 1481.0, 1411.0),
          starts: [
            (5, 5),
            (6, 4),
            (6, 5),
            (7, 5),
          ],
          terrain: {
            (0, 0): TerrainType.barrier,
            (0, 1): TerrainType.barrier,
            (0, 8): TerrainType.barrier,
            (0, 9): TerrainType.barrier,
            (1, 0): TerrainType.barrier,
            (1, 1): TerrainType.barrier,
            (1, 9): TerrainType.barrier,
            (1, 10): TerrainType.barrier,
            (2, 0): TerrainType.barrier,
            (2, 7): TerrainType.object,
            (2, 9): TerrainType.barrier,
            (3, 0): TerrainType.barrier,
            (3, 4): TerrainType.dangerous,
            (3, 10): TerrainType.barrier,
            (4, 6): TerrainType.difficult,
            (6, 2): TerrainType.difficult,
            (6, 7): TerrainType.dangerous,
            (8, 1): TerrainType.object,
            (9, 0): TerrainType.barrier,
            (9, 6): TerrainType.difficult,
            (9, 8): TerrainType.object,
            (9, 10): TerrainType.barrier,
            (10, 0): TerrainType.barrier,
            (10, 3): TerrainType.dangerous,
            (10, 9): TerrainType.barrier,
            (11, 0): TerrainType.barrier,
            (11, 1): TerrainType.barrier,
            (11, 9): TerrainType.barrier,
            (11, 10): TerrainType.barrier,
            (12, 0): TerrainType.barrier,
            (12, 1): TerrainType.barrier,
            (12, 8): TerrainType.barrier,
            (12, 9): TerrainType.barrier,
          },
          spawnPoints: {
            (0, 2): Ether.morph,
            (0, 7): Ether.earth,
            (6, 0): Ether.water,
            (6, 9): Ether.fire,
            (12, 2): Ether.wind,
            (12, 7): Ether.crux,
          },
        ),
        adversaries: [
          EncounterFigureDef(
            name: 'Ashemak',
            letter: 'A',
            health: 9,
            immuneToForcedMovement: true,
            traits: [
              '''[React] Before this unit is slain:
              
All units within [Range] 1 suffer [DMG]3.''',
            ],
            affinities: {
              Ether.water: -2,
              Ether.wind: -1,
              Ether.fire: 3,
            },
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
              Ether.wind: 1,
              Ether.water: -2,
            },
          ),
          EncounterFigureDef(
            name: 'Nahoot',
            letter: 'C',
            health: 15,
            traits: [
              'If a Rover slays this unit, that Rover [plus_wind_morph].',
            ],
            affinities: {
              Ether.morph: 2,
              Ether.wind: 1,
              Ether.crux: -1,
            },
            onSlain: [
              ether([Ether.wind, Ether.morph]),
            ],
          ),
          EncounterFigureDef(
            name: 'Briarwog',
            letter: 'A',
            health: 10,
            traits: [
              'Enemies within [Range] 1 of this unit suffer [DMG]1 after attacking it.',
            ],
            affinities: {
              Ether.water: 1,
              Ether.morph: 1,
              Ether.earth: -1,
              Ether.fire: -1,
            },
          ),
          EncounterFigureDef(
            name: 'Onisski',
            letter: 'B',
            health: 10,
            traits: [
              'Ignores the movement penality of mushroom terrain.',
            ],
            affinities: {
              Ether.water: 2,
              Ether.earth: 1,
              Ether.crux: 1,
              Ether.wind: -1,
              Ether.morph: -2,
            },
          ),
          EncounterFigureDef(
            name: 'Sek',
            letter: 'C',
            health: 12,
            defense: 1,
            affinities: {
              Ether.crux: -1,
              Ether.fire: 1,
              Ether.morph: 2,
            },
          ),
          EncounterFigureDef(
            name: 'Zinix',
            letter: 'A',
            health: 5,
            defense: 2,
            traits: [
              'Can enter spaces with objects.',
            ],
            affinities: {
              Ether.fire: -1,
              Ether.wind: -1,
              Ether.water: 1,
              Ether.earth: 2,
            },
          ),
          EncounterFigureDef(
            name: 'Bulwauros',
            letter: 'B',
            health: 6,
            defense: 3,
            traits: [
              'If this unit is damaged, reduce its [DEF] by 3.',
            ],
            affinities: {
              Ether.earth: 2,
              Ether.morph: -1,
              Ether.water: -2,
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
            name: 'Grovetender',
            letter: 'C',
            health: 14,
            defense: 1,
            traits: [
              'If a Rover slays this unit, that Rover [plus_water_earth].',
            ],
            affinities: {
              Ether.water: 2,
              Ether.earth: 1,
              Ether.fire: -1,
            },
            onSlain: [
              ether([Ether.water, Ether.earth]),
            ],
          ),
          EncounterFigureDef(
            name: 'Streak',
            letter: 'A',
            health: 7,
            flies: true,
            affinities: {
              Ether.crux: 2,
              Ether.wind: 1,
              Ether.earth: -1,
            },
          ),
          EncounterFigureDef(
            name: 'Kifa',
            letter: 'B',
            health: 7,
            flies: true,
            affinities: {
              Ether.wind: 1,
              Ether.earth: 1,
              Ether.fire: -1,
              Ether.water: -1,
            },
          ),
          EncounterFigureDef(
            name: 'Dekaha',
            letter: 'C',
            health: 9,
            immuneToForcedMovement: true,
            affinities: {
              Ether.wind: -1,
              Ether.fire: -2,
              Ether.earth: 1,
              Ether.water: 2,
            },
          ),
          EncounterFigureDef(
            name: 'Terranape',
            letter: 'A',
            health: 20,
            traits: [
              'At the start of this unit\'s turn, it recovers [RCV] R.',
            ],
            affinities: {
              Ether.fire: -2,
              Ether.morph: 1,
              Ether.water: 2,
              Ether.earth: 2,
            },
          ),
          EncounterFigureDef(
            name: 'Gruv',
            letter: 'B',
            health: 18,
            defenseFormula: '2*(1-T%2)',
            traits: [
              'During even rounds, this unit gains [DEF] 2.',
            ],
            affinities: {
              Ether.water: -1,
              Ether.fire: 1,
              Ether.earth: 2,
            },
          ),
          EncounterFigureDef(
            name: 'Dyad',
            letter: 'C',
            health: 14,
            affinities: {
              Ether.morph: -2,
              Ether.earth: -1,
              Ether.water: 1,
              Ether.crux: 2,
            },
          ),
        ],
        placements: const [
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
              r: 2,
              trapDamage: 3),
          PlacementDef(
              name: 'Crumbling Column',
              type: PlacementType.trap,
              c: 11,
              r: 5,
              trapDamage: 3),
        ],
        placementGroups: [
          PlacementGroupDef(
            name: 'Wildfire',
            isSpawnWithDie: true,
            placements: [
              PlacementDef(name: 'Ashemak'),
              PlacementDef(name: 'Ashemak'),
              PlacementDef(name: 'Ashemak', minPlayers: 3),
              PlacementDef(name: 'Ashemak', minPlayers: 3),
              PlacementDef(name: 'Wrathbone'),
              PlacementDef(name: 'Wrathbone'),
              PlacementDef(name: 'Wrathbone', minPlayers: 4),
              PlacementDef(name: 'Nahoot'),
              PlacementDef(name: 'Nahoot', minPlayers: 3),
              PlacementDef(name: 'Nahoot', minPlayers: 4),
            ],
          ),
          PlacementGroupDef(
            name: 'Snapfrost',
            isSpawnWithDie: true,
            placements: [
              PlacementDef(name: 'Briarwog'),
              PlacementDef(name: 'Briarwog'),
              PlacementDef(name: 'Briarwog', minPlayers: 3),
              PlacementDef(name: 'Briarwog', minPlayers: 4),
              PlacementDef(name: 'Onisski'),
              PlacementDef(name: 'Onisski'),
              PlacementDef(name: 'Onisski', minPlayers: 3),
              PlacementDef(name: 'Onisski', minPlayers: 4),
              PlacementDef(name: 'Sek'),
              PlacementDef(name: 'Sek'),
              PlacementDef(name: 'Sek', minPlayers: 3),
              PlacementDef(name: 'Sek', minPlayers: 4),
            ],
          ),
          PlacementGroupDef(
            name: 'Everbloom',
            isSpawnWithDie: true,
            placements: [
              PlacementDef(name: 'Zinix'),
              PlacementDef(name: 'Zinix'),
              PlacementDef(name: 'Zinix', minPlayers: 3),
              PlacementDef(name: 'Zinix', minPlayers: 4),
              PlacementDef(name: 'Bulwauros'),
              PlacementDef(name: 'Bulwauros'),
              PlacementDef(name: 'Bulwauros', minPlayers: 3),
              PlacementDef(name: 'Bulwauros', minPlayers: 4),
              PlacementDef(name: 'Grovetender'),
              PlacementDef(name: 'Grovetender'),
              PlacementDef(name: 'Grovetender', minPlayers: 3),
              PlacementDef(name: 'Grovetender', minPlayers: 4),
            ],
          ),
          PlacementGroupDef(
            name: 'Windscreen',
            isSpawnWithDie: true,
            placements: [
              PlacementDef(name: 'Streak'),
              PlacementDef(name: 'Streak'),
              PlacementDef(name: 'Streak'),
              PlacementDef(name: 'Streak', minPlayers: 3),
              PlacementDef(name: 'Streak', minPlayers: 4),
              PlacementDef(name: 'Streak', minPlayers: 4),
              PlacementDef(name: 'Kifa'),
              PlacementDef(name: 'Kifa'),
              PlacementDef(name: 'Kifa'),
              PlacementDef(name: 'Kifa', minPlayers: 3),
              PlacementDef(name: 'Kifa', minPlayers: 4),
              PlacementDef(name: 'Kifa', minPlayers: 4),
              PlacementDef(name: 'Dekaha'),
              PlacementDef(name: 'Dekaha'),
              PlacementDef(name: 'Dekaha', minPlayers: 3),
              PlacementDef(name: 'Dekaha', minPlayers: 3),
            ],
          ),
          PlacementGroupDef(
            name: 'Aura',
            isSpawnWithDie: true,
            placements: [
              PlacementDef(name: 'Terranape'),
              PlacementDef(name: 'Terranape', minPlayers: 4),
              PlacementDef(name: 'Gruv'),
              PlacementDef(name: 'Gruv', minPlayers: 3),
              PlacementDef(name: 'Dyad'),
              PlacementDef(name: 'Dyad', minPlayers: 3),
              PlacementDef(name: 'Dyad', minPlayers: 4),
            ],
          ),
          PlacementGroupDef(
            name: 'Miasma',
            isSpawnWithDie: true,
            placements: [
              PlacementDef(name: 'Sek'),
              PlacementDef(name: 'Sek'),
              PlacementDef(name: 'Sek', minPlayers: 3),
              PlacementDef(name: 'Sek', minPlayers: 4),
              PlacementDef(name: 'Nahoot'),
              PlacementDef(name: 'Nahoot'),
              PlacementDef(name: 'Nahoot', minPlayers: 3),
              PlacementDef(name: 'Nahoot', minPlayers: 4),
            ],
          ),
        ],
      );

  static EncounterDef get encounterChapter4dotI => EncounterDef(
      questId: 'chapter_4',
      number: 'I',
      title: 'Hunting of the Kaleido',
      setup: EncounterSetup(
          box: 'Intermissions',
          map: '47',
          adversary: '78',
          tiles: '4x Crumbling Columns'),
      victoryDescription: 'Slay the Kaleido.',
      roundLimit: 12,
      terrain: [
        trapColumn(3),
        etherFire(),
        etherEarth(),
        etherWater(),
        etherWind(),
      ],
      stashReward: ItemDef.secretStashName,
      campaignLink:
          '''Return to Chapter 4 - “**A Consequence**” [campaign] **100**, skipping directly to the Campaign Link.''',
      challenges: [
        'When the Kaleido attacks a Rover, they must drain all [Fire], [Wind], [Earth], and [Water] ether dice in their personal or infusion pools.',
        'All adversaries are treated as occupying the positive ether fields on the Kaleido’s statistic block.',
        'Adversaries are immune to the effects of [Fire] and [Water] nodes. Rovers can not take ether dice from [Fire] and [Water] nodes and are affected by these nodes while within [Range] 1-2.',
      ],
      dialogs: [
        introductionFromText('chapter_4_adventure_intro'),
      ],
      onLoad: [
        dialog('Introduction'),
        rules('Ethereal Shell',
            '''*The Kaleido is a mature urn and has absorbed great quantities of lyst making it impervious to all damage.*  You can not damage the Kaleido’s [HP] yet.

You will have to shatter the Kaleido’s resilient multilayered shell four times to make it vulnerable to damage. For now, when you attack the Kaleido you are instead targeting its resilient shell. Treat this shell as having 3*R [HP] and [DEF] 3.'''),
        codexLink('Kaleido Caldera',
            number: 183,
            body:
                '''Before the start of the first round, read [title], [codex] 87.'''),
        codexLink('Fractured',
            number: 184,
            body:
                '''Immediately when the Kaleido’s shell has suffered 3xR or more damage, read [title], [codex] 88.'''),
        codexLink('Shattered',
            number: 185,
            body:
                '''Immediately when there are four ether fields on the Kaleido’s statistic block, read [title], [codex] 88.'''),
        codex(183),
      ],
      startingMap: MapDef(
        id: 'I3.1',
        columnCount: 13,
        rowCount: 11,
        backgroundRect: Rect.fromLTWH(110.0, 44.0, 1481.0, 1411.0),
        starts: [
          (3, 10),
          (5, 10),
          (7, 10),
          (9, 10),
        ],
        terrain: {
          (0, 0): TerrainType.barrier,
          (0, 1): TerrainType.barrier,
          (0, 3): TerrainType.object,
          (0, 4): TerrainType.object,
          (0, 5): TerrainType.object,
          (0, 8): TerrainType.object,
          (0, 9): TerrainType.object,
          (1, 0): TerrainType.barrier,
          (1, 1): TerrainType.barrier,
          (1, 10): TerrainType.object,
          (2, 0): TerrainType.barrier,
          (3, 0): TerrainType.barrier,
          (3, 2): TerrainType.object,
          (4, 0): TerrainType.difficult,
          (4, 8): TerrainType.difficult,
          (4, 9): TerrainType.difficult,
          (5, 0): TerrainType.difficult,
          (5, 1): TerrainType.difficult,
          (5, 3): TerrainType.difficult,
          (5, 4): TerrainType.difficult,
          (5, 6): TerrainType.object,
          (5, 8): TerrainType.difficult,
          (5, 10): TerrainType.difficult,
          (6, 0): TerrainType.difficult,
          (6, 1): TerrainType.difficult,
          (6, 2): TerrainType.difficult,
          (6, 4): TerrainType.difficult,
          (6, 7): TerrainType.difficult,
          (7, 0): TerrainType.difficult,
          (7, 1): TerrainType.difficult,
          (7, 5): TerrainType.difficult,
          (7, 6): TerrainType.difficult,
          (7, 7): TerrainType.difficult,
          (7, 9): TerrainType.object,
          (8, 0): TerrainType.difficult,
          (8, 2): TerrainType.object,
          (9, 0): TerrainType.barrier,
          (10, 0): TerrainType.barrier,
          (11, 0): TerrainType.barrier,
          (11, 1): TerrainType.barrier,
          (11, 3): TerrainType.object,
          (11, 10): TerrainType.object,
          (12, 0): TerrainType.barrier,
          (12, 1): TerrainType.barrier,
          (12, 2): TerrainType.object,
          (12, 3): TerrainType.object,
          (12, 4): TerrainType.object,
          (12, 8): TerrainType.object,
          (12, 9): TerrainType.object,
        },
      ),
      adversaries: [
        EncounterFigureDef(
          name: 'Tentacle',
          letter: 'A',
          health: 8,
          flies: true,
          spawnable: true,
          affinities: {
            Ether.earth: 1,
            Ether.fire: 1,
            Ether.water: 1,
            Ether.wind: 1,
          },
        ),
        EncounterFigureDef(
          name: 'Kaleido',
          letter: 'B',
          type: AdversaryType.boss,
          large: true,
          healthFormula: '12*R',
          flies: true,
          possibleTokens: [
            EtherField.wildfire.toJson(),
            EtherField.everbloom.toJson(),
            EtherField.snapfrost.toJson(),
            EtherField.windscreen.toJson(),
          ],
          traits: [
            'X equals the number of ether field tokens on this stastic block.',
          ],
          affinities: {
            Ether.crux: -1,
            Ether.morph: -1,
          },
          onMilestone: {
            '_shell1': [
              addToken(EtherField.wildfire.toJson()),
              rules('Exposed Innards',
                  '''All units part of the Rover faction are treated as occupying the negative ether fields that are on the Kaleido’s statistic block.

The Kaleido is treated as occupying the positive ether fields that are on its statistic block.'''),
            ],
            '_shell2': [
              addToken(EtherField.everbloom.toJson()),
            ],
            '_shell3': [
              addToken(EtherField.snapfrost.toJson()),
            ],
            '_shell4': [
              addToken(EtherField.windscreen.toJson()),
              codex(185),
              removeRule('Ethereal Shell'),
              rules('Shattered',
                  'The Ethereal Shell rule is no longer active. When you target the Kaleido with attacks, you now attack the monstrosity directly damaging its [HP] as normal.'),
              codexLink('Land Squid',
                  number: 186,
                  body:
                      '''Immediately when the Kaleido is slain, read [title], [codex] 89.'''),
            ],
          },
          onSlain: [
            codex(186),
            victory(),
          ],
        ),
        EncounterFigureDef(
          name: 'Kaleido Shell 1',
          healthFormula: '3*R',
          defense: 3,
          onSlain: [
            milestone('_shell1'),
            codex(184),
            placementGroup('Urnlettes',
                body:
                    '''*The Kaleido’s ethereal shell has been damaged but not destroyed.*

Spawn R urnlettes adjacent to the Kaleido.

Place a [wildfire] on the Kaleido's statistic block. *[The app does this automatically.]*'''),
            placementGroup('Kaleido Shell 2', silent: true),
          ],
        ),
        EncounterFigureDef(
          name: 'Kaleido Shell 2',
          healthFormula: '3*R',
          defense: 2,
          traits: [
            'Has [DEF] 3-X, where X equals the number of ether fields on the Kaleido’s statistic block.'
          ],
          onSlain: [
            milestone('_shell2'),
            placementGroup('Urnlettes',
                body:
                    '''*The Kaleido’s ethereal shell has been damaged but not destroyed.*

Spawn R urnlettes adjacent to the Kaleido.

Place a [everbloom] on the Kaleido's statistic block. *[The app does this automatically.]*'''),
            placementGroup('Kaleido Shell 3', silent: true),
          ],
        ),
        EncounterFigureDef(
          name: 'Kaleido Shell 3',
          healthFormula: '3*R',
          defense: 1,
          traits: [
            'Has [DEF] 3-X, where X equals the number of ether fields on the Kaleido’s statistic block.'
          ],
          onSlain: [
            milestone('_shell3'),
            placementGroup('Urnlettes',
                body:
                    '''*The Kaleido’s ethereal shell has been damaged but not destroyed.*

Spawn R urnlettes adjacent to the Kaleido.

Place a [snapfrost] on the Kaleido's statistic block. *[The app does this automatically.]*'''),
            placementGroup('Kaleido Shell 4', silent: true),
          ],
        ),
        EncounterFigureDef(
          name: 'Kaleido Shell 4',
          healthFormula: '3*R',
          traits: [
            'Has [DEF] 3-X, where X equals the number of ether fields on the Kaleido’s statistic block.'
          ],
          onSlain: [
            placementGroup('Urnlettes',
                body: '''Spawn R urnlettes adjacent to the Kaleido.

Place a [windscreen] on the Kaleido's statistic block. *[The app does this automatically.]*'''),
            milestone('_shell4'),
          ],
        ),
        EncounterFigureDef(
          name: 'Urn',
          alias: 'Urnlette',
          letter: 'C',
          health: 4,
          affinities: {
            Ether.crux: 0,
          },
          traits: [
            'While this unit is within [Range] 1 of the Kaleido, this unit is immune to all damage.'
          ],
        ),
      ],
      placements: [
        PlacementDef(name: 'Tentacle', c: 1, r: 5),
        PlacementDef(name: 'Tentacle', c: 0, r: 6, minPlayers: 4),
        PlacementDef(name: 'Tentacle', c: 4, r: 3, minPlayers: 3),
        PlacementDef(name: 'Tentacle', c: 4, r: 1),
        PlacementDef(name: 'Tentacle', c: 8, r: 1),
        PlacementDef(name: 'Tentacle', c: 8, r: 5, minPlayers: 4),
        PlacementDef(name: 'Tentacle', c: 11, r: 4),
        PlacementDef(name: 'Tentacle', c: 12, r: 5, minPlayers: 3),
        PlacementDef(name: 'Kaleido', c: 6, r: 1),
        PlacementDef(
            name: 'Kaleido Shell 1',
            fixedTokens: [EtherField.wildfire.toJson()]),
        PlacementDef(
            name: 'Crumbling Column',
            type: PlacementType.trap,
            c: 1,
            r: 9,
            trapDamage: 3),
        PlacementDef(
            name: 'Crumbling Column',
            type: PlacementType.trap,
            c: 11,
            r: 9,
            trapDamage: 3),
        PlacementDef(
            name: 'Crumbling Column',
            type: PlacementType.trap,
            c: 3,
            r: 1,
            trapDamage: 3),
        PlacementDef(
            name: 'Crumbling Column',
            type: PlacementType.trap,
            c: 11,
            r: 2,
            trapDamage: 3),
        PlacementDef(name: 'earth', type: PlacementType.ether, c: 3, r: 2),
        PlacementDef(name: 'wind', type: PlacementType.ether, c: 8, r: 2),
        PlacementDef(name: 'water', type: PlacementType.ether, c: 5, r: 6),
        PlacementDef(name: 'fire', type: PlacementType.ether, c: 7, r: 9),
      ],
      placementGroups: [
        PlacementGroupDef(name: 'Urnlettes', placements: [
          PlacementDef(name: 'Urn'),
          PlacementDef(name: 'Urn'),
          PlacementDef(name: 'Urn', minPlayers: 3),
          PlacementDef(name: 'Urn', minPlayers: 4),
        ]),
        PlacementGroupDef(name: 'Kaleido Shell 2', placements: [
          PlacementDef(
              name: 'Kaleido Shell 2',
              fixedTokens: [EtherField.everbloom.toJson()]),
        ]),
        PlacementGroupDef(name: 'Kaleido Shell 3', placements: [
          PlacementDef(
              name: 'Kaleido Shell 3',
              fixedTokens: [EtherField.snapfrost.toJson()]),
        ]),
        PlacementGroupDef(name: 'Kaleido Shell 4', placements: [
          PlacementDef(
              name: 'Kaleido Shell 4',
              fixedTokens: [EtherField.windscreen.toJson()]),
        ]),
      ]);

  static EncounterDef get encounterChapter5dotI => EncounterDef(
        questId: 'chapter_5',
        number: 'I',
        title: 'Skyward Plateau',
        setup: EncounterSetup(
            box: 'Intermissions',
            map: '58',
            adversary: '100-101',
            tiles: '4x Bursting Bells'),
        victoryDescription: 'Slay all adversaries.',
        lossDescription: 'Lose if Hra is slain.',
        terrain: [
          trapColumn(3),
          etherEarth(),
        ],
        extraPhase: 'Hra',
        extraPhaseIndex: 0,
        roundLimit: 8,
        baseLystReward: 15,
        milestone: CampaignMilestone.milestoneIdot4,
        etherRewards: [Ether.earth],
        campaignLink:
            '''Return to Chapter 5 - “**Era Shattered**” [campaign] **130**, skipping directly to the Campaign Link.''',
        challenges: [
          'When the encounter begins, Hra suffers half their [HP] in damage.',
          'Hra’s attack loses the [Push] effect.',
          'When rolling the damage dice for adversary attacks, treat a result of [DIM] as +1 [DMG].',
        ],
        dialogs: [
          introductionFromText('chapter_5_adventure_intro'),
        ],
        onLoad: [
          dialog('Introduction'),
          rules('Hra',
              '''*Hra is a mysterious earth aligned Starling who appears to be an ally to you and enemy to the Star Hunters.*  They are a part of their own faction, Hra, which is allied with Rovers, enemies with adversaries, and gains priority before the Rover faction.

Hra has 10*R hit points. As traits, they have [DEF] 1, all push and pull effects targeting Hra are reduced by 1, and boulder objects within [Range] 1-2 of Hra are treated as barrier spaces.

Hra follows all the adversary logic rules found in the rule book. During their turn, Hra performs the following ability:

[Dash] 1 << Ignore all movement penalties.
[m_attack] | [Range] 1 | [DMG]3 | Push] 3'''),
          codexLink('Hey There Big Guy',
              number: 187,
              body:
                  '''Immediately when all enemies are slain, read [title], [codex] 89.'''),
        ],
        onMilestone: {
          '_victory': [
            codex(187),
            victory(),
          ]
        },
        startingMap: MapDef(
          id: 'I4.1',
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
            (0, 0): TerrainType.difficult,
            (1, 6): TerrainType.difficult,
            (2, 3): TerrainType.object,
            (3, 1): TerrainType.object,
            (6, 1): TerrainType.object,
            (6, 7): TerrainType.object,
            (6, 9): TerrainType.difficult,
            (8, 1): TerrainType.object,
            (8, 4): TerrainType.object,
            (9, 0): TerrainType.openAir,
            (9, 3): TerrainType.object,
            (9, 7): TerrainType.object,
            (10, 3): TerrainType.openAir,
            (11, 0): TerrainType.openAir,
            (11, 3): TerrainType.openAir,
            (11, 4): TerrainType.openAir,
            (11, 5): TerrainType.openAir,
            (11, 8): TerrainType.difficult,
            (12, 0): TerrainType.openAir,
            (12, 1): TerrainType.openAir,
            (12, 2): TerrainType.openAir,
            (12, 3): TerrainType.openAir,
            (12, 4): TerrainType.openAir,
            (12, 5): TerrainType.openAir,
            (12, 6): TerrainType.openAir,
          },
        ),
        adversaries: [
          EncounterFigureDef(
            name: 'Streak',
            letter: 'A',
            health: 8,
            flies: true,
            affinities: {
              Ether.wind: 2,
              Ether.crux: 1,
              Ether.earth: -1,
            },
            onSlain: [
              milestone('_victory',
                  condition: AllAdversariesSlainExceptCondition('Hra')),
            ],
          ),
          EncounterFigureDef(
            name: 'Briarwog',
            health: 10,
            traits: [
              '''[React] After this unit is attacked from within [Range] 1:
              
The attacker suffers [DMG]1.''',
            ],
            affinities: {
              Ether.earth: -1,
              Ether.fire: -1,
              Ether.morph: 1,
              Ether.water: 2,
            },
            onSlain: [
              milestone('_victory',
                  condition: AllAdversariesSlainExceptCondition('Hra')),
            ],
          ),
          EncounterFigureDef(
            name: 'Wrathbone',
            letter: 'C',
            health: 20,
            traits: [
              '''[React] At the end of the Rover phase:
              
All enemies within [Range] 1-2 suffer [DMG]1. << Enemies within [Range] 1 suffer an additional [DMG]1.''',
            ],
            affinities: {
              Ether.fire: 2,
              Ether.earth: 1,
              Ether.water: -2,
            },
            onSlain: [
              milestone('_victory',
                  condition: AllAdversariesSlainExceptCondition('Hra')),
            ],
          ),
          EncounterFigureDef(
            name: 'Harrow',
            letter: 'D',
            health: 18,
            affinities: {
              Ether.morph: 2,
              Ether.crux: 2,
            },
            onSlain: [
              milestone('_victory',
                  condition: AllAdversariesSlainExceptCondition('Hra')),
            ],
          ),
          EncounterFigureDef(
            name: 'Courslayer',
            health: 15,
            affinities: {
              Ether.fire: -1,
              Ether.earth: -1,
              Ether.water: 2,
              Ether.wind: 2,
            },
            onSlain: [
              milestone('_victory',
                  condition: AllAdversariesSlainExceptCondition('Hra')),
            ],
          ),
          EncounterFigureDef(
            name: 'Stormcaller',
            health: 15,
            flies: true,
            traits: [
              'This unit gains [DEF] 2 against [r_attack] targeting it.',
            ],
            affinities: {
              Ether.wind: 2,
              Ether.crux: 2,
              Ether.water: 1,
              Ether.morph: 1,
              Ether.fire: -1,
              Ether.earth: -2,
            },
            onSlain: [
              milestone('_victory',
                  condition: AllAdversariesSlainExceptCondition('Hra')),
            ],
          ),
          EncounterFigureDef(
            name: 'Hra',
            healthFormula: '10*R',
            defense: 1,
            faction: 'Hra',
            onSlain: [
              fail(),
            ],
          ),
        ],
        placements: const [
          PlacementDef(name: 'Hra', c: 10, r: 1),
          PlacementDef(name: 'Streak', c: 0, r: 3),
          PlacementDef(name: 'Streak', c: 8, r: 9),
          PlacementDef(name: 'Briarwog', minPlayers: 3),
          PlacementDef(name: 'Briarwog', c: 5, r: 5),
          PlacementDef(name: 'Briarwog', c: 7, r: 7),
          PlacementDef(name: 'Briarwog', c: 10, r: 8, minPlayers: 3),
          PlacementDef(name: 'Wrathbone', c: 6, r: 5, minPlayers: 4),
          PlacementDef(name: 'Wrathbone'),
          PlacementDef(name: 'Harrow', c: 7, r: 2, minPlayers: 4),
          PlacementDef(name: 'Harrow', c: 8, r: 2),
          PlacementDef(name: 'Courslayer', c: 6, r: 0),
          PlacementDef(name: 'Courslayer', c: 9, r: 5, minPlayers: 3),
          PlacementDef(name: 'Stormcaller', c: 11, r: 4),
          PlacementDef(
              name: 'Bursting Bell',
              type: PlacementType.trap,
              c: 3,
              r: 2,
              trapDamage: 3),
          PlacementDef(
              name: 'Bursting Bell',
              type: PlacementType.trap,
              c: 5,
              r: 4,
              trapDamage: 3),
          PlacementDef(
              name: 'Bursting Bell',
              type: PlacementType.trap,
              c: 10,
              r: 5,
              trapDamage: 3),
          PlacementDef(
              name: 'Bursting Bell',
              type: PlacementType.trap,
              c: 2,
              r: 8,
              trapDamage: 3),
          PlacementDef(name: 'earth', type: PlacementType.ether),
          PlacementDef(name: 'earth', type: PlacementType.ether, c: 6, r: 7),
        ],
      );
}
