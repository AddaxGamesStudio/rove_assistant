import 'dart:ui';

import 'encounter_def_utils.dart';
import 'package:rove_data_types/rove_data_types.dart';

extension Quest0 on EncounterDef {
  static EncounterDef get encounter0dot1 => EncounterDef(
        questId: '0',
        number: '1',
        title: 'Fling to the Hollow Gale',
        setup: EncounterSetup(box: '0', map: '3', adversary: '2'),
        victoryDescription: 'Hold out against the galelings.',
        terrain: [
          EncounterTerrain('difficult',
              title: 'Difficult Terrain',
              body:
                  'Spaces with a blue border and the [difficult] icon slows your movement down. It costs an extra movement point to dash [dash] into these spaces (pg. 24).'),
          EncounterTerrain('object',
              title: 'Objects',
              body:
                  'Spaces with a yellow border and the [object] icon block dash [dash] actions (pg. 25).'),
        ],
        roundLimit: 4,
        baseLystReward: 10,
        campaignLink:
            'Encounter 0.2 - “**When Each Thing Joy Supplied**” [campaign] **8**.',
        dialogs: [introductionFromText('quest_0_encounter_1_intro')],
        onLoad: [
          dialog('Introduction'),
          codexLink('Its Sullen Sound',
              number: 1,
              body:
                  'After all Rovers have taken their turn and performed two abilities, the Rover phase is over, advance the phase and read [title], [codex] 2.'),
          rules('Abilities',
              '''For this first round, focus on your abilities (pg. 58). Abilities are the four tiles you inserted into your player board during setup. When it’s your turn, you will perform two of these abilities. Focus on your abilities that let you Dash [dash] X (pg. 28) or Jump [jump] X (pg. 29) and either Melee Attack [m_attack] or Range Attack [r_attack] (pg. 33).

Rove is played in phases, and the first phase is the Rover phase (pg. 58), which means you get to take your turns first. Decide amongst players in what order you would like to take your turns.

When your turn begins, use your ability that contains a [dash] X or [jump] X action to move closer to the galelings, then attack one of them with an ability that contains either a [m_attack] action or [r_attack] action. Each attack has a Range [range] X value (pg. 33), which explains how far away an enemy can be for you to be able to target them. Make sure to use your dash or jump action to get within range of the attack you would like to perform.

When you attack an enemy, roll the damage dice, adjust your damage [dmg] based on your ether affinity which is found on your class board, and resolve damage against your target (pg. 36). To track the damage you deal to adversaries, scroll down to Adversaries, select the corresponding one and decrease their health [HP]. You can also place physical damage chits within the slot that matches their standee number in the damage tracker (pg. 27).

Your ability tiles slide within the slot they are placed into. When you activate an ability, slide it within its slot revealing the red X to indicate that you’ve used one of your ability activations.

After you dismiss this prompt note the **Codex Links** section for the encounter. When you meet the condition of a codex link entry, read that entry. Most of the times this will happen automatically as you slay adversaries or advance phases. In this case, once each Rover has taken their turn advance the phase by pressing the > button and we’ll go over how adversaries take their turns.''')
        ],
        onMilestone: {
          '_codex1': [
            codex(1),
            codexLink('Now With Rising Knell',
                number: 2,
                body:
                    'After all adversaries have taken their turns, the adversary phase is over. With all phases completed the round ends, read [title], [codex] 2.'),
            rules('Adversary Rules',
                '''Now that we’ve completed the Rover phase, it’s time for the adversaries to act during the adversary phase (pg. 59). Each adversary unit will get a turn. They activate in the order they are printed in the adversary book, from left to right, top to bottom. When a unit type is activated, the individual units a part of that unit type activate in standee number order, from least to greatest.

During the first round of any given encounter, adversaries always perform their first ability, the ability printed on the left side of their statistic block in the adversary book (pg. 46). This means the galelings will perform their Scything Strike ability. This ability contains two actions, a [jump] action and a [m_attack] action, separated by an action separator icon.

Adversaries follow a simple logic pattern depending on the primary action they are performing. For Scything Strike, the primary action is the single target [m_attack] action. Because of this, the galelings will follow the single target attack logic (pg. 47). The galelings will use their [jump] action that precedes their [m_attack] action to move into range of their nearest enemy who also has the most hit points to attack them.

Adversaries will use the fewest number of movement points required to get to their intended target. Double check the rules for the jump action, difficult terrain, and objects. A unit that jumps ignores the extra movement cost of difficult terrain and the dash blocking nature of objects.

Adversaries resolve damage the same way Rovers do, rolling the damage dice and comparing it to their ether affinity.

After you dismiss this prompt note that there is a new Codex Link. Triggering codex link entries will often reveal new codex links.'''),
          ],
          '_codex2': [
            codex(2),
            codexLink('Some Little Cheering',
                number: 3,
                body: 'After the Rover phase ends, read [title], [codex] 3.'),
            rules('More Abilities',
                '''Be sure to refresh your abilities, by sliding all of your ability tokens so that the green check is visible, indicating they are available to be used. In the previous round we stuck to just the abilities that allowed you to move and attack, but Rovers have several interesting tricks they can perform. Let’s look at the other abilities each Rover has access to.

**True Scale**:  The True Scale can heal [recover] themselves with the Take Stock ability (pg. 37). Take Stock can only target the True Scale because of its limited range. Also, the True Scale can force an enemy to dash in a path of their choosing with their Seize ability.

**Shadow Piercer**: The Shadow Piercer can activate their Reknit ability, with its heal [recover] action, to heal their allies near to themselves, as denoted by the limited range (pg. 21). to heal their allies, as denoted by the limited range  Also, the Shadow Piercer can activate the Brace ability, which adds range to their next range attack [r_attack]. 

**Flash**: The Flash has two attack abilities, Sear and Gale. For now let’s focus on the Gale ability with its range attack [r_attack] action that has a push [push] effect (pg. 30). Pushing an enemy is a powerful effect which will become more apparent as we get further into this quest, but for now let’s read about impact damage (pg. 31).

The Flash also has the unique ability Channel which allows you to modify the ether dice in your ether pools. We will go over this in more detail next round. For now, focus on your Gale ability and try to push a galeling into a tree stump.

**Sophist**: The Sophist has some unique abilities with Manifest and Inspire. Manifest allows the Sophist to place one of their Luminescent Hyperbola glyphs onto the map. Glyphs follow the conjuration rules (pg 38). Double check the ally card for Luminescent Hyperbola, as the glyph has a unique trait that affects enemies that occupy the same space as the glyph.

Inspire is an ability that allows the Sophist to grant a [dash] 3 action to their allies or one of their glyphs. Speak with your allies to see if the granted movement might allow them to get into a position they normally couldn’t on their own turn. If you grant the dash action to one of your glyphs, you control the action. Do this to get a glyph into the same space as an enemy.

**Dune Dancer**: The Dune Dancer has two abilities that contain an attack action, Carve and Erosion. Take note that these abilities have a qualifier before them. You can’t use both Carve and Erosion within the same turn.

The Dune Dancer also has access to the Barter ability. Barter allows you to use the Trade action (pg. 38), a useful ability that allows you to trade one of your ether dice from your personal pool with an ether dice from the personal pool of one of your Rover allies. We’ll cover ether dice in more detail next round, for now trading an ether dice with an ally can be useful if you wish to allow them a chance to recover [recover] (pg. 37) some of their hit points.

We covered a lot of new actions and effects. For this round, move, attack, recover hit points, push, and otherwise strike back at your enemy, using the two abilities of your choice.''')
          ],
          '_codex3': [
            codex(3),
            codexLink('Though Restless Still Themselves',
                number: 4,
                body:
                    'After the adversary phase ends, read [title], [codex] 4.'),
            rules('Rending Talons',
                '''For this round we will keep determining the adversary ability simple by advancing their ability token forward one space (pg. 34) to the Rending Talons ability.

If you look at Rending Talons it has a target [target] line, with a value of 2. This means that galeling can attack up to 2 different enemies with this action, both of which must be within range. Adversaries follow different logic for multiple target attacks (pg. 31) where they prioritize maximizing targets attacked.

Adversaries will revert to single-target attack logic if they can’t attack more than one target with their multi-target attacks.

It’s good to be aware that adversaries have competing movement logic when attacking multiple targets. Adversaries prioritize attacking multiple targets over moving fewer spaces.

When resolving damage for multi-target attacks, the damage dice is rolled and attack resolution is followed for each target separately (pg. 47).

That’s enough for now, resolve the adversary phase and good luck weathering their attacks.''')
          ],
          '_codex4': [
            codex(4),
            codexLink('The Last, Last Purple Streaks of the Day',
                number: 5,
                body: 'After the Rover phase ends, read [title], [codex] 5.'),
            rules('Rally Skill Cards',
                '''You’ve done well so far, but it’s time to tap into the ether of your surroundings if you’re going to clear out this nest. Ether is the magic of Chorus (pg. 20), a metaphysical energy that brings the elements of the world to life. Your skill cards are how you will both generate and spend the ether you need to win the fights ahead of you.

First, let’s read about ether dice (pg. 20). This very important game component represents the primary resource system of the game. For this round play a rally skill card (pg. 40) to generate an ether dice and add it to your personal pool on the left side of your player board (pg. 21). Don’t forget to flip your skill card after playing it (pg. 42).

Some things to keep in mind, you can activate two abilities and play one skill card during each of your turns (pg. 58-59). If the rally skill card you play has this icon [generate], the ether dice you generate is random. Some rally skill cards generate a specific ether dice, if this is the case, the specific ether icon will be present (pg. 38).

Skill cards can have action separator icons and or action flow icons. If the actions are separated by an action flow icon, the preceding action must be performed in order to perform the following action. You will notice the majority of ether generating icons are preceded by an action flow icon, meaning you’ll have to do something in order to generate that ether dice.

With rally skill cards several new actions, effects, and icons are made available to you.

There are positive and negative action icons (pg. 28). A positive action can target yourself and or an ally, depending on range restrictions. A negative action targets your enemies.

Some positive and healing actions have the defense [def] X effect (pg. 37). A unit targeted with the [def] effect gains a number of defense tokens [def] denoted by the value of X. [def] is used during damage resolution. The damage of an attack is reduced by the defense of the target. A unit that has [def] token removes them at the start of their turn.

Many of your skills can also place ether field tiles (pg. 26), which are placed onto the map and have a variety of effects. Be sure to read the timing statement and effects of each ether field carefully. Check your player board to learn what your [aura] and or [miasma] do when triggered. Adversaries will be able to place these two ether fields later in the campaign. Check the campaign sheet (pg. 61) to learn what adversary [aura] and [miasma] fields do.'''),
          ],
          '_codex5': [
            codex(5),
            codexLink('In Echo Sweet Replies',
                number: 6,
                body:
                    'After the adversary phase ends, read [title], [codex] 6.'),
            rules('Ability Dice and Reactions',
                '''The swarm is becoming frenzied. For this round to determine which ability the galelings will perform, roll the ability dice (pg. 46), and advance their ability token the number of spaces equal to the result of the ability dice. If the ability token would advance past the galelings fourth ability, it wraps around to their first ability instead.

Be aware that for all encounters after this one, at the start of the adversary phase during round 2 and each round after that, you will roll the ability dice to determine what ability adversaries perform. The ability dice is rolled separately for each adversary type.

If the ability rolled was Rending Swoop, this introduces the Ignore Defense [pierce] effect (pg. 37). This is an attack effect where the damage of an attack ignores the defense [def] value of the target.

If the Fleeing Shot ability was rolled, this introduces a special logic mechanic (pg. 47). Adversaries have a standard list of logic that they will follow for most of their actions, however, sometimes adversaries may operate in unexpected ways, and this is noted by the “Logic” qualifier. In the case of Fleeing Shot, if a galeling performs their ranged attack, they will want to retreat from their enemies (pg. 47), meaning they want to use their movement to maximize the distance from the most enemies that they can.

Rovers have another trick in their toolkit, reaction cards . During each round, Rovers can perform one reaction. Use the reaction token as a reminder aid to keep track of if you’ve performed your reaction or not.

Pay special attention to your reaction timing statements. Reaction cards can be used any time during their timing statement (as long as your reaction activation is available), which can occur during almost any phase of the game.

Your reaction activation refreshes during the start phase of a round. This means that at the beginning of the round, flip your reaction token to its available side.

Weather one last round of adversary attacks and try your best to use your reactions.''')
          ],
          '_codex6': [
            codex(6),
            codexLink('The Joy of Young Ideas',
                number: 7,
                body:
                    'Immediately after the Rover phase ends, or if all adversaries are slain, read [title], [codex] 7.'),
            rules('Rave Skill Cards',
                '''Now that you’ve generated some ether dice, it’s time to play one of your Rave skill cards (pg. 41). Raves are powerful skill cards that require you to infuse a number of ether dice equal to the number of pips at the top center of the card. To do this, move the dice from your personal pool to the skill card, perform the actions on the skill card, move the dice used to play the skill to your infusion pool (pg. 21), then flip the skill card over. Be sure not to flip the dice during this, keep the facing the same from your personal pool to the infusion pool.

The Shadow Piercer’s transform Raves are especially powerful and taxing, thus require you to spend an ability activation to use. To represent this, slide one of your abilities revealing the red X without performing the ability when paying for the Rave.

Some skill cards have special flip instructions [flip]. You must execute these mandatory instructions when you flip the card with the special instruction. 

This is a good time to discuss the summon action (pg. 39). With the Dune Dancer’s Dearest Friend rave they can summon the ardorok. Summons take their turn during their creator’s turn, performing the ability on their summon card. It’s worth mentioning here that actions are discrete moments in the game. What this means is the Dune Dancer can’t command their summons to act during the middle of an action.

Many actions will have augments that can be earned. The most common augment for rave skill cards is the ether check. What this cost means is if you infused the listed ether dice when paying for the Rave skill card, you gain the bonus.

The most common augment for abilities and rallies is ether drain. What this cost means is you must return the listed ether dice from your personal pool to the general pool and replace it with a dim dice to gain the bonus. You can still use dim dice to pay for typeless costs, such as the common cost to play Rave skill cards.

Many attack actions have a target pattern (pg. 34). Target patterns allow an action to affect many units at once. [m_attack] actions with a target pattern have a gray hex to indicate where the performer is. [r_attack] actions with a target pattern have a primary space indicator. The primary space of a target pattern must be within the range of the action.

Pay attention to any other target restrictions. For Rovers, a target pattern can often only affect up to 3 different targets within the pattern. 

This is a good time to discuss effect resolution order (pg. 36). Some actions, especially attack actions found within Raves, can have multiple layered effects. The damage of an attack is resolved first, then push or pull effects are resolved, then ether fields are placed, then all other effects are resolved. If the target of an attack with an ether field effect is slain due to damage dealt, the ether field is still placed in the space that the target occupied.''')
          ],
          '_victory': [
            codex(7),
            victory(
                body:
                    '''Congratulations on your first victory! Rovers gain 10xR [lyst]. **Lyst** [lyst] is the currency of Rove. R stands for the number of Rovers (pg. 62). That means R will equal 2, 3, or 4. Many things in the game can reference the value of R. Record the [lyst] you earned on your campaign sheet (pg. 61). *[The app does this automatically.]*'''),
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
            standeeCount: 8,
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
                RoveAction.rangeAttack(2),
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
        setup: EncounterSetup(
            box: '0',
            map: '4',
            adversary: '3',
            tiles:
                '3x Bursting Bells, 4x Hoards, 1x Treasure Chest, 1x Nektari Hive'),
        victoryDescription: 'Get to the exit hexes.',
        terrain: [
          EncounterTerrain('dangerous',
              title: 'Dangerous Terrain',
              damage: 1,
              body:
                  'Spaces with a red border and the dangerous [dangerous] icon damage non-flying units that enter into them. Non-flying units that enter into thick bramble suffer [DMG] 1 (pg. 24).'),
          EncounterTerrain('trap_bursting_bell',
              title: 'Bursting Bell Trap',
              damage: 2,
              body:
                  'Bursting Bell Trap tiles are placed throughout the map. Units that enter into these spaces trigger the trap, suffering [DMG] 2 (pg. 25), then the trap tile is removed.'),
          EncounterTerrain('open_air',
              title: 'Open Air',
              body:
                  'Spaces with white borders and the open air [open_air] icon are open air spaces (pg. 24). You can attempt to push [push] enemies into open air spaces, where they could fall (pg. 32).'),
          EncounterTerrain('hoard',
              title: 'Hoard',
              body:
                  'You have the chance to earn extra loot. There are hoard tiles (pg. 26) across the map, most likely Mo and Makaal’s dropped cargo. Try to grab what you can!'),
          EncounterTerrain('treasure',
              title: 'Treasure Chest',
              body:
                  'There’s a treasure chest as well (pg. 26). Treasure chests are usually locked, so you’ll have to search for the key if you want to open it.'),
          EncounterTerrain('nektari_hive',
              title: 'Nektari Hive',
              body:
                  'There is a nektari hive. These are special objects (pg. 25). It has R*2 [HP]. If you destroy it you can grab the nektari pollen inside. Is there something shiny within it?'),
          EncounterTerrain('ether_node',
              title: 'Ether Nodes',
              body:
                  'Spaces with a green border and an ether icon are ether nodes [ether_node] (pg. 25). During map setup, place the ether dice shown onto the ether node space. Almost every encounter will have some type and number of ether nodes. You’ll find the rules for these nodes within the terrain section of an encounter. Remember, Rovers that are adjacent to an ether node and performing a [dash] or [jump] action can spend one movement point to grab the ether dice from the node, adding that dice to their personal pool.'),
          EncounterTerrain('ether_node_earth',
              title: 'Earth Ether Node',
              body:
                  'Units that end their turn within [Range] 1 of this object recover [HP] 1.')
        ],
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
        dialogs: [
          introductionFromText('quest_0_encounter_2_intro'),
        ],
        onLoad: [
          dialog('Introduction'),
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
          rules('Overgrown Climb',
              '''Make sure that you’ve read the terrain rules above. There’s dangerous terrain, traps, and open air you can use against your enemy. Try to benefit from the [earth] ether node while denying the same to adversaries.'''),
          rules('Adversary Traits',
              'Adversaries will often have traits (pg. 46). Check the dekahas statistic block to read their traits. Dekahas are deeply rooted. They can not move, can not be forced to move, and can not be pushed or pulled.'),
        ],
        onMilestone: {
          '_codex9': [
            codex(9),
            codexLink('Perchance Her Acorn-Cups to Fill',
                number: 11,
                body:
                    'After the adversary phase ends, read [title], [codex] 9.'),
            rules('Adversary Healing',
                '''Some adversaries can perform the heal [recover] action. If the action can only target one unit, the adversary follows single-target healing logic (pg. 47), which has the adversary healing the most damaged unit they are allied with or themselves, within range of the action. Keep in mind, this is the most damaged unit, which is not necessarily the unit with the fewest [hp]. If there are no damaged units within range of the action, the adversary will target themselves. This is because adversary heal actions will often place ether fields.

Remember, this is the first round of the encounter, adversaries will perform the first ability within their ability track. For galelings that’s Scything Strike and for dekahas that’s Water Spout.'''),
          ],
          '_codex10': [
            codex(10),
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
            codex(11),
            codexLink('Well thy Gold and Purple Wing',
                number: 12,
                body: 'After the Rover phase ends, read [title], [codex] 10.'),
            rules('Infused Ether and Equipment',
                '''So far so good. It’s the start of a new round which means your abilities and reaction refresh. Hopefully you’ve had a chance to generate some ether. It may be a good idea to infuse some ether from your personal pool into your infusion pool in order to play a rave skill card this round. If you do, you could use your equipment (pg. 43).

When you infuse ether from your personal pool (the slot on the top left side of your player board), you place that ether into your infusion pool (the slot on the bottom left side of your player board). From there you may spend the ether dice to activate your equipment. Most equipment will have a timing statement that includes an ether cost, if you spend the indicated ether from your infusion pool (return ether dice to the general pool) during the timing window of the equipment, you gain the effect of that equipment.

When you use your equipment it becomes exhausted. To indicate this, turn the item 90 degrees. Exhausted equipment refreshes during the start phase of a round, along with your abilities and reaction token.'''),
            rules('Ether Limit',
                '''Each class can store a limited number of ether dice in their ether pool or infusion pool. Your ether limit is written on your class board. An ether check is performed at the end of your turn and each pool of ether is checked separately. For most classes, they can store up to 3 dice in either their personal pool or infusion pool. The Flash, a being composed of pure ether, can store 4 ether in their personal pool and infusion pool.'''),
            rules('Consumables',
                '''You have access to consumables [p] (pg. 44). These are one time use items that usually don’t require ether to use and have a powerful effect. Just like equipment, consumables have a timing statement for when they can be used. When you use a consumable item, flip it over. At the end of the encounter, if you won the encounter, return the consumable to the store (more about the store in a later encounter). If however the encounter was failed, all used consumables are flipped face up and stay with their owners (pg. 60).'''),
            rules('Revive',
                '''Roving is a dangerous profession and you may need to be picked back up by a friend. If a Rover’s [hp] is brought to 0, they are downed (pg. 38). If this happens, an ally can use a Powdered Drakaen consumable to gain access to the Revive action (pg. 37). A recently revived Rover can still take their full turn. Because of this powerful effect, it’s best if each Rover carries at least one Powdered Drakaen on them at all times.'''),
          ],
          '_codex12': [
            codex(12),
            codexLink('Close Dungeon of Innumerous Boughs',
                number: 14,
                body:
                    'Immediately when all Rovers occupy an [exit] space, read [title], [codex] 11.'),
            rules('Other Adversary Logic',
                '''It’s the beginning of the adversary phase during round 2. That means you need to roll the ability dice for each adversary type and advance their ability token a number of spaces equal to the result on the ability dice. This will be the ability that each adversary will perform this round. Each of the dekahas other three abilities introduce something new.'''),
            rules('Adversary Pushing and Pulling',
                '''Adversaries can push and pull their enemies too (pg. 47). The Dekahas Hydraulic Whip ability has an attack action with a push [push] 2 effect. Adversaries are aware of traps, dangerous terrain, and the impact damage rule. They will try to push you into these areas in such a way to maximize damage. Otherwise, if adversaries can’t maximize damage by pushing or pulling you, they’ll push or pull you to maximize distance.'''),
            rules('Traps',
                '''Both adversaries and Rovers can place traps onto the map. Rovers that can place traps have special trap tiles in their class box, while adversaries share the same trap tile. Traps are a tile, so be sure you’re familiar with the tile placement rules (pg. 27). The action that places the trap explains any restrictions to placement and the effects of the trap. You can place damage chits onto the trap tile as a reminder of how much damage it does.'''),
            rules('Multi-Target Healing',
                '''The last bit of logic we will cover is multi-target healing (pg. 47). Adversaries want to heal as many damaged targets as possible, preferring closer targets over further targets. If there aren’t enough damaged targets to choose from to maximize targets healed, adversaries will target the closest adversary units, even if they’re at maximum [hp].'''),
          ],
          '_victory': [
            codex(14),
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
              codex(13),
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
          const PlacementDef(name: 'Galeling', c: 7, r: 5, minPlayers: 3),
          const PlacementDef(name: 'Galeling', c: 9, r: 0, minPlayers: 3),
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
            PlacementDef(name: 'Nektari Swarm', c: 11, r: 5),
            PlacementDef(name: 'Nektari Swarm', c: 11, r: 5),
            PlacementDef(name: 'Nektari Swarm', c: 11, r: 5, minPlayers: 3),
            PlacementDef(name: 'Nektari Swarm', c: 11, r: 5, minPlayers: 4),
          ])
        ],
        overlays: [
          EncounterFigureDef(
            name: 'Hoard',
            lootable: true,
            onLoot: [
              codex(8),
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
            standeeCount: 8,
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
                RoveAction.rangeAttack(2),
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
              standeeCount: 6,
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
              name: 'Nektari Swarm',
              letter: 'C',
              standeeCount: 4,
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
        setup: EncounterSetup(
            box: '0',
            map: '5',
            adversary: '4',
            tiles: '3x Bursting Bells, 2x Nektari Hives'),
        victoryDescription: 'Slay the Galeaper Queen.',
        terrain: [
          EncounterTerrain('dangerous_thick_bramble',
              title: 'Thick Bramble',
              damage: 1,
              body:
                  'Non-flying units that enter a thick bramble space suffer [DMG] 1.'),
          EncounterTerrain('trap_bursting_bell',
              title: 'Bursting Bell Trap',
              damage: 2,
              body: 'Units that trigger Bursting Bell traps suffer [DMG] 2.'),
          EncounterTerrain('nektari_hive',
              title: 'Galeaper Hive Entrance',
              body:
                  'Galeleaper Hive Entrances (use Nektari Hive tiles) are special objects with R*2 [HP].'),
          etherWind(),
          EncounterTerrain('barrier',
              title: 'Barrier',
              body:
                  'Spaces with a black border and the barrier [barrier] icon are out of bounds (pg. 24). No unit, tile, or token can enter into these spaces, and they block line-of-sight (pg. 29).'),
        ],
        roundLimit: 8,
        baseLystReward: 10,
        itemRewards: ['Cutting Galewing'],
        unlocksRoverLevel: 2,
        campaignLink: 'Chapter 1 - “**A Choice**”, [campaign] **12**.',
        dialogs: [
          introductionFromText('quest_0_encounter_3_intro'),
        ],
        onLoad: [
          dialog('Introduction'),
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
          rules('Errata',
              '''The 1st printing Adversary Book for this encounter shows the Galeaper Queen twice instead of the Galeaper. The first adversary should be the Galeaper. Click on any Galeaper to see their abilities.'''),
          codexLink('Borne in Heedless Hum',
              number: 15,
              body:
                  '''Immediately when the Galeaper Queen is slain, read [title], [codex] 11.'''),
        ],
        onMilestone: {
          '_victory': [
            codex(15),
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
          const PlacementDef(name: 'Galeaper', c: 8, r: 4, minPlayers: 4),
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
              standeeCount: 8,
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
                      type: RoveActionType.dash,
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
              standeeCount: 6,
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
              standeeCount: 1,
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
                  RoveAction.meleeAttack(3, pierce: true, push: 3)
                ]),
                AbilityDef(name: 'Frenzy Swarm', actions: [
                  RoveAction(
                      type: RoveActionType.command,
                      object: 'Galeaper',
                      range: RoveAction.anyRange,
                      targetCount: 2,
                      targetKind: TargetKind.ally,
                      children: [
                        RoveAction.move(2),
                        RoveAction.rangeAttack(2, endRange: 2)
                      ]).withPrefix('The nearest two Galeapers perform:')
                ]),
                AbilityDef(name: 'Queen\'s Call', actions: [
                  RoveAction(
                      type: RoveActionType.spawn,
                      object: 'Galeaper',
                      amountFormula: 'R-1',
                      range: (
                        1,
                        1
                      )).withDescription(
                      'Spawn R-1 Galeapers within [range] 1 of this unit, closest the nearest enemy.')
                ]),
              ]),
        ],
      );
}
