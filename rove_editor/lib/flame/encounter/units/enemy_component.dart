import 'package:rove_editor/flame/encounter/units/hexagon_tile_component.dart';
import 'package:rove_editor/flame/encounter/units/tile_number_component.dart';
import 'package:rove_editor/flame/encounter/units/hexagon_unit_component.dart';
import 'package:rove_editor/model/tiles/enemy_model.dart';

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
    _numberComponent.parent = this;
  }
}
