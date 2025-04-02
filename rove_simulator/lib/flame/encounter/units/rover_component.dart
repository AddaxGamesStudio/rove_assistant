import 'dart:math';

import 'package:flame/components.dart';
import 'package:rove_simulator/assets.dart';
import 'package:rove_simulator/flame/encounter/units/hexagon_tile_component.dart';
import 'package:rove_simulator/flame/encounter/units/hexagon_unit_component.dart';
import 'package:rove_simulator/flame/encounter_game.dart';
import 'package:rove_simulator/model/tiles/player_unit_model.dart';
import 'package:rove_data_types/rove_data_types.dart';

class RoverComponent extends HexagonUnitComponent
    with HasGameReference<EncounterGame> {
  final PlayerUnitModel player;
  final RoverClass roverClass;

  late final PositionComponent _reactionComponent;

  RoverComponent({
    required this.player,
  })  : roverClass = player.roverClass,
        super(model: player);

  @override
  void onLoad() {
    super.onLoad();
    _reactionComponent = SpriteComponent(
        sprite: Assets.reactionSprite, size: Vector2(30, 30), angle: -pi / 4);
    _reactionComponent.center =
        tileComponent.positionOf(HexagonTileComponent.vertextAtIndex(5));
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (player.canPlayReaction) {
      _reactionComponent.parent = this;
    } else {
      _reactionComponent.parent = null;
    }
    tileComponent.isGrayscale = player.isDowned;
  }
}
