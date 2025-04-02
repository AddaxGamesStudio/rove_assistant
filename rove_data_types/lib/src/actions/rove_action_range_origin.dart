import 'package:rove_data_types/src/rove_glyph.dart';

enum RoveActionRangeOrigin {
  actor,
  previousTarget,
  aerios(glyph: RoveGlyph.aerios),
  armoroll(glyph: RoveGlyph.armoroll),
  actorOrGlyph,
  range4(endRange: 4),
  selection;

  final int? endRange;
  final RoveGlyph? glyph;
  // ignore: unused_element
  const RoveActionRangeOrigin({this.glyph, this.endRange});

  bool get needsSelection {
    switch (this) {
      case actor:
      case previousTarget:
      case actorOrGlyph:
      case aerios:
      case armoroll:
      case selection:
        return false;
      case range4:
        return true;
    }
  }

  String toJson() {
    switch (this) {
      case actor:
        return 'actor';
      case previousTarget:
        return 'previous_target';
      case aerios:
      case armoroll:
        return glyph!.name;
      case actorOrGlyph:
        return 'actor_or_glyph';
      case range4:
        return 'range=(1,$endRange)';
      case selection:
        return 'selection';
    }
  }

  static RoveActionRangeOrigin fromJson(String value) {
    return _jsonMap[value]!;
  }
}

final Map<String, RoveActionRangeOrigin> _jsonMap =
    Map<String, RoveActionRangeOrigin>.fromEntries(
        RoveActionRangeOrigin.values.map((v) => MapEntry(v.toJson(), v)));
