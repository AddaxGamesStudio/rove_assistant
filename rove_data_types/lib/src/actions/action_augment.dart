import 'package:meta/meta.dart';
import 'package:rove_data_types/src/actions/augment_condition.dart';
import 'package:rove_data_types/src/actions/rove_action.dart';
import 'package:rove_data_types/src/actions/rove_action_type.dart';
import 'package:rove_data_types/src/ether.dart';

enum AugmentType { additional, buff, replacement, special }

@immutable
class ActionAugment {
  final AugmentCondition condition;
  final RoveAction action;
  final bool isReplacement;
  final bool exclusive;

  ActionAugment(
      {required this.condition,
      required this.action,
      this.isReplacement = false,
      this.exclusive = false});

  Map<String, dynamic> toJson() {
    return {
      'condition': condition.toJson(),
      'action': action.toJson(),
      if (isReplacement) 'is_replacement': true,
      if (exclusive) 'exclusive': true,
    };
  }

  factory ActionAugment.fromJson(Map<String, dynamic> json) {
    return ActionAugment(
      condition: AugmentCondition.fromJson(json['condition']),
      action: RoveAction.fromJson(json['action']),
      isReplacement: json['is_replacement'] as bool? ?? false,
      exclusive: json['exclusive'] as bool? ?? false,
    );
  }

  String descriptionForAction(RoveAction action, {bool short = false}) =>
      this.action.descriptionForAugmentingAction(action, short: short);

  RoveAction augmentAction(RoveAction action) {
    assert(specialId == null);
    if (isReplacement) {
      return this.action;
    } else {
      return action.withBuff(this.action.toBuff!);
    }
  }

  bool matchesEther(List<Ether> etherToMatch) {
    return condition.matchesEther(etherToMatch);
  }

  AugmentType get type {
    if (specialId != null) {
      return AugmentType.special;
    } else if (isReplacement) {
      return AugmentType.replacement;
    } else if (action.toBuff != null) {
      return AugmentType.buff;
    } else {
      return AugmentType.additional;
    }
  }

  String? get specialId =>
      action.type == RoveActionType.special ? action.object! : null;
}
