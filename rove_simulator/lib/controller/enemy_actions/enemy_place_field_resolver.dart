import 'dart:async';

import 'package:rove_simulator/controller/enemy_actions/enemy_action_resolver.dart';
import 'package:hex_grid/hex_grid.dart';

class EnemyPlaceFieldResolver extends EnemyActionResolver {
  final HexCoordinate destination;

  EnemyPlaceFieldResolver(
      {required super.game,
      required super.actor,
      required this.destination,
      required super.action})
      : super(targets: []);

  Completer<bool> completer = Completer();

  @override
  Future<bool> execute() async {
    assert(action.field != null);
    if (action.field == null) {
      return false;
    }
    mapController.addField(action.field!,
        creator: actor, coordinate: destination);
    return true;
  }
}
