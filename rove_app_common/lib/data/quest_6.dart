import 'dart:ui';
import 'package:rove_app_common/data/encounter_def_utils.dart';
import 'package:rove_data_types/rove_data_types.dart';

extension Quest6 on EncounterDef {
  static EncounterDef get encounter6dot1 => EncounterDef(
        questId: '6',
        number: '1',
        title: 'Into that Darkness Peering',
        victoryDescription: 'Slay Hokmala.',
        roundLimit: 8,
        baseLystReward: 20,
        campaignLink:
            '''Encounter 6.2 - “**Atmosphere of Sorrow**”, [campaign] **88**.''',
        challenges: [
          'While the Corrupted Nektari Hive is on the map, at the start of each adversary phase, spawn R corrupted nektari swarms within [Range] 1 of it.',
          'Dekahas gain +2 [DEF].',
          'Terranapes always gain the benefit of their [HP] threshold augments.',
        ],
        dialogs: [
          EncounterDialogDef(
              title: 'Introduction',
              body:
                  '''Less “bubbling” and more “gurgling” are the sounds of the nearby stream, if it can still be called that. Its water heavy and black—the entire surface rendered completely opaque. Mo, Makaal, and Grandpaw have taken up the march at the rear at what they hope will be a safe distance. One of the aimless nektari has drifted close enough to Mo for them to capture with one of their tendrils. Uncharacteristically, its first response is one of physical violence, rather than the traditional response of spore-casting. After being released in surprise the entoman returns to its haphazard flight through the trees. “Morph,” Mo begins. “The creature was practically bursting with Morphic ether.”

By now the literal buzzing of their hives can be heard clearly, which means it’s time for the merchants to find safety as your survey begins in earnest. Normally a region home to tihfur clans would have regular patrols and wildlife-culling before overgrowth could create a dangerous environment. The level of neglect here speaks to years of deterioration, which makes absolutely no sense. It’s been days; weeks at worst.

Before you and Silky can get lost in a debate about the reason for the shocking amount of regrowth, an entire copse of rotten trees wrenches itself from the ground and moves along the brackish stream, stealing your attention entirely. A grovetender, though its countenance is entirely wrong. Grovetenders are silvans that style themselves as carnivorous predators in an effort to protect the pollinators that keep their bodies healthy and promote reproduction. This behemoth specimen looks neither healthy nor much like a silvan any longer. 

With each quaking step it takes, the other silvans react in tandem. Slow undulations become frantic writhing as the grovetender ambles and draws forth more polluted water into itself. The pale weeds also seem to bear only a faint resemblance to thriving dekaha. It feels as if the entire grove has fallen to some strange delirium. When you draw too close to one of the larger trees, the dekaha’s natural sensations finally discover your existence. Their vines arc and prime to defend their territory. Simultaneously the massive grovetender begins crashing its way through dying trees towards you.

Were the scene not so morbid, it would be almost quaint. This is exactly the kind of task you were trained for as Rovers.'''),
        ],
        onLoad: [
          dialog('Introduction'),
          codexLink('Dipped in Folly',
              number: 100,
              body:
                  '''If the Corrupted Nektari Hive is destroyed, read [title] [codex] 50.'''),
          codexLink('All The Night Tide',
              number: 101,
              body:
                  '''Immediately when Hokmala is slain, read [title] [codex] 50.'''),
        ],
        startingMap: MapDef(
          id: '6.1',
          columnCount: 13,
          rowCount: 11,
          backgroundRect: Rect.fromLTWH(110.0, 44.0, 1481.0, 1411.0),
          starts: [
            (0, 0),
            (0, 1),
            (1, 0),
            (1, 1),
            (2, 0),
          ],
          terrain: {
            (0, 2): TerrainType.barrier,
            (0, 3): TerrainType.barrier,
            (0, 4): TerrainType.barrier,
            (0, 5): TerrainType.barrier,
            (0, 6): TerrainType.difficult,
            (1, 3): TerrainType.barrier,
            (1, 4): TerrainType.barrier,
            (1, 5): TerrainType.barrier,
            (1, 6): TerrainType.dangerous,
            (1, 9): TerrainType.object,
            (2, 3): TerrainType.barrier,
            (2, 4): TerrainType.barrier,
            (2, 5): TerrainType.difficult,
            (2, 8): TerrainType.object,
            (3, 0): TerrainType.barrier,
            (3, 1): TerrainType.barrier,
            (4, 0): TerrainType.barrier,
            (4, 1): TerrainType.dangerous,
            (4, 8): TerrainType.difficult,
            (5, 0): TerrainType.barrier,
            (5, 1): TerrainType.barrier,
            (5, 7): TerrainType.difficult,
            (5, 8): TerrainType.openAir,
            (6, 0): TerrainType.barrier,
            (6, 1): TerrainType.difficult,
            (6, 6): TerrainType.difficult,
            (6, 7): TerrainType.openAir,
            (6, 8): TerrainType.dangerous,
            (7, 7): TerrainType.openAir,
            (7, 8): TerrainType.dangerous,
            (7, 10): TerrainType.dangerous,
            (8, 7): TerrainType.openAir,
            (9, 1): TerrainType.object,
            (9, 4): TerrainType.difficult,
            (9, 5): TerrainType.openAir,
            (9, 10): TerrainType.openAir,
            (10, 3): TerrainType.difficult,
            (10, 4): TerrainType.openAir,
            (10, 9): TerrainType.openAir,
            (11, 3): TerrainType.object,
            (11, 4): TerrainType.openAir,
            (11, 5): TerrainType.dangerous,
            (11, 9): TerrainType.openAir,
            (11, 10): TerrainType.openAir,
            (12, 3): TerrainType.openAir,
            (12, 4): TerrainType.dangerous,
            (12, 7): TerrainType.dangerous,
            (12, 8): TerrainType.openAir,
            (12, 9): TerrainType.openAir,
          },
        ),
        overlays: [
          EncounterFigureDef(
              name: 'Nektari Hive',
              alias: 'Corrupted Nektari Hive',
              healthFormula: '2*R',
              onSlain: [
                codexN(100),
                lyst('5*R'),
                item('Scour Ichor',
                    body:
                        'The Rover that destroyed the Corrupted Nektari Hive gains one “Scour Ichor” item.  They may equip this item.  If they don’t have the required item slot(s) available, they may unequip items as needed.'),
                placementGroup('Nektari',
                    body:
                        'Spawn R corrupted nektari swarms within [Range] 0-1 of the destroyed hive.'),
              ]),
        ],
        adversaries: [
          EncounterFigureDef(
            name: 'Briarwog',
            letter: 'A',
            health: 8,
            traits: [
              '''[React] After this unit is attacked from within [Range] 1:
              
The attacker suffers [DMG]1.''',
            ],
            affinities: {
              Ether.earth: -1,
              Ether.fire: -1,
              Ether.water: 1,
              Ether.morph: 1,
            },
          ),
          EncounterFigureDef(
            name: 'Dekaha',
            letter: 'B',
            health: 8,
            immuneToForcedMovement: true,
            traits: [
              'Immune to enemy forced movement. (Can be moved or teleported by Hokmala.)',
            ],
            affinities: {
              Ether.fire: -2,
              Ether.wind: -1,
              Ether.earth: 1,
              Ether.water: 2,
            },
          ),
          EncounterFigureDef(
            letter: 'C',
            name: 'Terranape',
            health: 20,
            traits: [
              'At the start of this unit\'s turn, it recovers [RCV] R+1.',
            ],
            affinities: {
              Ether.fire: -2,
              Ether.water: 2,
              Ether.earth: 2,
              Ether.wind: -1,
              Ether.morph: 1,
            },
          ),
          EncounterFigureDef(
            name: 'Hokmala',
            letter: 'D',
            type: AdversaryType.miniboss,
            healthFormula: '14*R',
            defenseFormula: 'X',
            xDefinition: 'count_adversary(Dekaha)',
            traits: [
              'This unit has [DEF] X, where X equals the number of Dekaha on the map.',
            ],
            affinities: {
              Ether.fire: -1,
              Ether.water: 2,
              Ether.earth: 2,
              Ether.crux: -1,
            },
          ),
          EncounterFigureDef(
            name: 'Corrupted Nektari Swarm',
            health: 1,
            flies: true,
            traits: [
              'This unit is immune to damage from attack actions when it is within [Range] 1 of a [miasma].',
            ],
            affinities: {
              Ether.crux: -2,
              Ether.water: -1,
              Ether.wind: 1,
              Ether.morph: 2,
            },
          ),
        ],
        placements: [
          PlacementDef(name: 'Briarwog', c: 9, r: 4),
          PlacementDef(name: 'Briarwog', c: 7, r: 3, minPlayers: 3),
          PlacementDef(name: 'Briarwog', c: 7, r: 5, minPlayers: 3),
          PlacementDef(name: 'Briarwog', c: 5, r: 7),
          PlacementDef(name: 'Briarwog', c: 4, r: 5, minPlayers: 3),
          PlacementDef(name: 'Dekaha', c: 2, r: 5),
          PlacementDef(name: 'Dekaha', c: 6, r: 1),
          PlacementDef(name: 'Dekaha', c: 11, r: 7, minPlayers: 4),
          PlacementDef(name: 'Dekaha', c: 9, r: 8, minPlayers: 3),
          PlacementDef(name: 'Terranape', c: 5, r: 4),
          PlacementDef(name: 'Terranape', c: 0, r: 9, minPlayers: 4),
          PlacementDef(name: 'Hokmala', c: 10, r: 7, onSlain: [
            codexN(101),
            victory(),
          ]),
          PlacementDef(
            name: 'Nektari Hive',
            type: PlacementType.object,
            c: 2,
            r: 8,
          ),
          PlacementDef(
              name: 'Hatchery',
              type: PlacementType.trap,
              c: 10,
              r: 0,
              trapDamage: 3),
          PlacementDef(
              name: 'Hatchery',
              type: PlacementType.trap,
              c: 4,
              r: 7,
              trapDamage: 3),
          PlacementDef(
              name: 'Hatchery',
              type: PlacementType.trap,
              c: 10,
              r: 5,
              trapDamage: 3),
        ],
        placementGroups: [
          PlacementGroupDef(
            name: 'Nektari',
            placements: [
              PlacementDef(name: 'Corrupted Nektari Swarm', c: 2, r: 8),
              PlacementDef(name: 'Corrupted Nektari Swarm', c: 2, r: 8),
              PlacementDef(
                  name: 'Corrupted Nektari Swarm', c: 2, r: 8, minPlayers: 3),
              PlacementDef(
                  name: 'Corrupted Nektari Swarm', c: 2, r: 8, minPlayers: 4)
            ],
          ),
        ],
      );

