import 'dart:ui';
import 'package:meta/meta.dart';
import 'package:rove_data_types/src/actions/ability_def.dart';
import 'package:rove_data_types/src/actions/field_effect.dart';
import 'package:rove_data_types/src/actions/reaction_def.dart';
import 'package:rove_data_types/src/actions/skill_def.dart';
import 'package:rove_data_types/src/actions/trait_def.dart';
import 'package:rove_data_types/src/campaign_presets.dart';
import 'package:rove_data_types/src/ether.dart';
import 'package:rove_data_types/src/summon_def.dart';
import 'package:rove_data_types/src/utils/json_utils.dart';

enum RoverEvolutionStage {
  base,
  prime,
  apex;

  String toJson() {
    return name;
  }

  String get label {
    switch (this) {
      case base:
        return 'Base';
      case prime:
        return 'Prime';
      case apex:
        return 'Apex';
    }
  }

  factory RoverEvolutionStage.fromName(String name) {
    return RoverEvolutionStage.values
        .firstWhere((element) => element.name == name);
  }

  factory RoverEvolutionStage.fromJson(String json) {
    return RoverEvolutionStage.fromName(json);
  }
}

RoverEvolutionStage roverEvolutionStageForLevel(int level) {
  if (level < rovePrimeLevel) {
    return RoverEvolutionStage.base;
  } else if (level < roveApexLevel) {
    return RoverEvolutionStage.prime;
  } else {
    return RoverEvolutionStage.apex;
  }
}

_normalizeClassName(String name) => name.toLowerCase().replaceAll(' ', '_');
_srcForName(String name) => 'class_${_normalizeClassName(name)}.webp';
_srcForSummon(String name) => 'summon_${_normalizeClassName(name)}.webp';
_iconSrcForName(String name) => 'class_icon_${_normalizeClassName(name)}.webp';
_colorFromString(String rgb) => Color(int.parse('FF$rgb', radix: 16));

String _colorChannelToString(double channel) =>
    (channel * 255).toInt().toRadixString(16).padLeft(2, '0').substring(0, 2);
String _colorToString(Color rgb) =>
    '${_colorChannelToString(rgb.r)}${_colorChannelToString(rgb.g)}${_colorChannelToString(rgb.b)}';

@immutable
class RoverClass {
  // Used for classes that are not available to players, like "Infected" in the Xulc expansion.
  final bool internal;
  final String? expansion;
  final String name;
  final RoverEvolutionStage evolutionStage;
  final String? base;
  final String? prime;
  final int health;
  final int defense;
  final Color color;
  final Color colorDark;
  final bool usesGlyphs;
  final List<String> startingEquipment;
  final List<String> boardTokens;
  final List<SummonDef> summons;
  final int etherLimit;
  final String? trapImage;
  final Map<Ether, int> affinities;
  final FieldEffect auraEffect;
  final FieldEffect miasmaEffect;
  final List<AbilityDef> abilities;
  final List<SkillDef> skills;
  final List<ReactionDef> reactions;
  final List<TraitDef> traits;

  static const _defaultDefense = 0;
  const RoverClass({
    this.internal = false,
    this.expansion,
    required this.name,
    required this.evolutionStage,
    this.base,
    this.prime,
    required this.health,
    this.defense = _defaultDefense,
    required this.color,
    required this.colorDark,
    this.usesGlyphs = false,
    required this.etherLimit,
    required this.startingEquipment,
    this.boardTokens = const [],
    required this.summons,
    this.trapImage,
    this.affinities = const {},
    required this.auraEffect,
    required this.miasmaEffect,
    required this.abilities,
    required this.skills,
    required this.reactions,
    this.traits = const [],
  });

