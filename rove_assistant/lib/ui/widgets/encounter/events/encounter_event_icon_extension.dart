import 'package:flutter/material.dart';
import 'package:rove_assistant/model/encounter_event.dart';
import 'package:rove_assistant/ui/widgets/common/rove_icon.dart';

extension EncounterEventIcon on EncounterEvent {
  Widget get icon {
    switch (type) {
      case EncounterEventType.codex:
        return RoveIcon('codex', color: Colors.white);
      case EncounterEventType.failure:
        return RoveIcon('loss_condition', color: Colors.white);
      case EncounterEventType.ether:
        return RoveIcon('reward', color: Colors.white);
      case EncounterEventType.reward:
        return RoveIcon('reward', color: Colors.white);
      case EncounterEventType.rollEtherDie:
        return Icon(Icons.games, color: Colors.white);
      case EncounterEventType.rollXulcDie:
        return Icon(Icons.games, color: Colors.white);
      case EncounterEventType.rules:
        return RoveIcon('special_rules', color: Colors.white);
      case EncounterEventType.token:
        return RoveIcon('reward', color: Colors.white);
      default:
        return RoveIcon('special_rules', color: Colors.white);
    }
  }
}
