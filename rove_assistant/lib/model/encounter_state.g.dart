// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'encounter_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EncounterState _$EncounterStateFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    disallowNullValues: const ['encounter_id'],
  );
  return EncounterState(
    encounterId: json['encounter_id'] as String,
  )
    ..isStartEncounterPhase = json['is_start_encounter_phase'] as bool? ?? true
    ..round = (json['round'] as num).toInt()
    ..phase = RoundPhase.fromJson(json['phase'] as String)
    ..challenges =
        (json['challenges'] as List<dynamic>).map((e) => e as bool).toList()
    ..actionsWithKeyTriggerred =
        (json['actions_with_key_triggered'] as Map<String, dynamic>?)?.map(
              (k, e) => MapEntry(k, (e as num).toInt()),
            ) ??
            {}
    ..codicesTriggered = (json['codices'] as Map<String, dynamic>?)?.map(
          (k, e) => MapEntry(
              k,
              _$recordConvert(
                e,
                ($jsonValue) => (
                  ($jsonValue[r'$1'] as num).toInt(),
                  ($jsonValue[r'$2'] as num).toInt(),
                ),
              )),
        ) ??
        {}
    ..playersState = (json['players_state'] as Map<String, dynamic>?)?.map(
          (k, e) => MapEntry(
              k, PlayerEncounterState.fromJson(e as Map<String, dynamic>)),
        ) ??
        {}
    ..summonsHealth = (json['summons_health'] as Map<String, dynamic>?)?.map(
          (k, e) => MapEntry(k, (e as num).toInt()),
        ) ??
        {}
    ..adversariesState =
        (json['adversaries_state'] as Map<String, dynamic>?)?.map(
              (k, e) =>
                  MapEntry(k, FigureState.fromJson(e as Map<String, dynamic>)),
            ) ??
            {}
    ..alliesState = (json['allies_state'] as Map<String, dynamic>?)?.map(
          (k, e) =>
              MapEntry(k, FigureState.fromJson(e as Map<String, dynamic>)),
        ) ??
        {}
    ..replacementPlacementGroup = json['replacement_placement_group'] as String?
    ..overridePlacements = (json['override_placements'] as List<dynamic>?)
        ?.map((e) => PlacementDef.fromJson(e as Map<String, dynamic>))
        .toList()
    ..additionalPlacements = (json['additional_placements'] as List<dynamic>?)
            ?.map((e) => PlacementDef.fromJson(e as Map<String, dynamic>))
            .toList() ??
        []
    ..lystRewards = (json['lyst_rewards'] as List<dynamic>?)
            ?.map((e) => _$recordConvert(
                  e,
                  ($jsonValue) => (
                    $jsonValue[r'$1'] as String,
                    ($jsonValue[r'$2'] as num).toInt(),
                  ),
                ))
            .toList() ??
        []
    ..itemRewards = (json['item_rewards'] as List<dynamic>?)
            ?.map((e) => _$recordConvert(
                  e,
                  ($jsonValue) => (
                    $jsonValue[r'$1'] as String,
                    $jsonValue[r'$2'] as String,
                    $jsonValue[r'$3'] as bool,
                  ),
                ))
            .toList() ??
        []
    ..etherRewards = (json['ether_rewards'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList() ??
        []
    ..lootedFigures = (json['looted_figures'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList() ??
        []
    ..milestones = (json['milestones'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList() ??
        []
    ..fieldsToDraw = (json['fields_to_draw'] as List<dynamic>?)
        ?.map((e) => $enumDecode(_$EtherFieldEnumMap, e))
        .toList()
    ..subtitle = json['subtitle'] as String?
    ..complete = json['complete'] as bool? ?? false
    ..failed = json['failed'] as bool? ?? false
    ..objectiveAchieved = json['objective_achieved'] as bool? ?? false
    .._consumedItems = (json['consumed_items'] as Map<String, dynamic>?)?.map(
          (k, e) => MapEntry(
              k, (e as List<dynamic>).map((e) => e as String).toList()),
        ) ??
        {}
    .._startedRoundWithFeralBloodLust =
        json['started_round_with_feral_blood_lust'] as bool? ?? false
    ..overrideLossCondition = json['override_loss_condition'] as String?
    ..overrideRoundLimit = (json['override_round_limit'] as num?)?.toInt()
    ..overrideVictoryCondition = json['override_victory_condition'] as String?
    ..overrideMap = json['override_map'] as String?
    ..specialRules = (json['special_rules'] as List<dynamic>?)
            ?.map((e) => _$recordConvert(
                  e,
                  ($jsonValue) => (
                    $jsonValue[r'$1'] as String,
                    $jsonValue[r'$2'] as String,
                  ),
                ))
            .toList() ??
        []
    ..codexLinks = (json['codex_links'] as List<dynamic>?)
            ?.map((e) => _$recordConvert(
                  e,
                  ($jsonValue) => (
                    ($jsonValue[r'$1'] as num?)?.toInt(),
                    $jsonValue[r'$2'] as String,
                    $jsonValue[r'$3'] as String?,
                  ),
                ))
            .toList() ??
        []
    ..encounteredAdversaries =
        (json['encountered_adversaries'] as Map<String, dynamic>?)?.map(
              (k, e) => MapEntry(k, (e as num).toInt()),
            ) ??
            {};
}

Map<String, dynamic> _$EncounterStateToJson(EncounterState instance) =>
    <String, dynamic>{
      'encounter_id': instance.encounterId,
      'is_start_encounter_phase': instance.isStartEncounterPhase,
      'round': instance.round,
      'phase': instance.phase.toJson(),
      'challenges': instance.challenges,
      'actions_with_key_triggered': instance.actionsWithKeyTriggerred,
      'codices':
          instance.codicesTriggered.map((k, e) => MapEntry(k, <String, dynamic>{
                r'$1': e.$1,
                r'$2': e.$2,
              })),
      'players_state':
          instance.playersState.map((k, e) => MapEntry(k, e.toJson())),
      'summons_health': instance.summonsHealth,
      'adversaries_state':
          instance.adversariesState.map((k, e) => MapEntry(k, e.toJson())),
      'allies_state':
          instance.alliesState.map((k, e) => MapEntry(k, e.toJson())),
      'replacement_placement_group': instance.replacementPlacementGroup,
      'override_placements':
          instance.overridePlacements?.map((e) => e.toJson()).toList(),
      'additional_placements':
          instance.additionalPlacements.map((e) => e.toJson()).toList(),
      'lyst_rewards': instance.lystRewards
          .map((e) => <String, dynamic>{
                r'$1': e.$1,
                r'$2': e.$2,
              })
          .toList(),
      'item_rewards': instance.itemRewards
          .map((e) => <String, dynamic>{
                r'$1': e.$1,
                r'$2': e.$2,
                r'$3': e.$3,
              })
          .toList(),
      'ether_rewards': instance.etherRewards,
      'looted_figures': instance.lootedFigures,
      'milestones': instance.milestones,
      'fields_to_draw': instance.fieldsToDraw?.map((e) => e.toJson()).toList(),
      'subtitle': instance.subtitle,
      'complete': instance.complete,
      'failed': instance.failed,
      'objective_achieved': instance.objectiveAchieved,
      'consumed_items': instance._consumedItems,
      'started_round_with_feral_blood_lust':
          instance._startedRoundWithFeralBloodLust,
      'override_loss_condition': instance.overrideLossCondition,
      'override_round_limit': instance.overrideRoundLimit,
      'override_victory_condition': instance.overrideVictoryCondition,
      'override_map': instance.overrideMap,
      'special_rules': instance.specialRules
          .map((e) => <String, dynamic>{
                r'$1': e.$1,
                r'$2': e.$2,
              })
          .toList(),
      'codex_links': instance.codexLinks
          .map((e) => <String, dynamic>{
                r'$1': e.$1,
                r'$2': e.$2,
                r'$3': e.$3,
              })
          .toList(),
      'encountered_adversaries': instance.encounteredAdversaries,
    };

$Rec _$recordConvert<$Rec>(
  Object? value,
  $Rec Function(Map) convert,
) =>
    convert(value as Map<String, dynamic>);

const _$EtherFieldEnumMap = {
  EtherField.snapfrost: 'snapfrost',
  EtherField.wildfire: 'wildfire',
  EtherField.everbloom: 'everbloom',
  EtherField.windscreen: 'windscreen',
  EtherField.miasma: 'miasma',
  EtherField.aura: 'aura',
};
