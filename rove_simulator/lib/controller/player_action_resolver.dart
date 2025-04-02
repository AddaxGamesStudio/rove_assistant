import 'dart:async';
import 'dart:ui';
import 'package:rove_simulator/controller/base_controller.dart';
import 'package:rove_simulator/controller/player_actions/attack_resolver.dart';
import 'package:rove_simulator/controller/player_actions/buff_resolver.dart';
import 'package:rove_simulator/controller/card_resolver.dart';
import 'package:rove_simulator/controller/player_actions/create_glyph_resolver.dart';
import 'package:rove_simulator/controller/player_actions/create_trap_resolver.dart';
import 'package:rove_simulator/controller/player_actions/flip_card_resolver.dart';
import 'package:rove_simulator/controller/player_actions/force_attack_resolver.dart';
import 'package:rove_simulator/controller/player_actions/generate_ether_resolver.dart';
import 'package:rove_simulator/controller/player_actions/heal_resolver.dart';
import 'package:rove_simulator/controller/player_actions/infuse_ether_resolver.dart';
import 'package:rove_simulator/controller/player_actions/move_resolver.dart';
import 'package:rove_simulator/controller/player_actions/place_field_resolver.dart';
import 'package:rove_simulator/controller/player_actions/push_pull_resolver.dart';
import 'package:rove_simulator/controller/player_actions/remove_ether_resolver.dart';
import 'package:rove_simulator/controller/player_actions/reroll_ether_resolver.dart';
import 'package:rove_simulator/controller/player_actions/revive_resolver.dart';
import 'package:rove_simulator/controller/player_actions/suffer_resolver.dart';
import 'package:rove_simulator/controller/player_actions/summon_resolver.dart';
import 'package:rove_simulator/controller/player_actions/swap_space_resolver.dart';
import 'package:rove_simulator/controller/player_actions/teleport_resolver.dart';
import 'package:rove_simulator/controller/player_actions/trade_ether_resolver.dart';
import 'package:rove_simulator/controller/player_actions/trigger_fields_resolver.dart';
import 'package:rove_simulator/model/tiles/player_unit_model.dart';
import 'package:rove_simulator/model/tiles/tile_model.dart';
import 'package:rove_simulator/model/tiles/unit_model.dart';
import 'package:hex_grid/hex_grid.dart';
import 'package:rove_data_types/rove_data_types.dart';

