import 'dart:math';

import 'package:collection/collection.dart';
import 'package:rove_assistant/model/campaign_model.dart';
import 'package:rove_assistant/model/encounter/encounter_model.dart';
import 'package:rove_assistant/model/encounter/encounter_model_extensions.dart';
import 'package:rove_assistant/model/encounter/encounter_state.dart';
import 'package:rove_assistant/model/encounter/figure.dart';
import 'package:rove_assistant/model/encounter/figure_state.dart';
import 'package:rove_assistant/model/players_model.dart';
import 'package:rove_assistant/persistence/assistant_preferences.dart';
import 'package:rove_assistant/persistence/preferences.dart';
import 'package:rove_data_types/rove_data_types.dart';

class EncounterResolver {
  final EncounterDef encounter;
  final EncounterState state;
  final CampaignDef campaign;

  EncounterResolver({required this.encounter, required this.state})
      : campaign = CampaignModel.instance.campaignDefinition;

  int get playerCount => PlayersModel.instance.players.length;

  int maxHealthForPlayer(Player player) {
    final itemsMaxHealthBuff = player
        .equippedItems(items: campaign.items)
        .map((i) => i.permanentBuff)
        .nonNulls
        .where((b) => b.type == BuffType.maxHealth)
        .fold(0, (total, buff) => total + buff.amount);
    final campaignMaxHealthBuff =
        PlayersModel.instance.xulcHealthBuffForPlayer(player);
    return player.roverClass.health +
        itemsMaxHealthBuff +
        campaignMaxHealthBuff;
  }

  FigureState _defaultStateForDefinition(EncounterFigureDef definition) {
    final variables = resolveVariablesForDefinition(definition, 0);
    return FigureState(
        health: definition.startingHealth ??
            definition.getHealth(variables: variables),
        maxHealth: definition.getHealth(variables: variables),
        defense: definition.getDefense(variables: variables),
        selectedTokens: definition.startingTokens);
  }

  Map<String, int> resolveVariablesForDefinition(
      EncounterFigureDef definition, int selectedTokenCount) {
    final variables = {
      rovePlayerCountVariable: PlayersModel.instance.players.length,
      roveRoundVariable: state.round,
      roveTokensVariable: selectedTokenCount,
      roveChallenge1Variable: state.challenges[0] ? 1 : 0,
      roveChallenge2Variable: state.challenges[1] ? 1 : 0,
      roveChallenge3Variable: state.challenges[2] ? 1 : 0,
    };
    if (definition.xDefinition != null) {
      variables[roveXVariable] = _resolveXForDefinition(definition);
    }
    return variables;
  }

  int _resolveXForDefinition(EncounterFigureDef definition) {
    // Can't call methors that resolve formulas or it could lead to infinite recursion
    assert(definition.xDefinition != null);
    switch (definition.xFunction) {
      case EncounterFigureDef.countAdversaryFunction:
        return placementsForName(definition.xTarget!)
            .whereIndexed(
                (i, p) => !state.isAdversarySlain(name: p.name, numeral: i + 1))
            .length;
      case EncounterFigureDef.countTokenFunction:
        // So far this only applies to single instance adversaries hence why index = 1
        return state
            .selectedTokensForAdvesary(name: definition.name, numeral: 1)
            .where((t) => t == definition.xTarget)
            .length;
    }
    return 0;
  }

  FigureState allyState({required AllyDef definition}) {
    return state.stateForAlly(
        name: definition.name,
        defaultState: _defaultStateForDefinition(definition.behaviors[
            definition.defaultBehaviorIndex !=
                    AllyDef.userSelectsDefaultBehavior
                ? definition.defaultBehaviorIndex
                : 0]));
  }

  FigureState adversaryState(
      {required EncounterFigureDef definition,
      required int index,
      bool randomizeNumeral = false}) {
    final adversaryState = state.adversaryState(
        name: definition.name,
        numeral: index,
        defaultState: _defaultStateForDefinition(definition));
    final existingRandomNumeral = state.getAdversaryRandomStandeeMapping(
        name: definition.name, index: index);
    if (adversaryState.hasOverrideNumber) {
      return adversaryState;
    }
    if (existingRandomNumeral != null) {
      return adversaryState.withNumber(existingRandomNumeral);
    }
    if (!randomizeNumeral || adversaryState.slain) {
      return adversaryState;
    }
    final randomNumeral = _randomNumeralForEncounterFigureDef(definition);
    state.setAdversaryRandomStandeeMapping(
        name: definition.name, index: index, standeeNumber: randomNumeral);
    return adversaryState.withNumber(randomNumeral);
  }

