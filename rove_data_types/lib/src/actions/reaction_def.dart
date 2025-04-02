import 'package:meta/meta.dart';
import 'package:rove_data_types/src/actions/reaction_trigger_def.dart';
import 'package:rove_data_types/src/actions/rove_action.dart';
import 'package:rove_data_types/src/actions/two_sided_card_def.dart';

enum RoveEventType {
  generatedEther,
  afterAttack,
  beforeAttack,
  afterMove,
  afterSuffer,
  afterSlain,
  enteredSpace,
  startTurn,
  endRoverPhase,
  endTurn;

  String toJson() {
    switch (this) {
      case RoveEventType.generatedEther:
        return 'generated_ether';
      case RoveEventType.afterAttack:
        return 'after_attack';
      case RoveEventType.beforeAttack:
        return 'before_attack';
      case RoveEventType.afterSuffer:
        return 'after_suffer';
      case RoveEventType.afterMove:
        return 'after_move';
      case RoveEventType.afterSlain:
        return 'after_slain';
      case RoveEventType.enteredSpace:
        return 'entered_space';
      case RoveEventType.startTurn:
        return 'start_turn';
      case RoveEventType.endRoverPhase:
        return 'end_rover_phase';
      case RoveEventType.endTurn:
        return 'end_turn';
    }
  }

  factory RoveEventType.fromJson(String value) {
    return _jsonMap[value]!;
  }
}

final Map<String, RoveEventType> _jsonMap =
    Map<String, RoveEventType>.fromEntries(
        RoveEventType.values.map((v) => MapEntry(v.toJson(), v)));

enum ReactionTriggerRangeOrigin {
  reactor,
  eventActor;

  String toJson() {
    switch (this) {
      case ReactionTriggerRangeOrigin.reactor:
        return 'reactor';
      case ReactionTriggerRangeOrigin.eventActor:
        return 'event_actor';
    }
  }

  static ReactionTriggerRangeOrigin fromJson(String value) {
    return _rangeOriginJsonMap[value]!;
  }
}

final Map<String, ReactionTriggerRangeOrigin> _rangeOriginJsonMap =
    Map<String, ReactionTriggerRangeOrigin>.fromEntries(
        ReactionTriggerRangeOrigin.values.map((v) => MapEntry(v.toJson(), v)));

@immutable
class ReactionDef extends TwoSidedCardDef {
  final ReactionTriggerDef trigger;
  final String? _description;

  ReactionDef(
      {super.id,
      required super.name,
      String? description,
      required super.subtype,
      super.isUpgrade,
      required super.back,
      required this.trigger,
      required super.actions})
      : _description = description;

  Map<String, dynamic> toJson() {
    return {
      if (id case final value?) 'id': value,
      'name': name,
      if (_description case final value?) 'description': value,
      'subtype': subtype,
      if (isUpgrade) 'is_upgrade': isUpgrade,
      'back': back,
      'trigger': trigger.toJson(),
      'actions': actions.map((a) => a.toJson()).toList(),
    };
  }

  factory ReactionDef.fromJson(Map<String, dynamic> json) {
    return ReactionDef(
      id: json['id'] as String?,
      name: json['name'] as String,
      description: json['description'] as String?,
      subtype: json['subtype'] as String,
      isUpgrade: json['is_upgrade'] as bool? ?? false,
      back: json['back'] as String,
      trigger:
          ReactionTriggerDef.fromJson(json['trigger'] as Map<String, dynamic>),
      actions:
          (json['actions'] as List).map((e) => RoveAction.fromJson(e)).toList(),
    );
  }

  String get description =>
      _description ?? actions.map((a) => a.description).join(';');
}
