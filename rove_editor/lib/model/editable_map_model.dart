import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:rove_app_common/data/campaign_loader.dart';
import 'package:rove_editor/editor_assets.dart';
import 'package:rove_editor/model/editable_encounter_model.dart';
import 'package:rove_editor/model/path_type.dart';
import 'package:rove_editor/model/tiles/enemy_model.dart';
import 'package:rove_editor/model/tiles/enemy_unit_def.dart';
import 'package:rove_editor/model/tiles/ether_node_model.dart';
import 'package:rove_editor/model/tiles/feature_model.dart';
import 'package:rove_editor/model/tiles/field_model.dart';
import 'package:rove_editor/model/tiles/glyph_model.dart';
import 'package:rove_editor/model/tiles/object_def.dart';
import 'package:rove_editor/model/tiles/object_model.dart';
import 'package:rove_editor/model/tiles/terrain_model.dart';
import 'package:rove_editor/model/tiles/tile_model.dart';
import 'package:rove_editor/model/tiles/trap_model.dart';
import 'package:rove_editor/model/tiles/unit_model.dart';
import 'package:hex_grid/hex_grid.dart';
import 'package:rove_data_types/rove_data_types.dart';

class EditableMapModel extends ChangeNotifier {
  final EditableEncounterModel encounter;

  final counts = <String, int>{};
  final features = <HexCoordinate, FeatureModel>{};
  List<EnemyModel> adversaries = [];
  final Map<HexCoordinate, UnitModel> units = {};
  final Map<HexCoordinate, GlyphModel> glyphs = {};
  final Map<HexCoordinate, FieldModel> fields = {};
  final Map<HexCoordinate, TrapModel> traps = {};
  final Map<HexCoordinate, TerrainModel> terrain = {};
  final Map<HexCoordinate, ObjectModel> objects = {};
  final Map<HexCoordinate, EtherNodeModel> etherNodes = {};
  String _id;
  Rect _backgroundRect;
  final int columnCount;
  final int rowCount;
  final MapDef map;
  late CampaignDef _campaignDefinition;
  CampaignDef get campaignDefinition => _campaignDefinition;
  final List<PlacementDef> _startingPlacements;
  final String _name;

  EditableMapModel(
      {required this.encounter,
      required this.map,
      required String name,
      required List<PlacementDef> placements,
      CampaignDef? campaign})
      : _name = name,
        _startingPlacements = placements.toList(),
        columnCount = map.columnCount,
        rowCount = map.rowCount,
        _id = map.id,
        _backgroundRect = encounter.encounter.startingMap.backgroundRect {
    _campaignDefinition = campaign ?? CampaignLoader.instance.campaign;
    _initializeTerrain();
    _updateBackground();
    initializePlacements(_startingPlacements);
  }

  enemyCount(String className) {
    return units.values
        .where((e) => e is EnemyModel && e.className == className)
        .length;
  }

  EnemyModel? _initializeEnemy(
      PlacementDef placement, Map<String, int> variables) {
    final name = placement.name;
    final figureDef = _campaignDefinition.adversaries[name];
    assert(figureDef != null);
    if (figureDef == null) {
      return null;
    }

    final encounterFigureDef =
        encounter.encounter.adversaries.firstWhereOrNull((a) => a.name == name);

    counts[name] = (counts[name] ?? 0) + 1;
    final definition = EnemyUnitDef(
        minPlayerCount: placement.minPlayers,
        figureDef: figureDef,
        encounterFigureDef: encounterFigureDef,
        placement: placement);
    final coordinate = EvenQHexCoordinate(placement.c, placement.r);
    final enemy =
        EnemyModel(enemy: definition, coordinate: coordinate, map: this);
    enemy.coordinate = coordinate;

    _addEnemy(enemy);
    return enemy;
  }

  _addEnemy(EnemyModel enemy) {
    adversaries.add(enemy);
    for (final c in enemy.coordinates) {
      units[c] = enemy;
    }
  }

