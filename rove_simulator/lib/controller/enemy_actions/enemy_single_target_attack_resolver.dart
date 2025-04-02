import 'dart:async';

import 'package:rove_simulator/controller/enemy_actions/enemy_action_resolver.dart';
import 'package:rove_simulator/controller/enemy_actions/enemy_pull_resolver.dart';
import 'package:rove_simulator/controller/enemy_actions/enemy_push_resolver.dart';
import 'package:rove_simulator/model/encounter_log.dart';
import 'package:rove_simulator/model/tiles/field_model.dart';
import 'package:rove_simulator/model/tiles/unit_model.dart';
import 'package:hex_grid/hex_grid.dart';
import 'package:rove_data_types/rove_data_types.dart';

class EnemySingleTargetAttackResolver extends EnemyActionResolver {
  EnemySingleTargetAttackResolver(
      {required super.game,
      required super.actor,
      required UnitModel target,
      super.targetAOE,
      required super.action})
      : super(targets: [target]);

  final List<(FieldModel, RoveAction?)> _appliedFields = [];

  _handleFields() {
    for (final c in actor.coordinates) {
      final field = mapModel.fieldAtCoordinate(c);
      if (field == null) {
        continue;
      }
      final buff = field.buff;
      if (buff != null) {
        log.addRecord(field.creator,
            'Buffed ${EncounterLogEntry.targetKeyword} with ${buff.descriptionForAction(action)} from ${field.name} field',
            target: actor);
        action = action.withBuff(buff);
      }
      final fieldAction = field.action;
      if (fieldAction != null || buff != null) {
        _appliedFields.add((field, fieldAction));
      }
    }
  }

  _willResolveAttack() async {
    for (final (field, action) in _appliedFields) {
      if (action != null) {
        // TODO: These are not necessarily enemy actions as the actor is the field creator and this can be a Rover. Consider a generic action resolver.
        final resolver = EnemyActionResolver.fromAction(
            game: game, actor: field.creator, targets: [actor], action: action);
        await resolver.execute();
      }
      mapController.removeFieldAtCoordinate(field.coordinate, actor: actor);
    }
  }

  _didCompleteAttack(UnitModel target) async {
    // TODO: Should these run in willResolveAttack?
    if (action.field != null) {
      if (mapModel.canPlaceField(_resolvedTargetCoordinate)) {
        mapController.addField(action.field!,
            creator: actor.owner!, coordinate: _resolvedTargetCoordinate);
      } else {
        log.addRecord(actor,
            'Could not place field at ${_resolvedTargetCoordinate.toEvenQ()}');
      }
    }

    if (target.isSlain) {
      return completer.complete(true);
    }

    if (action.hasPush) {
      if (target.immuneToForcedMovement) {
        log.addRecord(actor,
            'Skipping push because ${EncounterLogEntry.targetKeyword} can not be pushed',
            target: target);
      } else {
        final resolver = EnemyPushResolver(
            game: game, actor: actor, target: target, action: action);
        await resolver.execute();
      }
    } else if (action.pull > 0) {
      if (target.immuneToForcedMovement) {
        log.addRecord(actor,
            'Skipping pull because ${EncounterLogEntry.targetKeyword} can not be pulled',
            target: target);
      } else {
        final resolver = EnemyPullResolver(
            game: game, actor: actor, target: target, action: action);
        await resolver.execute();
      }
    }

    completer.complete(true);
  }

  late HexCoordinate _resolvedTargetCoordinate;

  _resolveAttack() {
    final target = targets.first;
    _resolvedTargetCoordinate =
        actor.closestCoordinateOfTarget(target, origin: actor.coordinate);
    assert(isInRangeForCoordinate(_resolvedTargetCoordinate,
            needsLineOfSight: true) ||
        targetAOE?.definition.isSingleHex == false);
    mapController.attack(
        actor: actor,
        target: target,
        amount: actor.resolveAmountForAction(action),
        pierce: action.pierce,
        willResolveAttack: () async {
          await _willResolveAttack();
        },
        onComplete: () async {
          await _didCompleteAttack(target);
        });
  }

  Completer<bool> completer = Completer();

  @override
  Future<bool> execute() async {
    assert(targets.length == 1);
    final target = targets.first;
    await eventController.onBeforeAttack(actor: actor, target: target);

    if (actor.isSlain || target.isSlain) {
      return false;
    }

    if (!isInRangeForTarget(target: target, needsLineOfSight: true)) {
      log.addRecord(actor,
          'Target is no longer in range; skipping ${action.shortDescription}');
      return false;
    }

    _handleFields();
    _resolveAttack();
    return completer.future;
  }
}
