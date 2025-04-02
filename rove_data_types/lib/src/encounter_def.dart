import 'dart:math';

import 'package:collection/collection.dart';
import 'package:meta/meta.dart';
import 'package:rove_data_types/src/actions/encounter_action.dart';
import 'package:rove_data_types/src/ally_def.dart';
import 'package:rove_data_types/src/campaign_milestone.dart';
import 'package:rove_data_types/src/encounter_tracker_event_def.dart';
import 'package:rove_data_types/src/encounter_dialog_def.dart';
import 'package:rove_data_types/src/encounter_figure_def.dart';
import 'package:rove_data_types/src/placement_def.dart';
import 'package:rove_data_types/src/placement_group_def.dart';
import 'package:rove_data_types/src/ether.dart';
import 'package:rove_data_types/src/map_def.dart';
import 'package:rove_data_types/src/utils/json_utils.dart';
import 'package:rove_data_types/src/utils/vector_utils.dart';

enum EncounterStatus { available, locked, completed }

enum RoundPhase {
  rover,
  adversary,
  extra;

  String label({String extraPhaseName = 'Extra'}) {
    switch (this) {
      case RoundPhase.rover:
        return 'Rover';
      case RoundPhase.adversary:
        return 'Adversary';
      case RoundPhase.extra:
        return extraPhaseName;
    }
  }

  factory RoundPhase.fromName(String name) {
    return RoundPhase.values.firstWhere((e) => e.name == name);
  }

  factory RoundPhase.fromJson(String json) {
    return RoundPhase.fromName(json);
  }

  toJson() {
    return name;
  }
}

typedef Faction = RoundPhase;

@immutable
class EncounterDef {
  // Use these to identify unique encounter logic.
  static const String encounter2dot4 = '2.4';
  static const String encounter3dot4 = '3.4';
  static const String encounterIdot2 = 'I.2';
  static const String encounter4dot5 = '4.5';
  static const String encounter5dot4 = '5.4';
  static const String encounter6dot3 = '6.3';
  static const String encounter6dot5 = '6.5';
  static const String encounter7dot3 = '7.3';
  static const String encounter8dot4 = '8.4';
  static const String encounter8dot5 = '8.5';
  static const String encounter9dot3 = '9.3';
  static const String encounter9dot6 = '9.6';
  static const String encounter10dot5 = '10_act1.5';
  static const String encounter10dot10 = '10_act2.10';

  static const int noRoundLimit = 99;

  final String? expansion;
  final String questId;
  final String number;
  final String title;
  final String victoryDescription;
  final String? lossDescription;
  final MapDef startingMap;
  final int roundLimit;
  final List<String> challenges;
  final int baseLystReward;
  final List<String> itemRewards;
  final List<Ether> etherRewards;
  final int unlocksShopLevel;
  final String? stashReward;
  final int unlocksRoverLevel;
  final bool unlocksTrait;
  final String? milestone;
  final String? campaignLink;
  final String? extraPhase;
  final int? extraPhaseIndex;
  final List<String> _playerPossibleTokens;
  final List<EncounterTrackerEventDef> _trackerEvents;
  final List<AllyDef> allies;
  final List<EncounterFigureDef> overlays;
  final List<EncounterFigureDef> adversaries;
  final List<PlacementDef> placements;
  final List<PlacementGroupDef> placementGroups;
  final List<EncounterDialogDef> dialogs;
  final List<EncounterAction> onLoad;
  final List<EncounterAction> onDidStartPhase;
  final List<EncounterAction> onDidStartRound;
  final List<EncounterAction> onOccupiedSpace;
  final List<EncounterAction> onWillEndPhase;
  final List<EncounterAction> onWillEndRound;
  final Map<String, List<EncounterAction>> onDraw;
  final Map<String, List<EncounterAction>> onMilestone;
  final List<EncounterAction> onFailure;