  List<HexCoordinate> sortedSpawnCoordinates(List<HexCoordinate> coordinates) {
    // SEED: Randomize spawn location
    coordinates.shuffle();
    // DIFFICULTY: Prefer spawns that favor the enemy
    return coordinates.sorted(
        (a, b) => terrain[a]?.terrain == TerrainType.dangerous ? 1 : -1);
  }

  ObjectModel? _initializeObject(
      PlacementDef placement, Map<String, int> variables) {
    final name = placement.name;
    final figureDef = _campaignDefinition.objects[name];
    assert(figureDef != null);
    if (figureDef == null) {
      return null;
    }

    final encounterFigureDef =
        encounter.encounter.overlays.firstWhereOrNull((a) => a.name == name);

    final definition = ObjectDef(
        figureDef: figureDef,
        encounterFigureDef: encounterFigureDef,
        placement: placement);
    final coordinate = EvenQHexCoordinate(placement.c, placement.r);
    assert(!objects.containsKey(coordinate));
    final object =
        ObjectModel(definition: definition, coordinate: coordinate, map: this);
    _addObject(object);
    return object;
  }

  _addObject(ObjectModel object) {
    objects[object.coordinate] = object;
    if (!object.definition.lootable) {
      terrain[object.coordinate]?.terrain = TerrainType.object;
    }
    object.addListener(() {
      if (object.isSlain) {
        _onObjectSlayed(object);
      }
      notifyListeners();
    });
  }

  _onObjectSlayed(ObjectModel object) {
    removeObject(object);
  }

  TrapModel _initializeTrap(PlacementDef placement) {
    final coordinate = EvenQHexCoordinate(placement.c, placement.r);
    assert(!traps.containsKey(coordinate));
    final trap = TrapModel.fromPlacement(placement, coordinate: coordinate);
    traps[coordinate] = trap;
    return trap;
  }

  FieldModel _initializeEtherField(PlacementDef placement) {
    final coordinate = EvenQHexCoordinate(placement.c, placement.r);
    assert(!objects.containsKey(coordinate));
    final field = FieldModel(
        field: EtherField.fromName(placement.name.toLowerCase()),
        coordinate: coordinate);
    fields[coordinate] = field;
    return field;
  }

  EtherNodeModel _initializeEther(PlacementDef placement) {
    final coordinate = EvenQHexCoordinate(placement.c, placement.r);
    assert(!objects.containsKey(coordinate));
    assert(!etherNodes.containsKey(coordinate));
    final etherNode = EtherNodeModel(
        ether: Ether.fromName(placement.name.toLowerCase()),
        coordinate: coordinate);
    etherNodes[coordinate] = etherNode;
    terrain[coordinate]?.terrain = TerrainType.object;
    return etherNode;
  }

  List<TileModel> initializePlacements(List<PlacementDef> placements) {
    if (!kDebugMode) {
      // SEED: Randomize placement order (affects enemy numbers/order)
      placements = placements.toList();
      placements.shuffle();
    }
    final variables = {
      rovePlayerCountVariable: 0,
      roveRoundVariable: 1,
    };
    final List<TileModel> tiles = [];
    for (var p in placements) {
      switch (p.type) {
        case PlacementType.feature:
          final coordinate = EvenQHexCoordinate(p.c, p.r);
          final feature = FeatureModel(name: p.name, coordinate: coordinate);
          features[coordinate] = feature;
          tiles.add(feature);
          break;
        case PlacementType.enemy:
          final enemy = _initializeEnemy(p, variables);
          if (enemy != null) {
            tiles.add(enemy);
          }
          break;
        case PlacementType.trap:
          tiles.add(_initializeTrap(p));
          break;
        case PlacementType.object:
          final object = _initializeObject(p, variables);
          if (object != null) {
            tiles.add(object);
          }
          break;
        case PlacementType.field:
          tiles.add(_initializeEtherField(p));
          break;
        case PlacementType.ether:
          tiles.add(_initializeEther(p));
          break;
      }
    }
    return tiles;
  }

