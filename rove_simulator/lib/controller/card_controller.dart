import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flame/components.dart';
import 'package:flutter/foundation.dart';
import 'package:rove_simulator/flame/encounter/cards/card_component.dart';
import 'package:rove_simulator/controller/base_controller.dart';
import 'package:rove_simulator/controller/card_resolver.dart';
import 'package:rove_simulator/controller/event_controller.dart';
import 'package:rove_simulator/controller/reaction_resolver.dart';
import 'package:rove_simulator/model/cards/ability_model.dart';
import 'package:rove_simulator/model/cards/card_model.dart';
import 'package:rove_simulator/model/cards/item_model.dart';
import 'package:rove_simulator/model/cards/reaction_model.dart';
import 'package:rove_simulator/model/encounter_log.dart';
import 'package:rove_simulator/model/tiles/player_unit_model.dart';
import 'package:rove_simulator/model/cards/skill_model.dart';
import 'package:rove_simulator/model/tiles/summon_model.dart';
import 'package:rove_simulator/model/tiles/tile_model.dart';
import 'package:rove_simulator/model/tiles/unit_model.dart';
import 'package:hex_grid/hex_grid.dart';
import 'package:rove_data_types/rove_data_types.dart';

enum _State {
  pendingReaction,
  resolvingNonReactionCard,
  resolvingReaction,
  choosingActionGroup,
  idle
}

class CardController extends BaseController {
  PlayerUnitModel? _player;
  CardResolver? _cardResolver;
  final List<ReactionResolver> _reactionResolvers = [];
  int _cardsShown = 0;

  CardController({required super.game});

  restart() {
    _player = null;
    _cardResolver = null;
    _reactionResolvers.clear();
    _cardsShown = 0;
    notifyListeners();
  }

  _State get _state {
    if (_reactionResolvers.isNotEmpty) {
      if (_reactionResolvers.first.isSelected) {
        return _State.resolvingReaction;
      } else {
        return _State.pendingReaction;
      }
    } else {
      if (_cardResolver != null) {
        return _State.resolvingNonReactionCard;
      } else if (_chooseActionGroupCompleter != null) {
        return _State.choosingActionGroup;
      } else {
        return _State.idle;
      }
    }
  }

  TileModel? get actor {
    switch (_state) {
      case _State.resolvingNonReactionCard:
        return _cardResolver?.actor;
      case _State.resolvingReaction:
        return _reactionResolvers.firstOrNull?.actor;
      case _State.choosingActionGroup:
      case _State.pendingReaction:
      case _State.idle:
        return null;
    }
  }

  HexCoordinate? get targetCoordinate {
    switch (_state) {
      case _State.resolvingNonReactionCard:
        return _cardResolver?.targetCoordinate;
      case _State.resolvingReaction:
        return _reactionResolvers.firstOrNull?.targetCoordinate;
      case _State.choosingActionGroup:
      case _State.pendingReaction:
      case _State.idle:
        return null;
    }
  }

  String? debugStringForCoordinate(HexCoordinate coordinate) {
    switch (_state) {
      case _State.resolvingNonReactionCard:
        return _cardResolver?.debugStringForCoordinate(coordinate);
      case _State.resolvingReaction:
        return _reactionResolvers.firstOrNull
            ?.debugStringForCoordinate(coordinate);
      case _State.choosingActionGroup:
      case _State.pendingReaction:
      case _State.idle:
        return null;
    }
  }

  bool get isPlayingCard {
    switch (_state) {
      case _State.resolvingNonReactionCard:
      case _State.resolvingReaction:
      case _State.choosingActionGroup:
        return true;
      case _State.pendingReaction:
      case _State.idle:
        return false;
    }
  }

  String? get instruction {
    switch (_state) {
      case _State.resolvingNonReactionCard:
        return _cardResolver?.instruction;
      case _State.resolvingReaction:
        return _reactionResolvers.firstOrNull?.instruction;
      case _State.pendingReaction:
        return 'Reaction: ${_reactionResolvers.firstOrNull?.player.name}';
      case _State.choosingActionGroup:
        return 'Select which half of the card to play';
      case _State.idle:
        return null;
    }
  }

