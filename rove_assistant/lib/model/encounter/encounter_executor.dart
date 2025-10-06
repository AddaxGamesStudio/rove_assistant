import 'dart:async';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:rove_assistant/app.dart';
import 'package:rove_assistant/data/campaign_loader.dart';
import 'package:rove_assistant/model/campaign_model.dart';
import 'package:rove_assistant/model/encounter/encounter_event.dart';
import 'package:rove_assistant/model/encounter/encounter_model_extensions.dart';
import 'package:rove_assistant/model/encounter/encounter_model.dart';
import 'package:rove_assistant/model/encounter/encounter_resolver.dart';
import 'package:rove_assistant/model/encounter/encounter_state.dart';
import 'package:rove_assistant/model/encounter/figure.dart';
import 'package:rove_assistant/model/players_model.dart';
import 'package:rove_assistant/persistence/preferences.dart';
import 'package:rove_assistant/persistence/assistant_preferences.dart';
import 'package:rove_data_types/rove_data_types.dart';

class EncounterExecutor {
  final EncounterDef encounter;
  final EncounterState state;
  final EncounterModel model;
  final CampaignDef _campaign;
  final EncounterEvents events;

  EncounterExecutor(
      {required this.encounter, required this.state, required this.model})
      : _campaign = CampaignModel.instance.campaignDefinition,
        events = model.events;

  EncounterResolver get resolver => encounter.resolver(state);
  List<Player> get _players => PlayersModel.instance.players;
  int get playerCount => _players.length;

  /* Encounter actions */

  List<(String, EncounterAction)> _encounterActionsForFigureDef(
      {required EncounterFigureDef figureDef,
      Iterable<EncounterAction> Function(EncounterFigureDef)?
          toActionsFromClass,
      Iterable<EncounterAction> Function(PlacementDef)?
          toActionsFromPlacement}) {
    final actions = <(String, EncounterAction)>[];
    final name = figureDef.name;
    final placements = resolver.placementsForName(name);
    var anyAlive = false;
    for (int i = 0; i < placements.length; i++) {
      final placement = placements[i];
      final index = i + 1;
      final unitState =
          resolver.adversaryState(definition: figureDef, index: index);
      if (!figureDef.unslayable &&
          unitState.health == 0 &&
          unitState.maxHealth > 0) {
        continue;
      }
      anyAlive = true;
      if (toActionsFromPlacement != null) {
        actions.addAll(toActionsFromPlacement(placement)
            .map((a) => (figureDef.targetForNumber(index), a)));
      }
    }
    if (anyAlive && toActionsFromClass != null) {
      actions.addAll(toActionsFromClass(figureDef).map((a) => (name, a)));
    }
    return actions;
  }

  List<(String?, EncounterAction)> _encounterActions(
      {Iterable<EncounterAction> Function()? actionsFromEncounter,
      Iterable<EncounterAction> Function(EncounterFigureDef)?
          toActionsFromClass,
      Iterable<EncounterAction> Function(PlacementDef)?
          toActionsFromPlacement}) {
    final actions = <(String?, EncounterAction)>[];
    if (actionsFromEncounter != null) {
      actions.addAll(actionsFromEncounter().map(((a) => (null, a))));
    }
    final nonAllyDefinitions = [
      ...resolver.adversaryDefinitions,
      ...encounter.overlays,
    ];
    for (final figureDef in nonAllyDefinitions) {
      actions.addAll(_encounterActionsForFigureDef(
          figureDef: figureDef,
          toActionsFromClass: toActionsFromClass,
          toActionsFromPlacement: toActionsFromPlacement));
    }
    for (final ally in encounter.allies) {
      actions.addAll(_encounterActionsForAlly(
          ally: ally, toActionsFromClass: toActionsFromClass));
    }
    return actions;
  }

  List<(String, EncounterAction)> _encounterActionsForAlly(
      {required AllyDef ally,
      Iterable<EncounterAction> Function(EncounterFigureDef)?
          toActionsFromClass}) {
    if (toActionsFromClass == null) {
      return [];
    }
    final allyFigure = resolver.figureForTarget(ally.name);
    assert(allyFigure != null);
    if (allyFigure == null) {
      return [];
    }
    final behavior = ally.behaviors[allyFigure.allyBehaviorIndex];
    return toActionsFromClass(behavior).map((a) => (ally.name, a)).toList();
  }