  _initializeTerrain() {
    for (int q = 0; q < columnCount; q++) {
      for (int r = 0; r < rowCount; r++) {
        final isLastRow = r == rowCount - 1;
        final isEvenColum = q % 2 == 0;
        if (isLastRow && isEvenColum) {
          continue;
        }
        final terrainAt = map.terrainAt(q: q, r: r);
        final coordinate = EvenQHexCoordinate(q, r);
        final bool isStart = map.starts.contains((q, r));
        final bool isExit = map.exits.contains((q, r));
        terrain[coordinate] = TerrainModel(
            coordinate: coordinate,
            terrain:
                terrainAt != TerrainType.start && terrainAt != TerrainType.exit
                    ? terrainAt
                    : TerrainType.normal,
            isStart: isStart,
            isExit: isExit,
            spawnPoint: map.spawnPointAt(q: q, r: r));
      }
    }
  }

  bool canPlaceTrap(HexCoordinate coordinate) {
    return !units.containsKey(coordinate) &&
        !fields.containsKey(coordinate) &&
        !objects.containsKey(coordinate) &&
        terrain[coordinate]?.terrain != TerrainType.object;
  }

  bool canSpawnAtCoordinate(
      {required EnemyModel actor,
      required HexCoordinate coordinate,
      bool allowDangerous = false}) {
    final isOccuppied = units.containsKey(coordinate) ||
        (objects.containsKey(coordinate) &&
            objects[coordinate]?.canBeSlain == true);
    final hasTrap = traps.containsKey(coordinate);

    if (hasTrap || isOccuppied) {
      return false;
    }

    switch (terrain[coordinate]?.terrain) {
      case TerrainType.openAir:
      case TerrainType.object:
        return actor.isFlying || actor.canEnterObjectSpaces;
      case TerrainType.dangerous:
      case TerrainType.start:
      case TerrainType.exit:
      case TerrainType.difficult:
      case TerrainType.normal:
        return true;
      case TerrainType.barrier:
      case TerrainType.unplayable:
        return false;
      case null:
        return false;
    }
  }

  bool canPlaceField(HexCoordinate coordinate) {
    return !traps.containsKey(coordinate) &&
        !objects.containsKey(coordinate) &&
        terrain[coordinate]?.terrain != TerrainType.object;
  }

  bool hasGlyph(HexCoordinate c) {
    return glyphs.containsKey(c);
  }

  bool isEdgeAtCoordinate(HexCoordinate coordinate) {
    return _neighborsOf(coordinate, pathType: PathType.push).length < 6;
  }

  bool isPullStopperAtCoordinate(HexCoordinate coordinate,
      {required UnitModel target}) {
    final t = terrain[coordinate]?.terrain;
    if (t == TerrainType.barrier) {
      return true;
    }
    final isAtCoordinate = target.coordinates.contains(coordinate);
    final isOccupied = hasUnitAtCoordinate(coordinate);
    if (isOccupied && !isAtCoordinate) {
      return true;
    }
    if (!target.isFlying && t == TerrainType.openAir) {
      return true;
    }
    if (!target.canEnterObjectSpaces && t == TerrainType.object) {
      return true;
    }
    return false;
  }

  bool isPushStopperAtCoordinate(HexCoordinate coordinate,
      {required UnitModel target}) {
    final t = terrain[coordinate]?.terrain;
    if (t == TerrainType.barrier) {
      return true;
    }

    final isAtCoordinate = target.coordinates.contains(coordinate);
    final isOccupied = hasUnitAtCoordinate(coordinate);
    if (isEdgeAtCoordinate(coordinate) && (!isOccupied || isAtCoordinate)) {
      return true;
    }
    if (isOccupied && !isAtCoordinate) {
      return true;
    }
    if (!target.isFlying && t == TerrainType.openAir) {
      return true;
    }
    if (!target.canEnterObjectSpaces && t == TerrainType.object) {
      return true;
    }
    return false;
  }

