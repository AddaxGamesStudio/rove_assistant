import 'package:rove_data_types/src/actions/rove_action.dart';

enum RoveActionActorKind {
  self,
  glyph,
  ally,
  allyOrGlyph,
  named,
  selfOrGlyph,
  previousTarget,
  eventActor,
  eventTarget;

  String descriptionForAction(RoveAction action) {
    switch (this) {
      case RoveActionActorKind.eventActor:
        return 'That actor';
      case RoveActionActorKind.previousTarget:
      case RoveActionActorKind.eventTarget:
        return 'That target';
      case RoveActionActorKind.self:
        return 'You';
      case RoveActionActorKind.glyph:
        return 'One of your glyphs';
      case RoveActionActorKind.ally:
        return 'One ally';
      case RoveActionActorKind.allyOrGlyph:
        return 'One ally or glyph';
      case RoveActionActorKind.named:
        return 'The ${action.object}';
      case RoveActionActorKind.selfOrGlyph:
        return 'You or one of your glyphs';
    }
  }

  bool get requiresSelection {
    switch (this) {
      case RoveActionActorKind.previousTarget:
      case RoveActionActorKind.eventActor:
      case RoveActionActorKind.eventTarget:
      case RoveActionActorKind.named:
      case RoveActionActorKind.self:
        return false;
      case RoveActionActorKind.glyph:
      case RoveActionActorKind.ally:
      case RoveActionActorKind.allyOrGlyph:
      case RoveActionActorKind.selfOrGlyph:
        return true;
    }
  }

  String toJson() {
    switch (this) {
      case RoveActionActorKind.self:
        return 'self';
      case RoveActionActorKind.glyph:
        return 'glyph';
      case RoveActionActorKind.ally:
        return 'ally';
      case RoveActionActorKind.allyOrGlyph:
        return 'ally_or_glyph';
      case RoveActionActorKind.named:
        return 'named';
      case RoveActionActorKind.selfOrGlyph:
        return 'self_or_glyph';
      case RoveActionActorKind.previousTarget:
        return 'previous_target';
      case RoveActionActorKind.eventActor:
        return 'event_actor';
      case RoveActionActorKind.eventTarget:
        return 'event_target';
    }
  }

  static RoveActionActorKind fromJson(String value) {
    return _jsonMap[value]!;
  }
}

final Map<String, RoveActionActorKind> _jsonMap =
    Map<String, RoveActionActorKind>.fromEntries(
        RoveActionActorKind.values.map((v) => MapEntry(v.toJson(), v)));