  CardResolver? get cardResolver {
    switch (_state) {
      case _State.resolvingNonReactionCard:
        return _cardResolver;
      case _State.resolvingReaction:
        return _reactionResolvers.firstOrNull?.cardResolver;
      case _State.choosingActionGroup:
      case _State.pendingReaction:
      case _State.idle:
        return null;
    }
  }

  bool canSelectPlayer(PlayerUnitModel player) {
    switch (_state) {
      case _State.pendingReaction:
        return player.canPlayReaction;
      case _State.resolvingNonReactionCard:
        return player == model.currentTurnUnit;
      case _State.resolvingReaction:
        return player == reactionPlayer;
      case _State.idle:
        return true;
      case _State.choosingActionGroup:
        return false;
    }
  }

  onSelectedAbility(
      {required PlayerUnitModel player,
      SummonModel? summon,
      required AbilityModel ability}) {
    if (model.currentTurnUnit != player) {
      return;
    }

    if (model.isPlayingCard || _cardResolver != null) {
      return;
    }

    log.addRecord(player,
        'Playing ${ability.name} ability${summon != null ? ' of ${EncounterLogEntry.targetKeyword}' : ''}',
        target: summon);

    summon?.startedTurn = true;
    _cardResolver =
        CardResolver(player: player, summon: summon, card: ability, game: game);
    _cardResolver!.resolve().then((resolved) {
      if (resolved) {
        summon?.endedTurn = true;
        log.addRecord(player, 'Resolved ${ability.name} ability');
        player.onPlayedAbility(ability);
      } else {
        summon?.startedTurn = false;
        log.addRecord(player, 'Cancelled ${ability.name}');
      }
      _cardResolver = null;
      game.overlays.remove('action_menu');
    });
    _cardResolver!.addListener(() {
      notifyListeners();
    });
    game.overlays.add('action_menu');
  }

  cancelSkill() {
    log.addRecord(_player, 'Cancelled ${model.activeSkill!.name} skill');
    _player?.onCancelledPlayingSkill(model.activeSkill!);
    model.activeSkill = null;
    _player = null;
    game.overlays.remove('skill_ether_selection_menu');
  }

  confirmSkill() {
    assert(model.activeSkill?.isConfirmable == true);
    game.overlays.remove('skill_ether_selection_menu');
    playSkill(_player!, model.activeSkill!);
  }

  onActionGroupSelected(int index) {
    assert(_chooseActionGroupCompleter != null);
    _chooseActionGroupCardComponent!.removeFromParent();
    _chooseActionGroupCompleter!.complete(index);
    _chooseActionGroupCompleter = null;
  }

  Completer<int>? _chooseActionGroupCompleter;
  PositionComponent? _chooseActionGroupCardComponent;

  Future<int> _selectActionGroupOfSkill(
      PlayerUnitModel player, SkillModel skill) {
    assert(_chooseActionGroupCompleter == null);
    _chooseActionGroupCompleter = Completer();

    _chooseActionGroupCardComponent =
        showCard(card: skill, unit: player, selectingGroup: true);

    return _chooseActionGroupCompleter!.future;
  }

  playSkill(PlayerUnitModel player, SkillModel skill) async {
    model.activeSkill = skill;
    player.onStartedPlayingSkill(skill);

    var actionGroup = 0;
    if (skill.hasExclusiveGroups) {
      actionGroup = await _selectActionGroupOfSkill(player, skill);
      log.addRecord(player,
          'Selected ${skill.groupDescriptionForIndex(actionGroup)} of ${skill.name}');
    }

    _cardResolver = CardResolver(
        player: player, card: skill, game: game, actionGroup: actionGroup);
    _cardResolver!.resolve().then((resolved) {
      if (resolved) {
        log.addRecord(player, 'Resolved ${skill.name} skill');
        player.onPlayedSkill(skill);
      } else {
        log.addRecord(player, 'Cancelled ${skill.name} skill');
        player.onCancelledPlayingSkill(skill);
      }
      _cardResolver = null;
      model.activeSkill = null;
      _player = null;
      game.overlays.remove('action_menu');
    });
    _cardResolver!.addListener(() {
      notifyListeners();
    });
    game.overlays.add('action_menu');
  }

  onSelectedPersonalPoolEther(Ether ether,
      {required int index, required bool selected}) {
    if (model.activeSkill?.isPlaying == false) {
      final skill = model.activeSkill!;
      skill.selectEther(ether, index: index, selected: selected);
      _player?.selectEtherForSkill(skill.selectedEther);
    } else if (selected) {
      cardResolver?.onSelectedPersonalPoolEther(ether);
    }
  }

