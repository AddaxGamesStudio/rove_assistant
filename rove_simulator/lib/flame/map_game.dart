import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:rove_app_common/data/campaign_loader.dart';
import 'package:rove_simulator/flame/map/encounter_map_indicator_component.dart';
import 'package:rove_data_types/rove_data_types.dart';

class MapGame extends FlameGame {
  late SpriteComponent backgroundComponent;
  final CampaignDef _campaign;
  EncounterMapIndicatorComponent? _focusedEncounterComponent;

  MapGame() : _campaign = CampaignLoader.instance.campaign;

  @override
  Future<void> onLoad() async {
    final sprite = Sprite(await Flame.images.load('world.jpeg'));

    world.add(
      backgroundComponent = SpriteComponent(
        sprite: sprite,
        size: Vector2(sprite.originalSize.x, sprite.originalSize.y),
      ),
    );

    final worldSize = sprite.originalSize;
    camera.viewfinder.visibleGameSize = Vector2(worldSize.x, 0);
    camera.viewfinder.anchor = Anchor.topLeft;

    final viewportSizeInWorld = camera.viewport.size / camera.viewfinder.zoom;
    camera.moveTo(
        Vector2(0, backgroundComponent.size.y - viewportSizeInWorld.y),
        speed: 10);

    _addIndicators(worldSize);
  }

  _addIndicators(Vector2 mapSize) {
    for (final quest in _campaign.quests) {
      for (final entry in quest.relativeCoordinates.entries) {
        final indicator =
            EncounterMapIndicatorComponent(encounterId: entry.key);
        final relativeCoordinate = entry.value;
        indicator.center = Vector2(mapSize.x * relativeCoordinate.$1,
            mapSize.y * relativeCoordinate.$2);
        world.add(indicator);
      }
    }
  }

  void onFocusedEncounterWithId(String encounterId) {
    final indicator = findByKey<EncounterMapIndicatorComponent>(
        ComponentKey.named(encounterId));
    if (indicator == null) {
      return;
    }
    _focusedEncounterComponent = indicator;
    indicator.focused = true;
    final viewportSizeInWorld = camera.viewport.size / camera.viewfinder.zoom;
    final maxY = backgroundComponent.size.y - viewportSizeInWorld.y;
    final encounterY = indicator.position.y - (viewportSizeInWorld.y / 2);
    final destinationY = min(encounterY, maxY);
    final viewFinderY = camera.viewfinder.position.y;
    final yDistance = (destinationY - viewFinderY).abs();
    final quarterWindowY = viewportSizeInWorld.y / 4;
    if (yDistance > quarterWindowY) {
      camera.stop();
      camera.viewfinder.add(MoveToEffect(Vector2(0, destinationY),
          EffectController(duration: 0.5, curve: Curves.easeOut)));
    }
  }

  void clearFocusedEncounter() {
    _focusedEncounterComponent?.focused = false;
    _focusedEncounterComponent = null;
  }
}
