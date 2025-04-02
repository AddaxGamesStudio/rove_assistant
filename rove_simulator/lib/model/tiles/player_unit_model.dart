import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:rove_app_common/model/players_model.dart';
import 'package:rove_simulator/assets.dart';
import 'package:rove_simulator/model/cards/ability_model.dart';
import 'package:rove_simulator/model/cards/item_model.dart';
import 'package:rove_simulator/model/cards/reaction_model.dart';
import 'package:rove_simulator/model/cards/skill_model.dart';
import 'package:rove_simulator/model/map_model.dart';
import 'package:rove_simulator/model/persistence/saveable.dart';
import 'package:rove_simulator/model/player_extension.dart';
import 'package:rove_simulator/model/tiles/summon_model.dart';
import 'package:rove_simulator/model/tiles/unit_model.dart';
import 'package:hex_grid/hex_grid.dart';
import 'package:rove_data_types/rove_data_types.dart';

class PlayerUnitModel extends UnitModel {
  final Player player;
  Set<String> playedAbilities = <String>{};
  List<Ether> personalEtherPool = [];
  List<Ether> infusedEtherPool = [];
  final List<(Ether, int)> _selectedEtherForSkill = [];
  final List<(Ether, int)> _selectedInfusedEther = [];
  SkillModel? _activeSkill;
  RoveGlyph? _glyph;
  final List<SkillModel> skills = [];
  final List<ReactionModel> reactions = [];
  final List<SummonModel> _summons = [];
  List<SummonModel> get summons => _summons;

  static const abilitiesPerTurnCount = 2;
  static const skillsPerTurnCount = 1;
  static const reactionsPerRound = 1;

  int availableAbilityCount = abilitiesPerTurnCount;
  int availableSkillCount = skillsPerTurnCount;
  int availableReactionCount = reactionsPerRound;

  late final List<AbilityModel> abilities;
  final List<ItemModel> items = [];

  PlayerUnitModel(
      {required this.player, required super.coordinate, required super.map})
      : abilities = player.roverClass.abilities
            .map((ability) => AbilityModel(ability: ability))
            .toList(growable: false) {
    maxHealth = player.roverClass.health;
    health = maxHealth;
    skills.addAll(SkillModel.fromSkills(
        SkillModel.mapOfSkills(player.roverClass.skills), player.roverClass));
    for (SkillModel skillModel in skills) {
      skillModel.addListener(() {
        notifyListeners();
      });
    }
    reactions.addAll(ReactionModel.fromReactions(
        ReactionModel.mapOfReactions(player.roverClass.reactions)));
    for (ReactionModel reaction in reactions) {
      reaction.addListener(() {
        notifyListeners();
      });
    }
    items.addAll(
        player.items.where((d) => d.$2).map((d) => ItemModel(item: d.$1)));
  }

  RoveGlyph? get glyph => _glyph;
  set glyph(RoveGlyph? glyph) {
    _glyph = glyph;
    notifyListeners();
  }

  RoverClass get roverClass => player.roverClass;

  String get boardOverlayName => player.boardOverlayName;

  @override
  String get key => 'player.${player.name}';

  @override
  String get name => player.name;

  @override
  String get className => player.roverClass.name;

  @override
  Color get color => player.roverClass.color;

  Color get colorDark => player.roverClass.colorDark;

  @override
  Color get backgroundColor => player.roverClass.colorDark;

  @override
  Faction get faction => Faction.rover;

  @override
  List<RoveGlyph> get affectingGlyphs =>
      super.affectingGlyphs + (glyph != null ? [glyph!] : []);

  @override
  int get defense => player.roverClass.defense + super.defense;

  @override
  bool get isFlying => false;

  @override
  bool get usesGlyphs => player.roverClass.usesGlyphs;

  @override
  int affinityForEther(Ether ether) {
    return player.roverClass.affinities[ether] ?? 0;
  }

  @override
  bool get isSlain => false;

  bool get isDowned => health <= 0;

  @override
  bool get isTargetable => !isDowned;

  @override
  Image get image =>
      Assets.campaignImages.classImage(player.roverClass.imageSrc);

  @override
  String? get trapImage => player.roverClass.trapImage;

  @override
  bool get immuneToForcedMovement => false;

  @override
  int get reducePushPullBy => 0;

  @override
  UnitModel? get owner => this;

  @override
  List<EncounterAction> get onSlayed => const [];

  @override
  List<EncounterAction> get onDidStartRound => const [];

  @override
  List<EncounterAction> get onWillEndRound => const [];

  /* Card Play */

  List<Ether> get selectedInfusedEther =>
      _selectedInfusedEther.map((e) => e.$1).toList();

  List<Ether> get selectedEtherForSkill =>
      _selectedEtherForSkill.map((e) => e.$1).toList();

  isSelectedInfusedEtherAtIndex(int index) {
    return _selectedInfusedEther.any((element) => element.$2 == index);
  }

  isSelectedPersonalPoolEtherAtIndex(int index) {
    return _selectedEtherForSkill.any((element) => element.$2 == index);
  }

