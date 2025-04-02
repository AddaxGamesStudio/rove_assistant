import 'package:rove_data_types/src/actions/rove_action_target_mode.dart';

enum TargetKind {
  self,
  selfOrAlly,
  selfOrEventActor,
  enemy,
  ally,
  allyOrGlyph,
  glyph;

  String descriptionForTargetMode(RoveActionTargetMode targetMode) {
    switch (targetMode) {
      case RoveActionTargetMode.all:
        switch (this) {
          case TargetKind.selfOrEventActor:
            return 'self and that ally';
          case TargetKind.self:
          case TargetKind.selfOrAlly:
          case TargetKind.enemy:
          case TargetKind.ally:
          case TargetKind.allyOrGlyph:
          case TargetKind.glyph:
            return description;
        }
      case RoveActionTargetMode.eventActor:
      case RoveActionTargetMode.eventTarget:
      case RoveActionTargetMode.previous:
      case RoveActionTargetMode.range:
        return description;
    }
  }

  String get description {
    switch (this) {
      case TargetKind.self:
        return 'Self';
      case TargetKind.selfOrAlly:
        return 'Self or Ally';
      case TargetKind.selfOrEventActor:
        return 'self or that ally';
      case TargetKind.enemy:
        return 'an enemy';
      case TargetKind.ally:
        return 'an ally';
      case TargetKind.allyOrGlyph:
        return 'Ally or Glyph';
      case TargetKind.glyph:
        return 'one of your glyphs';
    }
  }

  String toJson() {
    switch (this) {
      case TargetKind.self:
        return 'self';
      case TargetKind.selfOrAlly:
        return 'self_or_ally';
      case TargetKind.selfOrEventActor:
        return 'self_or_event_actor';
      case TargetKind.enemy:
        return 'enemy';
      case TargetKind.ally:
        return 'ally';
      case TargetKind.allyOrGlyph:
        return 'ally_or_glyph';
      case TargetKind.glyph:
        return 'glyph';
    }
  }

  factory TargetKind.fromJson(String value) {
    return _jsonMap[value]!;
  }
}

final Map<String, TargetKind> _jsonMap = Map<String, TargetKind>.fromEntries(
    TargetKind.values.map((v) => MapEntry(v.toJson(), v)));
