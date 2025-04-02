import 'dart:ui';

import 'package:rove_app_common/data/encounter_def_utils.dart';
import 'package:rove_data_types/rove_data_types.dart';

extension Quest0 on EncounterDef {
  static EncounterDef get encounter0dot1 => EncounterDef(
        questId: '0',
        number: '1',
        title: 'Fling to the Hollow Gale',
        victoryDescription: 'Hold out against the galelings.',
        roundLimit: 4,
        baseLystReward: 10,
        campaignLink:
            'Encounter 0.2 - “**When Each Thing Joy Supplied**” [campaign] **8**.',
        onLoad: [
          codexLink('Its Sullen Sound',
              number: 1,
              body:
                  'After all Rovers have taken their turn and performed two abilities, the Rover phase is over, read [title], [codex] 2.'),
        ],
        onMilestone: {
          '_codex1': [
            codex('Its Sullen Sound', page: 2),
            codexLink('Now With Rising Knell',
                number: 2,
                body:
                    'After all adversaries have taken their turns, the adversary phase is over. With all phases completed the round ends, read [title], [codex] 2.'),
          ],
          '_codex2': [
            codex('Now With Rising Knell', page: 2),
            codexLink('Some Little Cheering',
                number: 3,
                body: 'After the Rover phase ends, read [title], [codex] 3.'),
          ],
          '_codex3': [
            codex('Some Little Cheering', page: 3),
            codexLink('Though Restless Still Themselves',
                number: 4,
                body:
                    'After the adversary phase ends, read [title], [codex] 4.'),
          ],
          '_codex4': [
            codex('Though Restless Still Themselves', page: 4),
            codexLink('The Last, Last Purple Streaks of the Day',
                number: 5,
                body: 'After the Rover phase ends, read [title], [codex] 5.'),
          ],
          '_codex5': [
            codex('The Last, Last Purple Streaks of the Day', page: 5),
            codexLink('In Echo Sweet Replies',
                number: 6,
                body:
                    'After the adversary phase ends, read [title], [codex] 6.'),
          ],
          '_codex6': [
            codex('In Echo Sweet Replies', page: 6),
            codexLink('The Joy of Young Ideas',
                number: 7,
                body:
                    'Immediately after the Rover phase ends, or if all adversaries are slain, read [title], [codex] 7.'),
          ],
          '_victory': [
            codex('The Joy of Young Ideas', page: 7),
            victory(
                body:
                    '''Congratulations on your first victory! Rovers gain 10xR[lyst]. **Lyst** [lyst] is the currency of Rove. R stands for the number of Rovers (pg. 62). That means R will equal 2, 3, or 4. Many things in the game can reference the value of R. Record the [lyst] you earned on your campaign sheet (pg. 61). *[The app does this automatically.]*'''),
          ]
        },
        onWillEndPhase: [
          milestone('_codex1', conditions: [
            RoundCondition(1),
            PhaseCondition(RoundPhase.rover),
          ]),
          milestone('_codex3', conditions: [
            RoundCondition(2),
            PhaseCondition(RoundPhase.rover),
          ]),
          milestone('_codex5', conditions: [
            RoundCondition(3),
            PhaseCondition(RoundPhase.rover),
          ]),
          milestone('_victory', conditions: [
            RoundCondition(4),
            PhaseCondition(RoundPhase.rover),
          ]),
        ],
        onWillEndRound: [
          milestone('_codex2', condition: RoundCondition(1)),
          milestone('_codex4', condition: RoundCondition(2)),
          milestone('_codex6', condition: RoundCondition(3)),
        ],
        startingMap: MapDef(
          id: '0.1',
          columnCount: 13,
          rowCount: 11,
          backgroundRect: Rect.fromLTWH(134, 26, 1650 - 134, 1475 - 26),
          terrain: {
            (0, 8): TerrainType.start,
            (1, 9): TerrainType.start,
            (2, 3): TerrainType.object,
            (2, 6): TerrainType.difficult,
            (2, 9): TerrainType.start,
            (3, 10): TerrainType.start,
            (4, 1): TerrainType.difficult,
            (5, 8): TerrainType.difficult,
            (6, 3): TerrainType.object,
            (8, 6): TerrainType.object,
            (10, 1): TerrainType.object,
            (10, 4): TerrainType.difficult,
            (10, 8): TerrainType.object,
          },
        ),
        adversaries: [
          EncounterFigureDef(
            name: 'Galeling',
            letter: 'A',
            health: 5,
            affinities: const {
              Ether.fire: -1,
              Ether.earth: -1,
              Ether.wind: 1,
            },
            abilities: [
              AbilityDef(name: 'Scything Strike', actions: [
                RoveAction.jump(2),
                RoveAction.meleeAttack(2),
              ]),
              AbilityDef(name: 'Rending Talons', actions: [
                RoveAction.jump(3),
                RoveAction.meleeAttack(2, targetCount: 2),
              ]),
              AbilityDef(name: 'Rending Swoop', actions: [
                RoveAction.jump(2),
                RoveAction.meleeAttack(2, pierce: true),
              ]),
              AbilityDef(name: 'Fleeing Shot', actions: [
                RoveAction.jump(1),
                RoveAction.rangeAttack(2, pierce: true),
                RoveAction(
                    type: RoveActionType.jump,
                    amount: 2,
                    retreat: true,
                    requiresPrevious: true),
              ]),
            ],
            onSlain: [
              milestone('_victory', condition: AllAdversariesSlainCondition()),
            ],
          ),
        ],
        placements: const [
          PlacementDef(name: 'Galeling', c: 6, r: 2),
          PlacementDef(name: 'Galeling', c: 9, r: 4),
          PlacementDef(name: 'Galeling', c: 3, r: 5),
          PlacementDef(name: 'Galeling', c: 6, r: 6),
          PlacementDef(name: 'Galeling', c: 0, r: 3, minPlayers: 3),
          PlacementDef(name: 'Galeling', c: 11, r: 8, minPlayers: 3),
          PlacementDef(name: 'Galeling', c: 2, r: 0, minPlayers: 4),
          PlacementDef(name: 'Galeling', c: 8, r: 9, minPlayers: 4),
        ],
      );

