import 'package:rove_data_types/rove_data_types.dart';
import 'package:rove_data_types/src/utils/json_utils.dart';

class AllyDef {
  final String name;
  final String? cardId;
  // Force a specific card index (used when allys only use one side that is not index zero)
  final int? cardIndex;
  final int defaultBehaviorIndex;

  final List<EncounterFigureDef> behaviors;

  static const int userSelectsDefaultBehavior = -1;

  AllyDef(
      {required this.name,
      this.cardId,
      this.cardIndex,
      this.defaultBehaviorIndex = 0,
      required this.behaviors});

  factory AllyDef.fromJson(Map<String, dynamic> json) {
    return AllyDef(
        name: json['name'] as String,
        cardId: json['card_id'] as String?,
        cardIndex: json['card_index'] as int?,
        defaultBehaviorIndex: json['default_behavior_index'] as int? ?? 0,
        behaviors: decodeJsonListNamed(
            'behaviors', json, (b) => EncounterFigureDef.fromJson(b)));
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        if (cardId case final value?) 'card_id': value,
        if (cardIndex case final value?) 'card_index': value,
        if (defaultBehaviorIndex != 0)
          'default_behavior_index': defaultBehaviorIndex,
        'behaviors': behaviors.map((b) => b.toJson()).toList(),
      };
}
