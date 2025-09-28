// ignore_for_file: unused_element

import 'package:rove_data_types/rove_data_types.dart';

enum Expansion {
  core(
      name: 'Core',
      roversLevel: 0,
      merchantLevel: 0,
      startingLystPerRover: 0,
      unlockedTraitCount: 0),
  xulc(name: 'Xulc');

  static Expansion? fromValue(String value) {
    switch (value) {
      case coreCampaignKey:
        return Expansion.core;
      case 'xulc':
        return Expansion.xulc;
      default:
        return null;
    }
  }

  final String name;
  final int roversLevel;
  final int merchantLevel;
  final int startingLystPerRover;
  final int unlockedTraitCount;

  const Expansion(
      {required this.name,
      this.roversLevel = 9,
      this.merchantLevel = 4,
      this.startingLystPerRover = 300,
      this.unlockedTraitCount = 2});
}
