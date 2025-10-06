import 'dart:ui';
import 'encounter_def_utils.dart';
import 'package:rove_data_types/rove_data_types.dart';

extension Quest10 on EncounterDef {
  static EncounterDef get encounter10dot1 => EncounterDef(
        expansion: 'xulc',
        questId: '10_act1',
        number: '1',
        title: 'The Nameless Black of a Name',
        setup: EncounterSetup(
            box: 'XU-1', map: '3', adversary: '2', tiles: '2x Hatchery'),
        victoryDescription: 'Slay all adversaries.',
        roundLimit: 8,
        terrain: [
          dangerousBones(2),
          trapHatchery(4),
          difficultWater(),
          etherCrux(),
          etherMorph(),
        ],
        milestone: CampaignMilestone.milestone10dot1,
        campaignLink: 'Intermission - “**Strange Days**”, [campaign] **6**.',
        challenges: [
          'When rolling the damage dice for adversary attacks, increase the result of [DIM] by +1[DMG].',
          'When rolling the xulc dice, reroll any results of a blank face.',
          'Xulc are immune to the effects of ether fields.',
        ],
        dialogs: [
          introductionFromText('quest_10_encounter_1_intro'),
        ],
        onLoad: [
          dialog('Introduction'),
          codexLink('Kill it With Fire!',
              number: 1,
              body:
                  'Immediately after the action where the first stomaw or an urn are slain, read [title], [codex] 1.'),
        ],
        onMilestone: {
          CampaignMilestone.milestone10dot1XulcRevealed: [
            codex(1),
            rules('Something is Wrong Here',
                '''Flip the adversary book to page 3. Stomaws are now writhing stomaws and urns are now stolen urns. Ability tokens stay on the same ability block after flipping pages.

Writhing stomaw and stolen urn have the **Infected** trait.

Spawn one cleaving xulc in the space of the urn or stomaw that was just slain. If the urn was slain, read [codex_entry] 2, “Riddled Shell”, [codex] 2 now.'''),
            codexLink('Riddled Shell',
                number: 2,
                body:
                    'Each time a stolen urn is slain, read [title], [codex] 2.'),
            milestone('_urn_slain', condition: IsSlainCondition('Urn')),
            rules('Infected',
                '''Make sure you have the Xulc board – flipped to the **A** side – xulc standees, and xulc dice nearby.

When an **Infected** adversary is slain, roll the xulc dice and spawn the result in the space of the slain adversary. A result of [cleaving] spawns one cleaving xulc, [armor] spawns one armor xulc, or [flying_xulc] spawns one flying xulc. The last face of the dice has no icon. A result of blank slays the xulc within the host and no xulc is spawned. If all standees of a xulc type are on the map and the result of rolling the xulc dice is that xulc type, nothing is spawned.

For the remainder of this campaign, keep the xulc board, xulc standees, and xulc dice nearby. All enemies with the **Infected** trait follow these rules. Until instructed otherwise, always use the **A** side of the xulc board.

Xulc are adversaries and they take their turns before all other adversaries, activating in the order they are printed on the xulc page from top to bottom, then in standee order.'''),
            codexLink('Infected',
                number: 3,
                body:
                    'At the end of the round where all adversaries are slain, read [title], [codex] 2.'),
          ],
          '_urn_slain': [
            codex(2),
            lyst('5*R', title: 'Riddled Shell'),
            item('Dimming Stone',
                title: 'Riddled Shell',
                body:
                    '''The Rover that slayed the urn gains one “**Dimming Stone**” item (found in the Xulc merchant deck). They may equip this item. If they don’t have the required item slot(s) available, they may unequip items as needed.'''),
          ],
          '_victory': [
            codex(3),
            victory(
                body:
                    '''*You have been infected!  Your magic is strong and holding the parasite at bay… for now.*

The parasite is attempting to strengthen its bond with you. As a result of this, all Rovers gain +3 [HP].

Open the infected deck of skill cards. All Rovers must select and permanently add one infected skill card to their hand. This infected card does not count toward the number of skill or reaction cards you may take into an encounter.'''),
          ],
        },
        startingMap: MapDef(
          id: '10.1',
          columnCount: 13,
          rowCount: 11,
          backgroundRect: Rect.fromLTWH(125.0, 44.0, 1481.0, 1411.0),
          starts: [
            (5, 5),
            (6, 4),
            (6, 5),
            (7, 5),
          ],
          terrain: {
            (1, 2): TerrainType.object,
            (1, 5): TerrainType.difficult,
            (1, 6): TerrainType.difficult,
            (1, 7): TerrainType.difficult,
            (1, 8): TerrainType.difficult,
            (1, 9): TerrainType.dangerous,
            (2, 4): TerrainType.difficult,
            (2, 5): TerrainType.barrier,
            (2, 8): TerrainType.difficult,
            (3, 1): TerrainType.barrier,
            (3, 4): TerrainType.difficult,
            (3, 8): TerrainType.object,
            (4, 2): TerrainType.object,
            (4, 3): TerrainType.difficult,
            (5, 0): TerrainType.difficult,
            (5, 1): TerrainType.difficult,
            (5, 2): TerrainType.difficult,
            (5, 3): TerrainType.difficult,
            (6, 2): TerrainType.difficult,
            (6, 7): TerrainType.object,
            (7, 3): TerrainType.difficult,
            (8, 2): TerrainType.object,
            (8, 3): TerrainType.difficult,
            (9, 4): TerrainType.difficult,
            (9, 5): TerrainType.difficult,
            (10, 1): TerrainType.object,
            (10, 4): TerrainType.barrier,
            (10, 5): TerrainType.difficult,
            (10, 6): TerrainType.difficult,
            (10, 7): TerrainType.difficult,
            (11, 3): TerrainType.dangerous,
            (11, 9): TerrainType.object,
          },
        ),
        adversaries: [
          EncounterFigureDef(
            name: 'Cleaving Xulc',
            standeeCount: 8,
            health: 6,
            traits: [
              'Ignores the effects of water and xulc terrain.',
            ],
            affinities: {
              Ether.dim: 1,
            },
            onSlain: [
              milestone('_victory', condition: AllAdversariesSlainCondition()),
            ],
            spawnable: true,
          ),
          EncounterFigureDef(
            name: 'Armored Xulc',
            standeeCount: 8,
            health: 5,
            defense: 2,
            traits: [
              'Ignores the effects of water and xulc terrain.',
            ],
            affinities: {
              Ether.dim: 2,
            },
            onSlain: [
              milestone('_victory', condition: AllAdversariesSlainCondition()),
            ],
            spawnable: true,
          ),
          EncounterFigureDef(
            name: 'Flying Xulc',
            standeeCount: 8,
            health: 5,
            flies: true,
            traits: [
              '[React] After this unit is attacked:\n\nLogic: Retreat\n[Dash] 2',
            ],
            affinities: {
              Ether.dim: 1,
            },
            onSlain: [
              milestone('_victory', condition: AllAdversariesSlainCondition()),
            ],
            spawnable: true,
          ),
          EncounterFigureDef(
            name: 'Stomaw',
            letter: 'A',
            standeeCount: 6,
            health: 12,
            traits: [
              'When this unit attacks, if at least one of its allies are adjacent to the target, it gains +1 [DMG] to the attack.',
            ],
            affinities: {
              Ether.crux: -1,
              Ether.fire: -2,
              Ether.earth: 1,
              Ether.morph: 2,
            },
            onSlain: [
              replace('Cleaving Xulc', silent: true),
              milestone(CampaignMilestone.milestone10dot1XulcRevealed,
                  silent: true),
              milestone('_victory', condition: AllAdversariesSlainCondition()),
            ],
          ),
          EncounterFigureDef(
            name: 'Writhing Stomaw',
            letter: 'A',
            standeeCount: 6,
            health: 12,
            carryState: true,
            infected: true,
            traits: [
              'When this unit attacks, if at least one of its allies are adjacent to the target, it gains +1 [DMG] to the attack.',
            ],
            affinities: {
              Ether.crux: -1,
              Ether.fire: -2,
              Ether.earth: 1,
              Ether.morph: 2,
            },
            onSlain: [
              milestone('_victory', condition: AllAdversariesSlainCondition()),
            ],
          ),
          EncounterFigureDef(
            name: 'Broken Vessel',
            standeeCount: 6,
            letter: 'B',
            health: 8,
            flies: true,
            traits: [
              '''[React] Before this unit is slain it performs:
              
[m_attack] | [Range] 1-2 | [DMG]2 | [miasma] | [Target] all units''',
            ],
            affinities: {
              Ether.crux: -2,
              Ether.morph: 2,
            },
            onSlain: [
              milestone('_victory', condition: AllAdversariesSlainCondition()),
            ],
          ),
          EncounterFigureDef(
            name: 'Urn',
            letter: 'C',
            standeeCount: 1,
            healthFormula: '4*R',
            defense: 3,
            affinities: {
              Ether.fire: 2,
              Ether.wind: 2,
              Ether.earth: 2,
              Ether.water: 2,
            },
            onSlain: [
              replace('Cleaving Xulc', silent: true),
              milestone(CampaignMilestone.milestone10dot1XulcRevealed,
                  silent: true),
              milestone('_victory', condition: AllAdversariesSlainCondition()),
            ],
          ),
          EncounterFigureDef(
            name: 'Stolen Urn',
            letter: 'C',
            standeeCount: 2,
            healthFormula: '4*R',
            defense: 3,
            carryState: true,
            infected: true,
            affinities: {
              Ether.fire: 2,
              Ether.wind: 2,
              Ether.earth: 2,
              Ether.water: 2,
            },
            onSlain: [
              codex(2),
              lyst('5*R', title: 'Riddled Shell'),
              item('Dimming Stone',
                  title: 'Riddled Shell',
                  body:
                      '''The Rover that slayed the stolen urn gains one “**Dimming Stone**” item (found in the Xulc merchant deck). They may equip this item. If they don’t have the required item slot(s) available, they may unequip items as needed.'''),
              milestone('_victory', condition: AllAdversariesSlainCondition()),
            ],
          ),
        ],
        placements: [
          PlacementDef(
            name: 'Stomaw',
            c: 2,
            r: 2,
            onMilestone: {
              CampaignMilestone.milestone10dot1XulcRevealed: [
                replace('Writhing Stomaw', silent: true),
              ],
            },
          ),
          PlacementDef(
            name: 'Stomaw',
            c: 12,
            r: 4,
            minPlayers: 4,
            onMilestone: {
              CampaignMilestone.milestone10dot1XulcRevealed: [
                replace('Writhing Stomaw', silent: true),
              ],
            },
          ),
          PlacementDef(
            name: 'Stomaw',
            c: 12,
            r: 9,
            onMilestone: {
              CampaignMilestone.milestone10dot1XulcRevealed: [
                replace('Writhing Stomaw', silent: true),
              ],
            },
          ),
          PlacementDef(
            name: 'Stomaw',
            c: 0,
            r: 9,
            minPlayers: 4,
            onMilestone: {
              CampaignMilestone.milestone10dot1XulcRevealed: [
                replace('Writhing Stomaw', silent: true),
              ],
            },
          ),
          PlacementDef(
            name: 'Stomaw',
            c: 3,
            r: 10,
            minPlayers: 3,
            onMilestone: {
              CampaignMilestone.milestone10dot1XulcRevealed: [
                replace('Writhing Stomaw', silent: true),
              ],
            },
          ),
          PlacementDef(
            name: 'Stomaw',
            c: 11,
            r: 8,
            onMilestone: {
              CampaignMilestone.milestone10dot1XulcRevealed: [
                replace('Writhing Stomaw', silent: true),
              ],
            },
          ),
          PlacementDef(name: 'Broken Vessel', c: 1, r: 0),
          PlacementDef(name: 'Broken Vessel', c: 4, r: 1, minPlayers: 3),
          PlacementDef(name: 'Broken Vessel', c: 2, r: 7),
          PlacementDef(name: 'Broken Vessel', c: 9, r: 2),
          PlacementDef(name: 'Broken Vessel', c: 7, r: 0, minPlayers: 4),
          PlacementDef(name: 'Broken Vessel', c: 12, r: 0, minPlayers: 3),
          PlacementDef(
            name: 'Urn',
            c: 6,
            r: 8,
            onMilestone: {
              CampaignMilestone.milestone10dot1XulcRevealed: [
                replace('Stolen Urn', silent: true),
              ],
            },
          ),
          PlacementDef(
              name: 'Hatchery',
              type: PlacementType.trap,
              c: 0,
              r: 3,
              trapDamage: 4),
          PlacementDef(
              name: 'Hatchery',
              type: PlacementType.trap,
              c: 9,
              r: 10,
              trapDamage: 4),
          PlacementDef(name: 'crux', type: PlacementType.ether, c: 1, r: 2),
          PlacementDef(name: 'crux', type: PlacementType.ether, c: 8, r: 2),
          PlacementDef(name: 'morph', type: PlacementType.ether, c: 3, r: 8),
          PlacementDef(name: 'morph', type: PlacementType.ether, c: 11, r: 9),
        ],
      );