  List<(String, EncounterAction)> _encounterActionsForFigure(
      {required Figure figure,
      required Iterable<EncounterAction> Function(EncounterFigureDef)
          toActionsFromClass,
      Iterable<EncounterAction> Function(PlacementDef)?
          toActionsFromPlacement}) {
    final actions = <EncounterAction>[];
    // Return most specific actions first
    final placements = resolver.placementsForName(figure.name);
    final index = figure.numeral - 1;
    assert(index - 1 < placements.length);
    if (placements.isNotEmpty &&
        index < placements.length &&
        toActionsFromPlacement != null) {
      actions.addAll(toActionsFromPlacement(placements[index]));
    }
    actions.addAll([
      ...encounter.allies
          .where((a) => a.name == figure.name)
          .expand((a) => a.behaviors)
          .expand(toActionsFromClass),
      ...encounter.overlays
          .where((e) => e.name == figure.name)
          .expand(toActionsFromClass),
      ...resolver.adversaryDefinitions
          .where((e) => e.name == figure.name)
          .expand(toActionsFromClass)
    ]);
    return actions.map((a) => (figure.name, a)).toList();
  }

  _applyReaction(EnemyReactionDef reaction,
      {required Figure reactor, String? title, String? body}) {
    final key = reaction.title;
    if (key != null) {
      state.didApplyActionWithKey(key);
    }
    for (final action in reaction.actions) {
      _applyUnitAction(action, figure: reactor, title: title, body: body);
    }
  }

  bool _isActionBeLowLimit(EncounterAction action) {
    final key = action.key;
    final limit = action.limit;
    if (limit > 0 && key != null) {
      final count = state.countForActionKey(key);
      if (count >= limit) {
        return false;
      }
    }
    return true;
  }

  Future<void> _applyApplicableActions(List<(String?, EncounterAction)> actions,
      {String? title,
      bool isOnLoot = false,
      Figure? target,
      List<String>? tokens}) async {
    var appplicableActions = actions;
    // If there are multiple actions with closest of class condition, remove all but one.
    final closestOfClassActions = appplicableActions
        .where((d) => d.$2.conditions.any(
            (c) => c.type == RoveConditionType.ownerIsClosestOfClassToRovers))
        .where((d) => _matchesConditions(d.$2.conditions, target: target))
        .toList();
    if (closestOfClassActions.length > 1) {
      final actionsToRemove = closestOfClassActions.skip(1);
      for (final action in actionsToRemove) {
        appplicableActions.remove(action);
      }
    }

    for (final (className, action) in appplicableActions) {
      // Check conditions as actions are applied as the state changes can affect them
      if (!_isActionBeLowLimit(action)) {
        continue;
      }
      var currentTarget = target;
      if (currentTarget == null && className != null) {
        final candidates = resolver.figuresForTarget(className);
        if (candidates.length == 1) {
          currentTarget = candidates.first;
        }
      }
      if (!_matchesConditions(action.conditions, target: currentTarget)) {
        continue;
      }
      await _applyEncounterAction(action,
          className: className,
          target: currentTarget,
          title: action.title ?? title,
          body: action.body,
          isOnLoot: isOnLoot,
          tokens: tokens);
    }
  }

  Future<void> onLoad() async {
    final actions =
        _encounterActions(actionsFromEncounter: () => encounter.onLoad);
    await _applyApplicableActions(actions);
  }

  Future<void> _onFailure() async {
    final actions =
        _encounterActions(actionsFromEncounter: () => encounter.onFailure);
    await _applyApplicableActions(actions);
  }

  Future<void> _onLoot(Figure figure) async {
    final actions = _encounterActionsForFigure(
        figure: figure,
        toActionsFromClass: (e) => e.onLoot,
        toActionsFromPlacement: (p) => p.onLoot);
    await _applyApplicableActions(actions,
        title: '${figure.nameToDisplay} Looted',
        isOnLoot: true,
        target: figure);
  }

  Future<void> _onTokensChanged(
      {required Figure figure, required List<String> tokens}) async {
    final actions = _encounterActionsForFigure(
        figure: figure,
        toActionsFromClass: (e) => e.onTokensChanged,
        toActionsFromPlacement: (p) => p.onTokensChanged);
    await _applyApplicableActions(actions, target: figure, tokens: tokens);
  }

  Future<void> _onSlain(Figure figure) async {
    final actions = _encounterActionsForFigure(
        figure: figure,
        toActionsFromClass: (e) => e.onSlain,
        toActionsFromPlacement: (p) => p.onSlain);
    _applyReactionsForFigure(figure, RoveEventType.afterSlain,
        defaultTitle: '${figure.nameToDisplay} Slain');
    await _applyApplicableActions(actions,
        title: '${figure.nameToDisplay} Slain', target: figure);
  }

  bool _needsXulcDieRollOnSlainFigure(Figure figure) {
    if (!figure.infected) {
      return false;
    }
    // Check if there's custom Xulc die roll logic
    return _encounterActionsForFigure(
            figure: figure,
            toActionsFromClass: (e) => e.onSlain,
            toActionsFromPlacement: (p) => p.onSlain)
        .where((d) => d.$2.type == EncounterActionType.rollXulcDie)
        .isEmpty;
  }

