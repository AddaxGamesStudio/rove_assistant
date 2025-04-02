import 'dart:async';

import 'package:rove_simulator/controller/player_action_resolver.dart';
import 'package:rove_simulator/model/encounter_log.dart';
import 'package:rove_simulator/model/tiles/field_model.dart';
import 'package:rove_simulator/model/tiles/tile_model.dart';
import 'package:hex_grid/hex_grid.dart';

abstract class BaseAttackResolver extends PlayerActionResolver {
  HexCoordinate? _selectedCoordinate;

  BaseAttackResolver(
      {super.actor,
      required super.cardResolver,
      required super.action,
      super.target,
      HexCoordinate? selectedCoordinate,
      super.selectedRangeOrigin})
      : _selectedCoordinate = selectedCoordinate ?? target?.coordinate;

  Slayable? get unitTarget => target as Slayable?;

  int attackAmountForTarget(Slayable target) {
    var amount = action.amount;
    if (actor.usesGlyphs) {
      amount += target.coordinates.fold(
          0, (value, c) => value + (mapModel.glyphs[c]?.glyph.attackBuff ?? 0));
    }
    return amount;
  }

  set selectedCoordinate(HexCoordinate? selectedCoordinate) {
    _selectedCoordinate = selectedCoordinate;
    notifyListeners();
  }

  FieldModel? _handledField;

  FieldModel? _handleField() {
    var handled = false;
    final field = mapModel.fieldAtCoordinate(actorCoordinate);
    if (field == null) {
      return null;
    }
    final buff = field.buff;
    if (buff != null) {
      log.addRecord(field.creator,
          'Buffed ${EncounterLogEntry.targetKeyword} with ${buff.descriptionForAction(action)} from ${field.name} field',
          target: actor);
      action = action.withBuff(buff);
      handled = true;
    }
    final fieldAction = field.action;
    if (fieldAction != null) {
      handled = true;
      // TODO: This action should be resolved before the attack is resolved
      cardResolver.addActionForTarget(actor, fieldAction);
    }
    return handled ? field : null;
  }

  final Completer<bool> _completer = Completer();

  attack() {
    assert(unitTarget != null);
    _handledField = _handleField();
    // Target might be slain so save coordinate for field placement if needed
    _selectedCoordinate = _selectedCoordinate ?? unitTarget!.coordinate;
    mapController.attack(
        actor: actor,
        target: unitTarget!,
        amount: attackAmountForTarget(unitTarget!),
        pierce: action.pierce,
        willResolveAttack: () async {
          _willResolveAttack();
        },
        onComplete: () {
          _onAttackResolvedForTarget(unitTarget!);
        });
  }

  @override
  bool get resolvesWithoutUserInput => unitTarget != null;

  @override
  Future<bool> resolve() async {
    if (unitTarget == null) {
      return _completer.future;
    }

    attack();
    return _completer.future;
  }

  HexCoordinate? get fieldCoordinate => _selectedCoordinate;

  _willResolveAttack() {
    if (_handledField != null) {
      mapController.removeFieldAtCoordinate(_handledField!.coordinate,
          actor: actor);
      _handledField = null;
    }
  }

  _onAttackResolvedForTarget(Slayable target) {
    if (action.field != null && fieldCoordinate != null) {
      // Use stored target coordinate in case the target was slain
      if (mapModel.canPlaceField(fieldCoordinate!)) {
        mapController.addField(action.field!,
            creator: actor.owner!, coordinate: fieldCoordinate!);
      } else {
        log.addRecord(actor, 'Could not place field at $fieldCoordinate');
      }
    }

    if (target.isSlain) {
      _completer.complete(true);
      return;
    }

    if (action.push > 0) {
      if (target.immuneToForcedMovement) {
        log.addRecord(actor,
            'Skipping push because ${EncounterLogEntry.targetKeyword} can not be pushed',
            target: target);
      } else {
        final remainingPush = action.withPush();
        cardResolver.addActionForTarget(target, remainingPush);
      }
    } else if (action.pull > 0) {
      if (target.immuneToForcedMovement) {
        log.addRecord(actor,
            'Skipping pull because ${EncounterLogEntry.targetKeyword} can not be pulled',
            target: target);
      } else {
        final remainingPull = action.withPull();
        cardResolver.addActionForTarget(target, remainingPull);
      }
    }
    _completer.complete(true);
  }
}

class AttackResolver extends BaseAttackResolver {
  AttackResolver(
      {super.actor,
      required super.cardResolver,
      required super.action,
      required Slayable slayable,
      super.selectedCoordinate,
      super.selectedRangeOrigin})
      : super(target: slayable);
}