  static EncounterDef get encounter10dot2dotEarly => EncounterDef(
        expansion: 'xulc',
        questId: '10_act1',
        number: '2.early',
        title: 'Nidifugous by Nature',
        setup: EncounterSetup(
            box: 'XU-1',
            map: '4',
            adversary: '4',
            tiles: '4x Pod Traps, 3x Hoards'),
        victoryDescription: 'Slay the Nidus.',
        roundLimit: 10,
        terrain: [
          dangerousBones(2),
          trapPod(3),
          difficultWater(),
          etherWater(),
          etherMorph(),
        ],
        milestone: CampaignMilestone.milestone10dot2,
        baseLystReward: 20,
        campaignLink:
            '''Check your campaign sheet, if you do not have either milestone “**Rescued the Merchants… Again**” or “**Made a Powerful Ally**” marked, select your next encounter:

Encounter 3 - “**Keen Debtors**”, [campaign] **16** or Encounter 4 - “**Ought Never to Sprout**”, [campaign] **20**.

If you have the milestones “**Made A Powerful Ally**” marked and “**Rescued the Merchants… Again**” not marked, proceed to:

Encounter 3 - “**Keen Debtors**”, [campaign] **18**.

If you have the milestones “**Rescued the Merchants… Again**” marked and “**Made A Powerful Ally**” not marked, proceed to:

Encounter 4 - “**Ought Never to Sprout**”, [campaign] **24**.''',
        challenges: [
          'The Nidus gains +5*R [HP].',
          'Each time a Rover deals 3 or more [DMG] with an attack, they drain an ether dice in their personal pool, if able to.',
          'When an effect of the Nidus would have you roll the xulc dice, reroll any results of a blank face.',
        ],
        dialogs: [
          introductionFromText('quest_10_encounter_2_early_intro'),
        ],
        allies: [
          AllyDef(
            name: 'Hra',
            cardId: 'A-024',
            behaviors: [
              EncounterFigureDef(
                name: 'Marl',
                health: 10,
                traits: [
                  'Push and pull effects targeting this unit are reduced by 1.',
                ],
                affinities: {
                  Ether.wind: -2,
                  Ether.fire: -1,
                  Ether.water: 1,
                  Ether.earth: 2,
                },
              )
            ],
          ),
        ],
        onLoad: [
          remove('Hra',
              condition: MilestoneCondition(CampaignMilestone.milestone10dot4,
                  value: false),
              silent: true),
          dialog('Introduction'),
          rules(
              'Balatronists',
              '''*You have milestone “**${CampaignMilestone.milestone3dot4}**” marked in your core box campaign sheet.*

*The zusag before you are familiar - they are the querists that bothered you when you were last in the Unsouled Barrens! It appears Silky, in all his sneaky wisdom, had kept tabs on the rebellious young associates all this time. At the centre of the querists is another, more welcome familiar face; Ozendyn and his pet coruscopod, Gargaki. The old warrior appears tired and bruised - it’s clear that he has been fighting off this xulc-infested creature to defend the zusag, but had been brought low by its hulking form and the writhing stomaw around him. One of the querists notices you. “Rovers! It’s the Rovers! Thank the Nose - Ozendyn, he needs your help!” You rush into battle as the zusag appear steeled by your presence, pushing through their fear to summon glyphs of pure crux to aid you.*

Replace up to 3 pod traps with 3 reflective glyph traps. If an adversary triggers this trap, they suffer [DMG]3. If a Rover triggers this trap, they recover [RCV] 3.''',
              condition: MilestoneCondition(CampaignMilestone.milestone3dot4)),
          rules(
              'Balatronists',
              '''*You have milestone “**${CampaignMilestone.milestone7dot2Querists3}**” marked in your core box campaign sheet.*

*The zusag before you are familiar - they are the querists that bothered you when you were last in the Unsouled Barrens! It appears Silky, in all his sneaky wisdom, had kept tabs on the rebellious young associates all this time. At the centre of the querists is another, more welcome familiar face; Ozendyn and his pet coruscopod, Gargaki. The old warrior appears tired and bruised - it’s clear that he has been fighting off this xulc-infested creature to defend the zusag, but had been brought low by its hulking form and the writhing stomaw around him. One of the querists notices you. “Rovers! It’s the Rovers! Thank the Nose - Ozendyn, he needs your help!” You rush into battle as the zusag appear steeled by your presence, pushing through their fear to summon glyphs of pure crux to aid you.*

Replace up to 3 pod traps with 3 reflective glyph traps. If an adversary triggers this trap, they suffer [DMG]3. If a Rover triggers this trap, they recover [RCV] 3.''',
              condition: MilestoneCondition(
                  CampaignMilestone.milestone7dot2Querists3)),
          rules(
              'Gargaki',
              '''*You do not have either milestone “**${CampaignMilestone.milestone3dot4}**” or “**${CampaignMilestone.milestone7dot2Querists3}**”  marked in your core box campaign sheet.*

*The zusag are youthful - querists, the rebellious sort who go out to seek adventure in the world beyond their clans. They are frightened, wielding polearms not as weapons but as a tree does its branch in a storm - flailing stiffly, awkwardly, under pressure. In the centre is the old warrior you know from this place known as Ozendyn, that final warrior who would chop down the bonespire with his sword alone if he thought he’d live long enough to see it done. The warrior lies bloodied, but his companion coruscopod Gargaki recognizes you and rushes to your aid with a slithering, hungry pur.*

One Rover gains the following passive benefit for this encounter:

**Gargaki**: When a writhing stomaw is slain, perform: [Heal] | [Range] 0-1 | [RCV] 1 | [Everbloom]''',
              conditions: [
                MilestoneCondition(CampaignMilestone.milestone3dot4,
                    value: false),
                MilestoneCondition(CampaignMilestone.milestone7dot2Querists3,
                    value: false)
              ]),
          codexLink('What was Lost',
              number: 4,
              body:
                  'If a Rover enters into a space with hoard tile [A], remove the tile and read [title], [codex] 3.'),
          codexLink('What Once Was',
              number: 5,
              body:
                  'If a Rover enters into a space with hoard tile [B], remove the tile and read [title], [codex] 3.'),
          codexLink('What Will Never Be',
              number: 6,
              body:
                  'If a Rover enters into a space with hoard tile [C], remove the tile and read [title], [codex] 3.'),
          codexLink('It Burst with a Nervous Little Pop!',
              number: 7,
              body:
                  'Immediately when the Nidus is slain, read [title], [codex] 4.'),
        ],
        onMilestone: {
          '_victory': [
            codex(7),
            victory(
                body:
                    '''*You’ve slain a powerful foe and learned much about this new threat, but your foe has also learned a lot about you and your infection worsens.*

All Rovers must select and permanently add one infected skill card to their hand. This infected card **DOES** count toward the number of skill or reaction cards you may take in an encounter.'''),
          ],
        },
        startingMap: MapDef(
          id: '10.2.early',
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
            (1, 1): TerrainType.object,
            (2, 8): TerrainType.dangerous,
            (3, 2): TerrainType.object,
            (3, 4): TerrainType.difficult,
            (3, 5): TerrainType.difficult,
            (3, 6): TerrainType.difficult,
            (3, 7): TerrainType.barrier,
            (4, 0): TerrainType.dangerous,
            (4, 5): TerrainType.difficult,
            (4, 6): TerrainType.difficult,
            (5, 9): TerrainType.object,
            (6, 6): TerrainType.object,
            (7, 9): TerrainType.object,
            (8, 5): TerrainType.difficult,
            (9, 4): TerrainType.barrier,
            (9, 5): TerrainType.difficult,
            (9, 6): TerrainType.difficult,
            (10, 1): TerrainType.object,
            (10, 4): TerrainType.difficult,
            (10, 5): TerrainType.difficult,
            (11, 4): TerrainType.dangerous,
          },
        ),
        overlays: [EncounterFigureDef(name: 'Hoard')],
        adversaries: [
          EncounterFigureDef(
            name: 'Cleaving Xulc',
            standeeCount: 8,
            health: 6,
            traits: [
              'Ignores the effects of water and xulc terrain.',
            ],
            affinities: {
              Ether.dim: 1,
            },
            spawnable: true,
          ),
          EncounterFigureDef(
            name: 'Armored Xulc',
            standeeCount: 8,
            health: 5,
            defense: 2,
            traits: [
              'Ignores the effects of water and xulc terrain.',
            ],
            affinities: {
              Ether.dim: 2,
            },
            spawnable: true,
          ),
          EncounterFigureDef(
            name: 'Flying Xulc',
            standeeCount: 8,
            health: 5,
            flies: true,
            traits: [
              '[React] After this unit is attacked:\n\nLogic: Retreat\n[Dash] 2',
            ],
            affinities: {
              Ether.dim: 1,
            },
            spawnable: true,
          ),
          EncounterFigureDef(
            name: 'Writhing Stomaw',
            letter: 'A',
            standeeCount: 6,
            health: 12,
            infected: true,
            affinities: {
              Ether.fire: -2,
              Ether.crux: -1,
              Ether.earth: 1,
              Ether.morph: 2,
            },
          ),
          EncounterFigureDef(
            name: 'Nidus',
            letter: 'B',
            type: AdversaryType.miniboss,
            standeeCount: 4,
            healthFormula: '30*R',
            affinities: {
              Ether.morph: -1,
              Ether.wind: -1,
              Ether.dim: 1,
              Ether.earth: 2,
              Ether.crux: 2,
            },
            traits: [
              '''[React] After this unit suffers [DMG] as part of an attack:
              
Roll the Xulc dice and spawn the result within [Range] 1 of this unit.''',
            ],
            onSlain: [
              milestone('_victory'),
            ],
          ),
        ],
        placements: [
          PlacementDef(name: 'Writhing Stomaw', c: 1, r: 6),
          PlacementDef(name: 'Writhing Stomaw', c: 2, r: 2, minPlayers: 3),
          PlacementDef(name: 'Writhing Stomaw', c: 11, r: 2, minPlayers: 4),
          PlacementDef(name: 'Writhing Stomaw', c: 11, r: 6),
          PlacementDef(name: 'Nidus', c: 6, r: 2),
          PlacementDef(
            name: 'Hoard',
            alias: 'Hoard [A]',
            type: PlacementType.object,
            c: 10,
            r: 6,
            fixedTokens: ['A'],
            onLoot: [
              codex(4),
              lyst('5*R', title: 'What was Lost'),
            ],
          ),
          PlacementDef(
            name: 'Hoard',
            alias: 'Hoard [B]',
            type: PlacementType.object,
            c: 2,
            r: 4,
            fixedTokens: ['B'],
            onLoot: [
              codex(5),
              item('Starling Shard',
                  title: 'What Once Was',
                  body:
                      'The Rover that looted the hoard tile gains one “**Starling Shard**” item. They may equip this item. If they don’t have the required item slot(s) available, they may unequip items as needed.'),
            ],
          ),
          PlacementDef(
            name: 'Hoard',
            alias: 'Hoard [C]',
            type: PlacementType.object,
            c: 7,
            r: 0,
            fixedTokens: ['C'],
            onLoot: [
              codex(6),
              item('Gemini Stellate',
                  title: 'What Will Never Be',
                  body:
                      'The Rover that looted the hoard tile gains one “**Gemini Stellate**” item. They may equip this item. If they don’t have the required item slot(s) available, they may unequip items as needed.'),
            ],
          ),
          PlacementDef(
              name: 'Pod', type: PlacementType.trap, c: 1, r: 5, trapDamage: 3),
          PlacementDef(
              name: 'Pod', type: PlacementType.trap, c: 8, r: 0, trapDamage: 3),
          PlacementDef(
              name: 'Pod', type: PlacementType.trap, c: 5, r: 4, trapDamage: 3),
          PlacementDef(
              name: 'Pod',
              type: PlacementType.trap,
              c: 11,
              r: 9,
              trapDamage: 3),
          PlacementDef(name: 'morph', type: PlacementType.ether, c: 3, r: 2),
          PlacementDef(name: 'morph', type: PlacementType.ether, c: 10, r: 1),
          PlacementDef(name: 'water', type: PlacementType.ether, c: 6, r: 6),
          PlacementDef(name: 'A', type: PlacementType.feature, c: 10, r: 6),
          PlacementDef(name: 'B', type: PlacementType.feature, c: 2, r: 4),
        ],
      );

  static EncounterDef get encounter10dot2dotLate => EncounterDef(
        expansion: 'xulc',
        questId: '10_act1',
        number: '2.late',
        title: 'Nidifugous by Nature',
        setup: EncounterSetup(
            box: 'XU-1',
            map: '5',
            adversary: '5',
            tiles: '4x Pod Traps, 3x Hoards'),
        victoryDescription: 'Slay the Nidus.',
        roundLimit: 10,
        terrain: [
          dangerousBones(2),
          trapPod(3),
          difficultWater(),
          etherWater(),
          etherMorph(),
        ],
        baseLystReward: 20,
        campaignLink:
            'Encounter 10.5 - “**Knowable Only by Analogy**”, [campaign] **28**',
        challenges: [
          '**Nidus Cluster** triggers during the **Start Phase** of rounds 2, 4, 6, 8, and 10.',
          'Each time a Rover deals 3 or more [DMG] with an attack, they drain an ether dice in their personal supply, if able to.',
          'When an effect of the Nidus would have you roll the xulc dice, reroll any results of a blank face.',
        ],
        dialogs: [
          introductionFromText('quest_10_encounter_2_late_intro'),
        ],
        allies: [
          AllyDef(
            name: 'Hra',
            cardId: 'A-024',
            behaviors: [
              EncounterFigureDef(
                name: 'Marl',
                health: 10,
                traits: [
                  'Push and pull effects targeting this unit are reduced by 1.',
                ],
                affinities: {
                  Ether.wind: -2,
                  Ether.fire: -1,
                  Ether.water: 1,
                  Ether.earth: 2,
                },
              )
            ],
          ),
        ],
        onLoad: [
          remove('Hra',
              condition: MilestoneCondition(CampaignMilestone.milestone10dot4,
                  value: false),
              silent: true),
          dialog('Introduction'),
          rules(
              'Balatronists',
              '''*You have milestone “${CampaignMilestone.milestone3dot4}” marked in your core box campaign sheet.*

*The wounded zusag are familiar - they are the querists that bothered you when you were last in the Unsouled Barrens! It appears Silky, in all his sneaky wisdom, had kept tabs on the rebellious young associates all this time. The querists appear to be safeguarding another, more welcome familiar face; Ozendyn and his pet coruscopod, Gargaki. The old warrior appears gravely wounded amidst a pile of dead xulc- it’s clear that he has been fighting off this living altar to pestilence to defend the zusag, but had been brought low by its never-ending swarm. One of the querists notices you. “Rovers! It’s the Rovers! Help! He’s dying!!” You rush into battle as the zusag appear steeled by your presence, pushing through their fear to summon glyphs of pure crux to aid you.*

Replace up to 3 pod traps with 3 reflective glyph traps. If an adversary triggers this trap, they suffer [DMG]3. If a Rover triggers this trap, they recover [RCV] 3.''',
              condition: MilestoneCondition(CampaignMilestone.milestone3dot4)),
          rules(
              'Balatronists',
              '''*You have milestone “${CampaignMilestone.milestone7dot2Querists3}” marked in your core box campaign sheet.*

*The wounded zusag are familiar - they are the querists that bothered you when you were last in the Unsouled Barrens! It appears Silky, in all his sneaky wisdom, had kept tabs on the rebellious young associates all this time. The querists appear to be safeguarding another, more welcome familiar face; Ozendyn and his pet coruscopod, Gargaki. The old warrior appears gravely wounded amidst a pile of dead xulc- it’s clear that he has been fighting off this living altar to pestilence to defend the zusag, but had been brought low by its never-ending swarm. One of the querists notices you. “Rovers! It’s the Rovers! Help! He’s dying!!” You rush into battle as the zusag appear steeled by your presence, pushing through their fear to summon glyphs of pure crux to aid you.*

Replace up to 3 pod traps with 3 reflective glyph traps. If an adversary triggers this trap, they suffer [DMG]3. If a Rover triggers this trap, they recover [RCV] 3.''',
              condition: MilestoneCondition(
                  CampaignMilestone.milestone7dot2Querists3)),
          rules(
              'Gargaki',
              '''*You do not have either milestone “${CampaignMilestone.milestone3dot4}” or “${CampaignMilestone.milestone7dot2Querists3}”  marked in your core box campaign sheet.*

*The zusag are youthful - querists, the rebellious sort who go out to seek adventure in the world beyond their clans. This is far from the adventure that they would seek, this is terror, this is rot, this is abomination and inevitable death. In the centre is the old warrior you know from this place known as Ozendyn, that final warrior who would chop down the bonespire with his sword alone if he thought he’d live long enough to see it done. The warrior lies bloodied, exhausted, holding onto consciousness by the skin of his teeth. Ozendyn’s companion coruscopod Gargaki recognizes you and rushes to you with a display of sheer terror, but determined to save its old friend.*

One Rover gains the following passive benefit for this encounter:

**Gargaki**: When a writhing stomaw is slain, perform: [Heal] | [Range] 0-1 | [RCV] 1 | [Everbloom]''',
              conditions: [
                MilestoneCondition(CampaignMilestone.milestone3dot4,
                    value: false),
                MilestoneCondition(CampaignMilestone.milestone7dot2Querists3,
                    value: false)
              ]),
          rules('Nidus Cluster',
              '''*The Nidus has metastasized into a nidus cluster.*  Place the Nidus as seen on the map, on top of the monstrous growth tile. The Nidus and the tile are the same unit for this encounter. They can not be moved or teleported for any reason.

During the **Start Phase** of round 3, 6, and 9, Roll the Xulc dice R times and spawn the results within [Range] 1 of the monstrous growth.'''),
          codexLink('What was Lost',
              number: 4,
              body:
                  'If a Rover enters into a space with hoard tile [A], remove the tile and read [title], [codex] 3.'),
          codexLink('What Once Was',
              number: 5,
              body:
                  'If a Rover enters into a space with hoard tile [B], remove the tile and read [title], [codex] 3.'),
          codexLink('What Will Never Be',
              number: 6,
              body:
                  'If a Rover enters into a space with hoard tile [C], remove the tile and read [title], [codex] 3.'),
          codexLink('Eruption',
              number: 8,
              body:
                  'Immediately when the Nidus is slain, read [title], [codex] 5.'),
        ],
        onDidStartRound: [
          milestone('_round3', condition: RoundCondition(3)),
          milestone('_round6', condition: RoundCondition(6)),
          milestone('_round9', condition: RoundCondition(9)),
        ],
        onMilestone: {
          '_round3': [
            rollXulcDie(title: 'Nidus Cluster: First Roll'),
            rollXulcDie(title: 'Nidus Cluster: Second Roll'),
            rollXulcDie(
                title: 'Nidus Cluster: Third Roll',
                condition: MinPlayerCountCondition(3)),
            rollXulcDie(
                title: 'Nidus Cluster: Fourth Roll',
                condition: MinPlayerCountCondition(4)),
          ],
          '_round6': [
            rollXulcDie(title: 'Nidus Cluster: First Roll'),
            rollXulcDie(title: 'Nidus Cluster: Second Roll'),
            rollXulcDie(
                title: 'Nidus Cluster: Third Roll',
                condition: MinPlayerCountCondition(3)),
            rollXulcDie(
                title: 'Nidus Cluster: Fourth Roll',
                condition: MinPlayerCountCondition(4)),
          ],
          '_round9': [
            rollXulcDie(title: 'Nidus Cluster: First Roll'),
            rollXulcDie(title: 'Nidus Cluster: Second Roll'),
            rollXulcDie(
                title: 'Nidus Cluster: Third Roll',
                condition: MinPlayerCountCondition(3)),
            rollXulcDie(
                title: 'Nidus Cluster: Fourth Roll',
                condition: MinPlayerCountCondition(4)),
          ],
          '_victory': [
            codex(8),
            victory(
                body:
                    '''*You’ve slain a powerful foe and learned much about this new threat, but your foe has also learned a lot about you and your infection worsens.*

All Rovers must select and permanently add one infected skill card to their hand. This infected card **DOES** count toward the number of skill or reaction cards you may take in an encounter.'''),
          ],
        },
        startingMap: MapDef(
          id: '10.2.late',
          columnCount: 13,
          rowCount: 11,
          backgroundRect: Rect.fromLTWH(125.0, 44.0, 1481.0, 1411.0),
          starts: [
            (4, 9),
            (5, 10),
            (6, 9),
            (7, 10),
            (8, 9),
          ],
          terrain: {
            (1, 1): TerrainType.object,
            (2, 8): TerrainType.dangerous,
            (3, 2): TerrainType.object,
            (3, 4): TerrainType.difficult,
            (3, 5): TerrainType.difficult,
            (3, 6): TerrainType.difficult,
            (3, 7): TerrainType.barrier,
            (4, 0): TerrainType.dangerous,
            (4, 5): TerrainType.difficult,
            (4, 6): TerrainType.difficult,
            (5, 9): TerrainType.object,
            (6, 1): TerrainType.object,
            (6, 2): TerrainType.object,
            (6, 6): TerrainType.object,
            (7, 2): TerrainType.object,
            (7, 9): TerrainType.object,
            (8, 5): TerrainType.difficult,
            (9, 4): TerrainType.barrier,
            (9, 5): TerrainType.difficult,
            (9, 6): TerrainType.difficult,
            (10, 1): TerrainType.object,
            (10, 4): TerrainType.difficult,
            (10, 5): TerrainType.difficult,
            (11, 4): TerrainType.dangerous,
          },
        ),
        overlays: [EncounterFigureDef(name: 'Hoard')],
        adversaries: [
          EncounterFigureDef(
            name: 'Cleaving Xulc',
            standeeCount: 8,
            health: 6,
            traits: [
              'Ignores the effects of water and xulc terrain.',
            ],
            affinities: {
              Ether.dim: 1,
            },
            spawnable: true,
          ),
          EncounterFigureDef(
            name: 'Armored Xulc',
            standeeCount: 8,
            health: 5,
            defense: 2,
            traits: [
              'Ignores the effects of water and xulc terrain.',
            ],
            affinities: {
              Ether.dim: 2,
            },
            spawnable: true,
          ),
          EncounterFigureDef(
            name: 'Flying Xulc',
            standeeCount: 8,
            health: 5,
            flies: true,
            traits: [
              '[React] After this unit is attacked:\n\nLogic: Retreat\n[Dash] 2',
            ],
            affinities: {
              Ether.dim: 1,
            },
            spawnable: true,
          ),
          EncounterFigureDef(
            name: 'Writhing Stomaw',
            letter: 'A',
            standeeCount: 6,
            health: 12,
            infected: true,
            affinities: {
              Ether.fire: -2,
              Ether.crux: -1,
              Ether.earth: 1,
              Ether.morph: 2,
            },
          ),
          EncounterFigureDef(
            name: 'Nidus',
            letter: 'B',
            type: AdversaryType.miniboss,
            standeeCount: 4,
            healthFormula: '30*R',
            immuneToForcedMovement: true,
            immuneToTeleport: true,
            affinities: {
              Ether.morph: -1,
              Ether.wind: -1,
              Ether.dim: 1,
              Ether.earth: 2,
              Ether.crux: 2,
            },
            traits: [
              '''[React] After this unit suffers [DMG] as part of an attack:
              
Roll the Xulc dice and spawn the result within [Range] 1 of this unit.''',
            ],
            onSlain: [
              milestone('_victory'),
            ],
          ),
        ],
        placements: [
          PlacementDef(name: 'Writhing Stomaw', c: 1, r: 6),
          PlacementDef(name: 'Writhing Stomaw', c: 2, r: 2, minPlayers: 3),
          PlacementDef(name: 'Writhing Stomaw', c: 11, r: 2, minPlayers: 4),
          PlacementDef(name: 'Writhing Stomaw', c: 11, r: 6),
          PlacementDef(name: 'Nidus', c: 6, r: 2),
          PlacementDef(
            name: 'Hoard',
            alias: 'Hoard [A]',
            type: PlacementType.object,
            c: 10,
            r: 6,
            fixedTokens: ['A'],
            onLoot: [
              codex(4),
              lyst('5*R', title: 'What was Lost'),
            ],
          ),
          PlacementDef(
            name: 'Hoard',
            alias: 'Hoard [B]',
            type: PlacementType.object,
            c: 2,
            r: 4,
            fixedTokens: ['B'],
            onLoot: [
              codex(5),
              item('Starling Shard',
                  title: 'What Once Was',
                  body:
                      'The Rover that looted the hoard tile gains one “**Starling Shard**” item. They may equip this item. If they don’t have the required item slot(s) available, they may unequip items as needed.'),
            ],
          ),
          PlacementDef(
            name: 'Hoard',
            alias: 'Hoard [C]',
            type: PlacementType.object,
            c: 7,
            r: 0,
            fixedTokens: ['C'],
            onLoot: [
              codex(6),
              item('Gemini Stellate',
                  title: 'What Will Never Be',
                  body:
                      'The Rover that looted the hoard tile gains one “**Gemini Stellate**” item. They may equip this item. If they don’t have the required item slot(s) available, they may unequip items as needed.'),
            ],
          ),
          PlacementDef(
              name: 'Pod', type: PlacementType.trap, c: 1, r: 5, trapDamage: 3),
          PlacementDef(
              name: 'Pod', type: PlacementType.trap, c: 8, r: 0, trapDamage: 3),
          PlacementDef(
              name: 'Pod', type: PlacementType.trap, c: 5, r: 4, trapDamage: 3),
          PlacementDef(
              name: 'Pod',
              type: PlacementType.trap,
              c: 11,
              r: 9,
              trapDamage: 3),
          PlacementDef(name: 'morph', type: PlacementType.ether, c: 3, r: 2),
          PlacementDef(name: 'morph', type: PlacementType.ether, c: 10, r: 1),
          PlacementDef(name: 'water', type: PlacementType.ether, c: 6, r: 6),
          PlacementDef(name: 'A', type: PlacementType.feature, c: 10, r: 6),
          PlacementDef(name: 'B', type: PlacementType.feature, c: 2, r: 4),
        ],
      );

  static EncounterDef get encounter10dot3dotEarly => EncounterDef(
        expansion: 'xulc',
        questId: '10_act1',
        number: '3.early',
        title: 'Keen Debtors',
        setup: EncounterSetup(
            box: 'XU-1',
            map: '6',
            adversary: '6-7',
            tiles: '4x Magical Traps, 2x Pod Traps, 6x Hoards'),
        victoryDescription: 'Survive for 7 rounds.',
        lossDescription: 'Lose if Mo and Makaal are slain.',
        roundLimit: 7,
        terrain: [
          trapMagic(3),
          trapPod(3),
          etherEarth(),
          etherCrux(),
        ],
        baseLystReward: 20,
        milestone: CampaignMilestone.milestone10dot3,
        campaignLink:
            '''Check your campaign sheet, if you do not have either milestone “**Slayed the Nidus**” or “**Made a Powerful Ally**” marked, select your next encounter:

Encounter 2 - “**Nidifugous by Nature**”, [campaign] **8** or Encounter 4 - “**Ought Never to Sprout**”, [campaign] **20**.

If you have the milestones “**Made a Powerful Ally**” marked and “**Slayed the Nidus**” not marked, proceed to:

Encounter 2 - “**Nidifugous by Nature**”, [campaign] **12**.

If you have the milestones “**Slayed the Nidus**” marked and “**Made a Powerful Ally**” not marked, proceed to:

Encounter 4 - “**Ought Never to Sprout**”, [campaign] **24**.''',
        challenges: [
          'When rolling an ether dice for Mo and Makaal, a result of [crux] or [morph] have no effect. No Rover is healed and no [wildfire] is placed.',
          'When a xulc is spawned, they immediately take a turn.',
          'Remove the ether dice from the ether nodes on the map.',
        ],
        dialogs: [
          introductionFromText('quest_10_encounter_3_early_intro'),
        ],
        onLoad: [
          remove('Hra',
              condition: MilestoneCondition(CampaignMilestone.milestone10dot4,
                  value: false),
              silent: true),
          dialog('Introduction'),
          rules('Mo and Makaal',
              '''*That same smell of infection hits you first as always. Bodies of rangers litter the floor, whilst a few warriors remain, protecting Mo and Makaal as they pack wares onto the back of Grandpaw. You watch as Mo affixes the strap of a large leather bandiolier whilst Makaal haphazardly hurls glass bottles and ointments at the infected savannah creatures, exploding in a rainbow of chemicals. All around are similarly infected urns, whilst it appears the xulc have also managed to find their way here. But how? So sudden, so soon? These are questions to answer once Mo and Makaal are safe.*

Mo and Makaal are a part of the Rover faction.

Together they have 8 [HP]. During the **End Phase** each round they throw a potion. Roll an ether dice from the general pool, on a result of [wind], [earth], or [crux], the most damaged Rover unit within [Range] 0-3 recovers [RCV] 3. On a result of [fire], [water], or [morph], place one [wildfire] within [Range] 1-3, closest to the nearest enemy.'''),
          rules('Exploding Infestation',
              '''There are six ether icons on the edges of the map. These icons represent possible spawn locations throughout the encounter.

When an adversary with the **Infected** trait is slain, place it off to the side of the map on its side. During the **Start Phase**, for each adversary that is both off to the side and flipped vertically, roll an ether dice from the general pool, then spawn that adversary at the space with the ether icon corresponding to the result of the roll  Then, for each adversary that is both off to the side and placed on its side, flip them vertically.'''),
          codexLink('What Do We Have Here?',
              number: 9,
              body:
                  'Each time a Rover enters into a space with hoard tile, remove the tile and read [title], [codex] 6.'),
          codexLink('Riddled Shell',
              number: 2,
              body:
                  'Each time a stolen urn is slain, read [title], [codex] 2.'),
          codexLink('We\'re Leaving',
              number: 10,
              body: 'At the end of round 7, read [title], [codex] 6.'),
        ],
        onWillEndRound: [
          milestone('_victory', condition: RoundCondition(7)),
        ],
        onMilestone: {
          '_victory': [
            codex(10),
            victory(
                body:
                    '''*You’ve rescued Mo, Makaal, and Grandpaw. They are again indebted to you.*

Mo and Makaal’s shop is open again. Their shop is in the same state as it was at the end of the core box campaign. Their shop consists of the merchant level 1 through 4 decks. Check your core box campaign sheet and add all reward weapons and armors marked to the shop.'''),
          ],
        },
        onDraw: {
          EtherDieSide.wind.toJson(): [
            item('Aviating Coalyst',
                title: 'What Do We Have Here?',
                body:
                    'The Rover that looted the hoard tile may equip this item. If they don’t have the required item slot(s) available, they may unequip items as needed.'),
          ],
          EtherDieSide.crux.toJson(): [
            item('Condensed Will',
                title: 'What Do We Have Here?',
                body:
                    'The Rover that looted the hoard tile may equip this item. If they don’t have the required item slot(s) available, they may unequip items as needed.'),
          ],
          EtherDieSide.earth.toJson(): [
            item('Encrusting Coalyst',
                title: 'What Do We Have Here?',
                body:
                    'The Rover that looted the hoard tile may equip this item. If they don’t have the required item slot(s) available, they may unequip items as needed.'),
          ],
          EtherDieSide.fire.toJson(): [
            item('Flaming Coalyst',
                title: 'What Do We Have Here?',
                body:
                    'The Rover that looted the hoard tile may equip this item. If they don’t have the required item slot(s) available, they may unequip items as needed.'),
          ],
          EtherDieSide.morph.toJson(): [
            item('Scour Ichor',
                title: 'What Do We Have Here?',
                body:
                    'The Rover that looted the hoard tile may equip this item. If they don’t have the required item slot(s) available, they may unequip items as needed.'),
          ],
          EtherDieSide.water.toJson(): [
            item('Weltering Coalyst',
                title: 'What Do We Have Here?',
                body:
                    'The Rover that looted the hoard tile may equip this item. If they don’t have the required item slot(s) available, they may unequip items as needed.'),
          ],
        },
        startingMap: MapDef(
          id: '10.3.early',
          columnCount: 13,
          rowCount: 11,
          backgroundRect: Rect.fromLTWH(110.0, 44.0, 1481.0, 1411.0),
          starts: [
            (0, 7),
            (1, 8),
            (2, 8),
            (3, 9),
            (4, 9),
          ],
          terrain: {
            (0, 0): TerrainType.barrier,
            (0, 8): TerrainType.object,
            (1, 0): TerrainType.barrier,
            (1, 2): TerrainType.object,
            (1, 5): TerrainType.object,
            (2, 4): TerrainType.object,
            (2, 5): TerrainType.object,
            (3, 1): TerrainType.object,
            (3, 10): TerrainType.object,
            (4, 0): TerrainType.object,
            (4, 1): TerrainType.object,
            (5, 0): TerrainType.barrier,
            (5, 6): TerrainType.object,
            (6, 3): TerrainType.object,
            (6, 8): TerrainType.object,
            (7, 0): TerrainType.barrier,
            (7, 3): TerrainType.object,
            (7, 4): TerrainType.object,
            (7, 8): TerrainType.object,
            (7, 9): TerrainType.object,
            (9, 10): TerrainType.barrier,
            (11, 4): TerrainType.object,
            (11, 7): TerrainType.object,
            (11, 10): TerrainType.barrier,
            (12, 6): TerrainType.object,
            (12, 7): TerrainType.object,
            (12, 9): TerrainType.barrier,
          },
          spawnPoints: {
            (2, 0): Ether.fire,
            (6, 0): Ether.crux,
            (10, 0): Ether.earth,
            (12, 1): Ether.morph,
            (12, 4): Ether.water,
            (12, 8): Ether.wind,
          },
        ),
        allies: [
          AllyDef(
            name: 'Hra',
            cardId: 'A-024',
            behaviors: [
              EncounterFigureDef(
                name: 'Marl',
                health: 10,
                traits: [
                  'Push and pull effects targeting this unit are reduced by 1.',
                ],
                affinities: {
                  Ether.wind: -2,
                  Ether.fire: -1,
                  Ether.water: 1,
                  Ether.earth: 2,
                },
              )
            ],
          ),
          AllyDef(name: 'Mo and Makaal', behaviors: [
            EncounterFigureDef(
              name: 'Mo and Makaal',
              health: 8,
              large: true,
              onSlain: [
                fail(),
              ],
            )
          ]),
        ],
        overlays: [
          EncounterFigureDef(
            name: 'Hoard',
            onLoot: [
              codex(9),
              lyst('5*R', title: 'What Do We Have Here?'),
              rollEtherDie(
                  title: 'What Do We Have Here?',
                  body:
                      '''To determine what is found, roll an ether dice from the general pool and gain the item corresponding to the result.
              
[Fire]: One “Flaming Coalyst” item
[Water]: One “Weltering Coalyst” item
[Earth]: One “Encrusting Coalyst” item
[Wind]: One “Aviating Coalyst” item
[Crux]: One “Condensed Will” item
[Morph]: One “Scour Ichor” item'''),
            ],
          )
        ],
        adversaries: [
          EncounterFigureDef(
            name: 'Cleaving Xulc',
            standeeCount: 8,
            health: 6,
            traits: [
              'Ignores the effects of water and xulc terrain.',
            ],
            affinities: {
              Ether.dim: 1,
            },
            spawnable: true,
          ),
          EncounterFigureDef(
            name: 'Armored Xulc',
            standeeCount: 8,
            health: 5,
            defense: 2,
            traits: [
              'Ignores the effects of water and xulc terrain.',
            ],
            affinities: {
              Ether.dim: 2,
            },
            spawnable: true,
          ),
          EncounterFigureDef(
            name: 'Flying Xulc',
            standeeCount: 8,
            health: 5,
            flies: true,
            traits: [
              '[React] After this unit is attacked:\n\nLogic: Retreat\n[Dash] 2',
            ],
            affinities: {
              Ether.dim: 1,
            },
            spawnable: true,
          ),
          EncounterFigureDef(
            name: 'Colony',
            letter: 'A',
            standeeCount: 4,
            health: 6,
            infected: true,
            respawns: true,
            traits: [
              'When this unit is slain, roll the Xulc dice twice.',
            ],
            affinities: {
              Ether.morph: -1,
              Ether.wind: -1,
              Ether.earth: 1,
              Ether.crux: 1,
            },
            onSlain: [
              rollXulcDie(title: 'Colony Slain: First Roll'),
              rollXulcDie(title: 'Colony Slain: Second Roll'),
            ],
          ),
          EncounterFigureDef(
            name: 'Bulwauros Husk',
            letter: 'B',
            standeeCount: 3,
            health: 8,
            defense: 3,
            infected: true,
            respawns: true,
            traits: [
              'If this unit is damaged, reduce it\'s [DEF] by 2.',
            ],
            affinities: {
              Ether.water: -2,
              Ether.wind: -1,
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
                        amount: -2,
                        targetKind: TargetKind.self)
                  ])
            ],
          ),
          EncounterFigureDef(
            name: 'Listless Dyad',
            letter: 'C',
            standeeCount: 2,
            health: 9,
            infected: true,
            respawns: true,
            affinities: {
              Ether.morph: -2,
              Ether.earth: 1,
              Ether.crux: 2,
            },
          ),
          EncounterFigureDef(
              name: 'Stolen Urn',
              letter: 'D',
              standeeCount: 2,
              healthFormula: '4*R',
              defense: 3,
              infected: true,
              respawns: true,
              affinities: {
                Ether.fire: 2,
                Ether.wind: 2,
                Ether.earth: 2,
                Ether.water: 2,
              },
              onSlain: [
                codex(2),
                lyst('5*R', title: 'Riddled Shell'),
                item('Dimming Stone',
                    title: 'Riddled Shell',
                    body:
                        '''The Rover that slayed the stolen urn gains one “**Dimming Stone**” item (found in the Xulc merchant deck). They may equip this item. If they don’t have the required item slot(s) available, they may unequip items as needed.'''),
              ]),
        ],
        placements: const [
          PlacementDef(name: 'Colony', c: 3, r: 2),
          PlacementDef(name: 'Colony', c: 9, r: 8),
          PlacementDef(name: 'Colony', c: 12, r: 8, minPlayers: 3),
          PlacementDef(name: 'Bulwauros Husk', c: 9, r: 6),
          PlacementDef(name: 'Bulwauros Husk', c: 0, r: 2),
          PlacementDef(name: 'Bulwauros Husk', c: 10, r: 0, minPlayers: 4),
          PlacementDef(name: 'Listless Dyad', c: 2, r: 0, minPlayers: 3),
          PlacementDef(name: 'Listless Dyad', c: 7, r: 2),
          PlacementDef(name: 'Stolen Urn', c: 10, r: 3),
          PlacementDef(name: 'Stolen Urn', c: 12, r: 1, minPlayers: 4),
          PlacementDef(name: 'Hoard', type: PlacementType.object, c: 11, r: 6),
          PlacementDef(name: 'Hoard', type: PlacementType.object, c: 10, r: 2),
          PlacementDef(name: 'Hoard', type: PlacementType.object, c: 8, r: 3),
          PlacementDef(name: 'Hoard', type: PlacementType.object, c: 1, r: 4),
          PlacementDef(name: 'Hoard', type: PlacementType.object, c: 6, r: 9),
          PlacementDef(name: 'Hoard', type: PlacementType.object, c: 3, r: 0),
          PlacementDef(
              name: 'Magic',
              type: PlacementType.trap,
              c: 3,
              r: 7,
              trapDamage: 3),
          PlacementDef(
              name: 'Magic',
              type: PlacementType.trap,
              c: 4,
              r: 7,
              trapDamage: 3),
          PlacementDef(
              name: 'Magic',
              type: PlacementType.trap,
              c: 4,
              r: 3,
              trapDamage: 3),
          PlacementDef(
              name: 'Magic',
              type: PlacementType.trap,
              c: 9,
              r: 7,
              trapDamage: 3),
          PlacementDef(
              name: 'Pod', type: PlacementType.trap, c: 9, r: 1, trapDamage: 3),
          PlacementDef(
              name: 'Pod',
              type: PlacementType.trap,
              c: 12,
              r: 2,
              trapDamage: 3),
          PlacementDef(name: 'earth', type: PlacementType.ether, c: 1, r: 2),
          PlacementDef(name: 'earth', type: PlacementType.ether, c: 11, r: 4),
          PlacementDef(name: 'crux', type: PlacementType.ether, c: 5, r: 6),
        ],
      );

  static EncounterDef get encounter10dot3dotLate => EncounterDef(
        expansion: 'xulc',
        questId: '10_act1',
        number: '3.late',
        title: 'Keen Debtors',
        setup: EncounterSetup(
            box: 'XU-1',
            map: '7',
            adversary: '6-7',
            tiles: '4x Pod Traps, 2x Magical Traps, 1x Hoard'),
        victoryDescription: 'Survive for 7 rounds.',
        lossDescription: 'Lose if Mo and Makaal are slain.',
        roundLimit: 7,
        terrain: [
          trapMagic(3),
          trapPod(3),
          etherEarth(),
          etherCrux(),
        ],
        baseLystReward: 20,
        milestone: CampaignMilestone.milestone10dot3,
        campaignLink:
            'Encounter 10.5 - “**Knowable Only by Analogy**”, [campaign] **28**',
        challenges: [
          'Replace magic traps with pod traps.',
          'When a xulc is spawned, they immediately take a turn.',
          'Remove the ether dice from the ether nodes on the map.',
        ],
        dialogs: [
          introductionFromText('quest_10_encounter_3_late_intro'),
        ],
        onLoad: [
          remove('Hra',
              condition: MilestoneCondition(CampaignMilestone.milestone10dot4,
                  value: false),
              silent: true),
          dialog('Introduction'),
          rules('Mo and Makaal',
              '''*That same smell of infection hits you first as always. Bodies of numerous rangers litter the floor, only two  remaining. Makaal throws a potion of glowing blue oil  at a monstrous infected bulwarous, watching it screech  as it burns. Grandpaw launches himself at one head of  a mindless dyad whilst Mo wields their whittling knife to  stab the other. Makaal is bleeding. It looks like he might  have broken an arm. Grandpaw’s snowy coat is stained  in red and black, blood from himself and the xulc alike. Makaal’s ether looks thin and wispy. Thank the ether  they’re alive, but barely.*

Mo and Makaal are a part of the Rover faction.

Together they have 8 [HP]. Mo and Makaal are injured and are doing everything they can to pack Grandpaw. They are unable to assist you during this fight.'''),
          rules('Exploding Infestation',
              '''There are six ether icons on the edges of the map. These icons represent possible spawn locations throughout the encounter.

When an adversary with the **Infected** trait is slain, place it off to the side of the map on its side. During the **Start Phase**, for each adversary that is both off to the side and flipped vertically, roll an ether dice from the general pool, then spawn that adversary at the space with the ether icon corresponding to the result of the roll  Then, for each adversary that is both off to the side and placed on its side, flip them vertically.'''),
          codexLink('What Do We Have Here?',
              number: 9,
              body:
                  'Each time a Rover enters into a space with hoard tile, remove the tile and read [title], [codex] 6.'),
          codexLink('Riddled Shell',
              number: 2,
              body:
                  'Each time a stolen urn is slain, read [title], [codex] 2.'),
          codexLink('The Road Yawns',
              number: 11,
              body: 'At the end of round 7, read [title], [codex] 7.'),
        ],
        onWillEndRound: [
          milestone('_victory', condition: RoundCondition(7)),
        ],
        onMilestone: {
          '_victory': [
            codex(11),
            victory(
                body:
                    '''*You’ve rescued Mo, Makaal, and Grandpaw. They are again indebted to you.*

Mo and Makaal’s shop is open again. Their shop is in the same state as it was at the end of the core box campaign. Their shop consists of the merchant level 1 through 4 decks. Check your core box campaign sheet and add all reward weapons and armors marked to the shop.'''),
          ],
        },
        onDraw: {
          EtherDieSide.wind.toJson(): [
            item('Aviating Coalyst',
                title: 'What Do We Have Here?',
                body:
                    'The Rover that looted the hoard tile may equip this item. If they don’t have the required item slot(s) available, they may unequip items as needed.'),
          ],
          EtherDieSide.crux.toJson(): [
            item('Condensed Will',
                title: 'What Do We Have Here?',
                body:
                    'The Rover that looted the hoard tile may equip this item. If they don’t have the required item slot(s) available, they may unequip items as needed.'),
          ],
          EtherDieSide.earth.toJson(): [
            item('Encrusting Coalyst',
                title: 'What Do We Have Here?',
                body:
                    'The Rover that looted the hoard tile may equip this item. If they don’t have the required item slot(s) available, they may unequip items as needed.'),
          ],
          EtherDieSide.fire.toJson(): [
            item('Flaming Coalyst',
                title: 'What Do We Have Here?',
                body:
                    'The Rover that looted the hoard tile may equip this item. If they don’t have the required item slot(s) available, they may unequip items as needed.'),
          ],
          EtherDieSide.morph.toJson(): [
            item('Scour Ichor',
                title: 'What Do We Have Here?',
                body:
                    'The Rover that looted the hoard tile may equip this item. If they don’t have the required item slot(s) available, they may unequip items as needed.'),
          ],
          EtherDieSide.water.toJson(): [
            item('Weltering Coalyst',
                title: 'What Do We Have Here?',
                body:
                    'The Rover that looted the hoard tile may equip this item. If they don’t have the required item slot(s) available, they may unequip items as needed.'),
          ],
        },
        startingMap: MapDef(
          id: '10.3.late',
          columnCount: 13,
          rowCount: 11,
          backgroundRect: Rect.fromLTWH(125.0, 44.0, 1481.0, 1411.0),
          starts: [
            (0, 7),
            (1, 8),
            (2, 8),
            (3, 9),
            (4, 9),
          ],
          terrain: {
            (0, 0): TerrainType.barrier,
            (0, 8): TerrainType.object,
            (1, 0): TerrainType.barrier,
            (1, 2): TerrainType.object,
            (1, 5): TerrainType.object,
            (2, 4): TerrainType.object,
            (2, 5): TerrainType.object,
            (3, 1): TerrainType.object,
            (3, 10): TerrainType.object,
            (4, 0): TerrainType.object,
            (4, 1): TerrainType.object,
            (5, 0): TerrainType.barrier,
            (5, 6): TerrainType.object,
            (6, 3): TerrainType.object,
            (6, 8): TerrainType.object,
            (7, 0): TerrainType.barrier,
            (7, 3): TerrainType.object,
            (7, 4): TerrainType.object,
            (7, 8): TerrainType.object,
            (7, 9): TerrainType.object,
            (9, 10): TerrainType.barrier,
            (11, 4): TerrainType.object,
            (11, 7): TerrainType.object,
            (11, 10): TerrainType.barrier,
            (12, 6): TerrainType.object,
            (12, 7): TerrainType.object,
            (12, 9): TerrainType.barrier,
          },
          spawnPoints: {
            (2, 0): Ether.fire,
            (6, 0): Ether.crux,
            (10, 0): Ether.earth,
            (12, 1): Ether.morph,
            (12, 4): Ether.water,
            (12, 8): Ether.wind,
          },
        ),
        allies: [
          AllyDef(
            name: 'Hra',
            cardId: 'A-024',
            behaviors: [
              EncounterFigureDef(
                name: 'Marl',
                health: 10,
                traits: [
                  'Push and pull effects targeting this unit are reduced by 1.',
                ],
                affinities: {
                  Ether.wind: -2,
                  Ether.fire: -1,
                  Ether.water: 1,
                  Ether.earth: 2,
                },
              )
            ],
          ),
          AllyDef(name: 'Mo and Makaal', behaviors: [
            EncounterFigureDef(
              name: 'Mo and Makaal',
              health: 8,
              large: true,
              onSlain: [
                fail(),
              ],
            )
          ]),
        ],
        overlays: [
          EncounterFigureDef(
            name: 'Hoard',
            onLoot: [
              codex(9),
              lyst('5*R', title: 'What Do We Have Here?'),
              rollEtherDie(
                  title: 'What Do We Have Here?',
                  body:
                      '''To determine what is found, roll an ether dice from the general pool and gain the item corresponding to the result.
              
[Fire] - One “Flaming Coalyst” item
[Water] - One “Weltering Coalyst” item
[Earth] - One “Encrusting Coalyst” item
[Wind] - One “Aviating Coalyst” item
[Crux] - One “Condensed Will” item
[Morph] - One “Scour Ichor” item'''),
            ],
          )
        ],
        adversaries: [
          EncounterFigureDef(
            name: 'Cleaving Xulc',
            standeeCount: 8,
            health: 6,
            traits: [
              'Ignores the effects of water and xulc terrain.',
            ],
            affinities: {
              Ether.dim: 1,
            },
            spawnable: true,
          ),
          EncounterFigureDef(
            name: 'Armored Xulc',
            standeeCount: 8,
            health: 5,
            defense: 2,
            traits: [
              'Ignores the effects of water and xulc terrain.',
            ],
            affinities: {
              Ether.dim: 2,
            },
            spawnable: true,
          ),
          EncounterFigureDef(
            name: 'Flying Xulc',
            standeeCount: 8,
            health: 5,
            flies: true,
            traits: [
              '[React] After this unit is attacked:\n\nLogic: Retreat\n[Dash] 2',
            ],
            affinities: {
              Ether.dim: 1,
            },
            spawnable: true,
          ),
          EncounterFigureDef(
            name: 'Colony',
            letter: 'A',
            standeeCount: 4,
            health: 6,
            infected: true,
            respawns: true,
            traits: [
              'When this unit is slain, roll the Xulc dice twice.',
            ],
            affinities: {
              Ether.morph: -1,
              Ether.wind: -1,
              Ether.earth: 1,
              Ether.crux: 1,
            },
            onSlain: [
              rollXulcDie(title: 'Colony Slain: First Roll'),
              rollXulcDie(title: 'Colony Slain: Second Roll'),
            ],
          ),
          EncounterFigureDef(
            name: 'Bulwauros Husk',
            standeeCount: 3,
            letter: 'B',
            health: 8,
            defense: 3,
            infected: true,
            respawns: true,
            traits: [
              'If this unit is damaged, reduce it\'s [DEF] by 2.',
            ],
            affinities: {
              Ether.water: -2,
              Ether.wind: -1,
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
                        amount: -2,
                        targetKind: TargetKind.self)
                  ])
            ],
          ),
          EncounterFigureDef(
            name: 'Listless Dyad',
            letter: 'C',
            standeeCount: 2,
            health: 9,
            infected: true,
            respawns: true,
            affinities: {
              Ether.morph: -2,
              Ether.earth: 1,
              Ether.crux: 2,
            },
          ),
          EncounterFigureDef(
              name: 'Stolen Urn',
              letter: 'D',
              standeeCount: 2,
              healthFormula: '4*R',
              defense: 3,
              infected: true,
              respawns: true,
              affinities: {
                Ether.fire: 2,
                Ether.wind: 2,
                Ether.earth: 2,
                Ether.water: 2,
              },
              onSlain: [
                codex(2),
                lyst('5*R', title: 'Riddled Shell'),
                item('Dimming Stone',
                    title: 'Riddled Shell',
                    body:
                        '''The Rover that slayed the stolen urn gains one “**Dimming Stone**” item (found in the Xulc merchant deck). They may equip this item. If they don’t have the required item slot(s) available, they may unequip items as needed.'''),
              ]),
        ],
        placements: const [
          PlacementDef(name: 'Colony', c: 3, r: 2),
          PlacementDef(name: 'Colony', c: 9, r: 8),
          PlacementDef(name: 'Colony', c: 12, r: 8, minPlayers: 3),
          PlacementDef(name: 'Bulwauros Husk', c: 9, r: 6),
          PlacementDef(name: 'Bulwauros Husk', c: 0, r: 2),
          PlacementDef(name: 'Bulwauros Husk', c: 10, r: 0, minPlayers: 4),
          PlacementDef(name: 'Listless Dyad', c: 2, r: 0, minPlayers: 3),
          PlacementDef(name: 'Listless Dyad', c: 7, r: 2),
          PlacementDef(name: 'Stolen Urn', c: 10, r: 3),
          PlacementDef(name: 'Stolen Urn', c: 12, r: 1, minPlayers: 4),
          PlacementDef(name: 'Hoard', type: PlacementType.object, c: 11, r: 6),
          PlacementDef(name: 'Hoard', type: PlacementType.object, c: 3, r: 0),
          PlacementDef(
              name: 'Magic',
              type: PlacementType.trap,
              c: 3,
              r: 7,
              trapDamage: 3),
          PlacementDef(
              name: 'Magic',
              type: PlacementType.trap,
              c: 4,
              r: 7,
              trapDamage: 3),
          PlacementDef(
              name: 'Pod', type: PlacementType.trap, c: 9, r: 1, trapDamage: 3),
          PlacementDef(
              name: 'Pod',
              type: PlacementType.trap,
              c: 12,
              r: 2,
              trapDamage: 3),
          PlacementDef(
              name: 'Pod', type: PlacementType.trap, c: 4, r: 3, trapDamage: 3),
          PlacementDef(
              name: 'Pod', type: PlacementType.trap, c: 9, r: 7, trapDamage: 3),
          PlacementDef(name: 'earth', type: PlacementType.ether, c: 1, r: 2),
          PlacementDef(name: 'earth', type: PlacementType.ether, c: 11, r: 4),
          PlacementDef(name: 'crux', type: PlacementType.ether, c: 5, r: 6),
        ],
      );

  static EncounterDef get encounter10dot4dotEarly => EncounterDef(
        expansion: 'xulc',
        questId: '10_act1',
        number: '4.early',
        title: 'Ought Never to Sprout',
        setup: EncounterSetup(
            box: 'XU-1', map: '8', adversary: '8-9', tiles: ' 2x Pod Traps'),
        victoryDescription: 'Escort Hra to the [Exit] space.',
        lossDescription: 'Lose if Hra is slain.',
        roundLimit: 7,
        terrain: [
          dangerousBones(2),
          trapPod(3),
          etherEarth(),
          etherWater(),
        ],
        baseLystReward: 20,
        milestone: CampaignMilestone.milestone10dot4,
        campaignLink:
            '''Check your campaign sheet, if you do not have either milestone “**Slayed the Nidus**” or “**Rescued the Merchants... Again**” marked, select your next encounter:

Encounter 2 - “**Nidifugous by Nature**”, [campaign] **8** or Encounter 3 - “**Keen Debtors**”, [campaign] **16**.

If you have the milestones “**Rescued the Merchants... Again**” marked and “**Slayed the Nidus**” not marked, proceed to:

Encounter 2 - “**Nidifugous by Nature**”, [campaign] **12**.

If you have the milestones “Slayed the Nidus” marked and “Rescued the Merchants.... Again” not marked, proceed to:

Encounter 3 - “**Keen Debtors**”, [campaign] **18**.''',
        challenges: [
          'During the **End Phase** of each round, trigger each pod trap, removing them from the map and roll the Xulc dice, spawning the result within [Range] 0 of that trap.',
          'Xulc can not trigger and ignore the effects of all non-class ether fields.',
          'When a Rover unit slays an **Infected** adversary, all enemies to that adversary within [Range] 1 of that adversary suffer [DMG]2.',
        ],
        extraPhaseIndex: 0,
        extraPhase: 'Hra',
        dialogs: [
          introductionFromText('quest_10_encounter_4_intro'),
        ],
        trackerEvents: [
          EncounterTrackerEventDef(
            title: 'Mark when Hra ends the round occupying the [exit] space',
            recordMilestone: '_hra_exit',
          )
        ],
        allies: [
          AllyDef(
            name: 'Hra',
            cardId: 'A-024',
            behaviors: [
              EncounterFigureDef(
                name: 'Marl',
                health: 10,
                traits: [
                  'Push and pull effects targeting this unit are reduced by 1.',
                ],
                affinities: {
                  Ether.wind: -2,
                  Ether.fire: -1,
                  Ether.water: 1,
                  Ether.earth: 2,
                },
                onSlain: [
                  fail(),
                ],
              )
            ],
          ),
        ],
        onLoad: [
          dialog('Introduction'),
          rules(
              'Hra',
              '''*You have the milestone “Intervened in an Ambush” marked in your campaign sheet.*

*You follow the directions Silky provided you on the search of that magnificent starling Hra. How did Silky know? Just how many tabs was the zusag keeping on your former allies? Not that you’re complaining, of course. When you encountered Hra they were a powerful, although somewhat errant starling. Positively bursting with ether energy. You find them stationary at the top of a rocky outcrop, staring at the vegetation below.*

*“Rovers,” Hra grinds the sound out of their earthen body. “Disease below. Parasite.” Evolution. They don’t turn to acknowledge you, but you join them by their side and stare below. Xulc pods smatter across the landscape, and the silvan ashemak and dekaha appear wilted, as diseased as the therans you’ve come across so far. They also appear to be… moving. “Making others…husks.”* 

*One of Hra’s vine-tendrils gestures to the other side of the valley beneath. A single crystal - a starling shard - atop a tree-stump shrine. “Retrieve with Hra.” Before you can answer, the starling begins its land-slide down the outcrop into the infected silvan below. Time to follow.*

Hra is a character ally to Rovers. For this encounter Hra will only use their “Marl” side and will not flip.''',
              condition: MilestoneCondition(CampaignMilestone.milestoneIdot4)),
          rules(
              'Hra',
              '''*You do not have the milestone “Intervened in an Ambush” marked in your campaign sheet.*

*Silky’s map points you towards the mountains to the east of the Unsouled Barrens, and before long you find yourself close to the mark. This ‘Hra’ is not hard to find, and nor do they try to hide themselves. A huge four legged starling of earth ether stands atop a ledge with a proud, almost theran like dominion of their environment. You call the name Hra, and their tendrils flitter, scattering leaves and moss, though they do not turn. “The zusag said you would come”. Hra’s voice is like a distant earthquake. By zusag you assume they mean Silky, but exactly how he managed to inform the starling is a mystery. Another mystery, to be specific. “Disease here, Rovers. Silvans controlled by… others. Dark things. ****Beautiful things****. Against the laws of ether.” You move to the side of the starling and see a slow shuffle of shapes below, things that shouldn’t walk are walking, things that shouldn’t flower are flowering. “Help Hra retrieve something. Then, future.” The immense starling begins their descent down into the wilderness below before waiting to see if you would follow.*

Hra is a part of their own faction, Hra, which is allied with Rovers, enemies with adversaries, and gains priority before the Rover faction.

Hra has 10 [HP] and the trait: All [Push] and [Pull] effects targeting Hra are reduced by 1.

Hra follows all the adversary logic rules found on page 46 in the rule book. During their turn, Hra performs the following ability:

[Dash] 1 << Ignore all movement penalties.
[m_attack] | [Range] 1 | [DMG]3 | [Push] 2 |

Hra requires coxing to get to safety. When Hra’s turn starts, if there is a Rover within [Range] 1 of them, they perform the following ability instead:

[Dash] 3 << Ignore all movement penalties.
[Heal] | [RCV] 1 | [everbloom] | [Target] self and all allies moved through''',
              condition: MilestoneCondition(CampaignMilestone.milestoneIdot4,
                  value: false)),
          remove('Hra',
              condition: MilestoneCondition(CampaignMilestone.milestoneIdot4,
                  value: false),
              silent: true),
          placementGroup(
            'Hra',
            condition: MilestoneCondition(CampaignMilestone.milestoneIdot4,
                value: false),
            silent: true,
          ),
          codexLink('Let’s Move Big Guy',
              number: 12,
              body:
                  'When Hra ends the round occupying the [exit] space, read [title], [codex] 8.'),
        ],
        onMilestone: {
          '_victory': [
            codex(12),
            victory(body: '''*You’ve saved Hra from the Xulc.*

For the remainder of the campaign, Hra is a character ally to Rovers, and starts each encounter deployed with you. For now, only use Hra’s “Marl” side.'''),
          ]
        },
        onWillEndRound: [
          milestone('_victory', condition: MilestoneCondition('_hra_exit')),
        ],
        startingMap: MapDef(
          id: '10.4',
          columnCount: 13,
          rowCount: 11,
          backgroundRect: Rect.fromLTWH(110.0, 44.0, 1481.0, 1411.0),
          starts: [
            (0, 0),
            (0, 1),
            (0, 2),
            (1, 0),
          ],
          exits: [
            (12, 7),
          ],
          terrain: {
            (1, 4): TerrainType.dangerous,
            (1, 5): TerrainType.barrier,
            (1, 6): TerrainType.difficult,
            (2, 3): TerrainType.difficult,
            (2, 4): TerrainType.barrier,
            (2, 5): TerrainType.barrier,
            (2, 7): TerrainType.object,
            (3, 4): TerrainType.difficult,
            (3, 5): TerrainType.difficult,
            (3, 9): TerrainType.difficult,
            (4, 1): TerrainType.difficult,
            (4, 7): TerrainType.dangerous,
            (4, 8): TerrainType.barrier,
            (4, 9): TerrainType.barrier,
            (5, 1): TerrainType.barrier,
            (5, 2): TerrainType.barrier,
            (5, 3): TerrainType.dangerous,
            (5, 9): TerrainType.barrier,
            (5, 10): TerrainType.difficult,
            (6, 0): TerrainType.difficult,
            (6, 1): TerrainType.barrier,
            (6, 2): TerrainType.difficult,
            (6, 4): TerrainType.object,
            (7, 2): TerrainType.difficult,
            (7, 6): TerrainType.difficult,
            (7, 7): TerrainType.barrier,
            (7, 8): TerrainType.difficult,
            (8, 5): TerrainType.dangerous,
            (8, 6): TerrainType.barrier,
            (8, 7): TerrainType.barrier,
            (8, 8): TerrainType.difficult,
            (9, 1): TerrainType.object,
            (9, 3): TerrainType.difficult,
            (9, 4): TerrainType.difficult,
            (9, 6): TerrainType.difficult,
            (9, 7): TerrainType.difficult,
            (10, 2): TerrainType.barrier,
            (10, 3): TerrainType.barrier,
            (10, 4): TerrainType.difficult,
            (11, 3): TerrainType.barrier,
            (11, 4): TerrainType.difficult,
            (11, 9): TerrainType.object,
            (11, 10): TerrainType.object,
            (12, 6): TerrainType.object,
            (12, 8): TerrainType.object,
            (12, 9): TerrainType.object,
          },
        ),
        adversaries: [
          EncounterFigureDef(
            name: 'Hra',
            health: 10,
            faction: 'Hra',
            traits: [
              'Push and pull effects targeting this unit are reduced by 1.'
            ],
            onSlain: [
              fail(),
            ],
          ),
          EncounterFigureDef(
            name: 'Cleaving Xulc',
            standeeCount: 8,
            health: 6,
            traits: [
              'Ignores the effects of water and xulc terrain.',
            ],
            affinities: {
              Ether.dim: 1,
            },
            spawnable: true,
          ),
          EncounterFigureDef(
            name: 'Armored Xulc',
            standeeCount: 8,
            health: 5,
            defense: 2,
            traits: [
              'Ignores the effects of water and xulc terrain.',
            ],
            affinities: {
              Ether.dim: 2,
            },
            spawnable: true,
          ),
          EncounterFigureDef(
            name: 'Flying Xulc',
            standeeCount: 8,
            health: 5,
            flies: true,
            traits: [
              '[React] After this unit is attacked:\n\nLogic: Retreat\n[Dash] 2',
            ],
            affinities: {
              Ether.dim: 1,
            },
            spawnable: true,
          ),
          EncounterFigureDef(
            name: 'Colony',
            letter: 'A',
            standeeCount: 4,
            health: 6,
            infected: true,
            traits: [
              'When this unit is slain, roll the Xulc dice twice.',
            ],
            affinities: {
              Ether.morph: -1,
              Ether.wind: -1,
              Ether.earth: 1,
              Ether.crux: 1,
            },
            onSlain: [
              rollXulcDie(title: 'Colony Slain: First Roll'),
              rollXulcDie(title: 'Colony Slain: Second Roll'),
            ],
          ),
          EncounterFigureDef(
            name: 'Faltering Ashemak',
            letter: 'B',
            standeeCount: 3,
            health: 10,
            infected: true,
            traits: [
              'Before this unit is slain, all units within [Range] 1 suffer [DMG]3.',
            ],
            affinities: {
              Ether.water: -2,
              Ether.wind: -1,
              Ether.fire: 3,
            },
          ),
          EncounterFigureDef(
            name: 'Withering Dekaha',
            letter: 'C',
            standeeCount: 3,
            health: 10,
            infected: true,
            affinities: {
              Ether.fire: -2,
              Ether.earth: 1,
              Ether.water: 2,
            },
          ),
          EncounterFigureDef(
            name: 'Listless Dyad',
            letter: 'D',
            standeeCount: 2,
            health: 15,
            infected: true,
            affinities: {
              Ether.morph: -2,
              Ether.earth: 1,
              Ether.crux: 2,
            },
          ),
        ],
        placements: const [
          PlacementDef(name: 'Colony', c: 4, r: 0),
          PlacementDef(name: 'Colony', c: 5, r: 4, minPlayers: 3),
          PlacementDef(name: 'Colony', c: 0, r: 4),
          PlacementDef(name: 'Faltering Ashemak', c: 6, r: 6, minPlayers: 3),
          PlacementDef(name: 'Faltering Ashemak', c: 2, r: 8),
          PlacementDef(name: 'Faltering Ashemak', c: 11, r: 5),
          PlacementDef(name: 'Withering Dekaha', c: 8, r: 1),
          PlacementDef(name: 'Withering Dekaha', c: 6, r: 8),
          PlacementDef(name: 'Withering Dekaha', c: 8, r: 4, minPlayers: 3),
          PlacementDef(name: 'Listless Dyad', c: 9, r: 10, minPlayers: 4),
          PlacementDef(name: 'Listless Dyad', c: 11, r: 8),
          PlacementDef(name: 'Colony', c: 9, r: 8, minPlayers: 4),
          PlacementDef(
              name: 'Pod', type: PlacementType.trap, c: 5, r: 5, trapDamage: 3),
          PlacementDef(
              name: 'Pod', type: PlacementType.trap, c: 7, r: 4, trapDamage: 3),
          PlacementDef(name: 'earth', type: PlacementType.ether, c: 9, r: 1),
          PlacementDef(name: 'earth', type: PlacementType.ether, c: 2, r: 7),
          PlacementDef(name: 'water', type: PlacementType.ether, c: 6, r: 4),
        ],
        placementGroups: [
          PlacementGroupDef(name: 'Hra', placements: [
            PlacementDef(name: 'Hra', c: 0, r: 0),
          ]),
        ],
      );

  static EncounterDef get encounter10dot4dotLate => EncounterDef(
        expansion: 'xulc',
        questId: '10_act1',
        number: '4.late',
        title: 'Ought Never to Sprout',
        setup: EncounterSetup(
            box: 'XU-1', map: '8', adversary: '8-9', tiles: ' 2x Pod Traps'),
        victoryDescription: 'Escort Hra to the [Exit] space.',
        lossDescription: 'Lose if Hra is slain.',
        roundLimit: 6,
        terrain: [
          dangerousBones(2),
          trapPod(3),
          etherEarth(),
          etherWater(),
        ],
        baseLystReward: 20,
        milestone: CampaignMilestone.milestone10dot4,
        campaignLink:
            'Encounter 10.5 - “**Knowable Only by Analogy**”, [campaign] **28**',
        challenges: [
          'During the **End Phase** of each round, trigger each pod trap, removing them from the map and roll the Xulc dice, spawning the result within [Range] 0 of that trap.',
          'Xulc can not trigger and ignore the effects of all non-class ether fields.',
          'When a Rover unit slays an **Infected** adversary, all enemies to that adversary within [Range] 1 of that adversary suffer [DMG]2.',
        ],
        extraPhaseIndex: 0,
        extraPhase: 'Hra',
        dialogs: [
          introductionFromText('quest_10_encounter_4_intro'),
        ],
        trackerEvents: [
          EncounterTrackerEventDef(
              title: 'Mark when Hra ends the round occupying the [exit] space',
              recordMilestone: '_hra_exit')
        ],
        allies: [
          AllyDef(
            name: 'Hra',
            cardId: 'A-024',
            behaviors: [
              EncounterFigureDef(
                name: 'Marl',
                startingHealth: 5,
                health: 10,
                traits: [
                  'Push and pull effects targeting this unit are reduced by 1.',
                ],
                onSlain: [
                  fail(),
                ],
              )
            ],
          ),
        ],
        onLoad: [
          dialog('Introduction'),
          rules(
              'Hra',
              '''*You have the milestone “Intervened in an Ambush” marked in your campaign sheet.*

*You follow the directions Silky provided you on the search of that magnificent starling Hra. As your infection - ***gift submit*** - spreads, you take familiar comfort in having Mo, Makaal, and Grandpaw with you once again. “What’s the deal with this guy again,” Makaal asks? “Not a guy, Makaal. A starling. Gender is a concept most unnecessary to our kind,” Mo corrects.*

*“Sure. I once knew a starling that insisted I call her “her” though. Just saying.” *

*“Good for her,” Mo responds without a hint of irony, fixing the claw grip on a coalyst ring. Their regular banter continues to be a good distraction from the surging adrenaline in your body. ***Doesn’t it feel good?*** When you last came across Hra they were a powerful, although somewhat errant starling. Positively bursting with ether energy.*

*Grandpaw brings his head low and smells the ground, catching the xulc-pang moments before you do. You move to the top of a rocky outcrop and look below to what you can imagine was once a verdant valley, and there you see them.*

*Hra bucks and smashes Xulc pods into smithereens across the landscape, and the silvan ashemak and dekaha appear wilted, as diseased as the therans you’ve come across so far. They also appear to be… moving.* 

*Hra appears to be moving toward a small tree stump on the far side of the valley, but they are wounded amidst the mutated silvan onslaught. You kick off the outcrop to the starlings aid.*

Hra is a character ally to Rovers. For this encounter Hra will only use their “Marl” side and will not flip. Hra is injured and starts the encounter with only 5 current [HP].''',
              condition: MilestoneCondition(CampaignMilestone.milestoneIdot4)),
          rules(
              'Hra',
              '''*You do not have the milestone “Intervened in an Ambush” marked in your campaign sheet.*

*Silky’s map points you towards the mountains to the east of the Unsouled Barrens, and before long you find yourself close to the mark. Grandpaw barks low in the direction of a secluded valley a short descent from the point you arrive. This ‘Hra’ is not hard to find, and nor do they try to hide themselves. A huge four legged starling of earthen ether stands wrestling with a swarm of violent, infected silvans. “The xulc can infect silvans too,” Mo asks.*

*“I guess so, and I guess that’s our starling.” Makaal responds. You descend to the bottom of the outcrop to Hra’s aide. Broken and clearly wounded by the monstrous silvans, Hra bellows at your arrival: “The zusag said you would come. You’re late” Hra’s voice is like a distant earthquake. Probably best not to keep this walking mountain waiting any longer than necessary.*

Hra is a part of their own faction, Hra, which is allied with Rovers, enemies with adversaries, and gains priority before the Rover faction.

Hra is injured, they have 10 maximum [HP] but only 5 current [HP]. They also have the trait: All [Push] and [Pull] effects targeting Hra are reduced by 1.

Hra follows all the adversary logic rules found on page 46 in the rule book. During their turn, Hra performs the following ability:

[Dash] 1 << Ignore all movement penalties.
[m_attack] | [Range] 1 | [DMG]3 | [Push] 2 |

Hra requires coxing to get to safety. When Hra’s turn starts, if there is a Rover within [Range] 1 of them, they perform the following ability instead:

[Dash] 3 << Ignore all movement penalties.
[Heal] | [RCV] 1 | [everbloom] | [Target] self and all allies moved through''',
              condition: MilestoneCondition(CampaignMilestone.milestoneIdot4,
                  value: false)),
          remove('Hra',
              condition: MilestoneCondition(CampaignMilestone.milestoneIdot4,
                  value: false),
              silent: true),
          placementGroup(
            'Hra',
            condition: MilestoneCondition(CampaignMilestone.milestoneIdot4,
                value: false),
            silent: true,
          ),
          codexLink('Purpose',
              number: 13,
              body:
                  'When Hra ends the round occupying the [exit] space, read [title], [codex] 8.'),
        ],
        onMilestone: {
          '_victory': [
            codex(13),
            victory(body: '''*You’ve saved Hra from the Xulc.*

For the remainder of the campaign, Hra is a character ally to Rovers, and starts each encounter deployed with you. For now, only use Hra’s “Marl” side.'''),
          ]
        },
        onWillEndRound: [
          milestone('_victory', condition: MilestoneCondition('_hra_exit')),
        ],
        startingMap: MapDef(
          id: '10.4',
          columnCount: 13,
          rowCount: 11,
          backgroundRect: Rect.fromLTWH(110.0, 44.0, 1481.0, 1411.0),
          starts: [
            (0, 0),
            (0, 1),
            (0, 2),
            (1, 0),
          ],
          exits: [
            (12, 7),
          ],
          terrain: {
            (1, 4): TerrainType.dangerous,
            (1, 5): TerrainType.barrier,
            (1, 6): TerrainType.difficult,
            (2, 3): TerrainType.difficult,
            (2, 4): TerrainType.barrier,
            (2, 5): TerrainType.barrier,
            (2, 7): TerrainType.object,
            (3, 4): TerrainType.difficult,
            (3, 5): TerrainType.difficult,
            (3, 9): TerrainType.difficult,
            (4, 1): TerrainType.difficult,
            (4, 7): TerrainType.dangerous,
            (4, 8): TerrainType.barrier,
            (4, 9): TerrainType.barrier,
            (5, 1): TerrainType.barrier,
            (5, 2): TerrainType.barrier,
            (5, 3): TerrainType.dangerous,
            (5, 9): TerrainType.barrier,
            (5, 10): TerrainType.difficult,
            (6, 0): TerrainType.difficult,
            (6, 1): TerrainType.barrier,
            (6, 2): TerrainType.difficult,
            (6, 4): TerrainType.object,
            (7, 2): TerrainType.difficult,
            (7, 6): TerrainType.difficult,
            (7, 7): TerrainType.barrier,
            (7, 8): TerrainType.difficult,
            (8, 5): TerrainType.dangerous,
            (8, 6): TerrainType.barrier,
            (8, 7): TerrainType.barrier,
            (8, 8): TerrainType.difficult,
            (9, 1): TerrainType.object,
            (9, 3): TerrainType.difficult,
            (9, 4): TerrainType.difficult,
            (9, 6): TerrainType.difficult,
            (9, 7): TerrainType.difficult,
            (10, 2): TerrainType.barrier,
            (10, 3): TerrainType.barrier,
            (10, 4): TerrainType.difficult,
            (11, 3): TerrainType.barrier,
            (11, 4): TerrainType.difficult,
            (11, 9): TerrainType.object,
            (11, 10): TerrainType.object,
            (12, 6): TerrainType.object,
            (12, 8): TerrainType.object,
            (12, 9): TerrainType.object,
          },
        ),
        adversaries: [
          EncounterFigureDef(
            name: 'Hra',
            startingHealth: 5,
            health: 10,
            faction: 'Hra',
            traits: [
              'Push and pull effects targeting this unit are reduced by 1.'
            ],
            onSlain: [
              fail(),
            ],
          ),
          EncounterFigureDef(
            name: 'Cleaving Xulc',
            standeeCount: 8,
            health: 6,
            traits: [
              'Ignores the effects of water and xulc terrain.',
            ],
            affinities: {
              Ether.dim: 1,
            },
            spawnable: true,
          ),
          EncounterFigureDef(
            name: 'Armored Xulc',
            standeeCount: 8,
            health: 5,
            defense: 2,
            traits: [
              'Ignores the effects of water and xulc terrain.',
            ],
            affinities: {
              Ether.dim: 2,
            },
            spawnable: true,
          ),
          EncounterFigureDef(
            name: 'Flying Xulc',
            standeeCount: 8,
            health: 5,
            flies: true,
            traits: [
              '[React] After this unit is attacked:\n\nLogic: Retreat\n[Dash] 2',
            ],
            affinities: {
              Ether.dim: 1,
            },
            spawnable: true,
          ),
          EncounterFigureDef(
            name: 'Colony',
            letter: 'A',
            standeeCount: 4,
            health: 6,
            infected: true,
            traits: [
              'When this unit is slain, roll the Xulc dice twice.',
            ],
            affinities: {
              Ether.morph: -1,
              Ether.wind: -1,
              Ether.earth: 1,
              Ether.crux: 1,
            },
            onSlain: [
              rollXulcDie(title: 'Colony Slain: First Roll'),
              rollXulcDie(title: 'Colony Slain: Second Roll'),
            ],
          ),
          EncounterFigureDef(
            name: 'Faltering Ashemak',
            letter: 'B',
            standeeCount: 3,
            health: 10,
            infected: true,
            traits: [
              'Before this unit is slain, all units within [Range] 1 suffer [DMG]3.',
            ],
            affinities: {
              Ether.water: -2,
              Ether.wind: -1,
              Ether.fire: 3,
            },
          ),
          EncounterFigureDef(
            name: 'Withering Dekaha',
            letter: 'C',
            standeeCount: 3,
            health: 10,
            infected: true,
            affinities: {
              Ether.fire: -2,
              Ether.earth: 1,
              Ether.water: 2,
            },
          ),
          EncounterFigureDef(
            name: 'Listless Dyad',
            letter: 'D',
            standeeCount: 2,
            health: 15,
            infected: true,
            affinities: {
              Ether.morph: -2,
              Ether.earth: 1,
              Ether.crux: 2,
            },
          ),
        ],
        placements: const [
          PlacementDef(name: 'Colony', c: 4, r: 0),
          PlacementDef(name: 'Colony', c: 5, r: 4, minPlayers: 3),
          PlacementDef(name: 'Colony', c: 0, r: 4),
          PlacementDef(name: 'Faltering Ashemak', c: 6, r: 6, minPlayers: 3),
          PlacementDef(name: 'Faltering Ashemak', c: 2, r: 8),
          PlacementDef(name: 'Faltering Ashemak', c: 11, r: 5),
          PlacementDef(name: 'Withering Dekaha', c: 8, r: 1),
          PlacementDef(name: 'Withering Dekaha', c: 6, r: 8),
          PlacementDef(name: 'Withering Dekaha', c: 8, r: 4, minPlayers: 3),
          PlacementDef(name: 'Listless Dyad', c: 9, r: 10, minPlayers: 4),
          PlacementDef(name: 'Listless Dyad', c: 11, r: 8),
          PlacementDef(name: 'Colony', c: 9, r: 8, minPlayers: 4),
          PlacementDef(
              name: 'Pod', type: PlacementType.trap, c: 5, r: 5, trapDamage: 3),
          PlacementDef(
              name: 'Pod', type: PlacementType.trap, c: 7, r: 4, trapDamage: 3),
          PlacementDef(name: 'earth', type: PlacementType.ether, c: 9, r: 1),
          PlacementDef(name: 'earth', type: PlacementType.ether, c: 2, r: 7),
          PlacementDef(name: 'water', type: PlacementType.ether, c: 6, r: 4),
        ],
        placementGroups: [
          PlacementGroupDef(name: 'Hra', placements: [
            PlacementDef(name: 'Hra', c: 0, r: 0),
          ]),
        ],
      );

  static EncounterDef get encounter10dot5 => EncounterDef(
      expansion: 'xulc',
      questId: '10_act1',
      number: '5',
      title: 'Knowable Only by Analogy',
      setup: EncounterSetup(
          box: 'XU-1', map: '9', adversary: '10-11', tiles: '4x Pod Traps'),
      victoryDescription: 'Slay the Hastadilling',
      roundLimit: 10,
      terrain: [
        trapPod(3),
        etherEarth(),
        etherWater(),
        etherWind(),
      ],
      baseLystReward: 20,
      itemRewards: ['Gestalt Snare'],
      campaignLink:
          'Intermission - “**Loathsome Changes None Could Explain**”, [campaign] **30**.',
      challenges: [
        'When rolling the damage dice for adversary attacks, increase the result of [DIM] by +1[DMG].',
        'Each time a Rover deals 3 or more [DMG] with an attack, they drain an ether dice in their personal pool, if able to.',
        'Adversaries do not trigger and ignore the effects of the basic ether fields found in the core rule book.',
      ],
      dialogs: [
        introductionFromText('quest_10_encounter_5_intro'),
      ],
      allies: [
        AllyDef(
          name: 'Hra',
          cardId: 'A-024',
          behaviors: [
            EncounterFigureDef(
              name: 'Marl',
              health: 10,
              traits: [
                'Push and pull effects targeting this unit are reduced by 1.',
              ],
            )
          ],
        ),
      ],
      onLoad: [
        dialog('Introduction'),
        codexLink('Not One, But Two',
            number: 14,
            body:
                'Immediately after the action where the Hastadilling is defeated, read [title], [codex] 9.'),
      ],
      onWillEndRound: [
        milestone('_victory', condition: AllAdversariesSlainCondition()),
      ],
      onMilestone: {
        '_victory': [
          codex(18),
          victory(body: '''*Your infection worsens!*
          
All Rovers must replace one of their class traits with one infected trait. Write in your campaign log which trait was replaced.
          
[*In the app, you can record which trait you have chosen from each Rover's menu.*]''')
        ]
      },
      startingMap: MapDef(
        id: '10.5',
        columnCount: 13,
        rowCount: 11,
        backgroundRect: Rect.fromLTWH(125.0, 44.0, 1481.0, 1411.0),
        starts: [
          (3, 0),
          (3, 10),
          (5, 0),
          (5, 10),
          (7, 0),
          (7, 10),
          (9, 0),
          (9, 10),
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
          (3, 3): TerrainType.difficult,
          (3, 7): TerrainType.object,
          (4, 9): TerrainType.difficult,
          (5, 2): TerrainType.object,
          (6, 0): TerrainType.difficult,
          (8, 2): TerrainType.difficult,
          (8, 8): TerrainType.difficult,
          (9, 6): TerrainType.difficult,
          (9, 7): TerrainType.object,
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
          name: 'Cleaving Xulc',
          standeeCount: 8,
          health: 6,
          traits: [
            'Ignores the effects of water and xulc terrain.',
          ],
          affinities: {
            Ether.dim: 1,
          },
          spawnable: true,
        ),
        EncounterFigureDef(
          name: 'Armored Xulc',
          standeeCount: 8,
          health: 5,
          defense: 2,
          traits: [
            'Ignores the effects of water and xulc terrain.',
          ],
          affinities: {
            Ether.dim: 2,
          },
          spawnable: true,
        ),
        EncounterFigureDef(
          name: 'Flying Xulc',
          standeeCount: 8,
          health: 5,
          flies: true,
          traits: [
            '[React] After this unit is attacked:\n\nLogic: Retreat\n[Dash] 2',
          ],
          affinities: {
            Ether.dim: 1,
          },
          spawnable: true,
        ),
        EncounterFigureDef(
          name: 'Undercarriage',
          letter: 'A',
          type: AdversaryType.boss,
          standeeCount: 1,
          healthFormula: '15*R',
          traits: [
            '''[React] After an enemy within [Range] 1 attacks:
            
[m_attack] | [Range] 1 | [DMG]2 | [Target] the enemy that attacked'''
          ],
          affinities: {
            Ether.fire: 1,
            Ether.dim: 2,
          },
          onSlain: [
            codex(17),
            placementGroup('Cleaving Xulc',
                body:
                    'Spawn R Cleaving Xulc within [Range] 0-1 of where the Undercarriage was slain.')
          ],
        ),
        EncounterFigureDef(
          name: 'Head',
          letter: 'B',
          type: AdversaryType.boss,
          standeeCount: 1,
          healthFormula: '12*R',
          flies: true,
          traits: [
            'Enemies within [Range] 1 of this unit gain -1[DMG] to all of their attacks.'
          ],
          affinities: {
            Ether.wind: 1,
            Ether.dim: 2,
          },
          onSlain: [
            removeRule('Head'),
            codex(16),
            placementGroup('Flying Xulc',
                body:
                    'Spawn R Flying Xulc within [Range] 0-1 of where the Head was slain.'),
          ],
        ),
        EncounterFigureDef(
          name: 'Hastadilling',
          letter: 'C',
          standeeCount: 1,
          type: AdversaryType.boss,
          healthFormula: '10*R',
          large: true,
          traits: [
            '''[React] After this unit suffers [DMG] from any source:
            
[POS] | [Range] 0 | [DEF] 1'''
          ],
          affinities: {
            Ether.earth: 1,
            Ether.wind: 1,
            Ether.fire: 1,
            Ether.dim: 2,
          },
          onSlain: [
            codex(14),
            placementGroup('Head', silent: true),
            replace('Hastadilling Headless', silent: true),
            rules('Hastadilling',
                '''*The colony xulc within the Hastadilling are ripping it apart.*
              
Spawn the Head using a normal one hex base within [Range] 1 of the Hastadilling. The Hastadilling now uses the Hastadilling Headless statistic block, recovering its current [HP] to maximum. Move the Hastadilling ability token to the same ability number on the Hastadilling Headless.'''),
            rules('Head',
                '''The Head uses the unique logic keyword, drag. When the Head moves with the drag logic keyword, all enemies within [Range] 1 of it must move in such a way as to stay adjacent to the Head, moving the fewest spaces to do so.'''),
            codexLink('Separate But Whole',
                number: 15,
                body:
                    'Immediately after the action where the Hastadilling Headless is defeated, read [title], [codex] 9.'),
            codexLink('Crush',
                number: 16,
                body:
                    'Immediately after the action where the Head is slain, read [title], [codex] 9.'),
          ],
        ),
        EncounterFigureDef(
          name: 'Hastadilling Headless',
          letter: 'D',
          type: AdversaryType.boss,
          standeeCount: 1,
          healthFormula: '10*R',
          large: true,
          traits: [
            '[React] After this unit suffers [DMG] from any source: ||| [POS] | [Range] 0 [DEF] 1'
          ],
          affinities: {
            Ether.earth: 1,
            Ether.fire: 1,
            Ether.dim: 2,
          },
          onSlain: [
            codex(15),
            placementGroup('Undercarriage', silent: true),
            replace('Hastadilling Core', silent: true),
            rules('Hastadilling', '''*The xulc colony is becoming desperate.*

Spawn the Undercarriage using a normal one hex base within [Range] 1 of the Hastadilling Headless. The Hastadilling Headless now uses the Hastadilling Core statistic block, recovering its current [HP] to maximum. Move the Hastadilling Headless ability token to the same ability number on the Hastadilling Core.'''),
            codexLink('Until It Is Done',
                number: 18,
                body:
                    'At the end of the round where all adversaries are slain, read [title], [codex] 10.'),
            codexLink('Rip and Tear',
                number: 17,
                body:
                    'Immediately after the action where the Undercarriage is slain, read [title], [codex] 10.'),
          ],
        ),
        EncounterFigureDef(
          name: 'Hastadilling Core',
          letter: 'E',
          type: AdversaryType.boss,
          standeeCount: 1,
          healthFormula: '20*R',
          large: true,
          traits: [
            '[React] After this unit suffers [DMG] from any source: ||| [POS] | [Range] 0 [DEF] 1'
          ],
          affinities: {
            Ether.earth: 1,
            Ether.dim: 2,
          },
          onSlain: [
            removeRule('Hastadilling'),
          ],
        ),
      ],
      placements: [
        PlacementDef(name: 'Hastadilling', c: 6, r: 5),
        PlacementDef(
            name: 'Pod', type: PlacementType.trap, c: 3, r: 5, trapDamage: 3),
        PlacementDef(
            name: 'Pod', type: PlacementType.trap, c: 6, r: 3, trapDamage: 3),
        PlacementDef(
            name: 'Pod', type: PlacementType.trap, c: 9, r: 4, trapDamage: 3),
        PlacementDef(
            name: 'Pod', type: PlacementType.trap, c: 5, r: 7, trapDamage: 3),
        PlacementDef(name: 'fire', type: PlacementType.ether, c: 5, r: 2),
        PlacementDef(name: 'earth', type: PlacementType.ether, c: 3, r: 7),
        PlacementDef(name: 'wind', type: PlacementType.ether, c: 9, r: 7),
      ],
      placementGroups: [
        PlacementGroupDef(
            name: 'Head', placements: [PlacementDef(name: 'Head')]),
        PlacementGroupDef(name: 'Flying Xulc', placements: [
          PlacementDef(name: 'Flying Xulc'),
          PlacementDef(name: 'Flying Xulc'),
          PlacementDef(name: 'Flying Xulc', minPlayers: 3),
          PlacementDef(name: 'Flying Xulc', minPlayers: 4),
        ]),
        PlacementGroupDef(
            name: 'Undercarriage',
            placements: [PlacementDef(name: 'Undercarriage')]),
        PlacementGroupDef(name: 'Cleaving Xulc', placements: [
          PlacementDef(name: 'Cleaving Xulc'),
          PlacementDef(name: 'Cleaving Xulc'),
          PlacementDef(name: 'Cleaving Xulc', minPlayers: 3),
          PlacementDef(name: 'Cleaving Xulc', minPlayers: 4),
        ]),
      ]);

  static EncounterDef get encounter10dot6dotEarly => EncounterDef(
        expansion: 'xulc',
        questId: '10_act2',
        number: '6.early',
        title: 'Mapping Oblivion',
        setup: EncounterSetup(
            box: 'XU-2',
            map: '10',
            adversary: '12',
            tiles: '5x Pod Traps, 4x Hoards, 3x Crumbling Columns'),
        victoryDescription:
            'Collect R **Xulc Samples** and return to a [start] space.',
        roundLimit: 8,
        terrain: [
          difficultXulc(),
          dangerousFire(2),
          trapPod(3),
          etherFire(),
          etherMorph(),
        ],
        baseLystReward: 25,
        stashReward: ItemDef.xulcStashName,
        playerPossibleTokens: ['RxHoard'],
        milestone: CampaignMilestone.milestone10dot6,
        challenges: [
          'A Rover can only carry one **Xulc Sample**. While Rovers carry a **Xulc Sample**, all of their movement actions are reduced by 1.',
          'A Rover can only carry one **Xulc Sample**. While a Rover carries a **Xulc Sample**, after each of their movement actions, they suffer [DMG]1.',
          'A Rover can only carry one **Xulc Sample**. While a Rover carries a **Xulc Sample**, all adversary attacks that target them gain +1 [DMG].',
        ],
        trackerEvents: [
          EncounterTrackerEventDef(
              title:
                  'Mark this at the end of a round when all Rovers and Hra are standing on a [start] and you have R samples.',
              ifMilestone: '_hoards_collected',
              recordMilestone: '_ready_for_victory'),
        ],
        campaignLink:
            '''Check your campaign sheet, if you do not have either milestone “**Opened Your Third Eye**” or “**Hra The Mountain**” marked, select your next encounter: 
            
Encounter 7 - “**Half in Another World**”, [campaign] **38** or Encounter 8 - “**Thief of Light, Giver of Light**”, [campaign] **46**.

If you have the milestones “**Hra The Mountain**” marked and “**Opened Your Third Eye**” not marked, proceed to:

Encounter 7 - “**Half in Another World**”, [campaign] **42**.

If you have the milestones “**Opened Your Third Eye**” marked and “**Hra The Mountain**” not marked, proceed to:

Encounter 8 - “**Thief of Light, Giver of Light**”, [campaign] **48**.''',
        dialogs: [
          introductionFromText('quest_10_encounter_6_early_intro'),
        ],
        onLoad: [
          dialog('Introduction'),
          rules(
              'Ezmen Clan',
              '''*You have milestone “**${CampaignMilestone.milestone2dot5Advocate}**” marked in your core box campaign sheet.*

*Returning to the Ezmen clan for the first time since you slayed their queens, you hoped you’d come across a more comforting scene. From afar you hear the noises of battle and the xulc-stench, and as you arrive the familiar sight of panicked survival. To the east, Keb fights infected rasska, protecting a small series of tents and domiciles. To the west, a horde of infected ashemak surround a barricaded hovel.*

***ROVERS**, a psychic message from a nearby squad of keb warriors rings out.* 

***THE GREAT EMANCIPATORS. MIRN INFORMED US OF YOUR RETURN TO US. WEST SIDE HAS VALUABLE RESEARCH. TAKE THAT, THEN AID IN THE EAST.***

***WE ASSIST. WE PROTECT** - another keb’s psychic voice enters your consciousness. Without waiting for a response, the keb launch to your side, some clinging to your backs, all wielding shields. It feels wrong to use these ilk as living armor, but you always admired how readily the keb rasska would live and die for each other.*

Rovers gain [DEF] 2.  The first time a Rover suffers any amount of damage, this [DEF] is lost.''',
              condition:
                  MilestoneCondition(CampaignMilestone.milestone2dot5Advocate)),
          rules(
              'Ezmen Clan',
              '''*You have milestone “**${CampaignMilestone.milestone2dot5Sovereign}**” marked in your core box campaign sheet.*

*Returning to the Ezmen clan for the first time since you slayed their queens, you hoped you’d come across a more comforting scene. From afar you hear the noises of battle and the xulc-stench, and as you arrive the familiar sight of panicked survival. To the east, Keb fights infected rasska, protecting a small series of tents and domiciles. To the west, a horde of infected ashemak surround a barricaded hovel.*

***ROVERS**, a psychic message from a nearby squad of keb warriors rings out.* 

***THE GREAT EMANCIPATORS. MIRN INFORMED US OF YOUR RETURN TO US. WEST SIDE HAS VALUABLE RESEARCH. TAKE THAT, THEN AID IN THE EAST.***

***WE ASSIST. WE PROTECT** - another keb’s psychic voice enters your consciousness. Without waiting for a response, the keb launch to your side, some clinging to your backs, all wielding shields. It feels wrong to use these ilk as living armor, but you always admired how readily the keb rasska would live and die for each other.*

Rovers gain [DEF] 2.  The first time a Rover suffers any amount of damage, this [DEF] is lost.''',
              condition: MilestoneCondition(
                  CampaignMilestone.milestone2dot5Sovereign)),
          rules(
              'Ezmen Clan',
              '''*You do not have milestones “**${CampaignMilestone.milestone2dot5Advocate}**” or “**${CampaignMilestone.milestone2dot5Sovereign}**” marked in your core box campaign sheet.*

*You follow the smell. You’ve gotten good at following the smell. It’s never exactly a welcome smell, but you’ve gotten good at knowing what it means and following it. Arriving at the desecrated keb rasska camp, you see a horde of infected ashemak feasting on the corpses of keb and rasska alike. To the west, you see what looks like a barricaded domicile, covered in xulc-infected therans. “That’s the research warren.” Silky offers. “It looks like it’s held up well enough. Retrieve whatever you can from it and let’s be rid of this place!”*''',
              conditions: [
                MilestoneCondition(CampaignMilestone.milestone2dot5Advocate,
                    value: false),
                MilestoneCondition(CampaignMilestone.milestone2dot5Sovereign,
                    value: false)
              ]),
          rules('I Think It’s Moving',
              '''*The hoard tiles represent live but otherwise inert xulc samples.*

To gain the samples, a Rover has to end their turn on a hoard tile. When they do, place the hoard tile on their class board. Once you have collected R samples, return to a [start] space. There’s no reward for collecting more than R samples.'''),
          rules('Xulc Colony',
              '''The Xulc are subsuming the land and its people, rapidly. There are six ether icons by the Keb Rasska tents. These icons represent possible spawn locations throughout the encounter.

When an adversary with the **Infected** trait is slain, place it off to the side of the map on its side. During the **Start Phase**, for each adversary that is both off to the side and flipped vertically, roll an ether dice from the general pool, then spawn that adversary at the space with the ether icon corresponding to the result of the roll. Then, for each adversary that is both off to the side and placed on its side, flip them vertically.'''),
          codexLink('I Hope This Was Worth It',
              number: 19,
              body:
                  'At the end of the round where all Rovers and Hra are standing on a [start] and you have R samples, read [title], [codex] 10.'),
        ],
        onMilestone: {
          '_hoard4': [
            milestone('_hoards_collected', condition: PlayerCountCondition(4))
          ],
          '_hoard3': [
            milestone('_hoards_collected', condition: PlayerCountCondition(3))
          ],
          '_hoard2': [
            milestone('_hoards_collected', condition: PlayerCountCondition(2))
          ],
          '_victory': [
            codex(19),
            victory(
                body:
                    '''Mo and Makaal can make use of the material you retrieved from the keb rasska xulc colony. Add the Xulc merchant deck to the store.'''),
          ],
        },
        onWillEndRound: [
          milestone('_victory',
              condition: MilestoneCondition('_ready_for_victory')),
        ],
        allies: [
          AllyDef(
            name: 'Hra',
            cardId: 'A-024',
            behaviors: [
              EncounterFigureDef(
                name: 'Marl',
                health: 10,
                traits: [
                  'Push and pull effects targeting this unit are reduced by 1.',
                ],
                onDidStartRound: [
                  EncounterAction(
                    type: EncounterActionType.toggleBehavior,
                    conditions: [
                      MilestoneCondition(CampaignMilestone.milestone10dot8)
                    ],
                    silent: true,
                  ),
                ],
              ),
              EncounterFigureDef(
                name: 'Ether-Charged',
                health: 10,
                defense: 1,
                traits: [
                  'Push and pull effects targeting this unit are reduced by 1.',
                ],
              )
            ],
          ),
        ],
        startingMap: MapDef(
          id: '10.6.early',
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
            (0, 1): TerrainType.difficult,
            (0, 2): TerrainType.object,
            (1, 1): TerrainType.difficult,
            (1, 2): TerrainType.object,
            (1, 3): TerrainType.object,
            (2, 0): TerrainType.difficult,
            (2, 1): TerrainType.difficult,
            (2, 4): TerrainType.dangerous,
            (2, 6): TerrainType.object,
            (3, 1): TerrainType.difficult,
            (3, 6): TerrainType.object,
            (3, 7): TerrainType.object,
            (4, 3): TerrainType.object,
            (5, 3): TerrainType.object,
            (5, 4): TerrainType.object,
            (5, 6): TerrainType.dangerous,
            (6, 8): TerrainType.object,
            (7, 6): TerrainType.object,
            (8, 3): TerrainType.object,
            (8, 5): TerrainType.object,
            (8, 6): TerrainType.object,
            (9, 1): TerrainType.object,
            (10, 0): TerrainType.object,
            (10, 1): TerrainType.object,
            (10, 4): TerrainType.dangerous,
            (11, 0): TerrainType.difficult,
            (11, 1): TerrainType.difficult,
            (11, 2): TerrainType.difficult,
            (11, 3): TerrainType.difficult,
            (11, 8): TerrainType.object,
            (12, 2): TerrainType.difficult,
            (12, 7): TerrainType.object,
            (12, 8): TerrainType.object,
          },
          spawnPoints: {
            (0, 3): Ether.wind,
            (2, 7): Ether.fire,
            (4, 2): Ether.morph,
            (9, 2): Ether.water,
            (9, 6): Ether.earth,
            (11, 7): Ether.crux,
          },
        ),
        overlays: [
          EncounterFigureDef(name: 'Hoard', alias: 'Xulc Sample', onLoot: [
            addToken('Hoard'),
            milestone('_hoard4', condition: MilestoneCondition('_hoard3')),
            milestone('_hoard3', condition: MilestoneCondition('_hoard2')),
            milestone('_hoard2', condition: MilestoneCondition('_hoard1')),
            milestone('_hoard1'),
          ]),
        ],
        adversaries: [
          EncounterFigureDef(
            name: 'Cleaving Xulc',
            health: 8,
            traits: [
              'Ignores the effects of water and xulc terrain.',
              '[React] After this unit is attacked within [Range] 1, it performs:\n\n[m_attack] | [Range] 1 | [DMG]2'
            ],
            affinities: {
              Ether.dim: 1,
            },
            spawnable: true,
          ),
          EncounterFigureDef(
            name: 'Armored Xulc',
            health: 6,
            defense: 2,
            traits: [
              'Ignores the effects of water and xulc terrain.',
              '[React] After this unit is attacked at [Range] 2 or greater, it performs:\n\n[POS] | [Range] 0 | [DEF] 1'
            ],
            affinities: {
              Ether.dim: 2,
            },
            spawnable: true,
          ),
          EncounterFigureDef(
            name: 'Flying Xulc',
            health: 6,
            flies: true,
            traits: [
              '[React] After this unit is attacked:\n\nLogic: Retreat\n[Dash] 3',
            ],
            affinities: {
              Ether.dim: 1,
            },
            spawnable: true,
          ),
          EncounterFigureDef(
            name: 'Faltering Ashemak',
            letter: 'A',
            health: 10,
            infected: true,
            spawnable: true,
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
            name: 'Colony',
            letter: 'B',
            health: 6,
            infected: true,
            spawnable: true,
            traits: [
              'When this unit is slain, roll the Xulc dice twice.',
            ],
            affinities: {
              Ether.earth: 1,
              Ether.crux: 1,
              Ether.morph: -1,
              Ether.wind: -1,
            },
            onSlain: [
              rollXulcDie(title: 'Colony Slain: First Roll'),
              rollXulcDie(title: 'Colony Slain: Second Roll'),
            ],
          ),
          EncounterFigureDef(
            name: 'Regenerator',
            letter: 'C',
            health: 8,
            defense: 1,
            infected: true,
            spawnable: true,
            traits: [
              'At the start of this unit\'s turn, it recovers [RCV] R.',
            ],
            affinities: {
              Ether.fire: 1,
              Ether.morph: 1,
              Ether.water: -1,
              Ether.crux: -1,
            },
          ),
        ],
        placements: const [
          PlacementDef(name: 'Faltering Ashemak', c: 3, r: 1),
          PlacementDef(name: 'Faltering Ashemak', c: 5, r: 0, minPlayers: 4),
          PlacementDef(name: 'Faltering Ashemak', c: 9, r: 0),
          PlacementDef(name: 'Faltering Ashemak', c: 7, r: 7, minPlayers: 3),
          PlacementDef(name: 'Faltering Ashemak', c: 4, r: 6, minPlayers: 3),
          PlacementDef(name: 'Colony', c: 1, r: 4),
          PlacementDef(name: 'Colony', c: 8, r: 1, minPlayers: 4),
          PlacementDef(name: 'Colony', c: 12, r: 6),
          PlacementDef(name: 'Regenerator', c: 7, r: 5),
          PlacementDef(name: 'Regenerator', c: 2, r: 5),
          PlacementDef(name: 'Regenerator', c: 6, r: 3, minPlayers: 4),
          PlacementDef(name: 'Regenerator', c: 6, r: 0, minPlayers: 3),
          PlacementDef(name: 'Hoard', type: PlacementType.object, c: 0, r: 0),
          PlacementDef(name: 'Hoard', type: PlacementType.object, c: 1, r: 0),
          PlacementDef(name: 'Hoard', type: PlacementType.object, c: 12, r: 0),
          PlacementDef(name: 'Hoard', type: PlacementType.object, c: 12, r: 1),
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
              r: 5,
              trapDamage: 3),
          PlacementDef(
              name: 'Pod',
              type: PlacementType.trap,
              c: 10,
              r: 2,
              trapDamage: 3),
          PlacementDef(
              name: 'Pod',
              type: PlacementType.trap,
              c: 12,
              r: 3,
              trapDamage: 3),
          PlacementDef(
              name: 'Pod', type: PlacementType.trap, c: 3, r: 0, trapDamage: 3),
          PlacementDef(
              name: 'Pod', type: PlacementType.trap, c: 2, r: 2, trapDamage: 3),
          PlacementDef(
              name: 'Crumbling Column',
              type: PlacementType.trap,
              c: 6,
              r: 1,
              trapDamage: 3),
          PlacementDef(name: 'fire', type: PlacementType.ether, c: 8, r: 3),
          PlacementDef(name: 'morph', type: PlacementType.ether, c: 6, r: 8),
        ],
      );

  static EncounterDef get encounter10dot6dotLate => EncounterDef(
        expansion: 'xulc',
        questId: '10_act2',
        number: '6.late',
        title: 'Mapping Oblivion',
        setup: EncounterSetup(
            box: 'XU-2',
            map: '11',
            adversary: '14-15',
            tiles: '5x Pod Traps, 4x Hoards, 3x Crumbling Columns'),
        victoryDescription:
            'Collect R **Xulc Samples* and return to a [start] space.',
        roundLimit: 8,
        terrain: [
          difficultXulc(),
          dangerousFire(2),
          trapPod(3),
          etherFire(),
          etherMorph(),
        ],
        baseLystReward: 25,
        stashReward: ItemDef.xulcStashName,
        playerPossibleTokens: ['RxHoard'],
        milestone: CampaignMilestone.milestone10dot6,
        campaignLink:
            '''Encounter 9 - “**Promethean Purpose**”, [campaign] **50**.''',
        challenges: [
          'A Rover can only carry one **Xulc Sample**. While Rovers carry a **Xulc Sample**, all of their movement actions are reduced by 1.',
          'A Rover can only carry one **Xulc Sample**. While a Rover carries a **Xulc Sample**, after each of their movement actions, they suffer [DMG]1.',
          'A Rover can only carry one **Xulc Sample**. While a Rover carries a **Xulc Sample**, all adversary attacks that target them gain +1 [DMG].',
        ],
        trackerEvents: [
          EncounterTrackerEventDef(
              title:
                  'Mark this at the end of a round when all Rovers and Hra are standing on a [start] and you have R samples.',
              ifMilestone: '_hoards_collected',
              recordMilestone: '_ready_for_victory'),
        ],
        dialogs: [
          introductionFromText('quest_10_encounter_6_late_intro'),
        ],
        onLoad: [
          dialog('Introduction'),
          rules(
              'Ezmen Clan',
              '''*You do not have milestones “**${CampaignMilestone.milestone2dot5Advocate}**” or “**${CampaignMilestone.milestone2dot5Sovereign}**” marked in your core box campaign sheet.*

*You follow the smell. You’ve gotten good at following the smell. It’s never exactly a welcome smell, but you’ve gotten good at knowing what it means and following it. Arriving at the desecrated keb rasska camp, you see a horde of infected ashemak feasting on the corpses of keb and rasska alike. To the west, you see what looks like a barricaded domicile, covered in xulc-infected therans. “That’s the research warren.” Silky offers. “It looks like it’s held up well enough. Retrieve whatever you can from it and let’s be rid of this place!”*''',
              conditions: [
                MilestoneCondition(CampaignMilestone.milestone2dot5Advocate,
                    value: false),
                MilestoneCondition(CampaignMilestone.milestone2dot5Sovereign,
                    value: false)
              ]),
          rules('I Think It’s Moving',
              '''*The hoard tiles represent live but otherwise inert xulc samples.*

To gain the samples, a Rover has to end their turn on a hoard tile. When they do, place the hoard tile on their class board. Once you have collected R samples, return to a [start] space. There’s no reward for collecting more than R samples.'''),
          rules('Xulc Colony',
              '''The Xulc are subsuming the land and its people, rapidly. There are six ether icons by the Keb Rasska tents. These icons represent possible spawn locations throughout the encounter.

When an adversary with the **Infected** trait is slain, place it off to the side of the map on its side. During the **Start Phase**, for each adversary that is both off to the side and flipped vertically, roll an ether dice from the general pool, then spawn that adversary at the space with the ether icon corresponding to the result of the roll. Then, for each adversary that is both off to the side and placed on its side, flip them vertically.'''),
          codexLink('Recycled Parts',
              number: 20,
              body:
                  'At the end of the round where all Rovers and Hra are standing on a [start] and you have R samples, read [title], [codex] 11.'),
        ],
        onMilestone: {
          '_hoard4': [
            milestone('_hoards_collected', condition: PlayerCountCondition(4))
          ],
          '_hoard3': [
            milestone('_hoards_collected', condition: PlayerCountCondition(3))
          ],
          '_hoard2': [
            milestone('_hoards_collected', condition: PlayerCountCondition(2))
          ],
          '_victory': [
            codex(20),
            victory(
                body:
                    '''Mo and Makaal can make use of the material you retrieved from the keb rasska xulc colony. Add the Xulc merchant deck to the store.'''),
          ],
        },
        onWillEndRound: [
          milestone('_victory',
              condition: MilestoneCondition('_ready_for_victory')),
        ],
        allies: [
          AllyDef(
            name: 'Hra',
            cardId: 'A-024',
            behaviors: [
              EncounterFigureDef(
                name: 'Marl',
                health: 10,
                traits: [
                  'Push and pull effects targeting this unit are reduced by 1.',
                ],
                onDidStartRound: [
                  EncounterAction(
                    type: EncounterActionType.toggleBehavior,
                    conditions: [
                      MilestoneCondition(CampaignMilestone.milestone10dot8)
                    ],
                    silent: true,
                  ),
                ],
              ),
              EncounterFigureDef(
                name: 'Ether-Charged',
                health: 10,
                defense: 1,
                traits: [
                  'Push and pull effects targeting this unit are reduced by 1.',
                ],
              )
            ],
          ),
        ],
        startingMap: MapDef(
          id: '10.6.late',
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
            (0, 1): TerrainType.difficult,
            (0, 2): TerrainType.object,
            (1, 1): TerrainType.difficult,
            (1, 2): TerrainType.object,
            (1, 3): TerrainType.object,
            (2, 0): TerrainType.difficult,
            (2, 1): TerrainType.difficult,
            (2, 4): TerrainType.dangerous,
            (2, 6): TerrainType.object,
            (3, 1): TerrainType.difficult,
            (3, 6): TerrainType.object,
            (3, 7): TerrainType.object,
            (4, 3): TerrainType.object,
            (5, 3): TerrainType.object,
            (5, 4): TerrainType.object,
            (5, 6): TerrainType.dangerous,
            (6, 8): TerrainType.object,
            (7, 6): TerrainType.object,
            (8, 3): TerrainType.object,
            (8, 5): TerrainType.object,
            (8, 6): TerrainType.object,
            (9, 1): TerrainType.object,
            (10, 0): TerrainType.object,
            (10, 1): TerrainType.object,
            (10, 4): TerrainType.dangerous,
            (11, 0): TerrainType.difficult,
            (11, 1): TerrainType.difficult,
            (11, 2): TerrainType.difficult,
            (11, 3): TerrainType.difficult,
            (11, 8): TerrainType.object,
            (12, 2): TerrainType.difficult,
            (12, 7): TerrainType.object,
            (12, 8): TerrainType.object,
          },
          spawnPoints: {
            (0, 3): Ether.wind,
            (2, 7): Ether.fire,
            (4, 2): Ether.morph,
            (9, 2): Ether.water,
            (9, 6): Ether.earth,
            (11, 7): Ether.crux,
          },
        ),
        overlays: [
          EncounterFigureDef(name: 'Hoard', alias: 'Xulc Sample', onLoot: [
            addToken('Hoard'),
            milestone('_hoard4', condition: MilestoneCondition('_hoard3')),
            milestone('_hoard3', condition: MilestoneCondition('_hoard2')),
            milestone('_hoard2', condition: MilestoneCondition('_hoard1')),
            milestone('_hoard1'),
          ]),
        ],
        adversaries: [
          EncounterFigureDef(
            name: 'Cleaving Xulc',
            health: 8,
            traits: [
              'Ignores the effects of water and xulc terrain.',
              '[React] After this unit is attacked within [Range] 1, it performs:\n\n[m_attack] | [Range] 1 | [DMG]2'
            ],
            affinities: {
              Ether.dim: 1,
            },
          ),
          EncounterFigureDef(
            name: 'Armored Xulc',
            health: 6,
            defense: 2,
            traits: [
              'Ignores the effects of water and xulc terrain.',
              '[React] After this unit is attacked at [Range] 2 or greater, it performs:\n\n[POS] | [Range] 0 | [DEF] 1'
            ],
            affinities: {
              Ether.dim: 2,
            },
          ),
          EncounterFigureDef(
            name: 'Flying Xulc',
            health: 6,
            flies: true,
            traits: [
              '[React] After this unit is attacked:\n\nLogic: Retreat\n[Dash] 3',
            ],
            affinities: {
              Ether.dim: 1,
            },
          ),
          EncounterFigureDef(
            name: 'Faltering Ashemak',
            letter: 'A',
            health: 10,
            infected: true,
            spawnable: true,
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
            name: 'Colony',
            letter: 'B',
            health: 6,
            infected: true,
            spawnable: true,
            traits: [
              'When this unit is slain, roll the Xulc dice twice.',
            ],
            affinities: {
              Ether.earth: 1,
              Ether.crux: 1,
              Ether.morph: -1,
              Ether.wind: -1,
            },
            onSlain: [
              rollXulcDie(title: 'Colony Slain: First Roll'),
              rollXulcDie(title: 'Colony Slain: Second Roll'),
            ],
          ),
          EncounterFigureDef(
            name: 'Regenerator',
            letter: 'C',
            health: 8,
            defense: 1,
            infected: true,
            spawnable: true,
            traits: [
              'At the start of this unit\'s turn, it recovers [RCV] R.',
            ],
            affinities: {
              Ether.fire: 1,
              Ether.morph: 1,
              Ether.water: -1,
              Ether.crux: -1,
            },
          ),
          EncounterFigureDef(
            name: 'Fracturing Gruv',
            letter: 'D',
            health: 20,
            defenseFormula: '3*(1-T%2)',
            traits: [
              'After the action where this unit is slain, spawn R armored Xulc within [Range] 0-1 of where this unit was.',
              'During even rounds, this unit gains [Def] 3.',
            ],
            affinities: {
              Ether.earth: 2,
              Ether.fire: 1,
              Ether.water: -1,
            },
            onSlain: [
              placementGroup('Armored Xulc',
                  body:
                      'Spawn R armored Xulc within [Range] 0-1 of where this unit was.'),
            ],
          ),
        ],
        placements: const [
          PlacementDef(name: 'Faltering Ashemak', c: 5, r: 0, minPlayers: 4),
          PlacementDef(name: 'Faltering Ashemak', c: 9, r: 0),
          PlacementDef(name: 'Faltering Ashemak', c: 7, r: 7, minPlayers: 3),
          PlacementDef(name: 'Faltering Ashemak', c: 4, r: 6, minPlayers: 3),
          PlacementDef(name: 'Colony', c: 1, r: 4),
          PlacementDef(name: 'Colony', c: 8, r: 1, minPlayers: 4),
          PlacementDef(name: 'Regenerator', c: 7, r: 5),
          PlacementDef(name: 'Regenerator', c: 6, r: 0, minPlayers: 3),
          PlacementDef(name: 'Faltering Ashemak', c: 3, r: 1),
          PlacementDef(name: 'Regenerator', c: 12, r: 6, minPlayers: 4),
          PlacementDef(name: 'Fracturing Gruv', c: 6, r: 3),
          PlacementDef(name: 'Hoard', type: PlacementType.object, c: 0, r: 0),
          PlacementDef(name: 'Hoard', type: PlacementType.object, c: 1, r: 0),
          PlacementDef(name: 'Hoard', type: PlacementType.object, c: 12, r: 0),
          PlacementDef(name: 'Hoard', type: PlacementType.object, c: 12, r: 1),
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
              r: 5,
              trapDamage: 3),
          PlacementDef(
              name: 'Pod',
              type: PlacementType.trap,
              c: 10,
              r: 2,
              trapDamage: 3),
          PlacementDef(
              name: 'Pod',
              type: PlacementType.trap,
              c: 12,
              r: 3,
              trapDamage: 3),
          PlacementDef(
              name: 'Pod', type: PlacementType.trap, c: 3, r: 0, trapDamage: 3),
          PlacementDef(
              name: 'Pod', type: PlacementType.trap, c: 2, r: 2, trapDamage: 3),
          PlacementDef(
              name: 'Crumbling Column',
              type: PlacementType.trap,
              c: 6,
              r: 1,
              trapDamage: 3),
          PlacementDef(name: 'fire', type: PlacementType.ether, c: 8, r: 3),
          PlacementDef(name: 'morph', type: PlacementType.ether, c: 6, r: 8),
        ],
        placementGroups: [
          PlacementGroupDef(
            name: 'Armored Xulc',
            placements: [
              PlacementDef(name: 'Armored Xulc'),
              PlacementDef(name: 'Armored Xulc'),
              PlacementDef(name: 'Armored Xulc', minPlayers: 3),
              PlacementDef(name: 'Armored Xulc', minPlayers: 4),
            ],
          )
        ],
      );

  static EncounterDef get encounter10dot7dotEarly => EncounterDef(
        expansion: 'xulc',
        questId: '10_act2',
        number: '7.early',
        title: 'Half in Another World',
        setup: EncounterSetup(
            box: 'XU-2',
            map: '12',
            adversary: '16',
            tiles: '4x Pod Traps, 2x Bursting Bells'),
        victoryDescription: 'Survive for 7 rounds.',
        lossDescription: 'Lose if any Tihfur Mystic is slain.',
        roundLimit: 7,
        terrain: [
          difficultWater(),
          difficultXulc(),
          dangerousBramble(2),
          trapBell(3),
          trapPod(3),
          etherEarth(),
          etherWind(),
        ],
        baseLystReward: 25,
        milestone: CampaignMilestone.milestone10dot7,
        campaignLink:
            '''Check your campaign sheet, if you do not have either milestone “**Acquired the Samples**” or “**Hra The Mountain**” marked, select your next encounter:

Encounter 6 - “**Mapping Oblivion**”,  [campaign] **32** or
Encounter 8 - “**Thief of Light, Giver of Light**”, [campaign] **46**.

If you have the milestones “**Hra The Mountain**” marked and “**Acquired the Samples**” not marked, proceed to:

Encounter 6 - “**Mapping Oblivion**”, [campaign] **36**.

If you have the milestones “**Acquired the Samples**” marked and “**Hra The Mountain**” not marked, proceed to:

Encounter 8 - “**Thief of Light, Giver of Light**”, [campaign] **48**.''',
        challenges: [
          'For **Protect the Ritual**, only roll the ether dice R times.',
          'Set the **Tihfur Mystics** current [HP] to 4.',
          'Xulc will always attack **Tihfur Mystics** if they are within range of their attacks.',
        ],
        dialogs: [
          introductionFromText('quest_10_encounter_7_early_intro'),
        ],
        onLoad: [
          dialog('Introduction'),
          rules(
              'The Left and Right of the Yanshif',
              '''You have the milestone “**${CampaignMilestone.milestone1dot5}**” marked in your core box campaign sheet:

*Heading down to the site of the ritual, you see an extremely welcome face. Zeepurah, in full Yanshif Dominant regalia, leaves her husband for a moment, walking to you flanked by their strigiform guards. Zeepurah bows, and extends a hand. Even despite your obvious mutation, she grasps each of your hands with warmth and sincerity. “We are blessed this day, dear Yanshif. We have heroes in our midst.”*

Each Rover may generate one [morph] dice.''',
              condition: MilestoneCondition(CampaignMilestone.milestone1dot5)),
          rules(
              'The Left and Right of the Yanshif',
              '''You do not have the milestone “**${CampaignMilestone.milestone1dot5}**” marked in your core box campaign sheet:

*Even beneath the panicked focus of the current crisis, you can tell the Yanshif hold a deeper tension compared to your last visit here. Though it is undeniable that the defeat of the Ahma has allowed the community to heal, the Yanshif are still in mourning for the loss of their leadership. A small sculpture has appeared in the centre of the village, a mourning-craft, in the likeness of one you once knew - Zeepurah.*''',
              condition: MilestoneCondition(CampaignMilestone.milestone1dot5,
                  value: false)),
          rules('The Yanshif',
              '''The Yanshif are helping the Urshif reject the xulc from their form. Protect the ritual until it is complete.

There are three Yanshif present (use Nahadir standees). They have 8 [HP] each, are enemies to adversaries, and allies to Rovers. They are consumed by their ritual and are unable to assist in their defense any other way.'''),
          rules(
              'Protect the Ritual',
              'You have time to prepare for the assault. At the beginning of the encounter, roll an ether dice R*2 times. Each time you roll the dice, place the ether field that corresponds with the result of the roll anywhere on the map you wish too. Any one Rover may count as placing any of the ether fields. This can be useful if your Rover gains benefits for placing class specific ether fields.'
                  ''),
          rules('Xulc Colony',
              '''*The Xulc are subsuming the land and its people, rapidly.* There are six ether icons on the edges of the map. These icons represent possible spawn locations throughout the encounter.

When an adversary with the **Infected** trait is slain, place it off to the side of the map on its side. During the **Start Phase**, for each adversary that is both off to the side and flipped vertically, roll an ether dice from the general pool, then spawn that adversary at the space with the ether icon corresponding to the result of the roll. Then, for each adversary that is both off to the side and placed on its side, flip them vertically.'''),
          codexLink('Did it Work?',
              number: 21,
              body: 'At the end of round 7, read [title], [codex] 12.'),
        ],
        onWillEndRound: [
          milestone('_victory', condition: RoundCondition(7)),
        ],
        onMilestone: {
          '_victory': [
            codex(21),
            victory(
                body:
                    '''The ritual was a success. The xulc parasites were expelled from those of the Urshif that were resisting the infection. The parasite within you is scared and asserting its dominance.

All Rovers must make a choice. They must either reduce their maximum [HP] by 3, returning your base [HP] to the same value on your class board, or select and permanently add one infected skill card to their hand. This infected card **DOES** count toward the number of skill or reaction cards you may take in an encounter.

[*In the app, you can choose to resign your [HP] increase from each Rover's menu.*]'''),
          ],
        },
        allies: [
          AllyDef(
            name: 'Hra',
            cardId: 'A-024',
            behaviors: [
              EncounterFigureDef(
                name: 'Marl',
                health: 10,
                traits: [
                  'Push and pull effects targeting this unit are reduced by 1.',
                ],
                onDidStartRound: [
                  EncounterAction(
                    type: EncounterActionType.toggleBehavior,
                    conditions: [
                      MilestoneCondition(CampaignMilestone.milestone10dot8)
                    ],
                    silent: true,
                  ),
                ],
              ),
              EncounterFigureDef(
                name: 'Ether-Charged',
                health: 10,
                defense: 1,
                traits: [
                  'Push and pull effects targeting this unit are reduced by 1.',
                ],
              )
            ],
          ),
        ],
        startingMap: MapDef(
          id: '10.7.early',
          columnCount: 13,
          rowCount: 11,
          backgroundRect: Rect.fromLTWH(110.0, 44.0, 1481.0, 1411.0),
          starts: [
            (4, 5),
            (4, 6),
            (5, 4),
            (5, 7),
            (6, 3),
            (7, 4),
            (7, 7),
            (8, 5),
            (8, 6),
          ],
          terrain: {
            (0, 8): TerrainType.difficult,
            (0, 9): TerrainType.difficult,
            (1, 10): TerrainType.difficult,
            (2, 1): TerrainType.difficult,
            (2, 2): TerrainType.difficult,
            (2, 3): TerrainType.difficult,
            (2, 5): TerrainType.dangerous,
            (3, 2): TerrainType.difficult,
            (4, 2): TerrainType.difficult,
            (4, 3): TerrainType.object,
            (4, 9): TerrainType.difficult,
            (5, 6): TerrainType.object,
            (5, 10): TerrainType.difficult,
            (6, 4): TerrainType.object,
            (7, 6): TerrainType.object,
            (7, 10): TerrainType.difficult,
            (8, 7): TerrainType.object,
            (9, 4): TerrainType.dangerous,
            (12, 0): TerrainType.difficult,
            (12, 1): TerrainType.difficult,
            (12, 4): TerrainType.difficult,
          },
          spawnPoints: {
            (0, 0): Ether.fire,
            (0, 5): Ether.wind,
            (1, 10): Ether.water,
            (11, 10): Ether.morph,
            (12, 0): Ether.crux,
            (12, 5): Ether.earth,
          },
        ),
        adversaries: [
          EncounterFigureDef(
            name: 'Cleaving Xulc',
            health: 8,
            traits: [
              'Ignores the effects of water and xulc terrain.',
              '[React] After this unit is attacked within [Range] 1, it performs:\n\n[m_attack] | [Range] 1 | [DMG]2'
            ],
            affinities: {
              Ether.dim: 1,
            },
            spawnable: true,
          ),
          EncounterFigureDef(
            name: 'Armored Xulc',
            health: 6,
            defense: 2,
            traits: [
              'Ignores the effects of water and xulc terrain.',
              '[React] After this unit is attacked at [Range] 2 or greater, it performs:\n\n[POS] | [Range] 0 | [DEF] 1'
            ],
            affinities: {
              Ether.dim: 2,
            },
            spawnable: true,
          ),
          EncounterFigureDef(
            name: 'Flying Xulc',
            health: 6,
            flies: true,
            traits: [
              '[React] After this unit is attacked:\n\nLogic: Retreat\n[Dash] 3',
            ],
            affinities: {
              Ether.dim: 1,
            },
            spawnable: true,
          ),
          EncounterFigureDef(
            name: 'Withering Dekaha',
            letter: 'A',
            health: 10,
            respawns: true,
            infected: true,
            affinities: {
              Ether.earth: 1,
              Ether.water: 2,
              Ether.fire: -2,
            },
          ),
          EncounterFigureDef(
            name: 'Colony',
            letter: 'B',
            health: 6,
            infected: true,
            respawns: true,
            traits: [
              'When this unit is slain, roll the Xulc dice twice.',
            ],
            affinities: {
              Ether.wind: -1,
              Ether.morph: -1,
              Ether.crux: 1,
              Ether.earth: 1,
            },
            onSlain: [
              rollXulcDie(title: 'Colony Slain: First Roll'),
              rollXulcDie(title: 'Colony Slain: Second Roll'),
            ],
          ),
          EncounterFigureDef(
              name: 'Hunter',
              letter: 'C',
              health: 10,
              infected: true,
              respawns: true,
              traits: [
                'When this unit is slain, if the result of the xulc dice is blank, reroll the dice.',
              ],
              affinities: {
                Ether.fire: -1,
                Ether.earth: -1,
                Ether.water: 1,
                Ether.wind: 1,
              },
              onSlain: [
                rollXulcDie(
                    body:
                        'When this unit is slain, if the result of the xulc dice is blank, reroll the dice.'),
              ]),
          EncounterFigureDef(
            name: 'Nahadir',
            alias: 'Tihfur Mystic',
            faction: 'The Urshif',
            health: 8,
            onSlain: [
              fail(),
            ],
          ),
        ],
        placements: const [
          PlacementDef(name: 'Withering Dekaha', c: 0, r: 4),
          PlacementDef(name: 'Withering Dekaha', c: 3, r: 10, minPlayers: 3),
          PlacementDef(name: 'Withering Dekaha', c: 12, r: 6),
          PlacementDef(name: 'Withering Dekaha', c: 9, r: 0, minPlayers: 4),
          PlacementDef(name: 'Colony', c: 5, r: 0, minPlayers: 3),
          PlacementDef(name: 'Colony', c: 0, r: 1),
          PlacementDef(name: 'Colony', c: 0, r: 7, minPlayers: 4),
          PlacementDef(name: 'Colony', c: 12, r: 9),
          PlacementDef(name: 'Hunter', c: 1, r: 9),
          PlacementDef(name: 'Hunter', c: 9, r: 10, minPlayers: 3),
          PlacementDef(name: 'Hunter', c: 12, r: 3, minPlayers: 4),
          PlacementDef(name: 'Hunter', c: 11, r: 1),
          PlacementDef(name: 'Nahadir', c: 5, r: 5),
          PlacementDef(name: 'Nahadir', c: 7, r: 5),
          PlacementDef(name: 'Nahadir', c: 6, r: 6),
          PlacementDef(
              name: 'Pod', type: PlacementType.trap, c: 2, r: 9, trapDamage: 3),
          PlacementDef(
              name: 'Pod',
              type: PlacementType.trap,
              c: 11,
              r: 8,
              trapDamage: 3),
          PlacementDef(
              name: 'Pod',
              type: PlacementType.trap,
              c: 11,
              r: 0,
              trapDamage: 3),
          PlacementDef(
              name: 'Pod', type: PlacementType.trap, c: 1, r: 1, trapDamage: 3),
          PlacementDef(
              name: 'Bursting Bell',
              type: PlacementType.trap,
              c: 6,
              r: 1,
              trapDamage: 3),
          PlacementDef(
              name: 'Bursting Bell',
              type: PlacementType.trap,
              c: 6,
              r: 8,
              trapDamage: 3),
          PlacementDef(name: 'wind', type: PlacementType.ether, c: 8, r: 7),
          PlacementDef(name: 'earth', type: PlacementType.ether, c: 4, r: 3),
        ],
      );

  static EncounterDef get encounter10dot7dotLate => EncounterDef(
      expansion: 'xulc',
      questId: '10_act2',
      number: '7.late',
      title: 'Half in Another World',
      setup: EncounterSetup(
          box: 'XU-2',
          map: '13',
          adversary: '18-19',
          tiles: '4x Pod Traps, 2x Bursting Bells'),
      victoryDescription: 'Survive for 7 rounds.',
      lossDescription: 'Lose if any Tihfur Mystic is slain.',
      roundLimit: 7,
      terrain: [
        difficultWater(),
        difficultXulc(),
        dangerousBramble(2),
        trapBell(3),
        trapPod(3),
        etherEarth(),
        etherWind(),
      ],
      baseLystReward: 25,
      milestone: CampaignMilestone.milestone10dot7,
      campaignLink:
          '''Encounter 9 - “**Promethean Purpose**”, [campaign] **50**.''',
      challenges: [
        'For **Protect the Ritual**, only roll the ether dice R times.',
        'Set the **Tihfur Mystics** current [HP] to 4.',
        'Xulc will always attack **Tihfur Mystics** if they are within range of their attacks.',
      ],
      dialogs: [
        introductionFromText('quest_10_encounter_7_late_intro'),
      ],
      onLoad: [
        dialog('Introduction'),
        rules(
            'The Left and Right of the Yanshif',
            '''You have the milestone “**${CampaignMilestone.milestone1dot5}**” marked in your core box campaign sheet:

*Heading down to the site of the ritual, you see an extremely welcome face. Zeepurah, in full Yanshif Dominant regalia, leaves her husband for a moment, walking to you flanked by their strigiform guards. Zeepurah bows, and extends a hand. Even despite your obvious mutation, she grasps each of your hands with warmth and sincerity. “We are blessed this day, dear Yanshif. We have heroes in our midst.”*

Each Rover may generate one [morph] dice.''',
            condition: MilestoneCondition(CampaignMilestone.milestone1dot5)),
        rules(
            'The Left and Right of the Yanshif',
            '''You do not have the milestone “**${CampaignMilestone.milestone1dot5}**” marked in your core box campaign sheet:

*Even beneath the panicked focus of the current crisis, you can tell the Yanshif hold a deeper tension compared to your last visit here. Though it is undeniable that the defeat of the Ahma has allowed the community to heal, the Yanshif are still in mourning for the loss of their leadership. A small sculpture has appeared in the centre of the village, a mourning-craft, in the likeness of one you once knew - Zeepurah.*''',
            condition: MilestoneCondition(CampaignMilestone.milestone1dot5,
                value: false)),
        rules('The Yanshif',
            '''The Yanshif are helping the Urshif reject the xulc from their form. Protect the ritual until it is complete.

There are three Yanshif present (use Nahadir standees). They have 8 [HP] each, are enemies to adversaries, and allies to Rovers. They are consumed by their ritual and are unable to assist in their defense any other way.'''),
        rules(
            'Protect the Ritual',
            'You have time to prepare for the assault. At the beginning of the encounter, roll an ether dice R*2 times. Each time you roll the dice, place the ether field that corresponds with the result of the roll anywhere on the map you wish too. Any one Rover may count as placing any of the ether fields. This can be useful if your Rover gains benefits for placing class specific ether fields.'
                ''),
        rules('Xulc Colony',
            '''*The Xulc are subsuming the land and its people, rapidly.* There are six ether icons on the edges of the map. These icons represent possible spawn locations throughout the encounter.

When an adversary with the **Infected** trait is slain, place it off to the side of the map on its side. During the **Start Phase**, for each adversary that is both off to the side and flipped vertically, roll an ether dice from the general pool, then spawn that adversary at the space with the ether icon corresponding to the result of the roll. Then, for each adversary that is both off to the side and placed on its side, flip them vertically.'''),
        codexLink('No Sky Could Blind You Now',
            number: 22,
            body: 'At the end of round 7, read [title], [codex] 12.'),
      ],
      onWillEndRound: [
        milestone('_victory', condition: RoundCondition(7)),
      ],
      onMilestone: {
        '_victory': [
          codex(22),
          victory(
              body:
                  '''The ritual was a success. The xulc parasites were expelled from those of the Urshif that were resisting the infection. The parasite within you is scared and asserting its dominance.

All Rovers must make a choice. They must either reduce their maximum [HP] by 3, returning your base [HP] to the same value on your class board, or select and permanently add one infected skill card to their hand. This infected card **DOES** count toward the number of skill or reaction cards you may take in an encounter.

[*In the app, you can choose to resign your [HP] increase from each Rover's menu.*]'''),
        ],
      },
      allies: [
        AllyDef(
          name: 'Hra',
          cardId: 'A-024',
          behaviors: [
            EncounterFigureDef(
              name: 'Marl',
              health: 10,
              traits: [
                'Push and pull effects targeting this unit are reduced by 1.',
              ],
              onDidStartRound: [
                EncounterAction(
                  type: EncounterActionType.toggleBehavior,
                  conditions: [
                    MilestoneCondition(CampaignMilestone.milestone10dot8)
                  ],
                  silent: true,
                ),
              ],
            ),
            EncounterFigureDef(
              name: 'Ether-Charged',
              health: 10,
              defense: 1,
              traits: [
                'Push and pull effects targeting this unit are reduced by 1.',
              ],
            )
          ],
        ),
      ],
      startingMap: MapDef(
        id: '10.7.early',
        columnCount: 13,
        rowCount: 11,
        backgroundRect: Rect.fromLTWH(110.0, 44.0, 1481.0, 1411.0),
        starts: [
          (4, 5),
          (4, 6),
          (5, 4),
          (5, 7),
          (6, 3),
          (7, 4),
          (7, 7),
          (8, 5),
          (8, 6),
        ],
        terrain: {
          (0, 8): TerrainType.difficult,
          (0, 9): TerrainType.difficult,
          (1, 10): TerrainType.difficult,
          (2, 1): TerrainType.difficult,
          (2, 2): TerrainType.difficult,
          (2, 3): TerrainType.difficult,
          (2, 5): TerrainType.dangerous,
          (3, 2): TerrainType.difficult,
          (4, 2): TerrainType.difficult,
          (4, 3): TerrainType.object,
          (4, 9): TerrainType.difficult,
          (5, 6): TerrainType.object,
          (5, 10): TerrainType.difficult,
          (6, 4): TerrainType.object,
          (7, 6): TerrainType.object,
          (7, 10): TerrainType.difficult,
          (8, 7): TerrainType.object,
          (9, 4): TerrainType.dangerous,
          (12, 0): TerrainType.difficult,
          (12, 1): TerrainType.difficult,
          (12, 4): TerrainType.difficult,
        },
        spawnPoints: {
          (0, 0): Ether.fire,
          (0, 5): Ether.wind,
          (1, 10): Ether.water,
          (11, 10): Ether.morph,
          (12, 0): Ether.crux,
          (12, 5): Ether.earth,
        },
      ),
      adversaries: [
        EncounterFigureDef(
          name: 'Cleaving Xulc',
          health: 8,
          traits: [
            'Ignores the effects of water and xulc terrain.',
            '[React] After this unit is attacked within [Range] 1, it performs:\n\n[m_attack] | [Range] 1 | [DMG]2'
          ],
          affinities: {
            Ether.dim: 1,
          },
          spawnable: true,
        ),
        EncounterFigureDef(
          name: 'Armored Xulc',
          health: 6,
          defense: 2,
          traits: [
            'Ignores the effects of water and xulc terrain.',
            '[React] After this unit is attacked at [Range] 2 or greater, it performs:\n\n[POS] | [Range] 0 | [DEF] 1'
          ],
          affinities: {
            Ether.dim: 2,
          },
          spawnable: true,
        ),
        EncounterFigureDef(
          name: 'Flying Xulc',
          health: 6,
          flies: true,
          traits: [
            '[React] After this unit is attacked:\n\nLogic: Retreat\n[Dash] 3',
          ],
          affinities: {
            Ether.dim: 1,
          },
          spawnable: true,
        ),
        EncounterFigureDef(
          name: 'Withering Dekaha',
          letter: 'A',
          health: 10,
          respawns: true,
          infected: true,
          affinities: {
            Ether.earth: 1,
            Ether.water: 2,
            Ether.fire: -2,
          },
        ),
        EncounterFigureDef(
          name: 'Colony',
          letter: 'B',
          health: 6,
          infected: true,
          respawns: true,
          traits: [
            'When this unit is slain, roll the Xulc dice twice.',
          ],
          affinities: {
            Ether.wind: -1,
            Ether.morph: -1,
            Ether.crux: 1,
            Ether.earth: 1,
          },
          onSlain: [
            rollXulcDie(title: 'Colony Slain: First Roll'),
            rollXulcDie(title: 'Colony Slain: Second Roll'),
          ],
        ),
        EncounterFigureDef(
          name: 'Hunter',
          letter: 'C',
          health: 10,
          infected: true,
          respawns: true,
          traits: [
            'When this unit is slain, if the result of the xulc dice is blank, reroll the dice.',
          ],
          affinities: {
            Ether.fire: -1,
            Ether.earth: -1,
            Ether.water: 1,
            Ether.wind: 1,
          },
          onSlain: [
            rollXulcDie(
                body:
                    'When this unit is slain, if the result of the xulc dice is blank, reroll the dice.'),
          ],
        ),
        EncounterFigureDef(
          name: 'Bursting Terranape',
          letter: 'D',
          type: AdversaryType.miniboss,
          health: 28,
          traits: [
            'When this unit is slain, spawn R Cleaving Xulc within [Range] 0-1 of where this unit was.',
            'When this unit suffers damage from any source, all enemies within [Range] 1 suffer [DMG]1.',
          ],
          affinities: {
            Ether.water: 2,
            Ether.earth: 2,
            Ether.morph: 1,
            Ether.wind: -1,
            Ether.fire: -2,
          },
          onSlain: [
            placementGroup('Cleaving Xulc',
                body:
                    'Spawn R Cleaving Xulc within [Range] 0-1 of where this unit was.'),
          ],
        ),
        EncounterFigureDef(
          name: 'Nahadir',
          alias: 'Tihfur Mystic',
          faction: 'The Urshif',
          health: 8,
          onSlain: [
            fail(),
          ],
        ),
      ],
      placements: const [
        PlacementDef(name: 'Withering Dekaha', c: 0, r: 4),
        PlacementDef(name: 'Withering Dekaha', c: 3, r: 10, minPlayers: 3),
        PlacementDef(name: 'Withering Dekaha', c: 12, r: 6),
        PlacementDef(name: 'Withering Dekaha', c: 9, r: 0, minPlayers: 4),
        PlacementDef(name: 'Colony', c: 5, r: 0, minPlayers: 3),
        PlacementDef(name: 'Colony', c: 0, r: 1),
        PlacementDef(name: 'Colony', c: 0, r: 7, minPlayers: 4),
        PlacementDef(name: 'Colony', c: 12, r: 9),
        PlacementDef(name: 'Hunter', c: 9, r: 10, minPlayers: 3),
        PlacementDef(name: 'Hunter', c: 12, r: 3, minPlayers: 4),
        PlacementDef(name: 'Bursting Terranape', c: 11, r: 1),
        PlacementDef(name: 'Nahadir', c: 5, r: 5),
        PlacementDef(name: 'Nahadir', c: 7, r: 5),
        PlacementDef(name: 'Nahadir', c: 6, r: 6),
        PlacementDef(
            name: 'Pod', type: PlacementType.trap, c: 2, r: 9, trapDamage: 3),
        PlacementDef(
            name: 'Pod', type: PlacementType.trap, c: 11, r: 8, trapDamage: 3),
        PlacementDef(
            name: 'Pod', type: PlacementType.trap, c: 11, r: 0, trapDamage: 3),
        PlacementDef(
            name: 'Pod', type: PlacementType.trap, c: 1, r: 1, trapDamage: 3),
        PlacementDef(
            name: 'Bursting Bell',
            type: PlacementType.trap,
            c: 6,
            r: 1,
            trapDamage: 3),
        PlacementDef(
            name: 'Bursting Bell',
            type: PlacementType.trap,
            c: 6,
            r: 8,
            trapDamage: 3),
        PlacementDef(name: 'wind', type: PlacementType.ether, c: 8, r: 7),
        PlacementDef(name: 'earth', type: PlacementType.ether, c: 4, r: 3),
      ],
      placementGroups: [
        PlacementGroupDef(name: 'Cleaving Xulc', placements: [
          PlacementDef(name: 'Cleaving Xulc'),
          PlacementDef(name: 'Cleaving Xulc'),
          PlacementDef(name: 'Cleaving Xulc', minPlayers: 3),
          PlacementDef(name: 'Cleaving Xulc', minPlayers: 4),
        ])
      ]);

  static EncounterDef get encounter10dot8dotEarly => EncounterDef(
        expansion: 'xulc',
        questId: '10_act2',
        number: '8.early',
        title: 'Thief of Light, Giver of Light',
        setup: EncounterSetup(
            box: 'XU-2', map: '14', adversary: '20', tiles: '3x Magical Traps'),
        victoryDescription: 'Empower Hra 3 times.',
        lossDescription: 'Lose if Hra is slain.',
        roundLimit: 8,
        terrain: [
          dangerousCrystals(2),
          trapMagic(3),
          etherWind(),
          etherCrux(),
        ],
        baseLystReward: 25,
        milestone: CampaignMilestone.milestone10dot8,
        campaignLink:
            '''Encounter 9 - “**Promethean Purpose**”, [campaign] **50**.''',
        challenges: [
          'When Rovers wish to ignore **Fulgurite Fields**, they must spend an additional +2 ether dice.',
          'The damage Rover units suffer from **Fulgurite Fields** is increased by +1 [DMG].',
          'Xulc will always attack Hra if they are within range of their attacks.',
        ],
        dialogs: [
          introductionFromText('quest_10_encounter_8_early_intro'),
        ],
        onLoad: [
          dialog('Introduction'),
          rules('Fulgurite Fields',
              '''There are 6 crystals around the map, each with an ether icon. At the beginning of each round, roll an ether dice from the general pool and place that dice onto the space of the crystal with the ether icon that matches the result of the roll.

At the end of each round, all units within [Range] 0-1 of the crystal with an ether dice on it suffers [DMG]3, then return this ether dice to the general pool.

Rovers can ignore this roll. At the end of the round, Rovers as a group may return R ether dice from their personal pools to the general pool to choose which fulgurite crystal is struck instead.'''),
          rules('Suffuse With Ether',
              '''*Hra has sought out the Fulgurite Fields of the Thunder Mesa.*  Protect them as they absorb the raw ether.

Hra must be struck by the Fulgurite Fields rule three times, once at the [earth] crystal, once at the [wind] crystal, and once at [crux] crystal.

[*In the app, add the corresponding token to Hra to record your progress against this requirement.*]'''),
          codexLink('You\'re Glowing',
              number: 23,
              body:
                  'Immediately after completing the requirements of Suffuse With Ether, read [title], [codex] 13.'),
        ],
        onMilestone: {
          '_victory': [
            codex(23),
            victory(
                body:
                    'For the remainder of the campaign, during encounters use Hra’s “**Ether-Charged**” side.'),
          ]
        },
        allies: [
          AllyDef(
            name: 'Hra',
            cardId: 'A-024',
            behaviors: [
              EncounterFigureDef(name: 'Marl', health: 10, possibleTokens: [
                'Earth',
                'Wind',
                'Crux'
              ], traits: [
                'Push and pull effects targeting this unit are reduced by 1.',
              ], onTokensChanged: [
                milestone('_victory', condition: TokenCountCondition('3')),
              ])
            ],
          ),
        ],
        startingMap: MapDef(
          id: '10.8.early',
          columnCount: 13,
          rowCount: 11,
          backgroundRect: Rect.fromLTWH(110.0, 44.0, 1481.0, 1411.0),
          starts: [
            (0, 0),
            (0, 9),
            (1, 0),
            (1, 10),
            (11, 0),
            (11, 10),
            (12, 0),
            (12, 9),
          ],
          terrain: {
            (1, 4): TerrainType.dangerous,
            (2, 2): TerrainType.dangerous,
            (2, 5): TerrainType.dangerous,
            (2, 7): TerrainType.dangerous,
            (4, 1): TerrainType.dangerous,
            (4, 5): TerrainType.object,
            (5, 7): TerrainType.dangerous,
            (6, 1): TerrainType.dangerous,
            (6, 3): TerrainType.object,
            (7, 8): TerrainType.dangerous,
            (9, 3): TerrainType.dangerous,
            (9, 5): TerrainType.dangerous,
            (10, 2): TerrainType.dangerous,
            (10, 6): TerrainType.dangerous,
          },
        ),
        adversaries: [
          EncounterFigureDef(
            name: 'Cleaving Xulc',
            health: 8,
            traits: [
              'Ignores the effects of water and xulc terrain.',
              '[React] After this unit is attacked within [Range] 1, it performs:\n\n[m_attack] | [Range] 1 | [DMG]2'
            ],
            affinities: {
              Ether.dim: 1,
            },
            spawnable: true,
          ),
          EncounterFigureDef(
            name: 'Armored Xulc',
            health: 6,
            defense: 2,
            traits: [
              'Ignores the effects of water and xulc terrain.',
              '[React] After this unit is attacked at [Range] 2 or greater, it performs:\n\n[POS] | [Range] 0 | [DEF] 1'
            ],
            affinities: {
              Ether.dim: 2,
            },
            spawnable: true,
          ),
          EncounterFigureDef(
            name: 'Flying Xulc',
            health: 6,
            flies: true,
            traits: [
              '[React] After this unit is attacked:\n\nLogic: Retreat\n[Dash] 3',
            ],
            affinities: {
              Ether.dim: 1,
            },
            spawnable: true,
          ),
          EncounterFigureDef(
            name: 'Colony',
            letter: 'A',
            health: 6,
            infected: true,
            traits: [
              'When this unit is slain, roll the Xulc dice twice.',
            ],
            affinities: {
              Ether.morph: -1,
              Ether.wind: -1,
              Ether.earth: 1,
              Ether.crux: 1,
            },
            onSlain: [
              rollXulcDie(title: 'Colony Slain: First Roll'),
              rollXulcDie(title: 'Colony Slain: Second Roll'),
            ],
          ),
          EncounterFigureDef(
            name: 'Regenerator',
            letter: 'B',
            health: 8,
            defense: 1,
            infected: true,
            traits: [
              ' At the start of this unit\'s turn, it recovers [RCV] R.',
            ],
            affinities: {
              Ether.fire: 1,
              Ether.morph: 1,
              Ether.water: -1,
              Ether.crux: -1,
            },
          ),
          EncounterFigureDef(
            name: 'Hunter',
            letter: 'C',
            health: 10,
            infected: true,
            traits: [
              'When this unit is slain, if the result of the xulc dice is blank, reroll the dice.',
            ],
            affinities: {
              Ether.fire: 1,
              Ether.water: 1,
              Ether.earth: -1,
              Ether.wind: 1,
            },
            onSlain: [
              rollXulcDie(
                  body:
                      'When this unit is slain, if the result of the xulc dice is blank, reroll the dice.'),
            ],
          ),
        ],
        placements: const [
          PlacementDef(name: 'Colony', c: 5, r: 0, minPlayers: 4),
          PlacementDef(name: 'Colony', c: 7, r: 2),
          PlacementDef(name: 'Colony', c: 3, r: 4),
          PlacementDef(name: 'Colony', c: 0, r: 5, minPlayers: 3),
          PlacementDef(name: 'Colony', c: 10, r: 3, minPlayers: 3),
          PlacementDef(name: 'Regenerator', c: 7, r: 0, minPlayers: 3),
          PlacementDef(name: 'Regenerator', c: 12, r: 5, minPlayers: 4),
          PlacementDef(name: 'Regenerator', c: 9, r: 7),
          PlacementDef(name: 'Regenerator', c: 0, r: 4),
          PlacementDef(name: 'Hunter', c: 4, r: 7),
          PlacementDef(name: 'Hunter', c: 8, r: 4),
          PlacementDef(name: 'Hunter', c: 12, r: 4),
          PlacementDef(name: 'Hunter', c: 7, r: 10, minPlayers: 3),
          PlacementDef(name: 'Hunter', c: 5, r: 10, minPlayers: 4),
          PlacementDef(
              name: 'Magic',
              type: PlacementType.trap,
              c: 4,
              r: 8,
              trapDamage: 3),
          PlacementDef(
              name: 'Magic',
              type: PlacementType.trap,
              c: 7,
              r: 6,
              trapDamage: 3),
          PlacementDef(
              name: 'Magic',
              type: PlacementType.trap,
              c: 4,
              r: 3,
              trapDamage: 3),
          PlacementDef(name: 'crux', type: PlacementType.ether, c: 4, r: 5),
          PlacementDef(name: 'wind', type: PlacementType.ether, c: 6, r: 3),
        ],
      );

  static EncounterDef get encounter10dot8dotLate => EncounterDef(
        expansion: 'xulc',
        questId: '10_act2',
        number: '8.late',
        title: 'Thief of Light, Giver of Light',
        setup: EncounterSetup(
            box: 'XU-2',
            map: '15',
            adversary: '22-23',
            tiles: '3x Magical Traps'),
        victoryDescription: 'Empower Hra 3 times.',
        lossDescription: 'Lose if Hra is slain.',
        roundLimit: 8,
        terrain: [
          dangerousCrystals(2),
          trapMagic(3),
          etherWind(),
          etherCrux(),
        ],
        baseLystReward: 25,
        milestone: CampaignMilestone.milestone10dot8,
        campaignLink:
            '''Check your campaign sheet, if you do not have either milestone “**Acquired the Samples**” or “**Completed the Ritual**” marked, select your next encounter:

Encounter 6 - “**Mapping Oblivion**”, [campaign] **32** or
Encounter 7 - “**Half in Another World**”, [campaign] **38**.

If you have the milestones “Completed the Ritual” marked and “Acquired the Samples” not marked, proceed to:

Encounter 6 - “**Mapping Oblivion**”, [campaign] **36**.

If you have the milestones “**Acquired the Samples**” marked and “**Completed the Ritual**” not marked, proceed to:

Encounter 7 - “**Half in Another World**”, [campaign] **42**.''',
        challenges: [
          'When Rovers wish to ignore **Fulgurite Fields**, they must spend an additional +2 ether dice.',
          'The damage Rover units suffer from **Fulgurite Fields** is increased by +1 [DMG].',
          'Xulc will always attack Hra if they are within range of their attacks.',
        ],
        dialogs: [
          introductionFromText('quest_10_encounter_8_late_intro'),
        ],
        onLoad: [
          dialog('Introduction'),
          rules('Fulgurite Fields',
              '''There are 6 crystals around the map, each with an ether icon. At the beginning of each round, roll an ether dice from the general pool and place that dice onto the space of the crystal with the ether icon that matches the result of the roll.

At the end of each round, all units within [Range] 0-1 of the crystal with an ether dice on it suffers [DMG]3, then return this ether dice to the general pool.

Rovers can ignore this roll. At the end of the round, Rovers as a group may return R ether dice from their personal pools to the general pool to choose which fulgurite crystal is struck instead.'''),
          rules('Suffuse With Ether',
              '''*Hra has sought out the Fulgurite Fields of the Thunder Mesa.*  Protect them as they absorb the raw ether.

Hra must be struck by the Fulgurite Fields rule three times, once at the [earth] crystal, once at the [wind] crystal, and once at [crux] crystal.

[*In the app, add the corresponding token to Hra to record your progress against this requirement.*]'''),
          codexLink('Apocalypse Conduit',
              number: 24,
              body:
                  'Immediately after completing the requirements of Suffuse With Ether, read [title], [codex] 14.'),
        ],
        onMilestone: {
          '_victory': [
            codex(24),
            victory(
                body:
                    'For the remainder of the campaign, during encounters use Hra’s “**Ether-Charged**” side.'),
          ]
        },
        allies: [
          AllyDef(
            name: 'Hra',
            cardId: 'A-024',
            behaviors: [
              EncounterFigureDef(name: 'Marl', health: 10, possibleTokens: [
                'Earth',
                'Wind',
                'Crux'
              ], traits: [
                'Push and pull effects targeting this unit are reduced by 1.',
              ], onTokensChanged: [
                milestone('_victory', condition: TokenCountCondition('3')),
              ])
            ],
          ),
        ],
        startingMap: MapDef(
          id: '10.8.late',
          columnCount: 13,
          rowCount: 11,
          backgroundRect: Rect.fromLTWH(125.0, 44.0, 1481.0, 1411.0),
          starts: [
            (0, 0),
            (0, 9),
            (1, 0),
            (1, 10),
            (11, 0),
            (11, 10),
            (12, 0),
            (12, 9),
          ],
          terrain: {
            (1, 4): TerrainType.dangerous,
            (2, 2): TerrainType.dangerous,
            (2, 5): TerrainType.dangerous,
            (2, 7): TerrainType.dangerous,
            (4, 1): TerrainType.dangerous,
            (4, 5): TerrainType.object,
            (5, 7): TerrainType.dangerous,
            (6, 1): TerrainType.dangerous,
            (6, 3): TerrainType.object,
            (7, 8): TerrainType.dangerous,
            (9, 3): TerrainType.dangerous,
            (9, 5): TerrainType.dangerous,
            (10, 2): TerrainType.dangerous,
            (10, 6): TerrainType.dangerous,
          },
        ),
        adversaries: [
          EncounterFigureDef(
            name: 'Cleaving Xulc',
            health: 8,
            traits: [
              'Ignores the effects of water and xulc terrain.',
              '[React] After this unit is attacked within [Range] 1, it performs:\n\n[m_attack] | [Range] 1 | [DMG]2'
            ],
            affinities: {
              Ether.dim: 1,
            },
            spawnable: true,
          ),
          EncounterFigureDef(
            name: 'Armored Xulc',
            health: 6,
            defense: 2,
            traits: [
              'Ignores the effects of water and xulc terrain.',
              '[React] After this unit is attacked at [Range] 2 or greater, it performs:\n\n[POS] | [Range] 0 | [DEF] 1'
            ],
            affinities: {
              Ether.dim: 2,
            },
            spawnable: true,
          ),
          EncounterFigureDef(
            name: 'Flying Xulc',
            health: 6,
            flies: true,
            traits: [
              '[React] After this unit is attacked:\n\nLogic: Retreat\n[Dash] 3',
            ],
            affinities: {
              Ether.dim: 1,
            },
            spawnable: true,
          ),
          EncounterFigureDef(
            name: 'Colony',
            letter: 'A',
            health: 6,
            infected: true,
            traits: [
              'When this unit is slain, roll the Xulc dice twice.',
            ],
            affinities: {
              Ether.morph: -1,
              Ether.wind: -1,
              Ether.earth: 1,
              Ether.crux: 1,
            },
            onSlain: [
              rollXulcDie(title: 'Colony Slain: First Roll'),
              rollXulcDie(title: 'Colony Slain: Second Roll'),
            ],
          ),
          EncounterFigureDef(
            name: 'Regenerator',
            letter: 'B',
            health: 8,
            defense: 1,
            infected: true,
            traits: [
              ' At the start of this unit\'s turn, it recovers [RCV] R.',
            ],
            affinities: {
              Ether.fire: 1,
              Ether.morph: 1,
              Ether.water: -1,
              Ether.crux: -1,
            },
          ),
          EncounterFigureDef(
            name: 'Hunter',
            letter: 'C',
            health: 10,
            infected: true,
            traits: [
              'When this unit is slain, if the result of the xulc dice is blank, reroll the dice.',
            ],
            affinities: {
              Ether.fire: 1,
              Ether.water: 1,
              Ether.earth: -1,
              Ether.wind: 1,
            },
            onSlain: [
              rollXulcDie(
                  body:
                      'When this unit is slain, if the result of the xulc dice is blank, reroll the dice.'),
            ],
          ),
          EncounterFigureDef(
            name: 'Fading Crown',
            letter: 'D',
            type: AdversaryType.miniboss,
            health: 24,
            flies: true,
            traits: [
              'After the action where this unit is slain, spawn R flying Xulc within [Range] 0-1 of where this unit was.',
            ],
            affinities: {
              Ether.crux: 2,
              Ether.wind: 1,
              Ether.fire: -1,
              Ether.morph: -2,
            },
            onSlain: [
              placementGroup('Flying Xulc',
                  body:
                      'Spawn R flying Xulc within [Range] 0-1 of where this unit was.'),
            ],
          ),
        ],
        placements: const [
          PlacementDef(name: 'Colony', c: 0, r: 5, minPlayers: 3),
          PlacementDef(name: 'Regenerator', c: 0, r: 4),
          PlacementDef(name: 'Hunter', c: 4, r: 7),
          PlacementDef(name: 'Colony', c: 4, r: 2),
          PlacementDef(name: 'Colony', c: 5, r: 0, minPlayers: 4),
          PlacementDef(name: 'Colony', c: 10, r: 3),
          PlacementDef(name: 'Regenerator', c: 7, r: 2, minPlayers: 4),
          PlacementDef(name: 'Regenerator', c: 7, r: 0, minPlayers: 3),
          PlacementDef(name: 'Regenerator', c: 12, r: 5),
          PlacementDef(name: 'Regenerator', c: 12, r: 4, minPlayers: 4),
          PlacementDef(name: 'Regenerator', c: 9, r: 7),
          PlacementDef(name: 'Hunter', c: 3, r: 4),
          PlacementDef(name: 'Hunter', c: 5, r: 10, minPlayers: 4),
          PlacementDef(name: 'Hunter', c: 7, r: 10, minPlayers: 3),
          PlacementDef(name: 'Fading Crown', c: 6, r: 5),
          PlacementDef(
              name: 'Magic',
              type: PlacementType.trap,
              c: 4,
              r: 8,
              trapDamage: 3),
          PlacementDef(
              name: 'Magic',
              type: PlacementType.trap,
              c: 7,
              r: 6,
              trapDamage: 3),
          PlacementDef(
              name: 'Magic',
              type: PlacementType.trap,
              c: 4,
              r: 3,
              trapDamage: 3),
          PlacementDef(name: 'crux', type: PlacementType.ether, c: 4, r: 5),
          PlacementDef(name: 'wind', type: PlacementType.ether, c: 6, r: 3),
        ],
        placementGroups: [
          PlacementGroupDef(name: 'Flying Xulc', placements: [
            PlacementDef(name: 'Flying Xulc'),
            PlacementDef(name: 'Flying Xulc'),
            PlacementDef(name: 'Flying Xulc', minPlayers: 3),
            PlacementDef(name: 'Flying Xulc', minPlayers: 4),
          ])
        ],
      );

  static EncounterDef get encounter10dot9 => EncounterDef(
        expansion: 'xulc',
        questId: '10_act2',
        number: '9',
        title: 'Promethean Purpose',
        setup: EncounterSetup(
            box: 'XU-2', map: '16', adversary: '24-25', tiles: '3x Pod Traps'),
        victoryDescription: 'Slay all adversaries.',
        roundLimit: 10,
        terrain: [
          EncounterTerrain('ether_node_dim',
              title: 'Dim Ether Node',
              expansion: 'xulc',
              body:
                  'Units that generate an ether dice while within [range] 1 of this node generate a [DIM] dice instead. Rovers can not take this dice.'),
          trapPod(3),
          difficultWater(),
          EncounterTerrain('difficult_xulc',
              title: 'Xulc Growth',
              expansion: 'xulc',
              damage: 1,
              body: 'Rovers that enter xulc growth suffer [DMG] 1.')
        ],
        baseLystReward: 40,
        milestone: CampaignMilestone.milestone10dot9,
        campaignLink:
            '''Encounter 10 - “Collapse, Greying & Disintegration”, [campaign] 52.''',
        challenges: [
          'All [miniboss] units gain +R*3 [HP].',
          'When rolling the damage dice for adversary attacks, increase the result of [DIM] by +1[DMG].',
          'Increase the range of the [DIM] node by +1 [Range].',
        ],
        dialogs: [
          introductionFromText('quest_10_encounter_9_intro'),
        ],
        onLoad: [
          dialog('Introduction'),
          rules('Expulsion Ritual',
              '''*You are inside of Hra, fighting the parasite with your “third eye”.*  Remove Hra’s ally card. In this mindscape, you will have to slay all adversaries. Only then will the parasite be weak enough to be extracted from your body.'''),
          codexLink('It’s Not Over',
              number: 25,
              body:
                  'After the action where the Hastadilling is slain, read [title], [codex] 15.'),
        ],
        onMilestone: {
          '_phase2': [
            codex(25),
            rules('The Parasite Changes',
                '''Spawn one Fracturing Gruv where the Hastadiling was, one Bursting Terranape adjacent to the closest Rover, and one Fading Crown within [Range] 4 of where the Hastadilling was, furthest away from the most Rovers.'''),
            placementGroup('Phase 2', silent: true),
            codexLink('It’s Gone?',
                number: 26,
                body:
                    'At the end of the round where all adversaries are slain, read [title], [codex] 15.'),
          ],
          '_victory': [
            codex(26),
            victory(body: '''*Your infection has been expelled!*

All infected cards are removed from your hand, your hand size is reduced by 1, your infected trait reverts to the class trait it replaced (refer to the note you made in the campaign sheet), and your maximum [HP] is set to what is noted on your class board.

Remove Hra’s ally card from the game.'''),
          ]
        },
        startingMap: MapDef(
          id: '10.9',
          columnCount: 13,
          rowCount: 11,
          backgroundRect: Rect.fromLTWH(110.0, 44.0, 1481.0, 1411.0),
          starts: [
            (0, 9),
            (1, 2),
            (11, 0),
            (11, 8),
          ],
          terrain: {
            (0, 7): TerrainType.object,
            (0, 8): TerrainType.object,
            (1, 1): TerrainType.difficult,
            (1, 3): TerrainType.difficult,
            (1, 8): TerrainType.object,
            (2, 1): TerrainType.difficult,
            (2, 2): TerrainType.difficult,
            (2, 3): TerrainType.difficult,
            (2, 5): TerrainType.object,
            (3, 4): TerrainType.difficult,
            (4, 1): TerrainType.object,
            (6, 8): TerrainType.object,
            (9, 3): TerrainType.object,
            (9, 7): TerrainType.difficult,
            (9, 8): TerrainType.difficult,
            (10, 0): TerrainType.object,
            (10, 1): TerrainType.object,
            (10, 6): TerrainType.difficult,
            (10, 8): TerrainType.difficult,
            (11, 1): TerrainType.object,
          },
        ),
        adversaries: [
          EncounterFigureDef(
            name: 'Cleaving Xulc',
            health: 8,
            traits: [
              'Ignores the effects of water and xulc terrain.',
              '[React] After this unit is attacked within [Range] 1, it performs:\n\n[m_attack] | [Range] 1 | [DMG]2'
            ],
            affinities: {
              Ether.dim: 1,
            },
            onSlain: [
              milestone('_victory', condition: AllAdversariesSlainCondition()),
            ],
            spawnable: true,
          ),
          EncounterFigureDef(
            name: 'Armored Xulc',
            health: 6,
            defense: 2,
            traits: [
              'Ignores the effects of water and xulc terrain.',
              '[React] After this unit is attacked at [Range] 2 or greater, it performs:\n\n[POS] | [Range] 0 | [DEF] 1'
            ],
            affinities: {
              Ether.dim: 2,
            },
            onSlain: [
              milestone('_victory', condition: AllAdversariesSlainCondition()),
            ],
            spawnable: true,
          ),
          EncounterFigureDef(
            name: 'Flying Xulc',
            health: 6,
            flies: true,
            traits: [
              '[React] After this unit is attacked:\n\nLogic: Retreat\n[Dash] 3',
            ],
            affinities: {
              Ether.dim: 1,
            },
            onSlain: [
              milestone('_victory', condition: AllAdversariesSlainCondition()),
            ],
            spawnable: true,
          ),
          EncounterFigureDef(
            name: 'Hastadilling',
            letter: 'A',
            type: AdversaryType.boss,
            healthFormula: '20*R',
            large: true,
            traits: [
              '''[React] After this unit suffers [DMG] from any source:
              
[POS] | [Range] 0 | [DEF] 1 ''',
            ],
            affinities: {
              Ether.dim: 2,
              Ether.earth: 1,
              Ether.wind: 1,
              Ether.fire: 1,
            },
            onSlain: [
              milestone('_phase2'),
            ],
          ),
          EncounterFigureDef(
            name: 'Fracturing Gruv (miniboss)',
            alias: 'Fracturing Gruv',
            letter: 'B',
            type: AdversaryType.miniboss,
            healthFormula: '8*R',
            defenseFormula: '3*(1-T%2)',
            traits: [
              'After the action where this unit is slain, spawn R armored Xulc within [Range] 0-1 of where this unit was.',
              'During even rounds, this unit gains [DEF] 3.',
            ],
            affinities: {
              Ether.water: -1,
              Ether.fire: 1,
              Ether.earth: 2,
            },
            onSlain: [
              placementGroup('Armored Xulc',
                  body:
                      'After the action where this unit is slain, spawn R armored Xulc within [Range] 0-1 of where this unit was.'),
            ],
          ),
          EncounterFigureDef(
            name: 'Bursting Terranape',
            letter: 'C',
            type: AdversaryType.miniboss,
            healthFormula: '10*R',
            traits: [
              'After the action where this unit is slain, spawn R cleaving Xulc within [Range] 0-1 of where this unit was.',
              'When this unit suffers damage from any source, all enemies within [Range] 1 suffer [DMG] R-1.',
            ],
            affinities: {
              Ether.earth: 2,
              Ether.fire: 1,
              Ether.water: -1,
              Ether.morph: 1,
            },
            onSlain: [
              placementGroup('Cleaving Xulc',
                  body:
                      'After the action where this unit is slain, spawn R cleaving Xulc within [Range] 0-1 of where this unit was.'),
            ],
          ),
          EncounterFigureDef(
            name: 'Fading Crown',
            letter: 'D',
            type: AdversaryType.miniboss,
            healthFormula: '8*R',
            flies: true,
            traits: [
              'After the action where this unit is slain, spawn R flying Xulc within [Range] 0-1 of where this unit was.',
            ],
            affinities: {
              Ether.morph: -2,
              Ether.fire: -1,
              Ether.wind: 1,
              Ether.crux: 2,
            },
            onSlain: [
              placementGroup('Flying Xulc',
                  body:
                      'After the action where this unit is slain, spawn R flying Xulc within [Range] 0-1 of where this unit was.'),
            ],
          ),
        ],
        placements: const [
          PlacementDef(name: 'Hastadilling', c: 6, r: 5),
          PlacementDef(
              name: 'Pod', type: PlacementType.trap, c: 3, r: 8, trapDamage: 3),
          PlacementDef(
              name: 'Pod', type: PlacementType.trap, c: 7, r: 2, trapDamage: 3),
          PlacementDef(
              name: 'Pod',
              type: PlacementType.trap,
              c: 10,
              r: 7,
              trapDamage: 3),
          PlacementDef(name: 'dim', type: PlacementType.ether, c: 2, r: 5),
          PlacementDef(name: 'dim', type: PlacementType.ether, c: 4, r: 1),
          PlacementDef(name: 'dim', type: PlacementType.ether, c: 9, r: 3),
          PlacementDef(name: 'dim', type: PlacementType.ether, c: 6, r: 8),
        ],
        placementGroups: [
          PlacementGroupDef(
            name: 'Phase 2',
            placements: [
              PlacementDef(name: 'Fracturing Gruv (miniboss)', c: 5, r: 5),
              PlacementDef(name: 'Bursting Terranape', c: 6, r: 4),
              PlacementDef(name: 'Fading Crown', c: 7, r: 5),
            ],
          ),
          PlacementGroupDef(name: 'Armored Xulc', placements: [
            PlacementDef(name: 'Armored Xulc'),
            PlacementDef(name: 'Armored Xulc'),
            PlacementDef(name: 'Armored Xulc', minPlayers: 3),
            PlacementDef(name: 'Armored Xulc', minPlayers: 4),
          ]),
          PlacementGroupDef(name: 'Cleaving Xulc', placements: [
            PlacementDef(name: 'Cleaving Xulc'),
            PlacementDef(name: 'Cleaving Xulc'),
            PlacementDef(name: 'Cleaving Xulc', minPlayers: 3),
            PlacementDef(name: 'Cleaving Xulc', minPlayers: 4),
          ]),
          PlacementGroupDef(name: 'Flying Xulc', placements: [
            PlacementDef(name: 'Flying Xulc'),
            PlacementDef(name: 'Flying Xulc'),
            PlacementDef(name: 'Flying Xulc', minPlayers: 3),
            PlacementDef(name: 'Flying Xulc', minPlayers: 4),
          ]),
        ],
      );

  static EncounterDef get encounter10dot10 => EncounterDef(
        expansion: 'xulc',
        questId: '10_act2',
        number: '10',
        title: 'Collapse, Greying & Disintegration',
        setup: EncounterSetup(
            box: 'XU-2',
            map: '17',
            adversary: '26-27',
            tiles: '3x Pod Traps, 4x Monstrous Growth'),
        victoryDescription: 'Slay the Prime Xulc.',
        roundLimit: 6,
        terrain: [
          trapPod(3),
          difficultWater(),
          difficultXulc(),
        ],
        baseLystReward: 0,
        challenges: [
          'When a Rover suffers damage as part of a Prime Xulc action, they drain an ether dice in their personal pool, then drain an ether dice in their infusion pool.',
          'The Prime Xulc does not trigger and ignores the effects of the basic ether fields found in the core rule book. When a Rover places a basic ether field into one of the Prime Xulc’s spaces, place the same ether field into that Rover’s space.',
          'When a Rover unit rolls the damage dice, they treat a result of [DIM] as -1 [DMG].',
        ],
        dialogs: [
          introductionFromText('quest_10_encounter_10_intro'),
        ],
        onLoad: [
          dialog('Introduction'),
          rules('3 Phase Encounter',
              'This is a 3 phase encounter. Each phase has its own round limit.'),
          rules('The Prime Xulc',
              '*The Prime Xulc is nested safely within their hive.* They take their turns as normal, but are otherwise immune to all sources of damage and can not be moved for any reason. Root out the hive to expose them to attack.'),
          rules('Phase 1',
              '''There are several Nidus Clusters throughout the map. For two Rovers, there are Nidus Clusters at spaces [A] and [B]. For three Rovers there is also a Nidus Cluster at [C], and for four Rovers there is another Nidus Cluster at [D]. Nidus Clusters are special objects with 30 [HP], they are enemies to Rovers and allies to adversaries. During the **Start Phase** of round 2, and each even round after that, roll the xulc dice once for each Nidus Cluster, and then spawn the result within [Range] 1 of that cluster. If the result of the dice is blank, reroll the dice once, keeping the second result.'''),
          codexLink('Everything Executioner',
              number: 27,
              body:
                  'At the end of the round where all Nidus Clusters have been destroyed, read [title], [codex] 16.'),
        ],
        onWillEndRound: [
          milestone('_phase2',
              condition: MilestoneCondition('_all_nidus_slain')),
          milestone('_phase3',
              condition: MilestoneCondition('_dominator_slain')),
        ],
        onMilestone: {
          '_phase2': [
            removeRule('The Prime Xulc'),
            removeRule('Phase 1'),
            codex(27),
            placementGroup('Phase 2', silent: true),
            rules('Phase 2', '''Proceed to [adversary] 28 and [map] 18.

Place Rovers in [start] spaces and spawn adversaries according to Rover count as shown on the map. Rover [HP], ether dice, and infusion dice carry over. Glyphs and summons carry over and are placed within [Range] 1 of their owner.
'''),
            resetRound(
                title: 'Phase 2',
                body:
                    'The round limit has been reset. You have 6 rounds to defeat the Prime Xulc Dominator.'),
            rules('Prime Xulc Dominator',
                '''*The Prime Xulc attacks relentlessly.*

The Prime Xulc takes R turns each round. Roll the adversary ability dice before each turn to determine which ability they perform.

They have two rows of 4 abilities, for a total of 8 abilities. These still act like one track. When the ability token advances beyond the 4th ability, place the token on the 5th ability and continue advancing the token along the track. When the token would advance beyond ability 8, it wraps around back to ability 1.'''),
            codexLink('If It Bleeds, We Can Kill It',
                number: 28,
                body:
                    'At the end of the round where the Prime Xulc Dominator has been defeated, read [title], [codex] 16.'),
          ],
          '_phase3': [
            removeRule('Prime Xulc Dominator'),
            removeRule('Phase 2'),
            codex(28),
            placementGroup('Phase 3', silent: true),
            rules('Phase 3',
                '''*The Xulc Prime is on the back foot and has retreated to the ocean. Stop them once and for all before they escape!*

Proceed to [adversary] 29 and [map] 19.

Place Rovers in [start] spaces and spawn adversaries according to Rover count as shown on the map. Rover [HP], ether dice, and infusion dice carry over. Glyphs and summons carry over and are placed within [Range] 1 of their owner.
'''),
            resetRound(
                title: 'Phase 3',
                body:
                    'The round limit has been reset. You have 6 rounds to defeat the Prime Xulc Deliverer.'),
            rules('Prime Xulc Deliverer',
                '''*The Prime Xulc is the master of their domain.*

There are 6 ether icons along the edge of the map, two icons per space.

At the beginning of each of the Prime Xulc’s turns they will dive and emerge at random locations along the coast. Roll an ether dice from the general pool and place the Prime Xulc’s primary hex in the space that corresponds with the result of the roll, with all of their other hexes occupying a water space.'''),
            codexLink('Victory!',
                number: 29,
                body:
                    'Immediately when the Prime Xulc Deliverer is slain, read [title], [codex] 17.'),
          ],
          '_victory': [
            codex(29),
            victory(body: '''**Congratulations!** 

You have won! The campaign is now over.'''),
          ],
        },
        startingMap: MapDef(
          id: '10.10.1',
          columnCount: 13,
          rowCount: 11,
          backgroundRect: Rect.fromLTWH(125.0, 44.0, 1481.0, 1411.0),
          starts: [
            (1, 10),
            (3, 10),
            (5, 10),
            (7, 10),
            (9, 10),
            (11, 10),
          ],
          terrain: {
            (1, 2): TerrainType.difficult,
            (1, 5): TerrainType.object,
            (2, 0): TerrainType.difficult,
            (2, 1): TerrainType.difficult,
            (2, 7): TerrainType.object,
            (3, 2): TerrainType.difficult,
            (4, 1): TerrainType.difficult,
            (4, 2): TerrainType.object,
            (5, 0): TerrainType.difficult,
            (5, 1): TerrainType.difficult,
            (5, 2): TerrainType.difficult,
            (6, 0): TerrainType.difficult,
            (6, 1): TerrainType.difficult,
            (6, 2): TerrainType.difficult,
            (6, 5): TerrainType.object,
            (7, 0): TerrainType.difficult,
            (7, 1): TerrainType.difficult,
            (7, 2): TerrainType.difficult,
            (8, 1): TerrainType.difficult,
            (9, 2): TerrainType.difficult,
            (9, 5): TerrainType.object,
            (10, 0): TerrainType.difficult,
            (10, 1): TerrainType.difficult,
            (10, 3): TerrainType.object,
            (11, 2): TerrainType.difficult,
            (11, 8): TerrainType.object,
          },
        ),
        adversaries: [
          EncounterFigureDef(
            name: 'Cleaving Xulc',
            health: 8,
            traits: [
              'Ignores the effects of water and xulc terrain.',
              '[React] After this unit is attacked within [Range] 1, it performs:\n\n[m_attack] | [Range] 1 | [DMG]2'
            ],
            affinities: {
              Ether.dim: 1,
            },
            spawnable: true,
          ),
          EncounterFigureDef(
            name: 'Armored Xulc',
            health: 6,
            defense: 2,
            traits: [
              'Ignores the effects of water and xulc terrain.',
              '[React] After this unit is attacked at [Range] 2 or greater, it performs:\n\n[POS] | [Range] 0 | [DEF] 1'
            ],
            affinities: {
              Ether.dim: 2,
            },
            spawnable: true,
          ),
          EncounterFigureDef(
            name: 'Flying Xulc',
            health: 6,
            flies: true,
            traits: [
              '[React] After this unit is attacked:\n\nLogic: Retreat\n[Dash] 3',
            ],
            affinities: {
              Ether.dim: 1,
            },
            spawnable: true,
          ),
          EncounterFigureDef(
            name: 'Monstrous Growth',
            alias: 'Nidus Cluster',
            health: 30,
          ),
          EncounterFigureDef(
            name: 'Colony',
            letter: 'A',
            health: 6,
            infected: true,
            traits: [
              'When this unit is slain, roll the Xulc dice twice.',
            ],
            affinities: {
              Ether.earth: 1,
              Ether.crux: 1,
              Ether.morph: -1,
              Ether.wind: -1,
            },
            onSlain: [
              rollXulcDie(title: 'Colony Slain: First Roll'),
              rollXulcDie(title: 'Colony Slain: Second Roll'),
            ],
          ),
          EncounterFigureDef(
            name: 'Regenerator',
            letter: 'B',
            health: 8,
            defense: 1,
            infected: true,
            traits: [
              'At the start of this unit\'s turn, it recovers [RCV] R.',
            ],
            affinities: {
              Ether.water: -1,
              Ether.crux: -1,
              Ether.fire: 1,
              Ether.morph: 1,
            },
          ),
          EncounterFigureDef(
            name: 'Hunter',
            letter: 'C',
            health: 10,
            infected: true,
            traits: [
              'When this unit is slain, if the result of the xulc dice is blank, reroll the dice.',
            ],
            affinities: {
              Ether.fire: -1,
              Ether.earth: -1,
              Ether.water: 1,
              Ether.wind: 1,
            },
            onSlain: [
              rollXulcDie(
                  body:
                      'When this unit is slain, if the result of the xulc dice is blank, reroll the dice.'),
            ],
          ),
          EncounterFigureDef(
            name: 'Prime Xulc Brood Matron',
            letter: 'D',
            type: AdversaryType.boss,
            large: true,
            traits: [
              'Immune to all damage and cannot be moved or teleported for any reason.',
            ],
            affinities: {
              Ether.dim: 2,
              Ether.water: 1,
              Ether.earth: 1,
            },
          ),
          EncounterFigureDef(
            name: 'Prime Xulc Dominator',
            letter: 'A',
            type: AdversaryType.boss,
            healthFormula: '40*R',
            large: true,
            traits: [
              'At the beginning of each round, roll an ether dice from the general pool and add it to this unit\'s statistic block.',
              'Whenever any unit rolls the damage dice, they treat results that match an ether dice on this unit\'s statistic block as [DIM] instead.',
            ],
            possibleTokens: EtherDieSide.values.map((e) => e.toJson()).toList(),
            affinities: {
              Ether.dim: 2,
              Ether.water: 1,
              Ether.earth: 1,
            },
            onDidStartRound: [
              rollEtherDie(
                  title: 'Prime Xulc Dominator',
                  body:
                      'Add the result to this unit\'s statistic block. Whenever any unit rolls the damage dice, they treat results that match an ether dice on this unit\'s statistic block as [DIM] instead.'),
            ],
            onDraw: {
              EtherDieSide.wind.toJson(): [
                addToken(EtherDieSide.wind.toJson()),
              ],
              EtherDieSide.crux.toJson(): [
                addToken(EtherDieSide.crux.toJson()),
              ],
              EtherDieSide.earth.toJson(): [
                addToken(EtherDieSide.earth.toJson()),
              ],
              EtherDieSide.fire.toJson(): [
                addToken(EtherDieSide.fire.toJson()),
              ],
              EtherDieSide.morph.toJson(): [
                addToken(EtherDieSide.morph.toJson()),
              ],
              EtherDieSide.water.toJson(): [
                addToken(EtherDieSide.water.toJson()),
              ],
            },
            onSlain: [
              milestone('_dominator_slain'),
            ],
          ),
          EncounterFigureDef(
            name: 'Prime Xulc Deliverer',
            letter: 'A',
            type: AdversaryType.boss,
            healthFormula: '30*R',
            defense: 1,
            large: true,
            traits: [
              'After this unit suffers 2 or more damage from any one source: Roll the Xulc dice and spawn the result within [Range] 1 of this unit.',
            ],
            affinities: {
              Ether.dim: 2,
              Ether.water: 1,
              Ether.earth: 1,
            },
            onSlain: [
              milestone('_victory'),
            ],
          ),
        ],
        placements: [
          PlacementDef(
            name: 'Monstrous Growth',
            alias: 'Nidus Cluster [A]',
            c: 4,
            r: 0,
            fixedTokens: ['A'],
            onDidStartRound: [
              rollXulcDie(
                  title: 'Nidus Cluster [A]',
                  body:
                      'Spawn the result within [Range] 1 of this cluster. If the result of the dice is blank, reroll the dice once, keeping the second result.',
                  condition: RoundCondition(2)),
              rollXulcDie(
                  title: 'Nidus Cluster [A]',
                  body:
                      'Spawn the result within [Range] 1 of this cluster. If the result of the dice is blank, reroll the dice once, keeping the second result.',
                  condition: RoundCondition(4)),
              rollXulcDie(
                  title: 'Nidus Cluster [A]',
                  body:
                      'Spawn the result within [Range] 1 of this cluster. If the result of the dice is blank, reroll the dice once, keeping the second result.',
                  condition: RoundCondition(6)),
            ],
            onSlain: [
              milestone('_all_nidus_slain',
                  condition:
                      IsSlainCondition('Monstrous Growth', countFormula: 'R')),
            ],
          ),
          PlacementDef(
            name: 'Monstrous Growth',
            alias: 'Nidus Cluster [B]',
            c: 8,
            r: 0,
            fixedTokens: ['B'],
            onDidStartRound: [
              rollXulcDie(
                  title: 'Nidus Cluster [B]',
                  body:
                      'Spawn the result within [Range] 1 of this cluster. If the result of the dice is blank, reroll the dice once, keeping the second result.',
                  condition: RoundCondition(2)),
              rollXulcDie(
                  title: 'Nidus Cluster [B]',
                  body:
                      'Spawn the result within [Range] 1 of this cluster. If the result of the dice is blank, reroll the dice once, keeping the second result.',
                  condition: RoundCondition(4)),
              rollXulcDie(
                  title: 'Nidus Cluster [B]',
                  body:
                      'Spawn the result within [Range] 1 of this cluster. If the result of the dice is blank, reroll the dice once, keeping the second result.',
                  condition: RoundCondition(6)),
            ],
            onSlain: [
              milestone('_all_nidus_slain',
                  condition:
                      IsSlainCondition('Monstrous Growth', countFormula: 'R')),
            ],
          ),
          PlacementDef(
            name: 'Monstrous Growth',
            alias: 'Nidus Cluster [C]',
            c: 1,
            r: 1,
            minPlayers: 3,
            fixedTokens: ['C'],
            onDidStartRound: [
              rollXulcDie(
                  title: 'Nidus Cluster [C]',
                  body:
                      'Spawn the result within [Range] 1 of this cluster. If the result of the dice is blank, reroll the dice once, keeping the second result.',
                  condition: RoundCondition(2)),
              rollXulcDie(
                  title: 'Nidus Cluster [C]',
                  body:
                      'Spawn the result within [Range] 1 of this cluster. If the result of the dice is blank, reroll the dice once, keeping the second result.',
                  condition: RoundCondition(4)),
              rollXulcDie(
                  title: 'Nidus Cluster [C]',
                  body:
                      'Spawn the result within [Range] 1 of this cluster. If the result of the dice is blank, reroll the dice once, keeping the second result.',
                  condition: RoundCondition(6)),
            ],
            onSlain: [
              milestone('_all_nidus_slain',
                  condition:
                      IsSlainCondition('Monstrous Growth', countFormula: 'R')),
            ],
          ),
          PlacementDef(
            name: 'Monstrous Growth',
            alias: 'Nidus Cluster [D]',
            c: 11,
            r: 1,
            minPlayers: 4,
            fixedTokens: ['D'],
            onDidStartRound: [
              rollXulcDie(
                  title: 'Nidus Cluster [D]',
                  body:
                      'Spawn the result within [Range] 1 of this cluster. If the result of the dice is blank, reroll the dice once, keeping the second result.',
                  condition: RoundCondition(2)),
              rollXulcDie(
                  title: 'Nidus Cluster [D]',
                  body:
                      'Spawn the result within [Range] 1 of this cluster. If the result of the dice is blank, reroll the dice once, keeping the second result.',
                  condition: RoundCondition(4)),
              rollXulcDie(
                  title: 'Nidus Cluster [D]',
                  body:
                      'Spawn the result within [Range] 1 of this cluster. If the result of the dice is blank, reroll the dice once, keeping the second result.',
                  condition: RoundCondition(6)),
            ],
            onSlain: [
              milestone('_all_nidus_slain',
                  condition:
                      IsSlainCondition('Monstrous Growth', countFormula: 'R')),
            ],
          ),
          PlacementDef(name: 'Colony', c: 0, r: 3),
          PlacementDef(name: 'Colony', c: 4, r: 3, minPlayers: 4),
          PlacementDef(name: 'Colony', c: 8, r: 2),
          PlacementDef(name: 'Regenerator', c: 6, r: 4),
          PlacementDef(name: 'Regenerator', c: 10, r: 5, minPlayers: 4),
          PlacementDef(name: 'Regenerator', c: 12, r: 2, minPlayers: 4),
          PlacementDef(name: 'Hunter', c: 2, r: 5, minPlayers: 3),
          PlacementDef(name: 'Hunter', c: 11, r: 4),
          PlacementDef(name: 'Prime Xulc Brood Matron', c: 6, r: 0),
          PlacementDef(
              name: 'Pod', type: PlacementType.trap, c: 2, r: 2, trapDamage: 3),
          PlacementDef(
              name: 'Pod', type: PlacementType.trap, c: 5, r: 8, trapDamage: 3),
          PlacementDef(
              name: 'Pod', type: PlacementType.trap, c: 9, r: 4, trapDamage: 3),
        ],
        placementGroups: [
          PlacementGroupDef(
            name: 'Phase 2',
            setup: EncounterSetup(
                box: 'XU-2', map: '18', adversary: '28', tiles: '3x Pod Traps'),
            map: MapDef(
              id: '10.10.2',
              columnCount: 13,
              rowCount: 11,
              backgroundRect: Rect.fromLTWH(110.0, 44.0, 1481.0, 1411.0),
              starts: [
                (0, 6),
                (0, 8),
                (1, 10),
                (11, 10),
                (12, 6),
                (12, 8),
              ],
              terrain: {
                (1, 5): TerrainType.object,
                (2, 9): TerrainType.difficult,
                (3, 0): TerrainType.difficult,
                (3, 9): TerrainType.difficult,
                (3, 10): TerrainType.difficult,
                (4, 2): TerrainType.object,
                (4, 8): TerrainType.difficult,
                (4, 9): TerrainType.difficult,
                (5, 0): TerrainType.difficult,
                (5, 8): TerrainType.difficult,
                (5, 9): TerrainType.object,
                (5, 10): TerrainType.difficult,
                (7, 9): TerrainType.object,
                (7, 10): TerrainType.difficult,
                (8, 0): TerrainType.difficult,
                (8, 8): TerrainType.difficult,
                (8, 9): TerrainType.difficult,
                (9, 0): TerrainType.difficult,
                (9, 5): TerrainType.object,
                (9, 9): TerrainType.difficult,
                (9, 10): TerrainType.difficult,
                (10, 0): TerrainType.difficult,
                (11, 2): TerrainType.object,
                (11, 8): TerrainType.object,
              },
            ),
            placements: [
              PlacementDef(name: 'Prime Xulc Dominator', c: 6, r: 5),
              PlacementDef(
                  name: 'Pod',
                  type: PlacementType.trap,
                  c: 3,
                  r: 7,
                  trapDamage: 3),
              PlacementDef(
                  name: 'Pod',
                  type: PlacementType.trap,
                  c: 6,
                  r: 9,
                  trapDamage: 3),
              PlacementDef(
                  name: 'Pod',
                  type: PlacementType.trap,
                  c: 10,
                  r: 6,
                  trapDamage: 3),
            ],
          ),
          PlacementGroupDef(
            name: 'Phase 3',
            setup: EncounterSetup(box: 'XU-2', map: '19', adversary: '29'),
            map: MapDef(
              id: '10.10.3',
              columnCount: 13,
              rowCount: 11,
              backgroundRect: Rect.fromLTWH(125.0, 44.0, 1481.0, 1411.0),
              starts: [
                (0, 6),
                (2, 7),
                (4, 8),
                (8, 8),
                (10, 7),
                (12, 6),
              ],
              terrain: {
                (0, 0): TerrainType.difficult,
                (0, 1): TerrainType.difficult,
                (1, 0): TerrainType.difficult,
                (1, 1): TerrainType.difficult,
                (1, 2): TerrainType.difficult,
                (2, 0): TerrainType.difficult,
                (2, 1): TerrainType.difficult,
                (2, 6): TerrainType.difficult,
                (3, 0): TerrainType.barrier,
                (3, 1): TerrainType.difficult,
                (3, 2): TerrainType.difficult,
                (3, 9): TerrainType.object,
                (4, 0): TerrainType.difficult,
                (4, 1): TerrainType.object,
                (4, 6): TerrainType.difficult,
                (5, 0): TerrainType.difficult,
                (5, 1): TerrainType.difficult,
                (5, 2): TerrainType.difficult,
                (6, 0): TerrainType.difficult,
                (6, 1): TerrainType.difficult,
                (7, 0): TerrainType.difficult,
                (7, 1): TerrainType.difficult,
                (7, 2): TerrainType.difficult,
                (7, 8): TerrainType.difficult,
                (8, 0): TerrainType.difficult,
                (8, 1): TerrainType.difficult,
                (8, 7): TerrainType.difficult,
                (9, 0): TerrainType.difficult,
                (9, 1): TerrainType.difficult,
                (9, 2): TerrainType.object,
                (9, 8): TerrainType.difficult,
                (10, 0): TerrainType.difficult,
                (10, 1): TerrainType.difficult,
                (10, 9): TerrainType.object,
                (11, 0): TerrainType.difficult,
                (11, 1): TerrainType.difficult,
                (11, 2): TerrainType.difficult,
                (12, 0): TerrainType.barrier,
                (12, 1): TerrainType.difficult,
              },
            ),
            placements: [
              PlacementDef(name: 'Prime Xulc Deliverer', c: 6, r: 3),
            ],
          ),
        ],
      );
}
