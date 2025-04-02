import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:rove_data_types/rove_data_types.dart';
import 'package:rove_app_common/model/items_model.dart';
import 'package:rove_app_common/model/players_model.dart';

mixin CampaignPersistor {
  Future<void> saveCampaign(Campaign campaign);
  Future<void> deleteCampaign(Campaign campaign);
  Campaign? get currentCampaign;
  List<Campaign> get allCampaigns;
}

class CampaignModel extends ChangeNotifier {
  CampaignModel._privateConstructor();

  final ValueNotifier<String> lastEncounterCompleted =
      ValueNotifier<String>("");

  static final CampaignModel _instance = CampaignModel._privateConstructor();

  static CampaignModel get instance => _instance;

  late CampaignPersistor _persistor;
  CampaignDef? _campaignDefinition;
  Campaign? __campaign;
  List<Campaign> _campaigns = [];
  bool _promptShop = false;

  Campaign get _campaign {
    assert(__campaign != null);
    return __campaign!;
  }

  List<Player> get _players {
    return PlayersModel.instance.players;
  }

  load(CampaignDef definition, CampaignPersistor persistor) {
    if (_campaignDefinition != null) {
      return;
    }

    _persistor = persistor;
    _campaignDefinition = definition;
    __campaign = persistor.currentCampaign;
    _campaigns = persistor.allCampaigns;
    if (__campaign != null) {
      _campaign._initializeNotifiers();
    }
  }

  /* Campaign management */

  List<Campaign> get campaigns {
    return _campaigns.toList();
  }

  bool get hasCurrentCampaign {
    return __campaign != null;
  }

  void setCampaign(Campaign campaign) {
    __campaign = campaign;
    _campaign._initializeNotifiers();
  }

  void newCampaign(String name,
      {bool includeXulc = false, bool skipCore = false}) {
    final c = Campaign.empty(
        name: name,
        expansions: includeXulc ? [xulcExpansionKey] : [],
        skipCore: skipCore);
    if (skipCore) {
      c.milestones.add(_milestoneForQuestCompleted('9'));
    }
    __campaign = c;
    _campaigns.add(c);
    c._initializeNotifiers();
    _onStateChanged();
  }

  void deleteCampaign(Campaign campaign) {
    _campaigns.remove(campaign);
    _persistor.deleteCampaign(campaign);
    if (__campaign == campaign) {
      __campaign = null;
    }
  }

  void importCampaign(Campaign campaign) {
    final existing = _campaigns.firstWhereOrNull((c) => c.id == campaign.id);
    if (existing != null) {
      deleteCampaign(existing);
    }
    _persistor.saveCampaign(campaign);
    _campaigns.add(campaign);
    _onStateChanged();
  }

  CampaignDef get campaignDefinition {
    if (_campaignDefinition == null) {
      throw Exception('Campaign definition not loaded yet.');
    }
    return _campaignDefinition!;
  }

  Campaign get campaign => _campaign;

  /* Assets */

  String assetForItem({required String itemName, bool back = false}) {
    final item = campaignDefinition.itemForName(itemName);
    return campaignDefinition.pathForImage(
        type: CampaignAssetType.item,
        src: back ? item.backImageSrc : item.frontImageSrc,
        expansion: item.expansion);
  }

  /* Campaign progress */

  addMilestone(String milestone) {
    _campaign.milestones.add(milestone);
    _onStateChanged();
  }

  removeMilestone(String milestone) {
    _campaign.milestones.remove(milestone);
    _onStateChanged();
  }

  bool hasMilestone(String milestone) {
    return _campaign.milestones.contains(milestone);
  }

  bool hasEncounterRecord({required String encounterId}) {
    return _campaign.hasEncounterRecord(encounterId);
  }

  EncounterRecord encounterRecordForIdOrNew({required String encounterId}) {
    final encounterState = _campaign.encounterRecordForIdOrNew(encounterId);
    if (!_campaign.hasEncounterRecord(encounterId)) {
      _campaign.setEncounterRecord(encounterState);
    }
    return encounterState;
  }

  void setEncounterState({required EncounterRecord record}) {
    _campaign.setEncounterRecord(record);
  }

  void undoEncounter(String encounterId) {
    final record = _campaign.encounterRecordForId(encounterId);
    if (record == null) {
      return;
    }
    for (String milestone in record.campaignMilestones) {
      _campaign.milestones.remove(milestone);
    }
    final freshRecord = EncounterRecord(encounterId: encounterId);
    _campaign.setEncounterRecord(freshRecord);
    _onStateChanged();
  }