  void onSelectedInfusedEtherChanged(Ether ether,
      {required int index, required bool selected}) {
    assert(index >= 0 && index < infusedEtherPool.length);
    if (selected) {
      _selectedInfusedEther.add((ether, index));
    } else {
      _selectedInfusedEther.removeWhere((element) => element.$2 == index);
    }
    notifyListeners();
  }

  void selectEtherForSkill(List<(Ether, int)> ether) {
    _selectedEtherForSkill.clear();
    _selectedEtherForSkill.addAll(ether);
    notifyListeners();
  }

  bool canPlayAbility(AbilityModel ability) {
    if (endedTurn) {
      return false;
    }
    if (summons.any((s) => s.abilities.contains(ability))) {
      return ability.canPlayGivenPlayedAbilities(playedAbilities);
    }

    return availableAbilityCount > 0 &&
        ability.canPlayGivenPlayedAbilities(playedAbilities);
  }

  void onPlayedAbility(AbilityModel ability) {
    playedAbilities.add(ability.name);
    final isSummonAbility = summons.any((s) => s.abilities.contains(ability));
    if (!isSummonAbility) {
      availableAbilityCount--;
    }
    notifyListeners();
  }

  bool canPlaySkill(SkillModel skill) {
    return !endedTurn &&
        availableSkillCount > 0 &&
        skill.current.etherCost <= personalEtherPool.length &&
        (skill.current.abilityCost == 0 ||
            skill.current.abilityCost <= availableAbilityCount);
  }

  void onStartedPlayingSkill(SkillModel skill) {
    _activeSkill = skill;
    skill.isPlaying = true;
    notifyListeners();
  }

  void onCancelledPlayingSkill(SkillModel skill) {
    _activeSkill = null;
    skill.isPlaying = false;
    _selectedEtherForSkill.clear();
    notifyListeners();
  }

  void onPlayedSkill(SkillModel skill) {
    assert(_activeSkill == skill);
    _activeSkill = null;
    availableSkillCount--;
    availableAbilityCount -= skill.current.abilityCost;
    // Remove ether in reverse order to avoid out of bounds errors
    final etherToRemove = _selectedEtherForSkill.sorted((a, b) => b.$2 - a.$2);
    for (var element in etherToRemove) {
      personalEtherPool.removeAt(element.$2);
      infusedEtherPool.add(element.$1);
    }
    _selectedEtherForSkill.clear();
    skill.didPlay();
    notifyListeners();
  }

  void onPlayedReaction(ReactionModel reaction) {
    reaction.flip();
    notifyListeners();
  }

  List<SkillModel> flippableCardsForCondition(FlipCondition condition) {
    return skills
        .where((element) => element != _activeSkill)
        .where((element) => condition.matchesSkill(element.current))
        .toList();
  }

  /* Reactions */

  bool get canPlayReaction => reactions.where((r) => r.canPlay).isNotEmpty;

  bool get hasExceesEther =>
      personalEtherPool.length > player.roverClass.etherLimit ||
      infusedEtherPool.length > player.roverClass.etherLimit;

  /* Progression */

  @override
  void resetRound() {
    super.resetRound();
    availableAbilityCount = abilitiesPerTurnCount;
    availableSkillCount = skillsPerTurnCount;
    availableReactionCount = reactionsPerRound;
    playedAbilities.clear();
    notifyListeners();
  }

  /* Ether management */

  addEther(Ether ether) {
    personalEtherPool.add(ether);
    notifyListeners();
  }

  removeEther(Ether ether) {
    personalEtherPool.remove(ether);
    notifyListeners();
  }

  removeInfusedEther(Ether ether) {
    _selectedInfusedEther.clear();
    infusedEtherPool.remove(ether);
    notifyListeners();
  }

  dimEther(Ether ether) {
    assert(personalEtherPool.contains(ether));
    assert(ether != Ether.dim);
    final index = personalEtherPool.indexOf(ether);
    personalEtherPool[index] = Ether.dim;
    notifyListeners();
  }

  infuseEther(Ether ether, {required bool fromPersonalPool}) {
    _selectedInfusedEther.clear();
    if (fromPersonalPool) {
      assert(personalEtherPool.contains(ether));
      personalEtherPool.remove(ether);
    }
    infusedEtherPool.add(ether);
    notifyListeners();
  }

  /* Summons */

  SummonDef? summonDefinitionForName(String name) {
    return roverClass.summons.firstWhereOrNull((s) => s.name == name);
  }

  addSummon(SummonModel summon) {
    assert(summon.summoner == this);
    assert(!_summons.contains(summon));
    _summons.add(summon);
    notifyListeners();
  }

  void removeSummon(SummonModel summon) {
    assert(_summons.contains(summon));
    _summons.remove(summon);
    notifyListeners();
  }

  /* Items */

  addItem(ItemDef item) {
    items.add(ItemModel(item: item, isFromEncounter: true));
    notifyListeners();
  }

  List<ItemModel> get encounterItems =>
      items.where((i) => i.isFromEncounter).toList();

