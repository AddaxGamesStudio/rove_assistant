import 'package:flutter/material.dart';
import 'package:rove_app_common/model/players_model.dart';
import 'package:rove_assistant/model/encounter_model.dart';
import 'package:rove_app_common/style/rove_palette.dart';
import 'package:rove_assistant/model/figure.dart';
import 'package:rove_data_types/rove_data_types.dart';

enum EncounterEventType {
  draw,
  codex,
  reward,
  rules,
  failure,
  generic,
  ether,
  token,
  rollEtherDie,
  rollXulcDie,
}

class EncounterEvent {
  final EncounterModel model;
  final String title;
  final String message;
  final List<Figure> figures;
  final ItemDef? item;
  final List<EncounterDialogButton> buttons;
  String? _extra;
  Codex? codex;
  final EncounterEventType type;
  final Function(dynamic)? onComplete;

  String? get extra => _extra;

  EncounterEvent(
      {required this.model,
      required this.title,
      required this.message,
      this.figures = const [],
      this.item,
      this.type = EncounterEventType.generic,
      this.buttons = const [],
      this.onComplete})
      : assert(figures.isEmpty || item == null);

  bool get isDrawDialog => type == EncounterEventType.draw;
  bool get isDismissable {
    switch (type) {
      case EncounterEventType.draw:
      case EncounterEventType.token:
      case EncounterEventType.rollEtherDie:
      case EncounterEventType.rollXulcDie:
        return false;
      case EncounterEventType.reward:
        return item == null;
      case EncounterEventType.generic:
        return buttons.isEmpty;
      case EncounterEventType.codex:
      case EncounterEventType.failure:
      case EncounterEventType.ether:
      case EncounterEventType.rules:
        return true;
    }
  }

  bool get isFailure => type == EncounterEventType.failure;
  Color get foregroundColor {
    switch (type) {
      case EncounterEventType.rollEtherDie:
        return RovePalette.setupForeground;
      case EncounterEventType.draw:
        return RovePalette.rulesForeground;
      case EncounterEventType.codex:
        return RovePalette.codexForeground;
      case EncounterEventType.reward:
        return RovePalette.rewardForeground;
      case EncounterEventType.failure:
        return RovePalette.lossForeground;
      case EncounterEventType.ether:
        return RovePalette.rewardForeground;
      case EncounterEventType.generic:
        return RovePalette.rulesForeground;
      case EncounterEventType.rules:
        return RovePalette.rulesForeground;
      case EncounterEventType.token:
        return RovePalette.rewardForeground;
      case EncounterEventType.rollXulcDie:
        return RovePalette.xulc;
    }
  }

  Color get backgroundColor {
    switch (type) {
      case EncounterEventType.rollEtherDie:
        return RovePalette.setupBackground;
      case EncounterEventType.draw:
        return RovePalette.rulesBackground;
      case EncounterEventType.codex:
        return RovePalette.codexBackground;
      case EncounterEventType.reward:
        return RovePalette.rewardBackground;
      case EncounterEventType.failure:
        return RovePalette.lossBackground;
      case EncounterEventType.ether:
        return RovePalette.rewardBackground;
      case EncounterEventType.generic:
        return RovePalette.rulesBackground;
      case EncounterEventType.rules:
        return RovePalette.rulesBackground;
      case EncounterEventType.token:
        return RovePalette.rewardBackground;
      case EncounterEventType.rollXulcDie:
        return RovePalette.rulesBackground;
    }
  }

  static EncounterEvent spawnedAdversaries(
      {required String title,
      required EncounterModel model,
      String? message,
      required List<Figure> figures}) {
    return EncounterEvent(
        model: model,
        title: title,
        message: message ??
            (model.isStartEncounterPhase
                ? 'The adversaries you\'re facing reflect your path.'
                : figures.length == 1
                    ? 'A new adversary has spawned!'
                    : 'New adversaries have spawned!'),
        figures: figures);
  }

  static EncounterEvent itemReward(
      {required String title,
      String? message,
      required EncounterModel model,
      required bool loot,
      required ItemDef item}) {
    return EncounterEvent(
        model: model,
        title: title,
        message: message ??
            (loot
                ? 'The acting Rover receives ${item.name}!'
                : 'Rovers receive ${item.name}!'),
        item: item,
        type: EncounterEventType.reward);
  }

  static EncounterEvent etherReward(
      {required String title,
      required EncounterModel model,
      required List<Ether> etherOptions}) {
    return EncounterEvent(
        model: model,
        title: title,
        message: 'The acting Rover generates one of these ether.',
        type: EncounterEventType.ether)
      .._extra = Ether.etherOptionsToString(etherOptions);
  }

  static EncounterEvent lystReward(
      {required String title,
      required EncounterModel model,
      required int lyst}) {
    return EncounterEvent(
        model: model,
        title: title,
        message: 'Rovers gain $lyst[lyst].',
        type: EncounterEventType.reward);
  }

  static EncounterEvent tokenReward(
      {required String title,
      required EncounterModel model,
      required String token,
      String? message}) {
    return EncounterEvent(
      model: model,
      title: title,
      message: message ?? 'The acting rover picks up a $token.',
      type: EncounterEventType.token,
    ).._extra = token;
  }

  static EncounterEvent campaignMilestone(
      {required EncounterModel model,
      required String? title,
      required String milestone}) {
    final milestoneDef = CampaignMilestone.fromMilestone(milestone);
    return EncounterEvent(
        model: model,
        title: title ??
            (CampaignMilestone.coreCampaignSheetMilestones.contains(milestone)
                ? 'Record Milestone'
                : 'Record Log'),
        message: milestoneDef.message,
        figures: milestoneDef.figureNames
            .map((n) =>
                model.figureFromTarget(n) ??
                FigureBuilder.forGame(model.campaignDef, model.encounterDef,
                        PlayersModel.instance.players.length)
                    .withDefinition(EncounterFigureDef(name: n))
                    .build())
            .toList());
  }

