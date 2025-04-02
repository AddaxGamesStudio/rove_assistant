import 'package:rove_simulator/flame/encounter/units/hexagon_tile_component.dart';
import 'package:rove_simulator/flame/encounter/units/tile_number_component.dart';
import 'package:rove_simulator/flame/encounter/units/hexagon_unit_component.dart';
import 'package:rove_simulator/model/tiles/enemy_model.dart';

class EnemyComponent extends HexagonUnitComponent {
  final EnemyModel model;
  late TileNumberComponent _numberComponent;

  EnemyComponent({required this.model}) : super(model: model);

  /* Unit Component */

  @override
  void onLoad() {
    super.onLoad();
    _numberComponent = TileNumberComponent(model: model);
    _numberComponent.center =
        tileComponent.positionOf(HexagonTileComponent.vertextAtIndex(4));
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (focused) {
      _numberComponent.parent = this;
    } else {
      _numberComponent.parent = null;
    }
  }
}
