import 'dart:ui';

import 'package:rove_simulator/assets.dart';
import 'package:rove_simulator/model/cards/ability_model.dart';
import 'package:rove_simulator/model/map_model.dart';
import 'package:rove_simulator/model/persistence/saveable.dart';
import 'package:rove_simulator/model/tiles/player_unit_model.dart';
import 'package:rove_simulator/model/tiles/unit_model.dart';
import 'package:hex_grid/hex_grid.dart';
import 'package:rove_data_types/rove_data_types.dart';

class SummonModel extends UnitModel {
  final PlayerUnitModel summoner;
  final SummonDef summon;
  final List<AbilityModel> _abilities;

  SummonModel(
      {required this.summoner,
      required this.summon,
      required super.coordinate,
      required super.map})
      : _abilities = [AbilityModel(ability: summon.ability)] {
    health = summon.health;
    maxHealth = summon.health;
  }

  @override
  int affinityForEther(Ether ether) {
    return summoner.affinityForEther(ether);
  }

  @override
  String get className => summon.name;

  @override
  Color get color => summoner.color;

  @override
  Faction get faction => summoner.faction;

  String get imageFilename =>
      'summon_${summon.name.toLowerCase().replaceAll(' ', '_')}.webp';

  @override
  Image get image => Assets.campaignImages.classImage(imageFilename);

  @override
  String? get trapImage => summoner.trapImage;

  @override
  bool get isFlying => false;

  @override
  String get key => 'summon.${summon.name}';

  @override
  String get name => summon.name;

  @override
  UnitModel? get owner => this;

  @override
  bool get ignoresDifficultTerrain =>
      super.ignoresDifficultTerrain || summon.ignoresDifficultTerrain;

  @override
  bool get immuneToForcedMovement => false;

  @override
  int get reducePushPullBy => 0;

  List<AbilityModel> get abilities => _abilities;

  @override
  List<EncounterAction> get onSlayed => const [];

  @override
  List<EncounterAction> get onDidStartRound => const [];

  @override
  List<EncounterAction> get onWillEndRound => const [];

  /* Saveable */

  factory SummonModel.fromSaveData(SaveData data, {required MapModel map}) {
    final summonerKey = data.properties['summoner_key'];
    final summoner = map.findUnitByKey(summonerKey) as PlayerUnitModel;
    final name = data.properties['name'];
    final definition = summoner.summonDefinitionForName(name);
    final summon = SummonModel(
        summoner: summoner,
        summon: definition!,
        coordinate: HexCoordinate.zero(),
        map: map);
    summon.initializeWithSaveData(data);
    summoner.addSummon(summon);
    return summon;
  }

  @override
  Map<String, dynamic> saveableProperties() {
    final properties = super.saveableProperties();
    properties.addAll({
      'name': summon.name,
      'summoner_key': summoner.key,
    });
    return properties;
  }

  @override
  String get saveableKey => key;

  @override
  int get saveablePriority => summoner.saveablePriority + 10;

  @override
  String get saveableType => 'SummonModel';
}
