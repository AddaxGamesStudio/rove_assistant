import 'package:flutter/foundation.dart';
import 'package:rove_simulator/controller/card_controller.dart';
import 'package:rove_simulator/controller/event_controller.dart';
import 'package:rove_simulator/controller/map_controller.dart';
import 'package:rove_simulator/controller/reward_controller.dart';
import 'package:rove_simulator/controller/turn_controller.dart';
import 'package:rove_simulator/flame/encounter_game.dart';
import 'package:rove_simulator/model/encounter_log.dart';
import 'package:rove_simulator/model/encounter_model.dart';
import 'package:rove_simulator/model/map_model.dart';

abstract class BaseController extends ChangeNotifier {
  final EncounterGame game;

  BaseController({required this.game});

  EncounterModel get model => game.model;
  EncounterLog get log => model.log;
  MapModel get mapModel => game.mapModel;
  MapController get mapController => game.controller;
  TurnController get turnController => game.turnController;
  EventController get eventController => game.eventController;
  CardController get cardController => game.cardController;
  RewardController get rewardController => game.rewardController;
}
