import 'package:rove_simulator/controller/player_action_resolver.dart';
import 'package:rove_simulator/model/tiles/glyph_model.dart';
import 'package:rove_simulator/model/tiles/tile_model.dart';
import 'package:rove_simulator/model/tiles/unit_model.dart';
import 'package:hex_grid/hex_grid.dart';
import 'package:rove_data_types/rove_data_types.dart';

class SelectActorResolver extends PlayerActionResolver {
  SelectActorResolver({required super.cardResolver, required super.action});

  TileModel? selectedActor;

  @override
  String get instruction => 'Select Actor';

  bool matchesActorKindForUnit(UnitModel unit) {
    switch (action.actor) {
      case RoveActionActorKind.ally:
        return unit.isAllyToUnit(actor.owner!);
      case RoveActionActorKind.allyOrGlyph:
        return unit.isAllyToUnit(actor.owner!);
      case RoveActionActorKind.glyph:
        return false;
      case RoveActionActorKind.eventActor:
      case RoveActionActorKind.eventTarget:
      case RoveActionActorKind.named:
      case RoveActionActorKind.previousTarget:
      case RoveActionActorKind.self:
        throw UnsupportedError('Actor does not require user input');
      case RoveActionActorKind.selfOrGlyph:
        return unit == actor;
    }
  }

  bool matchesActorKindForGlyph(GlyphModel glyph) {
    switch (action.actor) {
      case RoveActionActorKind.ally:
        return false;
      case RoveActionActorKind.allyOrGlyph:
        return glyph.creator == actor;
      case RoveActionActorKind.glyph:
        return glyph.creator == actor;
      case RoveActionActorKind.eventActor:
      case RoveActionActorKind.eventTarget:
      case RoveActionActorKind.named:
      case RoveActionActorKind.previousTarget:
      case RoveActionActorKind.self:
        throw UnsupportedError('Actor does not require user input');
      case RoveActionActorKind.selfOrGlyph:
        return glyph.creator == actor;
    }
  }

  bool matchesActorKind(dynamic target) {
    if (target is UnitModel) {
      return matchesActorKindForUnit(target);
    } else if (target is GlyphModel) {
      return matchesActorKindForGlyph(target);
    }
    return false;
  }

  bool matchesRange(TileModel tileModel) {
    final distance = actorCoordinate.distanceTo(tileModel.coordinate);
    return action.actorRange.$1 <= distance && distance <= action.actorRange.$2;
  }

  List<TileModel> _targetsAtCoordinate(HexCoordinate coordinate) {
    switch (action.actor) {
      case RoveActionActorKind.ally:
        final unit = mapModel.units[coordinate];
        return unit != null && unit.isTargetable ? [unit] : [];
      case RoveActionActorKind.selfOrGlyph:
      case RoveActionActorKind.allyOrGlyph:
        // TODO: Handle having a glyph and unit in the same space
        List<TileModel> targets = [];
        final unit = mapModel.units[coordinate];
        if (unit != null && unit.isTargetable) {
          targets.add(unit);
        }
        final glyph = mapModel.glyphs[coordinate];
        if (glyph != null) {
          targets.add(glyph);
        }
        return targets;
      case RoveActionActorKind.glyph:
        final glyph = mapModel.glyphs[coordinate];
        return glyph != null ? [glyph] : [];
      case RoveActionActorKind.eventActor:
      case RoveActionActorKind.eventTarget:
      case RoveActionActorKind.named:
      case RoveActionActorKind.previousTarget:
      case RoveActionActorKind.self:
        throw UnsupportedError('Actor does not require user input');
    }
  }

  @override
  bool isSelectableAtCoordinate(HexCoordinate coordinate) {
    final targets = _targetsAtCoordinate(coordinate);
    if (targets.isEmpty) {
      return false;
    }

    return targets.any((t) => matchesActorKind(t) && matchesRange(t));
  }

  @override
  bool onSelectedCoordinate(HexCoordinate coordinate) {
    if (!isSelectableAtCoordinate(coordinate)) {
      return false;
    }

    var targets = _targetsAtCoordinate(coordinate);

    if (targets.isEmpty) {
      return false;
    }
    selectedActor = targets.first;
    didResolve();
    return true;
  }

  @override
  bool get isSkippable => true;
}