  _applyReactionsForFigure(Figure figure, RoveEventType type,
      {required String defaultTitle}) {
    final reactions = [
      ...encounter.allies
          .where((e) => e.name == figure.name)
          .expand((e) => e.behaviors),
      ...resolver.adversaryDefinitions.where((e) => e.name == figure.name),
      ...encounter.overlays.where((e) => e.name == figure.name)
    ]
        .expand((e) => e.reactions.where((r) => r.trigger.type == type))
        .where((r) => _canApplyEnemyReaction(r, reactor: figure))
        .toList();
    for (final reaction in reactions) {
      _applyReaction(reaction,
          reactor: figure,
          title: reaction.title ?? defaultTitle,
          body: reaction.body);
    }
  }

  Future<void> _onSufferedDamage(Figure figure) async {
    final defaultTitle = '${figure.nameToDisplay} Suffered Damage';
    _applyReactionsForFigure(figure, RoveEventType.afterSuffer,
        defaultTitle: defaultTitle);
    final actions = _encounterActionsForFigure(
        figure: figure, toActionsFromClass: (e) => e.onDamage);
    await _applyApplicableActions(actions, title: defaultTitle, target: figure);
  }

  Future<void> _onWillEndPhase() async {
    final actions =
        _encounterActions(actionsFromEncounter: () => encounter.onWillEndPhase);
    await _applyApplicableActions(actions);
  }

  Future<void> _onDidStartPhase() async {
    final actions = _encounterActions(
        actionsFromEncounter: () => encounter.onDidStartPhase,
        toActionsFromClass: (d) => d.onStartPhase);
    await _applyApplicableActions(actions,
        title: '${state.phase.label()} Phase Started');
  }

  List<(String?, EncounterAction)> get _willEndRoundEncounterActions =>
      _encounterActions(
          actionsFromEncounter: () => encounter.onWillEndRound,
          toActionsFromClass: (f) => f.onWillEndRound,
          toActionsFromPlacement: (p) => p.onWillEndRound).toList();

  Future<void> _onWillEndRound() async {
    final actions = _willEndRoundEncounterActions;
    await _applyApplicableActions(actions);
  }

  Future<void> onDidStartRound() async {
    final actions = _encounterActions(
        actionsFromEncounter: () => encounter.onDidStartRound,
        toActionsFromClass: (f) => f.onDidStartRound,
        toActionsFromPlacement: (p) => p.onDidStartRound);
    await _applyApplicableActions(actions);
  }

  Future<void> onMilestone(String milestone) async {
    final actions = _encounterActions(
        actionsFromEncounter: () => encounter.onMilestone[milestone] ?? [],
        toActionsFromClass: (p) => p.onMilestone[milestone] ?? [],
        toActionsFromPlacement: (p) => p.onMilestone[milestone] ?? []);
    await _applyApplicableActions(actions);
  }

  _canApplyEnemyReaction(EnemyReactionDef reaction, {Figure? reactor}) {
    final key = reaction.title;
    if (reaction.limit > 0 && key != null) {
      final count = state.countForActionKey(key);
      if (count >= reaction.limit) {
        return false;
      }
    }
    final condition = reaction.trigger.condition;
    return _matchesConditions(condition != null ? [condition] : [],
        target: reactor);
  }

  bool _matchesConditions(List<RoveCondition> conditions, {Figure? target}) {
    return conditions
            .any((c) => !resolver.matchesCondition(c, target: target)) ==
        false;
  }

  _showRules(EncounterAction action) {
    assert(action.type == EncounterActionType.rules);
    final title = action.title;
    final body = action.body;
    assert(title != null);
    if (title == null || body == null) {
      return;
    }
    state.addSpecialRule(title: title, body: body);
    if (!action.silent && !Preferences.instance.skipRules) {
      events.addEvent(
          EncounterEvent.rules(model: model, title: title, body: body));
    }
  }

  Future<void> _showCodex(EncounterAction action) async {
    assert(action.type == EncounterActionType.codex);
    final number = int.tryParse(action.value);
    assert(number != null);
    if (number == null) {
      return;
    }
    final context = App.key.currentContext;
    if (context == null) {
      return;
    }
    final codex = await CampaignLoader.loadCodex(context, number,
        expansion: encounter.expansion);
    final title = codex.title;
    if (state.hasCodexWithTitle(title)) {
      return;
    }
    state.addCodexEntry(number: number, title: title);
    final event = EncounterEvent.showCodex(model: model, codex: codex);
    // Remove codex link after creating the event to get its data.
    state.removeCodexLinkByNumber(number);
    state.removeCodexLinkByTitle(title);
    if (!Preferences.instance.skipNarrative) {
      events.addEvent(event);
    }
  }

