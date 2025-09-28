// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'figure_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FigureState _$FigureStateFromJson(Map<String, dynamic> json) => FigureState(
      health: (json['health'] as num).toInt(),
      maxHealth: json['max_health'],
      defense: (json['defense'] as num?)?.toInt(),
      roundSlain: (json['round_slain'] as num?)?.toInt(),
      selectedTokens: (json['selectedTokens'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      overrideNumber: (json['number'] as num?)?.toInt(),
      allyBehaviorIndex: (json['allyBehaviorIndex'] as num?)?.toInt() ?? 0,
      removed: json['removed'] as bool? ?? false,
    );

Map<String, dynamic> _$FigureStateToJson(FigureState instance) =>
    <String, dynamic>{
      'health': instance.health,
      'max_health': instance.maxHealth,
      'defense': instance.defense,
      'round_slain': instance.roundSlain,
      'selectedTokens': instance.selectedTokens,
      'number': instance.overrideNumber,
      'removed': instance.removed,
      'allyBehaviorIndex': instance.allyBehaviorIndex,
    };
