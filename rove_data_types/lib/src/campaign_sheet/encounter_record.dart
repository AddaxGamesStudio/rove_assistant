import 'package:rove_data_types/src/campaign_sheet/player.dart';
import 'package:rove_data_types/src/utils/json_utils.dart';

_keyForPlayer(Player player) {
  return player.baseClassName;
}

class EncounterRecord {
  final String encounterId;
  final bool complete;
  final List<int> completedChallenges;
  final List<String> campaignMilestones;
  final List<(String, String, bool)> itemRewards;
  final Map<String, List<String>> consumedItems;
  final Map<String, int> adversaries;

  EncounterRecord({
    required this.encounterId,
    this.complete = false,
    this.completedChallenges = const [],
    this.campaignMilestones = const [],
    this.itemRewards = const [],
    this.consumedItems = const {},
    this.adversaries = const {},
  });

  factory EncounterRecord.fromJson(Map<String, dynamic> json) {
    return EncounterRecord(
      encounterId: json['encounter_id'] as String,
      complete: json.containsKey('complete') ? json['complete'] as bool : false,
      completedChallenges:
          decodeJsonListNamed('completed_challenges', json, (e) => e as int),
      campaignMilestones:
          decodeJsonListNamed('milestones', json, (e) => e as String),
      itemRewards: decodeJsonListNamed(
          'item_rewards',
          json,
          (e) => (
                e['player'] as String,
                e['item'] as String,
                e['equipped'] as bool
              )),
      consumedItems: mapFromJson('consumed_items', json,
          (value) => (value as List<dynamic>).map((e) => e as String).toList()),
      adversaries: mapFromJson('adversaries', json, (value) => value as int),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'encounter_id': encounterId,
      if (complete) 'complete': complete,
      if (completedChallenges.isNotEmpty)
        'completed_challenges': completedChallenges,
      if (campaignMilestones.isNotEmpty) 'milestones': campaignMilestones,
      if (itemRewards.isNotEmpty)
        'item_rewards': itemRewards
            .map((reward) => {
                  'player': reward.$1,
                  'item': reward.$2,
                  'equipped': reward.$3,
                })
            .toList(),
      if (consumedItems.isNotEmpty) 'consumed_items': consumedItems,
      if (adversaries.isNotEmpty) 'adversaries': adversaries,
    };
  }

  String get questId {
    return encounterId.split('.').first;
  }

  List<String> rewardedItemsForPlayer(Player player) {
    return itemRewards
        .where((reward) => reward.$1 == _keyForPlayer(player))
        .map((reward) => reward.$2)
        .toList();
  }

  List<String> consumedItemsForPlayer(Player player) {
    return consumedItems.containsKey(_keyForPlayer(player))
        ? consumedItems[_keyForPlayer(player)]!.toList()
        : [];
  }

  List<String> unconsumedRewardedItemsForPlayer(Player player) {
    final consumedItems = consumedItemsForPlayer(player);
    final key = _keyForPlayer(player);
    return itemRewards
        .where((reward) => reward.$1 == key)
        .map((reward) => reward.$2)
        .map((item) {
          final bool consumed = consumedItems.contains(item);
          if (consumed) {
            consumedItems.remove(item);
          }
          return (item, consumed);
        })
        .where((o) => !o.$2) // Remove consumed items
        .map((o) => o.$1)
        .toList();
  }
}
