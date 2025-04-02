import 'package:flutter/material.dart';
import 'package:rove_assistant/model/encounter_model.dart';
import 'package:rove_assistant/model/figure.dart';
import 'package:rove_assistant/persistence/preferences_extension.dart';
import 'package:rove_assistant/ui/widgets/encounter/encounter_ally_detail.dart';
import 'package:rove_data_types/rove_data_types.dart';
import 'package:rove_app_common/model/players_model.dart';
import 'package:rove_app_common/persistence/preferences.dart';
import 'package:rove_app_common/style/rove_palette.dart';
import 'package:rove_assistant/ui/styles.dart';
import 'package:rove_assistant/ui/widgets/encounter/encounter_figure_dialog.dart';
import 'package:rove_assistant/ui/widgets/encounter/figure_hexagon.dart';

class EncounterRovers extends StatefulWidget {
  final EncounterModel model;

  const EncounterRovers({
    super.key,
    required this.model,
  });

  @override
  State<EncounterRovers> createState() => _EncounterRoversState();
}

class _ListItem {
  final String name;
  final Player? player;
  final RoverClass? roverClass;
  final String asset;
  final int health;
  final int maxHealth;
  final int defense;
  final int minDefense;
  final List<String> possibleTokens;
  final List<PlayerBoardToken> playerBoardTokens;
  final List<String> tokens;
  final List<SummonDef> summons;
  final double height;
  final bool large;
  final Function(int) setHealth;
  final Function(int)? setDefense;
  final Function(SummonDef)? spawnSummon;
  final Function(bool)? toggleReactionIfNeeded;
  final Function()? flipCard;
  final String? allyCardId;
  final int allyBehaviorIndex;
  final int allyBehaviorCount;

  bool get isAlly => allyCardId != null;

  _ListItem({
    required this.name,
    this.player,
    this.roverClass,
    required this.asset,
    required this.health,
    required this.maxHealth,
    this.defense = 0,
    this.minDefense = 0,
    this.possibleTokens = const [],
    this.playerBoardTokens = const [],
    this.tokens = const [],
    this.summons = const [],
    required this.height,
    required this.setHealth,
    this.large = false,
    this.setDefense,
    this.toggleReactionIfNeeded,
    this.spawnSummon,
    this.flipCard,
    this.allyCardId,
    this.allyBehaviorIndex = 0,
    this.allyBehaviorCount = 1,
  });

  factory _ListItem.fromPlayer(
      {required Player player, required EncounterModel model}) {
    final roverClass = player.roverClass;
    final summons = model.encounterState.summonableSummonsForPlayer(player);
    spawnSummon(summon) =>
        model.setSummonHealth(name: summon.name, health: summon.health);

    final playerState = model.stateForPlayer(player);
    return _ListItem(
      name: player.name,
      player: player,
      asset: roverClass.posterAsset,
      health: playerState.health,
      maxHealth: model.maxHealthForPlayer(player),
      defense: playerState.defense,
      minDefense: roverClass.defense,
      possibleTokens: model.possiblePlayerEncounterTokens,
      playerBoardTokens: playerState.boardTokens,
      tokens: [
        ...model.encounterTokensForPlayer(player),
        ...playerState.encounterTokens
      ],
      summons: summons,
      height: 80,
      setHealth: (health) =>
          model.setPlayerHealth(player: player, health: health),
      setDefense: (defense) =>
          model.setPlayerDefense(player: player, defense: defense),
      toggleReactionIfNeeded: (hasReacted) {
        final bool changed =
            model.stateForPlayer(player).hasReacted != hasReacted;
        if (changed) {
          model.toggleReactionForPlayer(player);
        }
      },
      spawnSummon: spawnSummon,
    );
  }

