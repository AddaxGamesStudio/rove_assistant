// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_encounter_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlayerEncounterState _$PlayerEncounterStateFromJson(
        Map<String, dynamic> json) =>
    PlayerEncounterState(
      health: (json['health'] as num).toInt(),
      defense: (json['defense'] as num).toInt(),
      hasReacted: json['has_reaction'] as bool? ?? false,
      encounterTokens: (json['encounter_tokens'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      boardTokens: json['board_tokens'] == null
          ? []
          : _boardTokensFromJson(json['board_tokens'] as List),
    );

Map<String, dynamic> _$PlayerEncounterStateToJson(
        PlayerEncounterState instance) =>
    <String, dynamic>{
      'health': instance.health,
      'defense': instance.defense,
      'has_reaction': instance.hasReacted,
      'encounter_tokens': instance.encounterTokens,
      'board_tokens': _jsonFromBoardTokens(instance.boardTokens),
    };
