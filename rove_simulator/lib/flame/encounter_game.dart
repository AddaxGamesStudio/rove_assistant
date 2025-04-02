import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart' hide Route;
import 'package:rove_simulator/controller/codex_controller.dart';
import 'package:rove_simulator/flame/encounter/map/map_component.dart';
import 'package:rove_simulator/flame/encounter/map/map_component_factory.dart';
import 'package:rove_simulator/controller/card_controller.dart';
import 'package:rove_simulator/controller/card_preview_controller.dart';
import 'package:rove_simulator/controller/event_controller.dart';
import 'package:rove_simulator/controller/map_controller.dart';
import 'package:rove_simulator/controller/card_resolver.dart';
import 'package:rove_simulator/controller/reward_controller.dart';
import 'package:rove_simulator/controller/turn_controller.dart';
import 'package:rove_simulator/encounter_asset_loader.dart';
import 'package:rove_simulator/model/cards/ability_model.dart';
import 'package:rove_simulator/model/cards/item_model.dart';
import 'package:rove_simulator/model/cards/reaction_model.dart';
import 'package:rove_simulator/model/tiles/enemy_model.dart';
import 'package:rove_simulator/model/encounter_model.dart';
import 'package:rove_simulator/model/tiles/player_unit_model.dart';
import 'package:rove_simulator/model/map_model.dart';
import 'package:rove_simulator/model/cards/skill_model.dart';
import 'package:rove_simulator/model/tiles/summon_model.dart';
import 'package:rove_simulator/widgets/encounter/encounter_menu.dart';
import 'package:rove_simulator/widgets/encounter/event_log_widget.dart';
import 'package:rove_simulator/widgets/encounter/instruction_widget.dart';
import 'package:rove_simulator/widgets/encounter/progression/failure_dialog.dart';
import 'package:rove_simulator/widgets/encounter/progression/victory_lyst_dialog.dart';
import 'package:rove_simulator/widgets/pages/campaign_page.dart';
import 'package:rove_simulator/widgets/pages/navigator_ext.dart';
import 'package:rove_data_types/rove_data_types.dart';

