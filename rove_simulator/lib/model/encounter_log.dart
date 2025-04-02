import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:rove_simulator/model/tiles/tile_model.dart';
import 'package:rove_app_common/style/rove_palette.dart';

class EncounterLogEntry {
  final String? codexTitle;
  final TileModel? actor;
  final String text;
  final TileModel? target;

  static const String targetKeyword = '<target />';

  EncounterLogEntry(
      {this.codexTitle, this.actor, required this.text, this.target})
      : assert(codexTitle == null || actor == null);

  TextSpan get textSpan {
    final children = <InlineSpan>[];
    if (codexTitle != null) {
      children.add(TextSpan(
          text: codexTitle,
          style: const TextStyle(color: RovePalette.codexForeground)));
      children.add(const TextSpan(text: ': '));
    } else if (actor != null) {
      children.add(
          TextSpan(text: actor!.name, style: TextStyle(color: actor!.color)));
      children.add(const TextSpan(text: ': '));
    }
    if (target != null) {
      final components = text.split(targetKeyword);
      for (int i = 0; i < components.length; i++) {
        final component = components[i];
        children.add(TextSpan(text: component));
        if (i < components.length - 1) {
          children.add(TextSpan(
              text: target == actor ? 'self' : target!.name,
              style: TextStyle(color: target!.color)));
        }
      }
    } else {
      children.add(TextSpan(text: text));
    }
    return TextSpan(
      children: children,
    );
  }

  factory EncounterLogEntry.separator() {
    return EncounterLogEntry(text: '');
  }
}

class EncounterLog extends ChangeNotifier {
  final List<EncounterLogEntry> records = [];

  addRecord(TileModel? actor, String text,
      {TileModel? target, bool addSeparator = false}) {
    records.add(EncounterLogEntry(actor: actor, text: text, target: target));
    if (addSeparator) {
      records.add(EncounterLogEntry.separator());
    }
    notifyListeners();
  }

  addCodexRecord(String codexTitle, String text, {TileModel? target}) {
    records.add(
        EncounterLogEntry(codexTitle: codexTitle, text: text, target: target));
    notifyListeners();
  }
}
