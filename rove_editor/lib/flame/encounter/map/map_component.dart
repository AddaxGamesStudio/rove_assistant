import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/palette.dart';
import 'package:flutter/foundation.dart';
import 'package:rove_data_types/rove_data_types.dart';
import 'package:rove_editor/flame/encounter/coordinate_component.dart';
import 'package:rove_editor/flame/encounter/hex_component.dart';
import 'package:rove_editor/flame/encounter/map/map_space_component.dart';
import 'package:rove_editor/flame/encounter/map/map_component_factory.dart';
import 'package:rove_editor/flame/encounter/tiles/glyph_component.dart';
import 'package:rove_editor/flame/encounter/units/object_component.dart';
import 'package:rove_editor/flame/encounter/units/unit_component.dart';
import 'package:rove_editor/flame/map_editor.dart';
import 'package:rove_editor/model/editable_map_model.dart';
import 'package:hex_grid/hex_grid.dart';
import 'package:rove_editor/controller/editor_controller.dart';
import 'package:rove_editor/model/tiles/enemy_model.dart';
import 'package:rove_editor/model/tiles/ether_node_model.dart';
import 'package:rove_editor/model/tiles/field_model.dart';
import 'package:rove_editor/model/tiles/object_model.dart';
import 'package:rove_editor/model/tiles/trap_model.dart';
import 'package:rove_editor/model/tiles/unit_model.dart';

