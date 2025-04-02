import 'package:rove_data_types/rove_data_types.dart';

EncounterAction codex(String title,
    {int? page, RoveCondition? condition, List<RoveCondition>? conditions}) {
  assert(condition == null || conditions == null);
  return EncounterAction(
      type: EncounterActionType.codex,
      title: title,
      value: page?.toString() ?? '',
      conditions: conditions ?? (condition != null ? [condition] : []));
}

EncounterAction codexN(int number,
    {int? page, RoveCondition? condition, List<RoveCondition>? conditions}) {
  assert(condition == null || conditions == null);
  return EncounterAction(
      type: EncounterActionType.codex,
      value: number.toString(),
      conditions: conditions ?? (condition != null ? [condition] : []));
}

EncounterAction codexLink(String title,
    {int? number,
    String? body,
    RoveCondition? condition,
    List<RoveCondition>? conditions}) {
  assert(condition == null || conditions == null);
  return EncounterAction(
      type: EncounterActionType.codexLink,
      title: title,
      value: number?.toString() ?? '',
      body: body,
      conditions: conditions ?? (condition != null ? [condition] : []));
}

EncounterAction terrain(String title, String body,
    {RoveCondition? condition,
    List<RoveCondition>? conditions,
    bool silent = false}) {
  return rules(title, body,
      condition: condition, conditions: conditions, silent: silent);
}

EncounterAction rules(String title, String body,
    {RoveCondition? condition,
    List<RoveCondition>? conditions,
    bool silent = false}) {
  assert(condition == null || conditions == null);
  return EncounterAction(
      type: EncounterActionType.rules,
      title: title,
      body: body,
      silent: silent,
      conditions: conditions ?? (condition != null ? [condition] : []));
}

EncounterAction removeRule(String title,
    {RoveCondition? condition, List<RoveCondition>? conditions}) {
  assert(condition == null || conditions == null);
  return EncounterAction(
      type: EncounterActionType.removeRule,
      value: title,
      conditions: conditions ?? (condition != null ? [condition] : []));
}

EncounterAction item(String name,
    {RoveCondition? condition, String? title, String? body}) {
  return EncounterAction(
      type: EncounterActionType.rewardItem,
      value: name,
      title: title,
      body: body,
      conditions: condition != null ? [condition] : []);
}

EncounterAction lyst(String formula,
    {String? title, RoveCondition? condition, bool silent = false}) {
  return EncounterAction(
      type: EncounterActionType.rewardLyst,
      value: formula,
      title: title,
      silent: silent,
      conditions: condition != null ? [condition] : []);
}

EncounterAction ether(List<Ether> ethers, {RoveCondition? condition}) {
  return EncounterAction(
      type: EncounterActionType.rewardEther,
      value: ethers.length == 1
          ? ethers[0].toJson()
          : Ether.etherOptionsToString(ethers),
      conditions: condition != null ? [condition] : []);
}

EncounterAction victory(
    {String? body, RoveCondition? condition, List<RoveCondition>? conditions}) {
  return EncounterAction(
      type: EncounterActionType.victory,
      body: body,
      conditions: conditions ?? (condition != null ? [condition] : []));
}

EncounterAction fail({String? title, String? body}) {
  return EncounterAction(
      type: EncounterActionType.loss, title: title, body: body);
}

EncounterAction dialog(String? name,
    {RoveCondition? condition,
    List<RoveCondition>? conditions,
    String? title,
    String? body}) {
  assert(name != null || body != null);
  assert(condition == null || conditions == null);
  return EncounterAction(
      type: EncounterActionType.dialog,
      value: name ?? '',
      title: title,
      body: body,
      conditions: conditions ?? (condition != null ? [condition] : []));
}

EncounterAction placementGroup(String name,
    {String? key,
    String? title,
    String? body,
    int limit = 0,
    bool silent = false,
    RoveCondition? condition}) {
  assert(key != null || limit == 0);
  return EncounterAction(
      key: key,
      type: EncounterActionType.spawnPlacements,
      value: name,
      title: title,
      body: body,
      limit: limit,
      silent: silent,
      conditions: condition != null ? [condition] : []);
}

EncounterAction resetRound(
    {int? newLimit,
    String? title,
    String? body,
    bool silent = false,
    RoveCondition? condition}) {
  return EncounterAction(
      type: EncounterActionType.resetRound,
      value: newLimit != null ? newLimit.toString() : '',
      title: title,
      body: body,
      silent: silent,
      conditions: condition != null ? [condition] : []);
}

EncounterAction victoryCondition(String value, {RoveCondition? condition}) {
  return EncounterAction(
      type: EncounterActionType.setVictoryCondition,
      value: value,
      conditions: condition != null ? [condition] : []);
}

EncounterAction subtitle(String subtitle, {RoveCondition? condition}) {
  return EncounterAction(
      type: EncounterActionType.setSubtitle,
      value: subtitle,
      conditions: condition != null ? [condition] : []);
}

EncounterAction milestone(String name,
    {String? title,
    bool silent = false,
    RoveCondition? condition,
    List<RoveCondition>? conditions}) {
  assert(condition == null || conditions == null);
  return EncounterAction(
      type: EncounterActionType.milestone,
      value: name,
      title: title,
      silent: silent,
      conditions: conditions ?? (condition != null ? [condition] : []));
}

EncounterAction remove(String? name,
    {String? title,
    String? body,
    RoveCondition? condition,
    bool silent = false}) {
  return EncounterAction(
      type: EncounterActionType.remove,
      value: name ?? '',
      title: title,
      body: body,
      silent: silent,
      conditions: condition != null ? [condition] : []);
}

EncounterAction removeAll() {
  return EncounterAction(type: EncounterActionType.removeAll);
}

EncounterAction replace(String name,
    {String? title,
    String? body,
    RoveCondition? condition,
    bool silent = false}) {
  return EncounterAction(
      type: EncounterActionType.replace,
      value: name,
      title: title,
      body: body,
      silent: silent,
      conditions: condition != null ? [condition] : []);
}

EncounterAction rollEtherDie({
  String? title,
  String? body,
  RoveCondition? condition,
}) {
  return EncounterAction(
      type: EncounterActionType.rollEtherDie,
      title: title,
      body: body,
      conditions: condition != null ? [condition] : []);
}

EncounterAction rollXulcDie({
  String? title,
  String? body,
  RoveCondition? condition,
}) {
  return EncounterAction(
      type: EncounterActionType.rollXulcDie,
      title: title,
      body: body,
      conditions: condition != null ? [condition] : []);
}

EncounterAction function(String name, {RoveCondition? condition}) {
  return EncounterAction(
      type: EncounterActionType.function,
      value: name,
      conditions: condition != null ? [condition] : []);
}

EncounterAction addToken(String name,
    {String? title, String? body, RoveCondition? condition}) {
  return EncounterAction(
      type: EncounterActionType.addToken,
      value: name,
      title: title,
      body: body,
      conditions: condition != null ? [condition] : []);
}