  HexCoordinate coordinateOfTarget(dynamic target) {
    assert(target is UnitModel || target is GlyphModel);
    if (target is UnitModel) {
      return target.coordinate;
    } else {
      return glyphs.entries.firstWhere((e) => e.value == target).key;
    }
  }

  bool hasUnitAtCoordinate(HexCoordinate coordinate) {
    return units.containsKey(coordinate);
  }

  bool hasAllyAtCoordinate(TileModel tileModel, HexCoordinate coordinate) {
    assert(tileModel.owner != null, 'Tile must have an owner');
    final coordinateUnit = units[coordinate];
    if (coordinateUnit == null) {
      return false;
    }
    return tileModel.owner!.isAllyToUnit(coordinateUnit);
  }

  bool hasEnemyAtCoordinate(TileModel tileModel, HexCoordinate coordinate) {
    assert(tileModel.owner != null, 'Tile must have an owner');
    final coordinateUnit = units[coordinate];
    if (coordinateUnit == null) {
      return false;
    }
    return tileModel.owner!.isEnemyToUnit(coordinateUnit);
  }

  int countOfGlyph(RoveGlyph glyph) =>
      glyphs.values.where((g) => g.glyph == glyph).length;

  /* Pathfinding */

  Iterable<HexCoordinate> _neighborsOf(HexCoordinate coordinate,
      {PathType pathType = PathType.dash}) {
    coordinate = coordinate.toEvenQ();
    final (q, r) = (coordinate.q, coordinate.r);
    final vectors = q % 2 == 0
        ? EvenQHexCoordinate.evenQNeighborVectors
        : EvenQHexCoordinate.oddQNeighborVectors;
    return vectors.map((v) {
      final q1 = q + v.$1;
      final r1 = r + v.$2;
      return EvenQHexCoordinate(q1, r1);
    }).where((c) => terrain.containsKey(c));
  }

  bool isPassable(
      {required dynamic actor,
      required HexCoordinate coordinate,
      required PathType pathType}) {
    bool isPassableSingle(
        {required dynamic actor,
        required HexCoordinate coordinate,
        required PathType pathType}) {
      final terrainType = terrain[coordinate]?.terrain;
      if (terrainType == null || terrainType == TerrainType.barrier) {
        return false;
      }

      final bool isFlying = actor is UnitModel && actor.isFlying;
      if (isFlying) {
        return true;
      }

      final bool isGlyph = actor is GlyphModel;
      if (isGlyph) {
        return true;
      }

      if (terrainType == TerrainType.openAir) {
        return false;
      }

      if (pathType.ignoresOccupied) {
        return true;
      }

      final bool canEnterObjectSpaces =
          actor is UnitModel && actor.canEnterObjectSpaces;

      if (!canEnterObjectSpaces && terrainType == TerrainType.object) {
        return false;
      }

      final unitAtCoordinate = units[coordinate];
      if (unitAtCoordinate != null) {
        return unitAtCoordinate == actor ||
            actor is UnitModel && actor.isAllyToUnit(unitAtCoordinate);
      }

      return true;
    }

    if (actor is EnemyModel) {
      return actor
          .coordinatesAtOrigin(coordinate)
          .whereNot((c) =>
              isPassableSingle(actor: actor, coordinate: c, pathType: pathType))
          .isEmpty;
    } else {
      return isPassableSingle(
          actor: actor, coordinate: coordinate, pathType: pathType);
    }
  }

