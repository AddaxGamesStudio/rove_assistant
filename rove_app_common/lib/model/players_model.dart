import 'package:flutter/foundation.dart';
import 'package:rove_app_common/model/campaign_model.dart';
import 'package:rove_app_common/model/items_model.dart';
import 'package:rove_data_types/rove_data_types.dart';

class PlayersModel extends ChangeNotifier {
  PlayersModel._privateConstructor();

  static final PlayersModel _instance = PlayersModel._privateConstructor();

  static PlayersModel get instance => _instance;

  Campaign get _campaign => CampaignModel.instance.campaign;
  CampaignDef get _campaignDefinition =>
      CampaignModel.instance.campaignDefinition;

  List<Player> get players => _campaign.players;
  List<Player> get inactivePlayers => _campaign.inactivePlayers;

  List<Player> get debugPlayers {
    final players = [
      Player(name: 'Sophist', baseClassName: 'Sophist'),
      Player(name: 'Shadow Piercer', baseClassName: 'Shadow Piercer'),
      Player(name: 'Dune Dancer', baseClassName: 'Dune Dancer'),
      Player(name: 'Flash', baseClassName: 'Flash'),
      Player(name: 'True Scale', baseClassName: 'True Scale')
    ];
    for (final player in players) {
      for (String itemName in player.roverClass.startingEquipment) {
        final item = ItemsModel.instance.itemForName(itemName);
        player.addItem(itemName);
        player.equipItem(item);
      }
    }
    // RoverClassBehavior.printClasses();
    players.shuffle();
    return players.sublist(0, 4);
  }

  addPlayer({required RoverClass roverClass, required String playerName}) {
    final baseClassName = roverClass.baseClass.name;
    if (_hasPlayerForBaseClass(baseClassName)) {
      throw Exception('Player already exists for base class $baseClassName');
    }

    final player = _campaign.addPlayer(playerName, baseClassName);
    switch (roverClass.evolutionStage) {
      case RoverEvolutionStage.prime:
        player.primeClassName = roverClass.name;
        break;
      case RoverEvolutionStage.apex:
        player.primeClassName = roverClass.prime;
        player.apexClassName = roverClass.name;
        break;
      case RoverEvolutionStage.base:
        break;
    }
    _onStateChanged();
  }

  bool get canAddPlayer {
    return _campaign.allPlayers.length < roveMaximumPlayerCount + 1 &&
        players.length <= roveMaximumPlayerCount - 1;
  }

  void reactivate(Player player) {
    assert(player.inactive);
    _campaign.reactivatePlayer(player);
    _onStateChanged();
  }

  void deactivate(Player player) {
    _campaign.inactivatePlayer(player);
    _onStateChanged();
  }

  bool get hasMinimumPlayerCount =>
      _campaign.players.length >= roveMinimumPlayerCount;

  setPlayerName({required String baseClassName, required String name}) {
    Player player = playerForClass(baseClassName);
    player.name = name;
    _onStateChanged();
  }

  Player playerForClass(String className) {
    final roverClass = _campaignDefinition.getClass(className: className);
    return _campaign.allPlayers
        .firstWhere((e) => e.roverClass.name == roverClass.name, orElse: () {
      return _campaign.allPlayers
          .firstWhere((e) => e.roverClass.baseClass == roverClass);
    });
  }

  bool hasPlayerForBaseClass(String className) {
    return _campaign.allPlayers.any((e) => e.baseClassName == className);
  }

  bool hasPlayerForClass(String className) {
    final roverClass = _campaignDefinition.getClass(className: className);
    return _campaign.allPlayers
        .any((e) => e.roverClass.name == roverClass.name);
  }

  isInactiveForClass(String className) {
    if (hasPlayerForClass(className)) {
      return playerForClass(className).inactive;
    }
    return false;
  }

  bool _hasPlayerForBaseClass(String className) {
    return _campaign.allPlayers.any((e) => e.baseClassName == className);
  }

  get roversLevel => _campaign.roversLevel;

  _onStateChanged() {
    CampaignModel.instance.saveCampaign();
    notifyListeners();
  }

  void setPlayers(List<Player> players) {
    assert(kDebugMode);
    _campaign.setPlayers(players);
    _onStateChanged();
  }

  /* Traits */

  int get traitCount => _campaign.traitsCount;

  bool get hasPendingTrait => players.any((p) => p.hasPendingTrait);

  void addTrait({required Player player, required String trait}) {
    if (player.traits.length >= CampaignModel.instance.campaign.traitsCount) {
      return;
    }
    player.addTrait(trait);
    _onStateChanged();
  }

  void removeTrait({required Player player, required String trait}) {
    player.removeTrait(trait);
    _onTraitRemoved(player);
    _onStateChanged();
  }

  List<TraitDef> traitsForPlayer(Player player) {
    final primeTraits = player.primeClass?.traits ?? [];
    final apexTraits = player.apexClass?.traits ?? [];
    final allTraits = primeTraits + apexTraits;
    return allTraits.where((t) => player.traits.contains(t.name)).toList();
  }

  bool anyPlayerHasTrait(String trait) {
    return players.any((p) => p.traits.contains(trait));
  }