  factory _ListItem.fromAlly(
      {required Figure ally, required EncounterModel model}) {
    return _ListItem(
        name: ally.name,
        asset: ally.asset,
        health: ally.health,
        maxHealth: ally.maxHealth,
        defense: ally.defense,
        possibleTokens: ally.selectableTokens,
        tokens: ally.selectedTokens,
        height: 80,
        large: ally.large,
        setHealth: (health) {
          // Ally might have changed due to card flipping
          final figure = model.figureFromTarget(ally.name);
          assert(figure != null);
          if (figure == null) {
            return;
          }
          model.setFigureHealth(figure: figure, health: health);
        },
        setDefense: (defense) {
          // Ally might have changed due to card flipping
          final figure = model.figureFromTarget(ally.name);
          assert(figure != null);
          if (figure == null) {
            return;
          }
          model.setFigureDefense(figure: figure, defense: defense);
        },
        allyCardId: ally.allyCardId,
        allyBehaviorIndex: ally.allyBehaviorIndex,
        allyBehaviorCount: ally.allyBehaviorCount,
        flipCard: () => {
              model.flipAllyCard(ally),
            });
  }

  factory _ListItem.fromSummon(
      {required SummonDef summon,
      required Player player,
      required int health,
      required EncounterModel model}) {
    return _ListItem(
        name: summon.name,
        roverClass: player.roverClass,
        asset: player.roverClass.summonAssetForName(summon.name,
            expansion: player.roverClass.expansion),
        health: health,
        maxHealth: summon.health,
        height: 72,
        setHealth: (health) {
          model.setSummonHealth(name: summon.name, health: health);
        });
  }
}

class _EncounterRoversState extends State<EncounterRovers> {
  void showAllyDetail(BuildContext context, _ListItem item) async {
    bool changed = false;
    int? newHealth;
    int? newDefense;
    List<String>? newTokens;
    final model = widget.model;
    await showDialog(
      context: context,
      builder: (_) => EncounterAllyDetail(
        model: model,
        name: item.name,
        onStateChanged: (health, defense, tokens) {
          changed = true;
          newHealth = health;
          newDefense = defense;
          newTokens = tokens;
        },
      ),
    );
    if (!mounted || !changed) return;
    if (newHealth != null && newHealth! != item.health) {
      item.setHealth(newHealth!);
    }
    if (newDefense != null && newDefense! != item.defense) {
      item.setDefense?.call(newDefense!);
    }
    if (newTokens != null && newTokens != item.tokens) {
      final figure = model.figureFromTarget(item.name);
      if (figure != null) {
        model.setFigureTokens(figure: figure, tokens: newTokens ?? []);
      }
    }
  }

  void showDetail(BuildContext context, _ListItem item) async {
    bool changed = false;
    int? newHealth;
    int? newDefense;
    SummonDef? newSummon;
    bool? newHasReacted;
    List<String>? newEncounterTokens;
    List<PlayerBoardToken>? newPlayerBoardTokens;
    await showDialog(
      context: context,
      builder: (_) => EncounterFigureDialog(
        model: widget.model,
        figureName: item.name,
        figureAsset: item.asset,
        player: item.player,
        roverClass: item.roverClass,
        accentColor: RovePalette.title,
        health: item.health,
        maxHealth: item.maxHealth,
        defense: item.defense,
        minDefense: item.minDefense,
        playerBoardTokens: item.playerBoardTokens,
        possibleEncounterTokens: item.possibleTokens,
        selectedEncounterTokens: item.tokens,
        summons: item.summons,
        onSummonRequested: (SummonDef summon) {
          changed = true;
          newSummon = summon;
        },
        onStateChanged: (health, defense, _, encounterTokens, hasReacted,
            playerBoardTokens) {
          changed = true;
          newHealth = health;
          newDefense = defense;
          newHasReacted = hasReacted;
          newEncounterTokens = encounterTokens;
          newPlayerBoardTokens = playerBoardTokens;
        },
      ),
    );
    if (!mounted || !changed) return;
    if (newSummon != null) {
      item.spawnSummon!(newSummon!);
    }
    if (newHealth != null && newHealth! != item.health) {
      item.setHealth(newHealth!);
    }
    if (newDefense != null && newDefense! != item.defense) {
      item.setDefense?.call(newDefense!);
    }
    if (newHasReacted != null) {
      item.toggleReactionIfNeeded?.call(newHasReacted!);
    }
    final player = item.player;
    if (player != null) {
      if (newEncounterTokens != null && newEncounterTokens != item.tokens) {
        widget.model.setPlayerEncounterTokens(
            player: player, tokens: newEncounterTokens!);
      }
      if (newPlayerBoardTokens != null &&
          newPlayerBoardTokens != item.playerBoardTokens) {
        widget.model.setPlayerBoardTokens(
            player: player, boardTokens: newPlayerBoardTokens!);
      }
    }
  }