  static const _defaultBaseLystReward = 0;
  static const _defaultUnlocksShopLevel = 0;
  static const _defaultUnlocksRoverLevel = 0;
  EncounterDef({
    this.expansion,
    required this.questId,
    required this.number,
    required this.title,
    required this.victoryDescription,
    this.lossDescription,
    required this.startingMap,
    required this.roundLimit,
    this.challenges = const [],
    this.baseLystReward = _defaultBaseLystReward,
    this.itemRewards = const [],
    this.etherRewards = const [],
    this.unlocksShopLevel = _defaultUnlocksShopLevel,
    this.stashReward,
    this.unlocksRoverLevel = _defaultUnlocksRoverLevel,
    this.unlocksTrait = false,
    this.milestone,
    this.campaignLink,
    this.extraPhase,
    this.extraPhaseIndex,
    List<String> playerPossibleTokens = const [],
    trackerEvents = const <EncounterTrackerEventDef>[],
    this.allies = const [],
    this.overlays = const [],
    this.adversaries = const [],
    this.placements = const [],
    this.placementGroups = const [],
    this.dialogs = const [],
    this.onLoad = const [],
    this.onDidStartPhase = const [],
    this.onDidStartRound = const [],
    this.onOccupiedSpace = const [],
    this.onWillEndPhase = const [],
    this.onWillEndRound = const [],
    this.onDraw = const {},
    this.onMilestone = const {},
    this.onFailure = const [],
  })  : _playerPossibleTokens = playerPossibleTokens.toList(),
        _trackerEvents = trackerEvents;

  static List<PlacementDef> _placementsFromJson(Map<String, dynamic> json) {
    if (!json.containsKey('placements')) {
      return [];
    }
    final placementsJson = json['placements'];
    if (placementsJson is List<dynamic>) {
      return placementsJson
          .map((e) => PlacementDef.fromJson(e as Map<String, dynamic>))
          .toList();
    } else if (placementsJson is Map<String, dynamic>) {
      return placementsJson.entries.map((e) {
        final coordinate = parseCoordinate(e.key);
        return PlacementDef.fromCoordinateAndJson(
            coordinate.$1, coordinate.$2, e.value);
      }).toList();
    }
    throw UnsupportedError('Invalid placements json: $placementsJson');
  }