  /* Xulc Campaign */

  bool get unlockedInfectedTraits =>
      _campaignDefinition
              .questForId('10_act1')
              .statusForEncounter(EncounterDef.encounter10dot5) ==
          EncounterStatus.completed &&
      !CampaignModel.instance.hasMilestone(XulcExpansion.curedMilestone);

  List<TraitDef> get infectedTraits =>
      _campaignDefinition.getClass(className: 'Infected').traits;

  bool get showResignXulcHealthIncrease =>
      CampaignModel.instance.hasMilestone(CampaignMilestone.milestone10dot7) &&
      !CampaignModel.instance.hasMilestone(XulcExpansion.curedMilestone);

  void setResignXulcHealthIncrease(
      {required Player player, required bool value}) {
    player.resignXulcHealthIncrease = value;
    _onStateChanged();
  }

  int xulcHealthBuffForPlayer(Player player) {
    if (player.resignXulcHealthIncrease) {
      return 0;
    }

    return CampaignModel.instance
                .hasMilestone(XulcExpansion.infectedMilestone) &&
            !CampaignModel.instance.hasMilestone(XulcExpansion.curedMilestone)
        ? XulcExpansion.infectedHealthBuff
        : 0;
  }

  void removeXulcTraits() {
    final infectedTraits = this.infectedTraits;
    for (final player in players) {
      final traits = player.traits.toList();
      for (final trait in traits) {
        if (infectedTraits.any((t) => t.name == trait)) {
          removeTrait(player: player, trait: trait);
        }
      }
    }
  }

  /* Leveling */

  bool levelUpToLevel(int level) {
    bool succeeded = true;
    final expansions = _campaign.expansions;
    for (final player in players) {
      if (player.canLevelUpWithoutUserSelectionToLevel(level,
          expansions: expansions)) {
        player.evolveRoverClassToLevel(level, expansions: expansions);
      } else {
        succeeded = false;
      }
    }
    _onStateChanged();
    return succeeded;
  }

  List<RoverClass> evolutionsForPlayer(Player player) {
    final campaign = CampaignModel.instance.campaign;
    final level = campaign.roversLevel;
    var stage = roverEvolutionStageForLevel(level);
    switch (stage) {
      case RoverEvolutionStage.base:
      case RoverEvolutionStage.prime:
        break;
      case RoverEvolutionStage.apex:
        if (player.primeClassName == null) {
          stage = RoverEvolutionStage.prime;
        }
        break;
    }
    return _campaignDefinition.evolutionsForBaseClass(player.baseClassName,
        primeClassName: player.primeClassName,
        stage: stage,
        expansions: campaign.expansions);
  }

  void levelUpToClass(Player player, {required RoverClass levelUpClass}) {
    player.evolveToClass(levelUpClass);
    player.evolveRoverClassToLevel(_campaign.roversLevel,
        expansions: _campaign.expansions);
    _onStateChanged();
  }

  bool usesClassesFromExpansion(String expansion) {
    return (players + inactivePlayers).any((p) =>
        p.roverClass.expansion == expansion ||
        p.primeClass?.expansion == expansion ||
        p.apexClass?.expansion == expansion);
  }

  bool get hasPendingLevelUp => players.any((p) => p.hasPendingLevelUp);

  bool get hasPendingUserInput =>
      players.any((p) => p.hasPendingLevelUp || p.hasPendingTrait);

  bool canLevelUpWithoutUserSelectionToLevel(int level) {
    return players.every((p) => p.canLevelUpWithoutUserSelectionToLevel(level,
        expansions: _campaign.expansions));
  }

  void resetEvolutionOfPlayer(Player player) {
    final traitsToRemove = [];
    if (player.apexClassName != null) {
      traitsToRemove.addAll(player.apexClass?.traits ?? []);
      player.apexClassName = null;
    }
    if (player.primeClassName != null) {
      traitsToRemove.addAll(player.primeClass?.traits ?? []);
      player.primeClassName = null;
    }
    for (final trait in traitsToRemove) {
      if (player.traits.contains(trait.name)) {
        removeTrait(player: player, trait: trait.name);
      }
    }
    _onStateChanged();
  }

  int slotCountForPlayer(Player player, {required ItemSlotType slotType}) {
    final traits = PlayersModel.instance.traitsForPlayer(player);
    final additionalSlots = traits
        .expand((t) => t.additionalSlots)
        .where((s) => s == slotType)
        .length;
    return player.baseSlotsForSlotType(slotType) + additionalSlots;
  }

  void _onTraitRemoved(Player player) {
    final items = player.equippedItems(items: _campaignDefinition.items);
    for (var slotType in [
      ItemSlotType.head,
      ItemSlotType.hand,
      ItemSlotType.body,
      ItemSlotType.foot,
      ItemSlotType.pocket
    ]) {
      final slotItems = items.where((e) => e.slotType == slotType).toList();
      final count = ItemsModel.instance
          .availableSlots(player: player, slotType: slotType);
      if (count < 0) {
        var deficit = count;
        while (deficit < 0 && slotItems.isNotEmpty) {
          final item = slotItems.removeLast();
          player.unequipItem(item);
          deficit += item.slotCount;
        }
      }
    }
  }

