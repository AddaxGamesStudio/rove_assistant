import 'package:flutter/material.dart';
import 'package:rove_data_types/rove_data_types.dart';

extension RoverClassTestData on RoverClass {
  static RoverClass testClass() {
    return RoverClass(
        name: 'Test',
        evolutionStage: RoverEvolutionStage.base,
        health: 10,
        color: Colors.white,
        colorDark: Colors.black,
        usesGlyphs: false,
        etherLimit: 3,
        startingEquipment: const [],
        summons: const [],
        miasmaEffect: FieldEffect.empty(),
        auraEffect: FieldEffect.empty(),
        abilities: const [],
        skills: const [],
        reactions: const []);
  }
}
