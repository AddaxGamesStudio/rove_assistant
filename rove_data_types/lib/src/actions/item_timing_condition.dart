import 'package:rove_data_types/rove_data_types.dart';

class ItemTimingCondition {
  final RoveActionType? actionType;
  final int? minRange;
  final bool? isAbility;

  ItemTimingCondition({this.actionType, this.minRange, this.isAbility = false});

  bool matchesAction(RoveAction action, bool isAbility) {
    if (actionType != null && action.type != actionType) {
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
      if (actionType case final value?) 'action': value.toJson(),
      if (minRange case final value?) 'min_range': value,
      if (isAbility case final value?) 'is_ability': value,
    };
  }

  factory ItemTimingCondition.fromJson(Map<String, dynamic> json) {
    return ItemTimingCondition(
      actionType: json.containsKey('action')
          ? RoveActionType.fromJson(json['action'] as String)
          : null,
      minRange: json.containsKey('min_range') ? json['min_range'] as int : null,
      isAbility:
          json.containsKey('is_ability') ? json['is_ability'] as bool : null,
    );
  }
}