abstract class PlayerActionResolver extends BaseController
    implements CoordinateSelector {
  final CardResolver cardResolver;
  RoveAction action;
  final TileModel? _actor;
  final TileModel? target;
  final Completer<bool> _completer = Completer();
  List<HexCoordinate> path = [];
  bool modifiedGameState = false;
  final HexCoordinate? selectedRangeOrigin;

  PlayerActionResolver(
      {required this.cardResolver,
      TileModel? actor,
      required this.action,
      this.target,
      this.selectedRangeOrigin})
      : _actor = selectedRangeOrigin != null && actor != null
            ? _ActorProjection(actor: actor, coordinate: selectedRangeOrigin)
            : actor,
        super(game: cardResolver.game) {
    assert(this.actor.owner != null, 'Actor must have an owner');
  }

  Future<bool> resolve() async {
    return _completer.future;
  }

  void didSkip() {
    _completer.complete(false);
  }

  void didResolve() {
    _completer.complete(true);
  }

  factory PlayerActionResolver.fromAction(
      {required CardResolver cardResolver,
      TileModel? actor,
      required RoveAction action,
      TileModel? target,
      HexCoordinate? selectedCoordinate,
      HexCoordinate? selectedRangeOrigin}) {
    switch (action.type) {
      case RoveActionType.attack:
        return AttackResolver(
            actor: actor,
            cardResolver: cardResolver,
            action: action,
            slayable: target as Slayable? ?? cardResolver.player,
            selectedCoordinate: selectedCoordinate,
            selectedRangeOrigin: selectedRangeOrigin);
      case RoveActionType.buff:
        return BuffResolver(
            cardResolver: cardResolver,
            action: action,
            unitTarget: (target ?? cardResolver.player) as UnitModel);
      case RoveActionType.createGlyph:
        return CreateGlyphResolver(cardResolver: cardResolver, action: action);
      case RoveActionType.createTrap:
        return CreateTrapResolver(cardResolver: cardResolver, action: action);
      case RoveActionType.flipCard:
        return FlipCardResolver(cardResolver: cardResolver, action: action);
      case RoveActionType.forceAttack:
        return ForceAttackResolver(
            cardResolver: cardResolver,
            action: action,
            forcedActor: target as UnitModel);
      case RoveActionType.forceMove:
        return MoveResolver(
            cardResolver: cardResolver, action: action, target: target!);
      case RoveActionType.generateEther:
        return GenerateEtherResolver(
            cardResolver: cardResolver, action: action);
      case RoveActionType.infuseEther:
        return InfuseEtherResolver(cardResolver: cardResolver, action: action);
      case RoveActionType.heal:
        return HealResolver(
            cardResolver: cardResolver,
            action: action,
            unitTarget: target as UnitModel? ?? cardResolver.player);
      case RoveActionType.jump:
        return MoveResolver(
            cardResolver: cardResolver,
            action: action,
            target: target ?? actor ?? cardResolver.player);
      case RoveActionType.move:
        return MoveResolver(
            cardResolver: cardResolver,
            action: action,
            target: target ?? actor ?? cardResolver.player);
      case RoveActionType.placeField:
        return PlaceFieldResolver(
            actor: actor,
            cardResolver: cardResolver,
            action: action,
            target: target);
      case RoveActionType.pull:
        return PushPullResolver(
            actor: actor,
            cardResolver: cardResolver,
            action: action,
            unitTarget: target as UnitModel? ?? cardResolver.player,
            selectedRangeOrigin: selectedRangeOrigin);
      case RoveActionType.push:
        return PushPullResolver(
            actor: actor,
            cardResolver: cardResolver,
            action: action,
            unitTarget: target as UnitModel? ?? cardResolver.player,
            selectedRangeOrigin: selectedRangeOrigin);
      case RoveActionType.removeEther:
        return RemoveEtherResolver(cardResolver: cardResolver, action: action);
      case RoveActionType.rerollEther:
        return RerollEtherResolver(cardResolver: cardResolver, action: action);
      case RoveActionType.revive:
        return ReviveResolver(
            cardResolver: cardResolver,
            action: action,
            unitTarget: target as UnitModel);
      case RoveActionType.suffer:
        return SufferResolver(
            cardResolver: cardResolver,
            action: action,
            slayable: target as Slayable);
      case RoveActionType.summon:
        return SummonResolver(cardResolver: cardResolver, action: action);
      case RoveActionType.swapSpace:
        return SwapSpaceResolver(
            cardResolver: cardResolver, action: action, swapToTarget: target!);
      case RoveActionType.teleport:
        return TeleportResolver(cardResolver: cardResolver, action: action);
      case RoveActionType.trade:
        return TradeEtherResolver(
            cardResolver: cardResolver,
            action: action,
            playerTarget: target as PlayerUnitModel);
      case RoveActionType.triggerFields:
        return TriggerFieldsResolver(
            cardResolver: cardResolver, action: action);
      default:
        throw UnimplementedError();
    }
  }

  TileModel get actor => _actor ?? cardResolver.player;
  PlayerUnitModel get player => cardResolver.player;
  HexCoordinate get actorCoordinate => actor.coordinate;
  HexCoordinate get targetCoordinate => target!.coordinate;
  HexCoordinate? get targetingCoordinate => target?.coordinate;
  int get resolvedAmount => (actor is UnitModel)
      ? (actor as UnitModel).resolveAmountForAction(action)
      : action.amount;

  bool get resolvesWithoutUserInput => false;

  String get instruction => '';

  bool get isSkippable => false;

  skip() {
    if (isSkippable) {
      didSkip();
    }
  }

  @override
  bool isSelectableAtCoordinate(HexCoordinate coordinate) {
    return false;
  }

  @override
  bool onHoveredCoordinate(HexCoordinate coordinate) {
    return false;
  }

  @override
  bool onSelectedCoordinate(HexCoordinate coordinate) {
    return false;
  }

  @override
  bool isPartOfPath(HexCoordinate coordinate) {
    return path.contains(coordinate);
  }

  @override
  bool isInAreaOfEffect(HexCoordinate coordinate) {
    return false;
  }

  @override
  String debugStringForCoordinate(HexCoordinate coordinate) {
    return '';
  }

  /* Convenience methods */

  isInRangeForCoordinate(HexCoordinate coordinate,
      {required bool needsLineOfSight}) {
    List<HexCoordinate> origins = [];
    switch (action.rangeOrigin) {
      case RoveActionRangeOrigin.actorOrGlyph:
        origins.add(actorCoordinate);
        origins.addAll(mapModel.glyphs.values
            .where((g) => g.creator == actor)
            .map((g) => g.coordinate));
      case RoveActionRangeOrigin.aerios:
      case RoveActionRangeOrigin.armoroll:
        final coordinate = mapModel.glyphs.entries
            .where((e) => e.value.glyph == action.rangeOrigin.glyph)
            .firstOrNull
            ?.key;
        if (coordinate != null) {
          origins.add(coordinate);
        }
      case RoveActionRangeOrigin.actor:
        origins.add(actorCoordinate);
        break;
      case RoveActionRangeOrigin.previousTarget:
        origins.add(cardResolver.previousTargetCoordinate!);
        break;
      case RoveActionRangeOrigin.range4:
        assert(selectedRangeOrigin != null);
        origins.addAll([if (selectedRangeOrigin case final value?) value]);
        break;
      case RoveActionRangeOrigin.selection:
        // TODO:
        throw UnimplementedError();
    }
    return origins.any((origin) {
      final range = action.range;
      final distance = mapModel.distance(origin, coordinate);
      return range.$1 <= distance &&
          distance <= range.$2 &&
          (needsLineOfSight
              ? mapModel.hasLineOfSight(coordinate, origin)
              : true);
    });
  }
}

class _ActorProjection extends TileModel {
  final TileModel actor;

  _ActorProjection({required this.actor, required super.coordinate});

  @override
  Color get color => actor.color;

  @override
  bool get ignoresDifficultTerrain => actor.ignoresDifficultTerrain;

  @override
  bool get immuneToForcedMovement => actor.immuneToForcedMovement;

  @override
  bool get isImperviousToDangerousTerrain =>
      actor.isImperviousToDangerousTerrain;

  @override
  bool get isSlain => actor.isSlain;

  @override
  String get key => 'projection.${actor.key}';

  @override
  String get name => actor.name;

  @override
  UnitModel? get owner => actor.owner;

  @override
  String get saveableKey => throw UnimplementedError();

  @override
  String get saveableType => throw UnimplementedError();
}