  int availableSlotsForSlotType(ItemSlotType slot) {
    switch (slot) {
      case ItemSlotType.head:
      case ItemSlotType.hand:
      case ItemSlotType.body:
      case ItemSlotType.foot:
      case ItemSlotType.none:
        return player.baseSlotsForSlotType(slot);
      case ItemSlotType.pocket:
        return player.baseSlotsForSlotType(slot) +
            items.where((i) => i.isPartOfEncounter).length;
    }
  }

  ItemModel? itemAtIndex({required int index, required ItemSlotType slot}) {
    final slotItems = items.where((i) => i.slotType == slot).toList();
    var indexedItems = [];
    for (final item in slotItems) {
      for (int i = 0; i < item.item.slotCount; i++) {
        indexedItems.add(item);
      }
    }
    if (index >= 0 && index < indexedItems.length) {
      return indexedItems[index];
    }
    return null;
  }

  /* Saveable */

  PlayerUnitModel._saveData(
      {required SaveData data, required this.player, required super.map})
      : super(coordinate: HexCoordinate.zero()) {
    abilities = player.roverClass.abilities
        .map((ability) => AbilityModel(ability: ability))
        .toList(growable: false);
    initializeWithSaveData(data);
  }

  static fromSaveData(
      {required SaveData data,
      required MapModel map,
      required List<Player> players}) {
    final playerName = data.key;
    final player = players.firstWhere((p) => p.name == playerName);
    final playerUnit =
        PlayerUnitModel._saveData(data: data, player: player, map: map);
    return playerUnit;
  }

  @override
  String get saveableKey => player.name;

  @override
  Map<String, dynamic> saveableProperties() {
    final properties = super.saveableProperties();
    properties.addAll({
      'played_abilities': playedAbilities.toList(),
      'selected_ether_for_skill': _selectedEtherForSkill
          .map((d) => {'ether': d.$1.name, 'index': d.$2})
          .toList(),
      'infused_ether_pool': infusedEtherPool.map((e) => e.name).toList(),
      'personal_ether_pool': personalEtherPool.map((e) => e.name).toList(),
      'available_ability_count': availableAbilityCount,
      'available_skill_count': availableSkillCount,
      'available_reaction_count': availableReactionCount,
    });
    if (_activeSkill != null) {
      properties['active_skill_front'] = _activeSkill!.front.name;
    }
    if (_glyph != null) {
      properties['glyph'] = _glyph!.name;
    }
    return properties;
  }

  @override
  String get saveableType => 'PlayerUnitModel';

  @override
  List<Saveable> get saveableChildren =>
      [...super.saveableChildren, ...skills, ...reactions, ...items];

  @override
  setSaveablePropertiesBeforeChildren(Map<String, dynamic> properties) {
    super.setSaveablePropertiesBeforeChildren(properties);
    playedAbilities.addAll(properties['played_abilities'] as List<String>);
    _selectedEtherForSkill.addAll((properties['selected_ether_for_skill']
            as List<Map<String, dynamic>>)
        .map((d) => (Ether.fromName(d['ether'] as String), d['index'] as int))
        .toList());
    infusedEtherPool.addAll(
        (properties['infused_ether_pool'] as List<String>? ?? [])
            .map((s) => Ether.fromName(s))
            .toList());
    personalEtherPool.addAll(
        (properties['personal_ether_pool'] as List<String>? ?? [])
            .map((s) => Ether.fromName(s))
            .toList());
    availableAbilityCount = properties['available_ability_count'];
    availableSkillCount = properties['available_skill_count'];
    availableReactionCount = properties['available_reaction_count'];
    final glyphString = properties['glyph'] as String?;
    if (glyphString != null) {
      _glyph = RoveGlyph.fromName(glyphString);
    }
  }

  @override
  setSaveablePropertiesAfterChildren(Map<String, dynamic> properties) {
    super.setSaveablePropertiesAfterChildren(properties);
    final activeSkillFrontName = properties['active_skill_front'];
    if (activeSkillFrontName != null) {
      _activeSkill =
          skills.firstWhere((s) => s.front.name == activeSkillFrontName);
    }
  }

  @override
  Saveable createSaveableChild(SaveData childData) {
    switch (childData.type) {
      case 'ReactionModel':
        final reactionMap = ReactionModel.mapOfReactions(roverClass.reactions);
        final reaction =
            ReactionModel.fromReactionName(childData.key, reactionMap);
        reactions.add(reaction);
        reaction.addListener(() {
          notifyListeners();
        });
        return reaction;
      case 'SkillModel':
        final skillMap = SkillModel.mapOfSkills(roverClass.skills);
        final skill =
            SkillModel.fromSkillName(roverClass, childData.key, skillMap);
        skills.add(skill);
        skill.addListener(() {
          notifyListeners();
        });
        return skill;
      case 'ItemModel':
        final item = ItemModel.fromSaveData(data: childData);
        items.add(item);
        return item;
      default:
        throw UnimplementedError();
    }
  }
}
