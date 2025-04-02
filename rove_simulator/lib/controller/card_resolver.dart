import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:rove_simulator/controller/augment_controller.dart';
import 'package:rove_simulator/controller/base_controller.dart';
import 'package:rove_simulator/controller/player_action_resolver.dart';
import 'package:rove_simulator/controller/player_actions/select_actor_resolver.dart';
import 'package:rove_simulator/controller/player_actions/select_range_origin_resolver.dart';
import 'package:rove_simulator/controller/player_actions/select_targets_resolver.dart';
import 'package:rove_simulator/model/cards/card_model.dart';
import 'package:rove_simulator/model/cards/item_model.dart';
import 'package:rove_simulator/model/cards/reaction_model.dart';
import 'package:rove_simulator/model/cards/two_sided_card_model.dart';
import 'package:rove_simulator/model/tiles/player_unit_model.dart';
import 'package:rove_simulator/model/cards/skill_model.dart';
import 'package:rove_simulator/model/tiles/summon_model.dart';
import 'package:rove_simulator/model/tiles/tile_model.dart';
import 'package:hex_grid/hex_grid.dart';
import 'package:rove_data_types/rove_data_types.dart';

import 'event_controller.dart';

mixin CoordinateSelector {
  String debugStringForCoordinate(HexCoordinate coordinate);

  bool isPartOfPath(HexCoordinate coordinate);

  bool isSelectableAtCoordinate(HexCoordinate coordinate);

  bool isInAreaOfEffect(HexCoordinate coordinate);

  bool onHoveredCoordinate(HexCoordinate coordinate);

  bool onSelectedCoordinate(HexCoordinate coordinate);
}

mixin EtherSelector {
  bool onSelectedPersonalPoolEther(Ether ether);
}

mixin InfusedEtherSelector {
  bool onSelectedInfusedEther(List<Ether> ether);
}

mixin FlipCardSelector {
  bool onSelectedFlippableCard(TwoSidedCardModel card);

  isFlippableForSkill(SkillModel skill);

  isFlippableForReaction(ReactionModel reaction);
}

mixin Confirmable {
  bool get isConfirmable;

  String get confirmLabel;

  bool confirm();
}

mixin OnKeyEvent {
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed);
}

class _PendingTarget {
  final TileModel actor;
  final TileModel target;
  final HexCoordinate coordinate;
  final HexCoordinate? selectedRangeOrigin;
  final RoveAction action;

  _PendingTarget(
      {required this.actor,
      required this.target,
      required this.coordinate,
      this.selectedRangeOrigin,
      required this.action});
}

class _PendingAction {
  final int? index;
  final RoveAction action;
  final TileModel? actor;
  final HexCoordinate? selectedRangeOrigin;

  _PendingAction(this.action,
      {this.index, this.actor, this.selectedRangeOrigin});
}