  Future<void> _applyEncounterAction(EncounterAction action,
      {String? title,
      String? body,
      bool isOnLoot = false,
      String? className,
      Figure? target,
      List<String>? tokens}) async {
    final key = action.key;
    if (key != null) {
      state.didApplyActionWithKey(key);
    }
    switch (action.type) {
      case EncounterActionType.addToken:
        assert(target != null || action.value.isNotEmpty);
        String? tokenName;
        String? tokenDisplayName;
        if (action.value.isNotEmpty) {
          tokenName = action.value;
        } else if (target != null) {
          tokenName = target.name;
          tokenDisplayName = target.nameToDisplay;
        }
        if (tokenName == null) {
          return;
        }
        final addTokenToRover = isOnLoot ||
            (target != null && !resolver.figureForFigure(target).isAlive) ||
            target == null;
        if (addTokenToRover) {
          _pushTokenRewardEvent(
              token: tokenName,
              displayName: tokenDisplayName,
              title: action.title,
              body: action.body);
        } else {
          _addToken(target, tokenName);
        }
        break;
      case EncounterActionType.dialog:
        await _showDialog(action);
        break;
      case EncounterActionType.function:
        assert(action.value.isNotEmpty);
        executeCustomFunction(action.value, figure: target, tokens: tokens);
        break;
      case EncounterActionType.victory:
        state.objectiveAchieved = true;
        _succeedEncounter(body: action.body);
        break;
      case EncounterActionType.loss:
        await failEncounter(title: action.title, body: action.body);
        break;
      case EncounterActionType.codex:
        await _showCodex(action);
        break;
      case EncounterActionType.codexLink:
        final title = action.title;
        if (title == null) {
          return;
        }
        state.addCodexLink(
            title: title,
            trigger: action.body,
            number: int.tryParse(action.value));
        break;
      case EncounterActionType.milestone:
        await recordMilestone(action.value,
            title: action.title ?? title, silent: action.silent);
        break;
      case EncounterActionType.remove:
        if (action.value.isNotEmpty) {
          target = resolver.figureForTarget(action.value);
        } else if (target == null && className != null) {
          target = resolver.figureForTarget(className);
        }
        assert(target != null);
        if (target == null) {
          return;
        }
        assert(!target.removed);
        if (target.removed) {
          return;
        }
        _removeFigure(target);
        if (!action.silent) {
          events.addEvent(EncounterEvent.removedFigure(
              model: model, title: title, message: body, figure: target));
        }
        break;
      case EncounterActionType.removeAll:
        _removeAllAdversaries();
        break;
      case EncounterActionType.removeRule:
        state.removeSpecialRule(title: action.value);
        break;
      case EncounterActionType.removeCodexLink:
        final number = int.tryParse(action.value);
        if (number == null) {
          return;
        }
        state.removeCodexLinkByNumber(number);
        break;
      case EncounterActionType.replace:
        if (target == null && className != null) {
          target = resolver.figureForTarget(className);
        }
        assert(target != null);
        if (target == null) {
          return;
        }
        _replace(target, action.value,
            title: title ?? 'Adversary Replaced',
            body: body,
            silent: action.silent);
        break;
      case EncounterActionType.rewardEther:
        _rewardEther(action: action, title: title);
        break;
      case EncounterActionType.rollEtherDie:
        await rollEtherDie(title: action.title, body: action.body);
        break;
      case EncounterActionType.rollXulcDie:
        await rollXulcDie(title: action.title ?? title, body: action.body);
        break;
      case EncounterActionType.rules:
        _showRules(action);
        break;
      case EncounterActionType.rewardLyst:
        _rewardLyst(action: action, title: title);
        break;
      case EncounterActionType.rewardItem:
        _pushItemRewardEvent(
            title: action.title ?? title ?? 'Item Reward',
            body: action.body,
            item: action.value,
            loot: isOnLoot);
        break;
      case EncounterActionType.resetRound:
        await _resetRound(
            title: action.title ?? title,
            body: body,
            overrideRoundLimit: int.tryParse(action.value),
            silent: action.silent);
        break;
      case EncounterActionType.respawn:
        _respawnAdversaries(title: action.title, force: true);
        break;
      case EncounterActionType.setLossCondition:
        state.overrideLossCondition = action.value;
        break;
      case EncounterActionType.setSubtitle:
        _setSubtitle(action.value);
        break;
      case EncounterActionType.setVictoryCondition:
        _setVictoryCondition(action.value);
        break;
      case EncounterActionType.spawnPlacements:
        _applyPlacementGroup(
            codexTitle: title ?? 'Spawn',
            placementGroupName: action.value,
            body: body,
            silent: action.silent);
        break;
      case EncounterActionType.toggleBehavior:
        assert(className != null);
        if (className != null) {
          final ally = resolver.figureForTarget(className);
          if (ally != null && ally.health > 0) {
            _flipAllyCard(name: className);
            if (!action.silent) {
              _pushedFlippedAllyCardEvent(name: className, title: title);
            }
          }
        }
        break;
      case EncounterActionType.awaken:
      case EncounterActionType.giveTo:
      case EncounterActionType.unlockFromAdjacentAndLoot:
        break;
    }
  }

  _addToken(Figure figure, String token) {
    final figureState = state.stateFromFigure(figure);
    final tokens = figureState.selectedTokens + [token];
    state.setAdversaryState(
        name: figure.name,
        numeral: figure.numeral,
        state: figureState.withTokens(tokens));
  }

