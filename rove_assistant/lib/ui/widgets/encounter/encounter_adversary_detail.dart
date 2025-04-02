import 'package:flutter/material.dart';
import 'package:rove_app_common/style/rove_palette.dart';
import 'package:rove_app_common/style/rove_theme.dart';
import 'package:rove_app_common/widgets/common/image_shadow.dart';
import 'package:rove_app_common/widgets/common/rove_text.dart';
import 'package:rove_assistant/ui/rove_assets.dart';
import 'package:rove_assistant/ui/widgets/common/rove_icon.dart';
import 'package:rove_data_types/rove_data_types.dart';
import 'package:rove_assistant/model/encounter_model.dart';
import 'package:rove_assistant/ui/widgets/common/minus_plus_row.dart';
import 'package:rove_app_common/widgets/common/rover_action_button.dart';
import 'package:rove_assistant/ui/widgets/encounter/figure_defense.dart';
import 'package:rove_assistant/ui/widgets/encounter/figure_health.dart';
import 'package:rove_assistant/ui/widgets/encounter/figure_index.dart';
import 'package:rove_assistant/ui/widgets/encounter/selectable_tokens.dart';

class EncounterAdversaryDetail extends StatefulWidget {
  final EncounterModel model;
  final String name;
  final FigureRole role;
  final AdversaryType adversaryType;
  final String? letter;
  final String asset;
  final List<String> traits;
  final Color? accentColor;
  final int health;
  final int maxHealth;
  final int defense;
  final int minDefense;
  final int number;
  final List<String> possibleEncounterTokens;
  final List<String> selectedEncounterTokens;
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
      required this.health,
      required this.maxHealth,
      this.defense = 0,
      this.minDefense = 0,
      this.number = 0,
      this.possibleEncounterTokens = const [],
      this.selectedEncounterTokens = const [],
      this.affinities = const {},
      required this.onStateChanged});

  @override
  State<EncounterAdversaryDetail> createState() =>
      _EncounterAdversaryDetailState();
}

const _valueWidth = 30.0;
const _padding = 8.0;

class _EncounterAdversaryDetailState extends State<EncounterAdversaryDetail> {
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

  Widget _rowHealth() {
    return MinusPlusRow(
        color: Colors.white,
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
            textColor: RovePalette.adversaryBackground,
            color: Colors.white,
          ),
        ));
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
      child: SizedBox(
        width: _valueWidth,
        child: FigureDefense(
          color: Colors.white,
          textColor: RovePalette.adversaryBackground,
          defense: defense,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final possibleTokens = widget.possibleEncounterTokens;
    final affinities = widget.affinities;
    final traits = widget.traits;
    final compact =
        traits.isEmpty && possibleTokens.isEmpty && affinities.isEmpty;
    final height = compact ? 300.0 : 400.0;
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
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: 240,
                  ),
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
                      if (widget.maxHealth > 0)
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
                            child: Center(child: _rowHealth())),
                      if (widget.maxHealth > 0)
                        Divider(
                          color: Colors.white,
                          height: 2,
                        ),
                      if (widget.maxHealth > 0)
                        SizedBox(
                            width: double.infinity,
                            child: Center(child: _rowDefense())),
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
            ],
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

class AdversaryPoster extends StatelessWidget {
  final String name;
  final FigureRole role;
  final AdversaryType adversaryType;
  final String? letter;
  final String asset;
  final int number;
  final Function onNumberMinus;
  final Function onNumberPlus;

  Widget _rowNumber() {
    if (number == 0) return SizedBox.shrink();
    return MinusPlusRow(
      color: Colors.white,
      onMinus: () {
        if (number == 1) return;
        onNumberMinus();
      },
      onPlus: () {
        if (number >= 20) return;
        onNumberPlus();
      },
      child: SizedBox(
        width: _valueWidth,
        child: FigureNumber(
          number: number,
        ),
      ),
    );
  }

  const AdversaryPoster({
    super.key,
    required this.name,
    required this.role,
    required this.adversaryType,
    this.letter,
    required this.number,
    required this.asset,
    required this.onNumberMinus,
    required this.onNumberPlus,
  });

  @override
  Widget build(BuildContext context) {
    final showType = role == FigureRole.adversary;
    return Stack(children: [
      AspectRatio(
        aspectRatio: 1,
        child: Image.asset(asset, width: double.infinity, fit: BoxFit.cover),
      ),
      Container(
        color: Colors.black.withValues(alpha: 0.5),
        width: double.infinity,
        padding: EdgeInsets.all(_padding),
        child: Row(
          spacing: 2,
          children: [
            Flexible(
              child: Align(
                alignment: Alignment.centerLeft,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: RoveText.subtitle(name),
                ),
              ),
            ),
            if (showType)
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: RoveAssets.iconForAdversaryType(adversaryType),
              ),
            if (letter != null)
              RoveText.label(letter ?? '', color: Colors.white),
          ],
        ),
      ),
      Positioned(
        bottom: _padding * 2,
        right: 0,
        child: _rowNumber(),
      ),
      Positioned(
        bottom: _padding,
        left: 0,
        right: 0,
        child: SizedBox(
          child: Divider(
            height: 2,
            indent: _padding,
            endIndent: _padding,
            color: Colors.white,
          ),
        ),
      ),
    ]);
  }
}

class _ShadowIcon extends StatelessWidget {
  final String name;
  final Color? color;

  const _ShadowIcon(this.name, {required this.color});

  @override
  Widget build(BuildContext context) {
    return ImageShadow(child: RoveIcon(name, color: color));
  }
}

class AffinitiesWidget extends StatelessWidget {
  final Map<Ether, int> affinities;

  const AffinitiesWidget(
    this.affinities, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const ethers = [
      Ether.fire,
      Ether.water,
      Ether.earth,
      Ether.wind,
      Ether.crux,
      Ether.morph
    ];
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: RoveTheme.horizontalSpacing,
      children: [
        Column(
            mainAxisSize: MainAxisSize.min,
            spacing: RoveTheme.verticalSpacing,
            children: [
              _ShadowIcon(
                'ether_attack',
                color: Colors.white,
              ),
              ...ethers
                  .map((e) => _ShadowIcon(e.name.toLowerCase(), color: null)),
              if (affinities.containsKey(Ether.dim))
                Image.asset(
                  RoveAssets.assetForEther(Ether.dim),
                  width: 24,
                  height: 24,
                )
            ]),
        Column(
            mainAxisSize: MainAxisSize.min,
            spacing: RoveTheme.verticalSpacing,
            children: [
              _ShadowIcon(
                'damage',
                color: Colors.white,
              ),
              ...ethers.map((e) => AffinityChip(affinities[e] ?? 0)),
              if (affinities.containsKey(Ether.dim))
                AffinityChip(affinities[Ether.dim] ?? 0)
            ])
      ],
    );
  }
}

class AffinityChip extends StatelessWidget {
  final int value;

  const AffinityChip(this.value, {super.key});

  String textForValue(int value) {
    if (value < 0) {
      return value.toString();
    } else if (value == 0) {
      return '+0';
    } else {
      return '+$value';
    }
  }

  Color colorForValue(int value) {
    if (value < 0) {
      return RovePalette.affinityNegative;
    } else if (value == 0) {
      return RovePalette.affinityNeutral;
    } else {
      return RovePalette.affinityPositive;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ImageShadow(
      child: SizedBox(
          height: 24,
          child: Container(
            width: 32,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                border: Border.all(color: Colors.white, width: 1),
                color: colorForValue(value)),
            child: Center(
                child:
                    RoveText.label(textForValue(value), color: Colors.white)),
          )),
    );
  }
}
