// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rove_action_description.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoveActionDescription _$RoveActionDescriptionFromJson(
        Map<String, dynamic> json) =>
    RoveActionDescription(
      prefix: json['prefix'] as String?,
      body: json['body'] as String?,
      suffix: json['suffix'] as String?,
    );

Map<String, dynamic> _$RoveActionDescriptionToJson(
        RoveActionDescription instance) =>
    <String, dynamic>{
      if (instance.prefix case final value?) 'prefix': value,
      if (instance.body case final value?) 'body': value,
      if (instance.suffix case final value?) 'suffix': value,
    };
