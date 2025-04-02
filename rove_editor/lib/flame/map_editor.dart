import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flutter/widgets.dart' hide Route;
import 'package:rove_editor/flame/encounter/map/map_component.dart';
import 'package:rove_editor/flame/encounter/map/map_component_factory.dart';
import 'package:rove_editor/encounter_asset_loader.dart';
import 'package:rove_editor/model/editable_map_model.dart';

class MapEditor extends FlameGame with ScaleDetector, ChangeNotifier {
  late double startZoom;
  late MapComponentFactory components;
  late MapComponent map;
  final EditableMapModel model;
  late RouterComponent router;

  MapEditor({required this.model}) {
    model.addListener(() {
      notifyListeners();
    });
    components = MapComponentFactory(model: model, game: this);
    map = MapComponent(model: model, components: components)
      ..position = Vector2(0, 0);
  }

  @override
  Future<void> onLoad() async {
    await EncounterAssetLoader(model.encounter.encounter).load();
    camera.viewfinder.zoom = 0.6;
    camera.viewfinder.anchor = Anchor.topCenter;

    _initialize();
  }

  @override
  Color backgroundColor() => BasicPalette.transparent.color;

  _initialize() {
    world.add(map);
    final worldSize = Vector2(map.width + map.x, map.height + map.y);
    camera.viewfinder.visibleGameSize = Vector2(worldSize.x, 0);
    camera.viewfinder.anchor = Anchor.topLeft;
  }

  /* Scale Detector */
  @override
  void onScaleStart(ScaleStartInfo info) {
    startZoom = camera.viewfinder.zoom;
  }

  void _clampZoom() {
    camera.viewfinder.zoom = camera.viewfinder.zoom.clamp(0.05, 3.0);
  }

  @override
  void onScaleUpdate(ScaleUpdateInfo info) {
    final currentScale = info.scale.global;
    if (!currentScale.isIdentity()) {
      camera.viewfinder.zoom = startZoom * currentScale.y;
      _clampZoom();
    } else {
      final delta = info.delta.global;
      camera.viewfinder.position.translate(-delta.x, -delta.y);
    }
  }

  String? _dialogOverlayName;

  void showDialog(String dialogName, Widget Function(MapEditor) builder) {
    overlays.addEntry(dialogName,
        (context, game) => Positioned.fill(child: builder(game as MapEditor)));
    overlays.add(dialogName);
    _dialogOverlayName = dialogName;
  }

  void dismissDialog() {
    if (_dialogOverlayName case final overlayName?) {
      overlays.remove(overlayName);
      _dialogOverlayName = null;
    }
  }
}
