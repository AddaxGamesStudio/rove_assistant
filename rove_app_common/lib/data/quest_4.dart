import 'dart:ui';
import 'package:rove_data_types/rove_data_types.dart';
import 'package:rove_app_common/data/encounter_def_utils.dart';

extension Quest4 on EncounterDef {
  static EncounterDef get encounter4dot1 => EncounterDef(
        questId: '4',
        number: '1',
        title: 'The Clouds Roll On',
        victoryDescription: 'Slay Uzem\'s Anxiety.',
        roundLimit: 8,
        baseLystReward: 20,
        campaignLink:
            '''Encounter 4.2 - “**Earth, Food, Raiment**”, [campaign] **58**.''',
        challenges: [
          'During the end phase of each round, Uzem\'s Anxiety performs: [NEG] | [Push] 1 | [Target] all << Treat the push as coming from the nearest ether cluster.',
          'After Uzem\'s Anxiety spawns, treat all other adversaries as occupying a [windscreen]. This is a permanent effect.',
          'Replace the end phase effect from the The Screaming Storm special rule with: [r_attack] | [Range] 1-3 | [DMG]3 | [pierce] | [Push] 2 | [Target] all',
        ],
        trackerEvents: [
          EncounterTrackerEventDef(
              title:
                  'Mark when all Rovers are adjacent to the [Crux] node cluster right before the end of the round.',
              recordMilestone: '_crux_cluster'),
          EncounterTrackerEventDef(
              title:
                  'Mark when all Rovers are adjacent to the [Wind] node cluster right before the end of the round.',
              recordMilestone: '_wind_cluster')
        ],
        onLoad: [
          rules('Quiet the Storm',
              '''*Potent ether threatens to exacerbate the raging storm buffeting the ridge line.* 
              
You need to draw the ether from the crystal to dispel it. There is a [Wind] ether node cluster and a [Crux] ether node cluster. All Rovers must end the round adjacent to one of these clusters to summon Uzem's Anxiety.'''),
          codexLink('The Fearless Flight',
              number: 75,
              body:
                  '''The first time a streak is slain, read [title] [codex] 38.'''),
          codexLink('Perfectly Heartless',
              number: 76,
              body: '''If an urn is slain, read [title] [codex] 38.'''),
          codexLink('With A Bitter Look',
              number: 77,
              body:
                  '''During the end phase, if all Rovers are adjacent to the [wind] ether node cluster or the [crux] ether node cluster, read [title] [codex] 38.'''),
        ],
        onMilestone: {
          '_screaming_storm_crux': [
            codex('With A Bitter Look', page: 38),
            placementGroup('With A Bitter Look',
                title: 'The Screaming Storm',
                body:
                    '''Spawn Uzem's Anxiety on the [Wind] ether node closest to the Rovers.'''),
            rules('The Screaming Storm',
                '''During the end phase of each round, Uzem's Anxiety performs:

[r_attack] | [DMG]3 | [pierce] | [Target] the enemy furthest away'''),
            codexLink('A Sunless Garden',
                number: 78,
                body:
                    '''Immediately when Uzem’s Anxiety is slain, read [title], [codex] 39.'''),
          ],
          '_screaming_storm_wind': [
            codex('With A Bitter Look', page: 38),
            placementGroup('With A Bitter Look',
                title: 'The Screaming Storm',
                body:
                    '''Spawn Uzem's Anxiety on the [Crux] ether node closest to the Rovers.'''),
            rules('The Screaming Storm',
                '''During the end phase of each round, Uzem's Anxiety performs:

[m_attack] | [Range] 1-3 | [DMG]1 | [Push] 2 | [Target] all'''),
            codexLink('A Sunless Garden',
                number: 78,
                body:
                    '''Immediately when Uzem’s Anxiety is slain, read [title], [codex] 39.'''),
          ]
        },
        onWillEndRound: [
          milestone('_screaming_storm_crux',
              condition: MilestoneCondition('_crux_cluster')),
          milestone('_screaming_storm_wind',
              condition: MilestoneCondition('_wind_cluster')),
        ],
        startingMap: MapDef(
          id: '4.1',
          columnCount: 13,
          rowCount: 11,
          backgroundRect: Rect.fromLTWH(110.0, 44.0, 1481.0, 1411.0),
          terrain: {
            (0, 2): TerrainType.start,
            (0, 3): TerrainType.start,
            (0, 4): TerrainType.start,
            (0, 5): TerrainType.start,
            (0, 6): TerrainType.start,
            (0, 7): TerrainType.start,
            (3, 3): TerrainType.dangerous,
            (5, 7): TerrainType.dangerous,
            (7, 4): TerrainType.dangerous,
            (8, 1): TerrainType.object,
            (8, 2): TerrainType.object,
            (8, 8): TerrainType.object,
            (9, 2): TerrainType.object,
            (9, 5): TerrainType.openAir,
            (9, 8): TerrainType.object,
            (9, 9): TerrainType.object,
            (10, 4): TerrainType.openAir,
            (10, 5): TerrainType.openAir,
            (10, 6): TerrainType.openAir,
            (11, 0): TerrainType.openAir,
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
            name: 'Galeaper',
            letter: 'A',
            health: 6,
            flies: true,
            affinities: {
              Ether.earth: -2,
              Ether.fire: -1,
              Ether.morph: 1,
              Ether.wind: 2,
            },
          ),
          EncounterFigureDef(
            name: 'Streak',
            letter: 'B',
            health: 6,
            flies: true,
            affinities: {
              Ether.earth: -2,
              Ether.wind: 1,
              Ether.crux: 1,
            },
            onSlain: [
              codex('The Fearless Flight', page: 38),
            ],
          ),
          EncounterFigureDef(
            name: 'Urn',
            letter: 'C',
            healthFormula: '3*R',
            defense: 2,
            affinities: {
              Ether.wind: 1,
              Ether.earth: 1,
              Ether.fire: 1,
              Ether.water: 1,
            },
            onSlain: [
              codex('Perfectly Heartless', page: 38),
              lyst('5*R'),
              item('Arcana Pigment',
                  body:
                      'The Rover that slayed the urn gains one “Arcana Pigment” item. They may equip this item. If they don’t have the required item slot(s) available, they may unequip items as needed.'),
            ],
          ),
          EncounterFigureDef(
              name: 'Uzem\'s Anxiety',
              letter: 'D',
              type: AdversaryType.miniboss,
              healthFormula: '10*R',
              flies: true,
              affinities: {
                Ether.fire: -1,
                Ether.morph: -1,
                Ether.wind: 2,
                Ether.crux: 2,
              },
              traits: [
                'This unit gains [DEF] 2 against ranged attacks targeting it.'
              ],
              onSlain: [
                codex('A Sunless Garden', page: 39),
                victory(),
              ]),
        ],
        placements: const [
          PlacementDef(name: 'Urn', c: 11, r: 1),
          PlacementDef(name: 'Streak', c: 5, r: 0, minPlayers: 4),
          PlacementDef(name: 'Streak', c: 6, r: 0),
          PlacementDef(name: 'Streak', c: 8, r: 0, minPlayers: 4),
          PlacementDef(name: 'Streak', c: 8, r: 6),
          PlacementDef(name: 'Streak', c: 5, r: 9),
          PlacementDef(name: 'Streak', c: 7, r: 10, minPlayers: 4),
          PlacementDef(name: 'Galeaper', c: 7, r: 2),
          PlacementDef(name: 'Galeaper', c: 9, r: 4),
          PlacementDef(name: 'Galeaper', c: 6, r: 3, minPlayers: 3),
          PlacementDef(name: 'Galeaper', c: 6, r: 6),
          PlacementDef(name: 'Galeaper', c: 7, r: 8, minPlayers: 3),
          PlacementDef(name: 'Streak', c: 10, r: 5, minPlayers: 4),
          PlacementDef(name: 'Urn', c: 11, r: 10),
          PlacementDef(name: 'wind', type: PlacementType.ether, c: 8, r: 2),
          PlacementDef(name: 'wind', type: PlacementType.ether, c: 8, r: 1),
          PlacementDef(name: 'wind', type: PlacementType.ether, c: 9, r: 2),
          PlacementDef(name: 'crux', type: PlacementType.ether, c: 8, r: 8),
          PlacementDef(name: 'crux', type: PlacementType.ether, c: 9, r: 9),
          PlacementDef(name: 'crux', type: PlacementType.ether, c: 9, r: 8),
        ],
        placementGroups: [
          PlacementGroupDef(
              name: 'With A Bitter Look',
              placements: [PlacementDef(name: 'Uzem\'s Anxiety')])
        ],
      );

