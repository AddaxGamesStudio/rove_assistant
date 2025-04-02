import 'package:meta/meta.dart';
import 'package:rove_assistant/model/figure_state.dart';
import 'package:rove_data_types/rove_data_types.dart';

typedef VariablesResolver = Map<String, int> Function(EncounterFigureDef, int);

@immutable
class Figure {
  final int numeral;
  final int? userNumeral;
  final String name;
  final String? alias;
  final String? letter;
  final AdversaryType type;
  final FigureRole role;
  final String? faction;
  final bool large;
  final String asset;
  final int health;
  final int maxHealth;
  final int defense;
  final int minDefense;
  final bool unslayable;
  final bool infected;
  final int roundsToRespawn;
  final List<String> definedTokens;
  final List<String> selectedTokens;
  final List<String> fixedTokens;
  final bool canLoot;
  final bool isLooted;
  final bool removed;
  final List<String> traits;
  final String? allyCardId;
  final int allyBehaviorIndex;
  final int allyBehaviorCount;
  final Map<Ether, int> affinities;

  const Figure({
    this.numeral = 0,
    this.userNumeral = 0,
    required this.name,
    this.alias,
    this.letter,
    this.type = AdversaryType.minion,
    required this.role,
    this.faction,
    required this.asset,
    this.large = false,
    required this.health,
    maxHealth,
    required this.defense,
    this.minDefense = 0,
    this.unslayable = false,
    this.infected = false,
    this.roundsToRespawn = 0,
    this.definedTokens = const [],
    this.selectedTokens = const [],
    this.fixedTokens = const [],
    this.canLoot = false,
    this.isLooted = false,
    this.removed = false,
    this.traits = const [],
    this.allyCardId,
    this.allyBehaviorIndex = 0,
    this.allyBehaviorCount = 0,
    this.affinities = const {},
  }) : maxHealth = maxHealth ?? health;

  get isLoot =>
      (role == FigureRole.object) && health == 0 && selectableTokens.isEmpty;

  int get numberToDisplay => userNumeral ?? numeral;

  String get targetName => '$name#$numeral';

  String get fullName =>
      '$nameToDisplay${numberToDisplay != 0 ? ' ($numberToDisplay)' : ''}';

  get nameToDisplay => alias ?? name;

  List<String> get selectableTokens =>
      definedTokens.isEmpty ? selectedTokens : definedTokens;

  List<String> get displayableTokens => fixedTokens + selectedTokens;

  bool get isOnDisplay =>
      (isAlive || willRespawn || isImpervious || unslayable) && !removed;
  bool get isAlive => health > 0;
  bool get willRespawn => roundsToRespawn > 0;
  bool get isImpervious =>
      health == 0 && maxHealth == 0 && role != FigureRole.object;
}

class FigureBuilder {
  final CampaignDef campaign;
  final EncounterDef encounter;
  final int playerCount;
  int index = 0;
  FigureRole role = FigureRole.adversary;
  String? asset;
  EncounterFigureDef? definition;
  PlacementDef? placement;
  FigureState? state;
  int? health;
  int? defense;
  int roundsToRespawn = 0;
  bool isLooted = false;
  bool hideNumber = false;
  AllyDef? allyDefinition;
  VariablesResolver? resolver;

  FigureBuilder._privateConstructor(
      {required this.campaign,
      required this.encounter,
      required this.playerCount});

  factory FigureBuilder.forGame(
          CampaignDef campaign, EncounterDef encounter, int playerCount) =>
      FigureBuilder._privateConstructor(
          campaign: campaign, encounter: encounter, playerCount: playerCount);

  FigureBuilder withIndex(int index) {
    this.index = index;
    return this;
  }

  FigureBuilder withRole(FigureRole role) {
    this.role = role;
    return this;
  }

  FigureBuilder withAsset(String asset) {
    this.asset = asset;
    return this;
  }

  FigureBuilder withDefinition(EncounterFigureDef definition) {
    this.definition = definition;
    return this;
  }

  FigureBuilder withPlacement(PlacementDef placement) {
    this.placement = placement;
    return this;
  }

  FigureBuilder withState(FigureState state) {
    this.state = state;
    return this;
  }

  FigureBuilder withHealth(int health) {
    this.health = health;
    return this;
  }

  FigureBuilder withDefense(int defense) {
    this.defense = defense;
    return this;
  }

  FigureBuilder withRoundsToRespawn(int roundsToRespawn) {
    this.roundsToRespawn = roundsToRespawn;
    return this;
  }

