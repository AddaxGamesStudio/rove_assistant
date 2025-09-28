import 'package:flutter/material.dart';
import 'package:rove_assistant/theme/rove_palette.dart';
import 'package:rove_assistant/theme/rove_theme.dart';
import 'package:rove_assistant/widgets/common/rove_confirm_dialog.dart';
import 'package:rove_assistant/widgets/common/rove_text.dart';
import 'package:rove_assistant/widgets/common/rover_action_button.dart';
import 'package:rove_assistant/widgets/encounter/adversaries/adversary_detail_ability.dart';
import 'package:rove_assistant/widgets/encounter/adversaries/adversary_poster.dart';
import 'package:rove_assistant/widgets/encounter/adversaries/affinities_widget.dart';
import 'package:rove_data_types/rove_data_types.dart';
import 'package:rove_assistant/model/encounter/encounter_model.dart';
import 'package:rove_assistant/widgets/common/minus_plus_row.dart';
import 'package:rove_assistant/widgets/encounter/figure_defense.dart';
import 'package:rove_assistant/widgets/encounter/figure_health.dart';
import 'package:rove_assistant/widgets/encounter/selectable_tokens.dart';

class EncounterAdversaryDetail extends StatefulWidget {
  final EncounterModel model;
  final String name;
  final FigureRole role;
  final AdversaryType adversaryType;
  final String? letter;
  final String asset;
  final List<String> traits;
  final Color? accentColor;
  final bool impervious;
  final int health;
  final int maxHealth;
  final int defense;
  final int minDefense;
  final int number;
  final List<String> possibleEncounterTokens;
  final List<String> selectedEncounterTokens;
  final List<AbilityDef> abilities;
  final Map<Ether, int> affinities;
  final Function(int, int, int, List<String>, bool, List<PlayerBoardToken>)
      onStateChanged;

  const EncounterAdversaryDetail(
      {super.key,
      required this.model,
      required this.name,
      required this.role,
      required this.adversaryType,
      this.letter,
      required this.asset,
      this.traits = const [],
      this.accentColor,
      this.impervious = false,
      required this.health,
      required this.maxHealth,
      this.defense = 0,
      this.minDefense = 0,
      this.number = 0,
      this.possibleEncounterTokens = const [],
      this.selectedEncounterTokens = const [],
      this.abilities = const [],
      this.affinities = const {},
      required this.onStateChanged});

  @override
  State<EncounterAdversaryDetail> createState() =>
      _EncounterAdversaryDetailState();
}

const _valueWidth = 30.0;
const _topRowHeight = 42.0;

class _EncounterAdversaryDetailState extends State<EncounterAdversaryDetail> {
  bool beyondMaxHealth = false;
  int health = 0;
  int defense = 0;
  int number = 0;
  bool hasReacted = false;
  List<String> selectedTokens = [];
  List<PlayerBoardToken> playerBoardTokens = [];

  _EncounterAdversaryDetailState();

  @override
  void initState() {
    super.initState();
    health = widget.health;
    defense = widget.defense;
    number = widget.number;
    selectedTokens = widget.selectedEncounterTokens;
  }

  @override
  setState(void Function() fn) {
    super.setState(() {
      fn();
      widget.onStateChanged(health, defense, number, selectedTokens, hasReacted,
          playerBoardTokens);
    });
  }

  Widget _healthWidget(int health, int maxHealth) {
    return SizedBox(
        width: _valueWidth,
        child: RoverHealth(
          health: health,
          maxHealth: widget.maxHealth,
          textColor: RovePalette.adversaryBackground,
          color: Colors.white,
        ));
  }

  Widget _rowHealth(BuildContext context) {
    return MinusPlusRow(
        color: Colors.white,
        onMinus: () {
          if (health == 0) return;
          setState(() {
            health--;
          });
        },
        onPlus: () {
          if (health == widget.maxHealth && !beyondMaxHealth) {
            showDialog(
                context: context,
                builder: (context) => RoveConfirmDialog(
                      title: 'Increase Health Beyond Max?',
                      color: RovePalette.adversaryHealth,
                      message:
                          'Do you want to increase the health of this adversary beyond their max health? You might want to do this if you are tracking challenges that add health.',
                      onConfirm: () {
                        setState(() {
                          health++;
                          beyondMaxHealth = true;
                        });
                      },
                    ));
            return;
          }
          setState(() {
            health++;
          });
        },
        child: _healthWidget(health, widget.maxHealth));
  }