  static EncounterDef get encounter4dot2 => EncounterDef(
        questId: '4',
        number: '2',
        title: 'Earth, Food, Raiment',
        victoryDescription: 'Slay Uzem\'s Endurance.',
        roundLimit: 8,
        baseLystReward: 15,
        itemRewards: ['Thundering Hikers'],
        campaignLink:
            '''Encounter 4.3 - “**Power of Disseminating**”, [campaign] **60**.''',
        challenges: [
          'While a Rover carries the Dowsing Spear, all of their movement actions are reduced by 2 instead.',
          'When Uzem\'s Endurance spawns, it spawns in the vine space furthest from the most Rovers instead.',
          'After Uzem\'s Endurance spawns, treat all other adversaries as occupying an [everbloom]. This is a permanent effect.',
        ],
        playerPossibleTokens: ['Hoard'],
        trackerEvents: [
          EncounterTrackerEventDef(
              title:
                  'Mark when the Rover that is carrying the Dowsing Spear is within [Range] 1 of the [Earth] ether node cluster right before the end of the round.',
              recordMilestone: '_earth_cluster')
        ],
        onLoad: [
          rules('Settle the Earth',
              '''*Uzem's Endurance is hidden somewhere beneath the fulgurcaps.* You need to draw Uzem's Endurance from out of the ground to defeat it. To do this, you must bring the Dowsing Spear within [Range] 1 of the [Earth] ether node cluster.

At the beginning of the encounter, decide which Rover will carry the Dowsing Spear, represented by a hoard tile on that Rover’s class board. While a Rover carries the Dowsing Spear, all of their movement actions are reduced by 1 and their [Jump] actions become [Dash] actions, and they gain the following ability:

**Throw Dowsing Spear**: Select one Rover within [Range] 1-3 and place the Dowsing Spear on their class board.

Note: **Throw Dowsing Spear** is an ability, so it requires an ability activation to use.'''),
          codexLink('If Only One Hides It',
              number: 79,
              body: '''If the haunt is slain, read [title] [codex] 40.'''),
          codexLink('With The Grasses Waving',
              number: 80,
              body:
                  '''At the end of the round, if the Rover that is carrying the Dowsing Spear is within 1 of the earth ether node cluster, read [title] [codex] 40.'''),
        ],
        onWillEndRound: [
          milestone('_uzems_endurance',
              condition: MilestoneCondition('_earth_cluster')),
        ],
        onMilestone: {
          '_uzems_endurance': [
            codex('With The Grasses Waving', page: 40),
            placementGroup('Uzem\'s Endurance',
                title: 'Uzem\'s Endurance',
                body:
                    '''Spawn Uzem's Endurance on the [Earth] ether node closest to the nearest Rover.'''),
            codexLink('By Each Let This Be Heard',
                number: 81,
                body:
                    '''Immediately when Uzem’s Endurance is slain, read [title], [codex] 40.'''),
          ]
        },
        startingMap: MapDef(
          id: '4.2',
          columnCount: 13,
          rowCount: 11,
          backgroundRect: Rect.fromLTWH(110.0, 44.0, 1481.0, 1411.0),
          terrain: {
            (0, 2): TerrainType.openAir,
            (0, 3): TerrainType.openAir,
            (0, 4): TerrainType.openAir,
            (0, 5): TerrainType.openAir,
            (0, 6): TerrainType.openAir,
            (0, 8): TerrainType.start,
            (0, 9): TerrainType.start,
            (1, 2): TerrainType.openAir,
            (1, 3): TerrainType.openAir,
            (1, 4): TerrainType.openAir,
            (1, 5): TerrainType.openAir,
            (1, 6): TerrainType.openAir,
            (1, 9): TerrainType.start,
            (1, 10): TerrainType.start,
            (2, 1): TerrainType.openAir,
            (2, 2): TerrainType.openAir,
            (2, 6): TerrainType.difficult,
            (2, 9): TerrainType.start,
            (3, 0): TerrainType.openAir,
            (3, 1): TerrainType.openAir,
            (3, 2): TerrainType.openAir,
            (3, 7): TerrainType.openAir,
            (3, 10): TerrainType.start,
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
            name: 'Onisski',
            letter: 'A',
            ignoresDifficultTerrain: true,
            health: 8,
            affinities: {
              Ether.morph: -2,
              Ether.water: 1,
              Ether.crux: 1,
            },
          ),
          EncounterFigureDef(
            name: 'Terranape',
            letter: 'B',
            health: 18,
            traits: ['At the start of this unit\'s turn, it recovers [RCV] R.'],
            affinities: {
              Ether.fire: -2,
              Ether.wind: -1,
              Ether.morph: 1,
              Ether.earth: 2,
              Ether.water: 2,
            },
          ),
          EncounterFigureDef(
            name: 'Haunt',
            letter: 'C',
            healthFormula: '3*R',
            affinities: {
              Ether.morph: -2,
              Ether.crux: 2,
            },
            onSlain: [
              codex('If Only One Hides It', page: 40),
              item('Multifaceted Icon',
                  body:
                      'The Rover that slayed the haunt gains one “Multifaceted Icon” item. They may equip this item. If they don’t have the required item slot(s) available, they may unequip items as needed.'),
            ],
          ),
          EncounterFigureDef(
            name: 'Uzem\'s Endurance',
            letter: 'D',
            type: AdversaryType.miniboss,
            healthFormula: '12*R',
            entersObjectSpaces: true,
            affinities: {
              Ether.morph: -1,
              Ether.wind: -1,
              Ether.crux: 2,
              Ether.earth: 2,
            },
            onSlain: [
              codex('By Each Let This Be Heard', page: 40),
              victory(),
            ],
          ),
        ],
        placements: const [
          PlacementDef(name: 'Onisski', c: 3, r: 5),
          PlacementDef(name: 'Onisski', c: 7, r: 5, minPlayers: 3),
          PlacementDef(name: 'Onisski', c: 4, r: 3),
          PlacementDef(name: 'Onisski', c: 5, r: 6),
          PlacementDef(name: 'Terranape', c: 12, r: 2),
          PlacementDef(name: 'Terranape', c: 6, r: 3, minPlayers: 4),
          PlacementDef(name: 'Haunt', c: 9, r: 5),
          PlacementDef(name: 'earth', type: PlacementType.ether, c: 11, r: 5),
          PlacementDef(name: 'earth', type: PlacementType.ether, c: 12, r: 4),
          PlacementDef(name: 'earth', type: PlacementType.ether, c: 12, r: 5),
          PlacementDef(name: 'crux', type: PlacementType.ether, c: 4, r: 4),
        ],
        placementGroups: [
          PlacementGroupDef(
              name: 'Uzem\'s Endurance',
              placements: [PlacementDef(name: 'Uzem\'s Endurance')])
        ],
      );

