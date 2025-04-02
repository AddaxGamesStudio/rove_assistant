import 'dart:math';
import 'dart:ui';

import 'package:rove_data_types/rove_data_types.dart';

EtherDieSide? etherDieFromJson(String? value) {
  if (value == null) return null;
  return EtherDieSide.values
      .firstWhere((e) => e.toString() == 'EtherDieSide.$value');
}

String? jsonFromEtherDie(EtherDieSide? etherDie) {
  if (etherDie == null) return null;
  return etherDie.toString().replaceFirst('EtherDieSide.', '');
}

stringFromEtherDie(EtherDieSide etherDie) {
  return etherDie.toString().replaceFirst('EtherDieSide.', '');
}

enum EtherDieSide {
  air,
  crux,
  earth,
  fire,
  morph,
  water;

  static EtherDieSide randomSide({int? seed}) {
    final values = EtherDieSide.values;
    return values[Random(seed).nextInt(values.length)];
  }

  String get name {
    switch (this) {
      case EtherDieSide.air:
        return 'Wind';
      case EtherDieSide.crux:
        return 'Crux';
      case EtherDieSide.earth:
        return 'Earth';
      case EtherDieSide.fire:
        return 'Fire';
      case EtherDieSide.morph:
        return 'Morph';
      case EtherDieSide.water:
        return 'Water';
    }
  }

  String toJson() {
    return name.toLowerCase();
  }
}

enum Ether {
  wind,
  crux,
  earth,
  fire,
  morph,
  water,
  dim;

  String toJson() {
    return name;
  }

  factory Ether.fromName(String name) {
    return Ether.values.firstWhere((element) => element.name == name);
  }

  factory Ether.fromJson(String json) {
    return Ether.fromName(json);
  }

  String get label {
    switch (this) {
      case Ether.wind:
        return 'Wind';
      case Ether.crux:
        return 'Crux';
      case Ether.earth:
        return 'Earth';
      case Ether.fire:
        return 'Fire';
      case Ether.morph:
        return 'Morph';
      case Ether.water:
        return 'Water';
      case Ether.dim:
        return 'Dim';
    }
  }

  Color get color {
    switch (this) {
      case Ether.wind:
        return Color(0xFFDDAA45);
      case Ether.crux:
        return Color(0xFF9C99A8);
      case Ether.earth:
        return Color(0xFFA2BC53);
      case Ether.fire:
        return Color(0xFFCC5C3B);
      case Ether.morph:
        return Color(0xFF5F4877);
      case Ether.water:
        return Color(0xFF5E84BF);
      case Ether.dim:
        return Color(0xFF4F5254);
    }
  }

  int get defenseBuff {
    switch (this) {
      case Ether.wind:
        return 1;
      case Ether.crux:
      case Ether.earth:
      case Ether.fire:
      case Ether.morph:
      case Ether.water:
      case Ether.dim:
        return 0;
    }
  }

  int get movementCostToEnterAdjacentSpace {
    switch (this) {
      case Ether.water:
        return 1;
      case Ether.wind:
      case Ether.crux:
      case Ether.earth:
      case Ether.fire:
      case Ether.morph:
      case Ether.dim:
        return 0;
    }
  }

  static List<Ether> etherDieSides = [
    Ether.wind,
    Ether.crux,
    Ether.earth,
    Ether.fire,
    Ether.morph,
    Ether.water,
  ];

  static List<Ether> damageDieSides = [
    Ether.wind,
    Ether.crux,
    Ether.earth,
    Ether.fire,
    Ether.morph,
    Ether.water,
    Ether.dim,
    Ether.dim
  ];

  static Ether randomDamageDie() {
    return damageDieSides[Random().nextInt(damageDieSides.length)];
  }

  static Ether randomNonDimEther() {
    return etherDieSides[Random().nextInt(etherDieSides.length)];
  }

  static Map<Ether, int> affinityFromJson(Map<String, dynamic> json) {
    final affinities = <Ether, int>{};
    for (Ether ether in Ether.values) {
      affinities[ether] = (json[ether.name] ?? 0) as int;
    }
    return affinities;
  }

  static Map<String, dynamic> affinitiesToJson(Map<Ether, int> affinities) {
    return Map<String, dynamic>.fromEntries(
        affinities.entries.map((a) => MapEntry(a.key.toJson(), a.value)));
  }

  static List<Ether> etherOptionsFromString(String value) {
    final components = value.split(';');
    return components.map((c) => Ether.fromJson(c)).toList();
  }

  static String etherOptionsToString(List<Ether> options) {
    return options.map((e) => e.toJson()).join(';');
  }
}

enum EtherField {
  snapfrost,
  wildfire,
  everbloom,
  windscreen,
  miasma,
  aura;

  bool get isPositive {
    switch (this) {
      case EtherField.aura:
      case EtherField.everbloom:
      case EtherField.windscreen:
        return true;
      case EtherField.miasma:
      case EtherField.snapfrost:
      case EtherField.wildfire:
        return false;
    }
  }

  RoveBuff? get buff {
    switch (this) {
      case EtherField.aura:
        return RoveBuff(amount: 2, type: BuffType.attack);
      case EtherField.miasma:
        return RoveBuff(amount: -2, type: BuffType.attack);
      default:
        return null;
    }
  }

  String toJson() {
    return name;
  }

  static EtherField fromJson(String json) {
    return EtherField.fromName(json);
  }

  static EtherField fromName(String name) {
    return EtherField.values.firstWhere((element) => element.name == name);
  }

  String get label {
    switch (this) {
      case EtherField.snapfrost:
        return 'Snapfrost';
      case EtherField.wildfire:
        return 'Wildfire';
      case EtherField.everbloom:
        return 'Everbloom';
      case EtherField.windscreen:
        return 'Windscreen';
      case EtherField.miasma:
        return 'Miasma';
      case EtherField.aura:
        return 'Aura';
    }
  }
}
