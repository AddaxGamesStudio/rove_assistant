import 'package:rove_data_types/rove_data_types.dart';

class ItemTimingCondition {
  final RoveActionType? type;
  final int? minRange;
  final bool? isAbility;

  ItemTimingCondition({this.type, this.minRange, this.isAbility = false});

  bool matchesAction(RoveAction action, bool isAbility) {
    if (type != null && action.type != type) {
      return false;
    }
    if (minRange != null && action.range.$1 < minRange!) {
      return false;
    }
    if (this.isAbility != null && this.isAbility == isAbility) {
      return false;
    }
    return true;
  }

  Map<String, dynamic> toJson() {
    return {
      if (type case final value?) 'type': value.toJson(),
      if (minRange case final value?) 'min_range': value,
      if (isAbility case final value?) 'is_ability': value,
    };
  }

  factory ItemTimingCondition.fromJson(Map<String, dynamic> json) {
    return ItemTimingCondition(
      type: json.containsKey('type')
          ? RoveActionType.fromJson(json['type'] as String)
          : null,
      minRange: json.containsKey('min_range') ? json['min_range'] as int : null,
      isAbility:
          json.containsKey('is_ability') ? json['is_ability'] as bool : null,
    );
  }
}
