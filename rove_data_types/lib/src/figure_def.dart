import 'package:flutter/material.dart';
import 'package:rove_data_types/rove_data_types.dart';
import 'package:rove_data_types/src/utils/json_utils.dart';

enum FigureRole {
  ally,
  adversary,
  object;

  String toJson() {
    return name;
  }

  static FigureRole fromJson(String value) {
    return _jsonMap[value]!;
  }
}

final Map<String, FigureRole> _jsonMap = Map<String, FigureRole>.fromEntries(
    FigureRole.values.map((v) => MapEntry(v.toJson(), v)));

@immutable
class FigureDef {
  /// Maximum number of standees for minions. Limits spawns.
  static const int standeeLimit = 8;

  /// Monstrous Growth is a special figure that takes up three hexes.
  static const monstrousGrowthName = 'Monstrous Growth';

  final String? expansion;
  final String name;
  final String image;

  /// When true will use the core campaign asset if the expansion is not null.
  final bool useImageFromCore;
  final FigureRole role;
  final AdversaryType adversaryType;
  final bool lootable;
  final bool large;
  final bool excludeFromBestiary;
  final List<int> codexEntries;

  const FigureDef(
      {this.expansion,
      required this.name,
      required this.image,
      this.useImageFromCore = false,
      required this.role,
      this.adversaryType = AdversaryType.minion,
      this.lootable = false,
      this.large = false,
      this.excludeFromBestiary = false,
      this.codexEntries = const []});

  factory FigureDef.fromJson(Map<String, dynamic> json, {String? expansion}) {
    return FigureDef(
      expansion: json['expansion'] as String? ?? expansion,
      name: json['name'] as String,
      image: json['image'] as String,
      useImageFromCore: json['use_image_from_core'] as bool? ?? false,
      role: FigureRole.fromJson(json['role'] as String),
      adversaryType: json.containsKey('type')
          ? AdversaryType.fromJson(json['type'] as String)
          : AdversaryType.minion,
      lootable: json['lootable'] as bool? ?? false,
      large: json['large'] as bool? ?? false,
      excludeFromBestiary: json['exclude_from_bestiary'] as bool? ?? false,
      codexEntries:
          decodeJsonListNamed('codex_entries', json, (value) => value as int),
    );
  }

  String get displayName => name.replaceAll(' (miniboss)', '');
}
