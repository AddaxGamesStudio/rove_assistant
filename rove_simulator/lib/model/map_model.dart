import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:rove_app_common/data/campaign_loader.dart';
import 'package:rove_simulator/model/path_type.dart';
import 'package:rove_simulator/model/persistence/saveable.dart';
import 'package:rove_simulator/model/tiles/enemy_model.dart';
import 'package:rove_simulator/model/tiles/enemy_unit_def.dart';
import 'package:rove_simulator/model/tiles/ether_node_model.dart';
import 'package:rove_simulator/model/tiles/field_model.dart';
import 'package:rove_simulator/model/tiles/glyph_model.dart';
import 'package:rove_simulator/model/tiles/object_def.dart';
import 'package:rove_simulator/model/tiles/object_model.dart';
import 'package:rove_simulator/model/tiles/player_unit_model.dart';
import 'package:rove_simulator/model/tiles/summon_model.dart';
import 'package:rove_simulator/model/tiles/terrain_model.dart';
import 'package:rove_simulator/model/tiles/tile_model.dart';
import 'package:rove_simulator/model/tiles/trap_model.dart';
import 'package:rove_simulator/model/tiles/unit_model.dart';
import 'package:hex_grid/hex_grid.dart';
import 'package:rove_data_types/rove_data_types.dart';

class MapModel extends ChangeNotifier with Saveable {
  final EncounterDef encounter;
  final List<Player> _players;
  final List<PlayerUnitModel> _playerUnits = [];
  List<PlayerUnitModel> get players => _playerUnits;

  final counts = <String, int>{};
  final features = <HexCoordinate, String>{};
  List<EnemyModel> adversaries = [];
  final List<SummonModel> summons = [];
  final Map<HexCoordinate, UnitModel> units = {};
  final Map<HexCoordinate, GlyphModel> glyphs = {};
  final Map<HexCoordinate, FieldModel> fields = {};
  final Map<HexCoordinate, TrapModel> traps = {};
  final Map<HexCoordinate, TerrainModel> terrain = {};
  final Map<HexCoordinate, ObjectModel> objects = {};
  final Map<HexCoordinate, EtherNodeModel> etherNodes = {};
  final int columnCount;
  final int rowCount;
  final MapDef map;
  late CampaignDef _campaignDefinition;
  CampaignDef get campaignDefinition => _campaignDefinition;

  MapModel(
      {required List<Player> players,
      required this.encounter,
      CampaignDef? campaign,
      bool skipPlayerInitialization = false})
      : _players = players,
        columnCount = encounter.startingMap.columnCount,
        rowCount = encounter.startingMap.rowCount,
        map = encounter.startingMap {
    _campaignDefinition = campaign ?? CampaignLoader.instance.campaign;
    _initializeTerrain();
    if (!skipPlayerInitialization) {
      _initializeRovers(players);
    }
  }

  initialize() {
    initializePlacements(encounter.placements);
  }

  _addPlayer(PlayerUnitModel player) {
    _playerUnits.add(player);
    player.addListener(() {
      notifyListeners();
    });
    for (final c in player.coordinates) {
      assert(units[c] == null);
      units[c] = player;
    }
  }

  _initializeRovers(List<Player> playersToInitialize) {
    final coordinates = map.startCoordinates
        .map((c) => EvenQHexCoordinate(c.$1, c.$2))
        .toList();
    coordinates.shuffle();
    for (int i = 0; i < playersToInitialize.length; i++) {
      final player = PlayerUnitModel(
          player: playersToInitialize[i],
          coordinate: coordinates[i],
          map: this);
      _addPlayer(player);
    }
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
        encounter.adversaries.firstWhereOrNull((a) => a.name == name);
    assert(encounterFigureDef != null);
    if (encounterFigureDef == null) {
      return null;
    }

    counts[name] = (counts[name] ?? 0) + 1;
    final definition = EnemyUnitDef(
        number: counts[name]!,
        figureDef: figureDef,
        encounterFigureDef: encounterFigureDef,
        placement: placement);
    final coordinate = EvenQHexCoordinate(placement.c, placement.r);
    final enemy =
        EnemyModel(enemy: definition, coordinate: coordinate, map: this);
    enemy.coordinate =
        _findSpawnableCoordinate(actor: enemy, origin: coordinate);
    _addEnemy(enemy);
    return enemy;
  }