  static EncounterDef get encounter0dot2 => EncounterDef(
        questId: '0',
        number: '2',
        title: 'When Each Thing Joy Supplied',
        victoryDescription: 'Get to the exit hexes.',
        roundLimit: 5,
        baseLystReward: 10,
        unlocksShopLevel: 1,
        campaignLink:
            '''Encounter 0.3 - “**The Storms Hath Bound**”, [campaign] **10**.''',
        playerPossibleTokens: ['Key'],
        trackerEvents: [
          EncounterTrackerEventDef(
              title: 'Mark immediately when all Rovers occupy an [exit] space.',
              recordMilestone: '_victory'),
        ],
        onLoad: [
          codexLink('Favors Court Thy Smile',
              number: 8,
              body:
                  'Immediately each time a Rover enters into a space with a hoard tile, remove the tile and read [title], [codex] 7.'),
          codexLink('And Steal Their Sweets',
              number: 10,
              body:
                  'Immediately when the Nektari Hive is destroyed, read [title], [codex] 8.'),
          codexLink('And Shake the Blooms',
              number: 9,
              body: 'After the Rover phase ends, read [title], [codex] 8.'),
        ],
        onMilestone: {
          '_codex9': [
            codex('And Shake the Blooms', page: 8),
            codexLink('Perchance Her Acorn-Cups to Fill',
                number: 11,
                body:
                    'After the adversary phase ends, read [title], [codex] 9.')
          ],
          '_codex10': [
            codex('And Steal Their Sweets', page: 8),
            addToken('Key',
                title: 'Reward',
                body:
                    '''Make a note on the backside of the campaign sheet that the Rover that destroyed the Nektari Hive “has the metal key”.

Then spawn R nektari swarms within [range] 0-1 of the destroyed hive.

Certain game events can spawn adversaries (pg. 51), which places new enemies onto the map.'''),
            placementGroup('That\'s a Lot of Nektari', silent: true),
            codexLink('That Slumbrous Influence Kest',
                number: 13,
                body:
                    'At the end of the round, if the Rover with “the metal key” is within [range] 1 of the treasure chest, read [title], [codex] 10.')
          ],
          '_codex11': [
            codex('Perchance Her Acorn-Cups to Fill', page: 9),
            codexLink('Well thy Gold and Purple Wing',
                number: 12,
                body: 'After the Rover phase ends, read [title], [codex] 10.')
          ],
          '_codex12': [
            codex('Well thy Gold and Purple Wing', page: 10),
            codexLink('Close Dungeon of Innumerous Boughs',
                number: 12,
                body:
                    'Immediately when all Rovers occupy an [exit] space, read [title], [codex] 11.')
          ],
          '_victory': [
            codex('Close Dungeon of Innumerous Boughs', page: 11),
            victory(
                body:
                    '''Congratulations, you found Mo and Makaal!  Rovers gain 10*R [lyst].
            
Mo and Makaal will help you in your fight against the galeapers, for the right price!  M&Ms shop is now open. Open the Merchant level 1 deck. This deck forms the basis of the shop. You can now buy and sell items (pg. 45). Remember, items sell for half of their cost (rounded up).'''),
          ],
        },
        onWillEndPhase: [
          milestone('_codex9', conditions: [
            RoundCondition(1),
            PhaseCondition(RoundPhase.rover),
          ]),
          milestone('_codex12', conditions: [
            RoundCondition(2),
            PhaseCondition(RoundPhase.rover),
          ]),
        ],
        onWillEndRound: [
          milestone(
            '_codex11',
            condition: RoundCondition(1),
          )
        ],
        startingMap: MapDef(
          id: '0.2',
          columnCount: 13,
          rowCount: 11,
          backgroundRect: Rect.fromLTWH(134, 26, 1650 - 134, 1475 - 26),
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
            (1, 1): TerrainType.openAir,
            (1, 2): TerrainType.openAir,
            (1, 3): TerrainType.openAir,
            (1, 5): TerrainType.openAir,
            (1, 6): TerrainType.openAir,
            (1, 7): TerrainType.openAir,
            (1, 8): TerrainType.openAir,
            (1, 9): TerrainType.openAir,
            (2, 0): TerrainType.exit,
            (2, 1): TerrainType.openAir,
            (2, 2): TerrainType.openAir,
            (2, 5): TerrainType.openAir,
            (2, 6): TerrainType.openAir,
            (2, 7): TerrainType.openAir,
            (2, 8): TerrainType.openAir,
            (3, 0): TerrainType.exit,
            (3, 1): TerrainType.exit,
            (3, 2): TerrainType.dangerous,
            (3, 5): TerrainType.dangerous,
            (3, 10): TerrainType.start,
            (4, 0): TerrainType.exit,
            (5, 10): TerrainType.start,
            (7, 10): TerrainType.start,
            (9, 2): TerrainType.dangerous,
            (9, 10): TerrainType.start,
            (10, 0): TerrainType.openAir,
            (10, 1): TerrainType.openAir,
            (10, 2): TerrainType.openAir,
            (10, 3): TerrainType.openAir,
            (10, 4): TerrainType.openAir,
            (10, 6): TerrainType.openAir,
            (10, 7): TerrainType.openAir,
            (10, 8): TerrainType.openAir,
            (11, 0): TerrainType.openAir,
            (11, 1): TerrainType.openAir,
            (11, 2): TerrainType.openAir,
            (11, 3): TerrainType.openAir,
            (11, 4): TerrainType.openAir,
            (11, 5): TerrainType.object,
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
        placements: [
          const PlacementDef(
            name: 'Hoard',
            type: PlacementType.object,
            c: 0,
            r: 4,
          ),
          PlacementDef(
            name: 'Treasure',
            type: PlacementType.object,
            c: 2,
            r: 3,
            unlockCondition: HasItemCondition('Metal Key'),
            onWillEndRound: [
              EncounterAction(
                  type: EncounterActionType.unlockFromAdjacentAndLoot)
            ],
            onLoot: [
              codex('That Slumbrous Influence Kest', page: 10),
              lyst('10', title: 'That Slumbrous Influence Kest'),
            ],
          ),
          const PlacementDef(name: 'Dekaha', c: 2, r: 4),
          const PlacementDef(name: 'Galeling', c: 3, r: 6),
          const PlacementDef(name: 'Dekaha', c: 4, r: 1, minPlayers: 4),
          const PlacementDef(name: 'Dekaha', c: 5, r: 0, minPlayers: 4),
          const PlacementDef(name: 'Galeling', c: 5, r: 3),
          const PlacementDef(name: 'Galeling', c: 6, r: 0, minPlayers: 4),
          const PlacementDef(name: 'Dekaha', c: 6, r: 1),
          const PlacementDef(
              name: 'Earth', type: PlacementType.ether, c: 6, r: 3),
          const PlacementDef(name: 'Dekaha', c: 6, r: 4, minPlayers: 3),
          const PlacementDef(
              name: 'Bursting Bell',
              type: PlacementType.trap,
              trapDamage: 2,
              c: 6,
              r: 6),
          const PlacementDef(
              name: 'Bursting Bell',
              type: PlacementType.trap,
              trapDamage: 2,
              c: 7,
              r: 2),
          const PlacementDef(name: 'Galeling', c: 7, r: 5, minPlayers: 2),
          const PlacementDef(name: 'Galeling', c: 9, r: 0, minPlayers: 2),
          const PlacementDef(
            name: 'Hoard',
            type: PlacementType.object,
            c: 9,
            r: 1,
          ),
          const PlacementDef(name: 'Dekaha', c: 9, r: 3),
          const PlacementDef(
            name: 'Hoard',
            type: PlacementType.object,
            c: 9,
            r: 4,
          ),
          const PlacementDef(
              name: 'Bursting Bell',
              type: PlacementType.trap,
              trapDamage: 2,
              c: 9,
              r: 5),
          const PlacementDef(name: 'Galeling', c: 10, r: 5),
          PlacementDef(
              name: 'Nektari Hive',
              type: PlacementType.object,
              c: 11,
              r: 5,
              onSlain: [
                milestone('_codex10'),
              ]),
          const PlacementDef(
            name: 'Hoard',
            type: PlacementType.object,
            c: 11,
            r: 10,
          ),
        ],
        placementGroups: const [
          PlacementGroupDef(name: 'That\'s a Lot of Nektari', placements: [
            PlacementDef(name: 'Nektari', c: 11, r: 5),
            PlacementDef(name: 'Nektari', c: 11, r: 5),
            PlacementDef(name: 'Nektari', c: 11, r: 5, minPlayers: 3),
            PlacementDef(name: 'Nektari', c: 11, r: 5, minPlayers: 4),
          ])
        ],
        overlays: [
          EncounterFigureDef(
            name: 'Hoard',
            lootable: true,
            onLoot: [
              codex('Favors Court Thy Smile', page: 7),
              lyst('5', title: 'Favors Court Thy Smile'),
            ],
          ),
          EncounterFigureDef(name: 'Treasure', traits: [
            'You can loot if at the end of the round, the Rover with “the metal key” is within [range] 1 of the treasure chest.'
          ]),
          EncounterFigureDef(name: 'Nektari Hive', healthFormula: '2*R'),
        ],
        adversaries: [
          EncounterFigureDef(
            name: 'Galeling',
            letter: 'A',
            health: 5,
            affinities: const {
              Ether.fire: -1,
              Ether.earth: -1,
              Ether.wind: 1,
            },
            abilities: [
              AbilityDef(name: 'Scything Strike', actions: [
                RoveAction.jump(2),
                RoveAction.meleeAttack(2),
              ]),
              AbilityDef(name: 'Rending Talons', actions: [
                RoveAction.jump(3),
                RoveAction.meleeAttack(2, targetCount: 2),
              ]),
              AbilityDef(name: 'Rending Swoop', actions: [
                RoveAction.jump(2),
                RoveAction.meleeAttack(2, pierce: true),
              ]),
              AbilityDef(name: 'Fleeing Shot', actions: [
                RoveAction.jump(1),
                RoveAction.rangeAttack(2, pierce: true),
                RoveAction(
                    type: RoveActionType.jump,
                    amount: 2,
                    retreat: true,
                    requiresPrevious: true),
              ]),
            ],
          ),
          EncounterFigureDef(
              name: 'Dekaha',
              letter: 'B',
              health: 6,
              immuneToForcedMovement: true,
              affinities: const {
                Ether.fire: -2,
                Ether.wind: -1,
                Ether.earth: 1,
                Ether.water: 1,
              },
              abilities: [
                AbilityDef(name: 'Water Spout', actions: [
                  RoveAction.heal(2, endRange: 4),
                ]),
                AbilityDef(name: 'Hydraulic Whip', actions: [
                  RoveAction.meleeAttack(2, endRange: 3, push: 2),
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
                AbilityDef(
                    name: 'Soothing Sprinkler',
                    actions: [RoveAction.heal(2, endRange: 5, targetCount: 2)]),
              ]),
          EncounterFigureDef(
              name: 'Nektari',
              letter: 'C',
              health: 1,
              flies: true,
              affinities: const {
                Ether.morph: -1,
                Ether.water: -1,
                Ether.wind: 1,
                Ether.crux: 1,
              },
              abilities: [
                AbilityDef(name: 'Revenge Swarn', actions: [
                  RoveAction.move(3),
                  RoveAction.meleeAttack(1, pierce: true),
                ]),
                AbilityDef(name: 'Pollen Burst', actions: [
                  RoveAction.move(4),
                  RoveAction.heal(1,
                      startRange: 1, endRange: 1, targetCount: 99)
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
              ]),
        ],
        onOccupiedSpace: [
          EncounterAction(
              type: EncounterActionType.codex,
              title: 'Close Dungeon of Innumerous Boughs',
              value: 'X',
              conditions: [RoversOnExitCondition()]),
          EncounterAction(
              type: EncounterActionType.victory,
              title: 'Close Dungeon of Innumerous Boughs',
              conditions: [RoversOnExitCondition()]),
        ],
      );
  static EncounterDef get encounter0dot3 => EncounterDef(
        questId: '0',
        number: '3',
        title: 'The Storms Hath Bound',
        victoryDescription: 'Slay the Galeaper Queen.',
        roundLimit: 8,
        baseLystReward: 10,
        itemRewards: ['Cutting Galewing'],
        unlocksRoverLevel: 2,
        campaignLink: 'Chapter 1 - “**A Choice**”, [campaign] **12**.',
        onLoad: [
          rules('Galeapers',
              '''Mature galeapers guard their queen. Galeleapers have the flying [flying] trait (pg. 29), so they ignore difficult and dangerous terrain. They also don’t suffer impact damage from being pushed into objects, as they normally can enter these spaces. Since no unit can enter a barrier space, you can push flying enemies into these spaces.'''),
          rules('Large Adversaries',
              '''The Galeaper Queen, a rotund fearsome matriarch, is a large adversary (pg. 48). Read the previously cited rules carefully. Large adversaries occupy four spaces. Use the large stand for this adversary. Use the primary hex of the large stand as a reference when moving the Queen. Don’t forget to evaluate each space she occupies. You can place negative ether fields into each space the Queen occupies. You can also push the Queen into multiple dangerous terrain spaces at once with enough effort.

Don’t forget that attacks that target the Queen are evaluated from the space she occupies that is closest to the attacker.'''),
          rules('Galeaper Queen',
              '''The Galeaper Queen is a boss with several special features. Her hit points [HP] scale. As discussed in encounter 1, the R value in her hit point property is equal to the number of Rovers on the map.

The Queen has two traits. She gains a defense [DEF] value of 2 as long as at least one galeaper is on the map. Try slaying all the galeapers before attacking her, or use attacks with the ignore defense [pierce] effect. She also is resistant to being pushed. If you want to push the Queen into dangerous terrain or traps, you’ll have to work together to do so.'''),
          rules('The Hive Stirs',
              '''The Galeapers are alert to their Queen’s plight. At the beginning of round 2, 4, 6, and 8, spawn R-1 Galeapers within [range] 0-1 of the Galeaper Hive Entrance closest to the Rovers.

That’s it for this encounter. The rest is up to you!  Use all the rules you’ve learned up to this point to play this encounter.'''),
          codexLink('Borne in Heedless Hum',
              number: 15,
              body:
                  '''Immediately when the Galeaper Queen is slain, read [title], [codex] 11.'''),
        ],
        onMilestone: {
          '_victory': [
            codex('Borne in Heedless Hum', page: 11),
            victory(
                body:
                    '''Congratulations!  You’ve cleared out the galeleaper nest, restored peace to the Uzem shrine, and saved Mo and Makaal. Rovers gain 10*R [lyst] and one “Cutting Galewing” item (pull this item from the reward deck).

Don’t forget you can buy and sell from Mo and Makaal’s shop.

Rovers are now level 2!  Rovers can now take one upgrade card with them into an encounter. Remember, when you start an encounter you form a hand of five cards (pg. 56-57). At the start of each encounter you’ll want to replace one of your basic cards with an upgrade card. Since this isn’t a permanent choice you’re making, you can replace which card you take for each encounter. Try any of your skills that look interesting, or select an upgrade card that will help you overcome a challenge you’ll face in the encounter.

For more information on leveling up, read page 63.'''),
          ]
        },
        startingMap: MapDef(
          id: '0.3',
          columnCount: 13,
          rowCount: 11,
          backgroundRect: Rect.fromLTWH(71, 26, 1593 - 71, 1475 - 26),
          terrain: {
            (0, 0): TerrainType.barrier,
            (0, 1): TerrainType.barrier,
            (0, 8): TerrainType.openAir,
            (0, 9): TerrainType.openAir,
            (1, 0): TerrainType.barrier,
            (1, 1): TerrainType.barrier,
            (1, 4): TerrainType.barrier,
            (1, 5): TerrainType.object,
            (1, 9): TerrainType.openAir,
            (1, 10): TerrainType.openAir,
            (2, 0): TerrainType.barrier,
            (2, 3): TerrainType.barrier,
            (2, 4): TerrainType.barrier,
            (2, 5): TerrainType.object,
            (2, 9): TerrainType.openAir,
            (3, 0): TerrainType.barrier,
            (3, 7): TerrainType.difficult,
            (3, 10): TerrainType.openAir,
            (4, 2): TerrainType.dangerous,
            (4, 9): TerrainType.start,
            (5, 2): TerrainType.dangerous,
            (5, 10): TerrainType.start,
            (6, 9): TerrainType.start,
            (7, 1): TerrainType.difficult,
            (7, 7): TerrainType.dangerous,
            (7, 10): TerrainType.start,
            (8, 9): TerrainType.start,
            (9, 0): TerrainType.barrier,
            (9, 5): TerrainType.object,
            (9, 6): TerrainType.barrier,
            (9, 10): TerrainType.openAir,
            (10, 0): TerrainType.barrier,
            (10, 3): TerrainType.object,
            (10, 5): TerrainType.barrier,
            (10, 6): TerrainType.barrier,
            (10, 9): TerrainType.openAir,
            (11, 0): TerrainType.barrier,
            (11, 1): TerrainType.barrier,
            (11, 9): TerrainType.openAir,
            (11, 10): TerrainType.openAir,
            (12, 0): TerrainType.barrier,
            (12, 1): TerrainType.barrier,
            (12, 8): TerrainType.openAir,
            (12, 9): TerrainType.openAir,
          },
        ),
        placements: [
          PlacementDef(
            name: 'Nektari Hive',
            alias: 'Galeaper Hive Entrance',
            type: PlacementType.object,
            c: 1,
            r: 5,
            onDidStartRound: [
              EncounterAction(
                  type: EncounterActionType.spawnPlacements,
                  title: 'The Hive Stirs',
                  value: 'Left Hive',
                  conditions: [
                    RoundCondition(2),
                    OwnerIsClosestOfClassToRoversCondition()
                  ]),
              EncounterAction(
                  type: EncounterActionType.spawnPlacements,
                  title: 'The Hive Stirs',
                  value: 'Left Hive',
                  conditions: [
                    RoundCondition(4),
                    OwnerIsClosestOfClassToRoversCondition()
                  ]),
              EncounterAction(
                  type: EncounterActionType.spawnPlacements,
                  title: 'The Hive Stirs',
                  value: 'Left Hive',
                  conditions: [
                    RoundCondition(6),
                    OwnerIsClosestOfClassToRoversCondition()
                  ]),
              EncounterAction(
                  type: EncounterActionType.spawnPlacements,
                  title: 'The Hive Stirs',
                  value: 'Left Hive',
                  conditions: [
                    RoundCondition(8),
                    OwnerIsClosestOfClassToRoversCondition()
                  ])
            ],
          ),
          const PlacementDef(
              type: PlacementType.ether, name: 'Wind', c: 2, r: 5),
          const PlacementDef(name: 'Dekaha', c: 3, r: 2, minPlayers: 4),
          const PlacementDef(name: 'Dekaha', c: 3, r: 7),
          const PlacementDef(name: 'Galeaper', c: 4, r: 4, minPlayers: 3),
          const PlacementDef(
              type: PlacementType.trap,
              name: 'Bursting Bell',
              trapDamage: 2,
              c: 4,
              r: 5),
          const PlacementDef(name: 'Galeaper', c: 5, r: 6),
          PlacementDef(name: 'Galeaper Queen', c: 6, r: 4, onSlain: [
            milestone('_victory'),
          ]),
          const PlacementDef(name: 'Dekaha', c: 7, r: 1),
          const PlacementDef(name: 'Galeaper', c: 7, r: 6),
          const PlacementDef(name: 'Galeaper', c: 8, r: 4),
          PlacementDef(
            name: 'Nektari Hive',
            alias: 'Galeaper Hive Entrance',
            type: PlacementType.object,
            c: 9,
            r: 5,
            onDidStartRound: [
              EncounterAction(
                  title: 'The Hive Stirs',
                  type: EncounterActionType.spawnPlacements,
                  value: 'Right Hive',
                  conditions: [
                    RoundCondition(2),
                    OwnerIsClosestOfClassToRoversCondition()
                  ]),
              EncounterAction(
                  type: EncounterActionType.spawnPlacements,
                  title: 'The Hive Stirs',
                  value: 'Right Hive',
                  conditions: [
                    RoundCondition(4),
                    OwnerIsClosestOfClassToRoversCondition()
                  ]),
              EncounterAction(
                  type: EncounterActionType.spawnPlacements,
                  title: 'The Hive Stirs',
                  value: 'Right Hive',
                  conditions: [
                    RoundCondition(6),
                    OwnerIsClosestOfClassToRoversCondition()
                  ]),
              EncounterAction(
                  type: EncounterActionType.spawnPlacements,
                  title: 'The Hive Stirs',
                  value: 'Right Hive',
                  conditions: [
                    RoundCondition(8),
                    OwnerIsClosestOfClassToRoversCondition()
                  ])
            ],
          ),
          const PlacementDef(
              type: PlacementType.trap,
              name: 'Bursting Bell',
              trapDamage: 2,
              c: 9,
              r: 7),
          const PlacementDef(
              type: PlacementType.ether, name: 'Wind', c: 10, r: 3),
          const PlacementDef(name: 'Dekaha', c: 10, r: 7, minPlayers: 3),
        ],
        placementGroups: const [
          PlacementGroupDef(name: 'Left Hive', placements: [
            PlacementDef(name: 'Galeaper', c: 1, r: 5),
            PlacementDef(name: 'Galeaper', c: 1, r: 5, minPlayers: 3),
            PlacementDef(name: 'Galeaper', c: 1, r: 5, minPlayers: 4),
          ]),
          PlacementGroupDef(name: 'Right Hive', placements: [
            PlacementDef(name: 'Galeaper', c: 9, r: 5),
            PlacementDef(name: 'Galeaper', c: 9, r: 5, minPlayers: 3),
            PlacementDef(name: 'Galeaper', c: 9, r: 5, minPlayers: 4),
          ])
        ],
        overlays: [
          EncounterFigureDef(name: 'Nektari Hive', healthFormula: '2*R'),
        ],
        adversaries: [
          EncounterFigureDef(
              name: 'Galeaper',
              letter: 'A',
              health: 5,
              flies: true,
              affinities: const {
                Ether.fire: -1,
                Ether.earth: -1,
                Ether.wind: 1,
                Ether.morph: 1,
              },
              abilities: [
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
                      type: RoveActionType.move,
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
              ]),
          EncounterFigureDef(
              name: 'Dekaha',
              letter: 'B',
              health: 6,
              immuneToForcedMovement: true,
              affinities: const {
                Ether.fire: -2,
                Ether.wind: -1,
                Ether.earth: 1,
                Ether.water: 1,
              },
              abilities: [
                AbilityDef(name: 'Hydraulic Whip', actions: [
                  RoveAction.meleeAttack(2, endRange: 3, push: 2),
                ]),
                AbilityDef(name: 'Water Spout', actions: [
                  RoveAction.heal(2, endRange: 4),
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
                AbilityDef(
                    name: 'Soothing Sprinkler',
                    actions: [RoveAction.heal(2, endRange: 5, targetCount: 2)]),
              ]),
          EncounterFigureDef(
              name: 'Galeaper Queen',
              letter: 'B',
              type: AdversaryType.boss,
              large: true,
              healthFormula: '10*R',
              defenseFormula: 'ceil(X/(X+1))*2',
              xDefinition: 'count_adversary(Galeaper)',
              reducePushPullBy: 1,
              traits: const [
                'Has [DEF]2 as long as at least one galeaper is on the map.'
              ],
              affinities: const {
                Ether.fire: -1,
                Ether.earth: -1,
                Ether.wind: 1,
                Ether.morph: 2,
              },
              abilities: [
                AbilityDef(name: 'Tornado Cannon', actions: [
                  RoveAction.move(1),
                  RoveAction(
                      type: RoveActionType.attack,
                      amount: 3,
                      range: (2, 3),
                      aoe: AOEDef.x3Triangle(),
                      targetCount: RoveAction.allTargets)
                ]),
                AbilityDef(name: 'Massive Talons', actions: [
                  RoveAction.move(2),
                  RoveAction.meleeAttack(1, pierce: true, push: 3)
                ]),
                AbilityDef(name: 'Frenzy Swarm', actions: [
                  RoveAction(
                      type: RoveActionType.command,
                      object: 'Galeaper',
                      range: RoveAction.anyRange,
                      targetCount: 2,
                      targetKind: TargetKind.ally,
                      staticDescription: RoveActionDescription(
                          body: 'The nearest two Galeapers perform:'),
                      commands: [
                        RoveAction.move(2),
                        RoveAction.rangeAttack(2, endRange: 2)
                      ])
                ]),
                AbilityDef(name: 'Queen\'s Call', actions: [
                  RoveAction(
                      type: RoveActionType.spawn,
                      object: 'Galeaper',
                      amountFormula: 'R-1',
                      range: (1, 1))
                ]),
              ]),
        ],
      );
}