  static EncounterDef get encounter4dot3 => EncounterDef(
        questId: '4',
        number: '3',
        title: 'Power of Disseminating',
        victoryDescription: 'Slay Uzem\'s Woe.',
        roundLimit: 7,
        baseLystReward: 15,
        itemRewards: [
          'Gallant Crown',
        ],
        unlocksRoverLevel: 5,
        campaignLink:
            '''Encounter 4.4 - “**That Uneasy, Dissatisfied Feeling**”, [campaign] **62**.''',
        challenges: [
          'During “Seat of Storms” Ascension, set the Round Limit to 3.',
          'Increase the damage Rovers suffer from Raging Rapids by +1 [DMG].',
          'After Uzem\'s Woe spawns, treat all Rovers as occupying a [snapfrost]. This is a permanent effect.',
        ],
        trackerEvents: [
          EncounterTrackerEventDef(
              title: 'Mark when all Rovers occupy an [exit] space.',
              recordMilestone: '_ascension')
        ],
        onLoad: [
          rules('Tame the Rapids',
              '''*Uzem's Woe is trying to wash you away with a deluge and keep you from the inner sanctum of the “Seat of Storms”.*  All Rovers must make it to an [exit] space in order to ascend the “Seat of Storms” and fight Uzem's Woe.'''),
          rules('Raging Rapids',
              '''*Uzem's Woe is trying to wash you from the tree.*  While climbing the tree, Uzem's Woe assails you. At the end of each round it performs:

[NEG] | [Push] 2 | [Target] all enemies | << Treat the push as coming from the nearest [exit] space. << All enemies pushed at least 1 space suffer [DMG]1.'''),
          rules('Special Supply',
              '''For this encounter, all Rovers gain the following ability:

**Enchanted Rope**: [POS] | [Pull] 2 | [Range] 2-3 | [Target] Stump | << Pulling yourself toward the target stump.

Note: **Enchanted Rope** is an ability, so it requires an ability activation to use.'''),
          codexLink('With Many Tears',
              number: 82,
              body:
                  '''When all Rovers occupy an [exit] space, the round immediately ends, then read [title] [codex] 41.'''),
        ],
        onMilestone: {
          '_ascension': [
            removeRule('Tame the Rapids'),
            removeRule('Raging Rapids'),
            removeRule('Special Supply'),
            codex('With Many Tears', page: 41),
            placementGroup('Ascension', silent: true),
            rules('“Seat of Storms” Ascension',
                '''Proceed to page 29 of the map book.

Place Rovers in [start] spaces and spawn adversaries according to Rover count as shown on the map. Rover [HP], ether dice, and infusion dice carry over. Glyphs and summons carry over and are placed within [Range] 1 of their owner.'''),
            resetRound(
                newLimit: 4,
                body:
                    'The round limit has been reset. You have 4 rounds to complete the next floor.'),
            codexLink('The Play Is Badly Cast',
                number: 83,
                body:
                    '''Immediately when Uzem’s Woe is slain, read [title] [codex] 41.'''),
          ],
        },
        startingMap: MapDef(
          id: '4.3.1',
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
          exits: [
            (3, 0),
            (5, 0),
            (7, 0),
            (9, 0),
          ],
          terrain: {
            (0, 0): TerrainType.openAir,
            (0, 1): TerrainType.openAir,
            (0, 2): TerrainType.openAir,
            (0, 3): TerrainType.openAir,
            (0, 5): TerrainType.openAir,
            (0, 6): TerrainType.openAir,
            (0, 7): TerrainType.openAir,
            (0, 8): TerrainType.openAir,
            (0, 9): TerrainType.openAir,
            (1, 0): TerrainType.openAir,
            (1, 1): TerrainType.openAir,
            (1, 2): TerrainType.openAir,
            (1, 3): TerrainType.openAir,
            (1, 4): TerrainType.openAir,
            (1, 6): TerrainType.openAir,
            (1, 7): TerrainType.openAir,
            (1, 8): TerrainType.openAir,
            (1, 9): TerrainType.openAir,
            (2, 0): TerrainType.openAir,
            (2, 1): TerrainType.openAir,
            (2, 2): TerrainType.openAir,
            (2, 3): TerrainType.openAir,
            (2, 4): TerrainType.openAir,
            (2, 6): TerrainType.openAir,
            (2, 7): TerrainType.openAir,
            (2, 8): TerrainType.openAir,
            (3, 0): TerrainType.difficult,
            (3, 1): TerrainType.difficult,
            (3, 2): TerrainType.difficult,
            (3, 5): TerrainType.object,
            (3, 10): TerrainType.difficult,
            (4, 2): TerrainType.difficult,
            (4, 3): TerrainType.difficult,
            (4, 7): TerrainType.difficult,
            (4, 8): TerrainType.difficult,
            (4, 9): TerrainType.difficult,
            (5, 4): TerrainType.difficult,
            (5, 7): TerrainType.difficult,
            (5, 8): TerrainType.object,
            (6, 3): TerrainType.object,
            (6, 4): TerrainType.difficult,
            (6, 5): TerrainType.difficult,
            (6, 6): TerrainType.difficult,
            (6, 7): TerrainType.difficult,
            (6, 8): TerrainType.difficult,
            (6, 9): TerrainType.difficult,
            (7, 0): TerrainType.difficult,
            (7, 1): TerrainType.difficult,
            (7, 4): TerrainType.difficult,
            (8, 1): TerrainType.difficult,
            (8, 2): TerrainType.difficult,
            (8, 3): TerrainType.difficult,
            (8, 8): TerrainType.object,
            (9, 0): TerrainType.difficult,
            (9, 1): TerrainType.difficult,
            (9, 4): TerrainType.difficult,
            (9, 5): TerrainType.difficult,
            (9, 6): TerrainType.difficult,
            (9, 7): TerrainType.difficult,
            (10, 1): TerrainType.openAir,
            (10, 2): TerrainType.openAir,
            (10, 3): TerrainType.object,
            (10, 5): TerrainType.openAir,
            (10, 6): TerrainType.openAir,
            (10, 7): TerrainType.openAir,
            (10, 8): TerrainType.openAir,
            (11, 1): TerrainType.openAir,
            (11, 2): TerrainType.openAir,
            (11, 3): TerrainType.openAir,
            (11, 5): TerrainType.openAir,
            (11, 6): TerrainType.openAir,
            (11, 7): TerrainType.openAir,
            (11, 8): TerrainType.openAir,
            (11, 9): TerrainType.openAir,
            (12, 0): TerrainType.openAir,
            (12, 1): TerrainType.openAir,
            (12, 2): TerrainType.openAir,
            (12, 3): TerrainType.openAir,
            (12, 5): TerrainType.openAir,
            (12, 6): TerrainType.openAir,
            (12, 7): TerrainType.openAir,
            (12, 8): TerrainType.openAir,
            (12, 9): TerrainType.openAir,
          },
        ),
        adversaries: [
          EncounterFigureDef(
            name: 'Dekaha',
            letter: 'A',
            health: 7,
            immuneToForcedMovement: true,
            affinities: {
              Ether.fire: -2,
              Ether.wind: -1,
              Ether.earth: 1,
              Ether.water: 2,
            },
          ),
          EncounterFigureDef(
            name: 'Grovetender',
            letter: 'B',
            health: 12,
            defense: 1,
            traits: [
              'If a Rover slays this unit, that Rover [plus_water_earth].'
            ],
            affinities: {
              Ether.fire: -1,
              Ether.earth: 1,
              Ether.water: 2,
            },
            onSlain: [
              ether([Ether.water, Ether.earth]),
            ],
          ),
          EncounterFigureDef(
              name: 'Uzem\'s Woe',
              letter: 'C',
              type: AdversaryType.miniboss,
              healthFormula: '12*R',
              flies: true,
              traits: [
                'Ignores the effects of [snapfrost].'
              ],
              affinities: {
                Ether.crux: 2,
                Ether.water: 2,
                Ether.morph: -1,
                Ether.fire: -1,
              },
              onSlain: [
                codex('The Play Is Badly Cast', page: 41),
                victory(),
              ]),
        ],
        placements: const [
          PlacementDef(name: 'Dekaha', c: 2, r: 5),
          PlacementDef(name: 'Dekaha', c: 7, r: 6),
          PlacementDef(name: 'Dekaha', c: 8, r: 4),
          PlacementDef(name: 'Dekaha', c: 9, r: 3, minPlayers: 3),
          PlacementDef(name: 'Dekaha', c: 3, r: 3, minPlayers: 3),
          PlacementDef(name: 'Dekaha', c: 4, r: 0, minPlayers: 4),
          PlacementDef(name: 'Dekaha', c: 6, r: 0),
          PlacementDef(name: 'Grovetender', c: 4, r: 5),
          PlacementDef(name: 'Grovetender', c: 7, r: 2),
          PlacementDef(name: 'Grovetender', c: 4, r: 2, minPlayers: 4),
          PlacementDef(name: 'Grovetender', c: 6, r: 4, minPlayers: 3),
          PlacementDef(name: 'Dekaha', c: 9, r: 6, minPlayers: 4),
          PlacementDef(
              name: 'Bursting Bell',
              type: PlacementType.trap,
              c: 5,
              r: 2,
              trapDamage: 3),
          PlacementDef(
              name: 'Bursting Bell',
              type: PlacementType.trap,
              c: 10,
              r: 4,
              trapDamage: 3),
          PlacementDef(name: 'crux', type: PlacementType.ether, c: 6, r: 3),
          PlacementDef(name: 'crux', type: PlacementType.ether, c: 5, r: 8),
        ],
        placementGroups: [
          PlacementGroupDef(
            name: 'Ascension',
            map: MapDef(
              id: '4.3.2',
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
                (0, 8): TerrainType.openAir,
                (0, 9): TerrainType.openAir,
                (1, 0): TerrainType.barrier,
                (1, 9): TerrainType.openAir,
                (1, 10): TerrainType.openAir,
                (2, 0): TerrainType.barrier,
                (2, 9): TerrainType.openAir,
                (3, 0): TerrainType.barrier,
                (3, 10): TerrainType.openAir,
                (4, 0): TerrainType.barrier,
                (5, 0): TerrainType.barrier,
                (5, 1): TerrainType.barrier,
                (5, 5): TerrainType.difficult,
                (5, 10): TerrainType.difficult,
                (6, 0): TerrainType.barrier,
                (6, 4): TerrainType.object,
                (6, 5): TerrainType.difficult,
                (6, 6): TerrainType.difficult,
                (6, 7): TerrainType.difficult,
                (6, 8): TerrainType.difficult,
                (6, 9): TerrainType.difficult,
                (7, 0): TerrainType.barrier,
                (7, 1): TerrainType.barrier,
                (7, 4): TerrainType.object,
                (7, 5): TerrainType.object,
                (7, 6): TerrainType.difficult,
                (7, 7): TerrainType.difficult,
                (7, 8): TerrainType.difficult,
                (7, 9): TerrainType.difficult,
                (7, 10): TerrainType.difficult,
                (8, 0): TerrainType.barrier,
                (8, 5): TerrainType.difficult,
                (8, 9): TerrainType.difficult,
                (9, 0): TerrainType.barrier,
                (9, 1): TerrainType.barrier,
                (9, 10): TerrainType.openAir,
                (10, 0): TerrainType.barrier,
                (10, 9): TerrainType.openAir,
                (11, 0): TerrainType.barrier,
                (11, 9): TerrainType.openAir,
                (11, 10): TerrainType.openAir,
                (12, 8): TerrainType.openAir,
                (12, 9): TerrainType.openAir,
              },
            ),
            placements: [
              PlacementDef(name: 'Uzem\'s Woe', c: 6, r: 5),
              PlacementDef(name: 'Dekaha', c: 3, r: 7),
              PlacementDef(name: 'Dekaha', c: 10, r: 6),
              PlacementDef(name: 'Dekaha', c: 8, r: 4, minPlayers: 4),
              PlacementDef(name: 'Dekaha', c: 5, r: 4, minPlayers: 3),
              PlacementDef(
                  name: 'Bursting Bell',
                  type: PlacementType.trap,
                  c: 3,
                  r: 5,
                  trapDamage: 3),
              PlacementDef(
                  name: 'Bursting Bell',
                  type: PlacementType.trap,
                  c: 9,
                  r: 6,
                  trapDamage: 3),
              PlacementDef(
                  name: 'water', type: PlacementType.ether, c: 6, r: 4),
              PlacementDef(
                  name: 'water', type: PlacementType.ether, c: 7, r: 5),
              PlacementDef(
                  name: 'water', type: PlacementType.ether, c: 7, r: 4),
            ],
          ),
        ],
      );

  static EncounterDef get encounter4dot4 => EncounterDef(
        questId: '4',
        number: '4',
        title: 'That Uneasy, Dissatisfied Feeling',
        victoryDescription: 'Slay the Uzem\'s Fervor.',
        roundLimit: 8,
        baseLystReward: 20,
        campaignLink:
            '''Encounter 4.5 - “**Manifold is Their Kindred**”, [campaign] **64**.''',
        challenges: [
          'During the end phase, Rovers must dim all non-[Fire] dice in their personal and infusion pools.',
          'Uzem\'s Fervor gains +1 [DMG] to all of their attacks when occupying a [wildfire].',
          'At the beginning of round 2, and each round after that, when placing [Fire] dice according to the Burning Bright special rules, place 3 [Fire] dice instead of 2. ',
        ],
        onLoad: [
          rules('Burn Bright',
              '''**Uzem's Fervor is burning away the corruption within its inner sanctum.**  The “Seat of Storms” is old and dense and will survive the flames, but you will not. Place a [Fire] ether dice off the map above the column containing the starting flag icons and the columns immediately to the left and right. Treat all spaces in a column with a [Fire] dice above it as containing a [wildfire].

During the **start phase** of round 2, and each round after that, place two more [Fire] ether dice off the map, above the columns that are immediately to the left of the current left most column with a [Fire] ether dice above it. In this way, a raging fire is traveling from the Rover [start] spaces toward the [Fire] ether node cluster.

Ether fields can still be placed into spaces that are affected by this special rule. A space containing any ether field tile ignores the effects of this special rule. However, if an ether field tile is removed from a space that would be affected by this special rule, treat that space as containing a [wildfire] again.'''),
          subtitle('[Fire] [Fire] [Fire]'),
          codexLink('Basis Of Optimism',
              number: 84,
              body:
                  '''Immediately when Uzem’s Fervor is slain, read [title] [codex] 42.'''),
        ],
        onDidStartRound: [
          subtitle('+ [Fire] [Fire]', condition: RoundCondition(2)),
          subtitle('+ [Fire] [Fire]', condition: RoundCondition(3)),
          subtitle('+ [Fire] [Fire]', condition: RoundCondition(4)),
          subtitle('+ [Fire] [Fire]', condition: RoundCondition(5)),
          subtitle('+ [Fire] [Fire]', condition: RoundCondition(6)),
        ],
        startingMap: MapDef(
          id: '4.4',
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
            (1, 5): TerrainType.object,
            (1, 9): TerrainType.openAir,
            (1, 10): TerrainType.openAir,
            (2, 0): TerrainType.openAir,
            (2, 4): TerrainType.object,
            (2, 5): TerrainType.object,
            (2, 9): TerrainType.openAir,
            (3, 0): TerrainType.openAir,
            (3, 10): TerrainType.openAir,
            (5, 5): TerrainType.openAir,
            (5, 8): TerrainType.object,
            (6, 4): TerrainType.openAir,
            (6, 5): TerrainType.openAir,
            (7, 2): TerrainType.object,
            (7, 5): TerrainType.openAir,
            (9, 0): TerrainType.openAir,
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
        adversaries: [
          EncounterFigureDef(
            name: 'Ashemak',
            letter: 'A',
            health: 6,
            immuneToForcedMovement: true,
            affinities: {
              Ether.water: -2,
              Ether.fire: 2,
            },
            traits: [
              '''[React] Before this unit is slain:
              
All units within [Range] 1 suffer [DMG]2.'''
            ],
          ),
          EncounterFigureDef(
            name: 'Wrathbone',
            letter: 'B',
            health: 14,
            affinities: {
              Ether.water: -2,
              Ether.fire: 2,
            },
            traits: const [
              '''[React] At the end of the Rover phase: 
            
All enemies within [Range] 1 suffer [DMG]1.'''
            ],
          ),
          EncounterFigureDef(
              name: 'Uzem\'s Fervor',
              letter: 'C',
              type: AdversaryType.miniboss,
              healthFormula: '15*R',
              flies: true,
              traits: [
                'Ignores the effects of [wildfire] and [Fire] ether nodes.'
              ],
              affinities: {
                Ether.water: -1,
                Ether.morph: -1,
                Ether.fire: 2,
                Ether.crux: 2,
              },
              onSlain: [
                codex('Basis Of Optimism', page: 42),
                victory(),
              ]),
        ],
        placements: const [
          PlacementDef(name: 'Uzem\'s Fervor', c: 6, r: 5),
          PlacementDef(name: 'Wrathbone', c: 7, r: 8),
          PlacementDef(name: 'Wrathbone', c: 4, r: 7, minPlayers: 3),
          PlacementDef(name: 'Wrathbone', c: 5, r: 2, minPlayers: 4),
          PlacementDef(name: 'Wrathbone', c: 7, r: 1),
          PlacementDef(name: 'Ashemak', c: 6, r: 1, minPlayers: 3),
          PlacementDef(name: 'Ashemak', c: 6, r: 2),
          PlacementDef(name: 'Ashemak', c: 5, r: 7, minPlayers: 4),
          PlacementDef(name: 'Ashemak', c: 5, r: 9),
          PlacementDef(name: 'fire', type: PlacementType.ether, c: 1, r: 5),
          PlacementDef(name: 'fire', type: PlacementType.ether, c: 2, r: 5),
          PlacementDef(name: 'fire', type: PlacementType.ether, c: 2, r: 4),
          PlacementDef(name: 'crux', type: PlacementType.ether, c: 5, r: 8),
          PlacementDef(name: 'crux', type: PlacementType.ether, c: 7, r: 2),
        ],
      );

  static EncounterDef get encounter4dot5 => EncounterDef(
        questId: '4',
        number: '5',
        title: 'Manifold is Their Kindred',
        victoryDescription: 'Slay the King of Storms.',
        roundLimit: 10,
        baseLystReward: 25,
        itemRewards: [
          'Uzem\'s Judgment',
        ],
        unlocksTrait: true,
        milestone: CampaignMilestone.milestone4dot5,
        campaignLink: 'Chapter 3 - “**A Consequence**”, [campaign] **66**.',
        challenges: [
          'The King of Storms attacks dim the ether dice that correspond to the icon on their standee in the personal and infusion pools of their target(s).',
          'Adversaries are treated as occupying the positive ether fields that correspond to the King of Storms forms that are active.',
          'Rovers are treated as occupying the negative ether fields that correspond to the King of Storms forms that are active.',
        ],
        dialogs: [
          EncounterDialogDef(
            title: 'Hail the King',
            type: 'draw',
            body:
                'This is the form The King of Storms takes. Spawn this form in the ether node space that matches its element.',
          )
        ],
        onLoad: [
          rules('Hail the King',
              '''*The King of Storms is trapped in an ethereal conflux.*  You must tame all aspects of this conflux to free the King and restore the environment. The King of Storms has four forms, each with their own hit points, abilities, and traits. All four forms will have to be defeated to win this encounter.

The first form The King of Storms takes is randomly determined at the beginning of the encounter. Randomly stack one copy of [wildfire], [snapfrost], [everbloom], and [windscreen] tiles. Remove the top tile from the stack; this is the form The King of Storms takes. Spawn this form in the ether node space that matches its element.

For example, if [snapfrost] is removed, spawn The King of Storms [icon_water] form in the [Water] ether node space. Use The King of Storms standee with the [Water] icon in the upper right corner, and use a normal one hex base.

Maintain this stack of ether field tiles, as this will be used again later in the encounter.

At the beginning of round 3, and each odd round after that, spawn another The King of Storms. To determine its form, remove the tile from the top of the stack created earlier.

All forms of The King of Storms add +X [DMG] to each attack they perform, where X equals the number of The King of Storms forms that have been defeated.'''),
          dialog('Hail the King'),
          codexLink('Never Forgives The Dreamer',
              number: 85,
              body:
                  '''Immediately when all four forms of The King of Storms are defeated, The King of Storms is slain, then read [title] [codex] 42.'''),
        ],
        onDidStartRound: [
          dialog('Hail the King', condition: RoundCondition(3)),
          dialog('Hail the King', condition: RoundCondition(5)),
          dialog('Hail the King', condition: RoundCondition(7)),
          milestone('_all_spawned', condition: RoundCondition(7)),
        ],
        onDraw: {
          EtherField.wildfire.toJson(): [
            placementGroup(
              'Fire',
              title: 'The King of Storms [Fire]',
              body:
                  'Spawn The King of Storms [icon_fire] form in the [Fire] ether node space.',
            ),
          ],
          EtherField.everbloom.toJson(): [
            placementGroup(
              'Earth',
              title: 'The King of Storms [Earth]',
              body:
                  'Spawn The King of Storms [icon_earth] form in the [Earth] ether node space.',
            ),
          ],
          EtherField.snapfrost.toJson(): [
            placementGroup(
              'Water',
              title: 'The King of Storms [Water]',
              body:
                  'Spawn The King of Storms [icon_water] form in the [Water] ether node space.',
            ),
          ],
          EtherField.windscreen.toJson(): [
            placementGroup(
              'Wind',
              title: 'The King of Storms [Wind]',
              body:
                  'Spawn The King of Storms [icon_wind] form in the [Wind] ether node space.',
            ),
          ],
        },
        onMilestone: {
          '_all_slayed': [
            codex('Never Forgives The Dreamer', page: 42),
            victory(),
            codex('Uzem Quest Conclusion', page: 43),
          ]
        },
        startingMap: MapDef(
          id: '4.5',
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
            (1, 3): TerrainType.object,
            (1, 7): TerrainType.dangerous,
            (1, 9): TerrainType.barrier,
            (1, 10): TerrainType.barrier,
            (2, 0): TerrainType.barrier,
            (2, 1): TerrainType.object,
            (2, 8): TerrainType.dangerous,
            (2, 9): TerrainType.barrier,
            (3, 0): TerrainType.barrier,
            (3, 3): TerrainType.object,
            (3, 10): TerrainType.barrier,
            (4, 1): TerrainType.object,
            (4, 7): TerrainType.object,
            (5, 9): TerrainType.dangerous,
            (7, 1): TerrainType.openAir,
            (7, 9): TerrainType.difficult,
            (8, 2): TerrainType.object,
            (8, 7): TerrainType.object,
            (9, 0): TerrainType.barrier,
            (9, 6): TerrainType.difficult,
            (9, 10): TerrainType.barrier,
            (10, 0): TerrainType.barrier,
            (10, 1): TerrainType.openAir,
            (10, 9): TerrainType.barrier,
            (11, 0): TerrainType.barrier,
            (11, 1): TerrainType.barrier,
            (11, 3): TerrainType.openAir,
            (11, 7): TerrainType.difficult,
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
            name: 'The King of Storms [icon_earth]',
            letter: 'A',
            type: AdversaryType.boss,
            healthFormula: '15*R',
            flies: true,
            large: true,
            traits: [
              ' At the start of this unit\'s turn, it recovers [RCV] R. << Cancel this action if this unit occupies [wildfire].',
              'Adds +X [DMG] to each attack they perform, where X equals the number of The King of Storms forms that have been defeated.'
            ],
            affinities: {
              Ether.wind: -1,
              Ether.crux: 1,
              Ether.earth: 2,
              Ether.morph: -1,
            },
            onSlain: [
              milestone('_all_slayed', conditions: [
                AllAdversariesSlainCondition(),
                MilestoneCondition('_all_spawned')
              ]),
            ],
          ),
          EncounterFigureDef(
            name: 'The King of Storms [icon_wind]',
            letter: 'A',
            type: AdversaryType.boss,
            healthFormula: '15*R',
            flies: true,
            large: true,
            traits: [
              '[M Attacks] that target this unit gain [pierce].',
              'Adds +X [DMG] to each attack they perform, where X equals the number of The King of Storms forms that have been defeated.'
            ],
            affinities: {
              Ether.wind: 2,
              Ether.crux: 1,
              Ether.morph: -1,
              Ether.earth: -1,
            },
            onSlain: [
              milestone('_all_slayed', conditions: [
                AllAdversariesSlainCondition(),
                MilestoneCondition('_all_spawned')
              ]),
            ],
          ),
          EncounterFigureDef(
            name: 'The King of Storms [icon_fire]',
            letter: 'A',
            type: AdversaryType.boss,
            healthFormula: '15*R',
            flies: true,
            large: true,
            traits: [
              'If this unit enters into a space with [snapfrost], it suffers [DMG]2.',
              'Adds +X [DMG] to each attack they perform, where X equals the number of The King of Storms forms that have been defeated.'
            ],
            affinities: {
              Ether.fire: 2,
              Ether.crux: 1,
              Ether.morph: -1,
              Ether.water: -1,
            },
            onSlain: [
              milestone('_all_slayed', conditions: [
                AllAdversariesSlainCondition(),
                MilestoneCondition('_all_spawned')
              ]),
            ],
          ),
          EncounterFigureDef(
            name: 'The King of Storms [icon_water]',
            letter: 'A',
            type: AdversaryType.boss,
            healthFormula: '15*R',
            flies: true,
            large: true,
            traits: [
              'If this unit suffers impact damage, it suffers an additional +1 [DMG].',
              'Adds +X [DMG] to each attack they perform, where X equals the number of The King of Storms forms that have been defeated.'
            ],
            affinities: {
              Ether.water: 2,
              Ether.crux: 1,
              Ether.morph: -1,
              Ether.fire: -1,
            },
            onSlain: [
              milestone('_all_slayed', conditions: [
                AllAdversariesSlainCondition(),
                MilestoneCondition('_all_spawned')
              ]),
            ],
          ),
        ],
        placements: const [
          PlacementDef(name: 'fire', type: PlacementType.ether, c: 4, r: 7),
          PlacementDef(name: 'earth', type: PlacementType.ether, c: 3, r: 3),
          PlacementDef(name: 'water', type: PlacementType.ether, c: 8, r: 7),
          PlacementDef(name: 'earth', type: PlacementType.ether, c: 8, r: 2),
        ],
        placementGroups: [
          PlacementGroupDef(
            name: 'Earth',
            placements: [
              PlacementDef(
                  name: 'The King of Storms [icon_earth]',
                  c: 3,
                  r: 3,
                  fixedTokens: ['Earth']),
            ],
          ),
          PlacementGroupDef(
            name: 'Wind',
            placements: [
              PlacementDef(
                  name: 'The King of Storms [icon_wind]',
                  c: 8,
                  r: 2,
                  fixedTokens: ['Wind']),
            ],
          ),
          PlacementGroupDef(
            name: 'Fire',
            placements: [
              PlacementDef(
                  name: 'The King of Storms [icon_fire]',
                  c: 4,
                  r: 7,
                  fixedTokens: ['Fire']),
            ],
          ),
          PlacementGroupDef(
            name: 'Water',
            placements: [
              PlacementDef(
                  name: 'The King of Storms [icon_water]',
                  c: 8,
                  r: 7,
                  fixedTokens: ['Water']),
            ],
          ),
        ],
      );
}
