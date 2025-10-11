import 'dart:ui';
import 'encounter_def_utils.dart';
import 'package:rove_data_types/rove_data_types.dart';

extension Quest8 on EncounterDef {
  static EncounterDef get encounter8dot1 => EncounterDef(
        questId: '8',
        number: '1',
        title: 'Wind-Bitten Ancient Elms',
        setup: EncounterSetup(box: '4/8', map: '53', adversary: '90-91'),
        victoryDescription: 'Slay the Squall.',
        roundLimit: 8,
        terrain: [
          etherWind(),
          etherCrux(),
        ],
        extraPhase: 'The Uzem',
        extraPhaseIndex: 2,
        baseLystReward: 25,
        campaignLink:
            'Encounter 8.2 - “**The Desolated Home**”, [campaign] **120**.',
        challenges: [
          'Treat the Squall as occupying a [windscreen]. This is a permanent effect.',
          'Adversaries ignore [HP] as a tie breaker and prefer to attack the Breath of Uzem if they are closest. Further, adversaries gain +1 [DMG] when attacking the Breath of Uzem.',
          'When the Squall attacks a Rover, they must drain all [Wind] ether dice in their personal or infusion pools.',
        ],
        dialogs: [
          introductionFromText('quest_8_encounter_1_intro'),
        ],
        onLoad: [
          dialog('Introduction'),
          rules('Uzem’s Prodigy',
              '''The Breath of Uzem is part of their own faction, the Uzem, which are allies to Rovers and enemies to adversaries. Units a part of the Uzem follow all the adversary logic rules in the rule book. This faction gains priority after the Adversary faction has gone.'''),
          codexLink('Birds of a Feather',
              number: 144,
              body:
                  '''The first time a streak is slain, read [title], [codex] 67.'''),
          codexLink('Exhale',
              number: 145,
              body:
                  '''Immediately when the Squall is slain, if the Breath of Uzem is alive, read [title], [codex] 67.'''),
          codexLink('It Must Be Wednesday',
              number: 146,
              body:
                  '''Immediately when the Squall is slain, if the Breath of Uzem was slain, read [title], [codex] 68.'''),
        ],
        onMilestone: {
          '_victory_with_uzem_alive': [
            codex(145),
            victory(),
            milestone(CampaignMilestone.milestone8dot1BreathOfUzemLives)
          ],
          '_victory_with_uzem_slain': [
            codex(146),
            victory(),
            milestone(CampaignMilestone.milestone8dot1BreathOfUzemSlain)
          ],
        },
        startingMap: MapDef(
          id: '8.1',
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
            (0, 2): TerrainType.openAir,
            (0, 3): TerrainType.openAir,
            (0, 4): TerrainType.openAir,
            (0, 5): TerrainType.openAir,
            (0, 6): TerrainType.openAir,
            (1, 2): TerrainType.openAir,
            (1, 3): TerrainType.openAir,
            (1, 4): TerrainType.openAir,
            (1, 5): TerrainType.openAir,
            (1, 6): TerrainType.openAir,
            (2, 1): TerrainType.openAir,
            (2, 2): TerrainType.openAir,
            (2, 6): TerrainType.difficult,
            (3, 0): TerrainType.openAir,
            (3, 1): TerrainType.openAir,
            (3, 2): TerrainType.openAir,
            (3, 7): TerrainType.openAir,
            (4, 0): TerrainType.openAir,
            (4, 1): TerrainType.openAir,
            (4, 3): TerrainType.difficult,
            (4, 4): TerrainType.object,
            (4, 7): TerrainType.difficult,
            (5, 1): TerrainType.openAir,
            (5, 2): TerrainType.openAir,
            (5, 6): TerrainType.difficult,
            (5, 8): TerrainType.openAir,
            (5, 9): TerrainType.openAir,
            (5, 10): TerrainType.openAir,
            (6, 1): TerrainType.openAir,
            (6, 2): TerrainType.openAir,
            (6, 7): TerrainType.openAir,
            (6, 8): TerrainType.openAir,
            (6, 9): TerrainType.openAir,
            (7, 2): TerrainType.openAir,
            (7, 3): TerrainType.openAir,
            (7, 7): TerrainType.openAir,
            (7, 8): TerrainType.openAir,
            (7, 9): TerrainType.openAir,
            (8, 1): TerrainType.openAir,
            (8, 2): TerrainType.openAir,
            (8, 3): TerrainType.openAir,
            (8, 4): TerrainType.difficult,
            (8, 5): TerrainType.difficult,
            (8, 6): TerrainType.openAir,
            (8, 7): TerrainType.openAir,
            (8, 8): TerrainType.openAir,
            (9, 1): TerrainType.openAir,
            (9, 2): TerrainType.openAir,
            (9, 8): TerrainType.openAir,
            (9, 9): TerrainType.openAir,
            (10, 0): TerrainType.openAir,
            (10, 1): TerrainType.openAir,
            (10, 3): TerrainType.difficult,
            (10, 8): TerrainType.openAir,
            (10, 9): TerrainType.openAir,
            (11, 0): TerrainType.openAir,
            (11, 1): TerrainType.openAir,
            (11, 5): TerrainType.object,
            (11, 7): TerrainType.difficult,
            (11, 9): TerrainType.openAir,
            (11, 10): TerrainType.openAir,
            (12, 0): TerrainType.openAir,
            (12, 4): TerrainType.object,
            (12, 5): TerrainType.object,
            (12, 9): TerrainType.openAir,
          },
        ),
        adversaries: [
          EncounterFigureDef(
            name: 'Galeaper',
            letter: 'A',
            standeeCount: 5,
            health: 7,
            flies: true,
            affinities: {
              Ether.wind: 2,
              Ether.morph: 1,
              Ether.fire: -1,
              Ether.earth: -1,
            },
          ),
          EncounterFigureDef(
              name: 'Streak',
              letter: 'B',
              standeeCount: 7,
              health: 8,
              flies: true,
              affinities: {
                Ether.earth: -1,
                Ether.wind: 1,
                Ether.crux: 1,
              },
              onSlain: [
                codex(144),
              ]),
          EncounterFigureDef(
            name: 'Stormcaller',
            letter: 'C',
            standeeCount: 3,
            health: 14,
            flies: true,
            traits: [
              'This unit gains [DEF] 1 against [r_attack] targeting it.',
            ],
            affinities: {
              Ether.wind: 2,
              Ether.crux: 2,
              Ether.water: 1,
              Ether.fire: -1,
              Ether.morph: -1,
              Ether.earth: -2,
            },
          ),
          EncounterFigureDef(
            name: 'Squall',
            letter: 'D',
            type: AdversaryType.miniboss,
            standeeCount: 1,
            healthFormula: '10*R',
            flies: true,
            affinities: {
              Ether.wind: 3,
              Ether.crux: 1,
              Ether.fire: -1,
              Ether.water: -1,
              Ether.earth: -1,
            },
          ),
          EncounterFigureDef(
            name: 'Breath of Uzem',
            letter: 'D',
            faction: 'The Uzem',
            standeeCount: 1,
            health: 18,
            flies: true,
            affinities: {
              Ether.earth: -1,
              Ether.crux: 2,
              Ether.wind: 2,
            },
          ),
        ],
        placements: [
          PlacementDef(name: 'Galeaper', c: 9, r: 10, minPlayers: 3),
          PlacementDef(name: 'Galeaper', c: 7, r: 7),
          PlacementDef(name: 'Galeaper', c: 3, r: 4, minPlayers: 4),
          PlacementDef(name: 'Galeaper', c: 0, r: 4),
          PlacementDef(name: 'Streak', c: 4, r: 5, minPlayers: 3),
          PlacementDef(name: 'Streak', c: 0, r: 1, minPlayers: 3),
          PlacementDef(name: 'Streak', c: 1, r: 3),
          PlacementDef(name: 'Streak', c: 7, r: 9),
          PlacementDef(name: 'Stormcaller', c: 6, r: 6),
          PlacementDef(name: 'Stormcaller', c: 2, r: 3),
          PlacementDef(name: 'Stormcaller', c: 5, r: 4, minPlayers: 4),
          PlacementDef(name: 'Squall', c: 10, r: 4, onSlain: [
            milestone('_victory_with_uzem_alive',
                condition: IsAliveCondition('Breath of Uzem')),
            milestone('_victory_with_uzem_slain',
                condition: IsSlainCondition('Breath of Uzem')),
          ]),
          PlacementDef(name: 'Breath of Uzem', c: 12, r: 1),
          PlacementDef(name: 'wind', type: PlacementType.ether, c: 11, r: 5),
          PlacementDef(name: 'wind', type: PlacementType.ether, c: 12, r: 4),
          PlacementDef(name: 'wind', type: PlacementType.ether, c: 12, r: 5),
          PlacementDef(name: 'crux', type: PlacementType.ether, c: 4, r: 4),
        ],
      );

  static EncounterDef get encounter8dot2 => EncounterDef(
        questId: '8',
        number: '2',
        title: 'The Desolated Home',
        setup: EncounterSetup(box: '4/8', map: '54', adversary: '92-93'),
        victoryDescription: 'Slay the Tremorcaller.',
        roundLimit: 8,
        terrain: [
          dangerousBones(1),
          etherEarth(),
          etherCrux(),
        ],
        baseLystReward: 20,
        itemRewards: [
          'Thundering Hikers',
        ],
        campaignLink:
            'Encounter 8.3 - “**Excess Of Their Thirst**”, [campaign] **122**.',
        challenges: [
          'Rovers can’t benefit from the effects of [Earth] nodes and can’t take ether dice from them. Adversaries are affected by [Earth] nodes when within [Range] 1-2.',
          'Harrows gain +1 movement point to all of their movement actions and are immune to [push] and [pull] effects.',
          'Onisski have +3 [HP].',
        ],
        dialogs: [
          introductionFromText('quest_8_encounter_2_intro'),
        ],
        onLoad: [
          dialog('Introduction'),
          codexLink('Not Enough Ether',
              number: 147,
              body:
                  '''The first time a harrow is slain, read [title], [codex] 68.'''),
          codexLink('Mineral Shell',
              number: 148,
              body: '''If the urn is slain, read [title], [codex] 68.'''),
          codexLink('Rock On',
              number: 149,
              body:
                  '''Immediately when the Tremorcaller is slain, read [title], [codex] 69.'''),
        ],
        startingMap: MapDef(
          id: '8.2',
          columnCount: 13,
          rowCount: 11,
          backgroundRect: Rect.fromLTWH(110.0, 44.0, 1481.0, 1411.0),
          starts: [
            (4, 9),
            (5, 10),
            (6, 9),
            (7, 10),
            (8, 9),
          ],
          terrain: {
            (0, 2): TerrainType.difficult,
            (0, 6): TerrainType.difficult,
            (0, 9): TerrainType.barrier,
            (1, 5): TerrainType.dangerous,
            (1, 9): TerrainType.barrier,
            (1, 10): TerrainType.barrier,
            (2, 1): TerrainType.difficult,
            (2, 4): TerrainType.barrier,
            (2, 5): TerrainType.barrier,
            (3, 5): TerrainType.barrier,
            (3, 8): TerrainType.difficult,
            (4, 1): TerrainType.dangerous,
            (4, 2): TerrainType.barrier,
            (5, 2): TerrainType.barrier,
            (5, 3): TerrainType.barrier,
            (5, 7): TerrainType.object,
            (5, 10): TerrainType.difficult,
            (6, 4): TerrainType.object,
            (7, 4): TerrainType.object,
            (7, 5): TerrainType.object,
            (8, 0): TerrainType.barrier,
            (8, 1): TerrainType.barrier,
            (8, 6): TerrainType.difficult,
            (9, 1): TerrainType.barrier,
            (9, 3): TerrainType.difficult,
            (9, 5): TerrainType.barrier,
            (9, 10): TerrainType.difficult,
            (10, 4): TerrainType.barrier,
            (10, 5): TerrainType.barrier,
            (10, 8): TerrainType.dangerous,
            (11, 8): TerrainType.barrier,
            (11, 9): TerrainType.barrier,
            (12, 5): TerrainType.difficult,
            (12, 8): TerrainType.barrier,
          },
        ),
        adversaries: [
          EncounterFigureDef(
            name: 'Onisski',
            letter: 'A',
            standeeCount: 6,
            healthFormula: '10+3*C3',
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
            name: 'Bulwauros',
            letter: 'B',
            standeeCount: 3,
            health: 8,
            defense: 3,
            traits: [
              'If this unit is damaged, reduce its [DEF] by 3. ',
            ],
            affinities: {
              Ether.earth: 2,
              Ether.wind: -1,
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
            name: 'Harrow',
            letter: 'C',
            standeeCount: 3,
            health: 16,
            affinities: {
              Ether.morph: 2,
              Ether.crux: 2,
            },
            onSlain: [
              codex(147),
            ],
          ),
          EncounterFigureDef(
            name: 'Tremorcaller',
            letter: 'D',
            type: AdversaryType.miniboss,
            standeeCount: 3,
            healthFormula: '10*R',
            flies: true,
            traits: [
              'While there is an [Earth] dice on an ether node, this unit reduces all sources of [DMG] by 2.',
            ],
            affinities: {
              Ether.earth: 2,
              Ether.crux: 2,
              Ether.wind: 1,
              Ether.water: 1,
              Ether.fire: -1,
              Ether.morph: -2,
            },
          ),
          EncounterFigureDef(
            name: 'Urn',
            letter: 'E',
            standeeCount: 2,
            healthFormula: '4*R',
            defense: 3,
            affinities: {
              Ether.fire: 2,
              Ether.water: 2,
              Ether.earth: 2,
              Ether.wind: 2,
            },
            onSlain: [
              codex(148),
              lyst('5*R'),
              item('Arcana Pigment',
                  body:
                      'The Rover that slayed the Urn gains one “Arcana Pigment” item. They may equip this item. If they don’t have the required item slot(s) available, they may unequip items as needed.'),
            ],
          ),
        ],
        placements: [
          PlacementDef(name: 'Onisski', c: 9, r: 3, minPlayers: 4),
          PlacementDef(name: 'Onisski', c: 8, r: 6),
          PlacementDef(name: 'Onisski', c: 1, r: 7, minPlayers: 3),
          PlacementDef(name: 'Bulwauros', c: 2, r: 6),
          PlacementDef(name: 'Bulwauros', c: 12, r: 6, minPlayers: 3),
          PlacementDef(name: 'Bulwauros', c: 6, r: 1, minPlayers: 3),
          PlacementDef(name: 'Harrow', c: 4, r: 4),
          PlacementDef(name: 'Harrow', c: 8, r: 4),
          PlacementDef(name: 'Harrow', c: 3, r: 3, minPlayers: 4),
          PlacementDef(name: 'Tremorcaller', c: 6, r: 3, onSlain: [
            codex(149),
            victory(),
          ]),
          PlacementDef(name: 'Urn', c: 0, r: 1),
          PlacementDef(name: 'Urn', c: 12, r: 1),
          PlacementDef(name: 'crux', type: PlacementType.ether, c: 5, r: 7),
          PlacementDef(name: 'earth', type: PlacementType.ether, c: 6, r: 4),
          PlacementDef(name: 'earth', type: PlacementType.ether, c: 7, r: 5),
          PlacementDef(name: 'earth', type: PlacementType.ether, c: 7, r: 4),
        ],
      );

  static EncounterDef get encounter8dot3 => EncounterDef(
        questId: '8',
        number: '3',
        title: 'Excess of Their Thirst',
        setup: EncounterSetup(
            box: '4/8',
            map: '55',
            adversary: '94-95',
            tiles: '2x Bursting Bells'),
        victoryDescription: 'Slay the Wavecaller.',
        roundLimit: 8,
        terrain: [
          trapBell(3),
          etherWater(),
          etherCrux(),
        ],
        unlocksRoverLevel: 8,
        baseLystReward: 15,
        campaignLink:
            'Encounter 8.4 - “**The Ancient Glimmer Burn**”, [campaign] **124**.',
        challenges: [
          'When an adversary triggers the [wildfire] effect, remove that tile. When an adversary triggers the [snapfrost] effect, they recover [RCV] 2.',
          'When the Wavecaster is within [Range] 1-2 of the Tears of Uzem they gain +2 [DEF].',
          'The Tears of Uzem gains +1 [DMG] to all of their attacks.',
        ],
        dialogs: [
          introductionFromText('quest_8_encounter_3_intro'),
        ],
        onLoad: [
          dialog('Introduction'),
          rules('Uzem’s Prodigy',
              'The Tears of Uzem has been enslaved by the Wavecaller and is part of the adversary faction. Try to slay the Wavecaller without slaying the Tears of Uzem.'),
          codexLink('Hope Floats',
              number: 150,
              body:
                  '''When the Wavecaller is slain, if the Tears of Uzem is alive, read [title], [codex] 69.'''),
          codexLink('Flotsam',
              number: 151,
              body:
                  '''When the Wavecaller is slain, if the Tears of Uzem was slain, read [title], [codex] 70.'''),
        ],
        onMilestone: {
          '_victory_with_uzem_alive': [
            codex(150),
            victory(),
            item('Gallant Crown'),
            milestone(CampaignMilestone.milestone8dot3TearsOfUzemLives)
          ],
          '_victory_with_uzem_slain': [
            codex(151),
            victory(),
            milestone(CampaignMilestone.milestone8dot3TearsOfUzemSlain)
          ],
        },
        startingMap: MapDef(
          id: '8.3',
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
            (0, 2): TerrainType.openAir,
            (0, 3): TerrainType.openAir,
            (0, 6): TerrainType.openAir,
            (0, 7): TerrainType.openAir,
            (0, 8): TerrainType.openAir,
            (0, 9): TerrainType.openAir,
            (1, 0): TerrainType.barrier,
            (1, 8): TerrainType.openAir,
            (1, 9): TerrainType.openAir,
            (1, 10): TerrainType.openAir,
            (2, 0): TerrainType.barrier,
            (2, 2): TerrainType.difficult,
            (2, 9): TerrainType.openAir,
            (3, 0): TerrainType.barrier,
            (3, 6): TerrainType.difficult,
            (3, 10): TerrainType.difficult,
            (4, 0): TerrainType.barrier,
            (5, 0): TerrainType.barrier,
            (5, 1): TerrainType.barrier,
            (5, 2): TerrainType.object,
            (5, 5): TerrainType.object,
            (5, 10): TerrainType.difficult,
            (6, 0): TerrainType.barrier,
            (7, 0): TerrainType.barrier,
            (7, 1): TerrainType.barrier,
            (7, 2): TerrainType.difficult,
            (7, 8): TerrainType.object,
            (7, 10): TerrainType.difficult,
            (8, 0): TerrainType.barrier,
            (8, 6): TerrainType.difficult,
            (9, 0): TerrainType.barrier,
            (9, 1): TerrainType.barrier,
            (9, 10): TerrainType.difficult,
            (10, 0): TerrainType.barrier,
            (10, 8): TerrainType.object,
            (10, 9): TerrainType.openAir,
            (11, 0): TerrainType.barrier,
            (11, 3): TerrainType.object,
            (11, 8): TerrainType.difficult,
            (11, 9): TerrainType.openAir,
            (11, 10): TerrainType.openAir,
            (12, 3): TerrainType.openAir,
            (12, 4): TerrainType.object,
            (12, 7): TerrainType.openAir,
            (12, 8): TerrainType.openAir,
            (12, 9): TerrainType.openAir,
          },
        ),
        adversaries: [
          EncounterFigureDef(
            name: 'Briarwog',
            letter: 'A',
            standeeCount: 3,
            health: 10,
            traits: [
              '''[React] After this unit is attacked from within [Range] 1:
              
The attacker suffers [DMG]1.''',
            ],
            affinities: {
              Ether.water: 2,
              Ether.morph: 1,
              Ether.earth: -1,
              Ether.fire: -1,
            },
          ),
          EncounterFigureDef(
            name: 'Dekaha',
            letter: 'B',
            standeeCount: 8,
            health: 9,
            immuneToForcedMovement: true,
            affinities: {
              Ether.water: 2,
              Ether.earth: 1,
              Ether.fire: -2,
            },
          ),
          EncounterFigureDef(
            name: 'Harrow',
            letter: 'C',
            standeeCount: 3,
            health: 16,
            affinities: {
              Ether.morph: 2,
              Ether.crux: 2,
            },
          ),
          EncounterFigureDef(
            name: 'Wavecaller',
            letter: 'D',
            type: AdversaryType.miniboss,
            standeeCount: 3,
            healthFormula: '10*R',
            flies: true,
            traits: [
              '[React] At the beginning of this unit\'s turn, if the Tears of Uzem is alive, this unit performs: [Heal] | [Range] 0 | [RCV] R*2',
            ],
            affinities: {
              Ether.water: 2,
              Ether.crux: 2,
              Ether.wind: 1,
              Ether.earth: -1,
              Ether.fire: -1,
              Ether.morph: -2,
            },
          ),
          EncounterFigureDef(
            name: 'Tears of Uzem',
            letter: 'E',
            standeeCount: 1,
            health: 18,
            affinities: {
              Ether.crux: 2,
              Ether.water: 2,
              Ether.wind: -1,
            },
          ),
        ],
        placements: [
          PlacementDef(name: 'Briarwog', c: 1, r: 7, minPlayers: 4),
          PlacementDef(name: 'Briarwog', c: 9, r: 6),
          PlacementDef(name: 'Briarwog', c: 3, r: 3, minPlayers: 3),
          PlacementDef(name: 'Dekaha', c: 3, r: 6),
          PlacementDef(name: 'Dekaha', c: 8, r: 6, minPlayers: 3),
          PlacementDef(name: 'Dekaha', c: 7, r: 2, minPlayers: 3),
          PlacementDef(name: 'Harrow', c: 6, r: 2),
          PlacementDef(name: 'Harrow', c: 11, r: 5, minPlayers: 4),
          PlacementDef(name: 'Wavecaller', c: 6, r: 1, onSlain: [
            milestone('_victory_with_uzem_alive',
                condition: IsAliveCondition('Tears of Uzem')),
            milestone('_victory_with_uzem_slain',
                condition: IsSlainCondition('Tears of Uzem')),
          ]),
          PlacementDef(name: 'Tears of Uzem', c: 6, r: 4),
          PlacementDef(
              name: 'Bursting Bell',
              type: PlacementType.trap,
              c: 1,
              r: 5,
              trapDamage: 3),
          PlacementDef(
              name: 'Bursting Bell',
              type: PlacementType.trap,
              c: 4,
              r: 9,
              trapDamage: 3),
          PlacementDef(name: 'crux', type: PlacementType.ether, c: 11, r: 3),
          PlacementDef(name: 'water', type: PlacementType.ether, c: 5, r: 2),
          PlacementDef(name: 'water', type: PlacementType.ether, c: 7, r: 8),
        ],
      );

  static EncounterDef get encounter8dot4 => EncounterDef(
        questId: '8',
        number: '4',
        title: 'The Ancient Glimmer Burn',
        setup: EncounterSetup(
            box: '4/8', map: '56', adversary: '96-97', tiles: '6x Wildfire'),
        victoryDescription: 'Slay the Embercaller.',
        roundLimit: 8,
        extraPhase: 'The Uzem',
        extraPhaseIndex: 2,
        baseLystReward: 20,
        campaignLink:
            'Encounter 8.5 - “**Nurse in Wavering Memories**”, [campaign] **126**.',
        challenges: [
          'When a Rover attacks the Embercaller or a Wrathbone, place a [Wildfire] in their space.',
          'Rovers trigger the effects of [Wildfire] when within [Range] 0-1 of a [Wildfire] tile.',
          'While sealed, the Rage of Uzem suffers R+1 [DMG] at the end of each round.',
        ],
        trackerEvents: [
          EncounterTrackerEventDef(
              title:
                  'Mark when Rage of Uzem is unsealed, or add Fire tokens to the Drained Ether below.',
              recordMilestone: '_uzem_unsealed')
        ],
        dialogs: [
          introductionFromText('quest_8_encounter_4_intro'),
        ],
        onLoad: [
          dialog('Introduction'),
          rules('Uzem’s Progeny',
              '''The Rage of Uzem is part of their own faction, the Uzem, which is an ally to the Rover faction and an enemy to the Adversary faction. Though the Uzem faction is an enemy to the adversary faction, all adversaries ignore the Rage of Uzem for now. Units a part of the Uzem faction follow all the adversary logic rules in the rule book. This faction gains priority after the Adversary faction has gone.

The Rage of Uzem is currently sealed by powerful ether and is unable to act. This encounter has a bonus objective that involves the four Drained Ether nodes on the map. These nodes work differently from the other ether nodes you have encountered up to this point. When a Rover is within [Range] 1 of a Drained Ether node, that Rover can spend 1 movement point to place a [Fire] dice from their personal supply onto the node.

If R Drained Ether nodes are turned into [Fire] nodes, the Rage of Uzem is unsealed and acts normally during the Uzem faction phase. Adversaries no longer ignore the Rage of Uzem and will target it as an enemy.'''),
          codexLink('Quenched Rage',
              number: 152,
              body:
                  '''Immediately when the Embercaller is slain, if the Rage of Uzem is still sealed, read [title], [codex] 70.'''),
          codexLink('Rage Unleashed',
              number: 153,
              body:
                  '''Immediately when the Embercaller is slain, if the Rage of Uzem was unsealed and is alive, read [title], [codex] 71.'''),
          codexLink('Smothered Flames',
              number: 154,
              body:
                  '''Immediately when the Embercaller is slain, if the Rage of Uzem was unsealed and slain, read [title], [codex] 71.'''),
        ],
        onMilestone: {
          '_uzem_unsealed': [
            rules('Rage of Uzem Unsealed',
                '''The Rage of Uzem is unsealed and acts normally during the Uzem faction phase. Adversaries no longer ignore the Rage of Uzem and will target it as an enemy.'''),
          ],
          '_victory_with_uzem_unsealed': [
            codex(153),
            victory(),
            milestone(CampaignMilestone.milestone8dot4RageOfUzemUnsealed)
          ],
          '_victory_with_uzem_sealed': [
            codex(152),
            victory(),
            milestone(CampaignMilestone.milestone8dot4RageOfUzemSealed)
          ],
          '_victory_with_uzem_slain': [
            codex(154),
            victory(),
            milestone(CampaignMilestone.milestone8dot4RageOfUzemSlain)
          ],
        },
        startingMap: MapDef(
          id: '8.4',
          columnCount: 13,
          rowCount: 11,
          backgroundRect: Rect.fromLTWH(110.0, 44.0, 1481.0, 1411.0),
          starts: [
            (11, 3),
            (11, 4),
            (11, 5),
            (11, 6),
            (11, 7),
          ],
          terrain: {
            (0, 0): TerrainType.openAir,
            (0, 1): TerrainType.openAir,
            (0, 2): TerrainType.openAir,
            (0, 3): TerrainType.openAir,
            (0, 6): TerrainType.openAir,
            (0, 7): TerrainType.openAir,
            (0, 8): TerrainType.openAir,
            (0, 9): TerrainType.openAir,
            (1, 0): TerrainType.openAir,
            (1, 1): TerrainType.openAir,
            (1, 9): TerrainType.openAir,
            (1, 10): TerrainType.openAir,
            (2, 0): TerrainType.openAir,
            (2, 9): TerrainType.openAir,
            (3, 0): TerrainType.openAir,
            (3, 5): TerrainType.object,
            (3, 10): TerrainType.openAir,
            (6, 2): TerrainType.object,
            (6, 7): TerrainType.object,
            (9, 0): TerrainType.openAir,
            (9, 5): TerrainType.object,
            (9, 10): TerrainType.openAir,
            (10, 0): TerrainType.openAir,
            (10, 9): TerrainType.openAir,
            (11, 0): TerrainType.openAir,
            (11, 1): TerrainType.openAir,
            (11, 8): TerrainType.openAir,
            (11, 9): TerrainType.openAir,
            (11, 10): TerrainType.openAir,
            (12, 0): TerrainType.openAir,
            (12, 1): TerrainType.openAir,
            (12, 2): TerrainType.openAir,
            (12, 3): TerrainType.openAir,
            (12, 6): TerrainType.openAir,
            (12, 7): TerrainType.openAir,
            (12, 8): TerrainType.openAir,
            (12, 9): TerrainType.openAir,
          },
        ),
        overlays: [
          EncounterFigureDef(
              name: 'Drained Fire Ether',
              alias: 'Drained Ether',
              possibleTokens: ['Fire'],
              onTokensChanged: [function('tally_uzem_fire_nodes')])
        ],
        adversaries: [
          EncounterFigureDef(
            name: 'Ashemak',
            letter: 'A',
            standeeCount: 4,
            health: 8,
            immuneToForcedMovement: true,
            traits: [
              '''[React] Before this unit is slain:

All units within [Range] 1 suffer [DMG]3.''',
            ],
            affinities: {
              Ether.fire: 3,
              Ether.water: -2,
              Ether.wind: -1,
            },
          ),
          EncounterFigureDef(
            name: 'Wrathbone',
            letter: 'B',
            standeeCount: 4,
            health: 18,
            traits: [
              '''[React] At the end of the Rover phase:
              
All enemies within [Range] 1-2 suffer [DMG]1. << Enemies within [Range] 1 suffer an additional [DMG]1.''',
            ],
            affinities: {
              Ether.fire: 2,
              Ether.earth: 1,
              Ether.water: -2,
            },
          ),
          EncounterFigureDef(
            name: 'Harrow',
            letter: 'C',
            standeeCount: 3,
            health: 16,
            affinities: {
              Ether.morph: 2,
              Ether.crux: 2,
            },
          ),
          EncounterFigureDef(
            name: 'Embercaller',
            letter: 'D',
            type: AdversaryType.miniboss,
            standeeCount: 3,
            healthFormula: '10*R',
            flies: true,
            traits: [
              '''[React] After enemies attack this unit:

That enemy suffers [DMG]2.''',
            ],
            affinities: {
              Ether.fire: 3,
              Ether.crux: 2,
              Ether.wind: 1,
              Ether.morph: -2,
              Ether.earth: -1,
              Ether.water: -1,
            },
          ),
          EncounterFigureDef(
            name: 'Rage of Uzem',
            letter: 'E',
            faction: 'The Uzem',
            standeeCount: 1,
            health: 18,
            flies: true,
            traits: [
              'This unit is immune to the Embercaller\'s trait.',
            ],
            affinities: {
              Ether.wind: -1,
              Ether.crux: 2,
              Ether.fire: 2,
            },
          ),
        ],
        placements: [
          PlacementDef(name: 'Drained Fire Ether', c: 3, r: 5),
          PlacementDef(name: 'Drained Fire Ether', c: 6, r: 2),
          PlacementDef(name: 'Drained Fire Ether', c: 6, r: 7),
          PlacementDef(name: 'Drained Fire Ether', c: 9, r: 5),
          PlacementDef(name: 'Ashemak', c: 7, r: 7),
          PlacementDef(name: 'Ashemak', c: 5, r: 7, minPlayers: 4),
          PlacementDef(name: 'Ashemak', c: 5, r: 3, minPlayers: 3),
          PlacementDef(name: 'Ashemak', c: 7, r: 3),
          PlacementDef(name: 'Wrathbone', c: 6, r: 8),
          PlacementDef(name: 'Wrathbone', c: 2, r: 4, minPlayers: 4),
          PlacementDef(name: 'Harrow', c: 2, r: 5, minPlayers: 3),
          PlacementDef(name: 'Harrow', c: 8, r: 2),
          PlacementDef(name: 'Embercaller', c: 5, r: 5, onSlain: [
            milestone('_victory_with_uzem_unsealed', conditions: [
              IsAliveCondition('Rage of Uzem'),
              MilestoneCondition('_uzem_unsealed')
            ]),
            milestone('_victory_with_uzem_sealed', conditions: [
              IsAliveCondition('Rage of Uzem'),
              MilestoneCondition('_uzem_unsealed', value: false)
            ]),
            milestone('_victory_with_uzem_slain',
                condition: IsSlainCondition('Rage of Uzem')),
          ]),
          PlacementDef(name: 'Rage of Uzem', c: 1, r: 5),
          PlacementDef(name: 'wildfire', type: PlacementType.field, c: 2, r: 3),
          PlacementDef(name: 'wildfire', type: PlacementType.field, c: 4, r: 7),
          PlacementDef(name: 'wildfire', type: PlacementType.field, c: 8, r: 8),
          PlacementDef(
              name: 'wildfire', type: PlacementType.field, c: 10, r: 6),
          PlacementDef(
              name: 'wildfire', type: PlacementType.field, c: 10, r: 3),
          PlacementDef(name: 'wildfire', type: PlacementType.field, c: 6, r: 1),
        ],
      );

  static EncounterDef get encounter8dot5 => EncounterDef(
        questId: '8',
        number: '5',
        title: 'Nurse in Wavering Memories',
        victoryDescription: 'Harmonize The King of Storms.',
        setup: EncounterSetup(box: '4/8', map: '57', adversary: '98-99'),
        roundLimit: 12,
        terrain: [
          dangerousFire(1),
          etherFire(),
          etherEarth(),
          etherWater(),
          etherWind(),
        ],
        baseLystReward: 30,
        itemRewards: [
          'Uzem\'s Judgment',
        ],
        unlocksTrait: true,
        milestone: CampaignMilestone.milestone8dot5,
        campaignLink: 'Chapter 5 - “**Era Shattered**”, [campaign] **130**.',
        challenges: [
          'Each time a Rover places an ether field in an enemy space, they place the same ether field in their own space.',
          'The King of Storms gains +X [DMG] to all of their attacks, where X equals the number of ether nodes that have been harmonized.',
          'Adversaries will continue to spawn, even when their associated ether node has been harmonized.',
        ],
        dialogs: [
          introductionFromText('quest_8_encounter_5_intro'),
        ],
        onLoad: [
          dialog('Introduction'),
          rules('The King of Storms',
              '''The King of Storms is in pieces and must be put back together. They are living ether enthralled by disharmony, wreaking havoc on the battlefield.

This is a unique battlefield that will ask a lot of you. The King of Storms can not be affected by any Rover faction action for any reason.

There are 4 ether clusters, one for [Fire], [Earth], [Water], and [Wind]. Though these ether clusters still have effects like most other ether nodes, Rovers can not remove the ether dice from these clusters.

In order to reunite The King of Storms, each ether cluster will need to be harmonized. Once these four tasks have been completed, the King of Storms will be brought into harmony.'''),
          rules('[Fire] Ether Cluster',
              '''The [Fire] ether cluster can be targeted with actions by Rovers as if it were an enemy. The cluster needs to suffer R*12 damage to be brought into harmony.''',
              condition: MilestoneCondition(
                  CampaignMilestone.milestone8dot4RageOfUzemUnsealed,
                  value: false)),
          rules(
              '[Fire] Ether Cluster',
              '''The [Fire] ether cluster can be targeted with actions by Rovers as if it were an enemy. The cluster needs to suffer R*12 damage to be brought into harmony.
Rage of Uzem Unsealed: Rovers gain +1 [DMG] to all of their attacks targeting the [Fire] ether cluster.''',
              condition: MilestoneCondition(
                  CampaignMilestone.milestone8dot4RageOfUzemUnsealed)),
          rules('[Earth] Ether Cluster',
              '''The [Earth] ether cluster can be targeted with actions by Rovers as if it were an ally. The cluster needs to recover R*6 damage to be brought into harmony.'''),
          rules('[Water] Ether Cluster',
              '''The [Water] ether cluster needs Rovers to fight against the current. Rovers must enter into R*2 spaces within [Range] 1 of the cluster to bring it into harmony.''',
              condition: MilestoneCondition(
                  CampaignMilestone.milestone8dot3TearsOfUzemLives,
                  value: false)),
          rules(
              '[Water] Ether Cluster',
              '''The [Water] ether cluster needs Rovers to fight against the current. Rovers must enter into R*2 spaces within [Range] 1 of the cluster to bring it into harmony.

Tears of Uzem Lives: Rovers gain +1 movement point to all of their movement actions that begin within [Range] 1 of the [Water] ether cluster.''',
              condition: MilestoneCondition(
                  CampaignMilestone.milestone8dot3TearsOfUzemLives)),
          rules('[Wind] Ether Cluster',
              '''The [Wind] ether cluster needs Rovers to prevent R*6 damage while within [Range] 1 of the cluster to be brought into harmony.''',
              condition: MilestoneCondition(
                  CampaignMilestone.milestone8dot1BreathOfUzemLives,
                  value: false)),
          rules(
              '[Wind] Ether Cluster',
              '''The [Wind] ether cluster needs Rovers to prevent R*6 damage while within [Range] 1 of the cluster to be brought into harmony.

Breath of Uzem Lives: Rovers gain +1 [DEF] while they are within [Range] 1 of the [Wind] ether cluster.''',
              condition: MilestoneCondition(
                  CampaignMilestone.milestone8dot1BreathOfUzemLives)),
          rules('Elemental Adversaries',
              '''Adversaries are associated to an ether cluster; ashemaks to the [Fire] cluster, bulwarous to the [Earth] cluster, briarwog to the [Water] cluster, and galeapers to the [Wind] cluster.

When an adversary is slain, place it off to the side of the map on its side. During the start phase, for each adversary that is off to the side, flipped vertically, and their associated ether cluster has not been harmonized, spawn that adversary at [Range] 2 from their ether cluster, closest to the nearest Rover. Then, for each adversary that is both off to the side and placed on its side, flip them vertically.'''),
          codexLink('Equipoise Regent',
              number: 155,
              body:
                  '''Immediately when The King of Storms has been harmonized, read [title], [codex] 73.'''),
        ],
        onMilestone: {
          '_victory': [
            codex(155),
            victory(),
            codex(156),
          ]
        },
        startingMap: MapDef(
          id: '8.5',
          columnCount: 13,
          rowCount: 11,
          backgroundRect: Rect.fromLTWH(110.0, 44.0, 1481.0, 1411.0),
          starts: [
            (0, 5),
            (6, 0),
            (6, 9),
            (12, 4),
          ],
          terrain: {
            (0, 0): TerrainType.barrier,
            (0, 1): TerrainType.barrier,
            (0, 8): TerrainType.barrier,
            (0, 9): TerrainType.barrier,
            (1, 0): TerrainType.barrier,
            (1, 1): TerrainType.barrier,
            (1, 4): TerrainType.object,
            (1, 7): TerrainType.dangerous,
            (1, 9): TerrainType.barrier,
            (1, 10): TerrainType.barrier,
            (2, 0): TerrainType.barrier,
            (2, 1): TerrainType.object,
            (2, 8): TerrainType.dangerous,
            (2, 9): TerrainType.barrier,
            (3, 0): TerrainType.barrier,
            (3, 2): TerrainType.object,
            (3, 8): TerrainType.object,
            (3, 10): TerrainType.barrier,
            (5, 2): TerrainType.object,
            (5, 9): TerrainType.dangerous,
            (7, 2): TerrainType.openAir,
            (7, 9): TerrainType.difficult,
            (9, 0): TerrainType.barrier,
            (9, 1): TerrainType.openAir,
            (9, 2): TerrainType.object,
            (9, 3): TerrainType.openAir,
            (9, 6): TerrainType.difficult,
            (9, 8): TerrainType.object,
            (9, 10): TerrainType.barrier,
            (10, 0): TerrainType.barrier,
            (10, 9): TerrainType.barrier,
            (11, 0): TerrainType.barrier,
            (11, 1): TerrainType.barrier,
            (11, 7): TerrainType.difficult,
            (11, 9): TerrainType.barrier,
            (11, 10): TerrainType.barrier,
            (12, 0): TerrainType.barrier,
            (12, 1): TerrainType.barrier,
            (12, 8): TerrainType.barrier,
            (12, 9): TerrainType.barrier,
          },
        ),
        overlays: [
          EncounterFigureDef(
            name: 'Fire Cluster',
            alias: '[Fire] Ether Cluster',
            healthFormula: '12*R',
            traits: [
              'The [Fire] ether cluster can be targeted with actions by Rovers as if it were an enemy. The cluster needs to suffer R*12 damage to be brought into harmony.'
            ],
            onSlain: [
              subtitle('+ [Fire]'),
              milestone('_fire_harmonized'),
              milestone(
                '_victory',
                conditions: [
                  MilestoneCondition('_fire_harmonized'),
                  MilestoneCondition('_earth_harmonized'),
                  MilestoneCondition('_water_harmonized'),
                  MilestoneCondition('_wind_harmonized'),
                ],
              ),
            ],
          ),
          EncounterFigureDef(
            name: 'Earth Cluster',
            alias: '[Ether] Ether Cluster',
            healthFormula: '6*R',
            traits: [
              'The [Earth] ether cluster can be targeted with actions by Rovers as if it were an ally. The cluster needs to recover R*6 damage to be brought into harmony. To track this, decrease its health for each recovered health point.'
            ],
            onSlain: [
              subtitle('+ [Earth]'),
              milestone('_earth_harmonized'),
              milestone(
                '_victory',
                conditions: [
                  MilestoneCondition('_fire_harmonized'),
                  MilestoneCondition('_earth_harmonized'),
                  MilestoneCondition('_water_harmonized'),
                  MilestoneCondition('_wind_harmonized'),
                ],
              ),
            ],
          ),
          EncounterFigureDef(
            name: 'Water Cluster',
            alias: '[Water] Ether Cluster',
            healthFormula: '2*R',
            traits: [
              'The [Water] ether cluster needs Rovers to fight against the current. Rovers must enter into R*2 spaces within [Range] 1 of the cluster to bring it into harmony. To track this, decrease its health for each eligible space entered.'
            ],
            onSlain: [
              subtitle('+ [Water]'),
              milestone('_water_harmonized'),
              milestone(
                '_victory',
                conditions: [
                  MilestoneCondition('_fire_harmonized'),
                  MilestoneCondition('_earth_harmonized'),
                  MilestoneCondition('_water_harmonized'),
                  MilestoneCondition('_wind_harmonized'),
                ],
              ),
            ],
          ),
          EncounterFigureDef(
            name: 'Wind Cluster',
            alias: '[Wind] Ether Cluster',
            healthFormula: '6*R',
            traits: [
              'The [Wind] ether cluster needs Rovers to prevent R*6 damage while within [Range] 1 of the cluster to be brought into harmony. To track this, decrease its health for each eligible damage point prevented.'
            ],
            onSlain: [
              subtitle('+ [Wind]'),
              milestone('_wind_harmonized'),
              milestone(
                '_victory',
                conditions: [
                  MilestoneCondition('_fire_harmonized'),
                  MilestoneCondition('_earth_harmonized'),
                  MilestoneCondition('_water_harmonized'),
                  MilestoneCondition('_wind_harmonized'),
                ],
              ),
            ],
          ),
        ],
        adversaries: [
          EncounterFigureDef(
            name: 'Ashemak',
            letter: 'A',
            standeeCount: 4,
            health: 8,
            immuneToForcedMovement: true,
            respawns: true,
            respawnCondition: IsAliveCondition('Fire Cluster'),
            traits: [
              '''[React] Before this unit is slain:
              
All units within [Range] 1 suffer [DMG]3.''',
            ],
            affinities: {
              Ether.fire: 3,
              Ether.wind: -1,
              Ether.water: -2,
            },
          ),
          EncounterFigureDef(
            name: 'Bulwauros',
            letter: 'B',
            standeeCount: 3,
            health: 8,
            defense: 3,
            respawns: true,
            respawnCondition: IsAliveCondition('Earth Cluster'),
            traits: [
              'If this unit is damaged, reduce its [DEF] by 3. ',
            ],
            affinities: {
              Ether.earth: 2,
              Ether.wind: -1,
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
            name: 'Briarwog',
            letter: 'C',
            standeeCount: 3,
            health: 10,
            respawns: true,
            respawnCondition: IsAliveCondition('Water Cluster'),
            traits: [
              '''[React] After this unit is attacked from within [Range] 1:
              
The attacker suffers [DMG]1.''',
            ],
            affinities: {
              Ether.water: 2,
              Ether.morph: 1,
              Ether.earth: -1,
              Ether.fire: -1,
            },
          ),
          EncounterFigureDef(
            name: 'Galeaper',
            letter: 'D',
            standeeCount: 5,
            health: 7,
            flies: true,
            respawns: true,
            respawnCondition: IsAliveCondition('Wind Cluster'),
            affinities: {
              Ether.fire: -1,
              Ether.earth: -1,
              Ether.wind: 2,
              Ether.morph: 1,
            },
          ),
          EncounterFigureDef(
            name: 'The King of Storms',
            letter: 'E',
            type: AdversaryType.boss,
            standeeCount: 1,
            immuneToForcedMovement: true,
            immuneToTeleport: true,
            large: true,
            affinities: {
              Ether.crux: 3,
              Ether.earth: 1,
              Ether.fire: 1,
              Ether.water: 1,
              Ether.wind: 1,
            },
          ),
        ],
        placements: const [
          PlacementDef(name: 'Ashemak', c: 6, r: 6, minPlayers: 3),
          PlacementDef(name: 'Ashemak', c: 4, r: 5),
          PlacementDef(name: 'Ashemak', c: 2, r: 6, minPlayers: 4),
          PlacementDef(name: 'Bulwauros', c: 3, r: 1),
          PlacementDef(name: 'Bulwauros', c: 2, r: 3, minPlayers: 3),
          PlacementDef(name: 'Bulwauros', c: 4, r: 2, minPlayers: 4),
          PlacementDef(name: 'Briarwog', c: 10, r: 8, minPlayers: 4),
          PlacementDef(name: 'Briarwog', c: 11, r: 7),
          PlacementDef(name: 'Briarwog', c: 9, r: 6, minPlayers: 3),
          PlacementDef(name: 'Galeaper', c: 9, r: 1, minPlayers: 3),
          PlacementDef(name: 'Galeaper', c: 7, r: 2, minPlayers: 4),
          PlacementDef(name: 'Galeaper', c: 9, r: 3),
          PlacementDef(name: 'The King of Storms', c: 6, r: 5),
          PlacementDef(
              name: 'Earth Cluster', type: PlacementType.object, c: 3, r: 2),
          PlacementDef(
              name: 'Fire Cluster', type: PlacementType.object, c: 3, r: 8),
          PlacementDef(
              name: 'Water Cluster', type: PlacementType.object, c: 9, r: 8),
          PlacementDef(
              name: 'Wind Cluster', type: PlacementType.object, c: 9, r: 2),
        ],
      );
}