  Widget _defenseWidget(int defense) {
    return SizedBox(
      width: _valueWidth,
      child: FigureDefense(
        color: Colors.white,
        textColor: RovePalette.adversaryBackground,
        defense: defense,
      ),
    );
  }

  Widget _rowDefense() {
    return MinusPlusRow(
      color: Colors.white,
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
      child: _defenseWidget(defense),
    );
  }

  @override
  Widget build(BuildContext context) {
    final impervious = widget.impervious;
    final possibleTokens = widget.possibleEncounterTokens;
    final affinities = widget.affinities;
    final abilities = widget.abilities;
    final traits = widget.traits;
    final compact = traits.isEmpty && affinities.isEmpty;
    final height = compact ? 300.0 : 440.0;
    return Dialog(
      backgroundColor: RovePalette.adversaryBackground,
      shape: ContinuousRectangleBorder(
        side: BorderSide(width: 4, color: RovePalette.adversaryOuterBorder),
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: RovePalette.adversaryInnerBorder,
            width: 8,
          ),
        ),
        child: Container(
          height: height,
          decoration: BoxDecoration(
            border: Border.all(
              color: RovePalette.adversaryOuterBorder,
              width: 2,
            ),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 240,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      adversaryPoster(),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (traits.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Column(
                                    children: [
                                      for (final trait in traits)
                                        SizedBox(
                                          child: Padding(
                                            padding: const EdgeInsets.all(4),
                                            child: RoveText.trait(trait,
                                                textAlign: TextAlign.center),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      if (possibleTokens.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.only(
                              top: RoveTheme.verticalSpacing,
                              bottom: RoveTheme.verticalSpacing),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SelectableTokens(
                                possibleTokens: possibleTokens,
                                selectedTokens: widget.selectedEncounterTokens,
                                deselectedTintColor:
                                    Colors.white.withValues(alpha: 0.5),
                                onSelectedTokensChanged: (tokens) {
                                  setState(() {
                                    selectedTokens = tokens;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      if (widget.maxHealth > 0 && !impervious)
                        Padding(
                          padding:
                              const EdgeInsets.all(RoveTheme.verticalSpacing),
                          child: SizedBox(
                              width: 80,
                              child: RoverActionButton(
                                  label: 'Slay',
                                  color: RovePalette.adversaryHealth,
                                  onPressed: () {
                                    setState(() {
                                      health = 0;
                                    });
                                    Navigator.of(context).pop();
                                  })),
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Container(
                    height: height,
                    width: 1,
                    decoration: BoxDecoration(color: Colors.white),
                  ),
                ),
                SizedBox(
                  width: 120,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.maxHealth > 0)
                          Container(
                              color: RovePalette.adversaryHealth,
                              width: double.infinity,
                              height: _topRowHeight,
                              child: Center(
                                  child: impervious
                                      ? Padding(
                                          padding: const EdgeInsets.all(6.0),
                                          child: _healthWidget(
                                              widget.health, widget.maxHealth),
                                        )
                                      : _rowHealth(context))),
                        if (widget.maxHealth > 0)
                          Divider(
                            color: Colors.white,
                            height: 2,
                          ),
                        if (widget.maxHealth > 0)
                          SizedBox(
                              width: double.infinity,
                              height: _topRowHeight,
                              child: Center(
                                  child: Center(
                                      child: impervious
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.all(6.0),
                                              child: _defenseWidget(
                                                  widget.defense),
                                            )
                                          : _rowDefense()))),
                        if (widget.maxHealth > 0)
                          Divider(
                            color: Colors.white,
                            height: 2,
                          ),
                        if (affinities.isNotEmpty)
                          Expanded(
                            child: Center(
                              child: AffinitiesWidget(affinities),
                            ),
                          ),
                      ]),
                ),
                for (int i = 0; i < abilities.length; i++) ...[
                  if (i < abilities.length)
                    Container(
                      width: 2,
                      height: double.infinity,
                      color: RovePalette.adversaryOuterBorder,
                    ),
                  AdversaryDetailAbility(
                    ability: abilities[i],
                    i: i,
                    headerHeight: _topRowHeight,
                  ),
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }

  AdversaryPoster adversaryPoster() {
    return AdversaryPoster(
      name: widget.name,
      role: widget.role,
      adversaryType: widget.adversaryType,
      letter: widget.letter,
      number: number,
      asset: widget.asset,
      onNumberMinus: () {
        setState(() {
          number--;
        });
      },
      onNumberPlus: () {
        setState(() {
          number++;
        });
      },
    );
  }
}
