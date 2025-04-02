import 'package:rove_data_types/rove_data_types.dart';
import 'package:rove_data_types/src/utils/json_utils.dart';

class AllyDef {
  final String name;
  final String? cardId;
  final int defaultBehaviorIndex;

  final List<EncounterFigureDef> behaviors;

  static const int userSelectsDefaultBehavior = -1;

  AllyDef(
      {required this.name,
      this.cardId,
      this.defaultBehaviorIndex = 0,
      required this.behaviors});

  factory AllyDef.fromJson(Map<String, dynamic> json) {
    return AllyDef(
        name: json['name'] as String,
        cardId: json['cardId'] as String?,
        defaultBehaviorIndex: json['default_behavior_index'] as int? ?? 0,
        behaviors: decodeJsonListNamed(
            'behaviors', json, (b) => EncounterFigureDef.fromJson(b)));
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        if (cardId case final value?) 'cardId': value,
        if (defaultBehaviorIndex != 0)
          'default_behavior_index': defaultBehaviorIndex,
        'behaviors': behaviors.map((b) => b.toJson()).toList(),
      };
}