  FigureBuilder withIsLooted(bool isLooted) {
    this.isLooted = isLooted;
    return this;
  }

  FigureBuilder withVariableResolver(VariablesResolver resolver) {
    this.resolver = resolver;
    return this;
  }

  FigureBuilder withHideNumber(bool hideNumber) {
    this.hideNumber = hideNumber;
    return this;
  }

  FigureBuilder withAllyDefinition(AllyDef allyDefinition) {
    this.allyDefinition = allyDefinition;
    return this;
  }

  List<String> get selectedTokens =>
      state?.selectedTokens ?? definition?.startingTokens ?? [];

  List<String> get fixedTokens => placement?.fixedTokens ?? [];

  bool get _isForceHideNumber =>
      encounter.id == EncounterDef.encounter4dot5 &&
      definition?.name == 'King of Storms';

  Figure build() {
    definition ??= allyDefinition?.behaviors[state?.allyBehaviorIndex ?? 0];
    final name = allyDefinition?.name ?? definition?.name;
    assert(name != null);
    final figureDef = campaign.figureDefinitionForName(name!);
    final resolvedAsset = asset ??
        campaign.pathForImage(
            type: CampaignAssetType.figure,
            src: figureDef!.image,
            expansion: figureDef.expansion);

    final variables = definition != null && resolver != null
        ? resolver!(definition!, selectedTokens.length)
        : {roveRoundVariable: 1};
    return Figure(
      numeral: index,
      userNumeral: hideNumber || _isForceHideNumber ? 0 : state?.overrideNumber,
      name: name,
      alias: placement?.alias ?? definition?.alias,
      letter: definition?.letter,
      type: definition?.type ?? AdversaryType.minion,
      role: role,
      faction: definition?.faction,
      asset: resolvedAsset,
      large: definition != null ? definition!.large : false,
      health: health != null
          ? health!
          : state != null
              ? state!.health
              : definition != null
                  ? definition?.startingHealth ??
                      definition!.getHealth(variables: variables)
                  : 0,
      maxHealth: state != null
          ? state!.maxHealth
          : definition != null
              ? definition!.getHealth(variables: variables)
              : 0,
      defense: defense != null
          ? defense!
          : state?.defense != null
              ? state!.defense!
              : definition != null
                  ? definition!.getDefense(variables: variables)
                  : 0,
      minDefense:
          definition != null ? definition!.getDefense(variables: variables) : 0,
      unslayable: definition?.unslayable ?? false,
      infected: definition?.infected ?? false,
      roundsToRespawn: roundsToRespawn,
      definedTokens:
          definition?.selectableTokensForPlayerCount(playerCount) ?? [],
      selectedTokens: selectedTokens,
      fixedTokens: fixedTokens,
      canLoot: definition?.canLoot ?? false,
      isLooted: isLooted,
      removed: state?.removed ?? false,
      traits: _traitsFromDefinition(definition!),
      allyCardId: allyDefinition?.cardId,
      allyBehaviorIndex: state?.allyBehaviorIndex ?? 0,
      allyBehaviorCount: allyDefinition?.behaviors.length ?? 0,
      affinities: definition?.affinities ?? {},
    );
  }
}

List<String> _traitsFromDefinition(EncounterFigureDef? definition) {
  if (definition == null) {
    return [];
  }
  final overrideForcedMovementDescription =
      definition.traits.any((t) => t.toLowerCase().contains('forced movement'));
  List<String> traits = [];
  if (definition.infected) {
    traits.add('Infected.');
  }
  if (definition.ignoresDifficultTerrain) {
    traits.add('Ignores the movement penalty of difficult terrain.');
  }
  if (definition.immuneToForcedMovement &&
      definition.immuneToTeleport &&
      !overrideForcedMovementDescription) {
    traits.add('Immune to forced movement and teleport.');
  } else if (definition.immuneToForcedMovement &&
      !overrideForcedMovementDescription) {
    traits.add('Immune to forced movement.');
  } else if (definition.immuneToTeleport) {
    traits.add('Immune to teleport.');
  }
  if (definition.flies) {
    traits.add('[flying]');
  } else if (definition.entersObjectSpaces) {
    traits.add('Can enter into spaces with objects.');
  }
  final reducePushPullBy = definition.reducePushPullBy;
  if (reducePushPullBy > 0) {
    traits.add(
        'Reduce all [PUSH] and [PULL] effects targeting this unit by $reducePushPullBy.');
  }
  traits.addAll(definition.traits);
  return traits;
}
