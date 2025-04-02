import 'package:rove_simulator/controller/player_action_resolver.dart';
import 'package:rove_simulator/model/tiles/tile_model.dart';

class SufferResolver extends PlayerActionResolver {
  final Slayable slayable;

  SufferResolver(
      {required super.cardResolver,
      required super.action,
      required this.slayable})
      : super(target: slayable);

  @override
  bool get resolvesWithoutUserInput => true;

  @override
  Future<bool> resolve() {
    mapController.suffer(
        actor: actor,
        target: slayable,
        amount: action.amount,
        onComplete: () {
          didResolve();
        });
    return super.resolve();
  }
}
