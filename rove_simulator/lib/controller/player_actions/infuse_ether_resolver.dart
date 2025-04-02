import 'package:rove_simulator/controller/card_resolver.dart';
import 'package:rove_simulator/controller/player_action_resolver.dart';
import 'package:rove_data_types/rove_data_types.dart';

class InfuseEtherResolver extends PlayerActionResolver with EtherSelector {
  InfuseEtherResolver({required super.cardResolver, required super.action});

  List<Ether> get personalEtherPool => player.personalEtherPool;
  bool get needsToSelectEther =>
      personalEtherPool.length > 1 &&
      personalEtherPool.where((e) => e != personalEtherPool.first).isNotEmpty;

  @override
  String get instruction =>
      needsToSelectEther ? 'Click on the Ether to Infuse' : '';

  _infuse(Ether ether) {
    log.addRecord(player, 'Infused ${ether.label} ether');
    player.infuseEther(ether, fromPersonalPool: true);
  }

  @override
  bool onSelectedPersonalPoolEther(Ether ether) {
    _infuse(ether);
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
      _infuse(ether);
      return true;
    } else {
      log.addRecord(player,
          'Skipping ${action.shortDescription} due to no ether in personal pool');
      return false;
    }
  }
}
