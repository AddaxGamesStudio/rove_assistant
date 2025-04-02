import 'package:meta/meta.dart';

@immutable
class EncounterTrackerEventDef {
  static const int anyRound = 0;
  static const String dialogPrefix = 'dialog:';
  static const String functionDrawField = 'draw_field';
  static const String appendPrefix = '+';
  static const String displayNamePrefix = 'DN:';
  static const String allValue = 'all';
  static const String onSlayedAllVerb = 'all';
  static const String onSlayedAllMinusVerb = 'all_minus';
  static const String onSlayedFirstVerb = 'first';
  static const String keywordAny = 'any';
  static const String onSlayedRoverCountVerb = 'rover_count';
  static const String onDamageSufferedVerb = 'suffered';
  static const String roundCounterResetVerb = "reset";

  final String title;
  final bool internal;
  final String? recordMilestone;
  final String? ifMilestone;

  EncounterTrackerEventDef({
    required String title,
    this.recordMilestone,
    this.ifMilestone,
  })  : title = title.startsWith('_') ? title.replaceFirst(('_'), '') : title,
        internal = title.startsWith('_');

  factory EncounterTrackerEventDef.fromJson(Map<String, dynamic> json) {
    return EncounterTrackerEventDef(
      title: json['title'] as String,
      recordMilestone: json['record_milestone'] as String?,
      ifMilestone: json['if_achieved'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': internal ? '_$title' : title,
      if (recordMilestone != null) 'record_milestone': recordMilestone,
      if (ifMilestone != null) 'if_achieved': ifMilestone,
    };
  }
}