  Figure adversaryWithState(
      {required EncounterFigureDef definition,
      required int index,
      required FigureState figureState}) {
    return FigureBuilder.forGame(campaign, encounter, playerCount)
        .withIndex(index)
        .withDefinition(definition)
        .withState(figureState)
        .withVariableResolver(resolveVariablesForDefinition)
        .withHideNumber(unitCountForName(definition.name) == 1)
        .build();
  }

  Figure adversary(
      {required EncounterFigureDef definition, required int index}) {
    return adversaryWithState(
        definition: definition,
        index: index,
        figureState: adversaryState(definition: definition, index: index));
  }

  Figure figureForFigure(Figure figure) {
    return figureForTarget(figure.targetName) ?? figure;
  }

  List<Figure> _healhtOnlyFiguresForTarget(
    String target,
  ) {
    return [
      ...allies,
      ..._adversariesHealthOnly(),
      ..._objectsHealthOnly(),
    ].where((e) => isFigureMatchingValue(figure: e, value: target)).toList();
  }

  bool canRespawn({required Figure figure}) {
    final definition =
        encounter.adversaries.firstWhereOrNull((e) => e.name == figure.name);
    if (definition != null) {
      final respawnCondition = definition.respawnCondition;
      if (respawnCondition == null) {
        return definition.respawns;
      }
      return matchesCondition(respawnCondition, target: figure);
    }
    return false;
  }

  bool canSpawnOfName(String name) {
    final adversaryDefinition =
        encounter.adversaries.firstWhereOrNull((e) => e.name == name);
    final count = figuresForTarget(name).where((f) => f.health > 0).length;
    if (adversaryDefinition != null &&
        adversaryDefinition.standeeCount !=
            EncounterFigureDef.undefinedStandeeCount) {
      return count < adversaryDefinition.standeeCount;
    }
    return count < FigureDef.standeeLimit;
  }

  List<Figure> figuresForTarget(String target) {
    return [
      ...allies,
      ...adversaries,
      ...objects,
    ].where((e) => isFigureMatchingValue(figure: e, value: target)).toList();
  }

  Figure? figureForTarget(String target) {
    return allies.firstWhereOrNull(
            (e) => isFigureMatchingValue(figure: e, value: target)) ??
        adversaries.firstWhereOrNull(
            (e) => isFigureMatchingValue(figure: e, value: target)) ??
        objects.firstWhereOrNull(
            (e) => isFigureMatchingValue(figure: e, value: target));
  }

  List<Figure> get allies {
    return encounter.allies.map(allyFromDefinition).toList();
  }

  Figure allyFromDefinition(AllyDef definition) {
    final state = allyState(definition: definition);
    return FigureBuilder.forGame(campaign, encounter, playerCount)
        .withIndex(0)
        .withRole(FigureRole.ally)
        .withAllyDefinition(definition)
        .withVariableResolver(resolveVariablesForDefinition)
        .withState(state)
        .build();
  }

  int unitCountForName(String name) {
    return placementsForName(name).length;
  }

  List<PlacementDef> placementsForName(String name) {
    final playerCount = PlayersModel.instance.players.length;
    final placements =
        state.resolvePlacements(startingPlacements: encounter.placements);
    return placements
        .where((e) => e.name == name && playerCount >= e.minPlayers)
        .toList();
  }

  List<Figure> _objectsHealthOnly() {
    return _figuresOfRole(
        role: FigureRole.object,
        encounterList: encounter.overlays,
        healthOnly: true);
  }

  List<Figure> get objects {
    return _figuresOfRole(
        role: FigureRole.object, encounterList: encounter.overlays);
  }

  List<Figure> _adversariesHealthOnly() {
    return _figuresOfRole(
        role: FigureRole.adversary,
        encounterList: adversaryDefinitions,
        healthOnly: true);
  }

  List<EncounterFigureDef> get adversaryDefinitions {
    final replacementPlacementGroup = state.replacementPlacementGroup;
    if (replacementPlacementGroup != null) {
      final group = encounter.placementGroupWithName(replacementPlacementGroup);
      if (group != null && group.adversaries.isNotEmpty) {
        return group.adversaries;
      } else {
        return encounter.adversaries;
      }
    } else {
      return encounter.adversaries;
    }
  }

