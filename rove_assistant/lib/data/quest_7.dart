import 'dart:ui';
import 'encounter_def_utils.dart';
import 'package:rove_data_types/rove_data_types.dart';

extension Quest7 on EncounterDef {
  static EncounterDef get encounter7dot1 => EncounterDef(
        questId: '7',
        number: '1',
        title: 'The Oldest and Strongest Emotion',
        setup: EncounterSetup(
            box: '3/7', map: '48', adversary: '80-81', tiles: '4x Hatchery'),
        victoryDescription: 'Slay all adversaries, not including the haunt.',
        roundLimit: 8,
        terrain: [
          dangerousBones(1),
          trapHatchery(3),
          etherCrux(),
          etherMorph(),
        ],
        baseLystReward: 25,
        campaignLink:
            'Encounter 7.2 - “**Flee From The Light**”, [campaign] **108**.',
        challenges: [
          'When Countdown to Doom triggers, Rovers also suffer [DMG] X, where X equals the number of ether dice in that Rover’s personal pool. This damage can not be blocked by line-of-sight rules.',
          'The recovery effect of Countdown to Doom gains +2 [RCV].',
          'Rovers can’t benefit from the effects of [Crux] nodes and can’t take ether dice from them. Adversaries are affected by [Crux] nodes when within [Range] 1-2.',
        ],
        dialogs: [
          introductionFromText('quest_7_encounter_1_intro'),
          EncounterDialogDef(
            title: 'Countdown to Doom',
            type: EncounterDialogDef.rulesType,
            body:
                'All Rovers suffer [DMG] 2 while all adversaries recover [RCV] 2. Units that are not within line-of-sight of the source of the dark ether [A] ignore this special rule.',
          )
        ],
        onLoad: [
          dialog('Introduction'),
          rules('Countdown to Doom',
              'A dark ether is pulsing from the Bonespire, tormenting the land. The source of this dark energy is marked on the map as coming from [A]. During the start phase of rounds 2, 4, 6, and 8 all Rovers suffer [DMG]2 while all adversaries recover [RCV] 2. Units that are not within line-of-sight of the source of the dark ether [A] ignore this special rule. Spaces that are not within line-of-sight of [A] have been marked with a white outline to make these unaffected spaces easier to identify.'),
          rules('Ozendyn',
              'Ozendyn is a character ally to Rovers. For this encounter Ozendyn will only use the “Picket” side and will not flip.'),
          codexLink('The Thing That Is Hidden',
              number: 130,
              body: '''If the haunt is slain, read [title], [codex] 62.'''),
          codexLink('The Poison Of Life',
              number: 131,
              body: '''When the azoth is slain, read [title], [codex] 62.'''),
          codexLink('A Dangerous Road',
              number: 132,
              body:
                  '''Immediately when all adversaries are slain, including the broken vessels that spawn from slaying a fell cradle, but not including the haunt, read [title], [codex] 62.'''),
        ],
        onDidStartRound: [
          dialog('Countdown to Doom', condition: RoundCondition(2)),
          dialog('Countdown to Doom', condition: RoundCondition(4)),
          dialog('Countdown to Doom', condition: RoundCondition(6)),
          dialog('Countdown to Doom', condition: RoundCondition(8)),
        ],
        onMilestone: {
          '_all_slayed': [
            codex(132),
            victory(),
          ]
        },
        startingMap: MapDef(
          id: '7.1',
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
            (0, 7): TerrainType.object,
            (1, 2): TerrainType.object,
            (1, 4): TerrainType.barrier,
            (1, 9): TerrainType.difficult,
            (2, 6): TerrainType.barrier,
            (2, 7): TerrainType.dangerous,
            (4, 0): TerrainType.object,
            (5, 4): TerrainType.dangerous,
            (6, 5): TerrainType.object,
            (6, 7): TerrainType.barrier,
            (7, 2): TerrainType.dangerous,
            (7, 8): TerrainType.difficult,
            (7, 9): TerrainType.dangerous,
            (7, 10): TerrainType.difficult,
            (8, 0): TerrainType.difficult,
            (9, 0): TerrainType.difficult,
            (9, 7): TerrainType.barrier,
            (10, 0): TerrainType.difficult,
            (11, 4): TerrainType.barrier,
            (11, 6): TerrainType.object,
            (12, 0): TerrainType.object,
            (12, 6): TerrainType.dangerous,
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
            name: 'Stomaw',
            letter: 'A',
            standeeCount: 8,
            health: 11,
            traits: [
              'When this unit attacks, if at least one of its allies are adjacent to the target, it gains +1 [DMG] to the attack.',
            ],
            affinities: {
              Ether.morph: 2,
              Ether.earth: 1,
              Ether.crux: -1,
              Ether.fire: -2,
            },
            onSlain: [
              milestone('_all_slayed',
                  condition: AllAdversariesSlainExceptCondition('Haunt')),
            ],
          ),
          EncounterFigureDef(
            name: 'Broken Vessel',
            letter: 'B',
            standeeCount: 8,
            health: 7,
            flies: true,
            traits: [
              '''[React] Before this unit is slain, it performs:
              
[m_attack] | [Range] 1-2 | [DMG]2 | [miasma] | [Target] all units''',
            ],
            affinities: {
              Ether.morph: 2,
              Ether.crux: -2,
            },
            onSlain: [
              milestone('_all_slayed',
                  condition: AllAdversariesSlainExceptCondition('Haunt')),
            ],
          ),
          EncounterFigureDef(
            name: 'Fell Cradle',
            letter: 'C',
            standeeCount: 3,
            health: 16,
            traits: [
              '''[React] When this unit is slain:
              
Spawn one Broken Vessel in the space this unit occupied.''',
            ],
            affinities: {
              Ether.morph: 2,
              Ether.crux: -2,
            },
            reactions: [
              EnemyReactionDef(
                  trigger: ReactionTriggerDef(
                      type: RoveEventType.afterSlain,
                      targetKind: TargetKind.self),
                  actions: [
                    RoveAction(
                        type: RoveActionType.spawn,
                        object: 'Broken Vessel',
                        amount: 1)
                  ])
            ],
            onSlain: [
              milestone('_all_slayed',
                  condition: AllAdversariesSlainExceptCondition('Haunt')),
            ],
          ),
          EncounterFigureDef(
            name: 'Azoth',
            letter: 'D',
            type: AdversaryType.miniboss,
            standeeCount: 1,
            healthFormula: '7*R',
            defense: 2,
            large: true,
            immuneToForcedMovement: true,
            affinities: {
              Ether.crux: 2,
              Ether.earth: 1,
              Ether.morph: 1,
              Ether.wind: -1,
              Ether.fire: -2,
            },
            onSlain: [
              codex(131),
              milestone('_all_slayed',
                  condition: AllAdversariesSlainExceptCondition('Haunt')),
            ],
          ),
          EncounterFigureDef(
            name: 'Haunt',
            letter: 'E',
            standeeCount: 4,
            healthFormula: '4*R',
            affinities: {
              Ether.crux: 2,
              Ether.morph: -2,
            },
            onSlain: [
              codex(130),
              item('Multifaceted Icon',
                  body:
                      'The Rover that slayed the haunt gains one “Multifaceted Icon” item. They may equip this item. If they don’t have the required item slot(s) available, they may unequip items as needed.'),
            ],
          ),
        ],
        placements: [
          PlacementDef(name: 'Stomaw', c: 3, r: 3),
          PlacementDef(name: 'Stomaw', c: 2, r: 4, minPlayers: 3),
          PlacementDef(name: 'Stomaw', c: 8, r: 4),
          PlacementDef(name: 'Stomaw', c: 12, r: 3),
          PlacementDef(name: 'Broken Vessel', c: 4, r: 5),
          PlacementDef(name: 'Broken Vessel', c: 10, r: 1, minPlayers: 3),
          PlacementDef(name: 'Broken Vessel', c: 7, r: 0, minPlayers: 3),
          PlacementDef(name: 'Fell Cradle', c: 11, r: 0, minPlayers: 4),
          PlacementDef(name: 'Fell Cradle', c: 2, r: 0),
          PlacementDef(name: 'Azoth', c: 6, r: 3),
          PlacementDef(name: 'Haunt', c: 0, r: 0),
          PlacementDef(name: 'Broken Vessel', c: 3, r: 10),
          PlacementDef(
              name: 'Hatchery',
              type: PlacementType.trap,
              c: 1,
              r: 8,
              trapDamage: 3),
          PlacementDef(
              name: 'Hatchery',
              type: PlacementType.trap,
              c: 4,
              r: 8,
              trapDamage: 3),
          PlacementDef(
              name: 'Hatchery',
              type: PlacementType.trap,
              c: 1,
              r: 5,
              trapDamage: 3),
          PlacementDef(
              name: 'Hatchery',
              type: PlacementType.trap,
              c: 9,
              r: 9,
              trapDamage: 3),
          PlacementDef(name: 'morph', type: PlacementType.ether, c: 0, r: 7),
          PlacementDef(name: 'morph', type: PlacementType.ether, c: 11, r: 6),
          PlacementDef(name: 'crux', type: PlacementType.ether, c: 6, r: 5),
          PlacementDef(name: 'crux', type: PlacementType.ether, c: 4, r: 0),
          PlacementDef(
              name: 'Line-of-sight blocked',
              type: PlacementType.feature,
              c: 0,
              r: 4),
          PlacementDef(
              name: 'Line-of-sight blocked',
              type: PlacementType.feature,
              c: 0,
              r: 5),
          PlacementDef(
              name: 'Line-of-sight blocked',
              type: PlacementType.feature,
              c: 1,
              r: 7),
          PlacementDef(
              name: 'Line-of-sight blocked',
              type: PlacementType.feature,
              c: 1,
              r: 8),
          PlacementDef(
              name: 'Line-of-sight blocked',
              type: PlacementType.feature,
              c: 0,
              r: 8),
          PlacementDef(
              name: 'Line-of-sight blocked',
              type: PlacementType.feature,
              c: 0,
              r: 9),
          PlacementDef(
              name: 'Line-of-sight blocked',
              type: PlacementType.feature,
              c: 1,
              r: 9),
          PlacementDef(
              name: 'Line-of-sight blocked',
              type: PlacementType.feature,
              c: 9,
              r: 9),
          PlacementDef(
              name: 'Line-of-sight blocked',
              type: PlacementType.feature,
              c: 9,
              r: 8),
          PlacementDef(
              name: 'Line-of-sight blocked',
              type: PlacementType.feature,
              c: 10,
              r: 8),
          PlacementDef(
              name: 'Line-of-sight blocked',
              type: PlacementType.feature,
              c: 10,
              r: 9),
          PlacementDef(
              name: 'Line-of-sight blocked',
              type: PlacementType.feature,
              c: 11,
              r: 10),
          PlacementDef(
              name: 'Line-of-sight blocked',
              type: PlacementType.feature,
              c: 6,
              r: 8),
          PlacementDef(
              name: 'Line-of-sight blocked',
              type: PlacementType.feature,
              c: 6,
              r: 9),
          PlacementDef(
              name: 'Line-of-sight blocked',
              type: PlacementType.feature,
              c: 12,
              r: 5),
          PlacementDef(
              name: 'Line-of-sight blocked',
              type: PlacementType.feature,
              c: 12,
              r: 4),
        ],
      );

  static EncounterDef get encounter7dot2 => EncounterDef(
        questId: '7',
        number: '2',
        title: 'Flee from the Light',
        setup: EncounterSetup(
            box: '3/7', map: '49', adversary: '82-83', tiles: '2x Hatchery'),
        victoryDescription: 'Survive for 7 rounds.',
        lossDescription: 'Lose if Ozendyn is slain.',
        extraPhase: 'The Balatronists',
        extraPhaseIndex: 2,
        roundLimit: 7,
        terrain: [
          dangerousBones(1),
          trapHatchery(3),
          etherMorph(),
        ],
        baseLystReward: 10,
        campaignLink:
            'Encounter 7.3 - “**Practical Consequences**”, [campaign] **110**.',
        challenges: [
          'Querists flee after suffering a total of 3 or more damage.',
          'When Countdown to Doom triggers, Rovers must reroll all ether dice in their personal and infusion pools.',
          'When the Scour spawns, Ozendyn is injured. Return him to the nearest starting space. Ozendyn can no longer perform [Dash] or [Jump] actions, and current [HP] can’t exceed half of their maximum [HP].',
        ],
        onLoad: [
          dialog('Introduction'),
          rules('Countdown to Doom',
              '''There are six ether icons placed on the edges of the map. These icons represent possible spawn locations throughout the encounter.

When an adversary is slain, place it off to the side of the map. During the start phase of rounds 2, 4, and 6, for each adversary that is to the side of the map, roll an ether dice from the general pool, then spawn that adversary at the space with the ether icon corresponding to the result that was just rolled.'''),
          rules('Ozendyn',
              'Ozendyn is a character ally to Rovers. For this encounter Ozendyn will only use the “Picket” side and will not flip.'),
          rules('Balatronists',
              '''The querists are part of their own faction, The Balatronists, which are allies to Rovers and enemies to adversaries. Units part of The Balatronists follow all the adversary logic rules in the rule book. This faction gains priority after the Adversary faction has gone.'''),
          codexLink('Guarantee of Dark Morbidities',
              number: 133,
              body:
                  '''The first time a stomaw is slain, read [title], [codex] 63.'''),
          codexLink('A Placid Island Of Ignorance',
              number: 134,
              body:
                  '''The first time a broken vessel is slain, read [title], [codex] 63.'''),
          codexLink('Violation Of The Order Of Nature',
              number: 135,
              body:
                  '''The first time a fell cradle is slain, read [title], [codex] 63.'''),
          codexLink('What Has Sunk May Rise',
              number: 136,
              body: '''At the end of round 4, read [title], [codex] 63.'''),
          codexLink('Almost Nobody Dances Sober',
              number: 138,
              body: '''At the end of round 7, read [title], [codex] 64.'''),
        ],
        dialogs: [
          introductionFromText('quest_7_encounter_2_intro'),
        ],
        onDidStartRound: [
          EncounterAction(
              type: EncounterActionType.respawn,
              title: 'Countdown to Doom',
              conditions: [RoundCondition(2)]),
          EncounterAction(
              type: EncounterActionType.respawn,
              title: 'Countdown to Doom',
              conditions: [RoundCondition(4)]),
          EncounterAction(
              type: EncounterActionType.respawn,
              title: 'Countdown to Doom',
              conditions: [RoundCondition(6)])
        ],
        onWillEndRound: [
          milestone('_round_4_end', condition: RoundCondition(4)),
          milestone('_round_7_end', condition: RoundCondition(7)),
        ],
        onMilestone: {
          '_round_4_end': [
            codex(136),
            placementGroup('Scour',
                title: 'Scour',
                body:
                    'Something terrible in the wastes has awakened. Spawn one Scour at the [Morph] icon. Survive.'),
            rules('Scour',
                'Something terrible in the wastes has awakened. Spawn one Scour at the [Morph] icon. Survive.',
                silent: true),
            rules('On Advance',
                'Adversaries in this encounter use the On Advance mechanic, which is found on page 47 of the rulebook.'),
            codexLink('Where Did That Come From?',
                number: 137,
                body: '''If the Scour is slain, read [title], [codex], 64.'''),
          ],
          '_round_7_end': [
            codex(138),
            victory(),
            lyst(
              '10',
              title: 'Querist Rescued',
              condition: IsAliveCondition('Querist#1'),
            ),
            lyst(
              '10',
              title: 'Querist Rescued',
              condition: IsAliveCondition('Querist#2'),
            ),
            lyst(
              '10',
              title: 'Querist Rescued',
              condition: IsAliveCondition('Querist#3'),
            ),
            item('Caucus Thesis',
                title: 'No Querists Fled The Fight',
                condition: IsSlainCondition(
                  'Querist',
                  countFormula: '0',
                )),
            milestone(CampaignMilestone.milestone7dot2Querists3,
                condition: IsSlainCondition(
                  'Querist',
                  countFormula: '0',
                )),
            milestone(CampaignMilestone.milestone7dot2Querists2,
                condition: IsSlainCondition(
                  'Querist',
                  countFormula: '1',
                )),
            milestone(CampaignMilestone.milestone7dot2Querists1,
                condition: IsSlainCondition(
                  'Querist',
                  countFormula: '2',
                )),
            milestone(CampaignMilestone.milestone7dot2Querists0,
                condition: IsSlainCondition(
                  'Querist',
                  countFormula: '3',
                )),
          ]
        },
        startingMap: MapDef(
          id: '7.2',
          columnCount: 13,
          rowCount: 11,
          backgroundRect: Rect.fromLTWH(110.0, 44.0, 1481.0, 1411.0),
          starts: [
            (4, 9),
            (5, 9),
            (6, 8),
            (7, 9),
            (8, 9),
          ],
          terrain: {
            (0, 1): TerrainType.dangerous,
            (0, 5): TerrainType.difficult,
            (0, 7): TerrainType.difficult,
            (1, 6): TerrainType.difficult,
            (1, 7): TerrainType.difficult,
            (2, 9): TerrainType.object,
            (3, 4): TerrainType.dangerous,
            (4, 0): TerrainType.difficult,
            (5, 1): TerrainType.difficult,
            (6, 0): TerrainType.difficult,
            (6, 1): TerrainType.object,
            (6, 5): TerrainType.dangerous,
            (9, 3): TerrainType.object,
            (9, 10): TerrainType.object,
            (10, 6): TerrainType.object,
            (11, 6): TerrainType.difficult,
            (11, 7): TerrainType.difficult,
            (12, 0): TerrainType.object,
            (12, 5): TerrainType.difficult,
            (12, 7): TerrainType.difficult,
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
            name: 'Stomaw',
            letter: 'A',
            standeeCount: 8,
            health: 11,
            respawns: true,
            traits: [
              'When this unit attacks, if at least one of its allies are adjacent to the target, it gains +1 [DMG] to the attack.',
            ],
            affinities: {
              Ether.morph: 2,
              Ether.earth: 1,
              Ether.crux: -1,
              Ether.fire: -2,
            },
            onSlain: [
              codex(133),
            ],
          ),
          EncounterFigureDef(
            name: 'Broken Vessel',
            letter: 'B',
            standeeCount: 8,
            health: 7,
            flies: true,
            respawns: true,
            traits: [
              '''[React] Before this unit is slain, it performs:
              
[m_attack] | [Range] 1-2 | [DMG]2 | [miasma] | [Target] all units''',
            ],
            affinities: {
              Ether.morph: 2,
              Ether.crux: -2,
            },
            onSlain: [
              codex(134),
            ],
          ),
          EncounterFigureDef(
            name: 'Fell Cradle',
            letter: 'C',
            standeeCount: 3,
            health: 16,
            respawns: true,
            traits: [
              '''[React] When this unit is slain:
              
Spawn one Broken Vessel in the space this unit occupied.''',
            ],
            affinities: {
              Ether.morph: 2,
              Ether.crux: -2,
            },
            reactions: [
              EnemyReactionDef(
                  trigger: ReactionTriggerDef(
                      type: RoveEventType.afterSlain,
                      targetKind: TargetKind.self),
                  actions: [
                    RoveAction(
                        type: RoveActionType.spawn,
                        object: 'Broken Vessel',
                        amount: 1)
                  ])
            ],
            onSlain: [codex(135)],
          ),
          EncounterFigureDef(
            name: 'Scour',
            letter: 'D',
            type: AdversaryType.miniboss,
            standeeCount: 1,
            healthFormula: '12*R',
            defense: 1,
            large: true,
            respawns: true,
            traits: [
              'At the start of this unit\'s turn, it recovers [RCV] X. << Where X equals the number of [Morph] nodes on the map.',
            ],
            affinities: {
              Ether.morph: 2,
              Ether.water: 1,
              Ether.earth: 1,
              Ether.fire: -1,
              Ether.crux: -2,
            },
          ),
          EncounterFigureDef(
            name: 'Querist',
            letter: 'E',
            faction: 'The Balatronists',
            standeeCount: 6,
            health: 10,
            traits: [
              '''[React] After this unit suffers damage from any source and it is at 2 or less [HP]:
              
They flee. Remove this unit from the map.''',
            ],
            affinities: {
              Ether.crux: 2,
              Ether.wind: 1,
              Ether.morph: -2,
            },
            reactions: [
              EnemyReactionDef(
                  trigger: ReactionTriggerDef(
                      type: RoveEventType.afterSuffer,
                      condition: HealthCondition('2+(C1*1)-X+1'),
                      targetKind: TargetKind.self),
                  actions: [
                    RoveAction.leave(),
                  ])
            ],
          ),
        ],
        placements: const [
          PlacementDef(name: 'Stomaw', c: 12, r: 9),
          PlacementDef(name: 'Stomaw', c: 8, r: 3, minPlayers: 3),
          PlacementDef(name: 'Broken Vessel', c: 0, r: 0),
          PlacementDef(name: 'Broken Vessel', c: 12, r: 4),
          PlacementDef(name: 'Broken Vessel', c: 0, r: 9, minPlayers: 3),
          PlacementDef(name: 'Broken Vessel', c: 12, r: 8, minPlayers: 3),
          PlacementDef(name: 'Fell Cradle', c: 0, r: 3),
          PlacementDef(name: 'Fell Cradle', c: 4, r: 3, minPlayers: 4),
          PlacementDef(name: 'Fell Cradle', c: 9, r: 0),
          PlacementDef(name: 'Querist', c: 5, r: 10),
          PlacementDef(name: 'Querist', c: 6, r: 9),
          PlacementDef(name: 'Querist', c: 7, r: 10),
          PlacementDef(name: 'Stomaw', c: 0, r: 8),
          PlacementDef(
              name: 'Hatchery',
              type: PlacementType.trap,
              c: 0,
              r: 6,
              trapDamage: 3),
          PlacementDef(
              name: 'Hatchery',
              type: PlacementType.trap,
              c: 12,
              r: 6,
              trapDamage: 3),
          PlacementDef(
              name: 'Hatchery',
              type: PlacementType.trap,
              c: 5,
              r: 0,
              trapDamage: 3),
          PlacementDef(name: 'morph', type: PlacementType.ether, c: 6, r: 1),
          PlacementDef(name: 'morph', type: PlacementType.ether, c: 9, r: 3),
          PlacementDef(name: 'morph', type: PlacementType.ether, c: 10, r: 6),
          PlacementDef(name: 'morph', type: PlacementType.ether, c: 12, r: 0),
        ],
        placementGroups: [
          PlacementGroupDef(
            name: 'Scour',
            placements: [
              PlacementDef(name: 'Scour', c: 11, r: 4, onSlain: [
                codex(137),
                item('Scour Brand'),
              ]),
            ],
          ),
        ],
      );
  static EncounterDef get encounter7dot3 => EncounterDef(
        questId: '7',
        number: '3',
        title: 'Practical Consequences',
        setup: EncounterSetup(
            box: '3/7', map: '50', adversary: '84-85', tiles: '4x Hatchery'),
        victoryDescription: 'Slay all adversaries.',
        lossDescription: 'Lose if Ozendyn is slain.',
        roundLimit: 8,
        extraPhase: 'Star Hunters',
        extraPhaseIndex: 2,
        terrain: [
          dangerousBones(1),
          trapHatchery(3),
          etherMorph(),
        ],
        baseLystReward: 15,
        unlocksRoverLevel: 8,
        campaignLink:
            'Encounter 7.4 - “**Sleeping Abnormalities**”, [campaign] **112**.',
        challenges: [
          'When a harrow gains a [DIM] dice, they recover all of their [HP].',
          'During odd rounds, Star Hunter units gain +1 [DEF].',
          'Countdown to Doom grants an additional +1 [DMG].',
        ],
        dialogs: [
          introductionFromText('quest_7_encounter_3_intro'),
        ],
        onLoad: [
          dialog('Introduction'),
          rules('Countdown to Doom',
              '''A dark ether is pulsing from the Bonespire, tormenting the land. During rounds 2, 4, 6, and 8 all Broken Vessels and Fell Cradles gain +1 [DMG] to all of their attacks.'''),
          rules('Ozendyn',
              '''Ozendyn is a character ally to Rovers. For this encounter Ozendyn will only use the “Picket” side and will not flip.'''),
          rules('Star Hunters',
              '''Harrows, wrathbone, and dyads are part of their own faction, Star Hunters, which are enemies to Rovers and adversaries alike. Units part of Star Hunters follow all the adversary logic rules in the rule book. This faction gains priority after the adversary faction has gone.

Harrows want to take the ether from broken vessels and fell cradles to empower themselves in their macabre rituals. 

Immediately when a broken vessel of fell cradle are slain by a Star Hunter unit, place an ether dice from the general pool into the damage tracker slot of the harrow that is nearest to the slain starling.'''),
          codexLink('The Physiology Of Fear',
              number: 139,
              body:
                  '''The first time a harrow is slain, read [title], [codex] 64.'''),
          codexLink('Inchoate And Rudely Fashioned',
              number: 140,
              body:
                  '''Immediately when all adversaries are slain, including the broken vessels that spawn from slaying a fell cradle, read [title], [codex] 65.'''),
        ],
        onDidStartRound: [
          subtitle('Countdown to Doom', condition: RoundCondition(2)),
          subtitle('', condition: RoundCondition(3)),
          subtitle('Countdown to Doom', condition: RoundCondition(4)),
          subtitle('', condition: RoundCondition(5)),
          subtitle('Countdown to Doom', condition: RoundCondition(6)),
          subtitle('', condition: RoundCondition(7)),
          subtitle('Countdown to Doom', condition: RoundCondition(8)),
        ],
        onMilestone: {
          '_slayed_all': [
            codex(140),
            victory(),
          ]
        },
        startingMap: MapDef(
          id: '7.3',
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
            (1, 4): TerrainType.difficult,
            (1, 7): TerrainType.object,
            (2, 1): TerrainType.object,
            (2, 3): TerrainType.difficult,
            (4, 5): TerrainType.dangerous,
            (4, 8): TerrainType.difficult,
            (5, 0): TerrainType.dangerous,
            (5, 8): TerrainType.difficult,
            (7, 0): TerrainType.difficult,
            (8, 0): TerrainType.difficult,
            (8, 8): TerrainType.dangerous,
            (10, 2): TerrainType.object,
            (10, 6): TerrainType.difficult,
            (10, 7): TerrainType.difficult,
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
            name: 'Broken Vessel',
            letter: 'A',
            standeeCount: 8,
            health: 7,
            flies: true,
            traits: [
              '''[React] Before this unit is slain, it performs:
              
[m_attack] | [Range] 1-2 | [DMG]2 | [miasma] | [Target] all units''',
            ],
            affinities: {
              Ether.crux: -2,
              Ether.morph: 2,
            },
            onSlain: [
              milestone('_slayed_all',
                  condition: AllAdversariesSlainCondition()),
            ],
          ),
          EncounterFigureDef(
            name: 'Fell Cradle',
            letter: 'B',
            standeeCount: 3,
            health: 16,
            traits: [
              '''[React] When this unit is slain:
              
Spawn one Broken Vessel in the space this unit occupied.''',
            ],
            affinities: {
              Ether.crux: -2,
              Ether.morph: 2,
            },
            reactions: [
              EnemyReactionDef(
                  trigger: ReactionTriggerDef(
                      type: RoveEventType.afterSlain,
                      targetKind: TargetKind.self),
                  actions: [
                    RoveAction(
                        type: RoveActionType.spawn,
                        object: 'Broken Vessel',
                        amount: 1)
                  ])
            ],
            onSlain: [
              milestone('_slayed_all',
                  condition: AllAdversariesSlainCondition()),
            ],
          ),
          EncounterFigureDef(
            name: 'Harrow',
            letter: 'C',
            faction: 'Star Hunters',
            standeeCount: 4,
            healthFormula: '16',
            defenseFormula: '1*(T%2)*C2',
            possibleTokens: ['Wild', 'Wild', 'Wild', 'Wild'],
            traits: [
              'For each ether dice this unit has in their damage tracker slot, it gains +2 [DMG] to all of its attacks and +7 to their current and maximum [HP].',
            ],
            affinities: {
              Ether.morph: 2,
              Ether.crux: 2,
            },
            onTokensChanged: [
              function('update_harrow_health'),
            ],
            onSlain: [
              codex(139),
              milestone('_slayed_all',
                  condition: AllAdversariesSlainCondition()),
            ],
          ),
          EncounterFigureDef(
            name: 'Wrathbone',
            letter: 'D',
            faction: 'Star Hunters',
            standeeCount: 2,
            health: 18,
            defenseFormula: '1*(T%2)*C2',
            traits: [
              '[React] At the end of the Rover phase: All enemies within [Range] 1-2 suffer [DMG]1. << Enemies within [Range] 1 suffer an additional [DMG]1.',
            ],
            affinities: {
              Ether.water: -2,
              Ether.earth: 1,
              Ether.fire: 2,
            },
            onSlain: [
              milestone('_slayed_all',
                  condition: AllAdversariesSlainCondition()),
            ],
          ),
          EncounterFigureDef(
            name: 'Dyad',
            letter: 'E',
            faction: 'Star Hunters',
            standeeCount: 8,
            health: 15,
            defenseFormula: '1*(T%2)*C2',
            affinities: {
              Ether.morph: -2,
              Ether.water: 1,
              Ether.crux: 2,
            },
            onSlain: [
              milestone('_slayed_all',
                  condition: AllAdversariesSlainCondition()),
            ],
          ),
        ],
        placements: const [
          PlacementDef(name: 'Broken Vessel', c: 1, r: 0, minPlayers: 3),
          PlacementDef(name: 'Broken Vessel', c: 0, r: 4, minPlayers: 4),
          PlacementDef(name: 'Broken Vessel', c: 2, r: 5),
          PlacementDef(name: 'Broken Vessel', c: 10, r: 5),
          PlacementDef(name: 'Broken Vessel', c: 12, r: 4, minPlayers: 4),
          PlacementDef(name: 'Broken Vessel', c: 11, r: 0, minPlayers: 3),
          PlacementDef(name: 'Fell Cradle', c: 6, r: 0),
          PlacementDef(name: 'Fell Cradle', c: 6, r: 5),
          PlacementDef(name: 'Harrow', c: 8, r: 1),
          PlacementDef(name: 'Harrow', c: 4, r: 3, minPlayers: 4),
          PlacementDef(name: 'Harrow', c: 8, r: 3, minPlayers: 3),
          PlacementDef(name: 'Harrow', c: 4, r: 1),
          PlacementDef(name: 'Wrathbone', c: 0, r: 2),
          PlacementDef(name: 'Wrathbone', c: 9, r: 4, minPlayers: 4),
          PlacementDef(name: 'Dyad', c: 12, r: 2),
          PlacementDef(name: 'Dyad', c: 3, r: 4, minPlayers: 3),
          PlacementDef(
              name: 'Hatchery',
              type: PlacementType.trap,
              c: 0,
              r: 1,
              trapDamage: 3),
          PlacementDef(
              name: 'Hatchery',
              type: PlacementType.trap,
              c: 2,
              r: 9,
              trapDamage: 3),
          PlacementDef(
              name: 'Hatchery',
              type: PlacementType.trap,
              c: 9,
              r: 0,
              trapDamage: 3),
          PlacementDef(
              name: 'Hatchery',
              type: PlacementType.trap,
              c: 12,
              r: 8,
              trapDamage: 3),
          PlacementDef(name: 'morph', type: PlacementType.ether, c: 2, r: 1),
          PlacementDef(name: 'morph', type: PlacementType.ether, c: 1, r: 7),
          PlacementDef(name: 'morph', type: PlacementType.ether, c: 10, r: 2),
        ],
      );

  static EncounterDef get encounter7dot4 => EncounterDef(
        questId: '7',
        number: '4',
        title: 'Sleeping Abnormalities',
        setup: EncounterSetup(
            box: '3/7',
            map: '51',
            adversary: '86-87',
            tiles: '3x Magical Trap'),
        victoryDescription: 'Slay the Borrowed Vessel.',
        lossDescription: 'Lose if Ozendyn is slain.',
        roundLimit: 8,
        terrain: [
          trapMagic(3),
        ],
        baseLystReward: 20,
        campaignLink:
            'Encounter 7.5 - “**Behind Every Masterpiece**”, [campaign] **114**.',
        challenges: [
          'The attack action granted to the Borrowed Vessel by Countdown to Doom gains +3 [Range], [pierce], and [Push] 3.',
          'While there is at least one harrow on the map, Borrowed Vessel gains +2 [DEF].',
          'Harrows gain +2 movement points to all of their movement actions.',
        ],
        dialogs: [
          introductionFromText('quest_7_encounter_4_intro'),
          EncounterDialogDef(
            title: 'Countdown to Doom',
            type: EncounterDialogDef.rulesType,
            body:
                '''A dark ether is pulsing from Bazhar’s outer ritual deck, tormenting the Bonespire. During the start phase of rounds 2, 4, 6, and 8 all harrows perform:

[Dash] 2
[m_attack] | [Range] 1 | [DMG]3

The Borrowed Vessel performs:

[Dash] 3
[r_attack] | [Range] 2-3 | [DMG]3 
>> Logic: Retreat. [Dash] 3''',
          ),
        ],
        onLoad: [
          dialog('Introduction'),
          rules('Countdown to Doom',
              '''A dark ether is pulsing from Bazhar’s outer ritual deck, tormenting the Bonespire. During the start phase of rounds 2, 4, 6, and 8 all harrows perform:

[Dash] 2
[m_attack] | [Range] 1 | [DMG]3

The Borrowed Vessel performs:

[Dash] 3
[r_attack] | [Range] 2-3 | [DMG]3 
>> Logic: Retreat. [Dash] 3'''),
          rules('Ozendyn',
              '''Ozendyn is a character ally to Rovers. For this encounter Ozendyn will only use the “Picket” side and will not flip.'''),
          codexLink('A Loss Of Identity',
              number: 141,
              body:
                  '''Immediately when the Borrowed Vessel is slain, read [title], [codex] 65.'''),
        ],
        onDidStartRound: [
          dialog('Countdown to Doom', condition: RoundCondition(2)),
          dialog('Countdown to Doom', condition: RoundCondition(4)),
          dialog('Countdown to Doom', condition: RoundCondition(6)),
          dialog('Countdown to Doom', condition: RoundCondition(8)),
        ],
        startingMap: MapDef(
          id: '7.4',
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
            (0, 0): TerrainType.barrier,
            (0, 1): TerrainType.barrier,
            (0, 6): TerrainType.object,
            (1, 0): TerrainType.barrier,
            (2, 6): TerrainType.difficult,
            (3, 1): TerrainType.object,
            (3, 3): TerrainType.barrier,
            (4, 6): TerrainType.object,
            (5, 0): TerrainType.barrier,
            (5, 5): TerrainType.difficult,
            (5, 8): TerrainType.barrier,
            (5, 10): TerrainType.object,
            (7, 0): TerrainType.barrier,
            (7, 3): TerrainType.difficult,
            (8, 7): TerrainType.difficult,
            (9, 5): TerrainType.barrier,
            (10, 7): TerrainType.object,
            (11, 0): TerrainType.barrier,
            (11, 10): TerrainType.barrier,
            (12, 0): TerrainType.barrier,
            (12, 1): TerrainType.barrier,
            (12, 3): TerrainType.object,
            (12, 4): TerrainType.object,
            (12, 5): TerrainType.object,
            (12, 8): TerrainType.barrier,
            (12, 9): TerrainType.barrier,
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
            name: 'Harrow',
            letter: 'A',
            standeeCount: 4,
            health: 16,
            affinities: {
              Ether.morph: 2,
              Ether.crux: 2,
            },
          ),
          EncounterFigureDef(
            name: 'Borrowed Vessel',
            letter: 'B',
            type: AdversaryType.miniboss,
            standeeCount: 1,
            healthFormula: '10*R',
            affinities: {
              Ether.earth: 1,
              Ether.fire: 1,
              Ether.water: 1,
              Ether.wind: 1,
            },
          ),
          EncounterFigureDef(
            name: 'Wrathbone',
            letter: 'C',
            standeeCount: 2,
            health: 18,
            traits: [
              '[React] At the end of the Rover phase: All enemies within [Range] 1-2 suffer [DMG]1. << Enemies within [Range] 1 suffer an additional [DMG]1.',
            ],
            affinities: {
              Ether.fire: 2,
              Ether.earth: 1,
              Ether.water: -2,
            },
          ),
          EncounterFigureDef(
            name: 'Dyad',
            letter: 'D',
            standeeCount: 8,
            health: 15,
            affinities: {
              Ether.crux: 2,
              Ether.water: 1,
              Ether.morph: -2,
            },
          ),
        ],
        placements: [
          PlacementDef(name: 'Harrow', c: 4, r: 4),
          PlacementDef(name: 'Harrow', c: 8, r: 2, minPlayers: 4),
          PlacementDef(name: 'Harrow', c: 8, r: 6),
          PlacementDef(name: 'Harrow', c: 10, r: 3, minPlayers: 3),
          PlacementDef(name: 'Borrowed Vessel', c: 9, r: 3, onSlain: [
            codex(141),
            victory(),
          ]),
          PlacementDef(name: 'Wrathbone', c: 11, r: 5),
          PlacementDef(name: 'Wrathbone', c: 10, r: 8, minPlayers: 4),
          PlacementDef(name: 'Dyad', c: 6, r: 1),
          PlacementDef(name: 'Dyad', c: 1, r: 2, minPlayers: 3),
          PlacementDef(
              name: 'Magic',
              type: PlacementType.trap,
              c: 0,
              r: 4,
              trapDamage: 3),
          PlacementDef(
              name: 'Magic',
              type: PlacementType.trap,
              c: 8,
              r: 9,
              trapDamage: 3),
          PlacementDef(
              name: 'Magic',
              type: PlacementType.trap,
              c: 6,
              r: 0,
              trapDamage: 3),
        ],
      );
  static EncounterDef get encounter7dot5 => EncounterDef(
        questId: '7',
        number: '5',
        title: 'Behind Every Masterpiece',
        setup: EncounterSetup(
            box: '3/7',
            map: '52',
            adversary: '88-89',
            tiles: '2x Magical Trap'),
        victoryDescription: 'Slay Bazhar. ',
        lossDescription: 'Lose if Ozendyn is slain.',
        roundLimit: 10,
        terrain: [
          trapMagic(3),
          etherMorph(),
        ],
        baseLystReward: 30,
        unlocksTrait: true,
        milestone: CampaignMilestone.milestone7dot5,
        itemRewards: [
          'Twisted Chargers',
        ],
        campaignLink: 'Chapter 5 - “**Era Shattered**”, [campaign] **130**.',
        challenges: [
          'When Countdown to Doom triggers and Rovers suffer damage, that damage is increased by +1.',
          'You have two fewer rounds to complete this encounter. When starting this encounter, set the round counter to 3. This does adjust the effect of Countdown to Doom.',
          'Adversaries are immune to the effects of [Morph] nodes. Rovers can not take ether dice from [Morph] nodes',
        ],
        dialogs: [
          introductionFromText('quest_7_encounter_5_intro'),
        ],
        onLoad: [
          dialog('Introduction'),
          rules('Ozendyn',
              '''Ozendyn is a character ally to Rovers. For this encounter Ozendyn will only use the “Crucial Sentinel” side and will not flip.'''),
          rules('Countdown to Doom',
              '''Bazhar radiates malevolent energy. They’re creating an army of corrupted ether.

While Bazhar creates his macabre forms of living ether, they do not act like a traditional adversary and do not take turns during the adversary phase. At the start of the adversary phase, execute the effects based on the current round count. Slay Bazhar quickly before you are overwhelmed.

There are six ether icons placed throughout the map. These icons represent possible spawn locations throughout the encounter. When an adversary would be spawned, roll an ether dice to determine its spawn location.

**Round 1**: Place [snapfrost] in all Rover spaces.
**Round 2**: All Rovers suffer [DMG]1. Clear all ether fields in spaces occupied by Bazhar. Spawn 3 corrupted forms.
**Round 3**: Place [miasma] in all Rover spaces.
**Round 4**: All Rovers suffer [DMG]2. Clear all ether fields in spaces occupied by Bazhar. Spawn 3 endless hunger.
**Round 5**: Spawn 1 broken reflection.
**Round 6**: All Rovers suffer [DMG]3. Clear all ether fields in spaces occupied by Bazhar. Spawn 3 corrupted forms.
**Round 7**: Spawn 3 endless hungers.
**Round 8**: All Rovers suffer [DMG]4. Clear all ether fields in spaces occupied by Bazhar. Spawn 2 broken reflections.
**Round 9**: Spawn 3 corrupted forms.
**Round 10**: All units of the Rover faction are slain. Their ether is corrupted and they become broken reflections. The encounter is lost.'''),
          codexLink('Blasphemously Surviving Nightmares',
              number: 142,
              body:
                  '''Immediately when Bazhar is slain, read [title], [codex] 66.'''),
        ],
        onDidStartPhase: [
          milestone('_countdown_to_doom_1', conditions: [
            RoundCondition(1),
            PhaseCondition(RoundPhase.adversary),
          ]),
          milestone('_countdown_to_doom_2', conditions: [
            RoundCondition(2),
            PhaseCondition(RoundPhase.adversary),
          ]),
          milestone('_countdown_to_doom_3', conditions: [
            RoundCondition(3),
            PhaseCondition(RoundPhase.adversary),
          ]),
          milestone('_countdown_to_doom_4', conditions: [
            RoundCondition(4),
            PhaseCondition(RoundPhase.adversary),
          ]),
          milestone('_countdown_to_doom_5', conditions: [
            RoundCondition(5),
            PhaseCondition(RoundPhase.adversary),
          ]),
          milestone('_countdown_to_doom_6', conditions: [
            RoundCondition(6),
            PhaseCondition(RoundPhase.adversary),
          ]),
          milestone('_countdown_to_doom_7', conditions: [
            RoundCondition(7),
            PhaseCondition(RoundPhase.adversary),
          ]),
          milestone('_countdown_to_doom_8', conditions: [
            RoundCondition(8),
            PhaseCondition(RoundPhase.adversary),
          ]),
          milestone('_countdown_to_doom_9', conditions: [
            RoundCondition(9),
            PhaseCondition(RoundPhase.adversary),
          ]),
          milestone('_countdown_to_doom_10', conditions: [
            RoundCondition(10),
            PhaseCondition(RoundPhase.adversary),
          ]),
        ],
        onMilestone: {
          '_countdown_to_doom_1': [
            rules('Countdown to Doom (1)',
                '''Place [snapfrost] in all Rover spaces.'''),
          ],
          '_countdown_to_doom_2': [
            rules('Countdown to Doom (2)',
                'All Rovers suffer [DMG]1. Clear all ether fields in spaces occupied by Bazhar. Spawn 3 corrupted forms.',
                silent: true),
            placementGroup('3 Corrupted Form',
                title: 'Rules: Countdown to Doom (2)',
                body:
                    'All Rovers suffer [DMG]1. Clear all ether fields in spaces occupied by Bazhar. Spawn 3 corrupted forms.'),
          ],
          '_countdown_to_doom_3': [
            rules('Countdown to Doom (3)',
                '''Place [miasma] in all Rover spaces.'''),
          ],
          '_countdown_to_doom_4': [
            rules('Countdown to Doom (4)',
                'All Rovers suffer [DMG]2. Clear all ether fields in spaces occupied by Bazhar. Spawn 3 endless hunger.',
                silent: true),
            placementGroup('3 Endless Hunger',
                title: 'Rules: Countdown to Doom (4)',
                body:
                    'All Rovers suffer [DMG]2. Clear all ether fields in spaces occupied by Bazhar. Spawn 3 endless hunger.'),
          ],
          '_countdown_to_doom_5': [
            rules('Countdown to Doom (5)', 'Spawn 1 broken reflection.',
                silent: true),
            placementGroup('1 Broken Reflection',
                title: 'Rules: Countdown to Doom (5)',
                body: 'Spawn 1 broken reflection.'),
          ],
          '_countdown_to_doom_6': [
            rules('Countdown to Doom (6)',
                'All Rovers suffer [DMG]3. Clear all ether fields in spaces occupied by Bazhar. Spawn 3 corrupted forms.',
                silent: true),
            placementGroup('3 Corrupted Form',
                title: 'Rules: Countdown to Doom (6)',
                body:
                    'All Rovers suffer [DMG]3. Clear all ether fields in spaces occupied by Bazhar. Spawn 3 corrupted forms. Spawn 3 corrupted forms.'),
          ],
          '_countdown_to_doom_7': [
            rules('Countdown to Doom (7)', 'Spawn 3 endless hunger.',
                silent: true),
            placementGroup('3 Endless Hunger',
                title: 'Rules: Countdown to Doom (7)',
                body: 'Spawn 3 endless hunger.'),
          ],
          '_countdown_to_doom_8': [
            rules('Countdown to Doom (8)',
                '''All Rovers suffer [DMG]4. Clear all ether fields in spaces occupied by Bazhar. Spawn 2 broken reflections.''',
                silent: true),
            placementGroup('2 Broken Reflection',
                title: 'Rules: Countdown to Doom (8)',
                body:
                    'All Rovers suffer [DMG]4. Clear all ether fields in spaces occupied by Bazhar. Spawn 2 broken reflections.'),
          ],
          '_countdown_to_doom_9': [
            rules('Countdown to Doom (9)', 'Spawn 3 corrupted forms.',
                silent: true),
            placementGroup('3 Corrupted Form',
                title: 'Rules: Countdown to Doom (9)',
                body: 'Spawn 3 corrupted forms.'),
          ],
          '_countdown_to_doom_10': [
            fail(
                title: 'Countdown to Doom (10)',
                body:
                    '''All units of the Rover faction are slain. Their ether is corrupted and they become broken reflections. The encounter is lost.'''),
          ],
        },
        startingMap: MapDef(
          id: '7.5',
          columnCount: 13,
          rowCount: 11,
          backgroundRect: Rect.fromLTWH(110.0, 44.0, 1481.0, 1411.0),
          starts: [
            (10, 0),
            (11, 0),
            (11, 1),
            (12, 0),
            (12, 1),
          ],
          terrain: {
            (0, 4): TerrainType.barrier,
            (0, 6): TerrainType.barrier,
            (1, 2): TerrainType.barrier,
            (1, 6): TerrainType.barrier,
            (1, 8): TerrainType.barrier,
            (1, 10): TerrainType.barrier,
            (3, 0): TerrainType.barrier,
            (3, 6): TerrainType.object,
            (3, 10): TerrainType.barrier,
            (5, 1): TerrainType.barrier,
            (5, 3): TerrainType.object,
            (5, 9): TerrainType.barrier,
            (7, 3): TerrainType.object,
            (7, 9): TerrainType.barrier,
            (9, 0): TerrainType.barrier,
            (9, 6): TerrainType.object,
            (9, 10): TerrainType.barrier,
            (11, 4): TerrainType.barrier,
            (11, 6): TerrainType.barrier,
            (11, 8): TerrainType.barrier,
            (12, 2): TerrainType.barrier,
            (12, 4): TerrainType.barrier,
            (12, 6): TerrainType.barrier,
          },
          spawnPoints: {
            (3, 4): Ether.crux,
            (4, 6): Ether.earth,
            (6, 2): Ether.fire,
            (6, 7): Ether.wind,
            (8, 6): Ether.water,
            (9, 4): Ether.morph,
          },
        ),
        allies: [
          AllyDef(name: 'Ozendyn', cardId: 'A-015', cardIndex: 1, behaviors: [
            EncounterFigureDef(
              name: 'Crucial Sentinel',
              health: 11,
              affinities: {
                Ether.wind: -1,
                Ether.morph: -1,
                Ether.earth: 1,
                Ether.crux: 2,
              },
              abilities: [
                AbilityDef(name: 'Ability', actions: [
                  RoveAction.jump(4),
                  RoveAction.meleeAttack(4,
                      aoe: AOEDef.x5FrontSpray(),
                      targetCount: RoveAction.allTargets),
                  RoveAction.heal(2,
                      endRange: 2,
                      targetCount: RoveAction.allTargets,
                      requiresPrevious: true)
                ]),
              ],
              reactions: [
                EnemyReactionDef(
                    trigger: ReactionTriggerDef(
                        type: RoveEventType.afterSlain,
                        targetKind: TargetKind.enemy,
                        condition: MatchesCondition('Endless Hunger')),
                    actions: [RoveAction.heal(1, endRange: 2)])
              ],
              onSlain: [fail()],
            ),
          ]),
        ],
        adversaries: [
          EncounterFigureDef(
            name: 'Bazhar',
            type: AdversaryType.boss,
            standeeCount: 1,
            healthFormula: '16*R',
            defenseFormula: 'X',
            xDefinition: 'count_adversary(Corrupted Form)',
            large: true,
            immuneToForcedMovement: true,
            immuneToTeleport: true,
            affinities: {
              Ether.morph: 9,
              Ether.crux: -9,
            },
          ),
          EncounterFigureDef(
            name: 'Endless Hunger',
            letter: 'B',
            standeeCount: 8,
            healthFormula: '5*R',
            traits: [
              'When the Endles Hunger deals damage, Bahzar recovers [RCV] X, where X equals the damage dealt by the Endless Hunger.',
            ],
            affinities: {
              Ether.fire: -2,
              Ether.crux: -1,
              Ether.earth: 1,
              Ether.morph: 2,
            },
          ),
          EncounterFigureDef(
            name: 'Corrupted Form',
            letter: 'C',
            standeeCount: 8,
            healthFormula: '4*R',
            flies: true,
            traits: [
              'Bahzar has [DEF] X, where X equals the number of Corrupted Forms on the map.',
            ],
            affinities: {
              Ether.crux: -2,
              Ether.morph: 2,
            },
          ),
          EncounterFigureDef(
            name: 'Broken Reflection',
            letter: 'D',
            standeeCount: 3,
            healthFormula: '7*R',
            traits: [
              'Units that attack Bahzar suffer [DMG] X, where X equals the damage that unit dealt.',
            ],
            affinities: {
              Ether.crux: -2,
              Ether.morph: 2,
            },
          ),
        ],
        placements: [
          PlacementDef(name: 'Bazhar', c: 6, r: 5, onSlain: [
            codex(142),
            victory(),
            codex(143),
          ]),
          PlacementDef(name: 'Endless Hunger', c: 6, r: 6),
          PlacementDef(name: 'Endless Hunger', c: 6, r: 1),
          PlacementDef(name: 'Endless Hunger', c: 10, r: 6),
          PlacementDef(
              name: 'Magic',
              type: PlacementType.trap,
              c: 3,
              r: 1,
              trapDamage: 3),
          PlacementDef(
              name: 'Magic',
              type: PlacementType.trap,
              c: 2,
              r: 8,
              trapDamage: 3),
          PlacementDef(
              name: 'Magic',
              type: PlacementType.trap,
              c: 10,
              r: 8,
              trapDamage: 3),
          PlacementDef(name: 'morph', type: PlacementType.ether, c: 3, r: 6),
          PlacementDef(name: 'morph', type: PlacementType.ether, c: 9, r: 6),
          PlacementDef(name: 'morph', type: PlacementType.ether, c: 5, r: 3),
          PlacementDef(name: 'morph', type: PlacementType.ether, c: 7, r: 3),
        ],
        placementGroups: [
          PlacementGroupDef(
            name: '3 Corrupted Form',
            isSpawnWithDie: true,
            placements: [
              PlacementDef(name: 'Corrupted Form'),
              PlacementDef(name: 'Corrupted Form'),
              PlacementDef(name: 'Corrupted Form'),
            ],
          ),
          PlacementGroupDef(
            name: '3 Endless Hunger',
            isSpawnWithDie: true,
            placements: [
              PlacementDef(name: 'Endless Hunger'),
              PlacementDef(name: 'Endless Hunger'),
              PlacementDef(name: 'Endless Hunger'),
            ],
          ),
          PlacementGroupDef(
            name: '1 Broken Reflection',
            isSpawnWithDie: true,
            placements: [
              PlacementDef(name: 'Broken Reflection'),
            ],
          ),
          PlacementGroupDef(
            name: '2 Broken Reflection',
            isSpawnWithDie: true,
            placements: [
              PlacementDef(name: 'Broken Reflection'),
              PlacementDef(name: 'Broken Reflection'),
            ],
          ),
        ],
      );
}