  void completeEncounter(
      {required EncounterRecord record, EncounterDef? encounter}) {
    for (Player player in _players) {
      final roverClass = player.roverClass.baseClass;
      final roverClassName = roverClass.name;

      if (record.encounterId != EncounterDef.encounterIdot2) {
        record.consumedItemsForPlayer(player).forEach((itemName) {
          ItemsModel.instance
              .consumeItem(baseClassName: roverClassName, itemName: itemName);
        });

        record.unconsumedRewardedItemsForPlayer(player).forEach((itemName) {
          ItemsModel.instance
              .giveItem(className: roverClassName, itemName: itemName);
        });
      }
    }

    for (var milestone in record.campaignMilestones) {
      _campaign.milestones.add(milestone);
      if (milestone == XulcExpansion.curedMilestone) {
        PlayersModel.instance.removeXulcTraits();
      }
    }

    if (encounter != null) {
      _campaign.etherNamesForNextEncounter =
          record.rewardedEtherNames(encounterDef: encounter);
    }

    _campaign.setEncounterRecord(record);
    lastEncounterCompleted.value = record.encounterId;

    if (campaignDefinition.questForId(record.questId).isCompleted) {
      _campaign.milestones.add(_milestoneForQuestCompleted(record.questId));
    }

    for (final entry in record.adversaries.entries) {
      final adversaryName = entry.key;
      final slainCount = entry.value;
      _campaign.updateAdversaryRecord(
          encounterId: record.encounterId,
          name: adversaryName,
          slainCount: slainCount);
    }

    _onStateChanged();
  }

  String _milestoneForQuestCompleted(String questId) {
    return 'quest_${questId}_complete';
  }

  void setPartyName(String value) {
    _campaign.name = value;
    _onStateChanged();
  }

  /* Shop */

  bool get promptShop => _promptShop;

  void setShopLevel(int level) {
    if (level > 0) {
      _promptShop = true;
    }
    _campaign.merchantLevel = level;
    _onStateChanged();
  }

  onVisitedShop() {
    _promptShop = false;
    _onStateChanged();
  }

  void addShopStash(String stash) {
    if (_campaign.unlockedStashes.contains(stash)) {
      return;
    }
    _promptShop = true;
    _campaign.unlockedStashes.add(stash);
    _onStateChanged();
  }

  bool get shopUnlocked =>
      _campaign.merchantLevel > 0 &&
      (![CampaignMilestone.milestone9dot6, CampaignMilestone.milestone10dot1]
              .any((m) => hasMilestone(m)) ||
          hasMilestone(CampaignMilestone.milestone10dot3));

  bool setRoversLevel(int level) {
    _campaign.roversLevel = level;
    final succeeded = PlayersModel.instance.levelUpToLevel(level);
    _onStateChanged();
    return succeeded;
  }

  void addTrait() {
    _campaign.traitsCount++;
    _onStateChanged();
  }

  _onStateChanged() {
    saveCampaign();
    notifyListeners();
  }

  saveCampaign() {
    if (__campaign == null) {
      return;
    }
    _persistor.saveCampaign(_campaign);
  }

  List<QuestDef> get quests {
    final expansions = _campaign.expansions;
    final skipCore = _campaign.skipCore;
    return campaignDefinition.quests
        .where((q) => skipCore && q.expansion != null || !skipCore || debugMode)
        .where((q) =>
            q.expansion == null ||
            expansions.contains(q.expansion?.toLowerCase()))
        .toList();
  }

  /* Expansions */

  void toggleExpansion(String expansion) {
    if (_campaign.expansions.contains(expansion)) {
      _campaign.removeExpansion(expansion);
    } else {
      _campaign.addExpansion(expansion);
    }
    _onStateChanged();
  }

  bool usesContentFromExpansion(String expansion) {
    expansion = expansion.toLowerCase();
    final expansionIds = _campaignDefinition?.quests
        .where((q) => q.expansion == expansion)
        .expand((q) => q.encounters)
        .map((e) => e.id);
    return expansionIds?.any((encounterId) =>
                hasEncounterRecord(encounterId: encounterId)) ==
            true ||
        PlayersModel.instance.usesClassesFromExpansion(expansion);
  }

  /* Bestiary */
  AdversaryRecord? recordOfAdversaryNamed(String name) {
    return _campaign.recordOfAdversaryNamed(name);
  }

  /* Settings */

  set debugMode(bool value) {
    _campaign.debugMode = value;
    _onStateChanged();
  }

  bool get debugMode => _campaign.debugMode;
}

/* Convenience extensions */

extension CampaignDefinitionConvenience on CampaignDef {
  List<RoverClass> get currentClasses {
    final campaign = CampaignModel.instance._campaign;
    return classesForLevel(campaign.roversLevel,
        expansions: campaign.expansions);
  }
}

extension CampaignConvenience on Campaign {
  List<QuestDef> get completedQuests {
    return CampaignModel.instance.campaignDefinition.quests
        .where((element) => element.isCompleted)
        .toList();
  }

  void _initializeNotifiers() {
    ItemsModel.instance.lystNotifier.value = lyst;
    CampaignModel.instance.lastEncounterCompleted.value = "";
  }
}

extension QuestDefinitionConvenience on QuestDef {
  EncounterStatus statusForEncounter(String encounterId) {
    if (isCompletedForEncounter(encounterId)) {
      return EncounterStatus.completed;
    }
    if (isAvailableForEncounter(encounterId)) {
      return EncounterStatus.available;
    }
    if (CampaignModel.instance.debugMode) {
      return EncounterStatus.available;
    }
    return EncounterStatus.locked;
  }