  Future<void> _showDialog(EncounterAction action) async {
    late final EncounterDialogDef dialog;
    if (action.value.isNotEmpty) {
      dialog = encounter.dialogForTitle(action.value);
    } else {
      assert(action.body != null);
      dialog = EncounterDialogDef(
          title: action.title ?? 'Dialog', body: action.body ?? '');
    }
    CampaignText? text;
    if (dialog.type == EncounterDialogDef.textType) {
      final context = App.key.currentContext;
      if (context == null) {
        return;
      }
      text = await CampaignLoader.loadText(context, dialog.body ?? '',
          expansion: encounter.expansion);
    }

    if (dialog.buttons.isNotEmpty) {
      final completer = Completer();
      events.addEvent(EncounterEvent.dialog(
          model: model,
          dialog: dialog,
          body: text?.body,
          artwork: text?.artwork,
          onButtonPressed: (button) async {
            await recordMilestone(button.milestone, title: button.title);
            completer.complete();
          }));
      return completer.future;
    } else {
      final event = EncounterEvent.dialog(
        model: model,
        dialog: dialog,
        body: text?.body,
        artwork: text?.artwork,
      );
      if (dialog.type == EncounterDialogDef.rulesType) {
        if (!Preferences.instance.skipRules) {
          events.addEvent(event);
        }
      } else if (dialog.type == EncounterDialogDef.drawType) {
        events.addEvent(event);
      } else {
        if (!Preferences.instance.skipNarrative) {
          events.addEvent(event);
        }
        if (event.isIntroduction &&
            model.setup != null &&
            !Preferences.instance.skipRules) {
          events.addEvent(EncounterEvent.setup(model: model));
        }
      }
    }
  }

  _resolveFormula({int? amount = 0, String? formula}) {
    return roveResolveValueOrFormula(amount == 0 ? null : amount, formula, {
      rovePlayerCountVariable: playerCount,
    });
  }

  _applyUnitAction(RoveAction action,
      {Figure? figure, String? title, String? body}) {
    switch (action.type) {
      case RoveActionType.leave:
        assert(figure != null);
        if (figure != null) {
          _removeFigure(figure);
          events.addEvent(EncounterEvent.removedFigure(
              model: model, title: title, message: body, figure: figure));
        }
      case RoveActionType.addDefense:
        if (figure != null && action.targetKind == TargetKind.self) {
          setFigureDefense(
              figure: figure, defense: figure.defense + action.amount);
        }
      case RoveActionType.spawn:
        final className = action.object;
        if (className == null) {
          return;
        }
        final amount = _resolveFormula(
            amount: action.amount, formula: action.amountFormula);
        final spawns = <Figure>[];
        for (int i = 0; i < amount; i++) {
          if (resolver.canSpawnOfName(className)) {
            spawns.add(spawn(name: className));
          }
        }
        _pushSpawnEvent(
            title: title ?? 'Spawned Advesaries', body: body, figures: spawns);
        break;
      default:
    }
  }

  /* Apply tracker events */

  Future<void> onSetHealth(
      {required Figure figure, required int health}) async {
    if (health == 0) {
      if (_needsXulcDieRollOnSlainFigure(figure)) {
        // Spawn Xulc before handling the onSlayed event in case there's conditions about slaying all.
        await rollXulcDie(title: '${figure.nameToDisplay} Slain');
      }
      await _onSlain(resolver.figureForFigure(figure));
    } else {
      if (health < figure.maxHealth) {
        await _onSufferedDamage(resolver.figureForFigure(figure));
      }
    }
  }

  Future<void> onLoot({required Figure figure}) async {
    await _onLoot(figure);
  }

  Future<void> onSetTokens(
      {required Figure figure, required List<String> tokens}) async {
    await _onTokensChanged(figure: figure, tokens: tokens);
  }

  Future<void> onDraw(String value) async {
    final actions = _encounterActions(
      actionsFromEncounter: () => encounter.onDraw[value] ?? [],
      toActionsFromClass: (f) => f.onDraw[value] ?? [],
    );
    await _applyApplicableActions(actions);
  }

  _rewardEther({required EncounterAction action, String? title}) {
    events.addEvent(EncounterEvent.etherReward(
        model: model,
        title: title ?? 'Ether Reward',
        etherOptions: Ether.etherOptionsFromString(action.value)));
  }

  _rewardLyst({required EncounterAction action, String? title}) {
    var lyst = 0;
    assert(action.type == EncounterActionType.rewardLyst);
    lyst = roveResolveFormula(
        action.value, {rovePlayerCountVariable: playerCount});
    assert(lyst > 0);
    if (lyst > 0) {
      final rewardTitle = title ?? 'Lyst Reward';
      state.lystRewards.add((rewardTitle, lyst));
      if (!action.silent) {
        events.addEvent(EncounterEvent.lystReward(
            model: model, title: rewardTitle, lyst: lyst));
      }
    }
  }

