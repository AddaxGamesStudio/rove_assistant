import 'package:meta/meta.dart';

@immutable
class EncounterDialogDef {
  static const drawType = 'draw';

  final String title;
  final String? type;
  final String? body;
  final List<EncounterDialogButton> buttons;

  const EncounterDialogDef(
      {required this.title, this.type, this.body, this.buttons = const []});

  factory EncounterDialogDef.fromJson(Map<String, dynamic> json) {
    return EncounterDialogDef(
      title: json['title'],
      type: json['type'] as String?,
      body: json['body'] as String?,
      buttons: json.containsKey('buttons')
          ? (json['buttons'] as List<dynamic>)
              .map((e) => EncounterDialogButton.fromJson(e))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      if (type case final value?) 'type': value,
      'body': body,
      if (buttons.isNotEmpty)
        'buttons': buttons.map((b) => b.toJson()).toList(),
    };
  }

  bool get isDraw => type == drawType;
}

@immutable
class EncounterDialogButton {
  final String title;
  final String milestone;

  const EncounterDialogButton({required this.title, required this.milestone});

  factory EncounterDialogButton.fromJson(Map<String, dynamic> json) {
    return EncounterDialogButton(
      title: json['title'] as String,
      milestone: json['milestone'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'title': title, 'milestone': milestone};
  }
}
