import 'package:rove_data_types/src/utils/json_utils.dart';

class CampaignText {
  final String name;
  final String body;
  final String? artwork;

  CampaignText({required this.name, required this.body, this.artwork});

  factory CampaignText.fromString(String name, String data) {
    Iterable<String> lines = data.split('\n');
    String? artwork;
    while (lines.isNotEmpty && lines.first.startsWith('[')) {
      final line = lines.first;
      final metadata = line.substring(1, line.length - 1);
      if (metadata.toLowerCase().startsWith('artwork')) {
        artwork = metadata.split('=')[1];
      }
      lines = lines.skip(1);
    }
    final String body = lines.join('\n\n').replaceAll('\n\n\n\n', '\n\n\n');
    return CampaignText(name: name, body: body, artwork: artwork);
  }
}

enum SectionType {
  artwork,
  text,
  campaignLink,
  rules;

  String toJson() {
    switch (this) {
      case SectionType.artwork:
        return 'artwork';
      case SectionType.text:
        return 'text';
      case SectionType.campaignLink:
        return 'campaign_link';
      case SectionType.rules:
        return 'rules';
    }
  }

  factory SectionType.fromJson(String json) {
    return SectionType.values.firstWhere(
      (e) => e.toJson() == json,
      orElse: () => SectionType.text,
    );
  }
}

class Section {
  final SectionType type;
  final String? title;
  final String? body;
  final String? value;
  final String? ifMilestone;
  final List<String> encounterCompletedAll;
  final List<String> encounterCompletedNotAll;
  final List<String> encounterCompletedNone;

  const Section({
    required this.type,
    this.title,
    this.body,
    this.value,
    this.ifMilestone,
    this.encounterCompletedAll = const [],
    this.encounterCompletedNone = const [],
    this.encounterCompletedNotAll = const [],
  });

  String? get questLink {
    if (type != SectionType.campaignLink) {
      return null;
    }
    if (value == null) {
      return null;
    }
    final components = value?.split(':');
    if (components?.first == 'quest') {
      return components?.last;
    }
    return null;
  }

  factory Section.fromJson(Map<String, dynamic> json) {
    return Section(
      type: SectionType.fromJson(json['type'] as String),
      title: json['title'] as String?,
      body: json['body'] as String?,
      value: json['value'] as String?,
      ifMilestone: json['if_milestone'] as String?,
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
      'type': type.toJson(),
      if (title case final val?) 'title': val,
      if (body case final val?) 'body': val,
      if (value case final val?) 'value': val,
      if (ifMilestone case final val?) 'if_milestone': val,
      if (encounterCompletedAll.isNotEmpty)
        'encounter_completed_all': encounterCompletedAll,
      if (encounterCompletedNone.isNotEmpty)
        'encounter_completed_none': encounterCompletedNone,
      if (encounterCompletedNotAll.isNotEmpty)
        'encounter_completed_not_all': encounterCompletedNotAll,
    };
  }
}

class ChapterPage {
  final String? id;
  final String title;
  final List<Section> sections;

  ChapterPage({this.id, this.title = 'Introduction', required this.sections});

  factory ChapterPage.fromJson(Map<String, dynamic> json) {
    return ChapterPage(
      id: json['id'] as String?,
      title: json['title'] as String? ?? 'Introduction',
      sections:
          decodeJsonListNamed('sections', json, (e) => Section.fromJson(e)),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id case final value?) 'id': value,
      'title': title,
      'sections': sections.map((e) => e.toJson()).toList(),
    };
  }
}
