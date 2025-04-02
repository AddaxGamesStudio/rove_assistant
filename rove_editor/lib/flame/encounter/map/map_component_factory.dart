import 'package:flame/components.dart';
import 'package:rove_editor/flame/encounter/tiles/ether_node_component.dart';
import 'package:rove_editor/flame/encounter/tiles/feature_component.dart';
import 'package:rove_editor/flame/encounter/tiles/field_component.dart';
import 'package:rove_editor/flame/encounter/tiles/glyph_component.dart';
import 'package:rove_editor/flame/encounter/tiles/trap_component.dart';
import 'package:rove_editor/flame/encounter/units/enemy_component.dart';
import 'package:rove_editor/flame/encounter/coordinate_component.dart';
import 'package:rove_editor/flame/encounter/map/map_space_component.dart';
import 'package:rove_editor/flame/encounter/units/large_enemy_component.dart';
import 'package:rove_editor/flame/encounter/units/object_component.dart';
import 'package:rove_editor/flame/encounter/units/unit_component.dart';
import 'package:rove_editor/flame/map_editor.dart';
import 'package:rove_editor/model/tiles/enemy_model.dart';
import 'package:rove_editor/model/tiles/ether_node_model.dart';
import 'package:rove_editor/model/tiles/feature_model.dart';
import 'package:rove_editor/model/tiles/field_model.dart';
import 'package:rove_editor/model/tiles/glyph_model.dart';
import 'package:rove_editor/model/tiles/object_model.dart';
import 'package:rove_editor/model/editable_map_model.dart';
import 'package:rove_editor/model/tiles/tile_model.dart';
import 'package:rove_editor/model/tiles/trap_model.dart';
import 'package:hex_grid/hex_grid.dart';

class MapComponentFactory {
  final MapEditor game;
  final Map<String, UnitComponent> units = {};
  final List<ObjectComponent> objects = [];
  final List<CoordinateComponent> tiles = [];
  final Map<HexCoordinate, MapSpaceComponent> spaces = {};
  final EditableMapModel model;

  MapComponentFactory({required this.model, required this.game}) {
    _initialize();
  }

  _initialize() {
    for (EnemyModel enemy in model.adversaries) {
      _initializeEnemy(enemy);
    }
    for (ObjectModel object in model.objects.values) {
      objects.add(ObjectComponent(model: object));
    }
    for (TrapModel trap in model.traps.values) {
      tiles.add(TrapComponent(model: trap));
    }
    for (EtherNodeModel etherNode in model.etherNodes.values) {
      tiles.add(EtherNodeComponent(model: etherNode));
    }
    for (GlyphModel glyph in model.glyphs.values) {
      tiles.add(GlyphComponent(model: glyph));
    }
    for (FieldModel field in model.fields.values) {
      tiles.add(FieldComponent(model: field));
    }
    for (FeatureModel feature in model.features.values) {
      tiles.add(FeatureComponent(model: feature));
    }
    for (HexCoordinate coordinate in model.terrain.keys) {
      final terrain = model.terrain[coordinate]!;
      final space = MapSpaceComponent(terrain: terrain);
      space.size = CoordinateComponent.defaultSize;
      space.anchor = Anchor.center;
      spaces[coordinate] = space;
    }
  }

  _removeSlainUnits() {
    final unitsCopy = units.values.toList();
    for (UnitComponent unit in unitsCopy) {
      if (unit.isSlain) {
        units.remove(unit.modelKey);
      }
    }
  }

  update() {
    _removeSlainUnits();
  }

  PositionComponent _initializeEnemy(EnemyModel model) {
    final UnitComponent component = model.large
        ? LargeEnemyComponent(model: model)
        : EnemyComponent(model: model);
    units[model.key] = component;
    return component;
  }

  List<PositionComponent> initializeModels(List<TileModel> models) {
    final components = <PositionComponent>[];
    for (final model in models) {
      if (model is EnemyModel) {
        components.add(_initializeEnemy(model));
      } else if (model is TrapModel) {
        components.add(TrapComponent(model: model));
      } else if (model is ObjectModel) {
        components.add(ObjectComponent(model: model));
      } else if (model is EtherNodeModel) {
        components.add(EtherNodeComponent(model: model));
      } else if (model is FeatureModel) {
        components.add(FeatureComponent(model: model));
      } else if (model is FieldModel) {
        components.add(FieldComponent(model: model));
      }
    }
    return components;
  }
}
