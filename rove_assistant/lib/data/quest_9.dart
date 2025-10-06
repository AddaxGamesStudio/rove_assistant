import 'dart:ui';

import 'encounter_def_utils.dart';
import 'package:rove_data_types/rove_data_types.dart';

extension Quest9 on EncounterDef {
  static EncounterDef get encounter9dot1a => EncounterDef(
        questId: '9',
        number: '1a',
        title: 'How Wide Was It',
        setup: EncounterSetup(box: '9', map: '59', adversary: '102-103'),
        victoryDescription: 'Slay the Battering Winds.',
        lossDescription: 'Lose if Ozendyn is slain.',
        roundLimit: 8,
        terrain: [
          dangerousBones(1),
          etherWind(),
        ],
        baseLystReward: 30,
        milestone: CampaignMilestone.milestone9dot1,
        campaignLink:
            'Encounter 9.2 - “**The Amber of This Moment**”, [campaign] **140**',
        challenges: [
          'The Battering Winds has +4*R [HP].',
          'When the Battering Winds attacks a Rover, they must drain all [Wind] and [Water] ether dice in their personal or infusion pools.',
          'Rovers can’t benefit from the effects of [Wind] nodes and can’t take ether dice from them. Adversaries are affected by [Wind] nodes when within [Range] 1-2.',
        ],
        dialogs: [
          introductionFromText('quest_9_encounter_1a_intro'),
        ],
        onLoad: [
          dialog('Introduction'),
          rules('Ozendyn',
              '''Ozendeyn is a character ally to Rovers. For this encounter Ozendyn will only use the “Picket” side and will not flip.'''),
          rules('Errata',
              '''The 1st printing tuckbox for Quest 9 is missing the Battering Winds standee. Use a Stormcaller standee from Quest 4/8 instead.'''),
          codexLink('Wait, Where is Mo?',
              number: 160,
              body:
                  '''Immediately when the Battering Winds is slain, read [title], [codex] 73.'''),
        ],
        startingMap: MapDef(
          id: '9.1.a',
          columnCount: 13,
          rowCount: 11,
          backgroundRect: Rect.fromLTWH(125.0, 44.0, 1481.0, 1411.0),
          starts: [
            (1, 10),
            (3, 10),
            (5, 10),
            (7, 10),
            (11, 10),
          ],
          terrain: {
            (0, 6): TerrainType.dangerous,
            (0, 8): TerrainType.object,
            (1, 1): TerrainType.object,
            (1, 4): TerrainType.object,
            (3, 0): TerrainType.dangerous,
            (3, 5): TerrainType.object,
            (3, 8): TerrainType.difficult,
            (4, 2): TerrainType.difficult,
            (4, 5): TerrainType.object,
            (6, 0): TerrainType.difficult,
            (6, 8): TerrainType.object,
            (7, 6): TerrainType.difficult,
            (8, 3): TerrainType.object,
            (9, 7): TerrainType.object,
            (10, 1): TerrainType.object,
            (10, 6): TerrainType.object,
            (10, 8): TerrainType.dangerous,
            (11, 4): TerrainType.dangerous,
          },
        ),
        allies: [
          AllyDef(name: 'Ozendyn', cardId: 'A-015', behaviors: [
            EncounterFigureDef(
              name: 'Picket',
              health: 11,
              affinities: {
                Ether.wind: -1,
                Ether.morph: -1,
                Ether.earth: 1,
                Ether.crux: 1,
              },
              abilities: [
                AbilityDef(name: 'Ability', actions: [
                  RoveAction.move(4, exclusiveGroup: 1),
                  RoveAction.meleeAttack(3, exclusiveGroup: 1),
                  RoveAction.move(2, exclusiveGroup: 2),
                  RoveAction.rangeAttack(2, endRange: 3, exclusiveGroup: 2),
                ]),
              ],
              reactions: [
                EnemyReactionDef(
                    trigger: ReactionTriggerDef(
                        type: RoveEventType.afterSlain,
                        targetKind: TargetKind.enemy,
                        condition: MatchesCondition('Stomaw')),
                    actions: [RoveAction.heal(1, endRange: 1)])
              ],
              onSlain: [fail()],
            ),
          ])
        ],
        adversaries: [
          EncounterFigureDef(
            name: 'Galeaper',
            letter: 'A',
            standeeCount: 4,
            health: 8,
            flies: true,
            affinities: {
              Ether.fire: -1,
              Ether.earth: -1,
              Ether.wind: 3,
              Ether.morph: 1,
            },
          ),
          EncounterFigureDef(
            name: 'Streak',
            letter: 'B',
            standeeCount: 5,
            health: 8,
            flies: true,
            affinities: {
              Ether.earth: -1,
              Ether.crux: 1,
              Ether.wind: 2,
            },
          ),
          EncounterFigureDef(
            name: 'Kifa',
            letter: 'C',
            standeeCount: 6,
            health: 8,
            flies: true,
            affinities: {
              Ether.fire: -1,
              Ether.water: -1,
              Ether.wind: 2,
              Ether.earth: 2,
            },
          ),
          EncounterFigureDef(
            name: 'Battering Winds',
            letter: 'D',
            type: AdversaryType.miniboss,
            standeeCount: 1,
            healthFormula: '8*R',
            flies: true,
            traits: [
              'This unit gains [DEF] 2 against melee attacks targeting it.',
            ],
            affinities: {
              Ether.earth: -2,
              Ether.fire: -1,
              Ether.morph: 1,
              Ether.water: 1,
              Ether.wind: 2,
              Ether.crux: 2,
            },
          ),
        ],
        placements: [
          PlacementDef(name: 'Galeaper', c: 2, r: 3),
          PlacementDef(name: 'Galeaper', c: 7, r: 5, minPlayers: 3),
          PlacementDef(name: 'Galeaper', c: 11, r: 2),
          PlacementDef(name: 'Galeaper', c: 4, r: 0, minPlayers: 4),
          PlacementDef(name: 'Streak', c: 7, r: 3),
          PlacementDef(name: 'Streak', c: 9, r: 4),
          PlacementDef(name: 'Streak', c: 12, r: 0, minPlayers: 4),
          PlacementDef(name: 'Streak', c: 0, r: 5),
          PlacementDef(name: 'Streak', c: 0, r: 0, minPlayers: 3),
          PlacementDef(name: 'Kifa', c: 1, r: 2),
          PlacementDef(name: 'Kifa', c: 5, r: 3),
          PlacementDef(name: 'Kifa', c: 5, r: 5, minPlayers: 3),
          PlacementDef(name: 'Kifa', c: 8, r: 0, minPlayers: 4),
          PlacementDef(name: 'Kifa', c: 11, r: 6),
          PlacementDef(name: 'Battering Winds', c: 6, r: 2, onSlain: [
            codex(160),
            victory(),
          ]),
          PlacementDef(name: 'wind', type: PlacementType.ether, c: 1, r: 4),
          PlacementDef(name: 'wind', type: PlacementType.ether, c: 10, r: 1),
          PlacementDef(name: 'wind', type: PlacementType.ether, c: 6, r: 8),
        ],
      );

  static EncounterDef get encounter9dot1b => EncounterDef(
        questId: '9',
        number: '1b',
        title: 'How Deep Was It',
        setup: EncounterSetup(box: '9', map: '60', adversary: '104-105'),
        victoryDescription: 'Slay the Final Cut.',
        roundLimit: 8,
        terrain: [
          dangerousBones(1),
          etherMorph(),
        ],
        baseLystReward: 30,
        milestone: CampaignMilestone.milestone9dot1,
        campaignLink:
            'Encounter 9.2 - “**The Amber of This Moment**”, [campaign] **140**',
        challenges: [
          'The Final Cut gains +2 movement points to all of their movement actions.',
          'Ashemaks gain +2 [DEF].',
          'Adversaries are immune to the effects of [Morph] nodes. Rovers can not take ether dice from [Morph] nodes and are affected by them while within [Range] 1-2.',
        ],
        dialogs: [
          introductionFromText('quest_9_encounter_1b_intro'),
        ],
        onLoad: [
          dialog('Introduction'),
          codexLink('Wait, Where is Mo?',
              number: 160,
              body:
                  '''Immediately when the Final Cut is slain, read [title], [codex] 73.'''),
        ],
        startingMap: MapDef(
          id: '9.1.b',
          columnCount: 13,
          rowCount: 11,
          backgroundRect: Rect.fromLTWH(110.0, 44.0, 1481.0, 1411.0),
          starts: [
            (1, 10),
            (3, 10),
            (5, 10),
            (7, 10),
            (11, 10),
          ],
          terrain: {
            (1, 4): TerrainType.dangerous,
            (2, 1): TerrainType.object,
            (2, 6): TerrainType.object,
            (2, 8): TerrainType.dangerous,
            (3, 7): TerrainType.object,
            (4, 3): TerrainType.object,
            (5, 6): TerrainType.difficult,
            (6, 0): TerrainType.difficult,
            (6, 8): TerrainType.object,
            (8, 2): TerrainType.difficult,
            (8, 5): TerrainType.object,
            (9, 0): TerrainType.dangerous,
            (9, 5): TerrainType.object,
            (9, 8): TerrainType.difficult,
            (11, 1): TerrainType.object,
            (11, 4): TerrainType.object,
            (11, 7): TerrainType.dangerous,
            (12, 8): TerrainType.object,
          },
        ),
        adversaries: [
          EncounterFigureDef(
            name: 'Final Cut',
            letter: 'A',
            type: AdversaryType.miniboss,
            healthFormula: '10*R',
            standeeCount: 4,
            immuneToForcedMovement: true,
            traits: [
              'This unit gains [DEF] 2 against ranged attacks targeting it.',
            ],
            affinities: {
              Ether.morph: 3,
              Ether.earth: 3,
              Ether.fire: 2,
              Ether.crux: -1,
              Ether.wind: -1,
            },
          ),
          EncounterFigureDef(
            name: 'Ashemak',
            letter: 'B',
            standeeCount: 4,
            health: 9,
            immuneToForcedMovement: true,
            traits: [
              'Before this unit is slain, all units within [Range] 1 suffer [DMG]3.',
            ],
            affinities: {
              Ether.fire: 3,
              Ether.wind: -1,
              Ether.water: -2,
            },
          ),
          EncounterFigureDef(
            name: 'Wrathbone',
            letter: 'C',
            standeeCount: 3,
            health: 20,
            traits: [
              '[React] At the end of the Rover phase: All enemies within [Range] 1-2 suffer [DMG]1. << Enemies within [Range] 1 suffer an additional [DMG]1.',
            ],
            affinities: {
              Ether.water: -2,
              Ether.fire: 2,
              Ether.earth: 1,
            },
          ),
          EncounterFigureDef(
            name: 'Dyad',
            letter: 'D',
            standeeCount: 2,
            health: 16,
            affinities: {
              Ether.crux: 2,
              Ether.water: 1,
              Ether.morph: -2,
            },
          ),
        ],
        placements: [
          PlacementDef(name: 'Final Cut', c: 6, r: 2, onSlain: [
            codex(160),
            victory(),
          ]),
          PlacementDef(name: 'Ashemak', c: 4, r: 2, minPlayers: 3),
          PlacementDef(name: 'Ashemak', c: 10, r: 2, minPlayers: 4),
          PlacementDef(name: 'Ashemak', c: 11, r: 6),
          PlacementDef(name: 'Ashemak', c: 1, r: 6),
          PlacementDef(name: 'Wrathbone', c: 8, r: 4),
          PlacementDef(name: 'Wrathbone', c: 1, r: 2, minPlayers: 3),
          PlacementDef(name: 'Dyad', c: 4, r: 4),
          PlacementDef(name: 'Dyad', c: 7, r: 1),
          PlacementDef(name: 'morph', type: PlacementType.ether, c: 6, r: 8),
          PlacementDef(name: 'morph', type: PlacementType.ether, c: 11, r: 4),
          PlacementDef(name: 'morph', type: PlacementType.ether, c: 2, r: 1),
        ],
      );