  toggleReaction(BuildContext context, _ListItem item) {
    if (item.player == null) {
      return;
    }
    widget.model.toggleReactionForPlayer(item.player!);
  }

  decreaseHealth(BuildContext context, _ListItem item) {
    if (item.health <= 0) {
      return;
    }
    item.setHealth(item.health - 1);
  }

  onGestureOfPreference(
      BuildContext context, _ListItem item, String preference) {
    switch (Preferences.instance.getString(preference)) {
      case AssistantPreferences.showDetailValue:
        if (item.isAlly) {
          showAllyDetail(context, item);
        } else {
          showDetail(context, item);
        }
        break;
      case AssistantPreferences.toggleReactionValue:
        toggleReaction(context, item);
        break;
      case AssistantPreferences.decreaseHealthValue:
        decreaseHealth(context, item);
        break;
    }
  }

  Function()? handlerForPreference(
      BuildContext context, _ListItem item, String preference) {
    if (item.player != null
        ? Preferences.instance.hasActionForPlayerGesture(preference)
        : Preferences.instance.hasActionForNonPlayerGesture(preference)) {
      return () => onGestureOfPreference(context, item, preference);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    List<_ListItem> listItems() {
      final model = widget.model;
      final encounterState = model.encounterState;
      List<_ListItem> items = [];
      for (var player in PlayersModel.instance.players) {
        items.add(_ListItem.fromPlayer(player: player, model: model));
        for (var summon in player.roverClass.summons) {
          final summonHealth =
              encounterState.getSummonHealth(name: summon.name);
          if (summonHealth > 0) {
            items.add(_ListItem.fromSummon(
                summon: summon,
                player: player,
                health: summonHealth,
                model: model));
          }
        }
      }
      items.addAll(model.allies
          .where((ally) => ally.health > 0)
          .map((ally) => _ListItem.fromAlly(ally: ally, model: model)));
      return items;
    }

    final padding = const EdgeInsets.only(left: 12, right: 8);

    return ListenableBuilder(
        listenable: widget.model,
        builder: (context, _) {
          return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding: padding,
                    child: Text('Rover Faction',
                        style: RoveStyles.titleStyle(color: Colors.black))),
                Padding(
                  padding: padding,
                  child: Divider(color: Colors.black, thickness: 2),
                ),
                RoveStyles.verticalSpacingBox,
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: padding,
                  child: Row(
                    children: listItems()
                        .map((item) => Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ListenableBuilder(
                                listenable: Preferences.instance,
                                builder: (context, child) {
                                  return GestureDetector(
                                    onDoubleTap: handlerForPreference(
                                        context,
                                        item,
                                        AssistantPreferences
                                            .onDoubleTapUnitPref),
                                    onTap: handlerForPreference(context, item,
                                        AssistantPreferences.onTapUnitPref),
                                    onLongPress: handlerForPreference(
                                        context,
                                        item,
                                        AssistantPreferences
                                            .onLongPressUnitPref),
                                    child: child,
                                  );
                                },
                                child: FigureHexagon(
                                  asset: item.asset,
                                  borderColor: item.player?.roverClass.color ??
                                      RovePalette.title,
                                  height: item.height,
                                  health: item.health,
                                  maxHealth: item.maxHealth,
                                  defense: item.defense,
                                  tileType: item.large
                                      ? TileType.fourHex
                                      : TileType.single,
                                  reactionAvailable: item.player != null
                                      ? !widget.model
                                          .stateForPlayer(item.player!)
                                          .hasReacted
                                      : null,
                                  playerBoardTokens: item.playerBoardTokens,
                                  encounterTokens: item.tokens,
                                ))))
                        .toList()
                        .cast<Widget>(),
                  ),
                )
              ]);
        });
  }
}
