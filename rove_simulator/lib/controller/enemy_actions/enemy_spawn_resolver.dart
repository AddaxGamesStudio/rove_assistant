import 'dart:async';

import 'package:collection/collection.dart';
import 'package:rove_simulator/controller/enemy_actions/enemy_action_resolver.dart';
import 'package:rove_app_common/data/campaign_loader.dart';
import 'package:rove_simulator/model/tiles/enemy_model.dart';
import 'package:rove_simulator/model/tiles/enemy_unit_def.dart';
import 'package:hex_grid/hex_grid.dart';
import 'package:rove_data_types/rove_data_types.dart';

class EnemySpawnResolver extends EnemyActionResolver {
  EnemySpawnResolver(
      {required super.game, required super.actor, required super.action})
      : super(targets: []);

  Completer<bool> completer = Completer();

  EnemyModel? buildPrototypeSpawn() {
    if (action.object == null) {
      return null;
    }
    final name = action.object!;
    final figureDef = CampaignLoader.instance.campaign.adversaries[name];
    assert(figureDef != null);
    if (figureDef == null) {
      return null;
    }

    final encounterFigureDef =
        model.encounter.adversaries.firstWhereOrNull((a) => a.name == name);
    assert(encounterFigureDef != null);
    if (encounterFigureDef == null) {
      return null;
    }
    final definition = EnemyUnitDef(
        number: 0,
        figureDef: figureDef,
        encounterFigureDef: encounterFigureDef,
        placement: PlacementDef(name: name, type: PlacementType.enemy));
    return EnemyModel(
        enemy: definition,
        coordinate: const EvenQHexCoordinate(0, 0),
        map: mapModel);
  }

  @override
  Future<bool> execute() async {
    final prototype = buildPrototypeSpawn();
    assert(prototype != null);
    if (prototype == null) {
      log.addRecord(actor, 'Unrecognized spawn named ${action.object}');
      return false;
    }
    final spawnableCoordinates =
        _findSpawnableCoordinatesForPrototype(prototype);
    if (spawnableCoordinates.isEmpty) {
      log.addRecord(
          actor, 'Skipped spawn due to no empty coordinates within range');
      return false;
    }

    final amount = actor.resolveAmountForAction(action);
    final targetCoordinates = spawnableCoordinates.length <= amount
        ? spawnableCoordinates
        : spawnableCoordinates.sublist(0, amount);
    final placements = targetCoordinates
        .map((c) => c.toEvenQ())
        .map((c) => PlacementDef(
            name: action.object!, type: PlacementType.enemy, c: c.q, r: c.r))
        .toList();
    mapController.spawnPlacements(placements: placements);
    return true;
  }

  List<HexCoordinate> _findSpawnableCoordinatesForPrototype(
      EnemyModel prototype) {
    final viableCoordinates = mapModel
        .coordinatesWithinRangeOfTarget(
            target: actor, range: action.range, needsLineOfSight: false)
        .where((c) =>
            mapModel.canSpawnAtCoordinate(actor: prototype, coordinate: c))
        .toList();
    return mapModel.sortedSpawnCoordinates(viableCoordinates);
  }
}