  factory EncounterDef.fromJson(
      {String? questId, required Map<String, dynamic> json}) {
    final List<String> challenges = json.containsKey('challenges')
        ? (json['challenges'] as List<dynamic>).map((e) => e as String).toList()
        : [];
    final rewards = json['rewards'] ?? {};
    final lystReward = rewards['lyst'] as int? ?? _defaultBaseLystReward;
    final List<String> itemRewards = rewards.containsKey('items')
        ? (rewards['items'] as List<dynamic>).map((e) => e as String).toList()
        : [];
    final List<Ether> etherRewards = rewards.containsKey('ether')
        ? (rewards['ether'] as List<dynamic>)
            .map((e) => Ether.fromJson(e as String))
            .toList()
        : [];

    final unlocksShopLevel = rewards.containsKey('shop_level')
        ? rewards['shop_level'] as int
        : _defaultUnlocksShopLevel;
    final stashReward = rewards['stash'] as String?;
    final unlocksRoverLevel =
        rewards.containsKey('rover_level') ? rewards['rover_level'] as int : 0;
    final unlocksTrait = rewards['trait'] as bool? ?? false;
    final List<EncounterTrackerEventDef> codices = json.containsKey('codices')
        ? (json['codices'] as List<dynamic>)
            .map((e) => EncounterTrackerEventDef.fromJson(e))
            .toList()
        : [];
    final milestone = rewards['milestone'] as String?;
    final campaignLink = rewards['campaign_link'] as String?;

    return EncounterDef(
      expansion: json['expansion'] as String?,
      questId: questId ?? json['quest_id'] as String,
      number: json['number'] as String,
      title: json['title'] as String,
      victoryDescription: json['objective'] ?? json['victory'] ?? '',
      lossDescription: json['loss'] as String?,
      roundLimit: json['round_limit'] ?? noRoundLimit,
      challenges: challenges,
      baseLystReward: lystReward,
      itemRewards: itemRewards,
      etherRewards: etherRewards,
      unlocksShopLevel: unlocksShopLevel,
      stashReward: stashReward,
      unlocksRoverLevel: unlocksRoverLevel,
      unlocksTrait: unlocksTrait,
      milestone: milestone,
      campaignLink: campaignLink,
      extraPhase: json['extra_phase'] as String?,
      extraPhaseIndex: json['extra_phase_index'] as int?,
      playerPossibleTokens:
          json['player_possible_tokens'] as List<String>? ?? [],
      trackerEvents: codices,
      allies: decodeJsonListNamed('allies', json, (e) => AllyDef.fromJson(e)),
      adversaries: decodeJsonListNamed(
          'adversaries', json, (e) => EncounterFigureDef.fromJson(e)),
      overlays: decodeJsonListNamed(
          'overlays', json, (e) => EncounterFigureDef.fromJson(e)),
      startingMap: json.containsKey('starting_map')
          ? MapDef.fromJson(json['starting_map'] as Map<String, dynamic>)
          : MapDef.empty(),
      placements: _placementsFromJson(json),
      placementGroups: [
        ...decodeJsonListNamed(
            'triggers', json, (e) => PlacementGroupDef.fromJson(e)),
        ...decodeJsonListNamed(
            'placement_groups', json, (e) => PlacementGroupDef.fromJson(e))
      ],
      dialogs: decodeJsonListNamed(
          'dialogs', json, (e) => EncounterDialogDef.fromJson(e)),
      onLoad: decodeJsonListNamed(
          'on_load', json, (e) => EncounterAction.fromJson(e)),
      onOccupiedSpace: decodeJsonListNamed(
          'on_ocuppied_space', json, (e) => EncounterAction.fromJson(e)),
      onDidStartPhase: decodeJsonListNamed(
          'on_did_start_phase', json, (e) => EncounterAction.fromJson(e)),
      onDidStartRound: decodeJsonListNamed(
          'on_did_start_round', json, (e) => EncounterAction.fromJson(e)),
      onWillEndPhase: decodeJsonListNamed(
          'on_will_end_phase', json, (e) => EncounterAction.fromJson(e)),
      onWillEndRound: decodeJsonListNamed(
          'on_will_end_round', json, (e) => EncounterAction.fromJson(e)),
      onDraw: actionMapFromJson('on_draw', json),
      onMilestone: actionMapFromJson('on_milestone', json),
      onFailure: decodeJsonListNamed(
          'on_failure', json, (e) => EncounterAction.fromJson(e)),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'expansion': expansion,
      'quest_id': questId,
      'number': number,
      'title': title,
      'victory': victoryDescription,
      if (lossDescription case final value?) 'loss': value,
      'starting_map': startingMap.toJson(),
      'round_limit': roundLimit,
      if (challenges.isNotEmpty) 'challenges': challenges,
      'rewards': {
        if (baseLystReward != _defaultBaseLystReward) 'lyst': baseLystReward,
        if (itemRewards.isNotEmpty) 'items': itemRewards,
        if (etherRewards.isNotEmpty)
          'ether': etherRewards.map((e) => e.toJson()).toList(),
        if (unlocksShopLevel != _defaultUnlocksShopLevel)
          'shop_level': unlocksShopLevel,
        if (stashReward case final value?) 'stash': value,
        if (unlocksRoverLevel != _defaultUnlocksRoverLevel)
          'rover_level': unlocksRoverLevel,
        if (unlocksTrait) 'trait': unlocksTrait,
        if (milestone case final value?) 'milestone': value,
        if (campaignLink case final value?) 'campaign_link': value,
      },
      if (extraPhase case final value?) 'extra_phase': value,
      if (extraPhaseIndex case final value?) 'extra_phase_index': value,
      if (_playerPossibleTokens.isNotEmpty)
        'player_possible_tokens': _playerPossibleTokens,
      if (_trackerEvents.isNotEmpty)
        'codices': _trackerEvents.map((c) => c.toJson()).toList(),
      if (allies.isNotEmpty) 'allies': allies.map((a) => a.toJson()).toList(),
      if (adversaries.isNotEmpty)
        'adversaries': adversaries.map((a) => a.toJson()).toList(),
      if (overlays.isNotEmpty)
        'overlays': overlays.map((a) => a.toJson()).toList(),
      if (placements.isNotEmpty)
        'placements': Map.fromEntries(placements.map((p) => MapEntry(
            coordinateToString((p.c, p.r)),
            p.toJson(excludeCoordinate: true)))),
      if (placementGroups.isNotEmpty)
        'placement_groups': placementGroups.map((t) => t.toJson()).toList(),
      if (dialogs.isNotEmpty)
        'dialogs': dialogs.map((d) => d.toJson()).toList(),
      if (onLoad.isNotEmpty) 'on_load': onLoad.map((a) => a.toJson()).toList(),
      if (onDidStartPhase.isNotEmpty)
        'on_did_start_phase': onDidStartPhase.map((a) => a.toJson()).toList(),
      if (onDidStartRound.isNotEmpty)
        'on_did_start_round': onDidStartRound.map((a) => a.toJson()).toList(),
      if (onOccupiedSpace.isNotEmpty)
        'on_ocuppied_space': onOccupiedSpace.map((a) => a.toJson()).toList(),
      if (onWillEndPhase.isNotEmpty)
        'on_will_end_phase': onWillEndPhase.map((a) => a.toJson()).toList(),
      if (onWillEndRound.isNotEmpty)
        'on_will_end_round': onWillEndRound.map((a) => a.toJson()).toList(),
      if (onDraw.isNotEmpty) 'on_draw': actionMapToJson(onMilestone),
      if (onMilestone.isNotEmpty) 'on_milestone': actionMapToJson(onMilestone),
      if (onFailure.isNotEmpty)
        'on_failure': onFailure.map((a) => a.toJson()).toList(),
    };
  }

