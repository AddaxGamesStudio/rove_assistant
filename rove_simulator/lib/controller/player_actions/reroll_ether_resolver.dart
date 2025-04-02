import 'package:rove_simulator/controller/card_resolver.dart';
import 'package:rove_simulator/controller/player_action_resolver.dart';
import 'package:rove_data_types/rove_data_types.dart';

class RerollEtherResolver extends PlayerActionResolver with Confirmable {
  RerollEtherResolver({required super.cardResolver, required super.action});

  @override
  bool get isSkippable => true;

  @override
  Future<bool> resolve() async {
    if (cardResolver.availableEtherFromPersonalPool.isEmpty) {
      log.addRecord(actor, 'No ether in personal pool; skipping reroll ether');
      return false;
    }
    return super.resolve();
  }

  @override
  bool confirm() {
    assert(cardResolver.availableEtherFromPersonalPool.isNotEmpty);
    final etherToReroll = player.personalEtherPool.last;
    player.removeEther(etherToReroll);
    final rerolledEther = Ether.randomNonDimEther();
    player.addEther(rerolledEther);
    log.addRecord(actor,
        'Rerolled ${etherToReroll.label} ether into ${rerolledEther.label} ether');
    didResolve();
    return true;
  }

  @override
  String get confirmLabel => 'Confirm Reroll';

  @override
  bool get isConfirmable =>
      cardResolver.availableEtherFromPersonalPool.isNotEmpty;
}
