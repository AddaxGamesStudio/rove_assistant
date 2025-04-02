import 'package:meta/meta.dart';
import 'package:rove_data_types/src/actions/rove_condition.dart';
import 'package:rove_data_types/src/utils/vector_utils.dart';
import 'package:rove_data_types/src/actions/reaction_def.dart';
import 'package:rove_data_types/src/actions/target_kind.dart';

@immutable
class ReactionTriggerDef {
  final RoveEventType type;
  final TargetKind? actorKind;
  final TargetKind? targetKind;
  final ReactionTriggerRangeOrigin rangeOrigin;
  final RoveCondition? condition;
  final (int, int) range;
  final int amount;
  final String? staticDescription;

  static const _defaultRangeOrigin = ReactionTriggerRangeOrigin.reactor;
  static const _defaultRange = (0, 0);
  static const _defaultAmount = 0;
  ReactionTriggerDef(
      {required this.type,
      this.actorKind,
      this.targetKind,
      this.rangeOrigin = _defaultRangeOrigin,
      this.condition,
      this.range = _defaultRange,
      this.amount = _defaultAmount,
      this.staticDescription});

  Map<String, dynamic> toJson() {
    return {
      'type': type.toJson(),
      if (actorKind case final value?) 'actor_kind': value.toJson(),
      if (targetKind case final value?) 'target_kind': value.toJson(),
      if (rangeOrigin != _defaultRangeOrigin)
        'range_origin': rangeOrigin.toJson(),
      if (condition case final value?) 'condition': value.toString(),
      if (range != _defaultRange) 'range': rangeToString(range),
      if (amount != _defaultAmount) 'amount': amount,
      if (staticDescription case final value?) 'static_description': value,
    };
  }

  factory ReactionTriggerDef.fromJson(Map<String, dynamic> json) {
    return ReactionTriggerDef(
      type: RoveEventType.fromJson(json['type'] as String),
      actorKind: json.containsKey('actor_kind')
          ? TargetKind.fromJson(json['actor_kind'] as String)
          : null,
      targetKind: json.containsKey('target_kind')
          ? TargetKind.fromJson(json['target_kind'] as String)
          : null,
      rangeOrigin: json.containsKey('range_origin')
          ? ReactionTriggerRangeOrigin.fromJson(json['range_origin'] as String)
          : _defaultRangeOrigin,
      condition: json.containsKey('condition')
          ? RoveCondition.fromJson(json['condition'] as String)
          : null,
      range: json.containsKey('range')
          ? parseRange(json['range'] as String)
          : _defaultRange,
      amount:
          json.containsKey('amount') ? json['amount'] as int : _defaultAmount,
      staticDescription: json['staticDescription'] as String?,
    );
  }

  String get description {
    if (staticDescription != null) {
      return staticDescription!;
    }

    final subjectDescription =
        actorKind?.description ?? targetKind?.description ?? 'any';
    switch (type) {
      case RoveEventType.afterSuffer:
        return 'After $subjectDescription suffered $amount or more damage within $range';
      case RoveEventType.afterMove:
        return 'After $subjectDescription ends a movement action $range to you';
      case RoveEventType.afterSlain:
        return 'After $subjectDescription is slain';
      case RoveEventType.afterAttack:
        return 'After $subjectDescription ${actorKind != null ? 'attacks' : 'is attacked'}';
      case RoveEventType.beforeAttack:
        return 'Before $subjectDescription ${actorKind != null ? 'attacks' : 'is attacked'}';
      case RoveEventType.enteredSpace:
        return 'After $subjectDescription enters a space';
      case RoveEventType.generatedEther:
        return 'After a rover generated ether within $range';
      case RoveEventType.startTurn:
        return 'Before $subjectDescription starts their turn adjacent to you';
      case RoveEventType.endRoverPhase:
        return 'At the end of the Rover phase';
      case RoveEventType.endTurn:
        return 'After $subjectDescription ends their turn';
    }
  }

  matchesAmount(int value) {
    switch (type) {
      case RoveEventType.afterSuffer:
        return value >= amount;
      default:
        return amount == 0;
    }
  }
}