  List<Figure> get adversaries {
    return _figuresOfRole(
        role: FigureRole.adversary, encounterList: adversaryDefinitions);
  }

  int slainFigureCount({required String target}) => (adversaries + objects)
      .where((f) =>
          f.health == 0 && isFigureMatchingValue(figure: f, value: target))
      .length;

  bool isAllAdversariesSlainWithTarget(String target) => adversaries
      .where((f) =>
          f.health > 0 && isFigureMatchingValue(figure: f, value: target))
      .isEmpty;

  bool isAllAdversariesSlain({List<String> minusNames = const []}) =>
      adversaries
          .where((f) => f.health > 0 && !minusNames.contains(f.name))
          .isEmpty;

  bool get isAllPlayersSlain => PlayersModel.instance.players
      .map((p) => state.stateForPlayer(p))
      .where((s) => s.health > 0)
      .isEmpty;

  int _randomNumeralForEncounterFigureDef(EncounterFigureDef definition) {
    final standeeCount = definition.standeeCount > 0
        ? definition.standeeCount
        : FigureDef.standeeLimit;
    final candidates = List.generate(standeeCount, (i) => i + 1);
    candidates.shuffle();
    for (final numeral in candidates) {
      if (!state.isStandeeNumberUsedForAdversary(
          name: definition.name, numeral: numeral)) {
        return numeral;
      }
    }
    assert(false, 'All standee numbers are used for ${definition.name}');
    return standeeCount + 1;
  }

  /// Use healthOnly to avoid infinite recursion.
  List<Figure> _figuresOfRole(
      {required FigureRole role,
      required List<EncounterFigureDef> encounterList,
      bool healthOnly = false}) {
    List<Figure> figures = [];
    for (var encounterFigureDef in encounterList) {
      final name = encounterFigureDef.name;
      final placements = placementsForName(name);
      final bool randomizeStandees = Preferences.instance.randomizeStandees &&
          role == FigureRole.adversary &&
          encounterFigureDef.standeeCount > 1;
      for (int i = 0; i < placements.length; i++) {
        final index = i + 1;
        final figureState = adversaryState(
            definition: encounterFigureDef,
            index: index,
            randomizeNumeral: randomizeStandees);
        final respawnCondition = encounterFigureDef.respawnCondition;
        final roundsToRespawn = !healthOnly &&
                encounterFigureDef.respawns &&
                (respawnCondition == null || matchesCondition(respawnCondition))
            ? figureState.roundSlain != null
                ? figureState.roundSlain! + roveRoundsToRespawn - state.round
                : 0
            : 0;
        final figure = FigureBuilder.forGame(campaign, encounter, playerCount)
            .withIndex(index)
            .withRole(role)
            .withDefinition(encounterFigureDef)
            .withPlacement(placements[i])
            .withState(figureState)
            .withVariableResolver(resolveVariablesForDefinition)
            .withRoundsToRespawn(roundsToRespawn)
            .withIsLooted(state.isLooted(name: name, index: index))
            .withHideNumber(placements.length == 1)
            .build();
        figures.add(figure);
      }
    }
    return figures;
  }

