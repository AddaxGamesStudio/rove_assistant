import 'package:rove_simulator/controller/player_action_resolver.dart';
import 'package:hex_grid/hex_grid.dart';
import 'package:rove_data_types/rove_data_types.dart';

class CreateGlyphResolver extends PlayerActionResolver {
  CreateGlyphResolver({required super.cardResolver, required super.action});

  RoveGlyph get glyph => RoveGlyph.fromName(action.object!);
  int get glyphCount =>
      mapModel.countOfGlyph(glyph) + (player.glyph == glyph ? 1 : 0);
  bool get needsToRemoveGlyph =>
      glyphCount >= glyph.countLimit && glyphCount > 1;

  @override
  String get instruction => needsToRemoveGlyph
      ? 'Select ${glyph.label} To Remove'
      : 'Select ${glyph.label} Destination';

  @override
  bool get isSkippable => false;

  @override
  bool isSelectableAtCoordinate(HexCoordinate coordinate) {
    if (needsToRemoveGlyph) {
      return mapModel.coordinatesOfGlyph(glyph).contains(coordinate);
    }

    if (!isInRangeForCoordinate(coordinate, needsLineOfSight: true)) {
      return false;
    }
    return !mapModel.hasGlyph(coordinate);
  }

  @override
  bool onSelectedCoordinate(HexCoordinate coordinate) {
    if (!isSelectableAtCoordinate(coordinate)) {
      return false;
    }

    if (needsToRemoveGlyph) {
      mapController.removeGlyphAtCoordinate(coordinate, actor: actor.owner!);
      modifiedGameState = true;
      notifyListeners();
      return true;
    }

    if (glyphCount >= glyph.countLimit) {
      if (glyph.countLimit == 1) {
        if (player.glyph == glyph) {
          player.glyph = null;
        } else {
          mapController.removeGlyphAtCoordinate(
              mapModel.coordinatesOfGlyph(glyph).first,
              actor: actor.owner!);
        }
      } else {
        return false;
      }
    }

    mapController.addGlyph(glyph, coordinate: coordinate, actor: actor.owner!);
    didResolve();

    return true;
  }
}