  onSelectedInfusedEther(List<Ether> ether) {
    cardResolver?.onSelectedInfusedEther(ether);
  }

  onSelectedSkill(
      {required PlayerUnitModel player, required SkillModel skill}) {
    if (model.currentTurnUnit != player) {
      return;
    }

    switch (_state) {
      case _State.resolvingNonReactionCard:
      case _State.resolvingReaction:
        cardResolver?.onSelectedFlippableCard(skill);
        break;
      case _State.pendingReaction:
      case _State.choosingActionGroup:
        break;
      case _State.idle:
        log.addRecord(player, 'Playing ${skill.name} skill');
        if (skill.etherCost > 0 && !kDebugMode) {
          model.activeSkill = skill;
          _player = player;
          game.overlays.add('skill_ether_selection_menu');
          return;
        }

        playSkill(player, skill);
        break;
    }
  }

  /* Reactions */

  PlayerUnitModel? get reactionPlayer => _reactionResolvers.firstOrNull?.player;
  RoveEvent? get reactionEvent => _reactionResolvers.firstOrNull?.event;

  int selectedReactionsForPlayerCount(PlayerUnitModel player) =>
      _reactionResolvers
          .where((r) => r.player == player && r.isSelected)
          .length;

  Future<void> resolveReaction(
      {required RoveEvent event,
      required PlayerUnitModel player,
      required ReactionModel reaction}) async {
    if (_cardResolver != null) {
      game.overlays.remove('action_menu');
    }
    final resolver = ReactionResolver(
        game: game, event: event, player: player, reaction: reaction);
    resolver.addListener(() {
      notifyListeners();
    });
    _reactionResolvers.insert(0, resolver);
    await resolver.resolve();
    _reactionResolvers.remove(resolver);
    if (_cardResolver != null) {
      game.overlays.add('action_menu');
    }
    if (model.currentPlayer != null) {
      game.onSelectedPlayer(model.currentPlayer!);
    }
  }

  onSelectedReaction(
      {required PlayerUnitModel player, required ReactionModel reaction}) {
    switch (_state) {
      case _State.pendingReaction:
        _reactionResolvers.firstOrNull
            ?.onSelectedReaction(player: player, reaction: reaction);
        break;
      case _State.resolvingReaction:
      case _State.resolvingNonReactionCard:
        _cardResolver!.onSelectedFlippableCard(reaction);
        break;
      case _State.idle:
      case _State.choosingActionGroup:
        break;
    }
  }

  void onSelectedItem(
      {required PlayerUnitModel player, required ItemModel item}) {
    switch (_state) {
      case _State.pendingReaction:
      case _State.resolvingReaction:
      case _State.resolvingNonReactionCard:
      case _State.choosingActionGroup:
        break;
      case _State.idle:
        _resolveItem(item, player);
    }
  }

  Future<void> _resolveItem(ItemModel item, PlayerUnitModel player) async {
    assert(player == player);
    log.addRecord(player, 'Playing ${item.name} item');

    final resolver = CardResolver(player: player, card: item, game: game);
    _cardResolver = resolver;
    game.overlays.add('action_menu');
    resolver.addListener(() {
      notifyListeners();
    });
    final resolved = await resolver.resolve();
    if (resolved) {
      log.addRecord(player, 'Consumed ${item.name} item');
      item.didPlay();
    } else {
      log.addRecord(player, 'Cancelled ${item.name} item');
    }
    _cardResolver = null;
    game.overlays.remove('action_menu');
  }

  skipReaction() {
    _reactionResolvers.firstOrNull?.skip();
  }

  PositionComponent showCard(
      {required CardModel card,
      required UnitModel unit,
      bool selectingGroup = false}) {
    final map = game.map;
    PositionComponent component = CardComponent.fromCard(
        card: card, unit: unit, selectingGroup: selectingGroup);
    component.position = Vector2(
        map.position.x + map.size.x + 20,
        map.position.y +
            (map.size.y - component.height) / 2 +
            _cardsShown * 40);
    game.world.add(component);
    _cardsShown++;
    return component;
  }

  removeCard(PositionComponent card) {
    card.removeFromParent();
    _cardsShown--;
  }
}