  Future<void> recordMilestone(String milestone,
      {required String? title, bool silent = false}) async {
    if (state.milestones.contains(milestone)) {
      return;
    }
    state.milestones.add(milestone);
    final bool isInternal = milestone.startsWith('_');
    if (!isInternal && !silent && !Preferences.instance.skipRules) {
      events.addEvent(EncounterEvent.campaignMilestone(
          model: model, title: title, milestone: milestone));
    }
    await onMilestone(milestone);
  }

  bool _roundReset = false;

  Future<void> _resetRound(
      {String? title,
      String? body,
      int? overrideRoundLimit,
      bool silent = false}) async {
    _roundReset = true;
    state.restartRoundCounter(phases: resolver.phases);
    if (overrideRoundLimit != null) {
      state.overrideRoundLimit = overrideRoundLimit;
    }
    if (!silent && !Preferences.instance.skipRules) {
      events.addEvent(EncounterEvent(
          model: model,
          title: title ?? 'Round Reset',
          message: body ??
              'The round limit has been reset.${overrideRoundLimit != null ? 'You have $overrideRoundLimit rounds to complete the encounter.' : ''}'));
    }
    await onDidStartRound();
    await _onDidStartPhase();
  }

  _setVictoryCondition(String victoryCondition) {
    if (victoryCondition.startsWith(EncounterTrackerEventDef.appendPrefix)) {
      victoryCondition =
          (state.overrideVictoryCondition ?? encounter.victoryDescription) +
              victoryCondition
                  .substring(EncounterTrackerEventDef.appendPrefix.length);
    }
    state.overrideVictoryCondition = victoryCondition;

    if (!Preferences.instance.skipRules) {
      events.addEvent(EncounterEvent.victoryConditionChanged(
          model: model, message: victoryCondition));
    }
  }

  _setSubtitle(String subtitle) {
    if (subtitle.startsWith(EncounterTrackerEventDef.appendPrefix)) {
      subtitle = (state.subtitle ?? '') +
          subtitle.substring(EncounterTrackerEventDef.appendPrefix.length);
    }
    state.subtitle = subtitle;
  }

  Future<void> triggerTrackerEvent(EncounterTrackerEventDef trackerEvent,
      {Figure? eventTarget, bool loot = false}) async {
    final milestone = trackerEvent.recordMilestone;
    if (milestone != null) {
      await recordMilestone(milestone, title: trackerEvent.title);
    }
  }

  void _replace(Figure figure, String replacementName,
      {required String title, String? body, bool silent = false}) {
    final spawnedFigure =
        spawn(name: replacementName, carryStateFromFigure: figure);
    // Remove figure after carrying over its state.
    _removeFigure(figure);
    if (!silent) {
      final event = EncounterEvent.replacedUnit(
          model: model,
          title: title,
          message: body,
          fromName: figure.nameToDisplay,
          figure: spawnedFigure);
      events.addEvent(event);
    }
  }

  _removeAllAdversaries() {
    final adversaries = resolver.adversaries;
    for (final adversary in adversaries) {
      _removeFigure(adversary);
    }
  }

  _removeFigure(Figure figure) {
    switch (figure.role) {
      case FigureRole.ally:
        state.setAllyState(
            name: figure.name,
            state: state.stateFromFigure(figure).withHealth(0).withRemoved());
      case FigureRole.object:
      case FigureRole.adversary:
        state.clearAdversaryRandomStandeeMapping(
            name: figure.name, index: figure.numeral);
        state.setAdversaryState(
            name: figure.name,
            numeral: figure.numeral,
            state: state.stateFromFigure(figure).withHealth(0).withRemoved());
    }
  }

  Figure spawn({required String name, Figure? carryStateFromFigure}) {
    assert(resolver.canSpawnOfName(name));

    final reusableFigure =
        resolver.figuresForTarget(name).firstWhereOrNull((f) => f.health == 0);

    final toDef =
        resolver.adversaryDefinitions.firstWhere((e) => e.name == name);
    // Reuse a previous numeral if available
    if (reusableFigure != null && !Preferences.instance.randomizeStandees) {
      state.setAdversaryState(
          name: reusableFigure.name,
          numeral: reusableFigure.numeral,
          state: state.stateFromFigure(reusableFigure).withRespawn());
    } else {
      state.addPlacements(placements: [PlacementDef(name: toDef.name)]);
    }

    final bool hasCarryState = toDef.carryState && carryStateFromFigure != null;
    // Add new adversary
    final toIndex = resolver.unitCountForName(toDef.name) + 1;
    if (hasCarryState) {
      final toState = state
          .stateFromFigure(carryStateFromFigure)
          .withNumber(carryStateFromFigure.numeral);
      state.setAdversaryState(
          name: toDef.name, numeral: toIndex, state: toState);
    }

    return resolver.adversary(definition: toDef, index: toIndex);
  }

