import 'package:rove_simulator/controller/card_resolver.dart';
import 'package:rove_simulator/controller/player_action_resolver.dart';
import 'package:rove_data_types/rove_data_types.dart';

class RemoveEtherResolver extends PlayerActionResolver with EtherSelector {
  RemoveEtherResolver({required super.cardResolver, required super.action});

  bool get needsToSelectEther => player.personalEtherPool.length > 1;

  @override
  String get instruction =>
      needsToSelectEther ? 'Click on the Ether to Remove' : '';

  @override
  bool onSelectedPersonalPoolEther(Ether ether) {
    log.addRecord(player, 'Removed ${ether.label} ether');
    player.removeEther(ether);
    didResolve();
    return true;
  }

  @override
  Future<bool> resolve() async {
    if (needsToSelectEther) {
      return super.resolve();
    }

    if (player.personalEtherPool.isNotEmpty) {
      final ether = player.personalEtherPool.first;
      log.addRecord(player, 'Removed ${ether.label} ether');
      player.removeEther(ether);
      return true;
    } else {
      log.addRecord(
          player, 'No ether to remove; skipping ${action.shortDescription}');
      return false;
    }
  }
}