  static EncounterEvent removedFigure(
      {required EncounterModel model,
      String? title,
      String? message,
      required Figure figure}) {
    return EncounterEvent(
        model: model,
        title: title ?? '${figure.nameToDisplay} Left',
        message: message ?? '${figure.nameToDisplay} has left the encounter.',
        figures: [figure]);
  }

  static EncounterEvent replacedUnit(
      {required EncounterModel model,
      required String title,
      String? message,
      required String fromName,
      required Figure figure}) {
    if (model.encounterDef.id == EncounterDef.encounter2dot4) {
      if (fromName == 'Kelo & Saras') {
        message = 'Kelo & Saras are now adversaries.';
      }
    }
    return EncounterEvent(
        model: model,
        title: title,
        message: message ?? '$fromName is now ${figure.nameToDisplay}!',
        figures: [figure]);
  }

  static EncounterEvent encounter3dot4HauntExit(
      {required EncounterModel model,
      required Figure haunt,
      required Figure loot}) {
    assert(model.encounterDef.id == EncounterDef.encounter3dot4);
    return EncounterEvent(
        model: model,
        title: 'Haunt Escaped',
        message:
            'A ${haunt.nameToDisplay} has escaped with ${loot.nameToDisplay}!',
        figures: [haunt, loot]);
  }

  static EncounterEvent victoryCondition(
      {required EncounterModel model, required String title, String? message}) {
    return EncounterEvent(
        model: model,
        title: title,
        type: EncounterEventType.reward,
        message:
            '${message != null ? '$message\n\n' : ''}Press Claim Rewards to complete the encounter.',
        figures: []);
  }

  static const String extraFailedWithRewards = 'failed_with_rewards';

  static EncounterEvent encounterFailed(
      {required EncounterModel model, String? title, String? message}) {
    final bool hasRewards =
        model.encounterDef.id == EncounterDef.encounterIdot2 &&
            model.encounterState.lystRewards.isNotEmpty;
    return EncounterEvent(
        model: model,
        type: EncounterEventType.failure,
        title: title ?? 'Encounter Failed',
        message: message ??
            (hasRewards
                ? 'You can Continue to claim your rewards so far or Retry.'
                : 'Would you like to retry now?'))
      .._extra = hasRewards ? extraFailedWithRewards : null;
  }

  static EncounterEvent dialog(
      {required EncounterModel model,
      required EncounterDialogDef dialog,
      Function(EncounterDialogButton)? onButtonPressed}) {
    late final EncounterEventType type;
    if (dialog.type == EncounterDialogDef.drawType) {
      type = EncounterEventType.draw;
    } else if (dialog.buttons.isNotEmpty) {
      type = EncounterEventType.generic;
    } else {
      type = EncounterEventType.codex;
    }
    return EncounterEvent(
        model: model,
        title: dialog.title,
        type: type,
        message: dialog.body ?? '',
        buttons: dialog.buttons,
        onComplete: onButtonPressed != null
            ? (button) => onButtonPressed(button)
            : null);
  }

  static EncounterEvent codexPrompt(
      {required EncounterModel model,
      required String title,
      String? body,
      required String? page}) {
    final number = model.numberForCodex(title);
    return EncounterEvent(
        model: model,
        title: '$title${number != null ? ' • $number' : ''}',
        message: body ??
            (page == null || page.isEmpty
                ? 'Open the [codex] book and read "**$title**".'
                : 'Open the [codex] book on page $page and read entry ${number != null ? '$number, ' : ''}"**$title**".'),
        type: EncounterEventType.codex);
  }

  static EncounterEvent showCodex(
      {required EncounterModel model, required Codex codex}) {
    return EncounterEvent(
        model: model,
        title: '${codex.number} • ${codex.title}',
        message: codex.body,
        type: EncounterEventType.codex)
      ..codex = codex;
  }

  static EncounterEvent rules(
      {required EncounterModel model, required String title, String? body}) {
    return EncounterEvent(
        model: model,
        title: title,
        message: body ?? 'Read section "$title" in the campaign book.',
        type: EncounterEventType.rules);
  }

  static EncounterEvent rollXulcDie(
      {required EncounterModel model,
      String? title,
      String? message,
      required Function(XulcDieSide draw) onDraw}) {
    return EncounterEvent(
        model: model,
        title: title ?? 'Roll Xulc Die',
        message: message ?? '',
        type: EncounterEventType.rollXulcDie,
        onComplete: (draw) => onDraw(draw));
  }

  static EncounterEvent rollEtherDie(
      {required EncounterModel model,
      String? title,
      String? message,
      required Function(EtherDieSide draw) onDraw}) {
    return EncounterEvent(
        model: model,
        title: title ?? 'Roll Ether Die',
        message: message ?? '',
        type: EncounterEventType.rollEtherDie,
        onComplete: (draw) => onDraw(draw));
  }
}

class EncounterEvents extends ChangeNotifier {
  final List<EncounterEvent> events = [];
  bool muted = false;

  addEvent(EncounterEvent event) {
    events.add(event);
    if (!muted) {
      notifyListeners();
    }
  }

  bool get isNotEmpty => events.isNotEmpty;

  List<EncounterEvent> pop() {
    assert(events.isNotEmpty);
    final eventsCopy = events.toList();
    events.clear();
    return eventsCopy;
  }

  /// Mute all events until [unmute] is called. Used for applying triggers on encounter start.
  void mute() {
    muted = true;
  }

  void unmute() {
    muted = false;
  }
}
