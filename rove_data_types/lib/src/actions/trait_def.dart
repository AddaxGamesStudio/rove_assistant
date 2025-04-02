import 'package:rove_data_types/rove_data_types.dart';
import 'package:rove_data_types/src/utils/json_utils.dart';

class TraitDef {
  final String name;
  final String? description;
  final List<ItemSlotType> additionalSlots;
  final List<String> startingTokens;
  final bool isSingleUse;

  TraitDef(
      {required this.name,
      this.description,
      this.additionalSlots = const [],
      this.startingTokens = const [],
      this.isSingleUse = false});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      if (description case final value?) 'description': value,
      if (isSingleUse) 'single_use': isSingleUse,
      if (additionalSlots.isNotEmpty)
        'additional_slots': additionalSlots.map((e) => e.toJson()).toList(),
      if (startingTokens.isNotEmpty) 'starting_tokens': startingTokens.toList(),
    };
  }

  factory TraitDef.fromJson(Map<String, dynamic> json) {
    return TraitDef(
      name: json['name'] as String,
      description: json['description'] as String?,
      isSingleUse: json['single_use'] as bool? ?? false,
      additionalSlots: decodeJsonListNamed(
          'additional_slots', json, (e) => ItemSlotType.fromJson(e)),
      startingTokens:
          decodeJsonListNamed('starting_tokens', json, (e) => e as String),
    );
  }
}