  String get id => '$questId.$number';

  List<EncounterTrackerEventDef> get publicTrackerEvents =>
      _trackerEvents.where((e) => !e.internal).toList();

  List<EncounterTrackerEventDef> get internalAndPublicTrackerEvents =>
      _trackerEvents.toList();

  EncounterTrackerEventDef? trackerEventWithTitle(String title) =>
      _trackerEvents.firstWhereOrNull((c) => c.title == title);

  PlacementGroupDef? placementGroupWithName(String name) =>
      placementGroups.firstWhereOrNull((t) => t.name == name);

  bool get hasReward {
    return baseLystReward > 0 ||
        itemRewards.isNotEmpty ||
        etherRewards.isNotEmpty ||
        unlocksShopLevel > 0 ||
        stashReward != null ||
        unlocksRoverLevel > 0 ||
        unlocksTrait ||
        milestone != null &&
            !CampaignMilestone.internalMilestones.contains(milestone) ||
        campaignLink?.isNotEmpty == true;
  }

  List<RoundPhase> get phases {
    final phases = [RoundPhase.rover, RoundPhase.adversary];
    if (extraPhase != null) {
      final index = max(extraPhaseIndex ?? phases.length, phases.length);
      phases.insert(index, RoundPhase.extra);
    }
    return phases;
  }

  String nameForPhase(RoundPhase phase) {
    switch (phase) {
      case RoundPhase.rover:
        return 'Rover';
      case RoundPhase.adversary:
        return 'Adversary';
      case RoundPhase.extra:
        return extraPhase ?? 'Extra';
    }
  }

  bool get isIntermission => questId.startsWith('I');

  EncounterDialogDef dialogForTitle(String s) {
    return dialogs.firstWhere((d) => d.title == s);
  }

  List<String> playerPossibleTokensForPlayerCount(int playerCount) {
    return _playerPossibleTokens.expand((e) {
      if (e.startsWith(EncounterFigureDef.tokenPerRoverPrefix)) {
        final token =
            e.substring(EncounterFigureDef.tokenPerRoverPrefix.length);
        return List.generate(playerCount, (_) => token);
      }
      return [e];
    }).toList();
  }

  Set<String> get referencedEntities {
    final classesEntities = <String>{
      ...allies.map((a) => a.name),
      ...overlays.map((a) => a.name),
      ...adversaries.map((a) => a.name)
    };
    final placementEntities = placements.map((p) => p.name).toSet();
    final entitiesFromPlacementGroups =
        placementGroups.map((t) => t.referencedEntities).flattened;
    return {
      ...classesEntities,
      ...placementEntities,
      ...entitiesFromPlacementGroups
    };
  }

  Set<String> get referencedItems {
    final eventReferences = [
      ...onDidStartRound,
      ...onOccupiedSpace,
      ...onWillEndRound,
      ...onWillEndPhase,
      ...onMilestone.values.flattened
    ]
        .where((a) => a.type == EncounterActionType.rewardItem)
        .map((a) => a.value)
        .toSet();

    final classesReferences = [
      ...allies.expand((a) => a.behaviors),
      ...overlays,
      ...adversaries
    ].map((p) => p.referencedItems);
    final placementReferences = placements.map((p) => p.referencedItems);
    final referencesFromPlacementGroups =
        placementGroups.map((t) => t.referencedItems);
    return {
      ...eventReferences,
      ...classesReferences.flattened,
      ...placementReferences.flattened,
      ...referencesFromPlacementGroups.flattened
    };
  }
}