  bool canOccupy({required dynamic actor, required HexCoordinate coordinate}) {
    bool canOccupySingle(
        {required dynamic actor, required HexCoordinate coordinate}) {
      final terrainType = terrain[coordinate]?.terrain;
      if (terrainType == null || terrainType == TerrainType.barrier) {
        return false;
      }

      final bool isGlyph = actor is GlyphModel;
      if (isGlyph) {
        return !glyphs.containsKey(coordinate) || glyphs[coordinate] == actor;
      }

      final unitAtCordinate = units[coordinate];
      if (unitAtCordinate == actor) {
        return true;
      } else if (unitAtCordinate != null) {
        return false;
      }

      final objectAtCoordinate = objects[coordinate];
      if (objectAtCoordinate?.canBeSlain == true) {
        return false;
      }

      final bool isFlying = actor is UnitModel && actor.isFlying;
      final bool canEnterObjectSpaces =
          actor is UnitModel && actor.canEnterObjectSpaces;
      switch (terrainType) {
        case TerrainType.openAir:
          return isFlying;
        case TerrainType.object:
          return canEnterObjectSpaces;
        default:
          return true;
      }
    }

    if (actor is EnemyModel) {
      return actor
          .coordinatesAtOrigin(coordinate)
          .whereNot((c) => canOccupySingle(actor: actor, coordinate: c))
          .isEmpty;
    } else {
      return canOccupySingle(actor: actor, coordinate: coordinate);
    }
  }

  bool hasLineOfSight(HexCoordinate from, HexCoordinate to) {
    final coordinates = HexCoordinate.line(from, to, excludeEdges: true);
    return coordinates.none((c) => terrain[c]?.terrain == TerrainType.barrier);
  }

  /* State changes */

  updateCoordinate(
      {required TileModel target,
      required HexCoordinate coordinate,
      bool swapping = false}) {
    assert(target is UnitModel || target is GlyphModel);
    if (target is UnitModel) {
      assert(!target.isSlain);

      final UnitModel unit = target;
      units.entries.where((e) => e.value == target).toList().forEach((e) {
        units.remove(e.key);
      });
      unit.coordinate = coordinate;
      for (var c in unit.coordinates) {
        assert(swapping || units[c] == null);
        units[c] = unit;
      }
    } else if (target is GlyphModel) {
      final GlyphModel glyph = target;
      final from = glyphs.entries.firstWhere((e) => e.value == glyph).key;
      glyphs.remove(from);
      glyphs[coordinate] = glyph;
      glyph.coordinate = coordinate;
    }
    notifyListeners();
  }

  removeUnit(UnitModel unit) {
    adversaries.remove(unit);
    for (var c in unit.coordinates) {
      units.remove(c);
    }
    notifyListeners();
  }

  void removeFeature(FeatureModel feature) {
    features.remove(feature.coordinate);
    notifyListeners();
  }

  addGlyph(GlyphModel model, {required HexCoordinate coordinate}) {
    assert(!hasGlyph(coordinate));
    glyphs[coordinate] = model;
    notifyListeners();
  }

  List<HexCoordinate> coordinatesOfGlyph(RoveGlyph glyph) {
    return glyphs.entries
        .where((e) => e.value.glyph == glyph)
        .map((e) => e.key)
        .toList();
  }

  void removeGlyphAtCoordinate(HexCoordinate coordinate) {
    assert(hasGlyph(coordinate));
    glyphs.remove(coordinate);
    notifyListeners();
  }

  bool hasEffectAtCoordinate(HexCoordinate coordinate) {
    return fields.containsKey(coordinate) || glyphs.containsKey(coordinate);
  }

  FieldModel? fieldAtCoordinate(HexCoordinate coordinate) {
    return fields[coordinate];
  }

  removeFieldAtCoordinate(HexCoordinate coordinate) {
    assert(fields.containsKey(coordinate));
    fields.remove(coordinate);
    notifyListeners();
  }

  void addField(FieldModel fieldModel, {required HexCoordinate coordinate}) {
    fields[coordinate] = fieldModel;
    notifyListeners();
  }

  TrapModel? trapAtCoordinate(HexCoordinate coordinate) {
    return traps[coordinate];
  }

  removeTrapAtCoordinate(HexCoordinate coordinate) {
    assert(traps.containsKey(coordinate));
    traps.remove(coordinate);
    notifyListeners();
  }

  void addTrap(TrapModel trap, {required HexCoordinate coordinate}) {
    traps[coordinate] = trap;
    notifyListeners();
  }

  /* Queries */

  List<UnitModel> get targetableUnits =>
      units.values.where((u) => u.isTargetable).toSet().toList();

  UnitModel? findUnitWithName(String s) {
    return units.values.firstWhereOrNull((u) => u.name == s);
  }