  bool isCompletedForEncounter(String encounterId) {
    return CampaignModel.instance._campaign
        .isCompletedForEncounter(encounterId);
  }

  bool isAvailableForEncounter(String encounterId) {
    final model = CampaignModel.instance;
    final questStatus = status;
    if (questStatus != QuestStatus.available &&
        questStatus != QuestStatus.inProgress) {
      return false;
    }

    final encounter = encounterForId(encounterId);
    assert(encounter != null);
    if (encounter == null) {
      return false;
    }

    final requiresQuest = encounter.requiresQuest;
    if (requiresQuest != null &&
        !model._campaign.isCompletedForQuest(requiresQuest)) {
      return false;
    }

    final encounterCompletedAny = encounter.encounterCompletedAny;
    if (encounterCompletedAny.isNotEmpty) {
      final matches = encounterCompletedAny.any((id) {
        return model._campaign.isCompletedForEncounter(id);
      });
      if (!matches) {
        return false;
      }
    }

    final encounterCompletedAll = encounter.encounterCompletedAll;
    if (encounterCompletedAll.isNotEmpty) {
      final matches = encounterCompletedAll.every((id) {
        return model._campaign.isCompletedForEncounter(id);
      });
      if (!matches) {
        return false;
      }
    }

    final encounterCompletedNone = encounter.encounterCompletedNone;
    if (encounterCompletedNone.isNotEmpty) {
      final matches = !encounterCompletedNone.any((id) {
        return model._campaign.isCompletedForEncounter(id);
      });
      if (!matches) {
        return false;
      }
    }

    final encounterCompletedNotAll = encounter.encounterCompletedNotAll;
    if (encounterCompletedNotAll.isNotEmpty) {
      final matches = encounterCompletedNotAll.where((id) {
            return model._campaign.isCompletedForEncounter(id);
          }).length !=
          encounterCompletedNotAll.length;
      if (!matches) {
        return false;
      }
    }

    return true;
  }

  QuestStatus get status {
    if (isCompleted) {
      return QuestStatus.completed;
    }
    if (isInProgress) {
      return QuestStatus.inProgress;
    }
    if (CampaignModel.instance.debugMode) {
      return QuestStatus.available;
    }
    if (isBlocked) {
      return QuestStatus.blocked;
    }
    if (isLocked) {
      return QuestStatus.locked;
    }
    return QuestStatus.available;
  }

  bool get isCompleted {
    final model = CampaignModel.instance;
    final campaign = model._campaign;
    final last = encounters.last;
    return campaign.isCompletedForEncounter(last.id) ||
        model.hasMilestone(model._milestoneForQuestCompleted(id));
  }

  bool get isInProgress {
    final campaign = CampaignModel.instance._campaign;
    return encounters.any((encounter) {
          return campaign.isCompletedForEncounter(encounter.id);
        }) &&
        !isCompleted;
  }

  bool get isBlocked {
    final campaign = CampaignModel.instance._campaign;
    final startedQuestIds = campaign.startedQuestIds;
    return requirements.questsStartedNone
        .any((questId) => startedQuestIds.contains(questId));
  }

  bool get isLocked {
    if (requirements.questsCompletedAny.isEmpty) return false;

    final campaign = CampaignModel.instance._campaign;
    final completedQuests = campaign.completedQuests;
    return !requirements.questsCompletedAny.any(
        (questId) => completedQuests.any((element) => element.id == questId));
  }
}

extension EncounterDefinitionConvenience on EncounterDef {
  int totalLystReward({bool achievedOneChallenge = false}) {
    final model = CampaignModel.instance;
    return (baseLystReward +
            (achievedOneChallenge ? roveChallengeRewardLyst : 0)) *
        model._players.length;
  }

  QuestDef get quest {
    return CampaignModel.instance.campaignDefinition.questForId(questId);
  }

  List<String> get extraEtherNames {
    final model = CampaignModel.instance;
    return model._campaign.etherNamesForNextEncounter;
  }
}

extension EncounterStateConvenience on EncounterRecord {
  List<String> rewardedEtherNames({required EncounterDef encounterDef}) {
    final etherNames = [...encounterDef.etherRewards.map((e) => e.label)];
    final challengesCount = completedChallenges.length;
    if (challengesCount > 1) {
      etherNames.add('Wild');
    }
    if (challengesCount > 2) {
      etherNames.add('Wild');
    }
    return etherNames;
  }
}

extension CampaignItemConvenience on ItemDef {
  bool get hasStock {
    if (isReward) {
      return isSold;
    } else {
      final campaign = CampaignModel.instance._campaign;
      return campaign.ownedStockForItem(name) < stock;
    }
  }

  int get shopStock {
    final campaign = CampaignModel.instance._campaign;
    if (isReward) {
      return campaign.countQuestItemInShop(name);
    } else {
      return stock - campaign.ownedStockForItem(name);
    }
  }

  bool get isSold {
    final campaign = CampaignModel.instance._campaign;
    return campaign.questItemsInShop.contains(name);
  }
}
