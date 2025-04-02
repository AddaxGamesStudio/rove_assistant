import 'package:flutter/material.dart';
import 'package:rove_data_types/rove_data_types.dart';
import 'package:rove_editor/data/encounter_def_ext.dart';
import 'package:rove_editor/flame/map_editor.dart';
import 'package:rove_editor/model/editable_encounter_model.dart';

class EditorController extends ChangeNotifier {
  late EncounterDef _encounter;
  late EditableEncounterModel _model;
  late MapEditor _mapEditor;
  List<MapEditor> _placementGroupEditors = [];

  EditorController._privateConstructor() {
    encounter = EncounterData.newEncounter();
  }

  static final EditorController _instance =
      EditorController._privateConstructor();

  static EditorController get instance => _instance;

  EncounterDef get encounter => _encounter;
  EditableEncounterModel get model => _model;
  MapEditor get mapEditor => _mapEditor;
  List<MapEditor> get placementGroupEditors => _placementGroupEditors;

  set encounter(EncounterDef value) {
    _encounter = value;
    _model = EditableEncounterModel(encounter: _encounter);
    _model.addListener(() {
      notifyListeners();
    });
    _mapEditor = MapEditor(model: model.map);
    _placementGroupEditors =
        model.placementGroups.map((g) => MapEditor(model: g)).toList();
    notifyListeners();
  }

  /* Placement Groups */

  addPlacementGroup(String name, {required bool replacesMap}) {
    final mapModel = _model.addPlacementGroup(name, replacesMap: replacesMap);
    _placementGroupEditors.add(MapEditor(model: mapModel));
    notifyListeners();
  }

  int _selectedPlacementGroupIndex = 0;

  MapEditor get selectedPlacementGroupEditor =>
      _selectedPlacementGroupIndex == 0
          ? _mapEditor
          : _placementGroupEditors[_selectedPlacementGroupIndex - 1];

  set selectedPlacementGroupIndex(int selectedPlacementGroupIndex) {
    _selectedPlacementGroupIndex = selectedPlacementGroupIndex;
    notifyListeners();
  }

  /* Tools */

  bool get isSelect {
    return _toolTerrain == null &&
        _toolAdversary == null &&
        _toolObject == null &&
        _toolSpawnPoint == null &&
        _toolEther == null &&
        _toolTrap == null &&
        _toolFeature == null &&
        !_toolClear;
  }

  TerrainType? _toolTerrain;
  FigureDef? _toolAdversary;
  FigureDef? _toolObject;
  Ether? _toolSpawnPoint;
  Ether? _toolEther;
  EtherField? _toolField;
  String? _toolTrap;
  bool _toolClear = false;
  String? _toolFeature;

  void clearTools() {
    _toolClear = false;
    _toolTerrain = null;
    _toolAdversary = null;
    _toolObject = null;
    _toolSpawnPoint = null;
    _toolEther = null;
    _toolField = null;
    _toolFeature = null;
    _toolTrap = null;
    notifyListeners();
  }

  bool get toolClear => _toolClear;
  set toolClear(bool value) {
    clearTools();
    _toolClear = value;
    notifyListeners();
  }

  String? get toolFeature => _toolFeature;
  set toolFeature(String? value) {
    if (_toolFeature == value) {
      _toolFeature = null;
    } else {
      clearTools();
      _toolFeature = value;
    }
    notifyListeners();
  }

  TerrainType? get toolTerrain => _toolTerrain;
  set toolTerrain(TerrainType? value) {
    if (_toolTerrain == value) {
      _toolTerrain = null;
    } else {
      clearTools();
      _toolTerrain = value;
    }
    notifyListeners();
  }

  FigureDef? get toolAdversary => _toolAdversary;
  set toolAdversary(FigureDef? value) {
    if (_toolAdversary?.name == value?.name) {
      _toolAdversary = null;
    } else {
      clearTools();
      _toolAdversary = value;
    }
    notifyListeners();
  }

  FigureDef? get toolObject => _toolObject;
  set toolObject(FigureDef? value) {
    if (_toolObject?.name == value?.name) {
      _toolObject = null;
    } else {
      clearTools();
      _toolObject = value;
    }
    notifyListeners();
  }

  Ether? get toolSpawnPoint => _toolSpawnPoint;
  set toolSpawnPoint(Ether? value) {
    if (_toolSpawnPoint == value) {
      _toolSpawnPoint = null;
    } else {
      clearTools();
      _toolSpawnPoint = value;
    }
    notifyListeners();
  }

  Ether? get toolEther => _toolEther;
  set toolEther(Ether? value) {
    if (_toolEther == value) {
      _toolEther = null;
    } else {
      clearTools();
      _toolEther = value;
    }
    notifyListeners();
  }

  EtherField? get toolField => _toolField;
  set toolField(EtherField? value) {
    if (_toolField == value) {
      _toolField = null;
    } else {
      clearTools();
      _toolField = value;
    }
    notifyListeners();
  }

  String? get toolTrap => _toolTrap;

  set toolTrap(String? value) {
    if (_toolTrap == value) {
      _toolTrap = null;
    } else {
      clearTools();
      _toolTrap = value;
    }
    notifyListeners();
  }
}