  List<RoverClass> classesForLevel(int level) {
    CampaignDef campaign = PlayersModel.instance._campaignDefinition;
    return campaign.classesForLevel(level, expansions: _campaign.expansions);
  }
}

extension PlayerConvenience on Player {
  RoverClass get roverClass {
    CampaignDef campaign = PlayersModel.instance._campaignDefinition;
    final apexName = apexClassName;
    if (apexName != null) {
      return campaign.getClass(className: apexName);
    }
    final primeName = primeClassName;
    if (primeName != null) {
      return campaign.getClass(className: primeName);
    }
    return campaign.getClass(className: baseClassName);
  }

  RoverEvolutionStage? get nextEvolutionStage {
    if (primeClassName == null) {
      return RoverEvolutionStage.prime;
    } else if (apexClassName == null) {
      return RoverEvolutionStage.apex;
    } else {
      return null;
    }
  }

  bool canLevelUpWithoutUserSelectionToLevel(int level,
      {required List<String> expansions}) {
    final currentStage = roverClass.evolutionStage;
    final nextStage = roverEvolutionStageForLevel(level);
    if (currentStage == nextStage) {
      return true;
    }
    final classes = PlayersModel.instance._campaignDefinition
        .evolutionsForBaseClassAtLevel(baseClassName,
            primeClassName: primeClassName,
            level: level,
            expansions: expansions);
    return classes.length == 1;
  }

  void evolveToClass(RoverClass roverClass) {
    final stage = roverClass.evolutionStage;
    switch (stage) {
      case RoverEvolutionStage.prime:
        primeClassName = roverClass.name;
      case RoverEvolutionStage.apex:
        primeClassName ??= roverClass.prime;
        apexClassName = roverClass.name;
      case RoverEvolutionStage.base:
        assert(baseClassName == roverClass.name);
    }
  }

  bool evolveRoverClassToLevel(int level, {required List<String> expansions}) {
    final classes = PlayersModel.instance._campaignDefinition
        .evolutionsForBaseClassAtLevel(baseClassName,
            primeClassName: primeClassName,
            level: level,
            expansions: expansions);
    if (classes.length != 1) {
      return false;
    }
    final classForLevel = classes.first;
    switch (classForLevel.evolutionStage) {
      case RoverEvolutionStage.prime:
        primeClassName = classForLevel.name;
      case RoverEvolutionStage.apex:
        if (primeClassName == null) {
          return false;
        }
        apexClassName = classForLevel.name;
      case RoverEvolutionStage.base:
        assert(baseClassName == classForLevel.name);
    }
    return true;
  }

  int get sharedLyst {
    return PlayersModel.instance._campaign.lyst;
  }

  List<(ItemDef, bool)> get items {
    final model = PlayersModel.instance;
    final equippedItemsCopy =
        equippedItems(items: PlayersModel.instance._campaignDefinition.items);
    return itemNames.map((e) {
      final item = model._campaignDefinition.itemForName(e);
      final equipped = equippedItemsCopy.any((e) => e.name == item.name);
      if (equipped) {
        equippedItemsCopy.removeWhere((element) => element.name == item.name);
      }
      return (item, equipped);
    }).toList();
  }

  RoverClass? get primeClass {
    final name = primeClassName;
    if (name == null) {
      return null;
    }
    return PlayersModel.instance._campaignDefinition.getClass(className: name);
  }

  RoverClass? get apexClass {
    final name = apexClassName;
    if (name == null) {
      return null;
    }
    return PlayersModel.instance._campaignDefinition.getClass(className: name);
  }

  bool get hasPendingLevelUp {
    final level = PlayersModel.instance._campaign.roversLevel;
    final stage = roverEvolutionStageForLevel(level);
    switch (stage) {
      case RoverEvolutionStage.base:
        return false;
      case RoverEvolutionStage.prime:
        return primeClassName == null;
      case RoverEvolutionStage.apex:
        return apexClassName == null || primeClassName == null;
    }
  }

  bool get hasPendingTrait =>
      CampaignModel.instance.campaign.traitsCount > traits.length;
}

extension RoverClassConvenience on RoverClass {
  RoverClass get baseClass {
    return PlayersModel.instance._campaignDefinition
        .getBaseClass(className: name);
  }

  String get posterAsset {
    final definition = PlayersModel.instance._campaignDefinition;
    final roverClass = definition.getClass(className: name);
    return definition.pathForImage(
        type: CampaignAssetType.rover,
        src: roverClass.imageSrc,
        expansion: roverClass.expansion);
  }

  String get iconAsset {
    final definition = PlayersModel.instance._campaignDefinition;
    final roverClass = definition.getClass(className: name);
    return definition.pathForImage(
        type: CampaignAssetType.rover,
        src: roverClass.iconSrc,
        expansion: roverClass.expansion);
  }

  summonAssetForName(String name, {String? expansion}) {
    return PlayersModel.instance._campaignDefinition.pathForImage(
        type: CampaignAssetType.summon,
        src: summonSrc(name),
        expansion: expansion);
  }
}
