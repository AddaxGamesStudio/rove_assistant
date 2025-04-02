import 'package:collection/collection.dart';
import 'package:flame/palette.dart';
import 'package:rove_simulator/model/map_model.dart';
import 'package:rove_simulator/model/persistence/saveable.dart';
import 'package:rove_simulator/model/tiles/tile_model.dart';
import 'package:rove_simulator/model/tiles/unit_model.dart';
import 'package:hex_grid/hex_grid.dart';
import 'package:rove_data_types/rove_data_types.dart';

class TrapModel extends TileModel {
  late String? _name;
  late int damage;
  late UnitModel? creator;
  late String? _image;
  late int _id;

  TrapModel(
      {required this.damage,
      String? name,
      this.creator,
      String? image,
      required super.coordinate})
      : _id = ++TileModel.instanceCount,
        _name = name,
        _image = image;

  factory TrapModel.fromPlacement(PlacementDef placement,
      {required HexCoordinate coordinate}) {
    assert(placement.trapDamage > 0);
    late String image;
    final knownTrap =
        TrapType.values.firstWhereOrNull((t) => t.label == placement.name);
    if (knownTrap != null) {
      image = 'trap_${knownTrap.toJson()}.png';
    } else {
      image = 'trap.png';
    }
    return TrapModel(
        damage: placement.trapDamage,
        name: placement.name,
        image: image,
        coordinate: coordinate);
  }

  @override
  String get key => 'trap.$_id';

  String get image => _image ?? creator?.trapImage ?? 'trap.png';

  @override
  Color get color => creator?.color ?? BasicPalette.yellow.color;

  @override
  bool get isImperviousToDangerousTerrain => true;
  @override
  bool get ignoresDifficultTerrain => true;
  @override
  bool get immuneToForcedMovement => true;

  @override
  String get name => '${_name ?? 'Trap'} ($damage)';

  @override
  bool get isSlain => false;

  @override
  UnitModel? get owner => creator;

  /* Saveable */

  TrapModel._saveData({required SaveData data, this.creator})
      : super(coordinate: HexCoordinate.zero()) {
    initializeWithSaveData(data);
  }

  factory TrapModel.fromSaveData(SaveData data, {required MapModel map}) {
    final creatorKey = data.properties['creator_key'];
    final creator = creatorKey != null ? map.findUnitByKey(creatorKey) : null;
    return TrapModel._saveData(data: data, creator: creator);
  }

  @override
  setSaveablePropertiesBeforeChildren(Map<String, dynamic> properties) {
    super.setSaveablePropertiesBeforeChildren(properties);
    _id = properties['id'] as int? ?? ++TileModel.instanceCount;
    _name = properties['name'] as String?;
    damage = properties['damage'] as int? ?? 0;
    _image = properties['image'] as String?;
  }

  @override
  Map<String, dynamic> saveableProperties() {
    final properties = super.saveableProperties();
    properties.addAll({
      'id': _id,
      'name': _name,
      'damage': damage,
      'creator_key': creator?.key,
      'image': _image,
    });
    return properties;
  }

  @override
  String get saveableKey => key;

  @override
  int get saveablePriority =>
      creator != null ? creator!.saveablePriority + 10 : 0;

  @override
  String get saveableType => 'TrapModel';
}
