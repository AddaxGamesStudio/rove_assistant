import 'dart:math';

import 'package:rove_simulator/controller/player_action_resolver.dart';
import 'package:hex_grid/hex_grid.dart';
import 'package:rove_data_types/rove_data_types.dart';

class PlaceFieldResolver extends PlayerActionResolver {
  int _pendingFields;

  PlaceFieldResolver(
      {super.actor,
      required super.cardResolver,
      required super.action,
      super.target})
      : _pendingFields = max(1, action.targetCount);

  EtherField get field => action.field!;

  @override
  String get instruction => _pendingFields > 1
      ? 'Select ${field.label} Destination ($_pendingFields)'
      : 'Select ${field.label} Destination';

  bool _canPlaceFieldAtCoordinate(HexCoordinate coordinate) {
    if (!mapModel.canPlaceField(coordinate)) {
      return false;
    }

    if (field.isPositive && mapModel.hasEnemyAtCoordinate(actor, coordinate)) {
      return false;
    } else if (!field.isPositive &&
        mapModel.hasAllyAtCoordinate(actor, coordinate)) {
      return false;
    }

    return true;
  }

  @override
  bool isSelectableAtCoordinate(HexCoordinate coordinate) {
    if (target != null) {
      if (target?.coordinate != coordinate) {
        return false;
      }
    } else {
      if (!isInRangeForCoordinate(coordinate, needsLineOfSight: true)) {
        return false;
      }
    }

    return _canPlaceFieldAtCoordinate(coordinate);
  }

  @override
  bool onSelectedCoordinate(HexCoordinate coordinate) {
    if (!isSelectableAtCoordinate(coordinate)) {
      return false;
    }

    mapController.addField(field,
        creator: actor.owner!, coordinate: coordinate);
    _pendingFields--;
    if (_pendingFields <= 0) {
      didResolve();
    }
    return true;
  }
}