  static EncounterDef get encounter6dot2 => EncounterDef(
        questId: '6',
        number: '2',
        title: 'Atmosphere of Sorrow',
        victoryDescription: 'Slay all adversaries.',
        extraPhase: 'The Yanshif',
        extraPhaseIndex: 2,
        roundLimit: 8,
        baseLystReward: 15,
        unlocksRoverLevel: 6,
        campaignLink:
            '''Encounter 6.3 - “**Like A Shattered Mirror**”, [campaign] **90**.''',
        challenges: [
          'Zeepurah will always attack Rovers if they are within range of her attacks.',
          'Treat kifa as occupying a [windscreen].  This is a permanent effect.',
          'At the end of each round, Rovers must flip one ether dice in either their personal or infusion pool to its [Morph] face.',
        ],
        dialogs: [
          EncounterDialogDef(
              title: 'Introduction',
              body: '''**“HE’LL MAKE YOU ANYTHING YOU WISH TO BE!”**

A crowd of tihfur stalk their way through the trees of the grove. Some laugh, others dance, and a few even try to sing. The words are choking and halted; their throats caught between their avian shifting. Most of them are focused on a woman towards the far end of the settlement. She screeches and swings violently at any who draw close.

This lone villager seems worse off than the notably twisted members of her faction attempting to surround her. Her wiry frame is corded in broken feathers and stretches of oozing hide where the shifting seems to have gone awry. Her left side is covered in skin-carvings that pulse with potent Morph ether. The muscles writhe and are unable to fully settle on one side of her shift or the other. With each pulse of her heart the blanket of miasma flowing through the forest roils —spreading further.

A few of the tihfur leaping through the trees make a point of letting the ether wash over their bodies. Each one takes a manic delight as it causes their entire body to twitch unnaturally. Mouths peeled back in ecstasy, wings fluttering in joy, talons ripping at their feathers in a daze. All of it a disturbing scene to say the least. This is nothing like the more primal rituals that tihfur clans engage in; this is simply madness given physical shape.

“String me up to bleed,” Silky curses. “Is this what has become of the Yanshif clan? How in the world could things have grown so dire so quickly?!”

His utterance kills the jubilations of the crowd of monstrous tihfur instantly. Besides the frantic woman at the outer reach, every last member (regardless of where they stood or perched) slowly turns to face you in unison. Every trio of eyes is on you. Each visage on display is curled in visible disgust.

**“A MYSTERY OF MYSTERIES!” “FRESH MEAT!” “PLUCK AND STRIP!” “THEIR BODIES SING!”**

A cacophony of squawking cries and jeers explode through the clearing. Their emotional outbursts fill the air as they descend upon you. Even the wildlife seems caught up in their temper as malformed streaks, kifa, and even a premature rakifa demolish the branches of trees to join the fray. This spread of Morph is pressing the entire forest into rapid and distorted development at the cost of its natural vitality.''')
        ],
        onLoad: [
          dialog('Introduction'),
          rules('The Yanshif',
              '''Zeepurah has been consumed by corrupting hatred.  She is feral, attacking all creatures she perceives as enemies, including you, but all may not be lost.  Zeepurah is part of her own faction, The Yanshif, which is an enemy to both the Rover and Adversary factions.  Units a part of the Yanshif faction follow all the adversary logic rules found on page X in the rule book.  This faction gains priority after the Adversary faction has gone.

You may be able to save Zeepurah from the corruption.  The encounter is over when all adversaries are slain.  If Zeepurah is the last remaining enemy on the map, the encounter will end and she will still be alive.  You may want to pursue this effort, though it will be challenging.

Though Zeepurah is indeed your enemy, you can still target her with positive effects, such as healing actions.'''),
          codexLink('Dipped in Folly',
              number: 100,
              body:
                  '''Each time a Corrupted Nektari Hive is destroyed, read [title] [codex] 50.'''),
          codexLink('Into the Sepulchre',
              number: 102,
              body: '''If Zeepurah is slain, read [title] [codex] 50.'''),
          codexLink('Eulalie',
              number: 103,
              body:
                  '''At the end of the round where all adversaries are slain, read [title] [codex] 51.'''),
        ],
        onWillEndRound: [
          milestone('_victory',
              condition: AllAdversariesSlainExceptCondition('Zeepurah'))
        ],
        onMilestone: {
          '_victory': [
            victory(),
            codexN(104,
                condition: MilestoneCondition(
                    CampaignMilestone.milestone6ZeepurahSlain)),
            codexN(105,
                condition: MilestoneCondition(
                    CampaignMilestone.milestone6ZeepurahSlain,
                    value: false)),
          ]
        },
        startingMap: MapDef(
          id: '6.2',
          columnCount: 13,
          rowCount: 11,
          backgroundRect: Rect.fromLTWH(110.0, 44.0, 1481.0, 1411.0),
          starts: [
            (0, 8),
            (0, 9),
            (1, 9),
            (1, 10),
            (2, 9),
          ],
          terrain: {
            (0, 0): TerrainType.object,
            (0, 1): TerrainType.difficult,
            (0, 5): TerrainType.barrier,
            (0, 6): TerrainType.barrier,
            (0, 7): TerrainType.dangerous,
            (1, 1): TerrainType.object,
            (1, 2): TerrainType.barrier,
            (1, 6): TerrainType.barrier,
            (2, 1): TerrainType.barrier,
            (2, 2): TerrainType.barrier,
            (3, 6): TerrainType.dangerous,
            (3, 10): TerrainType.dangerous,
            (4, 0): TerrainType.difficult,
            (4, 4): TerrainType.object,
            (4, 6): TerrainType.dangerous,
            (4, 8): TerrainType.barrier,
            (5, 0): TerrainType.difficult,
            (5, 8): TerrainType.barrier,
            (5, 9): TerrainType.barrier,
            (7, 0): TerrainType.barrier,
            (7, 1): TerrainType.barrier,
            (8, 0): TerrainType.barrier,
            (8, 3): TerrainType.dangerous,
            (8, 5): TerrainType.dangerous,
            (9, 6): TerrainType.dangerous,
            (9, 9): TerrainType.barrier,
            (9, 10): TerrainType.barrier,
            (10, 0): TerrainType.difficult,
            (10, 9): TerrainType.barrier,
            (11, 0): TerrainType.difficult,
            (11, 4): TerrainType.barrier,
            (11, 9): TerrainType.object,
            (11, 10): TerrainType.object,
            (12, 1): TerrainType.difficult,
            (12, 2): TerrainType.difficult,
            (12, 3): TerrainType.barrier,
            (12, 4): TerrainType.barrier,
          },
        ),
        overlays: [
          EncounterFigureDef(
              name: 'Nektari Hive',
              alias: 'Corrupted Nektari Hive',
              healthFormula: '2*R',
              onSlain: [
                codexN(100),
                lyst('5*R'),
                item('Scour Ichor',
                    body:
                        'The Rover that destroyed the Corrupted Nektari Hive gains one “Scour Ichor” item.  They may equip this item.  If they don’t have the required item slot(s) available, they may unequip items as needed.'),
                placementGroup('Nektari',
                    body:
                        'Spawn R corrupted nektari swarms within [Range] 0-1 of the destroyed hive.'),
              ]),
        ],
        adversaries: [
          EncounterFigureDef(
            name: 'Kifa',
            letter: 'A',
            health: 7,
            flies: true,
            affinities: {
              Ether.fire: -1,
              Ether.water: -1,
              Ether.wind: 1,
              Ether.earth: 1,
            },
          ),
          EncounterFigureDef(
            name: 'Nahoot',
            letter: 'B',
            health: 15,
            traits: [
              'If a Rover slays this unit, that Rover [plus_wind_morph].',
            ],
            affinities: {
              Ether.crux: -1,
              Ether.wind: 1,
              Ether.morph: 2,
            },
            onSlain: [
              ether([Ether.wind, Ether.morph]),
            ],
          ),
          EncounterFigureDef(
            name: 'Nahadir',
            letter: 'C',
            health: 15,
            flies: true,
            traits: [
              ' This unit gains [DEF] 1 against attacks by Rovers that have a [Morph] dice in their personal or infusion pools.',
            ],
            affinities: {
              Ether.crux: -1,
              Ether.water: 1,
              Ether.morph: 2,
            },
          ),
          EncounterFigureDef(
            name: 'Rakifa',
            letter: 'D',
            type: AdversaryType.miniboss,
            healthFormula: '12*R',
            affinities: {
              Ether.fire: -1,
              Ether.water: -1,
              Ether.wind: 1,
              Ether.earth: 2,
            },
          ),
          EncounterFigureDef(
            name: 'Zeepurah',
            letter: 'E',
            type: AdversaryType.miniboss,
            faction: 'The Yanshif',
            healthFormula: '8+2*R',
            flies: true,
            affinities: {
              Ether.wind: -1,
              Ether.fire: -1,
              Ether.morph: 2,
              Ether.water: 2,
            },
          ),
          EncounterFigureDef(
            name: 'Corrupted Nektari Swarm',
            letter: 'F',
            health: 1,
            flies: true,
            traits: [
              'This unit is immune to damage from attack actions when it is within [Range] 1 of a [miasma].',
            ],
            affinities: {
              Ether.crux: -2,
              Ether.water: -1,
              Ether.wind: 1,
              Ether.morph: 2,
            },
          ),
        ],
        placements: [
          PlacementDef(name: 'Kifa', c: 6, r: 1),
          PlacementDef(name: 'Kifa', c: 6, r: 5),
          PlacementDef(name: 'Kifa', c: 6, r: 6),
          PlacementDef(name: 'Kifa', c: 10, r: 6),
          PlacementDef(name: 'Kifa', c: 3, r: 0, minPlayers: 4),
          PlacementDef(name: 'Kifa', c: 10, r: 8, minPlayers: 3),
          PlacementDef(name: 'Nahoot', c: 6, r: 8),
          PlacementDef(name: 'Nahoot', c: 0, r: 2, minPlayers: 3),
          PlacementDef(name: 'Nahadir', c: 3, r: 4),
          PlacementDef(name: 'Nahadir', c: 7, r: 10, minPlayers: 4),
          PlacementDef(name: 'Rakifa', c: 9, r: 3),
          PlacementDef(
            name: 'Zeepurah',
            c: 11,
            r: 1,
            onSlain: [
              codexN(102),
              milestone(CampaignMilestone.milestone6ZeepurahSlain,
                  title: 'Zeepurah Death'),
            ],
          ),
          PlacementDef(
              name: 'Nektari Hive', type: PlacementType.object, c: 1, r: 1),
          PlacementDef(
              name: 'Nektari Hive', type: PlacementType.object, c: 11, r: 9),
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
              r: 0,
              trapDamage: 3),
          PlacementDef(
              name: 'Hatchery',
              type: PlacementType.trap,
              c: 11,
              r: 5,
              trapDamage: 3),
          PlacementDef(
              name: 'Hatchery',
              type: PlacementType.trap,
              c: 8,
              r: 9,
              trapDamage: 3),
          PlacementDef(name: 'morph', type: PlacementType.ether, c: 0, r: 0),
          PlacementDef(name: 'morph', type: PlacementType.ether, c: 11, r: 10),
          PlacementDef(name: 'wind', type: PlacementType.ether, c: 4, r: 4),
        ],
        placementGroups: [
          PlacementGroupDef(
            name: 'Nektari',
            placements: [
              PlacementDef(name: 'Corrupted Nektari Swarm'),
              PlacementDef(name: 'Corrupted Nektari Swarm'),
              PlacementDef(name: 'Corrupted Nektari Swarm', minPlayers: 3),
              PlacementDef(name: 'Corrupted Nektari Swarm', minPlayers: 4)
            ],
          ),
        ],
      );
  static EncounterDef get encounter6dot3 => EncounterDef(
        questId: '6',
        number: '3',
        title: 'Like a Shattered Mirror',
        victoryDescription:
            'Search Taharik for relics that contain deep memories and return to a [start] space.',
        roundLimit: 8,
        extraPhase: 'The Yanshif',
        extraPhaseIndex: 2,
        baseLystReward: 20,
        campaignLink:
            '''Encounter 6.4 - “**The Pitiless Wave**”, [campaign] **94**.''',
        challenges: [
          'Remove the hoard tile from the rubble closest to the starting spaces.  The Haunt has taken something of value. When it is slain, follow the **Lost Memories** special rule.',
          'If there are 2 Rovers, the round limit is 7.  If there are 3 or 4 Rovers, the round limit is 6.  This changes the trigger event for the codex link ”**Can Ever Dissever My Soul**”.',
          'Adversaries that attack an enemy occupying a [miasma] gain +1 [DMG] to that attack.',
        ],
        trackerEvents: [
          EncounterTrackerEventDef(
              title:
                  'Mark if during round 8 all Rovers end the Rover phase on an entrance space without having collected all three relics.',
              recordMilestone: '_search_failed'),
          EncounterTrackerEventDef(
              title:
                  'Mark if all Rovers end any Rover phase on an entrance space with all three relics collected.',
              recordMilestone: '_search_succeeded')
        ],
        onLoad: [
          dialog('Introduction'),
          rules('Zeepurah Slain',
              '''Check your campaign log, if “Zeepurah was slain.” is recorded, do not set up Zeepurah at the beginning of the encounter and The Yanshif special rule is not active.''',
              condition: MilestoneCondition(
                  CampaignMilestone.milestone6ZeepurahSlain)),
          remove('Zeepurah',
              condition:
                  MilestoneCondition(CampaignMilestone.milestone6ZeepurahSlain),
              silent: true),
          rules(
              'The Yanshif',
              '''Zeepurah has been consumed by corrupting hatred.  She is feral, attacking all creatures she perceives as enemies, including you, but all may not be lost.  

Zeepurah is part of her own faction, The Yanshif, which is an enemy to both the Rover and Adversary factions.  Units a part of the Yanshif faction follow all the adversary logic rules found on page X in the rule book.  This faction gains priority after the Adversary faction has gone.

Though Zeepurah is indeed your enemy, you can still target her with positive effects, such as healing actions.

You may be able to save Zeepurah from the corruption in a later encounter if you’re able to find all three relics.''',
              condition: MilestoneCondition(
                  CampaignMilestone.milestone6ZeepurahSlain,
                  value: false)),
          rules('Lost Memories',
              '''The hoard tiles represent the remnants of the Yanshif people. To loot these hoard tiles, a Rover has to end their turn on the hoard tile.

The contents of hoard tiles are randomly determined.  To do this, at the beginning of the encounter stack one copy of [wildfire], [snapfrost], [everbloom], [windscreen], [aura], and [miasma] tiles. When a hoard tile is looted, remove the top tile of this stack and reference the Codex Links, reading the link with the icon of the ether field tile removed.'''),
          rules('Consumed by Corruption',
              '''Taharik has been lost to the Ahma’s corruption. There are six ether icons on the bottom edge of the map.  These icons represent possible spawn locations throughout the encounter.

When an adversary is slain, place it off to the side of the map on its side.  During the start phase, for each adversary that is both off to the side and flipped vertically, roll an ether dice from the general pool, then spawn that adversary at the space with the ether icon corresponding to the result that was just rolled.  Then, for each adversary that is both off to the side and placed on its side, flip them vertically.'''),
          codexLink('Grains of the Golden Sand',
              number: 106,
              body: '''If the haunt is slain, read [title], [codex] 52.'''),
          codexLink('While I Weep',
              number: 107,
              body: '''If [wildfire] was removed, read [title], [codex] 52.'''),
          codexLink('How They Creep',
              number: 108,
              body:
                  '''If [snapfrost] was removed, read [title], [codex] 52.'''),
          codexLink('To The Deep',
              number: 109,
              body:
                  '''If [everbloom] was removed, read [title], [codex] 52.'''),
          codexLink('A Tighter Clasp',
              number: 110,
              body:
                  '''If [windscreen] was removed, read [title], [codex] 52.'''),
          codexLink('Binds Me Still',
              number: 111,
              body: '''If [aura] was removed, read [title], [codex] 52.'''),
          codexLink('Of Good And Ill',
              number: 112,
              body: '''If [miasma] was removed, read [title], [codex] 53.'''),
          codexLink('The Stars Never Rise',
              number: 113,
              body: '''If Zeepurah is slain, read [title], [codex] 53.''',
              condition: MilestoneCondition(
                  CampaignMilestone.milestone6ZeepurahSlain,
                  value: false)),
          codexLink('Can Ever Dissever My Soul',
              number: 114,
              body:
                  '''If during round 8 all Rovers end the Rover phase on an entrance space without having collected all three relics, read [title] [codex] 53.'''),
          codexLink('Feel the Bright Eyes',
              number: 115,
              body:
                  '''If all Rovers end any Rover phase on an entrance space with all three relics collected, read [title] [codex] 54.'''),
        ],
        onDraw: {
          EtherField.wildfire.toJson(): [
            codexN(107),
            milestone(CampaignMilestone.milestone6dot3Hopeful),
            function('tally_relics'),
          ],
          EtherField.snapfrost.toJson(): [
            codexN(108),
          ],
          EtherField.everbloom.toJson(): [
            codexN(109),
            milestone(CampaignMilestone.milestone6dot3Enduring),
            function('tally_relics'),
          ],
          EtherField.windscreen.toJson(): [
            codexN(110),
          ],
          EtherField.aura.toJson(): [
            codexN(111),
          ],
          EtherField.miasma.toJson(): [
            codexN(112),
            milestone(CampaignMilestone.milestone6dot3Admonishing),
            function('tally_relics'),
          ],
        },
        onMilestone: {
          '_search_failed': [
            codexN(114),
            victory(),
          ],
          '_search_succeeded': [
            codexN(115),
            victory(),
            item('Tihfur Claw'),
          ],
        },
        dialogs: [
          EncounterDialogDef(
              title: 'Introduction',
              body:
                  '''Every step deeper into the Taharik comes with some sort of added challenge. Unstable footing, gnarled tree roots, shrouds of Morphic spores, pools of muck and grime. Requiring even more care is the swirling moat of rancid Morph essence surrounding the ruins of a tihfur village. Displaced soil and collapsed trees give you a viable crossing, but its presence is deeply unsettling, and not even your ether-fortified bodies would withstand a plunge into its depths for very long.

Many of the homes that were once suspended in the treetops now lie shattered and broken in heaps on the forest floor. Rotten timber surrounds the ruins having either pierced or become buried in the wreckage of the hovels. Distressed tihfur monstrosities shuffle through the village, kicking at fallen carvings or digging through mounds of garbage.

Swirling overhead and haranguing the tihfur are faintly glowing beings of pure Morph. Each time they make contact with one another, the malformed starlings begin to screech uncontrollably as the tihfur pulls away and cackles. Silky gasps and lets out a stream of curses, more quietly than before. “Broken Vessels... that’s what Mo was sensing. I’ll put it this way; the only place, literally the only place, that we know of their appearance is the Unsouled Barrens. Which means to see them not only outside of the Barrens, but this far from it, suggests dire circumstances. We must hurry, Rovers. Time is very much not with us here.”

Silky performs a quick flying survey and circles back to point out areas in the village worth investigating. He urges you to find the potential source of the Morphic surge, suggesting that it may have originated here within the Yanshif’s now-broken homes. Silky emphasizes the importance of time, and that no matter what you discover, you cannot stay here as the concentration of Morph is growing and poses too substantial a risk to everyone’s bodies.'''),
          EncounterDialogDef(title: 'Lost Memories', type: 'draw'),
        ],
        startingMap: MapDef(
          id: '6.3',
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
            (0, 6): TerrainType.object,
            (0, 7): TerrainType.openAir,
            (0, 8): TerrainType.openAir,
            (0, 9): TerrainType.openAir,
            (1, 0): TerrainType.openAir,
            (1, 1): TerrainType.dangerous,
            (1, 8): TerrainType.openAir,
            (2, 3): TerrainType.difficult,
            (2, 6): TerrainType.object,
            (3, 0): TerrainType.object,
            (3, 3): TerrainType.difficult,
            (3, 6): TerrainType.object,
            (3, 7): TerrainType.object,
            (4, 9): TerrainType.object,
            (5, 1): TerrainType.difficult,
            (6, 0): TerrainType.object,
            (6, 1): TerrainType.difficult,
            (6, 2): TerrainType.object,
            (7, 1): TerrainType.difficult,
            (8, 2): TerrainType.object,
            (8, 3): TerrainType.object,
            (8, 6): TerrainType.difficult,
            (8, 8): TerrainType.object,
            (9, 0): TerrainType.openAir,
            (9, 3): TerrainType.object,
            (9, 6): TerrainType.difficult,
            (10, 0): TerrainType.openAir,
            (11, 0): TerrainType.openAir,
            (11, 1): TerrainType.dangerous,
            (11, 7): TerrainType.openAir,
            (12, 0): TerrainType.openAir,
            (12, 6): TerrainType.object,
            (12, 7): TerrainType.openAir,
            (12, 8): TerrainType.openAir,
          },
          spawnPoints: {
            (1, 10): Ether.fire,
            (3, 10): Ether.wind,
            (5, 10): Ether.earth,
            (7, 10): Ether.water,
            (9, 10): Ether.morph,
            (11, 10): Ether.crux,
          },
        ),
        overlays: [
          EncounterFigureDef(name: 'Hoard', onLoot: [
            dialog('Lost Memories'),
          ])
        ],
        adversaries: [
          EncounterFigureDef(
            name: 'Broken Vessel',
            letter: 'A',
            health: 6,
            flies: true,
            respawns: true,
            traits: [
              '''[React] Before this unit is slain, it performs:
              
[m_attack] | [Range] 1 | [DMG]2 | [miasma] | [Target] all units''',
            ],
            affinities: {
              Ether.crux: -2,
              Ether.morph: 1,
            },
          ),
          EncounterFigureDef(
            name: 'Nahoot',
            letter: 'B',
            health: 15,
            respawns: true,
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
            name: 'Nahadir',
            letter: 'C',
            health: 15,
            flies: true,
            respawns: true,
            traits: [
              'This unit gains [DEF] 1 against attacks by Rovers that have a [Morph] dice in their personal or infusion pools.',
            ],
            affinities: {
              Ether.crux: -1,
              Ether.water: 1,
              Ether.morph: 2,
            },
          ),
          EncounterFigureDef(
              name: 'Haunt',
              letter: 'D',
              healthFormula: '3*R',
              respawns: true,
              affinities: {
                Ether.crux: 2,
                Ether.morph: -2,
              },
              onSlain: [
                codexN(106),
                item('Multifaceted Icon',
                    body:
                        'The Rover that slayed the haunt gains one “Multifaceted Icon” item.  They may equip this item.  If they don’t have the required item slot(s) available, they may unequip items as needed.'),
              ]),
          EncounterFigureDef(
            name: 'Zeepurah',
            letter: 'E',
            type: AdversaryType.miniboss,
            healthFormula: '8+2*R',
            flies: true,
            affinities: {
              Ether.wind: -1,
              Ether.fire: -1,
              Ether.morph: 2,
              Ether.water: 2,
            },
          ),
        ],
        placements: [
          PlacementDef(name: 'Broken Vessel', c: 8, r: 0, minPlayers: 3),
          PlacementDef(name: 'Broken Vessel', c: 10, r: 2, minPlayers: 4),
          PlacementDef(name: 'Broken Vessel', c: 2, r: 0, minPlayers: 4),
          PlacementDef(name: 'Broken Vessel', c: 4, r: 4),
          PlacementDef(name: 'Broken Vessel', c: 7, r: 4),
          PlacementDef(name: 'Nahoot', c: 0, r: 5),
          PlacementDef(name: 'Nahoot', c: 7, r: 6),
          PlacementDef(name: 'Nahoot', c: 11, r: 6, minPlayers: 3),
          PlacementDef(name: 'Broken Vessel', c: 0, r: 3, minPlayers: 3),
          PlacementDef(name: 'Nahadir', c: 4, r: 6, minPlayers: 4),
          PlacementDef(name: 'Nahadir', c: 12, r: 4),
          PlacementDef(name: 'Haunt', c: 12, r: 1),
          PlacementDef(
            name: 'Zeepurah',
            c: 4,
            r: 0,
            onSlain: [
              codexN(113),
              milestone(CampaignMilestone.milestone6ZeepurahSlain),
            ],
          ),
          PlacementDef(name: 'Hoard', type: PlacementType.object, c: 2, r: 5),
          PlacementDef(name: 'Hoard', type: PlacementType.object, c: 3, r: 3),
          PlacementDef(name: 'Hoard', type: PlacementType.object, c: 5, r: 0),
          PlacementDef(name: 'Hoard', type: PlacementType.object, c: 7, r: 0),
          PlacementDef(name: 'Hoard', type: PlacementType.object, c: 9, r: 2),
          PlacementDef(name: 'Hoard', type: PlacementType.object, c: 8, r: 5),
          PlacementDef(name: 'morph', type: PlacementType.ether, c: 0, r: 6),
          PlacementDef(name: 'morph', type: PlacementType.ether, c: 12, r: 6),
          PlacementDef(name: 'wind', type: PlacementType.ether, c: 6, r: 2),
        ],
      );

  static EncounterDef get encounter6dot4 => EncounterDef(
        questId: '6',
        number: '4',
        title: 'The Pitiless Wave',
        victoryDescription: 'Slay Zipahudi the Briarbull.',
        roundLimit: 8,
        itemRewards: ['Thick Briarshawl'],
        campaignLink:
            '''Encounter 6.5 - “**Illimitable Dominion Over All**”, [campaign] **96**.''',
        extraPhase: 'The Yanshif',
        extraPhaseIndex: 2,
        challenges: [
          'Zeepurah will always attack Rovers if they are within range of her attacks.',
          'Zipahudi gains +2 movement points to all of their movement actions and their passive gains +1 [DMG].  When Zipahudi moves, it wants to move within [Range] 1 of the most enemies that it can.',
          'When rolling the damage dice for a Rover attack, treat a result of [DIM] as -1 [DMG].',
        ],
        trackerEvents: [
          EncounterTrackerEventDef(
              title:
                  'Mark when each Drained Ether node has a [Morph] dice, or add [Morph] tokens to the Drained Ether below.',
              ifMilestone: CampaignMilestone.milestone6dot3All,
              recordMilestone: '_ether_charged'),
        ],
        dialogs: [
          EncounterDialogDef(
              title: 'Introduction',
              body:
                  '''Marshes aren’t known for smelling nice even without undue contamination. Waste. Decay. Rot. Death. A festering cauldron whose contents cling to the air itself long before anything can think to sample its vile brew. Each step ejects more of the foul haze upwards. Carried on the wind is a palpable force that presses upon you and leaves your voices hoarse. Tears well up in Grandpaw’s eyes but he doesn’t give voice to his suffering—likely in the hopes of not inhaling more of the fetid air than necessary.

This marsh stands as the border between the Taharik and the southernmost swamp along the coast of Lalos. Normally it would be where the tihfur clan would hunt intruders and harvest reagents from its fertile wetland. Today it is an open-air sepulcher, festooned in the adornments of the briarwog brood that calls it home. Decaying silvans add their own splash of sickly color to the vista.

Pulsating stone masses crest the surface of the swamp waters at the far end of the marsh. An immense briarbull presides over the rotten cesspools, his hide mired in violet and ebony hues, his spines dripping with a venom no doubt all the worse for the inclusion of the Morphic miasma. A lone briarbull rutting in a single marsh couldn’t be the source of this wilde-spread pollution, but slaying it is a boon to anything that enjoys breathing clean air and drinking clean water.'''),
        ],
        onLoad: [
          dialog('Introduction'),
          rules('Zeepurah Slain',
              '''Check your campaign log, if “Zeepurah was slain.” is recorded, do not set up Zeepurah at the beginning of the encounter and The Yanshif special rule is not active.''',
              condition: MilestoneCondition(
                  CampaignMilestone.milestone6ZeepurahSlain)),
          remove('Zeepurah',
              condition:
                  MilestoneCondition(CampaignMilestone.milestone6ZeepurahSlain),
              silent: true),
          rules(
              'The Yanshif',
              '''Zeepurah is part of her own faction, The Yanshif, which is an enemy to both the Rover and Adversary factions.  Units a part of the Yanshif faction follow all the adversary logic rules found on page X in the rule book.  This faction gains priority after the Adversary faction has gone.

Though Zeepurah is indeed your enemy, you can still target her with positive effects, such as healing actions.''',
              condition: MilestoneCondition(
                  CampaignMilestone.milestone6ZeepurahSlain,
                  value: false)),
          codexLink('Dissemble no More',
              number: 117,
              body:
                  '''Each time a Corrupted Nektari Hive is destroyed, read [title], [codex] 55.'''),
          codexLink('Hope Has Flown Away',
              number: 118,
              body: '''If Zeepurah is slain, read [title], [codex] 55.'''),
          codexLink('They Can Only Shriek',
              number: 121,
              body:
                  '''Immediately when Zipahudi is slain, if Zeepurah was slain at any point during this quest, read [title], [codex] 57.'''),
          codexLink('Agony of Desire',
              number: 119,
              body:
                  '''Immediately when Zipahudi is slain, if Zeepurah is alive and if [morph] dice were not placed onto each of the drained ether nodes, read [title], [codex] 56.'''),
          milestone('_containing_zeepurah',
              condition:
                  MilestoneCondition(CampaignMilestone.milestone6dot3All)),
        ],
        onMilestone: {
          '_containing_zeepurah': [
            codexN(116),
            victoryCondition(
                '+\n\nOptional: Before slaying Zipahudi the Briarbull, place one [Morph] dice on each of the drained ether nodes while keeping Zeepurah alive.'),
            rules('Drained Ether Nodes',
                '''These drained ether nodes work differently from other ether nodes you have encountered up to this point. When a Rover is within [range] 1 of a Drained Ether node, that Rover can spend 1 movement point to place a [morph] dice from their personal supply on to the node.'''),
            codexLink('The Danger Ebbs and Flows',
                number: 120,
                body:
                    '''Immediately when Zipahudi is slain, if Zeepurah is alive and if [morph] dice have been placed onto each of the drained ether nodes, read [title], [codex] 56.'''),
          ],
          '_victory_zeepurah_slain': [
            codexN(121),
            victory(),
            lyst('10*R'),
            item('Zeepurah\'s Piercer'),
          ],
          '_victory_zeepurah_not_contained': [
            codexN(119),
            victory(),
            lyst('20*R'),
            milestone(CampaignMilestone.milestone6ZeepurahLost)
          ],
          '_victory_zeepurah_contained': [
            codexN(120),
            victory(),
            lyst('10*R'),
            milestone(CampaignMilestone.milestone6ZeepurahContained)
          ],
        },
        startingMap: MapDef(
          id: '6.4',
          columnCount: 13,
          rowCount: 11,
          backgroundRect: Rect.fromLTWH(110.0, 44.0, 1481.0, 1411.0),
          starts: [
            (0, 8),
            (0, 9),
            (1, 9),
            (1, 10),
            (2, 9),
          ],
          terrain: {
            (0, 0): TerrainType.openAir,
            (0, 1): TerrainType.openAir,
            (0, 2): TerrainType.barrier,
            (0, 3): TerrainType.barrier,
            (0, 5): TerrainType.dangerous,
            (0, 6): TerrainType.openAir,
            (1, 0): TerrainType.barrier,
            (1, 1): TerrainType.barrier,
            (1, 2): TerrainType.openAir,
            (1, 3): TerrainType.barrier,
            (1, 6): TerrainType.openAir,
            (2, 0): TerrainType.barrier,
            (2, 1): TerrainType.object,
            (3, 8): TerrainType.openAir,
            (3, 9): TerrainType.openAir,
            (4, 8): TerrainType.dangerous,
            (5, 5): TerrainType.object,
            (6, 0): TerrainType.barrier,
            (6, 3): TerrainType.object,
            (7, 0): TerrainType.barrier,
            (7, 1): TerrainType.barrier,
            (7, 5): TerrainType.object,
            (7, 10): TerrainType.dangerous,
            (8, 8): TerrainType.dangerous,
            (8, 9): TerrainType.object,
            (9, 9): TerrainType.openAir,
            (9, 10): TerrainType.openAir,
            (10, 3): TerrainType.openAir,
            (10, 4): TerrainType.dangerous,
            (10, 8): TerrainType.dangerous,
            (10, 9): TerrainType.openAir,
            (11, 0): TerrainType.barrier,
            (11, 1): TerrainType.barrier,
            (11, 4): TerrainType.openAir,
            (11, 7): TerrainType.object,
            (11, 8): TerrainType.openAir,
            (11, 9): TerrainType.openAir,
            (11, 10): TerrainType.openAir,
            (12, 0): TerrainType.barrier,
            (12, 6): TerrainType.dangerous,
            (12, 7): TerrainType.openAir,
            (12, 8): TerrainType.openAir,
            (12, 9): TerrainType.openAir,
          },
        ),
        overlays: [
          EncounterFigureDef(
              name: 'Drained Morph Ether',
              alias: 'Drained Ether',
              possibleTokens: [
                'Morph'
              ],
              onTokensChanged: [
                milestone('_ether_charged', conditions: [
                  MilestoneCondition('_charged_ether_1'),
                  MilestoneCondition('_charged_ether_2'),
                  MilestoneCondition('_charged_ether_3'),
                ]),
              ]),
          EncounterFigureDef(
              name: 'Nektari Hive',
              alias: 'Corrupted Nektari Hive',
              healthFormula: '2*R',
              onSlain: [
                codexN(117),
                lyst('5*R', title: 'Dissemble No More'),
                item('Scour Ichor',
                    body:
                        'The Rover that destroyed the Corrupted Nektari Hive gains one “Scour Ichor” item.  They may equip this item.  If they don’t have the required item slot(s) available, they may unequip items as needed.'),
                placementGroup('Nektari',
                    body:
                        'Spawn R corrupted nektari swarms within [Range] 0-1 of the destroyed hive.'),
              ]),
        ],
        adversaries: [
          EncounterFigureDef(
            name: 'Briarwog',
            letter: 'A',
            health: 8,
            traits: [
              '''[React] After this unit is attacked from within [Range] 1:
              
The attacker suffers [DMG]1.''',
            ],
            affinities: {
              Ether.earth: -1,
              Ether.fire: -1,
              Ether.water: 1,
              Ether.morph: 1,
            },
          ),
          EncounterFigureDef(
            name: 'Dekaha',
            letter: 'B',
            health: 8,
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
            letter: 'C',
            health: 12,
            defense: 1,
            traits: [
              'If a Rover slays this unit, that Rover +[Morph].',
            ],
            affinities: {
              Ether.crux: -2,
              Ether.fire: -1,
              Ether.earth: 1,
              Ether.water: 1,
              Ether.morph: 2,
            },
            onSlain: [
              ether([Ether.morph]),
            ],
          ),
          EncounterFigureDef(
            name: 'Zipahudi the Briarbull',
            letter: 'D',
            type: AdversaryType.miniboss,
            healthFormula: '15*R',
            traits: [
              'This unit treats corrupted pools and poison pools as normal spaces.',
              '''[React] When this unit enters into a space within [Range] 1 of an enemy:
              
That enemy suffers [DMG]2.''',
            ],
            affinities: {
              Ether.earth: -1,
              Ether.water: 1,
              Ether.morph: 2,
            },
          ),
          EncounterFigureDef(
            name: 'Zeepurah',
            letter: 'E',
            type: AdversaryType.miniboss,
            faction: 'The Yanshif',
            healthFormula: '8+2*R',
            flies: true,
            affinities: {
              Ether.wind: -1,
              Ether.fire: -1,
              Ether.morph: 2,
              Ether.water: 2,
            },
          ),
          EncounterFigureDef(
            name: 'Corrupted Nektari Swarm',
            letter: 'F',
            health: 1,
            flies: true,
            traits: [
              'This unit is immune to damage from attack actions when it is within [Range] 1 of a [miasma].',
            ],
            affinities: {
              Ether.crux: -2,
              Ether.water: -1,
              Ether.wind: 1,
              Ether.morph: 2,
            },
          ),
        ],
        placements: [
          PlacementDef(name: 'Briarwog', c: 2, r: 2, minPlayers: 3),
          PlacementDef(name: 'Briarwog', c: 5, r: 3, minPlayers: 4),
          PlacementDef(name: 'Briarwog', c: 7, r: 9),
          PlacementDef(name: 'Briarwog', c: 10, r: 7),
          PlacementDef(name: 'Briarwog', c: 11, r: 6, minPlayers: 3),
          PlacementDef(name: 'Dekaha', c: 7, r: 6),
          PlacementDef(name: 'Dekaha', c: 5, r: 6, minPlayers: 4),
          PlacementDef(name: 'Briarwog', c: 6, r: 1),
          PlacementDef(name: 'Dekaha', c: 9, r: 5),
          PlacementDef(name: 'Grovetender', c: 6, r: 4),
          PlacementDef(name: 'Grovetender', c: 11, r: 5, minPlayers: 3),
          PlacementDef(name: 'Grovetender', c: 9, r: 8, minPlayers: 4),
          PlacementDef(
            name: 'Zipahudi the Briarbull',
            c: 12,
            r: 8,
            onSlain: [
              milestone('_victory_zeepurah_slain', conditions: [
                MilestoneCondition(CampaignMilestone.milestone6ZeepurahSlain),
              ]),
              milestone(
                '_victory_zeepurah_contained',
                conditions: [
                  MilestoneCondition(CampaignMilestone.milestone6ZeepurahSlain,
                      value: false),
                  MilestoneCondition('_ether_charged'),
                ],
              ),
              milestone('_victory_zeepurah_not_contained', conditions: [
                MilestoneCondition('_ether_charged', value: false),
                MilestoneCondition(CampaignMilestone.milestone6ZeepurahSlain,
                    value: false),
              ]),
            ],
          ),
          PlacementDef(
            name: 'Zeepurah',
            c: 3,
            r: 0,
            onSlain: [
              codexN(117),
              milestone(CampaignMilestone.milestone6ZeepurahSlain,
                  title: 'Zeepurah Death'),
            ],
          ),
          PlacementDef(
              name: 'Nektari Hive', type: PlacementType.object, c: 2, r: 1),
          PlacementDef(name: 'morph', type: PlacementType.ether, c: 8, r: 9),
          PlacementDef(name: 'morph', type: PlacementType.ether, c: 11, r: 7),
          PlacementDef(
              name: 'Drained Morph Ether',
              type: PlacementType.feature,
              c: 5,
              r: 5,
              onTokensChanged: [
                milestone('_charged_ether_1'),
              ]),
          PlacementDef(
              name: 'Drained Morph Ether',
              type: PlacementType.feature,
              c: 7,
              r: 5,
              onTokensChanged: [
                milestone('_charged_ether_2'),
              ]),
          PlacementDef(
              name: 'Drained Morph Ether',
              type: PlacementType.feature,
              c: 6,
              r: 3,
              onTokensChanged: [
                milestone('_charged_ether_3'),
              ]),
        ],
        placementGroups: [
          PlacementGroupDef(
            name: 'Nektari',
            placements: [
              PlacementDef(name: 'Corrupted Nektari Swarm'),
              PlacementDef(name: 'Corrupted Nektari Swarm'),
              PlacementDef(name: 'Corrupted Nektari Swarm', minPlayers: 3),
              PlacementDef(name: 'Corrupted Nektari Swarm', minPlayers: 4)
            ],
          ),
        ],
      );
  static EncounterDef get encounter6dot5 => EncounterDef(
        questId: '6',
        number: '5',
        title: 'Illimitable Dominion Over All',
        victoryDescription: 'Slay the Ahma.',
        roundLimit: 10,
        baseLystReward: 30,
        itemRewards: ['Ahma Cowl'],
        unlocksRoverLevel: 7,
        unlocksShopLevel: 4,
        campaignLink:
            '''Chapter 4 - “**A Consequence**”, [campaign] **100**.''',
        challenges: [
          'Adversaries are immune to the effects of [Morph] nodes.  Rovers can not take ether dice from [Morph] nodes, and are affected by them when within [Range] 1-2.',
          'The Ahma gains +1 [DEF].',
          'Adversaries gain +1 [DMG] to their attack when targeting an enemy that occupies [miasma].',
        ],
        dialogs: [
          EncounterDialogDef(
              title: 'Introduction - Ahma Corrupter',
              body: '''*So heed the call of midnight’s choir,*

*And shun the miasma’s ghastly mire,*

*For in its grip where shadows dwell,*

*One might be lost within the spell.*


Two monstrous avian creatures squat in the middle of the swamp atop a mound of gathered corpses. You see streaks with their necks twisted, briarwogs with their limbs shredded, terranape with their legs crushed, and plenty of other indeterminate prey mixed between. Squelching, sloshing, slurping. Enjoying their banquet of rotten flesh, the two monsters wear similar expressions of delight.

One of the pair is truly massive. A cloak of manifold wings spans from shoulder to tail, each one cast in razor pinions. A naked skull protrudes from its spine, its ivory length splattered in the fluids of its kills. Three eyes of pride, fever, and adoration trail from its meals to the partner it shares them with. Every so often it preens the smaller of the pair, who must be the woman you pursued here, which involves ripping free one of her pin-feathers in a spray of ichor that coats them both.

Circling the scene is a host of broken vessels, each adding their “voice” to the cacophony of birdsong emanating from the monstrous pair. Their tendrils undulate wildly as they heedlessly crash into one another. For all of the viciousness they demonstrated in the village, they seem much less distressed amidst this macabre display.

Mo holds out their limbs and their tendrils sway in the putrid, but placid, breeze. “That’s… words fail to describe just how strange this flow of ether is. That large beast is for certain the source of the chaos. There’s… something flows between the tihfur. I think it’s weakening itself to empower its mate. Please, exercise caution, Rovers.”'''),
          EncounterDialogDef(
              title: 'Introduction - Ahma Enraged',
              body: '''*Over the land a curse was cast,*

*A silent echo from the past,*

*And as the black birds took their flight,*

*They bore away the waning light.*


**“M Y  M U S E,**

**W H A T  H A V E  Y O U  D O N E,**

**I  C A N N O T  F I N I S H  T H E  S O N G,**

**H O W  C A N  W E  L E A D  T H E  F L O C K?”**

In the depths of the swamp stands a monstrous ashen avian. Their long tail lashes out into the dark, the sharp feathers along its length casually shredding the brittle flora surrounding it. A pale skull with three eyes of wrath, woe, and despair survey their surroundings. The monster twists its skull unnaturally, adding percussive snapping and popping to the sounds of its screeching Yanshif cohort. 

**“H E A R  M E,**

**L I S T E N  T O  M Y  S O N G.”**

Shrieking tones emanate from the hollow visage of the monster. The collected Yanshif fall one after the other in reverent bows. Miasma flows into each of them, their bodies beginning to swell and their plumage taking on a new sheen of gleaming ebony. Fluttering nektari descend in droves to add their own wingbeats to the undulant dirge.

**“W E  A R E  A H M A,**

**Y O U  A R E  N O T  W E L C O M E!”**

A whirlwind of razor-sharp feathers explodes across the swamp. Every member of the procession screams as their bodies are assaulted by the energy that rends the flesh from their bodies to build upon the creeping cloud. Your only choice now is to fight against the chaos made manifest.'''),
          EncounterDialogDef(
              title: 'Introduction - Ahma Desperate',
              body: '''*Each rustle in the spectral gloom,*

*Foretold of tales within the tomb,*

*And shadows danced with twisted grace,*

*As darkened fate worked to interlace.*


Frantic splashes erupt in the midst of the swamp. A bleached skull with three eyes of worry, fear, and regret are cast upon you. The skull clatters and wobbles with uncertainty, as it searches for something within you. Whatever the monster seeks, it is not here, and it proceeds to slam its face into the brackish fluid below. Gurgles and pops echo through the swamp as the fluid fills the hollow spaces of the skull. When it resurfaces, a briarwog is held between its massive beak. A vicious snap rends the creature asunder as its innards are consumed by the grotesque abomination.

**“W H E R E  I S  M Y  M U S E?**

**W H A T  H A V E  Y O U  D O N E?”**

The source of the chaos lies here at the heart of the swamp. What was once tihfur is now only scourge, blanketing the region in an endless plume of Morph. There is some hope—the ritual you enacted has had a clear effect on the environment. While the waters of the swamp immediately surrounding the beast are brackish and dark, they take on a more natural green the further away one looks. Even the ever-present nektari seem to have recovered some faint hues of color to their bodies.

Mo nods as they curl their tendrils around themself. “It is as I said. Resonance was the key. The Morph was connecting their bodies; trapping the ether elsewhere has reduced its influence.” Silky quietly congratulates the starling. They depart back towards the marsh where Makaal and Grandpaw remain, leaving you to contend with the ailing heart of the stagnant force.

**“Z E E P U R A H,**

**I  B E G  Y O U,**

**G I V E  M E  Y O U R  S O N G!**”'''),
        ],
        onLoad: [
          milestone('_enraged',
              condition: MilestoneCondition(
                  CampaignMilestone.milestone6ZeepurahSlain)),
          milestone('_desperate',
              condition: MilestoneCondition(
                  CampaignMilestone.milestone6ZeepurahContained)),
          milestone('_corrupter',
              condition:
                  MilestoneCondition(CampaignMilestone.milestone6ZeepurahLost)),
        ],
        onMilestone: {
          '_enraged': [
            dialog('Introduction - Ahma Enraged'),
            rules('The Yanshif',
                '''The state of Zeepurah changes the profile you will use for the Ahma during this encounter.

You have milestone “${CampaignMilestone.milestone6ZeepurahSlain}” marked. Proceed to page 74 of the adversary book, page 44 of the map book.'''),
            placementGroup('Enraged'),
            codexLink('A Horror They Outpour',
                number: 125,
                body:
                    '''Immediately when Ahma Enraged is slain, read [title], [codex] 59.'''),
          ],
          '_desperate': [
            dialog('Introduction - Ahma Desperate'),
            rules('The Yanshif', '''
The state of Zeepurah changes the profile you will use for the Ahma during this encounter.

You have milestone “${CampaignMilestone.milestone6ZeepurahContained}” marked. Proceed to 75 of the adversary book, page 45 of the map book.'''),
            placementGroup('Desperate'),
            codexLink('The Palpitating Air',
                number: 124,
                body:
                    '''Immediately when Ahma Desperate is slain, read [title], [codex] 59.'''),
          ],
          '_corrupter': [
            dialog('Introduction - Ahma Corrupter'),
            rules('The Yanshif', '''
The state of Zeepurah changes the profile you will use for the Ahma during this encounter.

You have milestone “${CampaignMilestone.milestone6ZeepurahLost}” marked. Proceed to 76 of the adversary book, page 46 of the map book.

Though Zeepurah is indeed your enemy, you can still target her with positive effects, such as healing actions.  This encounter will be easier if you slay her, but it is not required to win.'''),
            codexLink('In a Mad Expostulation',
                number: 122,
                body: '''If Zeepurah is slain, read [title], [codex] 58.'''),
            codexLink('Evil is a Consequence of Good',
                number: 126,
                body:
                    '''Immediately when Ahma Corrupter is slain, if Zeepurah was slain, read [title], [codex] 60.'''),
            codexLink('A Clamorous Appealing',
                number: 123,
                body:
                    '''Immediately when Ahma Corrupter is slain, if Zeepurah is alive, read [title], [codex] 58.'''),
          ],
          '_victory': [
            victory(),
            codexN(127),
          ],
        },
        startingMap: MapDef(
          id: '6.5.2',
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
            (0, 0): TerrainType.openAir,
            (0, 1): TerrainType.openAir,
            (0, 2): TerrainType.openAir,
            (0, 6): TerrainType.object,
            (0, 8): TerrainType.difficult,
            (0, 9): TerrainType.openAir,
            (1, 0): TerrainType.openAir,
            (1, 1): TerrainType.openAir,
            (1, 2): TerrainType.openAir,
            (1, 3): TerrainType.difficult,
            (1, 9): TerrainType.dangerous,
            (1, 10): TerrainType.openAir,
            (2, 0): TerrainType.openAir,
            (2, 1): TerrainType.dangerous,
            (2, 9): TerrainType.object,
            (3, 0): TerrainType.openAir,
            (3, 5): TerrainType.openAir,
            (3, 9): TerrainType.dangerous,
            (3, 10): TerrainType.openAir,
            (4, 4): TerrainType.object,
            (4, 5): TerrainType.dangerous,
            (4, 9): TerrainType.openAir,
            (5, 10): TerrainType.openAir,
            (6, 9): TerrainType.openAir,
            (7, 9): TerrainType.difficult,
            (7, 10): TerrainType.openAir,
            (8, 3): TerrainType.dangerous,
            (8, 9): TerrainType.openAir,
            (9, 0): TerrainType.openAir,
            (9, 3): TerrainType.object,
            (9, 4): TerrainType.openAir,
            (9, 9): TerrainType.dangerous,
            (9, 10): TerrainType.openAir,
            (10, 0): TerrainType.dangerous,
            (10, 9): TerrainType.object,
            (11, 0): TerrainType.openAir,
            (11, 1): TerrainType.dangerous,
            (11, 9): TerrainType.openAir,
            (11, 10): TerrainType.openAir,
            (12, 0): TerrainType.dangerous,
            (12, 1): TerrainType.difficult,
            (12, 5): TerrainType.object,
            (12, 6): TerrainType.difficult,
            (12, 8): TerrainType.openAir,
            (12, 9): TerrainType.openAir,
          },
        ),
        adversaries: [
          EncounterFigureDef(
            name: 'Ahma',
            alias: 'Ahma Corrupter',
            letter: 'A',
            type: AdversaryType.boss,
            healthFormula: '40*R',
            large: true,
            traits: [
              'At the begining of each even round, spawn R-1 Broken Vessels at [Range] 2 of this unit, closest to the nearest enemy.',
            ],
            affinities: {
              Ether.morph: 2,
              Ether.wind: 2,
              Ether.water: 1,
              Ether.fire: -1,
              Ether.crux: -1,
            },
            onDidStartRound: [
              placementGroup('Broken Vessels', condition: RoundCondition(2)),
              placementGroup('Broken Vessels', condition: RoundCondition(4)),
              placementGroup('Broken Vessels', condition: RoundCondition(6)),
              placementGroup('Broken Vessels', condition: RoundCondition(8)),
              placementGroup('Broken Vessels', condition: RoundCondition(10)),
            ],
          ),
          EncounterFigureDef(
            name: 'Zeepurah',
            letter: 'B',
            type: AdversaryType.miniboss,
            healthFormula: '8*R',
            flies: true,
            traits: [
              'While this unit is within [Range] 1-2 of the Ahma, the Ahma gains [DEF] 2.',
            ],
            affinities: {
              Ether.morph: 2,
              Ether.water: 2,
              Ether.wind: -1,
              Ether.fire: -1,
            },
          ),
          EncounterFigureDef(
            name: 'Broken Vessel',
            letter: 'C',
            health: 6,
            flies: true,
            traits: [
              '''[React] Before this unit is slain, it performs:
              
[m_attack] | [Range] 1 | [DMG]2 | [miasma] | [Target] all units''',
            ],
            affinities: {
              Ether.crux: -2,
              Ether.morph: 1,
            },
          ),
        ],
        placements: [
          PlacementDef(name: 'Ahma', c: 6, r: 8, onSlain: [
            codexN(126,
                condition: MilestoneCondition(
                  CampaignMilestone.milestone6ZeepurahSlain,
                )),
            codexN(123,
                condition: MilestoneCondition(
                  CampaignMilestone.milestone6ZeepurahSlain,
                  value: false,
                )),
            milestone('_victory'),
          ]),
          PlacementDef(name: 'Zeepurah', c: 8, r: 6, onSlain: [
            codexN(122),
            milestone(CampaignMilestone.milestone6ZeepurahSlain,
                title: 'Zeepurah Death'),
          ]),
          PlacementDef(name: 'Broken Vessel', c: 0, r: 2, minPlayers: 3),
          PlacementDef(name: 'Broken Vessel', c: 3, r: 5),
          PlacementDef(name: 'Broken Vessel', c: 9, r: 4),
          PlacementDef(name: 'Broken Vessel', c: 12, r: 3, minPlayers: 3),
          PlacementDef(name: 'Broken Vessel', c: 10, r: 8, minPlayers: 4),
          PlacementDef(name: 'Broken Vessel', c: 2, r: 8, minPlayers: 4),
          PlacementDef(
              name: 'Hatchery',
              type: PlacementType.trap,
              c: 0,
              r: 3,
              trapDamage: 3),
          PlacementDef(
              name: 'Hatchery',
              type: PlacementType.trap,
              c: 5,
              r: 9,
              trapDamage: 3),
          PlacementDef(
              name: 'Hatchery',
              type: PlacementType.trap,
              c: 12,
              r: 7,
              trapDamage: 3),
          PlacementDef(
              name: 'Hatchery',
              type: PlacementType.trap,
              c: 9,
              r: 1,
              trapDamage: 3),
          PlacementDef(name: 'morph', type: PlacementType.ether, c: 2, r: 9),
          PlacementDef(name: 'morph', type: PlacementType.ether, c: 10, r: 9),
          PlacementDef(name: 'morph', type: PlacementType.ether, c: 4, r: 4),
          PlacementDef(name: 'morph', type: PlacementType.ether, c: 9, r: 3),
        ],
        placementGroups: [
          PlacementGroupDef(name: 'Broken Vessels', placements: [
            PlacementDef(name: 'Broken Vessel'),
            PlacementDef(name: 'Broken Vessel', minPlayers: 3),
            PlacementDef(name: 'Broken Vessel', minPlayers: 4),
          ]),
          PlacementGroupDef(
            name: 'Enraged',
            adversaries: [
              EncounterFigureDef(
                name: 'Ahma',
                alias: 'Ahma Enraged',
                letter: 'A',
                type: AdversaryType.boss,
                healthFormula: '35*R',
                defenseFormula: 'X',
                xDefinition: 'count_adversary(Nahoot)',
                large: true,
                traits: [
                  'X equals the number of Nahoot on the map.',
                  'At the start of this unit\'s turn, it recovers [RCV] Y+1. << Where Y equals the number of Nahadir on the map.',
                ],
                affinities: {
                  Ether.morph: 2,
                  Ether.wind: 2,
                  Ether.water: 1,
                  Ether.crux: -2,
                  Ether.fire: -1,
                },
              ),
              EncounterFigureDef(
                name: 'Nahoot',
                letter: 'B',
                health: 15,
                traits: [
                  'If a Rover slays this unit, that Rover [plus_wind_morph].'
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
                name: 'Nahadir',
                letter: 'C',
                health: 15,
                flies: true,
                traits: [
                  'This unit gains [DEF] 1 against attacks by Rovers that have a [Morph] dice in their personal or infusion pools.',
                ],
                affinities: {
                  Ether.morph: 2,
                  Ether.water: 1,
                  Ether.crux: -1,
                },
              ),
            ],
            map: MapDef(
              id: '6.5.3',
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
                (0, 0): TerrainType.openAir,
                (0, 1): TerrainType.openAir,
                (0, 2): TerrainType.openAir,
                (0, 6): TerrainType.object,
                (0, 8): TerrainType.difficult,
                (0, 9): TerrainType.openAir,
                (1, 0): TerrainType.openAir,
                (1, 1): TerrainType.openAir,
                (1, 2): TerrainType.openAir,
                (1, 3): TerrainType.difficult,
                (1, 9): TerrainType.dangerous,
                (1, 10): TerrainType.openAir,
                (2, 0): TerrainType.openAir,
                (2, 1): TerrainType.dangerous,
                (2, 9): TerrainType.object,
                (3, 0): TerrainType.openAir,
                (3, 5): TerrainType.openAir,
                (3, 9): TerrainType.dangerous,
                (3, 10): TerrainType.openAir,
                (4, 4): TerrainType.object,
                (4, 5): TerrainType.dangerous,
                (4, 9): TerrainType.openAir,
                (5, 10): TerrainType.openAir,
                (6, 9): TerrainType.openAir,
                (7, 9): TerrainType.difficult,
                (7, 10): TerrainType.openAir,
                (8, 3): TerrainType.dangerous,
                (8, 9): TerrainType.openAir,
                (9, 0): TerrainType.openAir,
                (9, 3): TerrainType.object,
                (9, 4): TerrainType.openAir,
                (9, 9): TerrainType.dangerous,
                (9, 10): TerrainType.openAir,
                (10, 0): TerrainType.dangerous,
                (10, 9): TerrainType.object,
                (11, 0): TerrainType.openAir,
                (11, 1): TerrainType.dangerous,
                (11, 9): TerrainType.openAir,
                (11, 10): TerrainType.openAir,
                (12, 0): TerrainType.dangerous,
                (12, 1): TerrainType.difficult,
                (12, 5): TerrainType.object,
                (12, 6): TerrainType.difficult,
                (12, 8): TerrainType.openAir,
                (12, 9): TerrainType.openAir,
              },
            ),
            placements: [
              PlacementDef(name: 'Ahma', c: 6, r: 8, onSlain: [
                codexN(125),
                milestone('_victory'),
              ]),
              PlacementDef(name: 'Nahoot', c: 0, r: 5, minPlayers: 3),
              PlacementDef(name: 'Nahoot', c: 11, r: 3),
              PlacementDef(name: 'Nahadir', c: 2, r: 3),
              PlacementDef(name: 'Nahadir', c: 11, r: 6, minPlayers: 3),
              PlacementDef(name: 'Nahoot', c: 8, r: 8, minPlayers: 4),
              PlacementDef(name: 'Nahadir', c: 4, r: 8, minPlayers: 4),
              PlacementDef(
                  name: 'Hatchery',
                  type: PlacementType.trap,
                  c: 2,
                  r: 6,
                  trapDamage: 3),
              PlacementDef(
                  name: 'Hatchery',
                  type: PlacementType.trap,
                  c: 5,
                  r: 9,
                  trapDamage: 3),
              PlacementDef(
                  name: 'Hatchery',
                  type: PlacementType.trap,
                  c: 9,
                  r: 6,
                  trapDamage: 3),
              PlacementDef(
                  name: 'Hatchery',
                  type: PlacementType.trap,
                  c: 12,
                  r: 7,
                  trapDamage: 3),
              PlacementDef(
                  name: 'morph', type: PlacementType.ether, c: 2, r: 9),
              PlacementDef(
                  name: 'morph', type: PlacementType.ether, c: 10, r: 9),
              PlacementDef(
                  name: 'morph', type: PlacementType.ether, c: 9, r: 3),
              PlacementDef(
                  name: 'morph', type: PlacementType.ether, c: 4, r: 4),
            ],
          ),
          PlacementGroupDef(
            name: 'Desperate',
            adversaries: [
              EncounterFigureDef(
                name: 'Ahma',
                alias: 'Ahma Desperate',
                letter: 'A',
                type: AdversaryType.boss,
                healthFormula: '45*R',
                large: true,
                possibleTokens: [
                  'RxHoard',
                  'Morph',
                  'Morph',
                  'Morph',
                ],
                traits: [
                  'When an adversary is slain, put their standee on Ahma Desperate\'s statistic block. When there are R standees on the statistic block, remove them and add a [Morph] dice. X equals the number of [Morph] dice on the statistic block.',
                ],
                affinities: {
                  Ether.morph: 2,
                  Ether.wind: 2,
                  Ether.water: 1,
                  Ether.crux: -2,
                  Ether.fire: -1,
                },
              ),
              EncounterFigureDef(
                name: 'Briarwog',
                letter: 'B',
                health: 10,
                traits: [
                  '[React] After this unit is attacked from within [Range] 1: The attacker suffers [DMG]1.',
                ],
                affinities: {
                  Ether.water: 1,
                  Ether.morph: 1,
                  Ether.earth: -1,
                  Ether.fire: -1,
                },
                onSlain: [
                  function('increase_ahma_tokens'),
                ],
              ),
              EncounterFigureDef(
                name: 'Dekaha',
                letter: 'C',
                health: 8,
                immuneToForcedMovement: true,
                affinities: {
                  Ether.fire: -2,
                  Ether.wind: -1,
                  Ether.earth: 1,
                  Ether.water: 2,
                },
                onSlain: [
                  function('increase_ahma_tokens'),
                ],
              ),
            ],
            map: MapDef(
              id: '6.5.1',
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
                (0, 0): TerrainType.openAir,
                (0, 1): TerrainType.openAir,
                (0, 2): TerrainType.openAir,
                (0, 6): TerrainType.object,
                (0, 9): TerrainType.openAir,
                (1, 0): TerrainType.openAir,
                (1, 1): TerrainType.openAir,
                (1, 2): TerrainType.openAir,
                (1, 9): TerrainType.dangerous,
                (1, 10): TerrainType.openAir,
                (2, 0): TerrainType.openAir,
                (2, 1): TerrainType.difficult,
                (2, 4): TerrainType.openAir,
                (2, 7): TerrainType.difficult,
                (2, 9): TerrainType.object,
                (3, 0): TerrainType.openAir,
                (3, 1): TerrainType.dangerous,
                (3, 4): TerrainType.object,
                (3, 5): TerrainType.dangerous,
                (3, 9): TerrainType.dangerous,
                (3, 10): TerrainType.openAir,
                (4, 9): TerrainType.openAir,
                (5, 4): TerrainType.difficult,
                (5, 10): TerrainType.openAir,
                (6, 9): TerrainType.openAir,
                (7, 6): TerrainType.difficult,
                (7, 10): TerrainType.openAir,
                (8, 3): TerrainType.dangerous,
                (8, 9): TerrainType.openAir,
                (9, 0): TerrainType.openAir,
                (9, 3): TerrainType.object,
                (9, 4): TerrainType.openAir,
                (9, 7): TerrainType.difficult,
                (9, 9): TerrainType.dangerous,
                (9, 10): TerrainType.openAir,
                (10, 0): TerrainType.dangerous,
                (10, 9): TerrainType.object,
                (11, 0): TerrainType.openAir,
                (11, 1): TerrainType.dangerous,
                (11, 2): TerrainType.difficult,
                (11, 9): TerrainType.openAir,
                (11, 10): TerrainType.openAir,
                (12, 0): TerrainType.dangerous,
                (12, 5): TerrainType.object,
                (12, 8): TerrainType.openAir,
                (12, 9): TerrainType.openAir,
              },
            ),
            placements: [
              PlacementDef(
                name: 'Ahma',
                c: 6,
                r: 8,
                onSlain: [
                  codexN(124),
                  milestone('_victory'),
                ],
              ),
              PlacementDef(name: 'Briarwog', c: 4, r: 7, minPlayers: 4),
              PlacementDef(name: 'Briarwog', c: 1, r: 5, minPlayers: 3),
              PlacementDef(name: 'Briarwog', c: 5, r: 5),
              PlacementDef(name: 'Briarwog', c: 8, r: 4),
              PlacementDef(name: 'Briarwog', c: 10, r: 4, minPlayers: 3),
              PlacementDef(name: 'Briarwog', c: 11, r: 7, minPlayers: 4),
              PlacementDef(name: 'Dekaha', c: 2, r: 1),
              PlacementDef(name: 'Dekaha', c: 11, r: 2),
              PlacementDef(name: 'Dekaha', c: 9, r: 7),
              PlacementDef(name: 'Dekaha', c: 2, r: 7),
              PlacementDef(name: 'Dekaha', c: 5, r: 4, minPlayers: 3),
              PlacementDef(name: 'Dekaha', c: 7, r: 6, minPlayers: 4),
              PlacementDef(
                  name: 'Hatchery',
                  type: PlacementType.trap,
                  c: 0,
                  r: 3,
                  trapDamage: 3),
              PlacementDef(
                  name: 'Hatchery',
                  type: PlacementType.trap,
                  c: 5,
                  r: 9,
                  trapDamage: 3),
              PlacementDef(
                  name: 'Hatchery',
                  type: PlacementType.trap,
                  c: 12,
                  r: 7,
                  trapDamage: 3),
              PlacementDef(
                  name: 'Hatchery',
                  type: PlacementType.trap,
                  c: 9,
                  r: 1,
                  trapDamage: 3),
              PlacementDef(
                  name: 'morph', type: PlacementType.ether, c: 2, r: 9),
              PlacementDef(
                  name: 'morph', type: PlacementType.ether, c: 10, r: 9),
              PlacementDef(
                  name: 'morph', type: PlacementType.ether, c: 9, r: 3),
              PlacementDef(
                  name: 'morph', type: PlacementType.ether, c: 3, r: 4),
            ],
          ),
        ],
      );
}