class EncounterGame extends FlameGame
    with PanDetector, ScaleDetector, ChangeNotifier, KeyboardEvents {
  late double startZoom;
  late MapController controller;
  late CardController cardController;
  late CardPreviewController cardPreviewController;
  late EventController eventController;
  late RewardController rewardController;
  late CodexController codexController;
  late TurnController turnController;
  late MapComponentFactory components;
  late MapComponent map;
  late EncounterModel model;
  CardResolver? get cardResolver => cardController.cardResolver;
  late RouterComponent router;
  final EncounterDef encounter;
  EnemyModel? _selectedEnemy;

  EncounterGame({required this.encounter, required List<Player> players}) {
    model = EncounterModel(encounter: encounter, players: players)
      ..addListener(() {
        notifyListeners();
      });
  }

  MapModel get mapModel => model.map;

  @override
  Future<void> onLoad() async {
    await EncounterAssetLoader(encounter).load();

    controller = MapController(game: this);
    cardController = CardController(game: this);
    cardController.addListener(() {
      notifyListeners();
    });
    cardPreviewController = CardPreviewController(game: this);
    turnController = TurnController(game: this);
    eventController = EventController(game: this);
    rewardController = RewardController(game: this);
    codexController = CodexController(game: this);

    add(router = RouterComponent(
      routes: {
        'main': Route(
          () => Component(),
        ),
      },
      initialRoute: 'main',
    ));

    camera.viewfinder.zoom = 0.6;
    camera.viewfinder.anchor = Anchor.topCenter;

    _initialize();

    turnController.startEncounterSetup();
  }

  @override
  Color backgroundColor() => BasicPalette.transparent.color;

  _reset() {
    _removePlayerOverlays();
    _removeSelectedEnemyOverlay();
    _selectedEnemy = null;
    world.removeAll(world.children);
    cardPreviewController.restart();
    controller.restart();
    cardController.restart();
    turnController.restart();
    eventController.restart();
    rewardController.restart();
  }

  _initialize() {
    components = MapComponentFactory(model: mapModel, game: this);
    map = MapComponent(model: mapModel, components: components)
      ..position = Vector2(0, 0);
    world.add(map);
    final worldSize = Vector2(map.width + map.x, map.height + map.y);
    camera.viewfinder.position = Vector2(worldSize.x / 2, -200);
  }

  void fail() {
    model.setFailed();
    overlays.add(FailureDialog.overlayName);
  }

  void win() {
    model.setVictory();
    overlays.remove(EventLogWidget.overlayName);
    overlays.remove(InstructionWidget.overlayName);
    showDialog(
        VictoryLystDialog.overlayName, (game) => VictoryLystDialog(game: game));
  }

  void quit(BuildContext context) {
    NavigatorExt.pushReplacementPage(context, CampaignPage());
  }

  restart() {
    _reset();
    model.restart();
    _initialize();
    turnController.startEncounterSetup();
  }

  restartRound() {
    final data = model.startOfRoundData;
    if (data == null) {
      return;
    }
    _reset();
    model.restartWithSaveData(data);
    _initialize();
    turnController.resumeFromModel();
  }

  restartTurn() {
    final data = model.startOfTurnData;
    if (data == null) {
      return;
    }
    _reset();
    model.restartWithSaveData(data);
    _initialize();
    turnController.resumeFromModel();
  }

  /* Cards */

  onSelectedAbility(
      {required PlayerUnitModel player,
      SummonModel? summon,
      required AbilityModel ability}) {
    cardPreviewController.hidePreview();
    cardController.onSelectedAbility(
        player: player, summon: summon, ability: ability);
  }

  onSelectedSkill(
      {required PlayerUnitModel player, required SkillModel skill}) {
    cardPreviewController.hidePreview();
    cardController.onSelectedSkill(player: player, skill: skill);
  }

  onSelectedReaction(
      {required PlayerUnitModel player, required ReactionModel reaction}) {
    cardPreviewController.hidePreview();
    cardController.onSelectedReaction(player: player, reaction: reaction);
  }

  void onSelectedItem(
      {required PlayerUnitModel player, required ItemModel item}) {
    cardPreviewController.hidePreview();
    cardController.onSelectedItem(player: player, item: item);
  }

  _removePlayerOverlays({PlayerUnitModel? except}) {
    for (PlayerUnitModel player in model.players) {
      if (player == except) {
        continue;
      }
      overlays.remove(player.boardOverlayName);
    }
  }

  _removeSelectedEnemyOverlay() {
    if (_selectedEnemy != null) {
      overlays.remove(_selectedEnemy!.key);
    }
  }

  void onSelectedEnemy(EnemyModel enemy) {
    _removeSelectedEnemyOverlay();
    _removePlayerOverlays();
    _selectedEnemy = enemy;
    overlays.add(enemy.key);
  }

  void onSelectedPlayer(PlayerUnitModel player) {
    if (!cardController.canSelectPlayer(player)) {
      return;
    }
    turnController.onSelectedPlayer(player);

    _removeSelectedEnemyOverlay();
    _removePlayerOverlays(except: player);
    overlays.add(player.boardOverlayName);
  }

  startTurnOfPlayer(PlayerUnitModel player) {
    turnController.startTurnForUnit(player);
  }

  endTurnOfPlayer(PlayerUnitModel player) {
    assert(model.currentTurnUnit == player);
    overlays.remove(player.boardOverlayName);
    turnController.endTurnForUnit(player);
  }

  /* Pan Detector */

  @override
  void onPanUpdate(DragUpdateInfo info) {
    camera.viewfinder.position = camera.viewfinder.position
      ..translate(-info.delta.global.x, -info.delta.global.y);
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

  /* Keyboard Events */

  @override
  KeyEventResult onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    if (cardResolver?.onKeyEvent(event, keysPressed) == true) {
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  /* UI */

  String get instruction => cardController.instruction ?? model.instruction;

  void showMenu() {
    overlays.add(EncounterMenu.overlayName);
  }

  String? _dialogOverlayName;

  void showDialog(String dialogName, Widget Function(EncounterGame) builder) {
    overlays.addEntry(
        dialogName,
        (context, game) =>
            Positioned.fill(child: builder(game as EncounterGame)));
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