class CardResolver extends BaseController
    with
        CoordinateSelector,
        EtherSelector,
        InfusedEtherSelector,
        FlipCardSelector,
        Confirmable,
        OnKeyEvent {
  final CardModel card;
  final PlayerUnitModel player;
  final SummonModel? summon;
  List<_PendingTarget> _pendingTargets = [];
  final List<(HexCoordinate, TileModel)> _previouslyResolvedTargets = [];
  final List<_PendingAction> _actionsToResolve = [];
  final List<RoveAction> _resolvedActions = [];
  final Completer<bool> _completer = Completer();
  PlayerActionResolver? _actionResolver;
  final RoveEvent? event;
  bool _resolvingActor = false;
  late AugmentController _augmentController;
  (int?, List<TileModel>) _previouslySelectedTargets = (null, []);

  CardResolver(
      {required this.player,
      this.summon,
      required this.card,
      required super.game,
      this.event,
      int actionGroup = 0}) {
    _augmentController =
        AugmentController(game: game, player: player, cardResolver: this);
    _augmentController.addListener(() {
      notifyListeners();
    });
    _actionsToResolve.addAll(card.actions
        .where((a) => a.exclusiveGroup == actionGroup || a.exclusiveGroup == 0)
        .mapIndexed((i, a) => _PendingAction(a, index: i)));
  }

  PositionComponent? _cardComponent;

  Future<bool> resolve() {
    _cardComponent = cardController.showCard(card: card, unit: player);
    _resolveNextAction();
    return _completer.future;
  }

  PlayerActionResolver? get actionResolver => _actionResolver;
  TileModel? get actor => _actionResolver?.actor;
  HexCoordinate? get targetCoordinate => _actionResolver?.targetingCoordinate;

  bool get isSelectingTargets => _actionResolver is SelectTargetsResolver;

  set actionResolver(PlayerActionResolver? value) {
    _actionResolver = value;
    _actionResolver?.addListener(() {
      notifyListeners();
    });
    notifyListeners();
  }

  _resolveNext({required bool skippedPrevious}) {
    if (_pendingTargets.isNotEmpty) {
      _resolveNextTarget();
    } else if (_actionsToResolve.isNotEmpty) {
      _resolveNextAction(skippedPrevious: skippedPrevious);
    } else {
      _didResolveCard();
    }
  }

  _didCancelCard() {
    cardController.removeCard(_cardComponent!);
    card.currentActionIndex = null;
    _completer.complete(false);
  }

  onPlayerDowned() {
    _didResolveCard();
    notifyListeners();
  }

  _didResolveCard() {
    cardController.removeCard(_cardComponent!);
    card.currentActionIndex = null;
    _consumeBuffs();
    _completer.complete(true);
  }

  bool _resolvingRangeOrigin = false;

  Future<HexCoordinate?> _resolveRangeOriginForAction(RoveAction action) async {
    final rangeOrigin = action.rangeOrigin;
    if (!rangeOrigin.needsSelection) {
      return null;
    }
    _resolvingRangeOrigin = true;
    SelectRangeOriginResolver resolver =
        SelectRangeOriginResolver(cardResolver: this, action: action);
    actionResolver = resolver;
    await resolver.resolve();
    _resolvingRangeOrigin = false;
    return resolver.selectedCoordinate;
  }

  Future<TileModel?> _resolveActorForAction(RoveAction action) async {
    switch (action.actor) {
      case RoveActionActorKind.previousTarget:
        if (previousTarget == null) {
          throw UnsupportedError('No previous target to use as actor');
        }
        return previousTarget!;
      case RoveActionActorKind.eventActor:
        if (event?.actor == null) {
          throw UnsupportedError('No event actor to use as actor');
        }
        return event!.actor!;
      case RoveActionActorKind.eventTarget:
        if (event?.target == null) {
          throw UnsupportedError('No event target to use as actor');
        }
        return event!.target!;
      case RoveActionActorKind.self:
        return summon ?? player;
      case RoveActionActorKind.named:
        return mapModel.findUnitWithName(action.object!);
      case RoveActionActorKind.glyph:
      case RoveActionActorKind.ally:
      case RoveActionActorKind.allyOrGlyph:
      case RoveActionActorKind.selfOrGlyph:
        _resolvingActor = true;
        SelectActorResolver actorResolver =
            SelectActorResolver(cardResolver: this, action: action);
        actionResolver = actorResolver;
        await actorResolver.resolve();
        _resolvingActor = false;
        return actorResolver.selectedActor;
    }
  }

  List<TileModel> _resolveNonSelectionTargetForAction(RoveAction action) {
    switch (action.targetMode) {
      case RoveActionTargetMode.all:
        switch (action.targetKind) {
          case TargetKind.selfOrEventActor:
            assert(event?.actor != null);
            return [player, if (event?.actor case final value?) value];
          default:
            throw UnimplementedError();
        }
      case RoveActionTargetMode.eventActor:
        assert(event?.actor != null);
        return [if (event?.actor case final value?) value];
      case RoveActionTargetMode.eventTarget:
        assert(event?.target != null);
        return [if (event?.target case final value?) value];
      case RoveActionTargetMode.previous:
        return [if (previousTarget case final value?) value];
      case RoveActionTargetMode.range:
        return [];
    }
  }

  _resolveNextAction({bool skippedPrevious = false}) async {
    final pendingAction = _actionsToResolve.removeAt(0);
    var nextAction = pendingAction.action;
    if (skippedPrevious && nextAction.requiresPrevious) {
      log.addRecord(player,
          'Skipped ${nextAction.shortDescription} because it requires the previous action');
      _didResolveAction(nextAction, skipped: true);
      return;
    }
    final nextActionIndex = pendingAction.index;
    if (nextActionIndex != null) {
      // Augments (or action follow-up) can add additional actions considered to be the same index
      card.currentActionIndex = nextActionIndex;
    }
    nextAction = _actionWithBuffs(nextAction);
    final selectedRangeOrigin = pendingAction.selectedRangeOrigin ??
        await _resolveRangeOriginForAction(nextAction);
    final actor =
        pendingAction.actor ?? await _resolveActorForAction(nextAction);
    if (actor == null) {
      log.addRecord(player,
          'Skipped ${nextAction.shortDescription} due to lack of actor');
      _didResolveAction(nextAction, skipped: true);
      return;
    }
    if (nextAction.requiresTargetSelection) {
      if (nextAction.rangeOrigin == RoveActionRangeOrigin.previousTarget &&
          _previouslyResolvedTargets.isEmpty) {
        throw Exception('No previous target to use as origin');
      }
      final targetCount = nextAction.targetCount;
      if (targetCount > 1 && nextAction.aoe == null) {
        // Handle each target individually
        assert(nextAction.augments.isEmpty);
        for (int i = 0; i < targetCount; i++) {
          _addPendingAction(_PendingAction(
              nextAction
                  .withoutAugments()
                  .withSingleTarget(requiresPrevious: true),
              index: nextActionIndex,
              actor: actor,
              selectedRangeOrigin: selectedRangeOrigin));
        }
        _resolveNext(skippedPrevious: false);
      } else {
        final targetsResolver = SelectTargetsResolver(
            index: nextActionIndex,
            previousTargets: _previouslySelectedTargets.$1 == nextActionIndex
                ? _previouslySelectedTargets.$2
                : [],
            cardResolver: this,
            action: nextAction,
            actor: actor,
            selectedRangeOrigin: selectedRangeOrigin);
        actionResolver = targetsResolver;
        if (!isConfirmable) {
          targetsResolver.resolve().then((completed) {
            // Check if the action became confirmable via augments
            if (targetsResolver.isConfirmable) {
              // Was already resolved via confirm
              return;
            }
            _didResolveAction(_actionResolver!.action, skipped: !completed);
          });
        }
      }
    } else {
      final targets = _resolveNonSelectionTargetForAction(nextAction);
      if (targets.length <= 1) {
        final resolver = PlayerActionResolver.fromAction(
            cardResolver: this,
            actor: actor,
            action: nextAction,
            target: targets.firstOrNull,
            selectedRangeOrigin: selectedRangeOrigin);
        actionResolver = resolver;
        if (!isConfirmable) {
          resolver.resolve().then((completed) {
            _didResolveAction(resolver.action, skipped: !completed);
          });
        }
      } else {
        _pendingTargets = targets
            .mapIndexed((i, target) => _PendingTarget(
                actor: actor,
                target: target,
                coordinate: target.coordinate,
                action: nextAction,
                selectedRangeOrigin: selectedRangeOrigin))
            .toList();
        _resolveNext(skippedPrevious: skippedPrevious);
      }
    }
  }

  _didResolveAction(RoveAction action, {required bool skipped}) {
    if (isSelectingTargets) {
      final targetsResolver = _actionResolver as SelectTargetsResolver;
      actionResolver = null;
      final selectedTargets = targetsResolver.selectedTargets;
      if (selectedTargets.isEmpty) {
        log.addRecord(
            player, 'Skipped ${targetsResolver.action.shortDescription}');
        _resolvedActions.add(targetsResolver.action);
        _resolveNext(skippedPrevious: true);
        return;
      }
      // Remember selection to prevent selecting the same target multiple time on non-AOE multi-target actions
      final selectedTiles = selectedTargets.map((t) => t.$1).toList();
      final index = targetsResolver.index;
      if (index == _previouslySelectedTargets.$1) {
        _previouslySelectedTargets =
            (index, [..._previouslySelectedTargets.$2, ...selectedTiles]);
      } else {
        _previouslySelectedTargets = (index, selectedTiles);
      }
      final actions = _augmentController.actionsForMultiTarget(
          targetsResolver.selectedCoordinate,
          selectedTargets,
          targetsResolver.action);
      _pendingTargets = selectedTargets
          .mapIndexed((i, target) => _PendingTarget(
              actor: targetsResolver.actor,
              target: target.$1,
              coordinate: target.$2,
              action: actions[i],
              selectedRangeOrigin: targetsResolver.selectedRangeOrigin))
          .toList();
      _resolveNext(skippedPrevious: skipped);
    } else {
      _resolvedActions.add(action);
      _resolveNext(skippedPrevious: skipped);
    }
  }

  _resolveNextTarget() {
    final pendingTarget = _pendingTargets.removeAt(0);
    actionResolver = PlayerActionResolver.fromAction(
        actor: pendingTarget.actor,
        cardResolver: this,
        action: pendingTarget.action,
        target: pendingTarget.target,
        selectedCoordinate: pendingTarget.coordinate,
        selectedRangeOrigin: pendingTarget.selectedRangeOrigin);
    if (!isConfirmable) {
      _actionResolver!.resolve().then((completed) {
        _resolvedActions.add(pendingTarget.action);
        _previouslyResolvedTargets
            .add((pendingTarget.coordinate, pendingTarget.target));
        _resolveNext(skippedPrevious: !completed);
      });
    }
  }

  addActionForTarget(TileModel target, RoveAction action) {
    _pendingTargets.add(_PendingTarget(
        actor: actionResolver!.actor,
        target: target,
        coordinate: target.coordinate,
        action: action,
        selectedRangeOrigin: actionResolver!.selectedRangeOrigin));
  }

  void replaceAction(RoveAction action) {
    assert(_actionResolver != null);
    _actionsToResolve.insert(0, _PendingAction(action));
    _resolveNext(skippedPrevious: false);
    notifyListeners();
  }

  void _addPendingAction(_PendingAction pendingAction) {
    _actionsToResolve.insert(0, pendingAction);
    notifyListeners();
  }

  void addFollowUpAction(RoveAction action) {
    _actionsToResolve.insert(0, _PendingAction(action));
    notifyListeners();
  }

  TileModel? get previousTarget => _previouslyResolvedTargets.lastOrNull?.$2;

  HexCoordinate? get previousTargetCoordinate =>
      _previouslyResolvedTargets.lastOrNull?.$1;

  /* Coordinate Selection */

  @override
  String debugStringForCoordinate(HexCoordinate coordinate) {
    if (mapController.animating) {
      return '';
    }
    return _actionResolver?.debugStringForCoordinate(coordinate) ?? '';
  }

  @override
  bool isInAreaOfEffect(HexCoordinate coordinate) {
    return _actionResolver?.isInAreaOfEffect(coordinate) == true;
  }

  @override
  bool isPartOfPath(HexCoordinate coordinate) {
    return _actionResolver?.isPartOfPath(coordinate) == true;
  }

  @override
  bool isSelectableAtCoordinate(HexCoordinate coordinate) {
    if (mapController.animating) {
      return false;
    }

    if (_augmentController.isSelectableAtCoordinate(coordinate)) {
      return true;
    }

    return _actionResolver?.isSelectableAtCoordinate(coordinate) == true;
  }

  @override
  bool onHoveredCoordinate(HexCoordinate coordinate) {
    if (mapController.animating) {
      return false;
    }
    return _actionResolver?.onHoveredCoordinate(coordinate) == true;
  }

  @override
  bool onSelectedCoordinate(HexCoordinate coordinate) {
    if (mapController.animating) {
      return false;
    }
    if (_augmentController.onSelectedCoordinate(coordinate)) {
      return true;
    }

    return _actionResolver?.onSelectedCoordinate(coordinate) == true;
  }

  RoveActionPolarity get currentActionPolarity =>
      _augmentController.pendingUserInput
          ? RoveActionPolarity.neutral
          : action.polarity;

  /* UI Actions */

  String get instruction =>
      _augmentController.instruction ?? _actionResolver?.instruction ?? '';

  String get cancelLabel => _augmentController.pendingUserInput
      ? 'Cancel ${card.name} Augment'
      : 'Cancel ${card.name}';

  bool get isCancelable =>
      _augmentController.pendingUserInput ||
      (_actionResolver?.modifiedGameState == false && _resolvedActions.isEmpty);

  cancel() {
    if (_augmentController.pendingUserInput) {
      _augmentController.cancel();
      return;
    }
    if (isCancelable) {
      _didCancelCard();
    }
  }

  /* Confirmable */

  @override
  String get confirmLabel => (_actionResolver is Confirmable)
      ? (_actionResolver as Confirmable).confirmLabel
      : 'Confirm ${_actionResolver!.action.shortDescription}';

  @override
  bool get isConfirmable {
    if (_augmentController.pendingUserInput) {
      return false;
    }

    final resolvesWithoutInput =
        _actionResolver?.resolvesWithoutUserInput == true;
    if ((availableAugments.isNotEmpty ||
            _augmentController.appliedAugments.isNotEmpty) &&
        resolvesWithoutInput) {
      return true;
    }
    if (availableItems.isNotEmpty && resolvesWithoutInput) {
      return true;
    }

    if ((_actionResolver is Confirmable) &&
        (_actionResolver as Confirmable).isConfirmable) {
      return true;
    }
    return false;
  }

  @override
  bool confirm() {
    if (_actionResolver is Confirmable) {
      final bool confirmed = (_actionResolver as Confirmable).confirm();
      if (confirmed) {
        _didResolveAction(_actionResolver!.action, skipped: false);
      }
      return confirmed;
    } else if (isConfirmable) {
      _actionResolver!.resolve().then((completed) {
        _didResolveAction(_actionResolver!.action, skipped: !completed);
      });
      return true;
    } else {
      return false;
    }
  }

  bool get isSkippable => _augmentController.pendingUserInput
      ? false
      : _actionResolver?.isSkippable == true;

  String get skipLabel => 'Skip ${_actionResolver?.action.shortDescription}';

  skip() {
    _actionResolver!.skip();
    if (isConfirmable) {
      _didResolveAction(_actionResolver!.action, skipped: false);
    }
  }

  /* Buffs */

  final List<RoveBuff> _appliedBuffs = [];

  RoveAction _actionWithBuffs(RoveAction actionToBuff) {
    final nonAppliedBuffs =
        player.buffs.where((buff) => !_appliedBuffs.contains(buff));
    for (final buff in nonAppliedBuffs) {
      if (buff.canBuffAction(actionToBuff)) {
        _appliedBuffs.add(buff);
        log.addRecord(player,
            'Buffed ${actionToBuff.shortDescription} with ${buff.descriptionForAction(actionToBuff)}');
        actionToBuff = actionToBuff.withBuff(buff);
      }
    }
    return actionToBuff;
  }

  _consumeBuffs() {
    for (final buff in _appliedBuffs) {
      player.buffs.remove(buff);
    }
  }

  /* Augmentations */

  RoveAction get action => _actionResolver!.action;

  bool get canDisplayAugments => !_resolvingActor && !_resolvingRangeOrigin;

  List<ActionAugment> get availableAugments {
    if (!canDisplayAugments) {
      return [];
    }
    return _augmentController.availableAugments;
  }

  List<Ether> get availableEtherFromPersonalPool =>
      _augmentController.availableEtherFromPersonalPool;

  Future<void> applyAugment(ActionAugment augment,
      {List<Ether> selectedEther = const []}) async {
    await _augmentController.applyAugment(augment,
        selectedEther: selectedEther);
  }

  Future<void> applyItem(ItemModel item,
      {List<Ether> selectedEther = const []}) async {
    await _augmentController.applyItem(item, selectedEther: selectedEther);
  }

  List<ItemModel> get availableItems {
    if (!canDisplayAugments) {
      return [];
    }
    return _augmentController.availableItems;
  }

  /* Card Flip Mechanichs */

  @override
  bool onSelectedFlippableCard(TwoSidedCardModel card) {
    if (_actionResolver is FlipCardSelector) {
      return (_actionResolver as FlipCardSelector)
          .onSelectedFlippableCard(card);
    }
    return false;
  }

  @override
  isFlippableForSkill(SkillModel skill) {
    if (_actionResolver is FlipCardSelector) {
      return (_actionResolver as FlipCardSelector).isFlippableForSkill(skill);
    }
    return false;
  }

  @override
  isFlippableForReaction(ReactionModel reaction) {
    if (_actionResolver is FlipCardSelector) {
      return (_actionResolver as FlipCardSelector)
          .isFlippableForReaction(reaction);
    }
    return false;
  }

  /* Ether Selection */

  @override
  bool onSelectedPersonalPoolEther(Ether ether) {
    if (_augmentController.onSelectedPersonalPoolEther(ether)) {
      return true;
    }
    if (_actionResolver is EtherSelector) {
      return (_actionResolver as EtherSelector)
          .onSelectedPersonalPoolEther(ether);
    }
    return false;
  }

  @override
  bool onSelectedInfusedEther(List<Ether> ether) {
    if (_augmentController.onSelectedInfusedEther(ether)) {
      return true;
    }
    if (_actionResolver is InfusedEtherSelector) {
      return (_actionResolver as InfusedEtherSelector)
          .onSelectedInfusedEther(ether);
    }
    return false;
  }

  /* Keyboard Input */

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (_actionResolver is OnKeyEvent) {
      if ((_actionResolver as OnKeyEvent).onKeyEvent(event, keysPressed)) {
        return true;
      }
    }
    return false;
  }
}