  UnitModel? findUnitByKey(String key) {
    return units.values.firstWhereOrNull((u) => u.key == key);
  }

  removeObject(ObjectModel object) {
    assert(objects.containsValue(object));
    objects.remove(object.coordinate);
    assert(!objects.containsValue(object));
    terrain[object.coordinate]?.terrain = TerrainType.normal;
    notifyListeners();
  }

  void removeEtherNode(EtherNodeModel etherNode) {
    assert(etherNodes.containsValue(etherNode));
    etherNodes.remove(etherNode.coordinate);
    assert(!etherNodes.containsValue(etherNode));
    terrain[etherNode.coordinate]?.terrain = TerrainType.normal;
    notifyListeners();
  }

  /* Editor */

  String get name => _name;

  String get id => _id;
  set id(String value) {
    _id = value;
    _updateBackground();
    notifyListeners();
  }

  Image? _background;
  Image? get background => _background;

  Future<Image?> loadBackgroundForId(String id) async {
    return await Assets.campaignImages
        .loadMap('$id.webp', expansion: encounter.expansion);
  }

  _updateBackground() async {
    _background = await loadBackgroundForId(id);
    notifyListeners();
  }

  Rect get backgroundRect => _backgroundRect;
  set backgroundX(double value) {
    _backgroundRect = Rect.fromLTWH(value, _backgroundRect.top,
        _backgroundRect.width, _backgroundRect.height);
    notifyListeners();
  }

  set backgroundY(double value) {
    _backgroundRect = Rect.fromLTWH(_backgroundRect.left, value,
        _backgroundRect.width, _backgroundRect.height);
    notifyListeners();
  }

  set backgroundWidth(double value) {
    _backgroundRect = Rect.fromLTWH(_backgroundRect.left, _backgroundRect.top,
        value, _backgroundRect.height);
    notifyListeners();
  }

  set backgroundHeight(double value) {
    _backgroundRect = Rect.fromLTWH(_backgroundRect.left, _backgroundRect.top,
        _backgroundRect.width, value);
    notifyListeners();
  }

  MapDef toMapDef() {
    return MapDef(
        id: id,
        rowCount: map.rowCount,
        columnCount: map.columnCount,
        backgroundRect: _backgroundRect,
        starts: terrain.entries
            .where((e) => e.value.isStart)
            .map((e) => e.key)
            .map((c) => c.toEvenQ())
            .map((c) => (c.q, c.r))
            .toList(),
        exits: terrain.entries
            .where((e) => e.value.isExit)
            .map((e) => e.key)
            .map((c) => c.toEvenQ())
            .map((c) => (c.q, c.r))
            .toList(),
        terrain: Map.fromEntries(terrain.entries
            .where((e) => e.value.terrain != TerrainType.normal)
            .map((e) => MapEntry(
                (e.key.toEvenQ().q, e.key.toEvenQ().r), e.value.terrain))),
        spawnPoints: Map.fromEntries(terrain.entries
            .where((e) => e.value.spawnPoint != null)
            .map((e) => MapEntry(
                (e.key.toEvenQ().q, e.key.toEvenQ().r), e.value.spawnPoint!))));
  }

  PlacementGroupDef toPlacementGroupDef() {
    return PlacementGroupDef(
        name: name,
        placements: placements,
        map: id != encounter.encounter.id ? toMapDef() : null);
  }

  List<PlacementDef> get placements {
    final placements = <PlacementDef>[];
    for (final unit in units.values) {
      placements.add(unit.toPlacement());
    }
    for (final object in objects.values) {
      placements.add(object.toPlacement());
    }
    for (final trap in traps.values) {
      placements.add(trap.toPlacement());
    }
    for (final ether in etherNodes.values) {
      placements.add(ether.toPlacement());
    }
    for (final feature in features.values) {
      placements.add(feature.toPlacement());
    }
    for (final field in fields.values) {
      placements.add(field.toPlacement());
    }
    return placements;
  }
}