  bool matchesCondition(RoveCondition condition, {Figure? target}) {
    switch (condition.type) {
      case RoveConditionType.allAdversariesSlain:
        return isAllAdversariesSlain();
      case RoveConditionType.allAdversariesSlainExcept:
        final c = condition as AllAdversariesSlainExceptCondition;
        return isAllAdversariesSlain(minusNames: [c.target]);
      case RoveConditionType.challengeOn:
        final c = condition as ChallengeOnCondition;
        return state.hasChallenge(c.challenge);
      case RoveConditionType.challengeOff:
        final c = condition as ChallengeOffCondition;
        return !state.hasChallenge(c.challenge);
      case RoveConditionType.damage:
        return target != null
            ? (condition as DamageCondition)
                .matches(target.maxHealth - target.health)
            : false;
      case RoveConditionType.health:
        return target != null
            ? (condition as HealthCondition).matches(target.health, {
                rovePlayerCountVariable: playerCount,
              })
            : false;
      case RoveConditionType.isAlive:
        final aliveTarget = (condition as IsAliveCondition).target;
        // Use _healhtOnlyFiguresForTarget to avoid infinite recursion.
        final aliveAdversaries =
            _healhtOnlyFiguresForTarget(aliveTarget).where((f) => f.health > 0);
        return aliveAdversaries.isNotEmpty;
      case RoveConditionType.isSlain:
        final slainCondition = (condition as IsSlainCondition);
        final slainFigures = _healhtOnlyFiguresForTarget(slainCondition.target)
            .where((f) => f.health == 0);
        return slainCondition.matches(
            slainFigures.length, {rovePlayerCountVariable: playerCount});

      case RoveConditionType.round:
        return (condition as RoundCondition).round == state.round;
      case RoveConditionType.milestone:
        final milestoneCondition = (condition as MilestoneCondition);
        final milestone = milestoneCondition.milestone;
        final value = milestoneCondition.value;
        return hasMilestone(milestone) == value;
      case RoveConditionType.phase:
        return (condition as PhaseCondition).phase == state.phase;
      case RoveConditionType.playerCount:
        return (condition as PlayerCountCondition).playerCount == playerCount;
      case RoveConditionType.minPlayerCount:
        return (condition as MinPlayerCountCondition).playerCount <=
            playerCount;
      case RoveConditionType.tokenCount:
        if (target == null) {
          return false;
        }
        final tokenCondition = condition as TokenCountCondition;
        final count = _resolveFormula(formula: tokenCondition.formula);
        // Get latest state as tokens might have changed
        return state.stateFromFigure(target).selectedTokens.length == count;
      case RoveConditionType.ownerIsClosestOfClassToRovers:
        return true;
      case RoveConditionType.onExit:
        return false;
      default:
        return false;
    }
  }

  _resolveFormula({int? amount = 0, String? formula}) {
    return roveResolveValueOrFormula(amount == 0 ? null : amount, formula, {
      rovePlayerCountVariable: playerCount,
    });
  }

  String objectiveForModel(EncounterModel model) {
    late final String victoryCondition;
    final overrideVictoryCondition = state.overrideVictoryCondition;
    if (overrideVictoryCondition != null) {
      victoryCondition = overrideVictoryCondition;
    } else {
      victoryCondition = encounter.victoryDescription;
    }
    return victoryCondition;
  }

  String? get lossCondition {
    final overrideLossCondition = state.overrideLossCondition;
    if (overrideLossCondition != null) {
      return overrideLossCondition.isEmpty ? null : overrideLossCondition;
    }
    return encounter.lossDescription;
  }

  int get roundLimit {
    final overrideRoundLimit = state.overrideRoundLimit;
    if (overrideRoundLimit != null) {
      return overrideRoundLimit;
    }
    return encounter.roundLimit;
  }

  List<RoundPhase> get phases {
    var phases = encounter.phases.where((p) {
      switch (p) {
        case RoundPhase.adversary:
          return adversaries
              .where((f) => f.faction == null && f.isOnDisplay)
              .isNotEmpty;
        case RoundPhase.extra:
          return adversaries
              .where((f) =>
                  f.faction != null &&
                  f.faction == encounter.extraPhase &&
                  f.isOnDisplay)
              .isNotEmpty;
        case RoundPhase.rover:
          return true;
      }
    }).toList();
    final extraPhaseIndex = encounter.extraPhaseIndex;
    if (extraPhaseIndex != null && phases.contains(RoundPhase.extra)) {
      phases.remove(RoundPhase.extra);
      phases.insert(min(phases.length, extraPhaseIndex), RoundPhase.extra);
    }
    return resolveCustomPhases(phases);
  }

  bool hasMilestone(String milestone) =>
      CampaignModel.instance.hasMilestone(milestone) ||
      state.milestones.contains(milestone);
}

extension EncounterDefResolver on EncounterDef {
  EncounterResolver resolver(EncounterState state) {
    return EncounterResolver(encounter: this, state: state);
  }
}

bool isFigureMatchingValue({required Figure figure, required String value}) {
  // DN:name_or_alias or name_or_alias#index or name_or_alias
  if (value.startsWith(EncounterTrackerEventDef.displayNamePrefix)) {
    return value.substring(EncounterTrackerEventDef.displayNamePrefix.length) ==
        figure.nameToDisplay;
  }
  final parts = value.split('#');
  final targetName = parts[0];
  if (parts.length == 2) {
    final targetIndex = int.parse(parts[1]);
    if (figure.numeral != targetIndex) {
      return false;
    }
  }
  return targetName == figure.name || targetName == figure.alias;
}
