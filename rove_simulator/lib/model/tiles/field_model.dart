import 'dart:ui';

import 'package:rove_simulator/model/map_model.dart';
import 'package:rove_simulator/model/persistence/saveable.dart';
import 'package:rove_simulator/model/tiles/glyph_model.dart';
import 'package:rove_simulator/model/tiles/player_unit_model.dart';
import 'package:rove_simulator/model/tiles/tile_model.dart';
import 'package:rove_simulator/model/tiles/unit_model.dart';
import 'package:hex_grid/hex_grid.dart';
import 'package:rove_data_types/rove_data_types.dart';

class FieldModel extends TileModel {
  late final EtherField field;
  final UnitModel creator;
  late int _id;

  FieldModel(
      {required this.field, required this.creator, required super.coordinate})
      : _id = ++TileModel.instanceCount;

  @override
  String get key => 'field.${field.name}.$_id';

  RoveBuff? _buffForClass(RoverClass roverClass) {
    switch (field) {
      case EtherField.aura:
        return roverClass.auraEffect.buff;
      case EtherField.miasma:
        return roverClass.miasmaEffect.buff;
      default:
        return null;
    }
  }

  RoveAction? _actionForClass(RoverClass roverClass) {
    switch (field) {
      case EtherField.aura:
        return roverClass.auraEffect.action;
      case EtherField.miasma:
        return roverClass.miasmaEffect.action;
      default:
        return null;
    }
  }

  RoveBuff? get buff {
    RoveBuff? buff;
    if (creator is PlayerUnitModel) {
      final player = creator as PlayerUnitModel;
      final roverClass = player.roverClass;
      buff = _buffForClass(roverClass);
    }
    return buff ?? field.buff;
  }

  RoveAction? get action {
    if (creator is! PlayerUnitModel) {
      return null;
    }
    final player = creator as PlayerUnitModel;
    final roverClass = player.roverClass;
    return _actionForClass(roverClass);
  }

  int startTurnDamageForUnit(UnitModel unit) {
    switch (field) {
      case EtherField.wildfire:
        return 1;
      default:
        return 0;
    }
  }

  int endTurnHealForUnit(UnitModel unit) {
    switch (field) {
      case EtherField.everbloom:
        return 1;
      default:
        return 0;
    }
  }

  int moveEffortToExitSpaceForActor(dynamic actor) {
    switch (field) {
      case EtherField.snapfrost:
        return (actor is GlyphModel) ? 0 : 2;
      default:
        return 0;
    }
  }

  int moveEffortToEnterSpaceForActor(dynamic actor) {
    switch (field) {
      case EtherField.snapfrost:
        return (actor is GlyphModel) ? 0 : 2;
      default:
        return 0;
    }
  }

  @override
  Color get color => creator.color;

  @override
  bool get isImperviousToDangerousTerrain => true;
  @override
  bool get ignoresDifficultTerrain => true;
  @override
  bool get immuneToForcedMovement => true;

  @override
  String get name => field.label;

  @override
  bool get isSlain => false;

  @override
  UnitModel? get owner => creator;

  /* Saveable */

  FieldModel._saveData({required SaveData data, required this.creator})
      : super(coordinate: HexCoordinate.zero()) {
    initializeWithSaveData(data);
  }

  factory FieldModel.fromSaveData(SaveData data, {required MapModel map}) {
    final creator = map.findUnitByKey(data.properties['creator_key']!)!;
    return FieldModel._saveData(data: data, creator: creator);
  }

  @override
  String get saveableKey => key;

  @override
  String get saveableType => 'FieldModel';

  @override
  int get saveablePriority => creator.saveablePriority + 10;

  @override
  setSaveablePropertiesBeforeChildren(Map<String, dynamic> properties) {
    super.setSaveablePropertiesBeforeChildren(properties);
    _id = properties['id'] as int? ?? ++TileModel.instanceCount;
    field = EtherField.fromName(properties['field'] as String);
  }

  @override
  Map<String, dynamic> saveableProperties() {
    final properties = super.saveableProperties();
    properties.addAll({
      'id': _id,
      'field': field.name,
      'creator_key': creator.key,
    });
    return properties;
  }
}