  /* General Actions */

  void setPlayerHealth({required Player player, required int health}) {
    state.setPlayerHealth(player: player, health: health);
    if (resolver.isAllPlayersSlain) {
      failEncounter();
    }
  }

  setFigureHealth({required Figure figure, required int health}) {
    var figureState = state.stateFromFigure(figure).withHealth(health);
    final slain = health == 0;
    if (slain) {
      figureState = figureState.withRoundSlain(state.round);
    }
    final name = figure.name;
    final numeral = figure.numeral;
    switch (figure.role) {
      case FigureRole.ally:
        state.setAllyState(name: name, state: figureState);
        break;
      case FigureRole.adversary:
        if (slain && !resolver.canRespawn(figure: figure)) {
          state.clearAdversaryRandomStandeeMapping(name: name, index: numeral);
        }
        state.setAdversaryState(
            name: name, numeral: numeral, state: figureState);
        break;
      case FigureRole.object:
        state.setAdversaryState(
            name: name, numeral: numeral, state: figureState);
        break;
    }
  }

  void setFigureDefense({required Figure figure, required int defense}) {
    final figureState = state.stateFromFigure(figure).withDefense(defense);
    switch (figure.role) {
      case FigureRole.ally:
        state.setAllyState(name: figure.name, state: figureState);
        break;
      case FigureRole.adversary:
      case FigureRole.object:
        state.setAdversaryState(
            name: figure.name, numeral: figure.numeral, state: figureState);
    }
  }

  Future<void> increasePhase() async {
    if (state.isLastPhaseOfRound(resolver.phases)) {
      final roundBeforeEvents = state.round;
      await _onWillEndPhase();
      await _onWillEndRound();
      final roundAfterEvents = state.round;
      final roundChanged = roundAfterEvents != roundBeforeEvents;
      if (state.round + 1 > resolver.roundLimit) {
        if (!model.isObjectiveAchieved) {
          await failEncounter();
        }
      } else if (!roundChanged && !_roundReset) {
        state.nextPhase(resolver.phases);
        await onDidStartRound();
        await _onDidStartPhase();
        _respawnAdversaries(force: false);
      }
    } else {
      await _onWillEndPhase();
      if (!_roundReset) {
        state.nextPhase(resolver.phases);
      }
      await _onDidStartPhase();
    }
    _roundReset = false;
  }

  Future<void> rollEtherDie({String? title, String? body}) {
    final completer = Completer();
    final event = EncounterEvent.rollEtherDie(
        model: model,
        title: title,
        message: body,
        onDraw: (draw) async {
          await onDraw(draw.toJson());
          completer.complete();
        });
    events.addEvent(event);
    return completer.future;
  }

  Future<void> rollXulcDie({String? title, String? body}) {
    final completer = Completer();
    final event = EncounterEvent.rollXulcDie(
        model: model,
        title: title,
        message: body,
        onDraw: (draw) {
          final adversary = draw.adversaryName;
          if (adversary != null && resolver.canSpawnOfName(adversary)) {
            spawn(name: adversary);
          }
          completer.complete();
        });
    events.addEvent(event);
    return completer.future;
  }

  _succeedEncounter({String? body}) {
    events.addEvent(EncounterEvent.victoryCondition(
        model: model, title: 'Victory!', message: body));
  }

  Future<void> failEncounter({String? title, String? body}) async {
    await _onFailure();
    events.addEvent(EncounterEvent.encounterFailed(
        model: model, title: title, message: body));
  }

  _respawnAdversaries({String? title, required bool force}) {
    final placements =
        state.resolvePlacements(startingPlacements: encounter.placements);

    final List<Figure> figures = [];
    for (var encounterFigureDef in resolver.adversaryDefinitions) {
      final name = encounterFigureDef.name;
      final figureCount = placements
          .where((e) => e.name == name && playerCount >= e.minPlayers)
          .length;
      for (int i = 0; i < figureCount; i++) {
        final index = i + 1;
        final figureState = resolver.adversaryState(
            definition: encounterFigureDef, index: index);
        final respawnCondition = encounterFigureDef.respawnCondition;
        if (!encounterFigureDef.respawns ||
            figureState.roundSlain == null ||
            (respawnCondition != null &&
                !resolver.matchesCondition(respawnCondition))) {
          continue;
        }
        if (figureState.roundsToRespawnOnRound(state.round) == 0 || force) {
          final variables = resolver.resolveVariablesForDefinition(
              encounterFigureDef, figureState.selectedTokens.length);
          final respawnState = figureState.respawn(
              health: encounterFigureDef.getHealth(variables: variables),
              defense: encounterFigureDef.getDefense(variables: variables),
              withoutDie: encounter.id == EncounterDef.encounter8dot5);
          state.setAdversaryState(
              name: name, numeral: index, state: respawnState);
          figures.add(resolver.adversaryWithState(
              definition: encounterFigureDef,
              index: index,
              figureState: respawnState));
        }
      }
    }
    if (figures.isNotEmpty) {
      _pushSpawnEvent(
          title: title ?? 'Round ${state.round} Start Phase', figures: figures);
    }
  }

