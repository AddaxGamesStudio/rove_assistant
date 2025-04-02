import 'package:collection/collection.dart';
import 'package:flutter/services.dart';
import 'package:rove_simulator/controller/card_resolver.dart';
import 'package:rove_simulator/controller/player_action_resolver.dart';
import 'package:rove_simulator/model/targeting/aoe_def_coordinate_extension.dart';
import 'package:rove_simulator/model/tiles/glyph_model.dart';
import 'package:rove_simulator/model/tiles/object_model.dart';
import 'package:rove_simulator/model/tiles/player_unit_model.dart';
import 'package:rove_simulator/model/tiles/tile_model.dart';
import 'package:rove_simulator/model/tiles/unit_model.dart';
import 'package:hex_grid/hex_grid.dart';
import 'package:rove_data_types/rove_data_types.dart';

class SelectTargetsResolver extends PlayerActionResolver
    with Confirmable, OnKeyEvent {
  SelectTargetsResolver(
      {this.index,
      this.previousTargets = const [],
      required super.cardResolver,
      required super.action,
      super.actor,
      super.selectedRangeOrigin});

  final int? index;
  final List<TileModel> previousTargets;
  List<HexCoordinate> _selectedCoordinates = [];
  List<(TileModel, HexCoordinate)> selectedTargets = [];
  late HexCoordinate selectedCoordinate;

  bool get isMultiTargetNonAOE => action.targetCount > 1 && !isAreaOfEffect;

  @override
  String get instruction {
    final aoe = action.aoe;
    final aoeSuffix = aoe != null && !aoe.radiallySymmetrical
        ? '; Use Arrow Keys To Rotate The Area Of Effect'
        : '';
    if (action.targetCount > 1) {
      final countSuffix = action.targetCount == RoveAction.allTargets
          ? ''
          : ' (max. ${action.targetCount})';
      return 'Select ${action.shortDescription} Targets$countSuffix$aoeSuffix';
    } else {
      return 'Select ${action.shortDescription} Target$aoeSuffix';
    }
  }

  @override
  HexCoordinate? get targetingCoordinate =>
      _currentCoordinate ?? super.targetingCoordinate;

  bool get isSelectingTarget => selectedTargets.isEmpty;
  bool get isAreaOfEffect => action.aoe != null;

  bool matchesTargetKindForUnit(UnitModel unit) {
    switch (action.targetKind) {
      case TargetKind.allyOrGlyph:
        return unit.isAllyToUnit(actor.owner!);
      case TargetKind.ally:
        return unit.isAllyToUnit(actor.owner!);
      case TargetKind.enemy:
        return unit.isEnemyToUnit(actor.owner!);
      case TargetKind.self:
        return unit == actor;
      case TargetKind.selfOrAlly:
        return unit.isAllyToUnit(actor.owner!) || unit == actor;
      case TargetKind.selfOrEventActor:
        return unit == cardResolver.event?.actor || unit == actor;
      case TargetKind.glyph:
        return false;
    }
  }

  bool matchesTargetKindForGlyph(GlyphModel glyph) {
    switch (action.targetKind) {
      case TargetKind.glyph:
      case TargetKind.allyOrGlyph:
        return true;
      case TargetKind.ally:
      case TargetKind.enemy:
      case TargetKind.self:
      case TargetKind.selfOrAlly:
        return false;
      case TargetKind.selfOrEventActor:
        return cardResolver.event?.actor == glyph;
    }
  }

  bool matchesTargetKindForObject(ObjectModel object) {
    switch (action.targetKind) {
      case TargetKind.glyph:
      case TargetKind.allyOrGlyph:
      case TargetKind.ally:
      case TargetKind.self:
      case TargetKind.selfOrAlly:
        return false;
      case TargetKind.enemy:
        switch (action.type) {
          case RoveActionType.attack:
          case RoveActionType.suffer:
            return object.canBeSlain;
          default:
            return false;
        }
      case TargetKind.selfOrEventActor:
        return cardResolver.event?.actor == object;
    }
  }

  bool isValidForActionType({required UnitModel target}) {
    if (!target.isTargetable && action.type != RoveActionType.revive) {
      return false;
    }
    if (action.type.isForcedMovement) {
      return !target.immuneToForcedMovement;
    } else if (action.type == RoveActionType.push) {
      return action.amount > target.reducePushPullBy;
    } else if (action.type == RoveActionType.pull) {
      return action.amount > target.reducePushPullBy;
    } else if (action.type == RoveActionType.revive) {
      return target is PlayerUnitModel && target.isDowned;
    }
    return true;
  }

  bool matchesTargetKind(dynamic target) {
    if (target is UnitModel) {
      return matchesTargetKindForUnit(target) &&
          isValidForActionType(target: target);
    } else if (target is GlyphModel) {
      return matchesTargetKindForGlyph(target);
    } else if (target is ObjectModel) {
      return matchesTargetKindForObject(target);
    }
    return false;
  }

  List<(TileModel, HexCoordinate)> targetsAtCoordinateConsideringAOE(
      HexCoordinate coordinate) {
    if (!isAreaOfEffect) {
      return _targetsAtCoordinate(coordinate);
    }

    final rotatedCoordinates = action.aoe!.rotatedCoordinates(
        center: actorCoordinate.toCube(),
        anchor: coordinate.toCube(),
        rotationTicksDelta: _rotationTicksDelta);
    return rotatedCoordinates.map(_targetsAtCoordinate).flattenedToList;
  }

  List<(TileModel, HexCoordinate)> _targetsAtCoordinate(
      HexCoordinate coordinate) {
    List<TileModel> targetsAtCoordinate(HexCoordinate coordinate) {
      switch (action.targetKind) {
        case TargetKind.glyph:
          final glyph = mapModel.glyphs[coordinate];
          return glyph != null ? [glyph] : [];
        case TargetKind.allyOrGlyph:
          // TODO: Handle having a glyph and ally in the same place
          List<TileModel> targets = [];
          final unit = mapModel.units[coordinate];
          if (unit != null) {
            targets.add(unit);
          }
          final glyph = mapModel.glyphs[coordinate];
          if (glyph != null) {
            targets.add(glyph);
          }
          return targets;
        case TargetKind.ally:
        case TargetKind.self:
        case TargetKind.selfOrAlly:
        case TargetKind.selfOrEventActor:
          final unit = mapModel.units[coordinate];
          return unit != null ? [unit] : [];
        case TargetKind.enemy:
          List<TileModel> targets = [];
          final unit = mapModel.units[coordinate];
          if (unit != null) {
            targets.add(unit);
          }
          final object = mapModel.objects[coordinate];
          if (object != null) {
            targets.add(object);
          }
          return targets;
      }
    }

    return targetsAtCoordinate(coordinate).map((t) => (t, coordinate)).toList();
  }

  @override
  bool isSelectableAtCoordinate(HexCoordinate coordinate) {
    if (!isInRangeForCoordinate(coordinate, needsLineOfSight: true)) {
      return false;
    }
    final targets = targetsAtCoordinateConsideringAOE(coordinate)
        .where((t) => !previousTargets.contains(t.$1));
    if (targets.isEmpty) {
      return false;
    }

    return targets.any((t) => matchesTargetKind(t.$1));
  }

  @override
  bool isInAreaOfEffect(HexCoordinate coordinate) {
    if (!isAreaOfEffect) {
      return _selectedCoordinates.contains(coordinate);
    }
    if (_currentCoordinate == null) {
      return false;
    }

    return action.aoe!.isInside(
        center: actorCoordinate.toCube(),
        anchor: _currentCoordinate!,
        coordinate: coordinate,
        rotationTicksDelta: _rotationTicksDelta);
  }

  CubeHexCoordinate? _currentCoordinate;

  @override
  bool onHoveredCoordinate(HexCoordinate coordinate) {
    if (!isSelectableAtCoordinate(coordinate)) {
      _currentCoordinate = null;
      return false;
    }
    if (_currentCoordinate != coordinate) {
      _currentCoordinate = coordinate.toCube();
    }
    return true;
  }

  @override
  bool onSelectedCoordinate(HexCoordinate coordinate) {
    if (!isSelectableAtCoordinate(coordinate)) {
      return false;
    }

    var targets = targetsAtCoordinateConsideringAOE(coordinate);
    if (!action.targetsAllInAreaOfEffect &&
        targets.length > action.targetCount) {
      // TODO: Allow user to select which targets
      targets = targets.sublist(0, action.targetCount);
    }

    if (targets.isEmpty) {
      return false;
    }
    _addNewTargets(targets);
    selectedCoordinate = coordinate;
    if (!isMultiTargetNonAOE) {
      didResolve();
    }
    return true;
  }

  _addNewTargets(List<(TileModel, HexCoordinate)> targets) {
    if (isAreaOfEffect) {
      selectedTargets = targets;
      return;
    }
    final newTargets =
        targets.where((t) => !selectedTargets.contains(t)).toList();
    if (newTargets.length + selectedTargets.length > action.targetCount) {
      final targetsToRemoveCount =
          newTargets.length + selectedTargets.length - action.targetCount;
      selectedTargets =
          selectedTargets.sublist(targetsToRemoveCount, selectedTargets.length);
      _selectedCoordinates = _selectedCoordinates.sublist(
          targetsToRemoveCount, _selectedCoordinates.length);
    }
    selectedTargets.addAll(newTargets);
    _selectedCoordinates.addAll(newTargets.map((e) => e.$2).toList());
    notifyListeners();
  }

  @override
  bool get isConfirmable => isMultiTargetNonAOE;

  @override
  bool confirm() {
    if (isConfirmable) {
      didResolve();
      return true;
    }
    return false;
  }

  @override
  String get confirmLabel =>
      'Confirm Target Selection (${selectedTargets.length})';

  @override
  bool get isSkippable => true;

  var _rotationTicksDelta = 0;
  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (event is KeyDownEvent) {
      if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
        _rotationTicksDelta--;
        return true;
      } else if (keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
        _rotationTicksDelta++;
        return true;
      }
    }
    return false;
  }
}
