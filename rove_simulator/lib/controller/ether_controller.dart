import 'dart:async';

import 'package:rove_data_types/rove_data_types.dart';
import 'package:rove_simulator/controller/base_controller.dart';
import 'package:rove_simulator/model/tiles/player_unit_model.dart';
import 'package:rove_simulator/widgets/encounter/actions/generate_ether_dialog.dart';

class EtherController extends BaseController {
  EtherController({required super.game});

  Future<void> generateEther(
      {required PlayerUnitModel player,
      List<Ether> etherOptions = const []}) async {
    late final Ether ether;
    if (etherOptions.length > 1) {
      ether = await _askWichEther(player, etherOptions);
    } else if (etherOptions.length == 1) {
      ether = etherOptions.first;
    } else {
      ether = Ether.randomNonDimEther();
    }
    player.addEther(ether);
    log.addRecord(player, 'Generated ${ether.label} ether');
    await eventController.onGeneratedEther(actor: player);
  }

  Future<Ether> _askWichEther(
      PlayerUnitModel player, List<Ether> etherOptions) async {
    const String overlayName = 'generate_ether_dialog';
    final completer = Completer<Ether>();
    game.showDialog(
        overlayName,
        (game) => GenerateEtherDialog(
            player: player,
            etherOptions: etherOptions,
            onSelectedEther: (ether) {
              game.overlays.remove(overlayName);
              completer.complete(ether);
            }));
    return completer.future;
  }
}
