import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart' as material;
import 'package:rove_simulator/assets.dart';
import 'package:rove_simulator/model/cards/ability_model.dart';
import 'package:rove_simulator/model/map_model.dart';
import 'package:rove_simulator/model/persistence/saveable.dart';
import 'package:rove_simulator/model/tiles/enemy_unit_def.dart';
import 'package:rove_simulator/model/tiles/unit_model.dart';
import 'package:hex_grid/hex_grid.dart';
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

  int get number => enemy.number;

  bool get large => enemy.large;

  List<EnemyReactionDef> get reactions => enemy.reactions;

  @override
  String get name => number > 0 ? '${enemy.name} #$number' : enemy.name;

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
  String get key => 'adversary.${enemy.className}.${enemy.number}';

  @override
  Faction get faction => Faction.adversary;

  @override
  bool get isFlying => enemy.isFlying;

  @override
  bool get canEnterObjectSpaces => isFlying || enemy.canEnterObjectSpaces;

  @override
  bool get usesGlyphs => false;

  @override
  Image get image => Assets.campaignImages.entityImage(enemy.imageFilename);

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
    if (immuneToForcedMovement) {
      traits.add('Immune to forced movement.');
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

  /* Saveable */

  static fromSaveData(
      {required SaveData data,
      required MapModel map,
      required CampaignDef campaign}) {
    final className = data.properties['class'] as String;
    final figureDef = campaign.adversaries[className]!;
    final encounterFigureDef =
        map.encounter.adversaries.firstWhere((a) => a.name == className);
    final placement =
        PlacementDef.fromJson(jsonDecode(data.properties['placement']));
    final number = data.properties['number'] as int;
    final definition = EnemyUnitDef(
        number: number,
        figureDef: figureDef,
        encounterFigureDef: encounterFigureDef,
        placement: placement);
    final enemy = EnemyModel(
        enemy: definition, coordinate: HexCoordinate.zero(), map: map);
    enemy.initializeWithSaveData(data);
    return enemy;
  }

  @override
  Map<String, dynamic> saveableProperties() {
    final properties = super.saveableProperties();
    properties.addAll({
      'number': enemy.number,
      'class': enemy.className,
      'placement': jsonEncode(enemy.placement.toJson()),
    });
    return properties;
  }

  @override
  String get saveableKey => key;

  @override
  String get saveableType => 'EnemyModel';
}
