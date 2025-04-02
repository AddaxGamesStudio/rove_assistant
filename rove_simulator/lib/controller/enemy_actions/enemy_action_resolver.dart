import 'package:rove_simulator/controller/base_controller.dart';
import 'package:rove_simulator/controller/enemy_actions/enemy_command_resolver.dart';
import 'package:rove_simulator/controller/enemy_actions/enemy_create_trap_resolver.dart';
import 'package:rove_simulator/controller/enemy_actions/enemy_move_resolver.dart';
import 'package:rove_simulator/controller/enemy_actions/enemy_place_field_resolver.dart';
import 'package:rove_simulator/controller/enemy_actions/enemy_pull_resolver.dart';
import 'package:rove_simulator/controller/enemy_actions/enemy_push_resolver.dart';
import 'package:rove_simulator/controller/enemy_actions/enemy_retreat_resolver.dart';
import 'package:rove_simulator/controller/enemy_actions/enemy_single_target_attack_resolver.dart';
import 'package:rove_simulator/controller/enemy_actions/enemy_single_target_heal_resolver.dart';
import 'package:rove_simulator/controller/enemy_actions/enemy_spawn_resolver.dart';
import 'package:rove_simulator/controller/enemy_actions/enemy_suffer_resolver.dart';
import 'package:rove_simulator/flame/encounter_game.dart';
import 'package:rove_simulator/model/cards/ability_model.dart';
import 'package:rove_simulator/model/targeting/area_of_effect.dart';
import 'package:rove_simulator/model/tiles/unit_model.dart';
import 'package:hex_grid/hex_grid.dart';
import 'package:rove_data_types/rove_data_types.dart';

abstract class EnemyActionResolver extends BaseController {
  final UnitModel actor;
  final List<UnitModel> targets;
  final AreaOfEffect? targetAOE;
  RoveAction action;

  HexCoordinate get actorCoordinate => mapModel.coordinateOfTarget(actor);
  List<HexCoordinate> get targetCoordinates =>
      targets.map((target) => mapModel.coordinateOfTarget(target)).toList();

  UnitModel get actingUnit => actor;

  EnemyActionResolver(
      {required super.game,
      required this.actor,
      required this.targets,
      this.targetAOE,
      required this.action});

  Future<bool> execute();

  isInRangeForTarget(
      {required UnitModel target, required bool needsLineOfSight}) {
    // Single hex AOE can be retargeted so long that is within the action's range
    if (targetAOE != null && !targetAOE!.definition.isSingleHex) {
      return target.coordinates
          .any((tc) => targetAOE!.coordinates.contains(tc));
    } else {
      final range = action.range;
      final distance = actor.distanceToTarget(target);
      if (!(range.$1 <= distance && distance <= range.$2)) {
        return false;
      }
      if (!needsLineOfSight) {
        return true;
      }
      return target.coordinates.any((tc) => actor.coordinates.any((ac) =>
          mapModel.hasLineOfSight(ac, tc) && ac.distanceTo(tc) <= distance));
    }
  }

  isInRangeForCoordinate(HexCoordinate coordinate,
      {required bool needsLineOfSight}) {
    final range = action.range;
    final distance =
        actor.distanceToCoordinate(coordinate, origin: actor.coordinate);
    return range.$1 <= distance &&
        distance <= range.$2 &&
        (needsLineOfSight
            ? mapModel.hasLineOfSight(actorCoordinate, coordinate)
            : true);
  }

  factory EnemyActionResolver.fromAction(
      {required EncounterGame game,
      required UnitModel actor,
      required List<UnitModel> targets,
      HexCoordinate? targetCoordinate,
      AreaOfEffect? targetAOE,
      AbilityModel? ability,
      required RoveAction action}) {
    switch (action.type) {
      case RoveActionType.jump:
      case RoveActionType.teleport:
      case RoveActionType.move:
        if (action.retreat) {
          return EnemyRetreatResolver(
              game: game, actor: actor, targets: targets, action: action);
        } else {
          return EnemyMoveResolver(
              game: game,
              actor: actor,
              target: targets.first,
              targetCoordinate: targetCoordinate,
              action: action);
        }
      case RoveActionType.attack:
        return EnemySingleTargetAttackResolver(
            game: game,
            actor: actor,
            target: targets.first,
            targetAOE: targetAOE,
            action: action);
      case RoveActionType.command:
        assert(ability != null);
        return EnemyCommandResolver(
            game: game, actor: actor, ability: ability!, action: action);
      case RoveActionType.createTrap:
        return EnemyCreateTrapResolver(
            game: game, actor: actor, action: action);
      case RoveActionType.heal:
        return EnemySingleTargetHealResolver(
            game: game,
            actor: actor,
            target: targets.first,
            targetAOE: targetAOE,
            action: action);
      case RoveActionType.placeField:
        assert(targets.isNotEmpty);
        return EnemyPlaceFieldResolver(
            game: game,
            actor: actor,
            destination: targets.first.coordinate,
            action: action);
      case RoveActionType.pull:
        return EnemyPullResolver(
            game: game, actor: actor, target: targets.first, action: action);
      case RoveActionType.push:
        return EnemyPushResolver(
            game: game, actor: actor, target: targets.first, action: action);
      case RoveActionType.spawn:
        return EnemySpawnResolver(game: game, actor: actor, action: action);
      case RoveActionType.suffer:
        assert(targets.isNotEmpty);
        return EnemySufferResolver(
            game: game, actor: actor, target: targets.first, action: action);
      default:
        throw UnimplementedError();
    }
  }

  String? debugStringForCoordinate(HexCoordinate coordinate) {
    return null;
  }
}
