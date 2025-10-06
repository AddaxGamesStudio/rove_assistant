import 'package:rove_data_types/rove_data_types.dart';

EncounterDialogDef introduction(String body) {
  return EncounterDialogDef(title: 'Introduction', body: body);
}

EncounterDialogDef introductionFromText(String name, {String? title}) {
  return EncounterDialogDef(
      title: title ?? 'Introduction',
      type: EncounterDialogDef.textType,
      body: name);
}

EncounterTerrain etherCrux({bool lodestone = false}) {
  return EncounterTerrain(lodestone ? 'lodestone_crux' : 'ether_node_crux',
      title: 'Crux Ether Node',
      body:
          ' Units within [range] 1 of this object gain +1 [DMG] to the first attack they perform during their turn.');
}

EncounterTerrain etherEarth({bool lodestone = false}) {
  return EncounterTerrain(lodestone ? 'lodestone_earth' : 'ether_node_earth',
      title: 'Earth Ether Node',
      body:
          'Units that end their turn within [Range] 1 of this object recover [HP] 1.');
}

EncounterTerrain etherFire({bool lodestone = false}) {
  return EncounterTerrain(lodestone ? 'lodestone_fire' : 'ether_node_fire',
      title: 'Fire Ether Node',
      damage: 1,
      body:
          'Units that end their turn within [Range] 1 of this object suffer [DMG] 1.');
}

EncounterTerrain etherWater({bool lodestone = false}) {
  return EncounterTerrain(lodestone ? 'lodestone_water' : 'ether_node_water',
      title: 'Water Ether Node',
      body:
          'It costs units 1 additional movement point to enter a space within [Range] 1 of this object.');
}

EncounterTerrain etherMorph({bool lodestone = false}) {
  return EncounterTerrain(lodestone ? 'lodestone_morph' : 'ether_node_morph',
      title: 'Morph Ether Node',
      body:
          'Units within [range] 1 of this object gain -1 [DMG] to the first attack they perform during their turn.');
}

EncounterTerrain etherWind({bool lodestone = false}) {
  return EncounterTerrain(lodestone ? 'lodestone_wind' : 'ether_node_wind',
      title: 'Wind Ether Node',
      body: 'Units within [Range] 1 of this object gain +1 [DEF].');
}

EncounterTerrain trapBell(int damage) {
  return EncounterTerrain('trap_bursting_bell',
      title: 'Bursting Bell Trap',
      damage: damage,
      body: 'Units that trigger Bursting Bell traps suffer [DMG] $damage.');
}

EncounterTerrain trapColumn(int damage) {
  return EncounterTerrain('trap_crumbling_column',
      title: 'Crumbling Column Trap',
      damage: damage,
      body: 'Units that trigger Crumbling Column traps suffer [DMG] $damage.');
}

EncounterTerrain trapTar(int damage) {
  return EncounterTerrain('trap_bursting_tar',
      title: 'Bursting Tar Trap',
      damage: damage,
      body: 'Units that trigger bursting tar traps suffer [DMG] $damage.');
}

EncounterTerrain trapHatchery(int damage) {
  return EncounterTerrain('trap_bursting_tar',
      title: 'Hatchery Trap',
      damage: damage,
      body: 'Units that trigger hatchery traps suffer [DMG] $damage.');
}

EncounterTerrain trapMagic(int damage) {
  return EncounterTerrain('trap_magic',
      title: 'Magic Trap',
      damage: damage,
      body:
          'Units that trigger magic traps suffer [DMG] $damage. When a magic trap is triggered, roll an ether dice and place the ether field that corresponds with the result of the roll in the space the trap was in. A result of [crux] or [morph] places an adversary [aura] or [miasma], respectively.');
}

EncounterTerrain trapPod(int damage) {
  return EncounterTerrain('trap_pod',
      title: 'Pod Trap',
      expansion: 'xulc',
      damage: damage,
      body:
          'Units that trigger a pod trap suffer [DMG] $damage. When a pod trap is triggered, roll the xulc dice and spawn the result in the space the trap was in.');
}

EncounterTerrain dangerousFire(int damage) {
  return EncounterTerrain('dangerous_fire',
      title: 'Fire',
      damage: damage,
      body: 'Non-flying units that enter fire suffer [DMG] $damage. ');
}

EncounterTerrain dangerousBones(int damage) {
  return EncounterTerrain('dangerous_jagged_bones',
      title: 'Jagged Bones',
      damage: damage,
      body: 'Non-flying units that enter jagged bones suffer [DMG] $damage.');
}

EncounterTerrain dangerousCrystals(int damage) {
  return EncounterTerrain('dangerous_jagged_crystals',
      title: 'Jagged Crystals',
      damage: damage,
      body:
          'Non-flying units that enter jagged crystals suffer [DMG] $damage.');
}

EncounterTerrain dangerousBramble(int damage) {
  return EncounterTerrain('dangerous_thick_bramble',
      title: 'Thick Bramble',
      damage: damage,
      body:
          'Non-flying units that enter a thick bramble space suffer [DMG] $damage.');
}

EncounterTerrain dangerousPool(int damage) {
  return EncounterTerrain('dangerous_polluted_pool',
      title: 'Polluted Pool',
      damage: damage,
      body:
          'Non-flying units that enter a polluted pool space suffer [DMG] $damage.');
}

EncounterTerrain poison() {
  return EncounterTerrain('poison',
      title: 'Poisoned Water',
      body:
          'An incredibly deadly river of poisonous sludge runs through the map. Poisoned water spaces have a white border and follow all the rules of open air spaces.');
}

EncounterTerrain difficultWater() {
  return EncounterTerrain('difficult_water',
      expansion: 'xulc', title: 'Water', body: 'Difficult terrain is water.');
}

EncounterTerrain difficultXulc() {
  return EncounterTerrain('difficult_xulc',
      expansion: 'xulc',
      title: 'Xulc Growth',
      body: 'Difficult terrain is xulc growth.');
}

EncounterAction codex(int number,
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

EncounterAction removeCodexLink(int number,
    {RoveCondition? condition, List<RoveCondition>? conditions}) {
  assert(condition == null || conditions == null);
  return EncounterAction(
      type: EncounterActionType.removeCodexLink,
      value: number.toString(),
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
    RoveCondition? condition,
    List<RoveCondition>? conditions}) {
  assert(key != null || limit == 0);
  return EncounterAction(
      key: key,
      type: EncounterActionType.spawnPlacements,
      value: name,
      title: title,
      body: body,
      limit: limit,
      silent: silent,
      conditions: conditions ?? (condition != null ? [condition] : []));
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
