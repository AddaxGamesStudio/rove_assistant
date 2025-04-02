import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rove_app_common/style/rove_palette.dart';
import 'package:rove_app_common/style/rove_theme.dart';
import 'package:rove_app_common/widgets/common/rove_dialog.dart';
import 'package:rove_app_common/widgets/common/rove_text.dart';
import 'package:rove_assistant/model/figure.dart';
import 'package:rove_assistant/ui/rove_assets.dart';
import 'package:rove_assistant/model/encounter_model.dart';
import 'package:rove_assistant/ui/widgets/common/minus_plus_row.dart';
import 'package:rove_app_common/widgets/common/rover_action_button.dart';
import 'package:rove_assistant/ui/widgets/encounter/figure_defense.dart';
import 'package:rove_assistant/ui/widgets/encounter/figure_health.dart';
import 'package:rove_assistant/ui/widgets/encounter/selectable_tokens.dart';

class EncounterAllyDetail extends StatefulWidget {
  final EncounterModel model;
  final String name;
  final Function(int, int, List<String>) onStateChanged;

  const EncounterAllyDetail(
      {super.key,
      required this.model,
      required this.name,
      required this.onStateChanged});
  @override
  State<EncounterAllyDetail> createState() => _EncounterAllyDetailState();
}

const _valueWidth = 30.0;

class _EncounterAllyDetailState extends State<EncounterAllyDetail> {
  int health = 0;
  int defense = 0;
  List<String> selectedTokens = [];

  _EncounterAllyDetailState();

  EncounterModel get model => widget.model;

  @override
  void initState() {
    super.initState();
    final figure = model.figureFromTarget(widget.name);
    assert(figure != null);
    if (figure == null) {
      return;
    }
    health = figure.health;
    defense = figure.defense;
    selectedTokens = figure.selectedTokens;
  }

  @override
  setState(void Function() fn) {
    super.setState(() {
      fn();
      widget.onStateChanged(health, defense, selectedTokens);
    });
  }

  Widget _rowHealth(Figure figure) {
    return MinusPlusRow(
        onMinus: () {
          if (health == 0) return;
          setState(() {
            health--;
          });
        },
        onPlus: () {
          if (health == figure.maxHealth) return;
          setState(() {
            health++;
          });
        },
        child: SizedBox(
          width: _valueWidth,
          child: RoverHealth(
              health: health,
              maxHealth: figure.maxHealth,
              minHealthColor: Colors.red.shade300),
        ));
  }

  Widget _rowDefense(Figure figure) {
    return MinusPlusRow(
      onMinus: () {
        if (defense == figure.minDefense) return;
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
          defense: max(defense, figure.minDefense),
        ),
      ),
    );
  }

  onFlipCard(Figure figure) {
    setState(() {
      model.flipAllyCard(figure);
      final flippedFigure = model.figureFromTarget(widget.name);
      assert(flippedFigure != null);
      if (flippedFigure == null) {
        return;
      }
      // Ally card flipping can change min defense
      defense = flippedFigure.defense;
    });
  }

  @override
  Widget build(BuildContext context) {
    final color = RovePalette.ally;
    final figure = model.figureFromTarget(widget.name)!;
    final width = MediaQuery.of(context).size.width;
    final behaviorCount = figure.allyBehaviorCount;
    final canFlipCard = behaviorCount > 1;

    Widget flipButton() {
      return SizedBox(
        width: double.infinity,
        child: RoverActionButton(
            label: 'Flip Card',
            color: color,
            onPressed: () {
              onFlipCard(figure);
            }),
      );
    }

    Widget tokensWidget() {
      return Column(
        children: [
          SelectableTokens(
            possibleTokens: figure.selectableTokens,
            selectedTokens: selectedTokens,
            onSelectedTokensChanged: (tokens) {
              setState(() {
                selectedTokens = tokens;
              });
            },
          ),
        ],
      );
    }

    if (width > 440) {
      return RoveDialog(
        color: color,
        padding: EdgeInsets.all(0),
        hideIcon: true,
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              flex: 3,
              child: ClipPath(
                clipper: ShapeBorderClipper(
                    shape: BeveledRectangleBorder(
                        borderRadius:
                            BorderRadius.only(topLeft: Radius.circular(8)))),
                child: Image.asset(RoveAssets.assetForAlly(
                    figure.allyCardId!, figure.allyBehaviorIndex,
                    expansion: model.encounterDef.expansion)),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                    spacing: RoveTheme.verticalSpacing,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: RoveText(figure.name,
                            style: GoogleFonts.grenze(
                              color: Colors.black54,
                              fontWeight: FontWeight.w600,
                              fontSize: 24,
                            )),
                      ),
                      _rowHealth(figure),
                      _rowDefense(figure),
                      if (figure.selectableTokens.isNotEmpty) tokensWidget(),
                      if (canFlipCard) flipButton(),
                    ]),
              ),
            ),
          ],
        ),
      );
    } else {
      return RoveDialog(
        title: figure.name,
        color: color,
        hideIcon: true,
        body: Column(
            spacing: RoveTheme.verticalSpacing,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: RoveTheme.bevelBorderRadius,
                child: Image.asset(RoveAssets.assetForAlly(
                    figure.allyCardId!, figure.allyBehaviorIndex,
                    expansion: model.encounterDef.expansion)),
              ),
              _rowHealth(figure),
              _rowDefense(figure),
              if (figure.selectableTokens.isNotEmpty) tokensWidget(),
              if (canFlipCard) flipButton(),
            ]),
      );
    }
  }
}
