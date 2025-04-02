import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:rove_data_types/rove_data_types.dart';
import 'package:rove_app_common/data/campaign_loader.dart';
import 'package:rove_app_common/data/classes/dune_dancer_behavior.dart';
import 'package:rove_app_common/data/classes/flash_behavior.dart';
import 'package:rove_app_common/data/classes/shadow_piercer_behavior.dart';
import 'package:rove_app_common/data/classes/sophist_behavior.dart';
import 'package:rove_app_common/data/classes/true_scale_behavior.dart';

abstract class RoverClassBehavior {
  FieldEffect get auraEffect;
  FieldEffect get miasmaEffect;
  List<AbilityDef> get abilities;
  List<SkillDef> get skills;
  List<ReactionDef> get reactions;

  static Map<String, RoverClassBehavior> get behaviors => {
        'Shadow Piercer': ShadowPiercerBehavior(),
        'Flash': FlashBehavior(),
        'True Scale': TrueScaleBehavior(),
        'Sophist': SophistBehavior(),
        'Dune Dancer': DuneDancerBehavior(),
      };

  static RoverClass roverClassWithBehavior(RoverClass roverClass) {
    final behavior = RoverClassBehavior.behaviors[roverClass.name];
    if (behavior == null) {
      return roverClass;
    }
    var abilities = behavior.abilities;
    if (kDebugMode) {
      abilities = [
        AbilityDef(name: 'Debug Teleport', actions: [RoveAction.teleport(99)]),
        AbilityDef(
            name: 'Debug Kill',
            actions: [RoveAction.meleeAttack(99, endRange: 99)]),
        AbilityDef(
            name: 'Debug Force Move',
            actions: [RoveAction.forceMove(99, endRange: 99)]),
        ...behavior.abilities,
      ];
    }
    return RoverClass(
      name: roverClass.name,
      evolutionStage: roverClass.evolutionStage,
      base: roverClass.base,
      health: roverClass.health,
      defense: roverClass.defense,
      color: roverClass.color,
      colorDark: roverClass.colorDark,
      usesGlyphs: roverClass.usesGlyphs,
      etherLimit: roverClass.etherLimit,
      startingEquipment: roverClass.startingEquipment,
      boardTokens: roverClass.boardTokens,
      summons: roverClass.summons,
      trapImage: roverClass.trapImage,
      affinities: roverClass.affinities,
      auraEffect: behavior.auraEffect,
      miasmaEffect: behavior.miasmaEffect,
      abilities: abilities,
      skills: behavior.skills,
      reactions: behavior.reactions,
    );
  }

  static printClasses() {
    CampaignLoader.instance.campaign.classesForLevel(1).forEach((roverClass) {
      final completeClass =
          RoverClassBehavior.roverClassWithBehavior(roverClass);
      final string = jsonEncode(completeClass.toJson());
      // ignore: avoid_print
      print(string);
    });
  }
}
