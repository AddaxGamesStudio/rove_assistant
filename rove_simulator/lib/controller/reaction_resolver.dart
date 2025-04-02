import 'dart:async';

import 'package:rove_simulator/controller/base_controller.dart';
import 'package:rove_simulator/controller/card_resolver.dart';
import 'package:rove_simulator/controller/event_controller.dart';
import 'package:rove_simulator/model/cards/reaction_model.dart';
import 'package:rove_simulator/model/tiles/player_unit_model.dart';
import 'package:rove_simulator/model/tiles/tile_model.dart';
import 'package:hex_grid/hex_grid.dart';

class ReactionResolver extends BaseController {
  final RoveEvent event;
  final PlayerUnitModel player;
  final ReactionModel reaction;

  ReactionResolver(
      {required super.game,
      required this.event,
      required this.player,
      required this.reaction});

  late Completer<void> _reactionCompleter;
  CardResolver? _cardResolver;

  Future<void> resolve() {
    reaction.canPlay = true;
    _reactionCompleter = Completer();
    game.overlays.add('reaction_menu');
    game.onSelectedPlayer(player);
    return _reactionCompleter.future;
  }

  bool get isSelected => _cardResolver != null;
  String? get instruction => _cardResolver?.instruction;
  CardResolver? get cardResolver => _cardResolver;
  TileModel? get actor => _cardResolver?.actor;
  HexCoordinate? get targetCoordinate => _cardResolver?.targetCoordinate;
  String? debugStringForCoordinate(HexCoordinate coordinate) {
    return _cardResolver?.debugStringForCoordinate(coordinate);
  }

  onSelectedReaction(
      {required PlayerUnitModel player, required ReactionModel reaction}) {
    assert(player == this.player);
    assert(reaction == this.reaction);
    log.addRecord(player, 'Playing ${reaction.name} reaction');
    game.overlays.remove('reaction_menu');
    // Decrement reaction count early in case the reaction triggers more reactions
    player.availableReactionCount--;
    _cardResolver =
        CardResolver(player: player, card: reaction, game: game, event: event);
    _cardResolver!.resolve().then((resolved) {
      if (resolved) {
        log.addRecord(player, 'Resolved ${reaction.name} reaction');
        player.onPlayedReaction(reaction);
        _didResolveReaction();
      } else {
        // Restore reaction count if the reaction was cancelled
        player.availableReactionCount++;
        log.addRecord(player, 'Cancelled ${reaction.name} reaction');
        game.overlays.add('reaction_menu');
      }
      game.overlays.remove('action_menu');
      notifyListeners();
    });
    _cardResolver!.addListener(() {
      notifyListeners();
    });
    game.overlays.add('action_menu');
  }

  _didResolveReaction() {
    reaction.canPlay = false;
    _reactionCompleter.complete();
  }

  skip() {
    log.addRecord(player, 'Skipped reaction');
    game.overlays.remove('reaction_menu');
    _didResolveReaction();
    notifyListeners();
  }
}
