import 'package:flame/components.dart';
import 'package:rove_editor/flame/encounter/coordinate_component.dart';
import 'package:rove_editor/flame/encounter/map/map_component.dart';
import 'package:rove_editor/flame/encounter/units/health_component.dart';
import 'package:rove_editor/flame/encounter/units/hexagon_tile_component.dart';
import 'package:rove_editor/model/tiles/object_model.dart';

class ObjectComponent extends CoordinateComponent {
  final ObjectModel _model;

  late SpriteComponent spriteComponent;
  HealthComponent? _healthComponent;

  ObjectComponent({required ObjectModel model})
      : _model = model,
        super(priority: MapComponent.objectPriority);

  @override
  ComponentKey? get key => ComponentKey.named(_model.key);

  @override
  void onMount() {
    super.onMount();
    coordinate = _model.coordinate;
  }

  @override
  void onLoad() {
    super.onLoad();

    addCentered(spriteComponent = SpriteComponent(
        sprite: Sprite(_model.image),
        size: Vector2(size.x * 0.9, size.y * 0.9)));

    if (_model.maxHealth > 0) {
      _healthComponent = HealthComponent(model: _model)
        ..center =
            spriteComponent.positionOf(HexagonTileComponent.vertextAtIndex(1));
      _healthComponent = HealthComponent(model: _model)
        ..center =
            spriteComponent.positionOf(HexagonTileComponent.vertextAtIndex(1));
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (focused) {
      _healthComponent?.parent = this;
      spriteComponent.opacity =
          game.model.hasEffectAtCoordinate(coordinate) ? 0.5 : 1.0;
    } else {
      _healthComponent?.parent = null;
      spriteComponent.opacity = 1;
    }
  }
}
