import 'dart:ui';

import 'package:flutter/material.dart' as material;
import 'package:rove_editor/editor_assets.dart';
import 'package:rove_editor/model/cards/ability_model.dart';
import 'package:rove_editor/model/tiles/enemy_unit_def.dart';
import 'package:rove_editor/model/tiles/unit_model.dart';
import 'package:rove_data_types/rove_data_types.dart';

class EnemyModel extends UnitModel {
  final EnemyUnitDef enemy;
  final List<AbilityModel> abilities;

  EnemyModel(
      {required this.enemy, required super.coordinate, required super.map})
      : abilities = enemy.abilities
            .map((ability) => AbilityModel(ability: ability))
            .toList(growable: false) {
    maxHealth = enemy.resolveMaxHealth();
    health = maxHealth;
  }

  set minPlayerCount(int number) {
    enemy.minPlayerCount = number;
  }

  @override
  int get minPlayerCount => enemy.minPlayerCount;

  bool get large => enemy.large;

  List<EnemyReactionDef> get reactions => enemy.reactions;

  @override
  String get name =>
      minPlayerCount > 0 ? '${enemy.name} #$minPlayerCount' : enemy.name;

  @override
  String get className => enemy.className;

  @override
  int get defense => enemy.resolveDefense() + super.defense;

  @override
  int get maxHealth => enemy.resolveMaxHealth();

  @override
  Color get color => material.Colors.red.shade800;

  @override
  Color get backgroundColor => const Color.fromARGB(255, 44, 44, 44);

  @override
  Faction get faction => Faction.adversary;

  @override
  bool get isFlying => enemy.isFlying;

  @override
  bool get canEnterObjectSpaces => isFlying || enemy.canEnterObjectSpaces;

  @override
  bool get usesGlyphs => false;

  @override
  Image get image => Assets.campaignImages
      .entityImage(enemy.imageFilename, expansion: enemy.expansion);

  @override
  String? get trapImage => 'trap.png';

  @override
  int affinityForEther(Ether ether) {
    return enemy.affinities[ether] ?? 0;
  }

  @override
  onAttackResolved() {}

  @override
  UnitModel? get owner => this;

  @override
  bool get immuneToForcedMovement => enemy.immuneToForcedMovement;

  bool get immuneToTeleport => enemy.immuneToTeleport;

  @override
  int get reducePushPullBy => enemy.reducePushPullBy;

  @override
  List<EncounterAction> get onSlayed => enemy.onSlayed;

  @override
  List<EncounterAction> get onDidStartRound => enemy.onDidStartRound;

  @override
  List<EncounterAction> get onWillEndRound => enemy.onWillEndRound;

  List<String> get traits {
    List<String> traits = [];
    if (immuneToForcedMovement && enemy.immuneToTeleport) {
      traits.add('Immune to forced movement and teleport.');
    } else if (immuneToForcedMovement) {
      traits.add('Immune to forced movement.');
    } else if (enemy.immuneToTeleport) {
      traits.add('Immune to teleport.');
    }
    if (isFlying) {
      traits.add('Flies.');
    } else if (canEnterObjectSpaces) {
      traits.add('Can enter into spaces with objects.');
    }
    if (reducePushPullBy > 0) {
      traits.add(
          'Reduce all [PUSH] and [PULL] effects targeting this unit by $reducePushPullBy.');
    }
    traits.addAll(enemy.descriptiveTraits);
    return traits;
  }

  /* Large */

  static final List<(int, int)> _cubeVectorsForLarge = [
    (0, 0),
    (-1, 0),
    (0, -1),
    (1, -1)
  ];

  @override
  List<(int, int)> cubeVectorsForCoordinates() {
    return large ? _cubeVectorsForLarge : super.cubeVectorsForCoordinates();
  }

  @override
  PlacementType get placementType => PlacementType.enemy;
}
