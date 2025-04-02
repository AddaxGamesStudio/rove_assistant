import 'package:meta/meta.dart';
import 'package:rove_data_types/src/actions/reaction_trigger_def.dart';
import 'package:rove_data_types/src/actions/rove_action.dart';

@immutable
class EnemyReactionDef {
  /// Used as key when the reaction has a limit.
  final String? title;
  final String? body;

  /// The number of times this reaction can be triggered. A value lower or equal to 0 means no limit.
  final int limit;
  final ReactionTriggerDef trigger;
  final List<RoveAction> actions;

  EnemyReactionDef(
      {this.title,
      this.body,
      this.limit = 0,
      required this.trigger,
      required this.actions});

  Map<String, dynamic> toJson() {
    return {
      if (title case final value?) 'title': value,
      if (body case final value?) 'description': value,
      if (limit != 0) 'limit': limit,
      'trigger': trigger.toJson(),
      'actions': actions.map((a) => a.toJson()).toList(),
    };
  }

  factory EnemyReactionDef.fromJson(Map<String, dynamic> json) {
    return EnemyReactionDef(
      title: json['title'] as String?,
      body: json['description'] as String?,
      limit: json['limit'] as int? ?? 0,
      trigger:
          ReactionTriggerDef.fromJson(json['trigger'] as Map<String, dynamic>),
      actions:
          (json['actions'] as List).map((e) => RoveAction.fromJson(e)).toList(),
    );
  }
}
