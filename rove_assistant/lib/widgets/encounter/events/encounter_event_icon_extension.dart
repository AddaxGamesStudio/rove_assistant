import 'package:flutter/material.dart';
import 'package:rove_assistant/model/encounter/encounter_event.dart';
import 'package:rove_assistant/widgets/common/rove_icon.dart';

extension EncounterEventIcon on EncounterEvent {
  Widget get icon {
    switch (type) {
      case EncounterEventType.codex:
        return RoveIcon.small('codex', color: Colors.white);
      case EncounterEventType.failure:
        return RoveIcon.small('loss_condition', color: Colors.white);
      case EncounterEventType.ether:
        return RoveIcon.small('reward', color: Colors.white);
      case EncounterEventType.reward:
        return RoveIcon.small('reward', color: Colors.white);
      case EncounterEventType.rollEtherDie:
        return Icon(Icons.games, color: Colors.white);
      case EncounterEventType.rollXulcDie:
        return Icon(Icons.games, color: Colors.white);
      case EncounterEventType.rules:
        return RoveIcon.small('special_rules', color: Colors.white);
      case EncounterEventType.token:
        return RoveIcon.small('reward', color: Colors.white);
      case EncounterEventType.victoryConditionChanged:
        return RoveIcon.small('victory_condition', color: Colors.white);
      default:
        return RoveIcon.small('special_rules', color: Colors.white);
    }
  }
}
