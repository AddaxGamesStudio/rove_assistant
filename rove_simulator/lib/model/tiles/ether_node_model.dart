import 'dart:ui';

import 'package:rove_simulator/model/persistence/saveable.dart';
import 'package:rove_simulator/model/tiles/tile_model.dart';
import 'package:rove_simulator/model/tiles/unit_model.dart';
import 'package:hex_grid/hex_grid.dart';
import 'package:rove_data_types/rove_data_types.dart';

class EtherNodeModel extends TileModel {
  late final Ether ether;
  late final int _id;

  EtherNodeModel({required this.ether, required super.coordinate}) {
    _id = ++TileModel.instanceCount;
  }

  @override
  String get key => 'ether.${ether.name}.$_id';

  int endTurnDamageForUnit(UnitModel unit) {
    switch (ether) {
      case Ether.fire:
        return 1;
      default:
        return 0;
    }
  }

  int endTurnHealForUnit(UnitModel unit) {
    switch (ether) {
      case Ether.earth:
        return 1;
      default:
        return 0;
    }
  }

  @override
  Color get color => ether.color;

  @override
  bool get isImperviousToDangerousTerrain => true;
  @override
  bool get ignoresDifficultTerrain => true;
  @override
  bool get immuneToForcedMovement => true;

  @override
  String get name => '${ether.label} Node';

  @override
  bool get isSlain => false;

  @override
  UnitModel? get owner => null;

  /* Saveable */

  EtherNodeModel.fromSaveData({required SaveData data})
      : super(coordinate: HexCoordinate.zero()) {
    initializeWithSaveData(data);
  }

  @override
  String get saveableKey => key;

  @override
  String get saveableType => 'EtherNodeModel';

  @override
  setSaveablePropertiesBeforeChildren(Map<String, dynamic> properties) {
    super.setSaveablePropertiesBeforeChildren(properties);
    _id = properties['id'] as int? ?? ++TileModel.instanceCount;
    ether = Ether.fromName(properties['ether'] as String);
  }

  @override
  Map<String, dynamic> saveableProperties() {
    final properties = super.saveableProperties();
    properties.addAll({
      'id': _id,
      'ether': ether.name,
    });
    return properties;
  }
}