  _addEnemy(EnemyModel enemy) {
    adversaries.add(enemy);
    enemy.addListener(() {
      if (enemy.isSlain) {
        _onEnemySlain(enemy);
      }
      notifyListeners();
    });
    for (final c in enemy.coordinates) {
      assert(units[c] == null);
      units[c] = enemy;
    }
  }

  _onEnemySlain(EnemyModel enemy) {
    assert(units[enemy.coordinate] == enemy || units[enemy.coordinate] == null);
    removeUnit(enemy);
  }

  HexCoordinate _findSpawnableCoordinate(
      {required EnemyModel actor, required EvenQHexCoordinate origin}) {
    if (canSpawnAtCoordinate(actor: actor, coordinate: origin)) {
      return origin;
    } else {
      int radius = 1;
      while (radius < 10) {
        final neighbors = coordinatesWithinRange(
                center: origin,
                range: (radius, radius),
                needsLineOfSight: false)
            .toList();
        final candidates = sortedSpawnCoordinates(neighbors);
        for (final candidate in candidates) {
          if (canSpawnAtCoordinate(actor: actor, coordinate: candidate)) {
            return candidate;
          }
        }
        radius++;
      }
      throw UnimplementedError('No spawnable coordinate found!');
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
        encounter.overlays.firstWhereOrNull((a) => a.name == name);

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
      rovePlayerCountVariable: players.length,
      roveRoundVariable: 1,
    };
    final List<TileModel> tiles = [];
    placements.where((p) => p.minPlayers <= players.length).forEach((p) {
      switch (p.type) {
        case PlacementType.feature:
          features[EvenQHexCoordinate(p.c, p.r)] = p.name;
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
        case PlacementType.ether:
          tiles.add(_initializeEther(p));
          break;
        case PlacementType.field:
          // TODO: Implement field placements
          break;
      }
    });
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
        final coordinate = EvenQHexCoordinate(q, r);
        terrain[coordinate] = TerrainModel(
            coordinate: coordinate,
            terrain: map.terrainAt(q: q, r: r),
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

  List<UnitModel> unitsAdjacentToCoordinate(HexCoordinate coordinate) {
    final adjacentCoordinates = coordinatesWithinRange(
        center: coordinate, range: (1, 1), needsLineOfSight: false);
    final List<UnitModel> adjacentUnits = [];
    for (final c in adjacentCoordinates) {
      final unit = units[c];
      if (unit != null) {
        adjacentUnits.add(unit);
      }
    }
    return adjacentUnits;
  }

  List<EtherNodeModel> etherAffectingCoordinate(HexCoordinate coordinate) {
    final adjacentCoordinates = coordinatesWithinRange(
        center: coordinate, range: (0, 1), needsLineOfSight: false);
    final List<EtherNodeModel> adjacentEther = [];
    for (final c in adjacentCoordinates) {
      final ether = etherNodes[c];
      if (ether != null) {
        adjacentEther.add(ether);
      }
    }
    return adjacentEther;
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

  int effortOfPath(
      {required dynamic actor,
      required HexCoordinate start,
      required List<HexCoordinate> path,
      PathType pathType = PathType.dash}) {
    int moveEffort = 0;
    if (path.isEmpty) {
      return 0;
    }
    var current = start;
    for (var i = 0; i < path.length; i++) {
      if (current.distanceTo(path[i]) == 1) {
        moveEffort += _effortBetweenNeighbors(
            actor: actor,
            from: current,
            isFirst: current == start,
            isLast: i == path.length - 1,
            to: path[i],
            pathType: pathType);
      } else {
        moveEffort += pathDistance(
            actor: actor, from: current, to: path[i], pathType: pathType)!;
      }
      current = path[i];
    }
    return moveEffort;
  }

  List<HexCoordinate> path(
      {required TileModel actor,
      required TileModel target,
      required HexCoordinate from,
      required HexCoordinate to,
      PathType pathType = PathType.dash}) {
    Map<HexCoordinate, HexCoordinate?> cameFrom = {};
    final bool includeToIfNotPassable = () {
      switch (pathType) {
        case PathType.dash:
        case PathType.dashIgnoringTerrainEffects:
        case PathType.enemyAIDash:
        case PathType.jump:
        case PathType.enemyAIJump:
          return false;
        case PathType.pull:
          return (target is UnitModel) &&
              isPullStopperAtCoordinate(to, target: target);
        case PathType.push:
          return (target is UnitModel) &&
              isPushStopperAtCoordinate(to, target: target);
      }
    }();

    _distance(
        actor: actor,
        target: target,
        from: from,
        to: to,
        cameFrom: cameFrom,
        pathType: pathType,
        includeToIfNotPassable: includeToIfNotPassable);
    final path = <HexCoordinate>[];
    HexCoordinate? current = to;
    while (current != from && current != null) {
      path.add(current);
      final previous = cameFrom[current];
      current = previous;
    }
    return current == null ? [] : path.reversed.toList();
  }

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

  Iterable<HexCoordinate> _passableNeighborsOf(
      dynamic actor, HexCoordinate center,
      {PathType pathType = PathType.dash, required HexCoordinate? to}) {
    return _neighborsOf(center, pathType: pathType).where((c) {
      if (c == to) {
        if (pathType == PathType.pull) {
          if (isPullStopperAtCoordinate(c, target: actor)) {
            return canOccupy(actor: actor, coordinate: c) ||
                canOccupy(actor: actor, coordinate: center);
          }
        } else if (pathType == PathType.push) {
          if (isPushStopperAtCoordinate(c, target: actor)) {
            return canOccupy(actor: actor, coordinate: c) ||
                canOccupy(actor: actor, coordinate: center);
          }
        }
        return true;
      }
      return isPassable(actor: actor, coordinate: c, pathType: pathType);
    });
  }

  Iterable<HexCoordinate> _closerPassableNeighbors(
      {required TileModel actor,
      required TileModel target,
      required HexCoordinate center,
      PathType pathType = PathType.dash,
      required HexCoordinate? to}) {
    final neighbors =
        _passableNeighborsOf(target, center, pathType: pathType, to: to);
    final distanceToActor = center.distanceTo(actor.coordinate);
    return neighbors
        .where((c) => c.distanceTo(actor.coordinate) < distanceToActor);
  }

  Iterable<HexCoordinate> _fartherPassableNeighbors(
      {required TileModel actor,
      required TileModel target,
      required HexCoordinate center,
      PathType pathType = PathType.dash,
      required HexCoordinate? to}) {
    final neighbors =
        _passableNeighborsOf(target, center, pathType: pathType, to: to);
    final distanceToActor = center.distanceTo(actor.coordinate);
    return neighbors
        .where((c) => c.distanceTo(actor.coordinate) > distanceToActor);
  }

  List<HexCoordinate> coordinatesWithinRangeOfTarget(
      {required TileModel target,
      required (int, int) range,
      required bool needsLineOfSight}) {
    return target.coordinates
        .map((c) => coordinatesWithinRange(
            center: c, range: range, needsLineOfSight: needsLineOfSight))
        .flattened
        .toSet()
        .where((c) {
      final distance = target.distanceToCoordinate(c);
      return range.$1 <= distance && distance <= range.$2;
    }).toList();
  }

  /// See also:
  /// - [coordinatesWithinRangeOfTarget] to return coordinates within range of a target that might or might not occupy multiple coordinates.
  Iterable<HexCoordinate> coordinatesWithinRange(
      {required HexCoordinate center,
      required (int, int) range,
      required bool needsLineOfSight}) {
    var results = <HexCoordinate>[];
    final cubeCenter = center.toCube();
    final maxN = range.$2;
    final minN = range.$1;
    for (int dq = -maxN; dq <= maxN; dq++) {
      for (int dr = max(-maxN, -dq - maxN); dr <= min(maxN, -dq + maxN); dr++) {
        final ds = -dq - dr;
        final candidate = cubeCenter.addVector(dq, dr, ds);
        if (distance(cubeCenter, candidate) < minN) {
          continue;
        }
        if (!terrain.containsKey(candidate)) {
          continue;
        }
        if (needsLineOfSight && !hasLineOfSight(center, candidate)) {
          continue;
        }
        results.add(candidate);
      }
    }
    return results;
  }

  int? _distance(
      {required TileModel actor,
      required TileModel target,
      required HexCoordinate from,
      required HexCoordinate to,
      required Map<HexCoordinate, HexCoordinate?> cameFrom,
      PathType pathType = PathType.dash,
      required bool includeToIfNotPassable}) {
    Iterable<HexCoordinate> neighborsOf(
        HexCoordinate center, HexCoordinate? to) {
      if (pathType == PathType.push) {
        return _fartherPassableNeighbors(
            actor: actor,
            target: target,
            center: center,
            pathType: pathType,
            to: to);
      } else if (pathType == PathType.pull) {
        return _closerPassableNeighbors(
            actor: actor,
            target: target,
            center: center,
            pathType: pathType,
            to: to);
      } else {
        return _passableNeighborsOf(target, center, pathType: pathType, to: to);
      }
    }

    final frontier =
        PriorityQueue<(HexCoordinate, int)>((a, b) => a.$2.compareTo(b.$2));
    frontier.add((from, 0));
    final costSoFar = <HexCoordinate, int>{};
    cameFrom[from] = null;
    costSoFar[from] = 0;

    while (frontier.isNotEmpty) {
      final current = frontier.removeFirst().$1;

      if (current == to) {
        return costSoFar[current];
      }

      final neighbors =
          neighborsOf(current, includeToIfNotPassable ? to : null);
      for (final next in neighbors) {
        final nextCost = _effortBetweenNeighbors(
            actor: target,
            from: current,
            isFirst: current == from,
            isLast: next == to,
            to: next,
            pathType: pathType);
        final newCost = costSoFar[current]! + nextCost;
        if (!costSoFar.containsKey(next) || newCost < costSoFar[next]!) {
          costSoFar[next] = newCost;
          final int priority = newCost + distance(to, next);
          frontier.add((next, priority));
          cameFrom[next] = current;
        }
      }
    }
    return null;
  }

  int _effortBetweenNeighbors(
      {required TileModel actor,
      required HexCoordinate from,
      required bool isFirst,
      required bool isLast,
      required HexCoordinate to,
      required PathType pathType}) {
    assert(from.distanceTo(to) == 1, 'Must be neighbors');
    var effort = pathType.ignoresDifficult || actor.ignoresDifficultTerrain
        ? 1
        : terrain[to]!.terrain.movementCost;
    if (isFirst) {
      effort +=
          fieldAtCoordinate(from)?.moveEffortToExitSpaceForActor(actor) ?? 0;
    }
    {
      final fromCoordinates = actor.coordinatesAtOrigin(from);
      final toCoordinates = actor.coordinatesAtOrigin(to);
      final enteredCoordinates =
          toCoordinates.whereNot((c) => fromCoordinates.contains(c));
      {
        final dangerousSpaceCount = enteredCoordinates
            .where((c) => terrain[c]?.terrain == TerrainType.dangerous)
            .length;
        effort += dangerousSpaceCount *
            pathType.extraEffortForDangerousSpace(isLast: isLast);
      }
      {
        final trapCount =
            enteredCoordinates.where((c) => traps[c] != null).length;
        effort += trapCount * pathType.extraEffortForTrap;
      }
      {
        for (final c in enteredCoordinates) {
          final etherNodes = etherAffectingCoordinate(c);
          effort += etherNodes.fold(0,
              (value, e) => value + e.ether.movementCostToEnterAdjacentSpace);
        }
      }
    }
    effort += fieldAtCoordinate(to)?.moveEffortToEnterSpaceForActor(actor) ?? 0;
    return effort;
  }

  int? pathDistance(
      {required dynamic actor,
      required HexCoordinate from,
      required HexCoordinate to,
      required PathType pathType}) {
    assert(pathType != PathType.pull);
    assert(pathType != PathType.push);
    return _distance(
        actor: actor,
        target: actor,
        from: from,
        to: to,
        pathType: pathType,
        cameFrom: {},
        includeToIfNotPassable: true);
  }

  int distance(HexCoordinate from, HexCoordinate to) {
    return from.distanceTo(to);
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
    summons.remove(unit);
    for (var c in unit.coordinates) {
      units.remove(c);
    }
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

  _addSummon(SummonModel summon) {
    summons.add(summon);
    summon.addListener(() {
      if (summon.isSlain) {
        removeUnit(summon);
      }
      notifyListeners();
    });
    for (final c in summon.coordinates) {
      assert(units[c] == null);
      units[c] = summon;
    }
  }

  void addSummon(SummonModel summon, {required HexCoordinate coordinate}) {
    assert(terrain.containsKey(coordinate));
    assert(canOccupy(actor: summon, coordinate: coordinate));
    assert(summon.coordinate == coordinate);
    _addSummon(summon);
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

  bool isClosestOfClassToRovers(TileModel target) {
    int distanceToRovers(TileModel target) {
      return players
          .map((p) => p.coordinate.distanceTo(target.coordinate))
          .reduce((value, d) => value + d);
    }

    late List<TileModel> candidates;
    if (target is UnitModel) {
      candidates =
          units.values.where((u) => u.className == target.className).toList();
    } else if (target is ObjectModel) {
      candidates =
          objects.values.where((o) => o.className == target.className).toList();
    } else {
      return false;
    }
    if (candidates.isEmpty) {
      return false;
    }
    final closest = candidates
        .map((c) => (c, distanceToRovers(c)))
        .reduce((closest, d) => closest.$2 < d.$2 ? closest : d)
        .$1;
    return closest == target;
  }

  /* Saveable */

  static const int terrainSaveablePriority = 0;
  static const int objectSaveablePriority = terrainSaveablePriority + 1;

  @override
  String get saveableKey => map.id;

  @override
  Map<String, dynamic> saveableProperties() {
    return {
      'counts': counts,
      'features': Map<String, String>.fromEntries(features.entries
          .map((e) => MapEntry(e.key.toCube().toString(), e.value))),
    };
  }

  @override
  String get saveableType => 'MapModel';

  @override
  List<Saveable> get saveableChildren => [
        ...super.saveableChildren,
        ...terrain.values.where((t) => t.changed),
        ...players,
        ...adversaries,
        ...summons,
        ...objects.values,
        ...etherNodes.values,
        ...fields.values,
        ...glyphs.values,
        ...traps.values
      ];

  @override
  setSaveablePropertiesBeforeChildren(Map<String, dynamic> properties) {
    super.setSaveablePropertiesAfterChildren(properties);
    counts.addAll(properties['counts'] as Map<String, int>);
    features.addEntries((properties['features'] as Map<String, String>)
        .entries
        .map((e) => MapEntry(EvenQHexCoordinate.fromString(e.key), e.value)));
  }

  @override
  Saveable createSaveableChild(SaveData childData) {
    switch (childData.type) {
      case 'EnemyModel':
        final enemy = EnemyModel.fromSaveData(
            data: childData, map: this, campaign: _campaignDefinition);
        _addEnemy(enemy);
        return enemy;
      case 'EtherNodeModel':
        final ether = EtherNodeModel.fromSaveData(data: childData);
        etherNodes[ether.coordinate] = ether;
        return ether;
      case 'FieldModel':
        final field = FieldModel.fromSaveData(childData, map: this);
        fields[field.coordinate] = field;
        return field;
      case 'GlyphModel':
        final glyph = GlyphModel.fromSaveData(childData, map: this);
        glyphs[glyph.coordinate] = glyph;
        return glyph;
      case 'ObjectModel':
        final object = ObjectModel.fromSaveData(
            data: childData, map: this, campaign: _campaignDefinition);
        _addObject(object);
        return object;
      case 'PlayerUnitModel':
        final player = PlayerUnitModel.fromSaveData(
            data: childData, map: this, players: _players);
        _addPlayer(player);
        return player;
      case 'SummonModel':
        final summon = SummonModel.fromSaveData(childData, map: this);
        _addSummon(summon);
        return summon;
      case 'TerrainModel':
        final terrainModel = TerrainModel.fromSaveData(childData);
        terrain[terrainModel.coordinate] = terrainModel;
        return terrainModel;
      case 'TrapModel':
        final trap = TrapModel.fromSaveData(childData, map: this);
        traps[trap.coordinate] = trap;
        return trap;
      default:
        throw UnimplementedError();
    }
  }
}
