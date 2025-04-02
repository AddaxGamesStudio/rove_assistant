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
  /// Monstrous Growth is a special figure that takes up three hexes.
  static const monstrousGrowthName = 'Monstrous Growth';

  final String? expansion;
  final String name;
  final String image;
  final FigureRole role;
  final AdversaryType adversaryType;
  final bool lootable;
  final bool large;
  final bool excludeFromBestiary;
  final List<int> codices;

  const FigureDef(
      {this.expansion,
      required this.name,
      required this.image,
      required this.role,
      this.adversaryType = AdversaryType.minion,
      this.lootable = false,
      this.large = false,
      this.excludeFromBestiary = false,
      this.codices = const []});

  factory FigureDef.fromJson(Map<String, dynamic> json, {String? expansion}) {
    return FigureDef(
      expansion: json['expansion'] as String? ?? expansion,
      name: json['name'] as String,
      image: json['image'] as String,
      role: FigureRole.fromJson(json['role'] as String),
      adversaryType: json.containsKey('type')
          ? AdversaryType.fromJson(json['type'] as String)
          : AdversaryType.minion,
      lootable: json['lootable'] as bool? ?? false,
      large: json['large'] as bool? ?? false,
      excludeFromBestiary: json['exclude_from_bestiary'] as bool? ?? false,
      codices: decodeJsonListNamed('codices', json, (value) => value as int),
    );
  }

  String get displayName => name.replaceAll(' (miniboss)', '');
}