  static fromJson(Map<String, dynamic> json) {
    return RoverClass(
      internal: json.containsKey('internal') as bool? ?? false,
      expansion: json['expansion'] as String?,
      name: json['name'] as String,
      evolutionStage: RoverEvolutionStage.fromJson(json['evolution'] as String),
      base: json['base'] as String?,
      prime: json['prime'] as String?,
      health: json['health'] as int,
      defense: json.containsKey('defense')
          ? json['defense'] as int
          : _defaultDefense,
      color: _colorFromString(json['color_rgb']),
      colorDark: _colorFromString(json['color_dark_rgb']),
      usesGlyphs:
          json.containsKey('uses_glyphs') ? json['uses_glyphs'] as bool : false,
      etherLimit:
          json.containsKey('ether_limit') ? json['ether_limit'] as int : 0,
      startingEquipment: json.containsKey('starting_equipment')
          ? (json['starting_equipment'] as List<dynamic>)
              .map((e) => e as String)
              .toList()
          : [],
      boardTokens: json.containsKey('board_tokens')
          ? (json['board_tokens'] as List<dynamic>)
              .map((e) => e as String)
              .toList()
          : [],
      summons: json.containsKey('summons')
          ? (json['summons'] as List<dynamic>)
              .map((e) => SummonDef.fromJson(e))
              .toList()
          : [],
      trapImage: json['trap_image'] as String?,
      affinities: json.containsKey('affinities')
          ? Ether.affinityFromJson(json['affinities'])
          : {},
      auraEffect: json.containsKey('aura_effect')
          ? FieldEffect.fromJson(json['aura_effect'])
          : FieldEffect.empty(),
      miasmaEffect: json.containsKey('miasma_effect')
          ? FieldEffect.fromJson(json['miasma_effect'])
          : FieldEffect.empty(),
      abilities: json.containsKey('abilities')
          ? (json['abilities'] as List<dynamic>).map((e) {
              return AbilityDef.fromJson(e);
            }).toList()
          : [],
      skills: json.containsKey('skills')
          ? (json['skills'] as List<dynamic>).map((e) {
              return SkillDef.fromJson(e);
            }).toList()
          : [],
      reactions: decodeJsonListNamed(
          'reactions', json, (e) => ReactionDef.fromJson(e)),
      traits: decodeJsonListNamed('traits', json, (e) => TraitDef.fromJson(e)),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (internal) 'internal': internal,
      if (expansion case final value?) 'expansion': value,
      'name': name,
      'evolution': evolutionStage.toString().split('.').last,
      if (base case final value?) 'base': value,
      if (prime case final value?) 'prime': value,
      'health': health,
      if (defense != _defaultDefense) 'defense': defense,
      'color_rgb': _colorToString(color),
      'color_dark_rgb': _colorToString(colorDark),
      if (usesGlyphs) 'uses_glyphs': usesGlyphs,
      'ether_limit': etherLimit,
      if (startingEquipment.isNotEmpty) 'starting_equipment': startingEquipment,
      if (boardTokens.isNotEmpty) 'board_tokens': boardTokens,
      if (summons.isNotEmpty)
        'summons': summons.map((e) => e.toJson()).toList(),
      if (trapImage != null) 'trap_image': trapImage,
      if (affinities.isNotEmpty)
        'affinities': Ether.affinitiesToJson(affinities),
      if (!auraEffect.isEmpty) 'aura_effect': auraEffect.toJson(),
      if (!miasmaEffect.isEmpty) 'miasma_effect': miasmaEffect.toJson(),
      'abilities': abilities.map((e) => e.toJson()).toList(),
      'skills': skills.map((e) => e.toJson()).toList(),
      'reactions': reactions.map((e) => e.toJson()).toList(),
      if (traits.isNotEmpty) 'traits': traits.map((e) => e.toJson()).toList(),
    };
  }

  String get imageSrc => _srcForName(name);
  String get iconSrc => _iconSrcForName(name);

  summonSrc(String name) {
    return _srcForSummon(name);
  }

  static const umbralHowlName = 'Umbral Howl';
  static const essentialistName = 'Essentialist';
  static const kathapatistName = 'Kataphatist';
}
