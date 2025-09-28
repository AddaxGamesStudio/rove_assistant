import 'package:collection/collection.dart';
import 'package:meta/meta.dart';
import 'package:rove_data_types/src/chapter_page.dart';
import 'package:rove_data_types/src/utils/json_utils.dart';

enum QuestStatus { available, inProgress, completed, locked, blocked }

class EncounterInQuestDef {
  final String id;
  final String title;
  final String? requiresQuest;
  final ChapterPage? page;
  final List<String> encounterCompletedAny;
  final List<String> encounterCompletedAll;
  final List<String> encounterCompletedNotAll;
  final List<String> encounterCompletedNone;

  const EncounterInQuestDef({
    required this.id,
    required this.title,
    this.requiresQuest,
    this.page,
    this.encounterCompletedAny = const [],
    this.encounterCompletedAll = const [],
    this.encounterCompletedNone = const [],
    this.encounterCompletedNotAll = const [],
  });

  factory EncounterInQuestDef.fromJson(Map<String, dynamic> json,
      {String? previousEncounterId}) {
    final page =
        json.containsKey('sections') ? ChapterPage.fromJson(json) : null;

    return EncounterInQuestDef(
      id: json['id'] as String,
      title: json['title'] as String,
      page: page,
      requiresQuest: json['requires_quest'] as String?,
      encounterCompletedAny: json.containsKey('encounter_completed_any')
          ? decodeJsonListNamed(
              'encounter_completed_any', json, (e) => e as String)
          : previousEncounterId != null
              ? [previousEncounterId]
              : [],
      encounterCompletedAll: decodeJsonListNamed(
          'encounter_completed_all', json, (e) => e as String),
      encounterCompletedNone: decodeJsonListNamed(
          'encounter_completed_none', json, (e) => e as String),
      encounterCompletedNotAll: decodeJsonListNamed(
          'encounter_completed_not_all', json, (e) => e as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      if (page case final value?) ...value.toJson(),
      if (requiresQuest case final value?) 'requires_quest': value,
      if (encounterCompletedAny.isNotEmpty)
        'encounter_completed_any': encounterCompletedAny,
      if (encounterCompletedAll.isNotEmpty)
        'encounter_completed_all': encounterCompletedAll,
      if (encounterCompletedNone.isNotEmpty)
        'encounter_completed_none': encounterCompletedNone,
      if (encounterCompletedNotAll.isNotEmpty)
        'encounter_completed_not_all': encounterCompletedNotAll,
    };
  }

  String get displayId {
    final components = id.split('.');
    if (components.length >= 2) {
      return components[1];
    } else {
      return id;
    }
  }
}

@immutable
class QuestDef {
  final String? expansion;
  final String id;
  final String title;
  final String? shortTitle;
  final ChapterPage? introduction;
  final List<EncounterInQuestDef> encounters;
  final Map<String, (double, double)> relativeCoordinates;
  final QuestRequirements requirements;

  const QuestDef(
      {this.expansion,
      required this.id,
      required this.title,
      this.shortTitle,
      this.introduction,
      required this.encounters,
      required this.requirements,
      this.relativeCoordinates = const {}});

  factory QuestDef.fromJson(Map<String, dynamic> json) {
    final requirements = json.containsKey('requires')
        ? QuestRequirements.fromJson(json['requires'])
        : QuestRequirements.empty();
    final questId = json['id'] as String;
    final relativeCoordinates = <String, (double, double)>{};
    String? previousEncounterId;
    return QuestDef(
      expansion: json['expansion'] as String?,
      id: questId,
      title: json['title'] as String,
      shortTitle: json['short_title'] as String?,
      introduction: json.containsKey('introduction')
          ? ChapterPage.fromJson(json['introduction'])
          : null,
      encounters: json.containsKey('encounters')
          ? (json['encounters'] as List<dynamic>).map((e) {
              final encounter = EncounterInQuestDef.fromJson(e,
                  previousEncounterId: previousEncounterId);
              previousEncounterId = encounter.id;
              final relativeX = e['relative_x'] as double?;
              final relativeY = e['relative_y'] as double?;
              if (relativeX != null && relativeY != null) {
                relativeCoordinates[encounter.id] = (relativeX, relativeY);
              }
              return encounter;
            }).toList()
          : [],
      requirements: requirements,
      relativeCoordinates: relativeCoordinates,
    );
  }

  bool get isTutorial {
    return title == 'Prologue';
  }

  EncounterInQuestDef? encounterForId(String encounterId) {
    return encounters.firstWhereOrNull((e) => e.id == encounterId);
  }
}

@immutable
class QuestRequirements {
  final List<String> questsCompletedAny;
  final List<String> questsStartedNone;

  const QuestRequirements(
      {required this.questsCompletedAny, required this.questsStartedNone});

  factory QuestRequirements.empty() {
    return const QuestRequirements(
        questsCompletedAny: [], questsStartedNone: []);
  }

  factory QuestRequirements.fromJson(Map<String, dynamic> json) {
    final List<String> questsCompletedAny =
        json.containsKey('quest_completed_any')
            ? (json['quest_completed_any'] as List<dynamic>)
                .map((e) => e as String)
                .toList()
            : [];
    final List<String> questsStartedNone =
        json.containsKey('quest_started_none')
            ? (json['quest_started_none'] as List<dynamic>)
                .map((e) => e as String)
                .toList()
            : [];
    return QuestRequirements(
      questsCompletedAny: questsCompletedAny,
      questsStartedNone: questsStartedNone,
    );
  }
}