  /* Codex Actions */

  void _applyPlacementGroup(
      {required String codexTitle,
      required String placementGroupName,
      String? body,
      bool silent = false}) {
    final group = encounter.placementGroupWithName(placementGroupName);
    assert(group != null);
    if (group == null) {
      return;
    }
    final mapId = group.map?.id;
    if (mapId != null) {
      state.overrideMap = mapId;
    }

    final placements = group.placements;

    final previousAdversaries = resolver.adversaries;
    if (group.clearCurrentPlacements) {
      state.replacementPlacementGroup = group.name;
      state.setPlacements(placements: placements);
    } else {
      for (var p in placements) {
        if (resolver.canSpawnOfName(p.name)) {
          // Add placements individually so that the check above considers previous placements.
          state.addPlacements(placements: [p]);
        }
      }
    }
    final adversaries = resolver.adversaries;
    final newAdversaries = adversaries
        .where((f) => previousAdversaries
            .where((p) => p.name == f.name && p.numeral == f.numeral)
            .isEmpty)
        .toList();

    if (newAdversaries.isEmpty) {
      return;
    }

    if (group.isSpawnWithDie) {
      _assignSpawnDieToFigures(newAdversaries);
    }
    // Update figures after assigning spawn die.
    final updatedAdversaries =
        newAdversaries.map((f) => resolver.figureForFigure(f)).toList();

    if (!group.clearCurrentPlacements && !silent) {
      _pushSpawnEvent(
          title: codexTitle, body: body, figures: updatedAdversaries);
    }
  }

  _assignSpawnDieToFigures(List<Figure> figures) {
    for (var f in figures) {
      state.setAdversaryState(
          name: f.name,
          numeral: f.numeral,
          state: state.stateFromFigure(f).withTokens([
            EtherDieSide
                .values[Random().nextInt(EtherDieSide.values.length)].name
          ]));
    }
  }

  /* Events */

  _pushSpawnEvent(
      {required String title, String? body, List<Figure> figures = const []}) {
    events.addEvent(EncounterEvent.spawnedAdversaries(
        model: model, title: title, message: body, figures: figures));
  }

  _pushTokenRewardEvent(
      {required String? displayName,
      required String token,
      String? title,
      String? body}) {
    displayName ??= token;
    events.addEvent(EncounterEvent.tokenReward(
        model: model,
        title: title ?? '$displayName Looted',
        token: token,
        message: body ?? 'The acting rover picks up a $displayName.'));
  }

  _pushItemRewardEvent(
      {required String title,
      String? body,
      required String item,
      bool loot = false}) {
    events.addEvent(EncounterEvent.itemReward(
        model: model,
        title: title,
        message: body,
        loot: loot,
        item: _campaign.itemForName(item)));
  }

  /* Codex elegibility */

  get hasEmergentEndRoundCodices => _willEndRoundEncounterActions.where((data) {
        final action = data.$2;
        final className = data.$1;
        Figure? target;
        if (className != null) {
          final candidates = resolver.figuresForTarget(className);
          if (candidates.length == 1) {
            target = candidates.first;
          }
        }
        return _matchesConditions(action.conditions, target: target);
      }).isNotEmpty;

  void flipAllyCard({required Figure ally}) {
    _flipAllyCard(name: ally.name);
  }

  void _flipAllyCard({required String name}) {
    final ally = resolver.figureForTarget(name);
    assert(ally != null);
    if (ally == null) {
      return;
    }
    final newIndex = (ally.allyBehaviorIndex + 1) % ally.allyBehaviorCount;
    final allyState = state
        .stateFromFigure(ally)
        .withAllyBehaviorIndex(newIndex)
        .withDefense(null); // Clear defense tokens
    state.setAllyState(name: ally.name, state: allyState);
  }

  void _pushedFlippedAllyCardEvent({required String name, String? title}) {
    final allyDefinition =
        encounter.allies.firstWhereOrNull((a) => a.name == name);
    final allyFigure = resolver.figureForTarget(name);
    assert(allyDefinition != null && allyFigure != null);
    if (allyDefinition == null || allyFigure == null) {
      return;
    }
    final behavior = allyDefinition.behaviors[allyFigure.allyBehaviorIndex];
    events.addEvent(EncounterEvent(
        model: model,
        title: title ?? 'Flipped Ally Card',
        message: '$name flipped to its ${behavior.name} side.',
        figures: [allyFigure]));
  }

  void applyPermanentBuffs() {
    for (Player player in PlayersModel.instance.players) {
      state.setPlayerHealth(
          player: player, health: resolver.maxHealthForPlayer(player));
    }
  }
}
