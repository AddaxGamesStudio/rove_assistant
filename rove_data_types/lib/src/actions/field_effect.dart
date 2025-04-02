import 'package:flutter/foundation.dart';
import 'package:rove_data_types/rove_data_types.dart';

@immutable
class FieldEffect {
  final bool appliesToAllEnemies;
  final RoveBuff? buff;
  final RoveAction? action;

  const FieldEffect(
      {this.appliesToAllEnemies = false,
      required this.buff,
      required this.action});

  static FieldEffect fromJson(Map<String, dynamic> json) {
    return FieldEffect(
        buff: json.containsKey('buff') ? RoveBuff.fromJson(json['buff']) : null,
        action: json.containsKey('action')
            ? RoveAction.fromJson(json['action'])
            : null);
  }

  Map<String, dynamic> toJson() {
    return {
      if (buff case final value?) 'buff': value.toJson(),
      if (action case final value?) 'action': value.toJson(),
    };
  }

  factory FieldEffect.empty() {
    return FieldEffect(buff: null, action: null);
  }

  bool get isEmpty => buff == null && action == null;
}
