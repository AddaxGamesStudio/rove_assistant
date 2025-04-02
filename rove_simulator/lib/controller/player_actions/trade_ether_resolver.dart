import 'package:rove_simulator/controller/player_action_resolver.dart';
import 'package:rove_simulator/model/encounter_log.dart';
import 'package:rove_simulator/model/tiles/player_unit_model.dart';
import 'package:rove_data_types/rove_data_types.dart';

class TradeEtherResolver extends PlayerActionResolver {
  PlayerUnitModel playerTarget;
  TradeEtherResolver(
      {required super.cardResolver,
      required super.action,
      required this.playerTarget});

  trade(Ether fromPlayerEther, Ether toPlayerEther) {
    assert(
        cardResolver.availableEtherFromPersonalPool.contains(fromPlayerEther));
    assert(playerTarget.personalEtherPool.contains(toPlayerEther));
    player.removeEther(fromPlayerEther);
    playerTarget.removeEther(toPlayerEther);
    player.addEther(toPlayerEther);
    log.addRecord(player,
        'Receiver ${toPlayerEther.label} ether from ${EncounterLogEntry.targetKeyword}',
        target: playerTarget);
    playerTarget.addEther(fromPlayerEther);
    log.addRecord(playerTarget,
        'Receiver ${fromPlayerEther.label} ether from ${EncounterLogEntry.targetKeyword}',
        target: player);
    cardResolver.game.overlays.remove('trade_ether');
    didResolve();
  }

  @override
  Future<bool> resolve() async {
    if (cardResolver.availableEtherFromPersonalPool.isEmpty) {
      log.addRecord(player,
          'No personal pool ether to trade; Skipping ${action.shortDescription}');
      return false;
    }
    if (playerTarget.personalEtherPool.isEmpty) {
      log.addRecord(player,
          '${EncounterLogEntry.targetKeyword} has no personal pool ether to trade; Skipping ${action.shortDescription}',
          target: playerTarget);
      return false;
    }
    cardResolver.game.overlays.add('trade_ether');
    return super.resolve();
  }
}