class MapComponent extends PositionComponent
    with
        TapCallbacks,
        PointerMoveCallbacks,
        HasGameReference<MapEditor>,
        ChangeNotifier {
  static const int uiPriority = 100;
  static const int unitPriority = 90;
  static const int objectPriority = 89;
  static const int trapPriority = 85;
  static const int glyphPriority = 70;
  static const int fieldPriority = 80;
  static const int featurePriority = 20;
  static const int targetPriority = 11;
  static const int spacePriority = 10;

  final EditableMapModel model;
  final MapComponentFactory components;

  final int columnCount;
  final int rowCount;
  MapSpaceComponent? _selectedSpace;
  MapSpaceComponent? _focusedSpace;
  CoordinateComponent? _focusedComponent;
  late PositionComponent _foreground;

  MapComponent({required this.model, required this.components})
      : columnCount = model.map.columnCount,
        rowCount = model.map.rowCount,
        super(
          size: Vector2(
              HexComponent.xSpacing * (model.map.columnCount - 1) +
                  HexComponent.defaultSize.x,
              HexComponent.defaultSize.y * model.map.rowCount),
        ) {
    _foreground = PositionComponent(size: size);
    add(_foreground);
  }

  HexCoordinate? get selectedCoordinate => _selectedSpace?.coordinate;

  List<T> componentsAtCoordinate<T extends CoordinateComponent>(
      HexCoordinate coordinate) {
    return children.whereType<T>().where((c) {
      return c.occupiesCoordinate(coordinate);
    }).toList();
  }

  MapSpaceComponent? spaceAtCoordinate(HexCoordinate coordinate) {
    return components.spaces[coordinate];
  }

  MapSpaceComponent? spaceAtPosition(Vector2 position) {
    final components =
        componentsAtPoint(position).whereType<MapSpaceComponent>();
    if (components.isEmpty) {
      return null;
    }
    var closestTile = components.first;
    var closestDistance = closestTile.center.distanceTo(position);
    for (final tile in components.skip(1)) {
      final distance = tile.center.distanceTo(position);
      if (distance < closestDistance) {
        closestTile = tile;
        closestDistance = distance;
      }
    }
    return closestTile;
  }

  Vector2? centerForCoordinate(HexCoordinate coordinate) {
    coordinate = coordinate.toEvenQ();
    final (q, r) = (coordinate.q, coordinate.r);
    if (q < 0 || q >= columnCount || r < 0 || r >= rowCount) {
      return null;
    }
    final isLastRow = r == rowCount - 1;
    final isEvenColum = q % 2 == 0;
    if (isLastRow && isEvenColum) {
      return null;
    }
    return Vector2(
        HexComponent.defaultSize.x / 2 + q * HexComponent.xSpacing,
        HexComponent.defaultSize.y / 2 +
            r * HexComponent.ySpacing +
            HexComponent.ySpacing / 2 * (1 - (q % 2)));
  }

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();
    await model.loadBackgroundForId(model.id);
    _foreground.addAll(components.spaces.values);
    _foreground.addAll(components.units.values);
    _foreground.addAll(components.tiles);
    _foreground.addAll(components.objects);
  }

  @override
  void render(Canvas canvas) {
    components.update();
    super.render(canvas);
    final background = model.background;
    if (background != null) {
      canvas.drawImageRect(
          background,
          model.backgroundRect,
          Rect.fromLTWH(0, 0, size.x, size.y),
          Paint()..color = BasicPalette.white.color.withValues(alpha: 0.75));
    }
  }

  @override
  void onTapUp(TapUpEvent event) {
    super.onTapUp(event);
    final space = spaceAtPosition(event.localPosition);
    if (space != _selectedSpace) {
      notifyListeners();
    }
    _selectedSpace?.selected = false;
    space?.selected = true;
    _selectedSpace = space;
    if (space == null) {
      return;
    }
    final coordinate = space.coordinate;

    final editor = EditorController.instance;
    final toolTerrain = editor.toolTerrain;
    final toolAdversary = editor.toolAdversary;
    final toolObject = editor.toolObject;
    final toolSpawnPoint = editor.toolSpawnPoint;
    final toolEther = editor.toolEther;
    final toolField = editor.toolField;
    final toolTrap = editor.toolTrap;
    final toolFeature = editor.toolFeature;
    if (editor.toolClear) {
      _removeCurrentAtCoordinate(coordinate);
    } else if (toolTerrain != null) {
      _stampTerrain(toolTerrain, space: space);
    } else if (toolFeature != null) {
      if (model.features[coordinate]?.name == toolFeature) {
        _removeFeatureAtCoordinate(coordinate);
      } else {
        _setFeature(name: toolFeature, coordinate: coordinate);
      }
    } else if (toolAdversary != null) {
      _stampAdversaryNamed(toolAdversary.name, coordinate: coordinate);
    } else if (toolObject != null) {
      _stampObjectNamed(toolObject.name, coordinate: coordinate);
    } else if (toolSpawnPoint != null) {
      _stampSpawnPoint(toolSpawnPoint, coordinate: coordinate);
    } else if (toolEther != null) {
      _stampEther(toolEther, coordinate: coordinate);
    } else if (toolField != null) {
      _stampEtherField(toolField, coordinate: coordinate);
    } else if (toolTrap != null) {
      _stampTrap(toolTrap, coordinate: coordinate);
    }
  }

  @override
  void onPointerMove(PointerMoveEvent event) {
    super.onPointerMove(event);
    final space = spaceAtPosition(event.localPosition);
    _focusedSpace?.focused = false;
    space?.focused = true;
    _focusedSpace = space;

    if (space != null) {
      final unit = componentsAtCoordinate<UnitComponent>(space.coordinate)
              .firstOrNull ??
          componentsAtCoordinate<ObjectComponent>(space.coordinate)
              .firstOrNull ??
          componentsAtCoordinate<GlyphComponent>(space.coordinate).firstOrNull;
      _focusedComponent?.focused = false;
      if (unit != null) {
        unit.focused = true;
        _focusedComponent = unit;
      }
    }
  }

  @override
  void onPointerMoveStop(PointerMoveEvent event) {
    super.onPointerMoveStop(event);
    _focusedSpace?.focused = false;
    _focusedSpace = null;
    _focusedComponent?.focused = false;
    _focusedComponent = null;
  }

  /* Stamps */

  _stampTerrain(TerrainType terrain, {required MapSpaceComponent space}) {
    switch (terrain) {
      case TerrainType.start:
        space.terrain.isStart = !space.terrain.isStart;
      case TerrainType.exit:
        space.terrain.isExit = !space.terrain.isExit;
      default:
        if (space.terrain.terrain == terrain) {
          space.terrain.terrain = TerrainType.normal;
        } else {
          space.terrain.terrain = terrain;
        }
    }
  }

  void _stampAdversaryNamed(String name, {required HexCoordinate coordinate}) {
    final unit = model.units[coordinate];
    if (unit != null) {
      if (unit is EnemyModel && unit.className == name) {
        if (unit.minPlayerCount < 4) {
          unit.minPlayerCount++;
        } else {
          _removeUnit(unit);
        }
        return;
      } else {
        _removeUnit(unit);
      }
    }
    final placement = PlacementDef(
        name: name,
        type: PlacementType.enemy,
        minPlayers: 2,
        c: coordinate.toEvenQ().q,
        r: coordinate.toEvenQ().r);
    _spawnPlacements(placements: [placement]);
  }

  void _stampObjectNamed(String name, {required HexCoordinate coordinate}) {
    if (model.objects[coordinate]?.name == name) {
      _removeCurrentAtCoordinate(coordinate);
      return;
    }
    _removeCurrentAtCoordinate(coordinate);
    final placement = PlacementDef(
        name: name,
        type: PlacementType.object,
        c: coordinate.toEvenQ().q,
        r: coordinate.toEvenQ().r);
    _spawnPlacements(placements: [placement]);
  }

  void _stampEther(Ether ether, {required HexCoordinate coordinate}) {
    if (model.etherNodes[coordinate]?.ether == ether) {
      _removeCurrentAtCoordinate(coordinate);
      return;
    }
    _removeCurrentAtCoordinate(coordinate);
    final placement = PlacementDef(
        name: ether.toJson(),
        type: PlacementType.ether,
        c: coordinate.toEvenQ().q,
        r: coordinate.toEvenQ().r);
    _spawnPlacements(placements: [placement]);
  }

  void _stampEtherField(EtherField field, {required HexCoordinate coordinate}) {
    if (model.fields[coordinate]?.field == field) {
      _removeCurrentAtCoordinate(coordinate);
      return;
    }
    _removeCurrentAtCoordinate(coordinate);
    final placement = PlacementDef(
        name: field.toJson(),
        type: PlacementType.field,
        c: coordinate.toEvenQ().q,
        r: coordinate.toEvenQ().r);
    _spawnPlacements(placements: [placement]);
  }

  void _stampTrap(String name, {required HexCoordinate coordinate}) {
    if (model.traps[coordinate]?.name == name) {
      _removeCurrentAtCoordinate(coordinate);
      return;
    }
    _removeCurrentAtCoordinate(coordinate);
    final placement = PlacementDef(
        name: name,
        type: PlacementType.trap,
        trapDamage: 3,
        c: coordinate.toEvenQ().q,
        r: coordinate.toEvenQ().r);
    _spawnPlacements(placements: [placement]);
  }

  _removeCurrentAtCoordinate(HexCoordinate coordinate,
      {bool isClearTool = true}) {
    final unit = model.units[coordinate];
    if (unit != null) {
      _removeUnit(unit);
      if (isClearTool) {
        return;
      }
    }
    final object = model.objects[coordinate];
    if (object != null) {
      _removeObject(object);
      if (isClearTool) {
        return;
      }
    }
    final trap = model.traps[coordinate];
    if (trap != null) {
      _removeTrap(trap);
      if (isClearTool) {
        return;
      }
    }
    final ether = model.etherNodes[coordinate];
    if (ether != null) {
      _removeEther(ether);
      if (isClearTool) {
        return;
      }
    }

    final field = model.fields[coordinate];
    if (field != null) {
      _removeField(field);
      if (isClearTool) {
        return;
      }
    }

    if (isClearTool) {
      spaceAtCoordinate(coordinate)?.terrain.terrain = TerrainType.normal;
    }
  }

  _removeFeatureAtCoordinate(HexCoordinate coordinate) {
    final feature = model.features[coordinate];
    if (feature == null) {
      return;
    }
    final component = game.findByKey(ComponentKey.named(feature.key));
    component?.removeFromParent();
    model.removeFeature(feature);
  }

  _setFeature({required String name, required HexCoordinate coordinate}) {
    _removeFeatureAtCoordinate(coordinate);
    final placement = PlacementDef(
        name: name,
        type: PlacementType.feature,
        c: coordinate.toEvenQ().q,
        r: coordinate.toEvenQ().r);
    _spawnPlacements(placements: [placement]);
  }

  _removeUnit(UnitModel unit) {
    final component = game.findByKey(ComponentKey.named(unit.key));
    component?.removeFromParent();
    model.removeUnit(unit);
  }

  _removeObject(ObjectModel object) {
    final component = game.findByKey(ComponentKey.named(object.key));
    component?.removeFromParent();
    model.removeObject(object);
  }

  _removeTrap(TrapModel trap) {
    final component = game.findByKey(ComponentKey.named(trap.key));
    component?.removeFromParent();
    model.removeTrapAtCoordinate(trap.coordinate);
  }

  _removeEther(EtherNodeModel ether) {
    final component = game.findByKey(ComponentKey.named(ether.key));
    component?.removeFromParent();
    model.removeEtherNode(ether);
  }

  _removeField(FieldModel field) {
    final component = game.findByKey(ComponentKey.named(field.key));
    component?.removeFromParent();
    model.removeFieldAtCoordinate(field.coordinate);
  }

  _spawnPlacements({required List<PlacementDef> placements}) {
    final models = model.initializePlacements(placements);
    EditorController.instance.model.initializeUnitClassesIfNeeded(models);
    final components = game.map.components.initializeModels(models);
    _foreground.addAll(components);
  }

  void _stampSpawnPoint(Ether ether, {required HexCoordinate coordinate}) {
    final space = spaceAtCoordinate(coordinate);
    if (space == null) {
      return;
    }
    if (space.terrain.spawnPoint == ether) {
      space.terrain.spawnPoint = null;
    } else {
      space.terrain.spawnPoint = ether;
    }
  }

  void toggleForeground() {
    _foreground.parent = _foreground.parent == null ? this : null;
  }
}
