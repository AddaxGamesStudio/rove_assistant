import 'package:flutter/material.dart';
import 'package:rove_assistant/theme/rove_theme.dart';
import 'package:rove_assistant/model/players_model.dart';
import 'package:rove_assistant/widgets/common/rove_dialog.dart';
import 'package:rove_assistant/widgets/common/rove_text.dart';
import 'package:rove_assistant/widgets/common/rover_action_button.dart';
import 'package:rove_data_types/rove_data_types.dart';
import 'package:rove_assistant/model/encounter/encounter_model.dart';
import 'package:rove_assistant/widgets/common/minus_plus_row.dart';
import 'package:rove_assistant/widgets/encounter/encounter_rover_items.dart';
import 'package:rove_assistant/widgets/encounter/figure_defense.dart';
import 'package:rove_assistant/widgets/encounter/figure_health.dart';
import 'package:rove_assistant/widgets/encounter/figure_index.dart';
import 'package:rove_assistant/widgets/encounter/figure_reaction.dart';
import 'package:rove_assistant/widgets/encounter/player_board_tokens_row.dart';
import 'package:rove_assistant/widgets/encounter/selectable_tokens.dart';

class EncounterFigureDialog extends StatefulWidget {
  final EncounterModel model;
  final String figureName;
  final String figureAsset;
  final List<String> traits;
  final RoverClass? roverClass;
  final Color? accentColor;
  final int health;
  final int maxHealth;
  final int defense;
  final int minDefense;
  final int number;
  final List<String> possibleEncounterTokens;
  final List<String> selectedEncounterTokens;
  final Function(int, int, int, List<String>, bool, List<PlayerBoardToken>)
      onStateChanged;
  // Player
  final Player? player;
  final List<PlayerBoardToken> playerBoardTokens;
  final List<SummonDef> summons;
  final Function(SummonDef)? onSummonRequested;

  EncounterFigureDialog(
      {super.key,
      required this.model,
      required this.figureName,
      required this.figureAsset,
      this.traits = const [],
      this.player,
      this.roverClass,
      this.accentColor,
      required this.health,
      required this.maxHealth,
      this.defense = 0,
      this.minDefense = 0,
      this.number = 0,
      this.playerBoardTokens = const [],
      this.possibleEncounterTokens = const [],
      this.selectedEncounterTokens = const [],
      this.summons = const [],
      required this.onStateChanged,
      this.onSummonRequested})
      : assert(summons.isEmpty || player != null,
            'If summons is not empty, player must not be null'),
        assert(player != null || accentColor != null);

  @override
  State<EncounterFigureDialog> createState() => _EncounterFigureDialogState();
}

const _valueWidth = 30.0;

class _EncounterFigureDialogState extends State<EncounterFigureDialog> {
  int health = 0;
  int defense = 0;
  int number = 0;
  bool hasReacted = false;
  List<String> selectedTokens = [];
  List<PlayerBoardToken> playerBoardTokens = [];

  _EncounterFigureDialogState();

  @override
  void initState() {
    super.initState();
    health = widget.health;
    defense = widget.defense;
    number = widget.number;
    selectedTokens = widget.selectedEncounterTokens;
    playerBoardTokens = widget.playerBoardTokens;
    hasReacted = widget.player != null
        ? widget.model.stateForPlayer(widget.player!).hasReacted
        : false;
  }

  @override
  setState(void Function() fn) {
    super.setState(() {
      fn();
      widget.onStateChanged(health, defense, number, selectedTokens, hasReacted,
          playerBoardTokens);
    });
  }

  Widget _rowHealth() {
    final roverClass = widget.player?.roverClass;
    return MinusPlusRow(
        onMinus: () {
          if (health == 0) return;
          setState(() {
            health--;
          });
        },
        onPlus: () {
          if (health == widget.maxHealth) return;
          setState(() {
            health++;
          });
        },
        child: SizedBox(
          width: _valueWidth,
          child: RoverHealth(
              health: health,
              maxHealth: widget.maxHealth,
              minHealthColor: roverClass?.color ?? Colors.red.shade300),
        ));
  }

  Widget _rowDefense() {
    return MinusPlusRow(
      onMinus: () {
        if (defense == widget.minDefense) return;
        setState(() {
          defense--;
        });
      },
      onPlus: () {
        if (defense >= 9) return;
        setState(() {
          defense++;
        });
      },
      child: SizedBox(
        width: _valueWidth,
        child: FigureDefense(
          defense: defense,
        ),
      ),
    );
  }

  Widget _rowNumber() {
    if (number == 0) return SizedBox.shrink();
    return MinusPlusRow(
      onMinus: () {
        if (number == 1) return;
        setState(() {
          number--;
        });
      },
      onPlus: () {
        if (number >= 20) return;
        setState(() {
          number++;
        });
      },
      child: SizedBox(
        width: _valueWidth,
        child: FigureNumber(
          number: number,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final player = widget.player;
    final roverClass = widget.roverClass ?? player?.roverClass;
    final possibleTokens = widget.possibleEncounterTokens;
    final accentColor = roverClass?.color ?? widget.accentColor!;
    return RoveDialog(
      title: widget.figureName,
      color: accentColor,
      iconAssetPath: roverClass?.iconAsset,
      body: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: RoveTheme.verticalSpacing,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            for (final trait in widget.traits)
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: RoveText(trait),
                ),
              ),
            if (widget.maxHealth > 0) _rowHealth(),
            if (widget.maxHealth > 0) _rowDefense(),
            _rowNumber(),
            if (widget.player != null)
              GestureDetector(
                onTap: () {
                  setState(() {
                    hasReacted = !hasReacted;
                  });
                },
                child: FigureReaction(available: !hasReacted),
              ),
            if (widget.playerBoardTokens.isNotEmpty)
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  PlayerBoardTokensRow(
                    boardTokens: widget.playerBoardTokens,
                    onTokensChanged: (tokens) {
                      setState(() {
                        playerBoardTokens = tokens;
                      });
                    },
                  ),
                ],
              ),
            if (possibleTokens.isNotEmpty)
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SelectableTokens(
                    possibleTokens: possibleTokens,
                    selectedTokens: widget.selectedEncounterTokens,
                    onSelectedTokensChanged: (tokens) {
                      setState(() {
                        selectedTokens = tokens;
                      });
                    },
                  ),
                ],
              ),
            if (player != null &&
                widget.model.itemsForPlayer(player).isNotEmpty)
              SizedBox(
                  height: EncounterRoverItems.height,
                  child:
                      EncounterRoverItems(player: player, model: widget.model)),
            if (widget.player == null && widget.maxHealth > 0)
              SizedBox(
                  width: double.infinity,
                  child: RoverActionButton(
                      label: 'Slay ${widget.figureName}',
                      color: accentColor,
                      onPressed: () {
                        setState(() {
                          health = 0;
                        });
                        Navigator.of(context).pop();
                      })),
            for (var summon in widget.summons)
              SizedBox(
                  width: double.infinity,
                  child: RoverActionButton(
                      label: 'Summon ${summon.name}',
                      roverClass: roverClass!,
                      onPressed: () {
                        widget.onSummonRequested!(summon);
                        Navigator.of(context).pop();
                      }))
          ]),
    );
  }
}
