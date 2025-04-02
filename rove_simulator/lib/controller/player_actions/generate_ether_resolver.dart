import 'package:rove_simulator/controller/ether_controller.dart';
import 'package:rove_simulator/controller/player_action_resolver.dart';
import 'package:rove_data_types/rove_data_types.dart';

class GenerateEtherResolver extends PlayerActionResolver {
  GenerateEtherResolver({required super.cardResolver, required super.action});

  List<Ether> get etherOptions => action.generateEtherOptions;

  @override
  bool get resolvesWithoutUserInput => etherOptions.length <= 1;

  @override
  Future<bool> resolve() async {
    final controller = EtherController(game: game);
    await controller.generateEther(player: player, etherOptions: etherOptions);
    return true;
  }
}
