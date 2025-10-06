import 'dart:ui';
import 'package:rove_data_types/rove_data_types.dart';
import 'encounter_def_utils.dart';

extension Quest3 on EncounterDef {
  static EncounterDef get encounter3dot1 => EncounterDef(
        questId: '3',
        number: '1',
        title: 'Peering Over the Rim',
        setup: EncounterSetup(
            box: '3/7', map: '17', adversary: '26-27', tiles: '4x Hatchery'),
        victoryDescription: 'Destroy the Monstrous Growth at [A].',
        lossDescription: 'Lose if Ozendyn is slain.',
        terrain: [
          dangerousBones(1),
          EncounterTerrain('ether_node_any',
              title: 'Conditional Ether',
              body:
                  'There are ether nodes on the map marked with a [wild] icon. The ether type of these nodes changes depending on the special rule block you are referencing.'),
          EncounterTerrain('monstrous_growth',
              title: 'Monstrous Growth',
              body:
                  'Monstrous Growth at [A] is a special object and has R*12 [HP]. Rovers treat the Monstrous Growth as an enemy and no faction treats it as an ally.')
        ],
        roundLimit: 8,
        baseLystReward: 20,
        campaignLink:
            'Encounter 3.2 - “**Midst of Black Seas**”, [campaign] **46**.',
        challenges: [
          'When a stomaw is placed on the side of the map, roll an ether dice from the general pool. On a result of [Earth] or [Morph], set its standee vertical instead of sideways.',
          'At the end of the Start Phase, the Monstrous Growth recovers [RCV] X, where X equals the number of stomaw on the map.',
          'Rovers within [Range] 1-3 of the Monstrous Growth count as being adjacent to an adversary, for the purposes of the stomaw trait.',
        ],
        startingMap: MapDef(
          id: '3.1',
          columnCount: 13,
          rowCount: 11,
          backgroundRect: Rect.fromLTWH(110.0, 44.0, 1481.0, 1411.0),
          terrain: {
            (0, 3): TerrainType.difficult,
            (0, 8): TerrainType.start,
            (0, 9): TerrainType.start,
            (1, 6): TerrainType.dangerous,
            (1, 9): TerrainType.start,
            (1, 10): TerrainType.start,
            (2, 9): TerrainType.start,
            (3, 3): TerrainType.openAir,
            (5, 5): TerrainType.dangerous,
            (6, 0): TerrainType.openAir,
            (7, 2): TerrainType.difficult,
            (7, 10): TerrainType.dangerous,
            (8, 7): TerrainType.difficult,
            (10, 3): TerrainType.difficult,
            (11, 0): TerrainType.object,
            (11, 1): TerrainType.object,
            (11, 5): TerrainType.dangerous,
            (11, 9): TerrainType.openAir,
            (12, 0): TerrainType.object,
            (12, 6): TerrainType.difficult,
          },
          spawnPoints: {
            (5, 0): Ether.fire,
            (7, 0): Ether.earth,
            (9, 0): Ether.water,
            (12, 1): Ether.wind,
            (12, 3): Ether.crux,
            (12, 5): Ether.morph,
          },
        ),
        dialogs: [
          introductionFromText('quest_3_encounter_1_intro'),
        ],
        onLoad: [
          dialog('Introduction'),
          rules('Ozendyn',
              '''Ozendyn is a character ally to Rovers. For this encounter Ozendyn will only use the “Picket” side and will not flip.'''),
          rules('A Sea of Gnashing Teeth',
              '''*A seemingly endless horde of necrotic monstrosities are pouring out from the wastes.* There are six ether icons on the edges of the map. These icons represent possible spawn locations throughout the encounter.

When a Stomaw is slain, place it off to the side of the map on its side. During the start phase, for each stomaw that is both off to the side and flipped vertically, roll an ether dice from the general pool, then spawn that stomaw at the space with the ether icon corresponding to the result that was just rolled. Then, for each stomaw that is both off to the side and placed on its side, flip them vertically. *[The app does this automatically.]*'''),
          rules('Adversaries',
              '''There are spaces marked Dekaha / Ashemak. The enemy that is spawned changes depending on the special rule block you are referencing.'''),
          rules(
              'Changed World (A)',
              '''Quest 1 completed. Use special rule block A.

Terrain: [Wild] Node = [Fire] Node:  Units that end their turn within [Range] 1 of this object suffer [DMG]1.

D Enemies: Ashemak''',
              condition: MilestoneCondition('quest_1_complete')),
          rules(
              'Changed World (B)',
              '''Quest 2 completed. Use special rule block B.

Terrain: [Wild] Node = [Water] Node:  It costs units 1 additional movement point to enter a space within [Range] 1 of this object.

D Enemies: Dekaha''',
              condition: MilestoneCondition('quest_1_complete', value: false)),
          placementGroup('Quest 1 Complete',
              condition: MilestoneCondition('quest_1_complete'), silent: true),
          placementGroup('Quest 2 Complete',
              condition: MilestoneCondition('quest_1_complete', value: false),
              silent: true),
          codexLink('Between its Glistening Teeth',
              number: 48,
              body:
                  '''The first time a stomaw is slain, read [title], [codex] 27.'''),
          codexLink('Whose Art Sublimely Shines',
              number: 49,
              body: '''If the haunt is slain, read [title], [codex] 27.'''),
          codexLink('Free From the Flesh',
              number: 50,
              body:
                  '''Immediately when the Monstrous Growth is destroyed, read [title], [codex] 28.'''),
        ],
        allies: [
          AllyDef(name: 'Ozendyn', cardId: 'A-014', behaviors: [
            EncounterFigureDef(
              name: 'Picket',
              health: 9,
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
        overlays: [
          EncounterFigureDef(
            name: 'Monstrous Growth',
            healthFormula: '12*R',
            onSlain: [
              codex(50),
              victory(),
            ],
          )
        ],
        adversaries: [
          EncounterFigureDef(
            name: 'Stomaw',
            letter: 'A',
            standeeCount: 8,
            health: 7,
            spawnable: true,
            respawns: true,
            traits: [
              'When this unit attacks, if at least one of its allies are adjacent to the target, it gains +1 [DMG] to the attack.'
            ],
            affinities: {
              Ether.fire: -1,
              Ether.earth: 1,
              Ether.crux: -1,
              Ether.morph: 1,
            },
            onSlain: [
              codex(48),
            ],
          ),
          EncounterFigureDef(
            name: 'Broken Vessel',
            letter: 'B',
            standeeCount: 8,
            flies: true,
            health: 5,
            traits: [
              '''[React] Before this unit is slain, it performs:

[m_attack] | [Range] 1 | [DMG]2 | [miasma] | [Target] all units'''
            ],
            affinities: {
              Ether.crux: -2,
              Ether.morph: 1,
            },
          ),
          EncounterFigureDef(
            name: 'Fell Cradle',
            letter: 'C',
            standeeCount: 3,
            health: 14,
            traits: [
              '''[React] When this unit is slain:
              
Spawn one Broken Vessel in the space this unit occupied.'''
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
          ),
          EncounterFigureDef(
            name: 'Dekaha',
            letter: 'D',
            standeeCount: 3,
            health: 7,
            immuneToForcedMovement: true,
            affinities: {
              Ether.fire: -2,
              Ether.water: 2,
              Ether.earth: 1,
              Ether.wind: -1,
            },
          ),
          EncounterFigureDef(
            name: 'Ashemak',
            letter: 'D',
            standeeCount: 3,
            health: 6,
            immuneToForcedMovement: true,
            traits: [
              '''[React] Before this unit is slain:
              
All units within [Range] 1 suffer [DMG]2.'''
            ],
            affinities: {
              Ether.fire: 2,
              Ether.water: -2,
            },
          ),
          EncounterFigureDef(
            name: 'Haunt',
            letter: 'E',
            standeeCount: 4,
            healthFormula: '3*R',
            affinities: {
              Ether.morph: -2,
              Ether.crux: 2,
            },
            onSlain: [
              codex(49),
              item('Multifaceted Icon',
                  body:
                      'The Rover that slayed the haunt gains one “Multifaceted Icon” item. They may equip this item. If they don’t have the required item slot(s) available, they may unequip items as needed.'),
            ],
          ),
        ],
        placements: const [
          PlacementDef(name: 'Haunt', c: 1, r: 0),
          PlacementDef(name: 'Fell Cradle', c: 3, r: 0, minPlayers: 4),
          PlacementDef(name: 'Broken Vessel', c: 8, r: 0, minPlayers: 3),
          PlacementDef(name: 'Broken Vessel', c: 8, r: 6),
          PlacementDef(name: 'Broken Vessel', c: 2, r: 4),
          PlacementDef(name: 'Broken Vessel', c: 12, r: 2, minPlayers: 3),
          PlacementDef(name: 'Stomaw', c: 4, r: 3),
          PlacementDef(name: 'Stomaw', c: 7, r: 6, minPlayers: 3),
          PlacementDef(name: 'Stomaw', c: 9, r: 8),
          PlacementDef(name: 'Stomaw', c: 8, r: 2, minPlayers: 4),
          PlacementDef(name: 'Fell Cradle', c: 10, r: 1),
          PlacementDef(
              name: 'Bursting Bell',
              type: PlacementType.trap,
              c: 2,
              r: 1,
              trapDamage: 3),
          PlacementDef(
              name: 'Bursting Bell',
              type: PlacementType.trap,
              c: 5,
              r: 3,
              trapDamage: 3),
          PlacementDef(
              name: 'Bursting Bell',
              type: PlacementType.trap,
              c: 3,
              r: 7,
              trapDamage: 3),
          PlacementDef(
              name: 'Bursting Bell',
              type: PlacementType.trap,
              c: 10,
              r: 7,
              trapDamage: 3),
          PlacementDef(name: 'Monstrous Growth', c: 11, r: 0),
        ],
        placementGroups: const [
          PlacementGroupDef(
            name: 'Quest 1 Complete',
            placements: [
              PlacementDef(name: 'Ashemak', c: 4, r: 2, minPlayers: 3),
              PlacementDef(name: 'Ashemak', c: 9, r: 3),
              PlacementDef(name: 'Ashemak', c: 6, r: 6),
              PlacementDef(name: 'fire', type: PlacementType.ether, c: 5, r: 8),
              PlacementDef(name: 'fire', type: PlacementType.ether, c: 8, r: 4),
            ],
          ),
          PlacementGroupDef(
            name: 'Quest 2 Complete',
            placements: [
              PlacementDef(name: 'Dekaha', c: 4, r: 2, minPlayers: 3),
              PlacementDef(name: 'Dekaha', c: 9, r: 3),
              PlacementDef(name: 'Dekaha', c: 6, r: 6),
              PlacementDef(
                  name: 'water', type: PlacementType.ether, c: 5, r: 8),
              PlacementDef(
                  name: 'water', type: PlacementType.ether, c: 8, r: 4),
            ],
          ),
        ],
      );

  static EncounterDef get encounter3dot2 => EncounterDef(
        questId: '3',
        number: '2',
        title: 'Midst of Black Seas',
        setup: EncounterSetup(
            box: '3/7', map: '18', adversary: '28-29', tiles: '4x Hatchery'),
        victoryDescription: 'Slay the Scour.',
        terrain: [
          dangerousBones(1),
          trapTar(3),
          etherMorph(),
          EncounterTerrain('a',
              title: 'Morph Nodes',
              body:
                  'If there are 3 or more Rovers, place a [morph] dice at node [a], and if there are 4 or more Rovers, place a [morph] dice at node [b]. In this way, there can be 2, 3, or 4 [morph] nodes on this map, depending on Rover count. This affects the Scour’s trait.')
        ],
        roundLimit: 8,
        baseLystReward: 10,
        campaignLink:
            'Encounter 3.3 - “**Paralyzed Memories**”, [campaign] **48**.',
        itemRewards: [
          'Scour Brand',
        ],
        challenges: [
          'The Scour gains +R*6 [HP].',
          'After the turn where the Scour suffers [DMG] from any source, spawn 1 Broken Vessel at [Range] 2 of it, closest to the nearest Rover.',
          'The Scour gains +1 [DMG] when targeting an enemy with half or less [HP].',
        ],
        dialogs: [
          introductionFromText('quest_3_encounter_2_intro'),
        ],
        onLoad: [
          dialog('Introduction'),
          rules('On Advance',
              '''Adversaries in this encounter use the On Advance mechanic, which is found on page 47 of the rulebook.'''),
          codexLink('A Strange Spirit Stalks',
              number: 51,
              body:
                  '''The first time a broken vessel is slain, read [title], [codex] 28.'''),
          codexLink('Capacity for Detachment',
              number: 52,
              body: '''If the urn is slain, read [title], [codex] 28.'''),
          codexLink('Monstrous, Unnatural, Colossal',
              number: 53,
              body:
                  '''Immediately when the Scour is slain, read [title], [codex] 29.'''),
        ],
        startingMap: MapDef(
          id: '3.2',
          columnCount: 13,
          rowCount: 11,
          backgroundRect: Rect.fromLTWH(110.0, 44.0, 1481.0, 1411.0),
          terrain: {
            (0, 3): TerrainType.object,
            (0, 5): TerrainType.dangerous,
            (0, 9): TerrainType.difficult,
            (1, 1): TerrainType.object,
            (1, 3): TerrainType.dangerous,
            (1, 9): TerrainType.difficult,
            (1, 10): TerrainType.difficult,
            (3, 10): TerrainType.start,
            (4, 1): TerrainType.dangerous,
            (4, 4): TerrainType.openAir,
            (5, 10): TerrainType.start,
            (7, 10): TerrainType.start,
            (8, 1): TerrainType.dangerous,
            (8, 6): TerrainType.openAir,
            (9, 10): TerrainType.start,
            (10, 1): TerrainType.object,
            (11, 3): TerrainType.dangerous,
            (11, 9): TerrainType.difficult,
            (11, 10): TerrainType.difficult,
            (12, 4): TerrainType.object,
            (12, 5): TerrainType.dangerous,
            (12, 9): TerrainType.difficult,
          },
        ),
        adversaries: [
          EncounterFigureDef(
            name: 'Stomaw',
            health: 7,
            letter: 'A',
            standeeCount: 8,
            traits: [
              'When this unit attacks, if at least one of its allies are adjacent to the target, it gains +1 [DMG] to the attack.'
            ],
            affinities: {
              Ether.fire: -1,
              Ether.earth: 1,
              Ether.crux: -1,
              Ether.morph: 1,
            },
          ),
          EncounterFigureDef(
            name: 'Broken Vessel',
            letter: 'B',
            standeeCount: 8,
            spawnable: true,
            health: 5,
            flies: true,
            traits: [
              '''[React] Before this unit is slain, it performs:

[m_attack] | [Range] 1 | [DMG]2 | [miasma] | [Target] all units'''
            ],
            affinities: {
              Ether.crux: -2,
              Ether.morph: 1,
            },
            onSlain: [
              codex(51),
            ],
          ),
          EncounterFigureDef(
            name: 'Dyad',
            letter: 'C',
            standeeCount: 8,
            health: 12,
            affinities: {
              Ether.water: 1,
              Ether.earth: -1,
              Ether.crux: 2,
              Ether.morph: -2,
            },
          ),
          EncounterFigureDef(
            name: 'Scour',
            letter: 'D',
            standeeCount: 1,
            type: AdversaryType.miniboss,
            healthFormula: '12*R+(R*6)*C1',
            defense: 1,
            large: true,
            traits: [
              '''At the start of this unit's turn, it recovers [RCV] X. << Where X equals the number of [morph] nodes on the map.'''
            ],
            affinities: {
              Ether.fire: -1,
              Ether.earth: 1,
              Ether.crux: -2,
              Ether.morph: 2,
            },
            onSlain: [
              codex(53),
              victory(),
            ],
          ),
          EncounterFigureDef(
            name: 'Urn',
            letter: 'E',
            standeeCount: 1,
            healthFormula: '3*R',
            defense: 2,
            affinities: {
              Ether.fire: 1,
              Ether.water: 1,
              Ether.earth: 1,
              Ether.wind: 1,
            },
            onSlain: [
              codex(52),
              lyst('5*R'),
              item('Arcana Pigment',
                  body:
                      '''The Rover that slayed the urn gains one “Arcana Pigment” item. They may equip this item. If they don’t have the required item slot(s) available, they may unequip items as needed.'''),
            ],
          ),
        ],
        placements: const [
          PlacementDef(name: 'Dyad', c: 1, r: 0),
          PlacementDef(name: 'Dyad', c: 9, r: 0, minPlayers: 4),
          PlacementDef(name: 'Broken Vessel', c: 1, r: 2),
          PlacementDef(name: 'Broken Vessel', c: 8, r: 5, minPlayers: 3),
          PlacementDef(name: 'Broken Vessel', c: 12, r: 1),
          PlacementDef(name: 'Stomaw', c: 2, r: 2),
          PlacementDef(name: 'Stomaw', c: 5, r: 4, minPlayers: 3),
          PlacementDef(name: 'Stomaw', c: 11, r: 4),
          PlacementDef(name: 'Urn', c: 11, r: 0),
          PlacementDef(name: 'Scour', c: 6, r: 1),
          PlacementDef(
              name: 'Bursting Bell',
              type: PlacementType.trap,
              c: 0,
              r: 8,
              trapDamage: 3),
          PlacementDef(
              name: 'Bursting Bell',
              type: PlacementType.trap,
              c: 2,
              r: 9,
              trapDamage: 3),
          PlacementDef(
              name: 'Bursting Bell',
              type: PlacementType.trap,
              c: 10,
              r: 9,
              trapDamage: 3),
          PlacementDef(
              name: 'Bursting Bell',
              type: PlacementType.trap,
              c: 12,
              r: 8,
              trapDamage: 3),
          PlacementDef(name: 'morph', type: PlacementType.ether, c: 1, r: 1),
          PlacementDef(
              name: 'morph',
              type: PlacementType.ether,
              c: 10,
              r: 1,
              minPlayers: 4),
          PlacementDef(name: 'morph', type: PlacementType.ether, c: 12, r: 4),
          PlacementDef(
              name: 'morph',
              type: PlacementType.ether,
              c: 0,
              r: 3,
              minPlayers: 3),
        ],
      );

  static EncounterDef get encounter3dot3 => EncounterDef(
        questId: '3',
        number: '3',
        title: 'Paralyzed Memories',
        setup: EncounterSetup(
            box: '3/7', map: '19', adversary: '30', tiles: '4x Hoard'),
        victoryDescription: 'Slay the Crown.',
        lossDescription: 'Lose if Ozendyn is slain.',
        terrain: [
          dangerousBramble(1),
          etherCrux(),
        ],
        roundLimit: 8,
        baseLystReward: 20,
        unlocksRoverLevel: 5,
        campaignLink:
            'Encounter 3.4 - “**Malign and Particular Suspension**”, [campaign] **50**.',
        challenges: [
          'The azoth gains +1 [DEF].',
          'When the azoth is slain, spawn R dyad hatchlings in spaces the azoth occupied.',
          'After any action where the crown suffers damage, it performs: Logic: Retreat. [Teleport] 3',
        ],
        dialogs: [
          introductionFromText('quest_3_encounter_3_intro'),
        ],
        onLoad: [
          dialog('Introduction'),
          rules('Ozendyn',
              '''Ozendyn is a character ally to Rovers. For this encounter Ozendyn will only use the “Picket” side and will not flip.'''),
          codexLink('Ornamental Fruits',
              number: 54,
              body:
                  '''If a Rover enters into a space with a hoard tile, remove the tile and read [title], [codex] 29.'''),
          codexLink('Slithering Malice',
              number: 55,
              body:
                  '''The first time a dyad hatchling is slain, read [title], [codex] 29.'''),
          codexLink('Crown of a Shocking Eikon',
              number: 56,
              body:
                  '''Immediately when the crown is slain, read [title], [codex] 30'''),
        ],
        startingMap: MapDef(
          id: '3.3',
          columnCount: 13,
          rowCount: 11,
          backgroundRect: Rect.fromLTWH(110.0, 44.0, 1481.0, 1411.0),
          terrain: {
            (0, 0): TerrainType.barrier,
            (0, 3): TerrainType.difficult,
            (0, 9): TerrainType.barrier,
            (1, 0): TerrainType.barrier,
            (1, 1): TerrainType.barrier,
            (1, 3): TerrainType.object,
            (1, 4): TerrainType.difficult,
            (1, 9): TerrainType.barrier,
            (1, 10): TerrainType.barrier,
            (2, 9): TerrainType.difficult,
            (3, 0): TerrainType.start,
            (3, 6): TerrainType.difficult,
            (3, 9): TerrainType.difficult,
            (3, 10): TerrainType.dangerous,
            (4, 9): TerrainType.dangerous,
            (5, 0): TerrainType.start,
            (5, 2): TerrainType.dangerous,
            (5, 5): TerrainType.object,
            (5, 10): TerrainType.dangerous,
            (6, 0): TerrainType.start,
            (7, 0): TerrainType.start,
            (7, 4): TerrainType.difficult,
            (7, 10): TerrainType.dangerous,
            (8, 9): TerrainType.dangerous,
            (9, 0): TerrainType.start,
            (9, 9): TerrainType.dangerous,
            (9, 10): TerrainType.dangerous,
            (10, 1): TerrainType.dangerous,
            (10, 3): TerrainType.object,
            (10, 6): TerrainType.difficult,
            (10, 9): TerrainType.difficult,
            (11, 3): TerrainType.barrier,
            (11, 9): TerrainType.barrier,
            (11, 10): TerrainType.barrier,
            (12, 2): TerrainType.barrier,
            (12, 3): TerrainType.barrier,
            (12, 9): TerrainType.barrier,
          },
        ),
        allies: [
          AllyDef(name: 'Ozendyn', cardId: 'A-014', behaviors: [
            EncounterFigureDef(
              name: 'Picket',
              health: 9,
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
        overlays: [
          EncounterFigureDef(name: 'Hoard', onLoot: [
            codex(54),
            item('Scour Ichor',
                body:
                    '''The Rover that collected the hoard tile gains one “Scour Ichor” item. They may equip this item. If they don’t have the required item slot available, they may unequip items as needed.'''),
          ])
        ],
        adversaries: [
          EncounterFigureDef(
            name: 'Dyad Hatchling',
            letter: 'A',
            standeeCount: 8,
            health: 6,
            affinities: {
              Ether.morph: -2,
              Ether.crux: 2,
            },
            onSlain: [
              codex(55),
            ],
          ),
          EncounterFigureDef(
            name: 'Azoth',
            letter: 'B',
            type: AdversaryType.miniboss,
            standeeCount: 1,
            healthFormula: '5*R',
            defense: 2,
            large: true,
            immuneToForcedMovement: true,
            immuneToTeleport: true,
            affinities: {
              Ether.fire: -2,
              Ether.crux: 1,
              Ether.morph: 1,
            },
          ),
          EncounterFigureDef(
            name: 'Crown',
            letter: 'C',
            type: AdversaryType.miniboss,
            standeeCount: 1,
            alias: 'Crown',
            healthFormula: '12*R',
            traits: [
              'This unit is immune to all damage while the Azoth is alive.',
              'Gains +2 [DMG] to all attacks when the Azoth is slain.',
            ],
            affinities: {
              Ether.crux: 2,
            },
            onSlain: [
              codex(56),
              victory(),
            ],
          ),
        ],
        placements: const [
          PlacementDef(name: 'Dyad Hatchling', c: 0, r: 3),
          PlacementDef(name: 'Dyad Hatchling', c: 7, r: 4),
          PlacementDef(name: 'Dyad Hatchling', c: 10, r: 6),
          PlacementDef(name: 'Dyad Hatchling', c: 3, r: 6),
          PlacementDef(name: 'Dyad Hatchling', c: 1, r: 8, minPlayers: 3),
          PlacementDef(name: 'Dyad Hatchling', c: 11, r: 4, minPlayers: 4),
          PlacementDef(name: 'Azoth', c: 6, r: 9),
          PlacementDef(name: 'Crown', c: 5, r: 8),
          PlacementDef(name: 'Hoard', type: PlacementType.object, c: 4, r: 8),
          PlacementDef(name: 'Hoard', type: PlacementType.object, c: 5, r: 6),
          PlacementDef(name: 'Hoard', type: PlacementType.object, c: 7, r: 7),
          PlacementDef(name: 'Hoard', type: PlacementType.object, c: 8, r: 8),
          PlacementDef(name: 'crux', type: PlacementType.ether, c: 1, r: 3),
          PlacementDef(name: 'crux', type: PlacementType.ether, c: 5, r: 5),
          PlacementDef(name: 'crux', type: PlacementType.ether, c: 10, r: 3),
        ],
      );

  static EncounterDef get encounter3dot4 => EncounterDef(
        questId: '3',
        number: '4',
        title: 'Malign and Particular Suspension',
        setup: EncounterSetup(box: '3/7', map: '20', adversary: '31'),
        victoryDescription:
            'Complete three floors, getting to the top of the tower.',
        lossDescription: 'Lose if Ozendyn is slain.',
        roundLimit: 5,
        campaignLink:
            'Encounter 3.5 - “**Fathomless Chaos**”, [campaign] **52**.',
        challenges: [
          'Rovers remove all ether dice from their personal pool when transitioning into a new floor.',
          'The [miniboss] on floor 2 gains +R*5 [HP].',
          'You have only 4 rounds to complete floor 3.',
        ],
        playerPossibleTokens: ['Hoard'],
        trackerEvents: [
          EncounterTrackerEventDef(
            title: 'Mark when a Rover brings “Bazhar’s Strand” to space [B].',
            recordMilestone: '_laboratory_complete',
            ifMilestone: '_laboratory',
          ),
          EncounterTrackerEventDef(
            title:
                'Mark when all Rovers and Ozendyn occupy an [exit] exit space.',
            recordMilestone: '_vault_complete',
            ifMilestone: '_vault',
          ),
        ],
        onLoad: [
          dialog('Introduction'),
          rules('Ozendyn',
              '''Ozendyn is a character ally to Rovers. Ozendyn begins the encounter on their “Picket” side. Once during this encounter, at the start of the turn of the Rover who controls Ozendyn may choose to flip them over to the “Crucial Sentinel” side. At the end of this turn, flip Ozendyn back over to their “Picket” side.'''),
          rules('A Fixt Monument',
              '''You must scale the Bonespire quickly before your crux-infused reagents lose their potency. To scale the tower and win this encounter you’ll have to complete 3 different floors. 

For each floor, you’ll have 5 rounds to complete it.

You are on the ground floor and must ascend a precarious series of stairs. Slay all enemies to clear the floor and proceed to the next floor.'''),
          subtitle('First Floor'),
          codexLink('Combined to Inculcate',
              number: 57,
              body:
                  '''The first time a fell cradle is slain, read [title], [codex] 31.'''),
          codexLink('In The Dank Twilight I Climbed',
              number: 58,
              body:
                  '''At the end of the round where all adversaries are slain, including the broken vessels that spawn from slaying a fell cradle, read [title], [codex] 31.'''),
        ],
        onWillEndRound: [
          milestone('_first_floor_complete',
              condition: AllAdversariesSlainCondition()),
          milestone('_arboretum_complete',
              condition: MilestoneCondition('_hyperborea_slayed')),
          milestone('_menagerie_complete',
              condition: MilestoneCondition('_rakifa_slayed')),
        ],
        onMilestone: {
          '_first_floor_complete': [
            removeCodexLink(58),
            dialog('First Floor Complete'),
          ],
          '_arboretum': [
            rules('Arboretum',
                '''Proceed to pages 32-33 of the adversary book and page 21 of the map book.

Place Rovers in [start] spaces and spawn adversaries according to Rover count as shown on the map. Rover [HP], ally character [HP], ether dice, and infusion dice carry over. Glyphs and summons carry over and are placed within [Range] 1 of their owner.'''),
            resetRound(
                body:
                    'The round limit has been reset. You have 5 rounds to complete the next floor.'),
            codex(59),
            victoryCondition(
                'Complete three floors, getting to the top of the tower.\n\n**Floor Victory Condition**: Slay the Hyperborea that guards the way.'),
            subtitle('Second Floor: Arboretum'),
            placementGroup('Arboretum', silent: true),
            codexLink('Scattered Petals',
                number: 62,
                body:
                    '''Immediately when the Hyperborea is slain, remove all other enemies from the map. Then complete the round. Then read [title], [codex] 33.'''),
          ],
          '_arboretum_complete': [
            removeCodexLink(62),
            item('Condensed Will',
                body: 'Rovers gain one “Condensed Will” item.'),
            dialog('Second Floor Complete'),
          ],
          '_menagerie': [
            rules('Menagerie',
                '''Proceed to pages 34-35 of the adversary book and page 24 of the map book.

Place Rovers in [start] spaces and spawn adversaries according to Rover count as shown on the map. Rover [HP], ally character [HP], ether dice, and infusion dice carry over. Glyphs and summons carry over and are placed within [Range] 1 of their owner.'''),
            resetRound(
                body:
                    'The round limit has been reset. You have 5 rounds to complete the next floor.'),
            codex(60),
            victoryCondition(
                'Complete three floors, getting to the top of the tower.\n\n**Floor Victory Condition**: Slay the Rakifa that guards the way.'),
            subtitle('Second Floor: Menagerie'),
            placementGroup('Menagerie', silent: true),
            codexLink('Torn Fur',
                number: 61,
                body:
                    '''Immediately when the Rakifa is slain, remove all other enemies from the map. Then complete the round. Then read [title], [codex] 32.'''),
          ],
          '_menagerie_complete': [
            removeCodexLink(61),
            item('Rakifa\'s Garrote',
                body: 'Rovers gain one “Rakifa\'s Garrote” item.'),
            dialog('Second Floor Complete'),
          ],
          '_laboratory': [
            removeRule('Arboretum'),
            removeRule('Menagerie'),
            rules('Laboratory',
                '''Proceed to page **36** of the adversary book and page **22** of the map book.

Place Rovers in [start] spaces and spawn adversaries according to Rover count as shown on the map. Rover [HP], ally character [HP], ether dice, and infusion dice carry over. Glyphs and summons carry over and are placed within [Range] 1 of their owner.'''),
            resetRound(
                body:
                    'The round limit has been reset. You have 5 rounds to complete the next floor.'),
            codex(63),
            terrain('Bazhar\'s Strand',
                '''The hoard tile in space [A] is “Bazhar’s Strand”. A Rover that enters space [A] picks up the hoard tile. To indicate this, place the hoard tile on your class board. This same Rover must now enter space [B] to open the door and win the encounter.'''),
            victoryCondition(
                'Complete three floors, getting to the top of the tower.\n\n**Floor Victory Condition**: Grab “Bazhar’s Strand” at space [A] and bring it to space [B] to open the great doors. You don’t have to kill the abomination, the Zaghan Nahoot, but slaying it could award you a valuable item.'),
            subtitle('Third Floor: Laboratory'),
            placementGroup('Laboratory', silent: true),
            codexLink('The Poison Spreads Far',
                number: 64,
                body:
                    '''If the Zaghan Nahoot is slain, read [title], [codex] 34.'''),
            codexLink('In the Walls of Henzya',
                number: 66,
                body:
                    '''When a Rover brings “Bazhar’s Strand” to space [B], read [title], [codex] 35.'''),
          ],
          '_laboratory_complete': [
            codex(66),
            victory(),
            lyst('20*R'),
          ],
          '_vault': [
            removeRule('Arboretum'),
            removeRule('Menagerie'),
            rules('Vault',
                '''Proceed to page **37** of the adversary book and page **23** of the map book.

Place Rovers in [start] spaces and spawn adversaries according to Rover count as shown on the map. Rover [HP], ally character [HP], ether dice, and infusion dice carry over. Glyphs and summons carry over and are placed within [Range] 1 of their owner.'''),
            resetRound(
                body:
                    'The round limit has been reset. You have 5 rounds to complete the next floor.'),
            codex(65),
            victoryCondition(
                'Complete three floors, getting to the top of the tower.\n\n**Floor Victory Condition**: All Rovers and Ozendyn must occupy an exit space. Try to collect as many treasures and hoard tiles as you can before you leave.'),
            subtitle('Third Floor: Vault'),
            placementGroup('Vault', silent: true),
            milestone(CampaignMilestone.milestone3dot4),
            codexLink('Forgotten Treasure',
                number: 67,
                body:
                    '''If a Rover enters into a space with a hoard tile, remove the tile and read [title], [codex] 35.'''),
            codexLink('Forgotten Treasure [A]',
                number: 68,
                body:
                    '''If a Rover enters into a space with a treasure chest [A], remove the tile and read [title], [codex] 35.'''),
            codexLink('Forgotten Treasure [B]',
                number: 69,
                body:
                    '''If a Rover enters into a space with a treasure chest [B], remove the tile and read [title], [codex] 35.'''),
            codexLink('In the Vault',
                number: 70,
                body:
                    '''At the end of the round when all Rovers and Ozendyn occupy exit spaces [C], read [title], [codex] 35.'''),
          ],
          '_vault_complete': [
            codex(70),
            victory(),
            lyst('10*R'),
          ]
        },
        dialogs: [
          introductionFromText('quest_3_encounter_4_intro'),
          EncounterDialogDef(
              title: 'First Floor Complete',
              body:
                  '''You climb the broken stairs and come to a T intersection. To the left reads Arboretum, to the right, Menagerie. You will have to choose your path.''',
              buttons: [
                EncounterDialogButton(
                    title: 'Arboretum', milestone: '_arboretum'),
                EncounterDialogButton(
                    title: 'Menagerie', milestone: '_menagerie'),
              ]),
          EncounterDialogDef(
              title: 'Second Floor Complete',
              body:
                  '''You climb the broken stairs and come to a T intersection. To the left reads Laboratory, to the right, Vault. Pick a path.''',
              buttons: [
                EncounterDialogButton(
                    title: 'Laboratory', milestone: '_laboratory'),
                EncounterDialogButton(title: 'Vault', milestone: '_vault'),
              ])
        ],
        startingMap: MapDef(
          id: '3.4.1',
          columnCount: 13,
          rowCount: 11,
          backgroundRect: Rect.fromLTWH(110.0, 44.0, 1481.0, 1411.0),
          terrain: {
            (0, 0): TerrainType.start,
            (0, 1): TerrainType.start,
            (0, 2): TerrainType.barrier,
            (0, 4): TerrainType.barrier,
            (0, 6): TerrainType.barrier,
            (0, 8): TerrainType.barrier,
            (1, 0): TerrainType.start,
            (1, 1): TerrainType.start,
            (2, 0): TerrainType.start,
            (3, 0): TerrainType.barrier,
            (3, 5): TerrainType.difficult,
            (3, 10): TerrainType.barrier,
            (4, 9): TerrainType.barrier,
            (5, 0): TerrainType.barrier,
            (5, 9): TerrainType.barrier,
            (5, 10): TerrainType.barrier,
            (6, 4): TerrainType.object,
            (6, 9): TerrainType.barrier,
            (7, 0): TerrainType.barrier,
            (7, 4): TerrainType.object,
            (7, 5): TerrainType.object,
            (7, 9): TerrainType.difficult,
            (7, 10): TerrainType.difficult,
            (8, 8): TerrainType.difficult,
            (8, 9): TerrainType.difficult,
            (9, 0): TerrainType.barrier,
            (9, 2): TerrainType.difficult,
            (9, 7): TerrainType.difficult,
            (9, 9): TerrainType.barrier,
            (9, 10): TerrainType.barrier,
            (10, 8): TerrainType.barrier,
            (10, 9): TerrainType.barrier,
            (11, 0): TerrainType.barrier,
            (11, 8): TerrainType.barrier,
            (11, 9): TerrainType.barrier,
            (11, 10): TerrainType.barrier,
            (12, 0): TerrainType.barrier,
            (12, 7): TerrainType.barrier,
            (12, 8): TerrainType.barrier,
            (12, 9): TerrainType.barrier,
          },
        ),
        allies: [
          AllyDef(name: 'Ozendyn', cardId: 'A-014', behaviors: [
            EncounterFigureDef(
              name: 'Picket',
              health: 9,
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
            EncounterFigureDef(
              name: 'Picket',
              health: 9,
              affinities: {
                Ether.wind: -1,
                Ether.morph: -1,
                Ether.earth: 1,
                Ether.crux: 2,
              },
              abilities: [
                AbilityDef(name: 'Ability', actions: [
                  RoveAction.jump(4),
                  RoveAction.meleeAttack(3,
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
                        condition: MatchesCondition('Stomaw')),
                    actions: [RoveAction.heal(1, endRange: 1)])
              ],
              onSlain: [EncounterAction(type: EncounterActionType.loss)],
            ),
          ])
        ],
        overlays: [
          EncounterFigureDef(name: 'Hoard'),
          EncounterFigureDef(name: 'Treasure'),
        ],
        adversaries: [
          EncounterFigureDef(
            name: 'Broken Vessel',
            letter: 'A',
            standeeCount: 8,
            health: 5,
            flies: true,
            affinities: {
              Ether.crux: -2,
              Ether.morph: 1,
            },
            traits: [
              '''[React] Before this unit is slain, it performs:

[m_attack] | [Range] 1 | [DMG]2 | [miasma] | [Target] all units'''
            ],
          ),
          EncounterFigureDef(
            name: 'Fell Cradle',
            letter: 'B',
            standeeCount: 3,
            health: 14,
            affinities: {
              Ether.crux: -2,
              Ether.morph: 2,
            },
            traits: [
              '''[React] When this unit is slain:
              
Spawn one Broken Vessel in the space this unit occupied.'''
            ],
            onSlain: [
              codex(57),
            ],
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
          ),
        ],
        placements: const [
          PlacementDef(name: 'Broken Vessel', c: 3, r: 6, minPlayers: 3),
          PlacementDef(name: 'Broken Vessel', c: 5, r: 5),
          PlacementDef(name: 'Broken Vessel', c: 7, r: 6),
          PlacementDef(name: 'Broken Vessel', c: 8, r: 5, minPlayers: 3),
          PlacementDef(name: 'Broken Vessel', c: 8, r: 3),
          PlacementDef(name: 'Broken Vessel', c: 10, r: 2, minPlayers: 3),
          PlacementDef(name: 'Fell Cradle', c: 7, r: 8),
          PlacementDef(name: 'Fell Cradle', c: 9, r: 8, minPlayers: 4),
        ],
        placementGroups: [
          PlacementGroupDef(
            name: 'Arboretum',
            terrain: [
              dangerousBramble(1),
            ],
            adversaries: [
              EncounterFigureDef(
                name: 'Dekaha',
                letter: 'A',
                standeeCount: 3,
                health: 7,
                immuneToForcedMovement: true,
                affinities: {
                  Ether.wind: -1,
                  Ether.earth: 1,
                  Ether.fire: -2,
                  Ether.water: 2,
                },
              ),
              EncounterFigureDef(
                  name: 'Ashemak',
                  standeeCount: 3,
                  letter: 'B',
                  health: 6,
                  immuneToForcedMovement: true,
                  affinities: {
                    Ether.fire: 2,
                    Ether.water: -2,
                  },
                  traits: [
                    '''[React] Before this unit is slain: 
                
All units within [Range] 1 suffer [DMG]2.'''
                  ]),
              EncounterFigureDef(
                name: 'Grovetender',
                letter: 'C',
                standeeCount: 3,
                health: 12,
                defense: 1,
                affinities: {
                  Ether.earth: 1,
                  Ether.fire: -1,
                  Ether.water: 2,
                },
                traits: [
                  'If a Rover slays this unit, that Rover [plus_water_earth].'
                ],
                onSlain: [
                  ether([Ether.water, Ether.earth]),
                ],
              ),
              EncounterFigureDef(
                name: 'Hyperborea',
                letter: 'D',
                type: AdversaryType.miniboss,
                standeeCount: 1,
                healthFormula: '6*R',
                defense: 2,
                large: true,
                immuneToForcedMovement: true,
                affinities: {
                  Ether.crux: 1,
                  Ether.fire: -2,
                  Ether.morph: 1,
                },
                onSlain: [
                  milestone('_hyperborea_slayed'),
                  removeAll(),
                ],
              ),
            ],
            map: MapDef(
              id: '3.4.2',
              columnCount: 13,
              rowCount: 11,
              backgroundRect: Rect.fromLTWH(110.0, 44.0, 1481.0, 1411.0),
              terrain: {
                (1, 4): TerrainType.difficult,
                (2, 8): TerrainType.barrier,
                (2, 9): TerrainType.barrier,
                (3, 1): TerrainType.barrier,
                (3, 2): TerrainType.barrier,
                (3, 6): TerrainType.dangerous,
                (3, 9): TerrainType.barrier,
                (4, 1): TerrainType.barrier,
                (4, 4): TerrainType.dangerous,
                (4, 5): TerrainType.difficult,
                (5, 4): TerrainType.dangerous,
                (5, 6): TerrainType.difficult,
                (6, 3): TerrainType.difficult,
                (6, 6): TerrainType.dangerous,
                (6, 7): TerrainType.difficult,
                (7, 4): TerrainType.difficult,
                (7, 6): TerrainType.difficult,
                (7, 10): TerrainType.difficult,
                (8, 0): TerrainType.dangerous,
                (8, 3): TerrainType.dangerous,
                (8, 4): TerrainType.difficult,
                (8, 5): TerrainType.dangerous,
                (8, 6): TerrainType.dangerous,
                (9, 3): TerrainType.dangerous,
                (10, 9): TerrainType.start,
                (11, 3): TerrainType.barrier,
                (11, 4): TerrainType.barrier,
                (11, 9): TerrainType.start,
                (11, 10): TerrainType.start,
                (12, 3): TerrainType.barrier,
                (12, 6): TerrainType.dangerous,
                (12, 8): TerrainType.start,
                (12, 9): TerrainType.start,
              },
            ),
            placements: [
              PlacementDef(name: 'Dekaha', c: 8, r: 4),
              PlacementDef(name: 'Dekaha', c: 4, r: 3, minPlayers: 3),
              PlacementDef(name: 'Ashemak', c: 4, r: 5),
              PlacementDef(name: 'Ashemak', c: 6, r: 7, minPlayers: 4),
              PlacementDef(name: 'Grovetender', c: 4, r: 7),
              PlacementDef(name: 'Grovetender', c: 3, r: 5, minPlayers: 4),
              PlacementDef(name: 'Grovetender', c: 8, r: 2, minPlayers: 3),
              PlacementDef(name: 'Hyperborea', c: 6, r: 5),
            ],
          ),
          PlacementGroupDef(
            name: 'Menagerie',
            terrain: [
              dangerousBramble(1),
            ],
            adversaries: [
              EncounterFigureDef(
                name: 'Kifa',
                letter: 'A',
                standeeCount: 3,
                health: 6,
                flies: true,
                affinities: {
                  Ether.fire: 1,
                  Ether.water: 1,
                  Ether.wind: 1,
                  Ether.earth: 1,
                },
              ),
              EncounterFigureDef(
                name: 'Briarwog',
                letter: 'B',
                standeeCount: 3,
                health: 8,
                affinities: {
                  Ether.earth: -1,
                  Ether.fire: -1,
                  Ether.water: 1,
                  Ether.morph: 1,
                },
              ),
              EncounterFigureDef(
                name: 'Dyad',
                letter: 'C',
                standeeCount: 8,
                health: 12,
                affinities: {
                  Ether.morph: -2,
                  Ether.earth: -1,
                  Ether.water: 1,
                  Ether.crux: 2,
                },
              ),
              EncounterFigureDef(
                name: 'Rakifa',
                healthFormula: '10*R',
                letter: 'D',
                type: AdversaryType.miniboss,
                standeeCount: 1,
                affinities: {
                  Ether.fire: -1,
                  Ether.earth: 2,
                  Ether.wind: 1,
                  Ether.water: -1,
                },
                onSlain: [
                  milestone('_rakifa_slayed'),
                  removeAll(),
                ],
              ),
            ],
            map: MapDef(
              id: '3.4.5',
              columnCount: 13,
              rowCount: 11,
              backgroundRect: Rect.fromLTWH(110.0, 44.0, 1481.0, 1411.0),
              terrain: {
                (0, 8): TerrainType.start,
                (0, 9): TerrainType.start,
                (1, 9): TerrainType.start,
                (1, 10): TerrainType.start,
                (2, 3): TerrainType.dangerous,
                (2, 6): TerrainType.dangerous,
                (2, 9): TerrainType.start,
                (4, 1): TerrainType.dangerous,
                (5, 4): TerrainType.dangerous,
                (5, 8): TerrainType.object,
                (8, 1): TerrainType.openAir,
                (8, 2): TerrainType.object,
                (9, 1): TerrainType.openAir,
                (9, 2): TerrainType.openAir,
                (9, 3): TerrainType.object,
                (9, 8): TerrainType.difficult,
                (9, 9): TerrainType.difficult,
                (9, 10): TerrainType.object,
                (10, 1): TerrainType.openAir,
                (10, 2): TerrainType.openAir,
                (10, 7): TerrainType.difficult,
                (10, 8): TerrainType.difficult,
                (10, 9): TerrainType.difficult,
                (11, 7): TerrainType.object,
                (11, 8): TerrainType.difficult,
                (11, 9): TerrainType.difficult,
                (12, 8): TerrainType.object,
              },
            ),
            placements: [
              PlacementDef(name: 'Kifa', c: 9, r: 1),
              PlacementDef(name: 'Kifa', c: 10, r: 1, minPlayers: 3),
              PlacementDef(name: 'Kifa', c: 9, r: 2, minPlayers: 3),
              PlacementDef(name: 'Briarwog', c: 9, r: 8),
              PlacementDef(name: 'Briarwog', c: 10, r: 7, minPlayers: 3),
              PlacementDef(name: 'Briarwog', c: 9, r: 9, minPlayers: 4),
              PlacementDef(name: 'Dyad', c: 3, r: 2),
              PlacementDef(name: 'Dyad', c: 5, r: 1, minPlayers: 4),
              PlacementDef(name: 'Rakifa', c: 8, r: 3),
            ],
          ),
          PlacementGroupDef(
            name: 'Laboratory',
            terrain: [
              trapMagic(3),
              EncounterTerrain('hoard',
                  title: 'Bazhar\'s Strand',
                  body:
                      'The hoard tile in space [a] is “Bazhar’s Strand”. A Rover that enters space  picks up the hoard tile. To indicate this, place the hoard tile on your class board. This same Rover must now enter space [b] to open the door and win the encounter.')
            ],
            adversaries: [
              EncounterFigureDef(
                name: 'Stomaw',
                letter: 'A',
                standeeCount: 8,
                health: 7,
                affinities: {
                  Ether.fire: -1,
                  Ether.crux: -1,
                  Ether.morph: 1,
                  Ether.earth: 1,
                },
                traits: [
                  'When this unit attacks, if at least one of its allies are adjacent to the target, it gains +1 [DMG] to the attack.'
                ],
              ),
              EncounterFigureDef(
                name: 'Broken Vessel',
                letter: 'A',
                standeeCount: 8,
                health: 5,
                flies: true,
                affinities: {
                  Ether.crux: -2,
                  Ether.morph: 1,
                },
                traits: [
                  '''[React] Before this unit is slain, it performs:

[m_attack] | [Range] 1 | [DMG]2 | [miasma] | [Target] all units'''
                ],
              ),
              EncounterFigureDef(
                name: 'Zaghan Nahoot',
                letter: 'C',
                type: AdversaryType.miniboss,
                standeeCount: 1,
                healthFormula: '10*R',
                affinities: {
                  Ether.crux: -1,
                  Ether.fire: -1,
                  Ether.morph: 2,
                  Ether.wind: 1,
                },
              ),
            ],
            map: MapDef(
              id: '3.4.3',
              columnCount: 13,
              rowCount: 11,
              backgroundRect: Rect.fromLTWH(110.0, 44.0, 1481.0, 1411.0),
              terrain: {
                (0, 1): TerrainType.barrier,
                (0, 2): TerrainType.barrier,
                (0, 8): TerrainType.object,
                (0, 9): TerrainType.object,
                (1, 1): TerrainType.barrier,
                (2, 6): TerrainType.barrier,
                (3, 2): TerrainType.openAir,
                (4, 2): TerrainType.openAir,
                (4, 5): TerrainType.barrier,
                (4, 7): TerrainType.barrier,
                (5, 10): TerrainType.barrier,
                (6, 3): TerrainType.object,
                (6, 4): TerrainType.object,
                (6, 6): TerrainType.openAir,
                (7, 6): TerrainType.openAir,
                (7, 10): TerrainType.barrier,
                (8, 1): TerrainType.object,
                (9, 2): TerrainType.object,
                (9, 5): TerrainType.barrier,
                (9, 6): TerrainType.barrier,
                (10, 0): TerrainType.start,
                (10, 4): TerrainType.barrier,
                (10, 5): TerrainType.barrier,
                (10, 8): TerrainType.object,
                (11, 0): TerrainType.start,
                (11, 1): TerrainType.start,
                (11, 8): TerrainType.object,
                (12, 0): TerrainType.start,
                (12, 1): TerrainType.start,
                (12, 3): TerrainType.openAir,
                (12, 4): TerrainType.openAir,
              },
            ),
            placements: [
              PlacementDef(name: 'Stomaw', c: 12, r: 7, minPlayers: 3),
              PlacementDef(name: 'Stomaw', c: 8, r: 9),
              PlacementDef(name: 'Stomaw', c: 4, r: 9),
              PlacementDef(name: 'Stomaw', c: 5, r: 4, minPlayers: 4),
              PlacementDef(name: 'Broken Vessel', c: 0, r: 3),
              PlacementDef(name: 'Broken Vessel', c: 1, r: 0),
              PlacementDef(name: 'Broken Vessel', c: 3, r: 7, minPlayers: 3),
              PlacementDef(name: 'Broken Vessel', c: 9, r: 7, minPlayers: 4),
              PlacementDef(
                name: 'Zaghan Nahoot',
                c: 8,
                r: 5,
                onSlain: [
                  removeCodexLink(64),
                  item('Zaghan\'s Limb',
                      body: 'Rovers gain one “Zahgan’s Limb” item.'),
                ],
              ),
              PlacementDef(
                  name: 'Magic',
                  type: PlacementType.trap,
                  c: 3,
                  r: 4,
                  trapDamage: 32),
              PlacementDef(
                  name: 'Magic',
                  type: PlacementType.trap,
                  c: 5,
                  r: 1,
                  trapDamage: 3),
              PlacementDef(
                  name: 'Magic',
                  type: PlacementType.trap,
                  c: 6,
                  r: 7,
                  trapDamage: 3),
              PlacementDef(
                  name: 'Magic',
                  type: PlacementType.trap,
                  c: 12,
                  r: 5,
                  trapDamage: 3),
              PlacementDef(
                  name: 'Hoard',
                  alias: 'Bazhar\'s Strand',
                  type: PlacementType.object,
                  c: 1,
                  r: 2,
                  fixedTokens: [
                    'A'
                  ],
                  onLoot: [
                    addToken('Hoard'),
                  ]),
              PlacementDef(name: 'A', type: PlacementType.feature, c: 1, r: 2),
              PlacementDef(name: 'B', type: PlacementType.feature, c: 6, r: 9),
            ],
          ),
          PlacementGroupDef(
            name: 'Vault',
            terrain: [
              trapMagic(3),
              EncounterTerrain('treasure',
                  title: 'Forgotten Treasure',
                  body:
                      'Treasure chests in space [a] and [b] are special. Try your best to collect them.')
            ],
            adversaries: [
              EncounterFigureDef(
                name: 'Querist',
                letter: 'A',
                standeeCount: 6,
                health: 8,
                affinities: {
                  Ether.morph: -2,
                  Ether.crux: 1,
                  Ether.wind: 1,
                },
                traits: [
                  '''[React] After this unit suffers damage from any source and it is at 2 or less [HP]:
              
They flee. Remove this unit from the map.'''
                ],
                reactions: [
                  EnemyReactionDef(
                      trigger: ReactionTriggerDef(
                          type: RoveEventType.afterSuffer,
                          condition: HealthCondition('2-X+1'),
                          targetKind: TargetKind.self),
                      actions: [
                        RoveAction.leave(),
                      ])
                ],
              ),
              EncounterFigureDef(
                name: 'Haunt',
                letter: 'B',
                standeeCount: 4,
                healthFormula: '3*R',
                affinities: {
                  Ether.morph: -2,
                  Ether.crux: 2,
                },
                traits: [
                  '''[React] When this unit enters into a space with a hoard tile:
              
Remove that hoard tile and this unit from the map.'''
                ],
                reactions: [
                  EnemyReactionDef(
                      trigger: ReactionTriggerDef(
                          type: RoveEventType.enteredSpace,
                          condition:
                              InRangeOfAny(range: (0, 0), targets: ['Hoard']),
                          targetKind: TargetKind.self),
                      actions: [
                        RoveAction.loot(),
                        RoveAction.leave(requiresPrevious: true),
                      ])
                ],
              ),
            ],
            map: MapDef(
              id: '3.4.4',
              columnCount: 13,
              rowCount: 11,
              backgroundRect: Rect.fromLTWH(110.0, 44.0, 1481.0, 1411.0),
              terrain: {
                (0, 0): TerrainType.difficult,
                (0, 2): TerrainType.start,
                (0, 3): TerrainType.start,
                (0, 4): TerrainType.start,
                (0, 5): TerrainType.start,
                (0, 6): TerrainType.start,
                (0, 9): TerrainType.barrier,
                (1, 0): TerrainType.difficult,
                (1, 1): TerrainType.difficult,
                (1, 9): TerrainType.barrier,
                (2, 0): TerrainType.difficult,
                (2, 4): TerrainType.difficult,
                (2, 5): TerrainType.difficult,
                (2, 9): TerrainType.barrier,
                (5, 2): TerrainType.object,
                (5, 3): TerrainType.object,
                (5, 7): TerrainType.object,
                (5, 8): TerrainType.object,
                (6, 4): TerrainType.object,
                (6, 5): TerrainType.object,
                (9, 2): TerrainType.difficult,
                (9, 3): TerrainType.difficult,
                (9, 7): TerrainType.object,
                (9, 8): TerrainType.difficult,
                (10, 0): TerrainType.barrier,
                (10, 4): TerrainType.object,
                (10, 5): TerrainType.object,
                (10, 9): TerrainType.barrier,
                (11, 0): TerrainType.barrier,
                (11, 9): TerrainType.difficult,
                (11, 10): TerrainType.barrier,
                (12, 0): TerrainType.barrier,
                (12, 1): TerrainType.barrier,
                (12, 2): TerrainType.exit,
                (12, 3): TerrainType.exit,
                (12, 4): TerrainType.exit,
                (12, 5): TerrainType.exit,
                (12, 6): TerrainType.exit,
                (12, 7): TerrainType.exit,
                (12, 8): TerrainType.barrier,
                (12, 9): TerrainType.barrier,
              },
            ),
            placements: [
              PlacementDef(name: 'Querist', c: 3, r: 0),
              PlacementDef(name: 'Querist', c: 5, r: 1, minPlayers: 4),
              PlacementDef(name: 'Querist', c: 10, r: 2),
              PlacementDef(name: 'Querist', c: 10, r: 7, minPlayers: 3),
              PlacementDef(name: 'Querist', c: 11, r: 8),
              PlacementDef(name: 'Querist', c: 3, r: 10),
              PlacementDef(name: 'Haunt', c: 11, r: 4, minPlayers: 3),
              PlacementDef(name: 'Haunt', c: 3, r: 5, minPlayers: 4),
              PlacementDef(name: 'Haunt', c: 7, r: 0),
              PlacementDef(name: 'Haunt', c: 5, r: 10),
              PlacementDef(
                name: 'Treasure',
                alias: 'Treasure Chest [A]',
                type: PlacementType.object,
                fixedTokens: ['A'],
                c: 1,
                r: 10,
                onLoot: [
                  removeCodexLink(68),
                  item('Miasma Cape',
                      body: 'Rovers gain one “Miasma Cape” item.'),
                ],
              ),
              PlacementDef(
                name: 'Treasure',
                alias: 'Treasure Chest [B]',
                type: PlacementType.object,
                fixedTokens: ['B'],
                c: 11,
                r: 1,
                onLoot: [
                  removeCodexLink(69),
                  item('Coruscant Amblers',
                      body: 'Rovers gain one “Coruscant Amblers” item.'),
                ],
              ),
              PlacementDef(
                name: 'Hoard',
                type: PlacementType.object,
                c: 5,
                r: 5,
                onLoot: [
                  lyst('10', title: 'Forgotten Treasure'),
                ],
              ),
              PlacementDef(
                name: 'Hoard',
                type: PlacementType.object,
                c: 4,
                r: 7,
                onLoot: [
                  lyst('10', title: 'Forgotten Treasure'),
                ],
              ),
              PlacementDef(
                name: 'Hoard',
                type: PlacementType.object,
                c: 6,
                r: 7,
                onLoot: [
                  lyst('10', title: 'Forgotten Treasure'),
                ],
              ),
              PlacementDef(
                name: 'Hoard',
                type: PlacementType.object,
                c: 8,
                r: 7,
                onLoot: [
                  lyst('10', title: 'Forgotten Treasure'),
                ],
              ),
              PlacementDef(
                name: 'Hoard',
                type: PlacementType.object,
                c: 9,
                r: 5,
                onLoot: [
                  lyst('10', title: 'Forgotten Treasure'),
                ],
              ),
              PlacementDef(
                name: 'Hoard',
                type: PlacementType.object,
                c: 7,
                r: 5,
                onLoot: [
                  lyst('10', title: 'Forgotten Treasure'),
                ],
              ),
              PlacementDef(
                name: 'Hoard',
                type: PlacementType.object,
                c: 11,
                r: 5,
                onLoot: [
                  lyst('10', title: 'Forgotten Treasure'),
                ],
              ),
              PlacementDef(
                name: 'Hoard',
                type: PlacementType.object,
                c: 6,
                r: 2,
                onLoot: [
                  lyst('10', title: 'Forgotten Treasure'),
                ],
              ),
              PlacementDef(
                name: 'Hoard',
                type: PlacementType.object,
                c: 4,
                r: 2,
                onLoot: [
                  lyst('10', title: 'Forgotten Treasure'),
                ],
              ),
              PlacementDef(
                  name: 'Magic',
                  type: PlacementType.trap,
                  c: 3,
                  r: 3,
                  trapDamage: 3),
              PlacementDef(
                  name: 'Magic',
                  type: PlacementType.trap,
                  c: 4,
                  r: 6,
                  trapDamage: 3),
              PlacementDef(
                  name: 'Magic',
                  type: PlacementType.trap,
                  c: 10,
                  r: 1,
                  trapDamage: 3),
              PlacementDef(
                  name: 'Magic',
                  type: PlacementType.trap,
                  c: 11,
                  r: 2,
                  trapDamage: 3),
            ],
          ),
        ],
      );

  static EncounterDef get encounter3dot5 => EncounterDef(
      questId: '3',
      number: '5',
      title: 'Fathomless Chaos',
      setup: EncounterSetup(box: '3/7', map: '25', adversary: '38-39'),
      victoryDescription: 'Slay Bazhar.',
      lossDescription: 'Lose if Ozendyn is slain. ',
      roundLimit: 5,
      baseLystReward: 25,
      campaignLink: 'Chapter 3 - “**A Consequence**”, [campaign] **66**.',
      itemRewards: [
        'Twisted Chargers',
      ],
      unlocksTrait: true,
      milestone: CampaignMilestone.milestone3dot5,
      challenges: [
        'Bazhar Caller gains +2 [DEF] as long as there are other adversaries on the map.',
        'Increase the damage and push effects of Bazhar Charger’s trait by +1.',
        'When Bazhar Absolute spawns broken vessels, they spawn R of them instead.',
      ],
      dialogs: [
        introductionFromText('quest_3_encounter_5_intro'),
      ],
      onLoad: [
        dialog('Introduction'),
        rules('3 Phase Encounter',
            'This is a 3 phase fight. Each phase has its own round limit.'),
        rules('Ozendyn',
            '''Ozendyn is a character ally to Rovers. Ozendyn begins the encounter on their “Picket” side. Once during this encounter, at the start of the turn of the Rover who controls Ozendyn may choose to flip them over to their “Crucial Sentinel” side. At the end of this turn, flip Ozendyn back over to their “Picket” side.'''),
        rules('Bazhar',
            '''This broken creature is powerful and can withstand incredible damage. Read each statistic block carefully, including traits, to understand what Bazhar is capable of.'''),
        codexLink('Many Pairs of Legs',
            number: 71,
            body:
                '''Immediately after the turn where Bazhar Caller is defeated, read [title], [codex] 36.'''),
      ],
      startingMap: MapDef(
        id: '3.5',
        columnCount: 13,
        rowCount: 11,
        backgroundRect: Rect.fromLTWH(110.0, 44.0, 1481.0, 1411.0),
        terrain: {
          (0, 0): TerrainType.unplayable,
          (0, 2): TerrainType.unplayable,
          (0, 4): TerrainType.barrier,
          (0, 6): TerrainType.barrier,
          (1, 0): TerrainType.unplayable,
          (1, 1): TerrainType.unplayable,
          (1, 2): TerrainType.barrier,
          (1, 8): TerrainType.barrier,
          (2, 0): TerrainType.unplayable,
          (3, 0): TerrainType.barrier,
          (3, 10): TerrainType.barrier,
          (5, 1): TerrainType.barrier,
          (5, 9): TerrainType.barrier,
          (7, 0): TerrainType.barrier,
          (7, 10): TerrainType.barrier,
          (9, 0): TerrainType.barrier,
          (9, 1): TerrainType.barrier,
          (9, 9): TerrainType.barrier,
          (9, 10): TerrainType.barrier,
          (10, 0): TerrainType.start,
          (11, 0): TerrainType.start,
          (11, 1): TerrainType.start,
          (11, 4): TerrainType.barrier,
          (11, 7): TerrainType.barrier,
          (11, 8): TerrainType.barrier,
          (11, 10): TerrainType.unplayable,
          (12, 0): TerrainType.start,
          (12, 1): TerrainType.start,
          (12, 2): TerrainType.barrier,
          (12, 4): TerrainType.barrier,
          (12, 6): TerrainType.barrier,
          (12, 9): TerrainType.unplayable,
        },
      ),
      allies: [
        AllyDef(name: 'Ozendyn', cardId: 'A-014', behaviors: [
          EncounterFigureDef(
            name: 'Picket',
            health: 9,
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
            onMilestone: {
              '_absolute': [
                remove(null, silent: true),
                rules('Ozendyn',
                    '''*Ozendyn has been grievously injured and is out of the fight.*  Remove Ozendyn from the map, but the encounter is not lost. If Ozendyn did not use the ability found on his “Crucial Sentinel” side, any Rover during their turn may replace one of their ability activations with the ability found on the “Crucial Sentinel” side of Ozendyn’s ally card. This special rule can only be used once.'''),
              ],
            },
          ),
          EncounterFigureDef(
            name: 'Crucial Sentinel',
            health: 9,
            affinities: {
              Ether.wind: -1,
              Ether.morph: -1,
              Ether.earth: 1,
              Ether.crux: 2,
            },
            abilities: [
              AbilityDef(name: 'Ability', actions: [
                RoveAction.jump(4),
                RoveAction.meleeAttack(3,
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
                      condition: MatchesCondition('Stomaw')),
                  actions: [RoveAction.heal(1, endRange: 1)])
            ],
            onSlain: [fail()],
            onStartPhase: [
              EncounterAction(type: EncounterActionType.toggleBehavior),
            ],
            onMilestone: {
              '_absolute': [
                remove(null, silent: true),
                rules('Ozendyn',
                    '''*Ozendyn has been grievously injured and is out of the fight.*  Remove Ozendyn from the map, but the encounter is not lost. If Ozendyn did not use the ability found on his “Crucial Sentinel” side, any Rover during their turn may replace one of their ability activations with the ability found on the “Crucial Sentinel” side of Ozendyn’s ally card. This special rule can only be used once.'''),
              ],
            },
          ),
        ]),
      ],
      adversaries: [
        EncounterFigureDef(
          name: 'Stomaw',
          letter: 'A',
          standeeCount: 8,
          health: 7,
          traits: [
            'When this unit attacks, if at least one of its allies are adjacent to the target, it gains +1 [DMG] to the attack.'
          ],
        ),
        EncounterFigureDef(
          name: 'Fell Cradle',
          letter: 'B',
          standeeCount: 3,
          health: 14,
          affinities: {
            Ether.crux: -2,
            Ether.morph: 2,
          },
          traits: [
            '''[React] When this unit is slain:
            
Spawn one Broken Vessel in the space this unit occupied.'''
          ],
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
        ),
        EncounterFigureDef(
          name: 'Bazhar',
          letter: 'C',
          type: AdversaryType.boss,
          standeeCount: 1,
          alias: 'Bazhar Caller',
          healthFormula: '12*R',
          large: true,
          affinities: {
            Ether.crux: -2,
            Ether.morph: 2,
          },
          onSlain: [
            codex(71),
            rules(
                'Bazhar Charger',
                '''Bazhar Caller now uses the Bazhar Charger statistic block, recovering its current [HP] to maximum. Move the Bazhar Caller ability token to the same ability number on the Bazhar Charger statistic block.

Spawn one stomaw adjacent to each Rover.''',
                silent: true),
            replace('Bazhar Charger',
                title: 'Bazhar Charger',
                body:
                    'Bazhar Caller now uses the Bazhar Charger statistic block, recovering its current [HP] to maximum. Move the Bazhar Caller ability token to the same ability number on the Bazhar Charger statistic block.'),
            resetRound(
                title: 'Bazhar Charger',
                body:
                    'The round limit has been reset. You have 5 rounds to defeat Bazhar Charger.'),
            placementGroup('Many Pairs of Legs',
                title: 'Bazhar Charger',
                body: 'Spawn one stomaw adjacent to each Rover.'),
            codexLink('Whisperer in the Darkness',
                number: 72,
                body:
                    '''Immediately after the turn where Bazhar Charger is defeated, read [title], [codex] 36.'''),
          ],
        ),
        EncounterFigureDef(
          name: 'Bazhar Charger',
          letter: 'C',
          type: AdversaryType.boss,
          standeeCount: 1,
          healthFormula: '15*R',
          large: true,
          affinities: {
            Ether.crux: -2,
            Ether.morph: 2,
          },
          traits: [
            'Can enter into spaces occupied by enemies. If this unit does, that enemy suffers 1 damage and is pushed 1 away.'
          ],
          onSlain: [
            removeRule('Bazhar Charger'),
            codex(72),
            rules(
              'Bazhar Absolute',
              '''Bazhar Charger now uses the Bazhar Absolute statistic block, recovering its current [HP] to maximum. Move the Bazhar Charger ability token to the same ability number on the Bazhar Absolute statistic block.

Return Bazhar to its starting location. If there are other units occupying Bazhar’s starting location, move those units the fewest number of spaces so that they no longer occupy Bazhar’s starting location.''',
              silent: true,
            ),
            replace('Bazhar Absolute',
                title: 'Bazhar Absolute',
                body:
                    '''Bazhar Charger now uses the Bazhar Absolute statistic block, recovering its current [HP] to maximum. Move the Bazhar Charger ability token to the same ability number on the Bazhar Absolute statistic block.

Return Bazhar to its starting location. If there are other units occupying Bazhar’s starting location, move those units the fewest number of spaces so that they no longer occupy Bazhar’s starting location.'''),
            resetRound(
                title: 'Bazhar Absolute',
                body:
                    'The round limit has been reset. You have 5 rounds to defeat Bazhar Absolute.'),
            codexLink('One Black Tower',
                number: 73,
                body:
                    '''Immediately when Bazhar Absolute is slain, read [title], [codex] 37.'''),
            milestone('_absolute'),
          ],
        ),
        EncounterFigureDef(
          name: 'Bazhar Absolute',
          letter: 'C',
          type: AdversaryType.boss,
          standeeCount: 1,
          healthFormula: '18*R',
          large: true,
          immuneToForcedMovement: true,
          immuneToTeleport: true,
          affinities: {
            Ether.crux: -2,
            Ether.morph: 2,
          },
          onSlain: [
            codex(73),
            victory(),
            codex(74),
          ],
        ),
        EncounterFigureDef(
          name: 'Broken Vessel',
          letter: 'D',
          standeeCount: 8,
          health: 5,
          flies: true,
          affinities: {
            Ether.crux: -2,
            Ether.morph: 1,
          },
          traits: [
            '''[React] Before this unit is slain, it performs:
            
[m_attack] | [Range] 1 | [DMG]2 | [miasma] | [Target] all units'''
          ],
        ),
      ],
      placements: const [
        PlacementDef(name: 'Bazhar', c: 6, r: 5),
        PlacementDef(name: 'Broken Vessel', c: 4, r: 6),
        PlacementDef(name: 'Broken Vessel', c: 8, r: 6),
        PlacementDef(name: 'Broken Vessel', c: 4, r: 3),
        PlacementDef(name: 'Broken Vessel', c: 2, r: 4, minPlayers: 3),
        PlacementDef(name: 'Broken Vessel', c: 2, r: 1, minPlayers: 3),
        PlacementDef(name: 'Broken Vessel', c: 6, r: 8, minPlayers: 3),
        PlacementDef(name: 'Fell Cradle', c: 8, r: 9),
        PlacementDef(name: 'Fell Cradle', c: 0, r: 3, minPlayers: 4),
      ],
      placementGroups: [
        PlacementGroupDef(name: 'Many Pairs of Legs', placements: [
          PlacementDef(name: 'Stomaw'),
          PlacementDef(name: 'Stomaw'),
          PlacementDef(name: 'Stomaw', minPlayers: 3),
          PlacementDef(name: 'Stomaw', minPlayers: 4),
        ])
      ]);
}
