import 'package:collection/collection.dart';
import 'package:flame/palette.dart';
import 'package:rove_editor/model/tiles/tile_model.dart';
import 'package:rove_editor/model/tiles/unit_model.dart';
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
  String get name => _name ?? 'Trap';

  @override
  bool get isSlain => false;

  @override
  UnitModel? get owner => creator;

  PlacementDef toPlacement() {
    final evenQ = coordinate.toEvenQ();
    return PlacementDef(
      name: name,
      type: PlacementType.trap,
      trapDamage: damage,
      c: evenQ.q,
      r: evenQ.r,
    );
  }
}
