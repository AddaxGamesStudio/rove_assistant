import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart' as material;
import 'package:rove_simulator/assets.dart';
import 'package:rove_simulator/model/map_model.dart';
import 'package:rove_simulator/model/persistence/saveable.dart';
import 'package:rove_simulator/model/tiles/ether_node_model.dart';
import 'package:rove_simulator/model/tiles/object_def.dart';
import 'package:rove_simulator/model/tiles/player_unit_model.dart';
import 'package:rove_simulator/model/tiles/tile_model.dart';
import 'package:rove_simulator/model/tiles/unit_model.dart';
import 'package:hex_grid/hex_grid.dart';
import 'package:rove_data_types/rove_data_types.dart';

class ObjectModel extends TileModel with Slayable {
  final ObjectDef definition;
  final MapModel map;
  late int _id;

  ObjectModel(
      {required this.definition,
      required super.coordinate,
      required this.map}) {
    _id = ++TileModel.instanceCount;
    maxHealth = definition.resolveMaxHealth();
    health = maxHealth;
  }

  String get className => definition.className;

  @override
  String get key => 'object.$name.$_id';

  @override
  List<EtherNodeModel> get nearbyEther => coordinates
      .map((c) => map.etherAffectingCoordinate(c))
      .fold(<EtherNodeModel>[], (value, e) => value + e)
      .toSet() // Do not repeat ether nodes
      .toList();

  @override
  List<RoveGlyph> get affectingGlyphs {
    final glyph = map.glyphs[coordinate];
    if (glyph != null && glyph.matches(this)) {
      return [glyph.glyph];
    }
    return [];
  }

  @override
  Color get color => material.Colors.yellow;

  @override
  int get maxHealth => definition.resolveMaxHealth();

  @override
  bool get ignoresDifficultTerrain => false;

  @override
  bool get isImperviousToDangerousTerrain => false;

  @override
  bool get immuneToForcedMovement => true;

  @override
  int get reducePushPullBy => 0;

  @override
  String get name => definition.name;

  @override
  onAttackResolved() {}

  @override
  UnitModel? get owner => null;

  @override
  List<EncounterAction> get onSlayed => definition.onSlayed;

  @override
  List<EncounterAction> get onDidStartRound => definition.onDidStartRound;

  @override
  List<EncounterAction> get onWillEndRound => definition.onWillEndRound;

  Image get image =>
      Assets.campaignImages.entityImage(definition.imageFilename);

  bool canLoot(UnitModel actor) {
    if (!definition.lootable) {
      return false;
    }
    return actor is PlayerUnitModel;
  }

  bool get canBeSlain => maxHealth > 0;

  List<EncounterAction> get onLoot => definition.onLoot;

  RoveCondition? get unlockCondition => definition.unlockCondition;

  /* Saveable */

  static fromSaveData(
      {required SaveData data,
      required MapModel map,
      required CampaignDef campaign}) {
    final className = data.properties['class'] as String;
    final figureDef = campaign.objects[className]!;
    final encounterFigureDef =
        map.encounter.overlays.firstWhere((a) => a.name == className);
    final placement =
        PlacementDef.fromJson(jsonDecode(data.properties['placement']));
    final definition = ObjectDef(
        figureDef: figureDef,
        encounterFigureDef: encounterFigureDef,
        placement: placement);
    final object = ObjectModel(
        definition: definition, coordinate: HexCoordinate.zero(), map: map);
    object.initializeWithSaveData(data);
    return object;
  }

  @override
  setSaveablePropertiesBeforeChildren(Map<String, dynamic> properties) {
    super.setSaveablePropertiesBeforeChildren(properties);
    _id = properties['id'] as int? ?? ++TileModel.instanceCount;
  }

  @override
  Map<String, dynamic> saveableProperties() {
    final properties = super.saveableProperties();
    properties.addAll({
      'id': _id,
      'class': definition.className,
      'placement': jsonEncode(definition.placement.toJson()),
    });
    return properties;
  }

  @override
  String get saveableKey => key;

  @override
  String get saveableType => 'ObjectModel';

  @override
  int get saveablePriority => MapModel.objectSaveablePriority;
}