  static EncounterDef get encounter9dot2 => EncounterDef(
        questId: '9',
        number: '2',
        title: 'The Amber of This Moment',
        setup: EncounterSetup(box: '9', map: '61', adversary: '106-107'),
        victoryDescription: 'Free Mo from their cage.',
        roundLimit: 8,
        terrain: [
          dangerousBones(1),
          etherWind(),
          etherFire(),
        ],
        baseLystReward: 15,
        unlocksRoverLevel: 9,
        milestone: CampaignMilestone.milestone9dot2,
        playerPossibleTokens: ['Key'],
        campaignLink:
            'Encounter 9.3 - “**What do the Birds Say**”, [campaign] **142**.',
        challenges: [
          'Set the Round Limit to 6.',
          'The Warden gains +2 [DEF].',
          'Briarwogs and streaks gain +1 [DMG] to all of their attacks.'
        ],
        trackerEvents: [
          EncounterTrackerEventDef(
              title:
                  'Mark when the Rover with the “Cage Key” is within [Range] 1 of cage [A] at the end of the round',
              ifMilestone: '_warden_slain',
              recordMilestone: '_victory'),
        ],
        dialogs: [
          introductionFromText('quest_9_encounter_2_intro'),
        ],
        onLoad: [
          dialog('Introduction'),
          rules('Caged Starling',
              '''Mo has been captured by the Star Hunters. The Warden will execute Mo soon and take their shard for themselves. There are several ways to free Mo. Pick the path that best suits your team composition.'''),
          rules('Clear the Camp',
              '''Slay all the enemies. If all adversaries are slain, you have the freedom to uncage Mo with no threat of retaliation.'''),
          rules('Uncage Mo',
              '''Slay the Warden, take the cage key from them, then move to within [Range] 1 of cage [A] to open it and free Mo.'''),
          rules('Sunder the Cage',
              '''Open the cage by force and flee with Mo. Cage [A] is a special object and has R*5 [HP] and [DEF] 4. Rovers treat the cage as an enemy and no faction treats it as an ally.'''),
          rules('Errata',
              '''The 1st printing tuckbox for Quest 9 is missing the Stormcaller standees. Take them from Quest 4/8 instead.'''),
          codexLink('Cage Master',
              number: 161,
              body: '''If the Warden is slain, read [title], [codex] 74.'''),
          codexLink('Let’s Get You Out of Here',
              number: 162,
              body:
                  '''Immediately when all adversaries are slain, read [title], [codex] 74.'''),
          codexLink('Let’s Get You Out of Here',
              number: 162,
              body:
                  '''Immediately when cage space [A] is destroyed, read [title], [codex] 74.'''),
        ],
        onMilestone: {
          '_victory': [
            codex(162),
            victory(),
          ],
          '_warden_slain': [
            codex(161),
            addToken('Key'),
            codexLink(
              'Let’s Get You Out Of Here',
              number: 162,
              body:
                  'At the end of the round, if the Rover with the “Cage Key” is within [range] 1 of cage [A], read [title], [codex] 74.',
            )
          ],
        },
        startingMap: MapDef(
          id: '9.2',
          columnCount: 13,
          rowCount: 11,
          backgroundRect: Rect.fromLTWH(125.0, 44.0, 1481.0, 1411.0),
          starts: [
            (3, 10),
            (4, 9),
            (5, 10),
            (6, 9),
            (7, 10),
            (8, 9),
            (9, 10),
          ],
          terrain: {
            (0, 5): TerrainType.object,
            (0, 6): TerrainType.object,
            (1, 1): TerrainType.object,
            (1, 2): TerrainType.object,
            (1, 4): TerrainType.object,
            (1, 6): TerrainType.object,
            (1, 10): TerrainType.object,
            (2, 1): TerrainType.object,
            (2, 9): TerrainType.object,
            (3, 3): TerrainType.object,
            (3, 4): TerrainType.object,
            (3, 9): TerrainType.object,
            (4, 3): TerrainType.object,
            (5, 0): TerrainType.object,
            (5, 2): TerrainType.object,
            (5, 5): TerrainType.barrier,
            (6, 0): TerrainType.object,
            (6, 4): TerrainType.barrier,
            (6, 5): TerrainType.barrier,
            (7, 0): TerrainType.object,
            (7, 5): TerrainType.barrier,
            (9, 2): TerrainType.object,
            (9, 9): TerrainType.object,
            (10, 0): TerrainType.object,
            (10, 9): TerrainType.object,
            (11, 1): TerrainType.object,
            (11, 10): TerrainType.object,
            (12, 0): TerrainType.object,
            (12, 2): TerrainType.object,
            (12, 3): TerrainType.object,
          },
        ),
        overlays: [
          EncounterFigureDef(
            name: 'Cage',
            healthFormula: '5*R',
            defense: 4,
          )
        ],
        adversaries: [
          EncounterFigureDef(
            name: 'Streak',
            letter: 'A',
            standeeCount: 5,
            health: 8,
            flies: true,
            affinities: {
              Ether.wind: 2,
              Ether.earth: -1,
              Ether.crux: 1,
            },
            onSlain: [
              milestone('_victory', condition: AllAdversariesSlainCondition()),
            ],
          ),
          EncounterFigureDef(
            name: 'Wrathbone',
            letter: 'B',
            standeeCount: 3,
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
              milestone('_victory', condition: AllAdversariesSlainCondition()),
            ],
          ),
          EncounterFigureDef(
            name: 'Harrow',
            letter: 'C',
            standeeCount: 4,
            health: 18,
            affinities: {
              Ether.morph: 2,
              Ether.crux: 2,
            },
            onSlain: [
              milestone('_victory', condition: AllAdversariesSlainCondition()),
            ],
          ),
          EncounterFigureDef(
            name: 'Stormcaller',
            letter: 'D',
            standeeCount: 4,
            health: 15,
            flies: true,
            traits: [
              'This unit gains [DEF] 2 against [r_attack] targeting it.',
            ],
            affinities: {
              Ether.wind: 2,
              Ether.crux: 2,
              Ether.water: 1,
              Ether.morph: -1,
              Ether.fire: -1,
              Ether.earth: -2,
            },
            onSlain: [
              milestone('_victory', condition: AllAdversariesSlainCondition()),
            ],
          ),
          EncounterFigureDef(
            name: 'Briarwog',
            letter: 'E',
            standeeCount: 6,
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
            onSlain: [
              milestone('_victory', condition: AllAdversariesSlainCondition()),
            ],
          ),
          EncounterFigureDef(
            name: 'Warden',
            letter: 'F',
            type: AdversaryType.miniboss,
            standeeCount: 4,
            health: 15,
            affinities: {
              Ether.wind: 2,
              Ether.water: 2,
              Ether.earth: -1,
              Ether.fire: -1,
            },
            onSlain: [
              milestone('_victory', condition: AllAdversariesSlainCondition()),
              milestone('_warden_slain',
                  condition: MilestoneCondition('_victory', value: false)),
            ],
          ),
        ],
        placements: [
          PlacementDef(name: 'Streak', c: 8, r: 3, minPlayers: 3),
          PlacementDef(name: 'Streak', c: 10, r: 4),
          PlacementDef(name: 'Streak', c: 11, r: 4),
          PlacementDef(name: 'Wrathbone', c: 3, r: 5),
          PlacementDef(name: 'Wrathbone', c: 0, r: 8, minPlayers: 3),
          PlacementDef(name: 'Harrow', c: 2, r: 6),
          PlacementDef(name: 'Harrow', c: 4, r: 1, minPlayers: 4),
          PlacementDef(name: 'Stormcaller', c: 12, r: 1, minPlayers: 4),
          PlacementDef(name: 'Stormcaller', c: 12, r: 5),
          PlacementDef(name: 'Briarwog', c: 3, r: 0),
          PlacementDef(name: 'Briarwog', c: 9, r: 0),
          PlacementDef(
              name: 'Cage',
              type: PlacementType.object,
              c: 6,
              r: 0,
              onSlain: [
                milestone('_victory'),
              ]),
          PlacementDef(name: 'Briarwog', c: 6, r: 2, minPlayers: 3),
          PlacementDef(name: 'Warden', c: 7, r: 1),
          PlacementDef(name: 'wind', type: PlacementType.ether, c: 5, r: 2),
          PlacementDef(name: 'wind', type: PlacementType.ether, c: 9, r: 2),
          PlacementDef(name: 'fire', type: PlacementType.ether, c: 1, r: 4),
        ],
      );

  static EncounterDef get encounter9dot3 => EncounterDef(
        questId: '9',
        number: '3',
        title: 'What do the Birds Say?',
        setup: EncounterSetup(box: '9', map: '62', adversary: '108'),
        victoryDescription: 'Slay all adversaries.',
        roundLimit: 8,
        terrain: [
          etherEarth(),
        ],
        baseLystReward: 20,
        campaignLink:
            'Encounter 9.4 - “**Feet of Lead, Wings of Ti**”, [campaign] **144**.',
        challenges: [
          'Courslayers gain +1 [DMG] to all of their attacks.',
          'Grovetenders have +6 [HP].',
          'Rovers can’t benefit from the effects of [Earth] nodes and can’t take ether dice from them. Adversaries are affected by [Earth] nodes when within [Range] 1-2.',
        ],
        dialogs: [
          introductionFromText('quest_9_encounter_3_intro'),
        ],
        onLoad: [
          dialog('Introduction'),
          rules('Ambush',
              'You have been ambushed by the Star Hunters. In this encounter, the Adversary faction gains priority before the Rover faction.'),
          codexLink('Trained Killer',
              number: 163,
              body:
                  '''The first time a courslayer is slain, read [title], [codex] 74.'''),
          codexLink('This is Bad',
              number: 164,
              body:
                  '''Immediately when all adversaries are slain, read [title], [codex] 75.'''),
        ],
        onMilestone: {
          '_victory': [
            codex(164),
            victory(),
          ],
        },
        startingMap: MapDef(
          id: '9.3',
          columnCount: 13,
          rowCount: 11,
          backgroundRect: Rect.fromLTWH(110.0, 44.0, 1481.0, 1411.0),
          starts: [
            (6, 2),
            (6, 3),
            (6, 4),
            (6, 5),
            (6, 6),
            (6, 7),
          ],
          terrain: {
            (1, 2): TerrainType.object,
            (1, 5): TerrainType.object,
            (3, 1): TerrainType.object,
            (3, 7): TerrainType.object,
            (3, 8): TerrainType.object,
            (4, 3): TerrainType.difficult,
            (4, 4): TerrainType.difficult,
            (4, 5): TerrainType.difficult,
            (4, 7): TerrainType.object,
            (6, 9): TerrainType.object,
            (8, 0): TerrainType.difficult,
            (8, 3): TerrainType.object,
            (8, 4): TerrainType.difficult,
            (8, 5): TerrainType.object,
            (8, 8): TerrainType.difficult,
            (9, 2): TerrainType.object,
            (10, 1): TerrainType.object,
            (10, 2): TerrainType.object,
            (10, 5): TerrainType.object,
            (11, 8): TerrainType.object,
          },
        ),
        adversaries: [
          EncounterFigureDef(
            name: 'Briarwog',
            letter: 'A',
            standeeCount: 6,
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
              milestone('_victory', condition: AllAdversariesSlainCondition()),
            ],
          ),
          EncounterFigureDef(
            name: 'Grovetender',
            letter: 'B',
            standeeCount: 2,
            health: 12,
            defense: 2,
            traits: [
              ' If a Rover slays this unit, that Rover [plus_water_earth].',
            ],
            affinities: {
              Ether.earth: 3,
              Ether.water: 3,
              Ether.fire: -1,
              Ether.morph: -1,
            },
            onSlain: [
              ether([Ether.water, Ether.earth]),
              milestone('_victory', condition: AllAdversariesSlainCondition()),
            ],
          ),
          EncounterFigureDef(
            name: 'Courslayer',
            letter: 'C',
            standeeCount: 4,
            health: 15,
            affinities: {
              Ether.earth: -1,
              Ether.fire: -1,
              Ether.wind: 2,
              Ether.water: 2,
            },
            onSlain: [
              codex(163),
              milestone('_victory', condition: AllAdversariesSlainCondition()),
            ],
          ),
        ],
        placements: const [
          PlacementDef(name: 'Briarwog', c: 4, r: 9),
          PlacementDef(name: 'Briarwog', c: 8, r: 9),
          PlacementDef(name: 'Briarwog', c: 11, r: 7, minPlayers: 3),
          PlacementDef(name: 'Briarwog', c: 1, r: 7, minPlayers: 3),
          PlacementDef(name: 'Grovetender', c: 6, r: 0),
          PlacementDef(name: 'Grovetender', c: 4, r: 0, minPlayers: 3),
          PlacementDef(name: 'Courslayer', c: 0, r: 3, minPlayers: 4),
          PlacementDef(name: 'Courslayer', c: 2, r: 4),
          PlacementDef(name: 'Courslayer', c: 10, r: 4),
          PlacementDef(name: 'Courslayer', c: 12, r: 3, minPlayers: 4),
          PlacementDef(name: 'earth', type: PlacementType.ether, c: 1, r: 5),
          PlacementDef(name: 'earth', type: PlacementType.ether, c: 3, r: 1),
          PlacementDef(name: 'earth', type: PlacementType.ether, c: 10, r: 5),
          PlacementDef(name: 'earth', type: PlacementType.ether, c: 6, r: 9),
        ],
      );

  static EncounterDef get encounter9dot4 => EncounterDef(
        questId: '9',
        number: '4',
        title: 'Feet of Lead, Wings of Tin',
        setup: EncounterSetup(
            box: '9',
            map: '63',
            adversary: '110-11',
            tiles: '3x Magical Traps'),
        victoryDescription: 'Escape Eclipse.',
        roundLimit: 8,
        terrain: [
          trapMagic(3),
          etherWind(),
        ],
        baseLystReward: 20,
        campaignLink:
            'Encounter 9.5 - “**Requirements of Chaos**”, [campaign] **146**.',
        challenges: [
          'Courslayers gain +1 [DMG] to all of their attacks.',
          'Harrows gain +1 movement points to all of their movement actions.',
          'Stormcallers gain +2 [Range] to all of their attacks.',
        ],
        dialogs: [
          introductionFromText('quest_9_encounter_4_intro'),
        ],
        trackerEvents: [
          EncounterTrackerEventDef(
              title:
                  'Mark when all Rovers occupy an [exit] space at the end of the round',
              recordMilestone: '_victory')
        ],
        onLoad: [
          dialog('Introduction'),
          rules('Eclipse',
              '''Eclipse is the cruel and greedy leader of the Star Hunters, who rides upon his primal worg, Andiron. While within the ruins of Era, and the magics of the starling cores, Eclipse is practically invulnerable. You can’t win this fight. Flee to the exit spaces quickly.'''),
          rules('Errata',
              '''The 1st printing tuckbox for Quest 9 is missing the Stormcaller standees. Take them from Quest 4/8 instead.'''),
          codexLink('We Better Move Quickly',
              number: 165,
              body:
                  '''At the end of the round, if all Rovers occupy an [exit] space, read [title], [codex] 75.'''),
        ],
        onMilestone: {
          '_victory': [
            codex(165),
            victory(),
          ],
        },
        startingMap: MapDef(
          id: '9.4',
          columnCount: 13,
          rowCount: 11,
          backgroundRect: Rect.fromLTWH(125.0, 44.0, 1481.0, 1411.0),
          starts: [
            (3, 6),
            (3, 7),
            (3, 8),
            (4, 6),
            (4, 7),
            (4, 8),
          ],
          exits: [
            (0, 0),
            (0, 1),
            (1, 0),
            (1, 1),
            (1, 2),
          ],
          terrain: {
            (0, 2): TerrainType.barrier,
            (0, 3): TerrainType.barrier,
            (0, 4): TerrainType.barrier,
            (0, 5): TerrainType.barrier,
            (1, 3): TerrainType.barrier,
            (1, 4): TerrainType.barrier,
            (1, 5): TerrainType.barrier,
            (1, 6): TerrainType.barrier,
            (2, 2): TerrainType.barrier,
            (2, 3): TerrainType.barrier,
            (2, 4): TerrainType.barrier,
            (2, 5): TerrainType.barrier,
            (3, 0): TerrainType.difficult,
            (3, 1): TerrainType.difficult,
            (3, 2): TerrainType.barrier,
            (3, 3): TerrainType.barrier,
            (3, 4): TerrainType.barrier,
            (3, 5): TerrainType.barrier,
            (4, 2): TerrainType.barrier,
            (4, 3): TerrainType.barrier,
            (4, 4): TerrainType.barrier,
            (4, 5): TerrainType.barrier,
            (5, 2): TerrainType.object,
            (5, 3): TerrainType.barrier,
            (5, 4): TerrainType.barrier,
            (5, 5): TerrainType.barrier,
            (5, 9): TerrainType.barrier,
            (5, 10): TerrainType.barrier,
            (6, 2): TerrainType.barrier,
            (6, 3): TerrainType.barrier,
            (6, 4): TerrainType.barrier,
            (6, 8): TerrainType.barrier,
            (6, 9): TerrainType.barrier,
            (7, 2): TerrainType.barrier,
            (7, 3): TerrainType.barrier,
            (7, 4): TerrainType.barrier,
            (7, 5): TerrainType.object,
            (7, 8): TerrainType.barrier,
            (7, 9): TerrainType.barrier,
            (7, 10): TerrainType.barrier,
            (8, 2): TerrainType.barrier,
            (8, 3): TerrainType.barrier,
            (8, 4): TerrainType.barrier,
            (8, 5): TerrainType.barrier,
            (8, 8): TerrainType.barrier,
            (8, 9): TerrainType.barrier,
            (9, 2): TerrainType.barrier,
            (9, 3): TerrainType.barrier,
            (9, 4): TerrainType.barrier,
            (9, 5): TerrainType.barrier,
            (9, 6): TerrainType.barrier,
            (9, 9): TerrainType.barrier,
            (9, 10): TerrainType.barrier,
            (10, 4): TerrainType.difficult,
            (10, 9): TerrainType.object,
            (11, 4): TerrainType.object,
            (11, 10): TerrainType.difficult,
            (12, 4): TerrainType.difficult,
            (12, 9): TerrainType.difficult,
          },
        ),
        adversaries: [
          EncounterFigureDef(
            name: 'Harrow',
            letter: 'A',
            standeeCount: 4,
            health: 18,
            affinities: {
              Ether.morph: 2,
              Ether.crux: 2,
            },
          ),
          EncounterFigureDef(
            name: 'Stormcaller',
            letter: 'B',
            standeeCount: 4,
            health: 15,
            flies: true,
            traits: [
              'This unit gains [DEF] 2 against [r_attack] targeting it.',
            ],
            affinities: {
              Ether.wind: 2,
              Ether.crux: 2,
              Ether.water: 1,
              Ether.morph: -1,
              Ether.fire: -1,
              Ether.earth: -2,
            },
          ),
          EncounterFigureDef(
            name: 'Courslayer',
            letter: 'C',
            standeeCount: 4,
            health: 15,
            affinities: {
              Ether.earth: -1,
              Ether.fire: -1,
              Ether.water: 2,
              Ether.wind: 2,
            },
          ),
          EncounterFigureDef(
            name: 'Eclipse Mounted',
            alias: 'Eclipse',
            letter: 'D ',
            type: AdversaryType.boss,
            standeeCount: 1,
            healthFormula: '20*R',
            defenseFormula: '2',
            large: true,
            immuneToDamage: true,
            affinities: {
              Ether.earth: 1,
              Ether.fire: 1,
              Ether.wind: 1,
              Ether.water: 1,
              Ether.crux: 2,
              Ether.morph: 2,
            },
          ),
        ],
        placements: const [
          PlacementDef(name: 'Harrow', c: 7, r: 7),
          PlacementDef(name: 'Harrow', c: 7, r: 6, minPlayers: 3),
          PlacementDef(name: 'Harrow', c: 10, r: 7, minPlayers: 4),
          PlacementDef(name: 'Harrow', c: 7, r: 1, minPlayers: 4),
          PlacementDef(name: 'Stormcaller', c: 2, r: 0),
          PlacementDef(name: 'Stormcaller', c: 2, r: 1, minPlayers: 3),
          PlacementDef(name: 'Courslayer', c: 9, r: 0, minPlayers: 4),
          PlacementDef(name: 'Courslayer', c: 11, r: 0),
          PlacementDef(name: 'Courslayer', c: 12, r: 0, minPlayers: 3),
          PlacementDef(name: 'Eclipse Mounted', c: 1, r: 10),
          PlacementDef(
              name: 'Magic',
              type: PlacementType.trap,
              c: 10,
              r: 6,
              trapDamage: 3),
          PlacementDef(
              name: 'Magic',
              type: PlacementType.trap,
              c: 10,
              r: 8,
              trapDamage: 3),
          PlacementDef(
              name: 'Magic',
              type: PlacementType.trap,
              c: 11,
              r: 2,
              trapDamage: 3),
          PlacementDef(
              name: 'Magic',
              type: PlacementType.trap,
              c: 4,
              r: 0,
              trapDamage: 3),
          PlacementDef(
              name: 'Magic',
              type: PlacementType.trap,
              c: 4,
              r: 1,
              trapDamage: 3),
          PlacementDef(name: 'wind', type: PlacementType.ether, c: 5, r: 2),
          PlacementDef(name: 'wind', type: PlacementType.ether, c: 7, r: 5),
          PlacementDef(name: 'wind', type: PlacementType.ether, c: 11, r: 4),
          PlacementDef(name: 'wind', type: PlacementType.ether, c: 10, r: 9),
        ],
      );

  static EncounterDef get encounter9dot5 => EncounterDef(
        questId: '9',
        number: '5',
        title: 'Requirements of Chaos',
        victoryDescription: 'Find three starling shards.',
        roundLimit: 6,
        baseLystReward: 20,
        campaignLink:
            'Encounter 9.6 - “**Something Worth Wishing For**”, [campaign] **156**.',
        challenges: [
          'During the end phase of each round, Rovers must drain one non-[DIM] dice in their personal or infusion pool.',
          'Rovers remove all ether dice from their personal and infusion pools when transitioning into a new area.',
          'The [miniboss] in the final area gains +5*R [HP] and +1 [DMG] to all of their attacks.',
        ],
        trackerEvents: [
          EncounterTrackerEventDef(
              title:
                  'Mark when one Rover ends the round within [Range] 1 of the Reliquary [A]',
              ifMilestone: '_selected_reliquary',
              recordMilestone: '_reliquary_completed'),
          EncounterTrackerEventDef(
              title:
                  'Mark when one Rover ends the round within [Range] 1 of the Archive [A]',
              ifMilestone: '_selected_archives',
              recordMilestone: '_archives_completed'),
          EncounterTrackerEventDef(
              title:
                  'Mark when one Rover ends the round within [Range] 1 of grave marker [A]',
              ifMilestone: '_selected_mausoleum',
              recordMilestone: '_mausoleum_completed'),
        ],
        dialogs: [
          introductionFromText('quest_9_encounter_5_intro'),
          EncounterDialogDef(
              title: 'Reliquary',
              body:
                  '''The area near the largest Great Tree on the fallen island survived the best, including the nondescript hole in the island’s crust at its base. Despite the lack of ornamentation or adornment the solemnity of the area speaks to a place of veneration, a holy place. Tiny roots woven together form the ceiling and walls as you descend on worn stone stairs. You can see the roots sucking in Air ether and expelling small amounts of Morph. Mo observes that the Morph runs along the roots, holding the islands together, while the Air collects in the sap, slowly forming the abounding crystals which provide lift, keeping Era skybound.

Unfortunately this sacred place, too, has been defiled by the Star Hunters in their quest for personal enrichment. When you reach the bottom of the stairs you find a wide, open room filled with hulking harrow and their accompanying kifa. The Star Hunter captain, a stormcaller, stands in the center of the room, directing its destruction and pilfering.

The room was once filled with small shrines holding delicate relics wrought from the wood and leaves of the Great Trees of Era. Many were destroyed when the island fell, filling the room with rubble and ruin. Three greater shrines persist, miniature temples holding the most hallowed artifacts of Era. One of these must be the infused object that ‘inspired’ you to come this way.'''),
          EncounterDialogDef(
              title: 'Archives',
              body:
                  '''Makaal stares at the stony bit of starling tentacle in his hands. “Mo, what is this?! Why did you give me this?” Mo looks confused. “You asked how I knew that dagger would shatter. Is it not better to share information directly, rather than use imprecise verbiage?” Makaal takes a long, slow breath. “Mo, my friend, I appreciate the thought, but you know I can’t fuse with this like a starling!” The starling flinches, “No, you don’t fuse with it! Though I see the similarity, all you need to do is hold it against you while you meditate.” Makaal just shakes his head and hands the tendril back to his friend.

The archives are the deepest structures on Era; so deep you can occasionally see an exposed blue Water gem, like those that cover the bottom of the island sucking latent Water from the air to sustain the Great Trees. Thankfully, they are also the best reinforced and managed to remain largely in-tact even having fallen from the sky.

Normally the tidiest, best organized section of Era, the impact still all but ruined the interior leaving the shelves knocked down, dozens of clay jars dashed against the ground. Pottery and petrified starling tendrils crunch under the feet of the briarwogs patrolling the aisles while their masters seek out the infused shard. Silky’s aerios swoons in the air, appalled at the sight of such disregard for one of the greatest stores of information in the world. “The object of power will be stored alongside a tendril in one of the archives, Rovers, now hurry before I’m sick!” he exclaims.'''),
          EncounterDialogDef(
              title: 'Mausoleum',
              body:
                  '''Mo leads you to an offshoot Great Tree on the fallen island. Even these ‘smaller’ trees are the size of a house on the surface, their twisting bark glowing with a golden inner light forming the walls of large hollows inside. Mo explains that many of the trees near the edges of Era are mausoleums, including the one they are leading you to now.

You peek your head around the entrance to scope out the inside. The mausoleum is a mess of shattered crystals and ruined burial urns, but you see only one harrow and her accompanying wrathbones defiling the graves in their search. One thing strikes you as odd, however; whereas typically the Star Hunters smash first and ask questions later, this harrow seems to be carefully fiddling with a starling core embedded in a sconce.

Makaal whispers, “The cores are crafted into the memorial work. They have to be carefully extracted, or you risk destroying the entire core.” You nod and step up, ready to get to work. Before you can even make an impression, several courslayers drop from the ceiling where they had been extracting cores out of view. You steel yourselves regardless; the starling shard must be recovered. '''),
          EncounterDialogDef(
              title: 'Choose First Area',
              body:
                  '''There are three different areas to explore within the Era ruins, the Reliquary, the Archives, and the Mausoleum. All three locations must be explored to find all starling shards. Choose which area to explore first and reference the appropriate pages.''',
              buttons: [
                EncounterDialogButton(
                    title: 'Reliquary', milestone: '_selected_reliquary'),
                EncounterDialogButton(
                    title: 'Archives', milestone: '_selected_archives'),
                EncounterDialogButton(
                    title: 'Mausoleum', milestone: '_selected_mausoleum'),
              ]),
          EncounterDialogDef(
              title: 'Reliquary Completed',
              body: '''Choose which room to go to next.''',
              buttons: [
                EncounterDialogButton(
                    title: 'Archives', milestone: '_selected_archives'),
                EncounterDialogButton(
                    title: 'Mausoleum', milestone: '_selected_mausoleum'),
              ]),
          EncounterDialogDef(
              title: 'Archives Completed',
              body: '''Choose which room to go to next.''',
              buttons: [
                EncounterDialogButton(
                    title: 'Reliquary', milestone: '_selected_reliquary'),
                EncounterDialogButton(
                    title: 'Mausoleum', milestone: '_selected_mausoleum'),
              ]),
          EncounterDialogDef(
              title: 'Mausoleum Completed',
              body: '''Choose which room to go to next.''',
              buttons: [
                EncounterDialogButton(
                    title: 'Reliquary', milestone: '_selected_reliquary'),
                EncounterDialogButton(
                    title: 'Archives', milestone: '_selected_archives'),
              ]),
        ],
        onLoad: [
          rules('Errata',
              '''The 1st printing tuckbox for Quest 9 is missing the Stormcaller standees. Take them from Quest 4/8 instead.'''),
          dialog('Introduction'),
          dialog('Choose First Area'),
          codexLink('Collected An Echo of the Past',
              number: 166,
              body:
                  '''Immediately after finding the first starling shard, read [title], [codex] 75.'''),
        ],
        onMilestone: {
          '_selected_reliquary': [
            dialog('Reliquary'),
            rules('Reliquary',
                '''Proceed to page 112 of the adversary book, page 64 of the map book, and page 148 of the campaign book.

Place Rovers in [start] spaces and spawn adversaries according to Rover count as shown on the map. Rover [HP], ether dice, and infusion dice carry over. Glyphs and summons carry over and are placed within [Range] 1 of their owner.

*The air is electric with potential. A powerful construct is housed here.*

Area Victory Condition: One Rover ends the round within [Range] 1 of the Reliquary [A].'''),
            placementGroup('Reliquary'),
            subtitle('Reliquary'),
            victoryCondition(
                'Find three starling shards.\n\nArea Victory Condition: One Rover ends the round within [Range] 1 of the Reliquary [A].'),
            resetRound(body: 'You have 6 rounds to complete the next area.'),
          ],
          '_reliquary_completed': [
            codex(166),
            milestone(CampaignMilestone.milestone9dot5Reliquary),
            milestone('_archives_last', conditions: [
              MilestoneCondition('_mausoleum_completed'),
            ]),
            milestone('_mausoleum_last', conditions: [
              MilestoneCondition('_archives_completed'),
            ]),
            dialog('Reliquary Completed', conditions: [
              MilestoneCondition('_archives_last', value: false),
              MilestoneCondition('_mausoleum_last', value: false)
            ]),
          ],
          '_reliquary_last': [
            rules('Reliquary Last',
                '''Proceed to page 115 of the adversary book, page 67 of the map book, and page 152 of the campaign book.

Place Rovers in [start] spaces and spawn adversaries according to Rover count as shown on the map. Rover [HP], ether dice, and infusion dice carry over. Glyphs and summons carry over and are placed within [Range] 1 of their owner.

*The air is electric with potential. A powerful construct is housed here.*

Area Victory Condition: Slay the Stolen Breath.'''),
            placementGroup('Reliquary Last'),
            subtitle('Reliquary'),
            victoryCondition(
                'Find three starling shards.\n\nArea Victory Condition: Slay the Stolen Breath.'),
            resetRound(body: 'You have 6 rounds to complete the next area.'),
            codexLink('We Have Need of Your Knowledge One Last Time',
                number: 167,
                body:
                    '''Immediately when the Stolen Breath is slain, read [title], [codex] 76.'''),
          ],
          '_selected_archives': [
            dialog('Archives'),
            rules('Archives',
                '''Proceed to page 113 of the adversary book, page 65 of the map book, and page 149 of the campaign book.
            
Place Rovers in [start] spaces and spawn adversaries according to Rover count as shown on the map. Rover [HP], ether dice, and infusion dice carry over. Glyphs and summons carry over and are placed within [Range] 1 of their owner.

*The great chamber is eerily silent, as if the room itself holds its breath.*

Area Victory Condition: One Rover ends the round within [Range] 1 of the Archive [A].'''),
            placementGroup('Archives'),
            subtitle('Archives'),
            victoryCondition(
                'Find three starling shards.\n\nArea Victory Condition: One Rover ends the round within [Range] 1 of the Archive [A].'),
            resetRound(body: 'You have 6 rounds to complete the next area.'),
          ],
          '_archives_completed': [
            codex(166),
            milestone(CampaignMilestone.milestone9dot5Archives),
            milestone('_reliquary_last', conditions: [
              MilestoneCondition('_mausoleum_completed'),
            ]),
            milestone('_mausoleum_last', conditions: [
              MilestoneCondition('_reliquary_completed'),
            ]),
            dialog('Archives Completed', conditions: [
              MilestoneCondition('_reliquary_last', value: false),
              MilestoneCondition('_mausoleum_last', value: false)
            ]),
          ],
          '_archives_last': [
            rules('Archives Last',
                '''Proceed to page 116 of the adversary book, page 68 of the map book, and page 153 of the campaign book.

Place Rovers in [start] spaces and spawn adversaries according to Rover count as shown on the map. Rover [HP], ether dice, and infusion dice carry over. Glyphs and summons carry over and are placed within [Range] 1 of their owner.

*The great chamber is eerily silent, as if the room itself holds its breath.*

Area Victory Condition: Slay the Piercing Gaze.'''),
            placementGroup('Archives Last'),
            subtitle('Archives'),
            victoryCondition(
                'Find three starling shards.\n\nArea Victory Condition: Slay the Piercing Gaze.'),
            resetRound(body: 'You have 6 rounds to complete the next area.'),
            codexLink('We Have Need of Your Knowledge One Last Time',
                number: 167,
                body:
                    '''Immediately when the Piercing Gaze is slain, read [title], [codex] 76.'''),
          ],
          '_selected_mausoleum': [
            dialog('Mausoleum'),
            rules('Mausoleum',
                '''Proceed to page 114 of the adversary book, page 66 of the map book, and page 150 of the campaign book.

Place Rovers in [start] spaces and spawn adversaries according to Rover count as shown on the map. Rover [HP], ether dice, and infusion dice carry over. Glyphs and summons carry over and are placed within [Range] 1 of their owner.

*A heavy pal hangs over the markers of those lost.*

Area Victory Condition: One Rover ends the round within [Range] 1 of grave marker [A].'''),
            placementGroup('Mausoleum'),
            subtitle('Mausoleum'),
            victoryCondition(
                'Find three starling shards.\n\nArea Victory Condition: One Rover ends the round within [Range] 1 of grave marker [A].'),
            resetRound(body: 'You have 6 rounds to complete the next area.'),
          ],
          '_mausoleum_completed': [
            codex(166),
            milestone(CampaignMilestone.milestone9dot5Mausoleum),
            milestone('_reliquary_last', conditions: [
              MilestoneCondition('_archives_completed'),
            ]),
            milestone('_archives_last', conditions: [
              MilestoneCondition('_reliquary_completed'),
            ]),
            dialog('Mausoleum Completed', conditions: [
              MilestoneCondition('_reliquary_last', value: false),
              MilestoneCondition('_archives_last', value: false)
            ]),
          ],
          '_mausoleum_last': [
            rules('Mausoleum Last',
                '''Proceed to page 117 of the adversary book, page 69 of the map book, and page 154 of the campaign book.

Place Rovers in [start] spaces and spawn adversaries according to Rover count as shown on the map. Rover [HP], ether dice, and infusion dice carry over. Glyphs and summons carry over and are placed within [Range] 1 of their owner.

*A heavy pal hangs over the markers of those lost.*

Area Victory Condition: Slay the Heavy Hand.'''),
            placementGroup('Mausoleum Last'),
            subtitle('Mausoleum'),
            victoryCondition(
                'Find three starling shards.\n\nArea Victory Condition: Slay the Heavy Hand.'),
            resetRound(body: 'You have 6 rounds to complete the next area.'),
            codexLink('We Have Need of Your Knowledge One Last Time',
                number: 167,
                body:
                    '''Immediately when the Heavy Hand is slain, read [title], [codex] 76.'''),
          ],
          '_victory': [
            codex(167),
            victory(
                body:
                    '''Rover may choose one of two items, the “Ethereal Catena” or the “Ethereal Aegis”. These are unique party items. They do not take up an equipment slot and all Rovers benefit from their passive effect.'''),
          ],
        },
        startingMap: MapDef.empty(),
        adversaries: [],
        placements: const [],
        placementGroups: [
          PlacementGroupDef(
            name: 'Reliquary',
            terrain: [
              trapMagic(3),
              etherWind(),
              etherCrux(),
            ],
            setup: EncounterSetup(
                box: '9',
                map: '64',
                adversary: '112',
                tiles: '3x Magical Traps'),
            adversaries: [
              EncounterFigureDef(
                name: 'Kifa',
                letter: 'A',
                standeeCount: 6,
                health: 8,
                flies: true,
                affinities: {
                  Ether.wind: 2,
                  Ether.earth: 2,
                  Ether.fire: -1,
                  Ether.water: -1,
                },
              ),
              EncounterFigureDef(
                name: 'Harrow',
                letter: 'B',
                standeeCount: 4,
                health: 18,
                affinities: {
                  Ether.morph: 2,
                  Ether.crux: 2,
                },
              ),
              EncounterFigureDef(
                name: 'Stormcaller',
                letter: 'C',
                standeeCount: 4,
                health: 15,
                flies: true,
                traits: [
                  'This unit gains [DEF] 2 against [r_attack] targeting it.',
                ],
                affinities: {
                  Ether.wind: 2,
                  Ether.crux: 2,
                  Ether.water: 1,
                  Ether.morph: -1,
                  Ether.fire: -1,
                  Ether.earth: -2,
                },
              ),
            ],
            map: MapDef(
              id: '9.5.reliquary',
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
                (0, 4): TerrainType.difficult,
                (1, 2): TerrainType.barrier,
                (1, 8): TerrainType.difficult,
                (2, 1): TerrainType.barrier,
                (2, 2): TerrainType.object,
                (3, 2): TerrainType.barrier,
                (4, 5): TerrainType.difficult,
                (4, 9): TerrainType.difficult,
                (5, 5): TerrainType.difficult,
                (5, 6): TerrainType.difficult,
                (6, 1): TerrainType.object,
                (6, 5): TerrainType.difficult,
                (8, 0): TerrainType.barrier,
                (8, 7): TerrainType.object,
                (9, 0): TerrainType.barrier,
                (9, 1): TerrainType.object,
                (9, 10): TerrainType.object,
                (10, 0): TerrainType.barrier,
                (10, 4): TerrainType.barrier,
                (10, 9): TerrainType.difficult,
                (11, 4): TerrainType.barrier,
                (11, 5): TerrainType.object,
                (11, 10): TerrainType.object,
                (12, 4): TerrainType.barrier,
                (12, 8): TerrainType.object,
                (12, 9): TerrainType.object,
              },
            ),
            placements: [
              PlacementDef(name: 'Kifa', c: 0, r: 0, minPlayers: 4),
              PlacementDef(name: 'Kifa', c: 4, r: 0, minPlayers: 3),
              PlacementDef(name: 'Kifa', c: 11, r: 3, minPlayers: 3),
              PlacementDef(name: 'Kifa', c: 0, r: 3),
              PlacementDef(name: 'Kifa', c: 10, r: 8),
              PlacementDef(name: 'Kifa', c: 7, r: 10, minPlayers: 4),
              PlacementDef(name: 'Harrow', c: 4, r: 3),
              PlacementDef(name: 'Harrow', c: 10, r: 5),
              PlacementDef(name: 'Harrow', c: 7, r: 2, minPlayers: 3),
              PlacementDef(name: 'Harrow', c: 4, r: 6, minPlayers: 4),
              PlacementDef(name: 'Stormcaller', c: 7, r: 4),
              PlacementDef(
                  name: 'Magic',
                  type: PlacementType.trap,
                  c: 2,
                  r: 3,
                  trapDamage: 3),
              PlacementDef(
                  name: 'Magic',
                  type: PlacementType.trap,
                  c: 9,
                  r: 2,
                  trapDamage: 3),
              PlacementDef(
                  name: 'Magic',
                  type: PlacementType.trap,
                  c: 11,
                  r: 6,
                  trapDamage: 3),
              PlacementDef(name: 'crux', type: PlacementType.ether, c: 6, r: 1),
              PlacementDef(name: 'wind', type: PlacementType.ether, c: 8, r: 7),
              PlacementDef(
                  name: '[A]', type: PlacementType.feature, c: 9, r: 1),
            ],
          ),
          PlacementGroupDef(
            name: 'Reliquary Last',
            terrain: [
              trapMagic(3),
              etherWind(),
              etherCrux(),
            ],
            setup: EncounterSetup(
                box: '9',
                map: '67',
                adversary: '115',
                tiles: '3x Magical Traps'),
            adversaries: [
              EncounterFigureDef(
                name: 'Kifa',
                letter: 'A',
                standeeCount: 6,
                health: 8,
                flies: true,
                affinities: {
                  Ether.wind: 2,
                  Ether.earth: 2,
                  Ether.fire: -1,
                  Ether.water: -1,
                },
              ),
              EncounterFigureDef(
                name: 'Harrow',
                letter: 'B',
                standeeCount: 4,
                health: 18,
                affinities: {
                  Ether.morph: 2,
                  Ether.crux: 2,
                },
              ),
              EncounterFigureDef(
                name: 'Stolen Breath',
                letter: 'C',
                type: AdversaryType.miniboss,
                standeeCount: 4,
                healthFormula: '8*R',
                flies: true,
                affinities: {
                  Ether.fire: -1,
                  Ether.earth: -2,
                  Ether.morph: 1,
                  Ether.water: 1,
                  Ether.crux: 2,
                  Ether.wind: 2,
                },
                onSlain: [
                  milestone('_victory'),
                ],
              ),
            ],
            map: MapDef(
              id: '9.5.reliquary.last',
              columnCount: 13,
              rowCount: 11,
              backgroundRect: Rect.fromLTWH(124.0, 44.0, 1481.0, 1411.0),
              starts: [
                (0, 8),
                (0, 9),
                (1, 9),
                (1, 10),
                (2, 9),
                (3, 10),
              ],
              terrain: {
                (0, 4): TerrainType.difficult,
                (1, 2): TerrainType.barrier,
                (1, 8): TerrainType.difficult,
                (2, 1): TerrainType.barrier,
                (2, 2): TerrainType.object,
                (3, 2): TerrainType.barrier,
                (4, 5): TerrainType.difficult,
                (4, 9): TerrainType.difficult,
                (5, 5): TerrainType.difficult,
                (5, 6): TerrainType.difficult,
                (6, 1): TerrainType.object,
                (6, 5): TerrainType.difficult,
                (8, 0): TerrainType.barrier,
                (8, 7): TerrainType.object,
                (9, 0): TerrainType.barrier,
                (9, 1): TerrainType.object,
                (9, 10): TerrainType.object,
                (10, 0): TerrainType.barrier,
                (10, 4): TerrainType.barrier,
                (10, 9): TerrainType.difficult,
                (11, 4): TerrainType.barrier,
                (11, 5): TerrainType.object,
                (11, 10): TerrainType.object,
                (12, 4): TerrainType.barrier,
                (12, 8): TerrainType.object,
                (12, 9): TerrainType.object,
              },
            ),
            placements: [
              PlacementDef(name: 'Kifa', c: 0, r: 3),
              PlacementDef(name: 'Kifa', c: 7, r: 10, minPlayers: 4),
              PlacementDef(name: 'Kifa', c: 10, r: 8),
              PlacementDef(name: 'Kifa', c: 11, r: 3, minPlayers: 3),
              PlacementDef(name: 'Harrow', c: 4, r: 3),
              PlacementDef(name: 'Harrow', c: 4, r: 6, minPlayers: 4),
              PlacementDef(name: 'Harrow', c: 7, r: 2, minPlayers: 3),
              PlacementDef(name: 'Harrow', c: 10, r: 5),
              PlacementDef(name: 'Stolen Breath', c: 9, r: 2),
              PlacementDef(
                  name: 'Magic',
                  type: PlacementType.trap,
                  c: 2,
                  r: 3,
                  trapDamage: 3),
              PlacementDef(
                  name: 'Magic',
                  type: PlacementType.trap,
                  c: 11,
                  r: 6,
                  trapDamage: 3),
              PlacementDef(name: 'crux', type: PlacementType.ether, c: 6, r: 1),
              PlacementDef(name: 'wind', type: PlacementType.ether, c: 8, r: 7),
            ],
          ),
          PlacementGroupDef(
            name: 'Archives',
            terrain: [
              trapMagic(3),
              etherWater(),
              etherFire(),
            ],
            setup: EncounterSetup(
                box: '9',
                map: '65',
                adversary: '113',
                tiles: '3x Magical Traps'),
            adversaries: [
              EncounterFigureDef(
                name: 'Briarwog',
                letter: 'A',
                standeeCount: 6,
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
                name: 'Stormcaller',
                letter: 'B',
                standeeCount: 4,
                health: 15,
                flies: true,
                traits: [
                  'This unit gains [DEF] 2 against [r_attack] targeting it.',
                ],
                affinities: {
                  Ether.wind: 2,
                  Ether.crux: 2,
                  Ether.water: 1,
                  Ether.morph: -1,
                  Ether.fire: -1,
                  Ether.earth: -2,
                },
              ),
              EncounterFigureDef(
                name: 'Courslayer',
                letter: 'C',
                standeeCount: 4,
                health: 15,
                affinities: {
                  Ether.wind: 2,
                  Ether.water: 2,
                  Ether.fire: -1,
                  Ether.earth: -1,
                },
              ),
            ],
            map: MapDef(
              id: '9.5.archives',
              columnCount: 13,
              rowCount: 11,
              backgroundRect: Rect.fromLTWH(125.0, 44.0, 1481.0, 1411.0),
              starts: [
                (10, 9),
                (11, 9),
                (11, 10),
                (12, 8),
                (12, 9),
              ],
              terrain: {
                (0, 0): TerrainType.object,
                (0, 1): TerrainType.object,
                (1, 0): TerrainType.object,
                (2, 1): TerrainType.barrier,
                (2, 2): TerrainType.barrier,
                (2, 3): TerrainType.difficult,
                (2, 6): TerrainType.object,
                (2, 7): TerrainType.barrier,
                (2, 8): TerrainType.object,
                (3, 5): TerrainType.difficult,
                (5, 4): TerrainType.barrier,
                (5, 5): TerrainType.object,
                (5, 6): TerrainType.barrier,
                (5, 9): TerrainType.object,
                (5, 10): TerrainType.difficult,
                (6, 9): TerrainType.difficult,
                (7, 1): TerrainType.barrier,
                (7, 2): TerrainType.object,
                (7, 3): TerrainType.object,
                (8, 4): TerrainType.difficult,
                (8, 6): TerrainType.barrier,
                (8, 7): TerrainType.barrier,
                (8, 8): TerrainType.barrier,
                (10, 2): TerrainType.barrier,
                (10, 3): TerrainType.difficult,
                (10, 4): TerrainType.barrier,
                (10, 7): TerrainType.object,
                (11, 0): TerrainType.object,
                (12, 0): TerrainType.object,
                (12, 5): TerrainType.difficult,
              },
            ),
            placements: [
              PlacementDef(name: 'Briarwog', c: 5, r: 1),
              PlacementDef(name: 'Briarwog', c: 9, r: 0, minPlayers: 4),
              PlacementDef(name: 'Briarwog', c: 8, r: 3, minPlayers: 4),
              PlacementDef(name: 'Briarwog', c: 0, r: 4, minPlayers: 3),
              PlacementDef(name: 'Briarwog', c: 3, r: 6),
              PlacementDef(name: 'Briarwog', c: 7, r: 5, minPlayers: 3),
              PlacementDef(name: 'Stormcaller', c: 1, r: 7, minPlayers: 4),
              PlacementDef(name: 'Stormcaller', c: 3, r: 3, minPlayers: 3),
              PlacementDef(name: 'Stormcaller', c: 11, r: 2),
              PlacementDef(name: 'Stormcaller', c: 5, r: 8),
              PlacementDef(name: 'Courslayer', c: 7, r: 4),
              PlacementDef(
                  name: 'Magic',
                  type: PlacementType.trap,
                  c: 3,
                  r: 9,
                  trapDamage: 3),
              PlacementDef(
                  name: 'Magic',
                  type: PlacementType.trap,
                  c: 3,
                  r: 2,
                  trapDamage: 3),
              PlacementDef(
                  name: 'Magic',
                  type: PlacementType.trap,
                  c: 8,
                  r: 0,
                  trapDamage: 3),
              PlacementDef(name: 'fire', type: PlacementType.ether, c: 5, r: 5),
              PlacementDef(
                  name: 'water', type: PlacementType.ether, c: 10, r: 7),
              PlacementDef(
                  name: '[A]', type: PlacementType.feature, c: 2, r: 1),
            ],
          ),
          PlacementGroupDef(
            name: 'Archives Last',
            terrain: [
              trapMagic(3),
              etherWater(),
              etherFire(),
            ],
            setup: EncounterSetup(
                box: '9',
                map: '68',
                adversary: '116',
                tiles: '3x Magical Traps'),
            adversaries: [
              EncounterFigureDef(
                name: 'Briarwog',
                letter: 'A',
                standeeCount: 6,
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
                name: 'Stormcaller',
                letter: 'B',
                standeeCount: 4,
                health: 15,
                flies: true,
                traits: [
                  'This unit gains [DEF] 2 against [r_attack] targeting it.',
                ],
                affinities: {
                  Ether.wind: 2,
                  Ether.crux: 2,
                  Ether.water: 1,
                  Ether.morph: -1,
                  Ether.fire: -1,
                  Ether.earth: -2,
                },
              ),
              EncounterFigureDef(
                name: 'Piercing Gaze',
                letter: 'C',
                type: AdversaryType.miniboss,
                standeeCount: 4,
                healthFormula: '8*R',
                affinities: {
                  Ether.water: 2,
                  Ether.wind: 2,
                  Ether.earth: -1,
                  Ether.fire: -1,
                },
                onSlain: [
                  milestone('_victory'),
                ],
              ),
            ],
            map: MapDef(
              id: '9.5.archives.last',
              columnCount: 13,
              rowCount: 11,
              backgroundRect: Rect.fromLTWH(110.0, 44.0, 1481.0, 1411.0),
              starts: [
                (10, 9),
                (11, 9),
                (11, 10),
                (12, 8),
                (12, 9),
              ],
              terrain: {
                (0, 0): TerrainType.object,
                (0, 1): TerrainType.object,
                (1, 0): TerrainType.object,
                (2, 1): TerrainType.barrier,
                (2, 2): TerrainType.barrier,
                (2, 3): TerrainType.difficult,
                (2, 6): TerrainType.object,
                (2, 7): TerrainType.barrier,
                (2, 8): TerrainType.object,
                (3, 5): TerrainType.difficult,
                (5, 4): TerrainType.barrier,
                (5, 5): TerrainType.object,
                (5, 6): TerrainType.barrier,
                (5, 9): TerrainType.object,
                (5, 10): TerrainType.difficult,
                (6, 9): TerrainType.difficult,
                (7, 1): TerrainType.barrier,
                (7, 2): TerrainType.object,
                (7, 3): TerrainType.object,
                (8, 4): TerrainType.difficult,
                (8, 6): TerrainType.barrier,
                (8, 7): TerrainType.barrier,
                (8, 8): TerrainType.barrier,
                (10, 2): TerrainType.barrier,
                (10, 3): TerrainType.difficult,
                (10, 4): TerrainType.barrier,
                (10, 7): TerrainType.object,
                (11, 0): TerrainType.object,
                (12, 0): TerrainType.object,
                (12, 5): TerrainType.difficult,
              },
            ),
            placements: [
              PlacementDef(name: 'Briarwog', c: 7, r: 5, minPlayers: 3),
              PlacementDef(name: 'Briarwog', c: 8, r: 3, minPlayers: 4),
              PlacementDef(name: 'Briarwog', c: 5, r: 1),
              PlacementDef(name: 'Briarwog', c: 3, r: 6),
              PlacementDef(name: 'Stormcaller', c: 11, r: 2),
              PlacementDef(name: 'Stormcaller', c: 5, r: 8),
              PlacementDef(name: 'Stormcaller', c: 1, r: 7, minPlayers: 4),
              PlacementDef(name: 'Stormcaller', c: 7, r: 4),
              PlacementDef(name: 'Piercing Gaze', c: 3, r: 2),
              PlacementDef(
                  name: 'Magic',
                  type: PlacementType.trap,
                  c: 3,
                  r: 9,
                  trapDamage: 3),
              PlacementDef(
                  name: 'Magic',
                  type: PlacementType.trap,
                  c: 8,
                  r: 0,
                  trapDamage: 3),
              PlacementDef(
                  name: 'water', type: PlacementType.ether, c: 10, r: 7),
              PlacementDef(name: 'fire', type: PlacementType.ether, c: 5, r: 5),
            ],
          ),
          PlacementGroupDef(
            name: 'Mausoleum',
            terrain: [
              trapMagic(3),
              etherEarth(),
              etherMorph(),
            ],
            setup: EncounterSetup(
                box: '9',
                map: '66',
                adversary: '114',
                tiles: '3x Magical Traps'),
            adversaries: [
              EncounterFigureDef(
                name: 'Wrathbone',
                letter: 'A',
                standeeCount: 3,
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
              ),
              EncounterFigureDef(
                name: 'Courslayer',
                letter: 'B',
                standeeCount: 4,
                health: 15,
                affinities: {
                  Ether.wind: 2,
                  Ether.water: 2,
                  Ether.fire: -1,
                  Ether.earth: -1,
                },
              ),
              EncounterFigureDef(
                name: 'Harrow',
                letter: 'C',
                standeeCount: 4,
                health: 18,
                affinities: {
                  Ether.morph: 2,
                  Ether.crux: 2,
                },
              ),
            ],
            map: MapDef(
              id: '9.5.mausoleum',
              columnCount: 13,
              rowCount: 11,
              backgroundRect: Rect.fromLTWH(110.0, 44.0, 1481.0, 1411.0),
              starts: [
                (4, 0),
                (5, 0),
                (6, 0),
                (7, 0),
                (8, 0),
              ],
              terrain: {
                (0, 0): TerrainType.difficult,
                (1, 0): TerrainType.difficult,
                (1, 3): TerrainType.object,
                (1, 5): TerrainType.object,
                (1, 7): TerrainType.difficult,
                (4, 3): TerrainType.object,
                (4, 6): TerrainType.difficult,
                (5, 4): TerrainType.object,
                (5, 7): TerrainType.difficult,
                (6, 3): TerrainType.object,
                (6, 6): TerrainType.object,
                (6, 9): TerrainType.object,
                (7, 4): TerrainType.difficult,
                (7, 7): TerrainType.object,
                (8, 3): TerrainType.difficult,
                (8, 6): TerrainType.object,
                (8, 9): TerrainType.object,
                (11, 3): TerrainType.object,
                (11, 5): TerrainType.difficult,
                (11, 7): TerrainType.object,
                (11, 10): TerrainType.object,
                (12, 9): TerrainType.object,
              },
            ),
            placements: [
              PlacementDef(name: 'Wrathbone', c: 3, r: 8),
              PlacementDef(name: 'Wrathbone', c: 10, r: 8, minPlayers: 3),
              PlacementDef(name: 'Wrathbone', c: 12, r: 1, minPlayers: 4),
              PlacementDef(name: 'Courslayer', c: 1, r: 4),
              PlacementDef(name: 'Courslayer', c: 0, r: 2, minPlayers: 4),
              PlacementDef(name: 'Courslayer', c: 6, r: 4, minPlayers: 3),
              PlacementDef(name: 'Courslayer', c: 10, r: 5),
              PlacementDef(name: 'Harrow', c: 9, r: 7),
              PlacementDef(
                  name: 'Magic',
                  type: PlacementType.trap,
                  c: 1,
                  r: 6,
                  trapDamage: 3),
              PlacementDef(
                  name: 'Magic',
                  type: PlacementType.trap,
                  c: 6,
                  r: 8,
                  trapDamage: 3),
              PlacementDef(
                  name: 'Magic',
                  type: PlacementType.trap,
                  c: 11,
                  r: 4,
                  trapDamage: 3),
              PlacementDef(
                  name: 'morph', type: PlacementType.ether, c: 6, r: 6),
              PlacementDef(
                  name: 'earth', type: PlacementType.ether, c: 6, r: 3),
              PlacementDef(
                  name: '[A]', type: PlacementType.feature, c: 6, r: 9),
            ],
          ),
          PlacementGroupDef(
            name: 'Mausoleum Last',
            terrain: [
              trapMagic(3),
              etherEarth(),
              etherMorph(),
            ],
            setup: EncounterSetup(
                box: '9',
                map: '69',
                adversary: '117',
                tiles: '3x Magical Traps'),
            adversaries: [
              EncounterFigureDef(
                name: 'Wrathbone',
                letter: 'A',
                standeeCount: 3,
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
              ),
              EncounterFigureDef(
                name: 'Courslayer',
                letter: 'B',
                standeeCount: 4,
                health: 15,
                affinities: {
                  Ether.wind: 2,
                  Ether.water: 2,
                  Ether.fire: -1,
                  Ether.earth: -1,
                },
              ),
              EncounterFigureDef(
                name: 'Heavy Hand',
                letter: 'C',
                type: AdversaryType.miniboss,
                standeeCount: 4,
                healthFormula: '10*R',
                affinities: {
                  Ether.morph: 2,
                  Ether.crux: 2,
                },
                onSlain: [
                  milestone('_victory'),
                ],
              ),
            ],
            map: MapDef(
              id: '9.5.mausoleum.last',
              columnCount: 13,
              rowCount: 11,
              backgroundRect: Rect.fromLTWH(125.0, 44.0, 1481.0, 1411.0),
              starts: [
                (4, 0),
                (5, 0),
                (6, 0),
                (7, 0),
                (8, 0),
              ],
              terrain: {
                (0, 0): TerrainType.difficult,
                (1, 0): TerrainType.difficult,
                (1, 3): TerrainType.object,
                (1, 5): TerrainType.object,
                (1, 7): TerrainType.difficult,
                (4, 3): TerrainType.object,
                (4, 6): TerrainType.difficult,
                (4, 9): TerrainType.difficult,
                (5, 4): TerrainType.object,
                (5, 7): TerrainType.difficult,
                (6, 3): TerrainType.object,
                (6, 6): TerrainType.object,
                (6, 9): TerrainType.object,
                (7, 4): TerrainType.difficult,
                (8, 3): TerrainType.difficult,
                (8, 9): TerrainType.object,
                (11, 3): TerrainType.object,
                (11, 5): TerrainType.difficult,
                (11, 7): TerrainType.object,
                (11, 10): TerrainType.object,
                (12, 9): TerrainType.object,
              },
            ),
            placements: [
              PlacementDef(name: 'Wrathbone', c: 3, r: 8),
              PlacementDef(name: 'Wrathbone', c: 10, r: 8, minPlayers: 3),
              PlacementDef(name: 'Wrathbone', c: 12, r: 1, minPlayers: 4),
              PlacementDef(name: 'Courslayer', c: 1, r: 4),
              PlacementDef(name: 'Courslayer', c: 6, r: 4, minPlayers: 3),
              PlacementDef(name: 'Courslayer', c: 10, r: 5),
              PlacementDef(name: 'Courslayer', c: 0, r: 2, minPlayers: 4),
              PlacementDef(name: 'Heavy Hand', c: 6, r: 8),
              PlacementDef(
                  name: 'Magic',
                  type: PlacementType.trap,
                  c: 1,
                  r: 6,
                  trapDamage: 3),
              PlacementDef(
                  name: 'Magic',
                  type: PlacementType.trap,
                  c: 11,
                  r: 4,
                  trapDamage: 3),
              PlacementDef(
                  name: 'earth', type: PlacementType.ether, c: 6, r: 3),
              PlacementDef(
                  name: 'morph', type: PlacementType.ether, c: 6, r: 6),
            ],
          ),
        ],
      );

  static EncounterDef get encounter9dot6 => EncounterDef(
      questId: '9',
      number: '6',
      title: 'Something Worth Wishing For',
      setup: EncounterSetup(box: '9', map: '70', adversary: '118-119'),
      victoryDescription: 'Slay Eclipse.',
      roundLimit: 99,
      terrain: [
        etherFire(lodestone: true),
        etherEarth(lodestone: true),
        etherWater(lodestone: true),
        etherWind(lodestone: true),
        etherCrux(lodestone: true),
        etherMorph(lodestone: true),
      ],
      baseLystReward: 0,
      milestone: CampaignMilestone.milestone9dot6,
      campaignLink:
          'Read campaign conclusion, “**A New Age Dawns**”, [campaign] **79**.',
      challenges: [
        'Each time a Rover places an ether field in an enemy space, they place the same ether field in their own space.',
        'After Eclipse attacks a Rover, that Rover must reroll all non-[DIM] dice in their personal and infusion pools.',
        'Rovers suffer [DMG]1 each time they generate an ether dice.',
      ],
      dialogs: [
        introductionFromText('quest_9_encounter_6_intro'),
      ],
      onLoad: [
        dialog('Introduction'),
        rules('Vengeance',
            '''*Eclipse is a cruel and unrelenting fighter*. This encounter does not have a round limit, but you will still have to keep track of rounds. On every 4th round, Eclipse gains +1 [DMG] to all attacks they perform. This is an accumulative bonus, meaning on the 8th round this bonus is +2 [DMG], on the 12th round the bonus is +3 [DMG], etc.'''),
        rules('Invincible',
            '''*Eclipse has absorbed an unhealthy amount of ether, making themselves nearly invincible.* To stand a chance of taking down Eclipse you will have to sever their connection to the Ether Lodestone. To do this, you’ll have to place [DIM] dice onto Rx2 Ether Lodestone spaces. Each Ether Lodestone space can only have one [DIM] dice on it. Rovers gain two new abilities for this phase:

**Drain Ether**: Return one of your ether dice from your personal pool to the general pool and gain one [DIM] dice.

**Infuse Dim**: Place one [DIM] dice from your personal pool onto an Ether Lodestone space within [Range] 1.

**Note**: **Drain Ether** and **Infuse Dim** are abilities and require an ability activation to use.

**Note**: [DIM] dice can not be removed from the Ether Lodestone.'''),
        codexLink('Severed Connection',
            number: 168,
            body:
                '''At the end of the round, if there are [dim] dice on Rx2 Ether Lodestone spaces, read [title], [codex] 76.'''),
      ],
      onMilestone: {
        '_phase3': [
          codex(169),
          placementGroup('Andiron',
              title: 'Revenge',
              body:
                  '*Andiron has recovered and is back in the fight.* Spawn Andiron, at maximum [HP] and using the large base adapter, as close to space [B] as possible.'),
          rules('Addiction',
              'Eclipse still follows the rules for addiction, grabbing ether dice from ether nodes around the map.'),
          rules('Limitless Rage',
              'Eclipse and Andiron can not be slain, not yet. If either of their [HP] is brought to 0, they are not slain and are not removed from the map. There must be a way to defeat both of them. Keep fighting and look for an opportunity to win.'),
          codexLink('Take the Ether',
              number: 170,
              body:
                  '''At the end of the round, if both Eclipse and Andiron individually are at R or less, read [title], [codex] 77.'''),
        ],
        '_eclipse_downed': [
          milestone('_phase4',
              condition: MilestoneCondition('_andiron_downed')),
        ],
        '_andiron_downed': [
          milestone('_phase4',
              condition: MilestoneCondition('_eclipse_downed')),
        ],
        '_phase4': [
          removeRule('Limitless Rage'),
          removeRule('Addiction'),
          codex(170),
          remove('Andiron', silent: true),
          remove('Eclipse', silent: true),
          placementGroup('Eclipse Ether Ascended',
              title: 'Eclipse Ether Ascended',
              body:
                  '''Remove Eclipse and Andiron from the map. Spawn Eclipse Ether Ascended, at maximum [HP] and using the large base adapter, as close to space [C] as you can. Place ether dice onto the statistic block of Eclipse Ether Ascended until there is one of each ether type: [Fire], [Water], [Earth], [Wind], [Crux], and [Morph].
'''),
          rules('Eclipse',
              '''*Eclipse realizes their power is fading and is growing desperate. They leap back onto the back of Andiron. This is your chance, the shards of ether in their body is radiating extraordinary power. If you can take them, Eclipse should be weak enough to be defeated.*

Once each round, one Rover may perform the following ability:

**Take Ether**: If you are within [Range] 1 of Eclipse Ether Ascended, take one ether dice of your choice from their statistic block and add it to your personal pool.

**Note**: **Take Ether** is an ability and requires an ability activation to use.

Remove all ether dice from Eclipse Ether Ascended and reduce their hit points to 0 to slay them.'''),
          codexLink('Eclipsed',
              number: 171,
              body:
                  '''At the end of the round, if Eclipse Ether Ascended is at 0 and has no ether dice on their statistic block, read [title], [codex] 78.'''),
        ],
        '_victory': [
          remove('Eclipse Ether Ascended', silent: true),
          codex(171),
          victory(body: '''Congratulations, you have won!  The campaign is over.

Remove the party items “**Ethereal Catena**” and “**Ethereal Aegis**”. Their power is spent and can no longer be used.'''),
          codex(172),
        ],
      },
      onDidStartRound: [
        subtitle('Vengeance: +1 [DMG]', condition: RoundCondition(4)),
        subtitle('Vengeance: +2 [DMG]', condition: RoundCondition(8)),
        subtitle('Vengeance: +3 [DMG]', condition: RoundCondition(12)),
        subtitle('Vengeance: +4 [DMG]', condition: RoundCondition(16)),
        subtitle('Vengeance: +5 [DMG]', condition: RoundCondition(20)),
        subtitle('Vengeance: +6 [DMG]', condition: RoundCondition(24)),
        subtitle('Vengeance: +7 [DMG]', condition: RoundCondition(28)),
        subtitle('Vengeance: +8 [DMG]', condition: RoundCondition(32)),
        subtitle('Vengeance: +9 [DMG]', condition: RoundCondition(36)),
        subtitle('Vengeance: +10 [DMG]', condition: RoundCondition(40)),
        subtitle('Vengeance: +11 [DMG]', condition: RoundCondition(44)),
        subtitle('Vengeance: +12 [DMG]', condition: RoundCondition(48)),
        subtitle('Vengeance: +13 [DMG]', condition: RoundCondition(52)),
        subtitle('Vengeance: +14 [DMG]', condition: RoundCondition(56)),
        subtitle('Vengeance: +15 [DMG]', condition: RoundCondition(60)),
        subtitle('Vengeance: +16 [DMG]', condition: RoundCondition(64)),
        subtitle('Vengeance: +17 [DMG]', condition: RoundCondition(68)),
        subtitle('Vengeance: +18 [DMG]', condition: RoundCondition(72)),
        subtitle('Vengeance: +19 [DMG]', condition: RoundCondition(76)),
        subtitle('Vengeance: +20 [DMG]', condition: RoundCondition(80)),
      ],
      startingMap: MapDef(
        id: '9.6',
        columnCount: 13,
        rowCount: 11,
        backgroundRect: Rect.fromLTWH(110.0, 44.0, 1481.0, 1411.0),
        starts: [
          (0, 3),
          (0, 5),
          (4, 0),
          (4, 9),
          (8, 0),
          (8, 9),
          (12, 3),
          (12, 5),
        ],
        terrain: {
          (0, 1): TerrainType.object,
          (0, 7): TerrainType.object,
          (3, 6): TerrainType.object,
          (4, 5): TerrainType.object,
          (4, 6): TerrainType.object,
          (5, 4): TerrainType.object,
          (5, 5): TerrainType.object,
          (5, 6): TerrainType.object,
          (5, 7): TerrainType.object,
          (6, 0): TerrainType.object,
          (6, 3): TerrainType.object,
          (6, 4): TerrainType.object,
          (6, 5): TerrainType.object,
          (6, 6): TerrainType.object,
          (6, 9): TerrainType.object,
          (7, 3): TerrainType.object,
          (7, 4): TerrainType.object,
          (7, 5): TerrainType.object,
          (12, 1): TerrainType.object,
          (12, 7): TerrainType.object,
        },
      ),
      overlays: [
        EncounterFigureDef(
          name: 'Ether Lodestone',
          large: true,
          possibleTokens: [
            'RxDim',
            'RxDim',
          ],
          onWillEndRound: [
            milestone('_phase2', condition: TokenCountCondition('2*R')),
          ],
        )
      ],
      adversaries: [
        EncounterFigureDef(
          name: 'Eclipse Mounted',
          letter: 'A',
          type: AdversaryType.boss,
          standeeCount: 1,
          healthFormula: '25*R',
          defense: 2,
          large: true,
          immuneToDamage: true,
          affinities: {
            Ether.fire: 1,
            Ether.wind: 1,
            Ether.water: 1,
            Ether.earth: 1,
            Ether.morph: 2,
            Ether.crux: 2,
          },
          onMilestone: {
            '_phase2': [
              removeRule('Invincible'),
              remove('Ether Lodestone', silent: true),
              codex(168),
              replace('Eclipse',
                  title: 'Eclipse',
                  body:
                      '''Remove Eclipse Mounted from the map. Spawn Eclipse, at maximum [HP] and using a normal one hex base, as close to space [A] as possible.'''),
              rules('Addiction',
                  '''*You have blown Eclipse from off the back of Andiron. They are desperate to regain what they have lost.*

If an ether node has had its ether dice removed, replace that ether dice. If a unit occupies the space of an inactive ether node, move that unit out of the space, but as close as possible to the now active ether node.

If Eclipse ends their turn within [Range] 1 of an active ether node, take the ether dice from that node and place it on their statistic block.'''),
              rules('Limitless Rage',
                  'Eclipse can not be slain, not yet. If their [HP] is brought to 0, they are not slain and are not removed from the map. There must be a way to defeat them. Keep fighting and look for an opportunity to win.'),
              codexLink('Loyal to the End',
                  number: 169,
                  body:
                      '''At the end of the round, if Eclipse is at 10xR or less, read [title], [codex] 77.'''),
            ]
          },
        ),
        EncounterFigureDef(
          name: 'Eclipse',
          letter: 'B',
          type: AdversaryType.boss,
          standeeCount: 1,
          healthFormula: '20*R',
          defense: 1,
          unslayable: true,
          possibleTokens: [
            Ether.fire.label,
            Ether.water.label,
            Ether.wind.label,
            Ether.earth.label,
            Ether.crux.label,
            Ether.morph.label,
          ],
          traits: [
            'For each ether dice on their statistic block, Eclipse gains the following bonus.',
            '[Fire]: At end of turn, enemies within [Range] 1 suffer [DMG]2',
            '[Water]: +2 movement points',
            '[Wind]: Reduce damage suffered by 2 ',
            '[Earth]: At end of turn, recover [RCV] R',
            '[Crux]: +1 [DMG] to all attacks',
            '[Morph]: All enemies within [Range] 1 gain -1 [DMG]',
          ],
          affinities: {
            Ether.fire: 1,
            Ether.wind: 1,
            Ether.morph: 2,
          },
          onWillEndRound: [
            milestone('_phase3', condition: HealthCondition('10*R-X+1')),
            milestone('_eclipse_downed', condition: HealthCondition('R-X+1')),
          ],
        ),
        EncounterFigureDef(
          name: 'Andiron',
          letter: 'C',
          type: AdversaryType.boss,
          standeeCount: 1,
          healthFormula: '20*R',
          defense: 1,
          large: true,
          unslayable: true,
          traits: [
            '''[React] Eclipse suffers damage caused by a Rover:
            
Logic: Wants to attack the Rover that damaged Eclipse.
[Jump] 6
[m_attack] | [Range] 1 | [DMG]4'''
          ],
          affinities: {
            Ether.earth: 1,
            Ether.water: 1,
            Ether.crux: 2,
          },
          onWillEndRound: [
            milestone('_andiron_downed', condition: HealthCondition('R-X+1')),
          ],
        ),
        EncounterFigureDef(
          name: 'Eclipse Ether Ascended',
          letter: 'D',
          type: AdversaryType.boss,
          standeeCount: 1,
          healthFormula: '35*R',
          defense: 2,
          large: true,
          unslayable: true,
          possibleTokens: [
            Ether.fire.label,
            Ether.water.label,
            Ether.wind.label,
            Ether.earth.label,
            Ether.crux.label,
            Ether.morph.label,
          ],
          startingTokens: [
            Ether.fire.label,
            Ether.water.label,
            Ether.wind.label,
            Ether.earth.label,
            Ether.crux.label,
            Ether.morph.label,
          ],
          traits: [
            'For each ether dice on their statistic block, Eclipse gains the following bonus.',
            '[Fire]: At end of turn, enemies within [Range] 1 suffer [DMG]2',
            '[Water]: +2 movement points',
            '[Wind]: Reduce damage suffered by 2',
            '[Earth]: At end of turn, recover [RCV] R',
            '[Crux]: +1 [DMG] to all attacks',
            '[Morph]: All enemies within [Range] 1 gain -1 [DMG]',
          ],
          affinities: {
            Ether.fire: 1,
            Ether.wind: 1,
            Ether.water: 1,
            Ether.earth: 1,
            Ether.morph: 3,
            Ether.crux: 3,
          },
          onWillEndRound: [
            milestone('_victory', conditions: [
              TokenCountCondition('0'),
              HealthCondition('-X+1'),
            ]),
          ],
        ),
      ],
      placements: const [
        PlacementDef(name: 'Eclipse Mounted', c: 9, r: 6),
        PlacementDef(
            name: 'Ether Lodestone', type: PlacementType.object, c: 3, r: 6),
        PlacementDef(name: 'fire', type: PlacementType.ether, c: 0, r: 1),
        PlacementDef(name: 'crux', type: PlacementType.ether, c: 6, r: 0),
        PlacementDef(name: 'earth', type: PlacementType.ether, c: 12, r: 1),
        PlacementDef(name: 'morph', type: PlacementType.ether, c: 12, r: 7),
        PlacementDef(name: 'water', type: PlacementType.ether, c: 6, r: 9),
        PlacementDef(name: 'wind', type: PlacementType.ether, c: 0, r: 7),
        PlacementDef(name: '[A]', type: PlacementType.feature, c: 2, r: 8),
        PlacementDef(name: '[B]', type: PlacementType.feature, c: 3, r: 3),
        PlacementDef(name: '[C]', type: PlacementType.feature, c: 9, r: 6),
      ],
      placementGroups: [
        PlacementGroupDef(name: 'Andiron', placements: [
          PlacementDef(name: 'Andiron', c: 3, r: 3),
        ]),
        PlacementGroupDef(name: 'Eclipse Ether Ascended', placements: [
          PlacementDef(
            name: 'Eclipse Ether Ascended',
            c: 9,
            r: 6,
          ),
        ]),
      ]);
}
