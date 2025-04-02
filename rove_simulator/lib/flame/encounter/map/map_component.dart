import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:rove_simulator/assets.dart';
import 'package:rove_simulator/flame/encounter/coordinate_component.dart';
import 'package:rove_simulator/flame/encounter/hex_component.dart';
import 'package:rove_simulator/flame/encounter/map/map_space_component.dart';
import 'package:rove_simulator/flame/encounter/map/map_component_factory.dart';
import 'package:rove_simulator/flame/encounter/map/target_component.dart';
import 'package:rove_simulator/flame/encounter/tiles/glyph_component.dart';
import 'package:rove_simulator/flame/encounter/units/object_component.dart';
import 'package:rove_simulator/flame/encounter/units/unit_component.dart';
import 'package:rove_simulator/flame/encounter_game.dart';
import 'package:rove_simulator/model/tiles/enemy_model.dart';
import 'package:rove_simulator/model/tiles/player_unit_model.dart';
import 'package:rove_simulator/model/map_model.dart';
import 'package:rove_simulator/model/tiles/summon_model.dart';
import 'package:hex_grid/hex_grid.dart';

class MapComponent extends PositionComponent
    with TapCallbacks, PointerMoveCallbacks, HasGameReference<EncounterGame> {
  static const int uiPriority = 100;
  static const int unitPriority = 90;
  static const int objectPriority = 89;
  static const int trapPriority = 85;
  static const int glyphPriority = 70;
  static const int fieldPriority = 80;
  static const int targetPriority = 11;
  static const int spacePriority = 10;

  final MapModel model;
  final MapComponentFactory components;

  final int columnCount;
  final int rowCount;
  final Rect backgroundRect;
  MapSpaceComponent? _selectedSpace;
  MapSpaceComponent? _focusedSpace;
  CoordinateComponent? _focusedComponent;

  late Image _background;

  MapComponent({required this.model, required this.components})
      : columnCount = model.map.columnCount,
        rowCount = model.map.rowCount,
        backgroundRect = model.map.backgroundRect,
        super(
          size: Vector2(
              HexComponent.xSpacing * (model.map.columnCount - 1) +
                  HexComponent.defaultSize.x,
              HexComponent.defaultSize.y * model.map.rowCount),
        );

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
    _background =
        await Assets.campaignImages.loadMap('${model.encounter.id}.webp');
    addAll(components.spaces.values);
    addAll(components.units.values);
    addAll(components.tiles);
    addAll(components.objects);
    add(TargetComponent(size: size, priority: targetPriority));
  }

  @override
  void render(Canvas canvas) {
    components.update();
    super.render(canvas);
    canvas.drawImageRect(_background, backgroundRect,
        Rect.fromLTWH(0, 0, size.x, size.y), Paint());
  }

  @override
  void onTapUp(TapUpEvent event) {
    super.onTapUp(event);
    final space = spaceAtPosition(event.localPosition);
    _selectedSpace?.selected = false;
    space?.selected = true;
    _selectedSpace = space;
    if (space == null) {
      return;
    }
    final coordinate = space.coordinate;
    if (game.cardResolver?.onSelectedCoordinate(coordinate) == true) {
      return;
    }
    final unit = model.units[coordinate];
    if (unit == null) {
      if (game.turnController.onSelectedTerrain(space.terrain)) {
        return;
      }
    }

    if (unit is PlayerUnitModel) {
      game.onSelectedPlayer(unit);
    } else if (unit is SummonModel) {
      game.onSelectedPlayer(unit.summoner);
    } else if (unit is EnemyModel) {
      game.onSelectedEnemy(unit);
    }
  }

  @override
  void onPointerMove(PointerMoveEvent event) {
    super.onPointerMove(event);
    final space = spaceAtPosition(event.localPosition);
    if (space != null) {
      game.cardResolver?.onHoveredCoordinate(space.coordinate);
    }
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
}
