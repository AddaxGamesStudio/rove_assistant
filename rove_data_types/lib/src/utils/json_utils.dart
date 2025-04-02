import 'package:rove_data_types/src/actions/encounter_action.dart';

List<T> decodeJsonListNamed<T>(
  String name,
  dynamic json,
  T Function(dynamic) decoder,
) {
  return json.containsKey(name)
      ? (json[name] as List<dynamic>).map(decoder).toList()
      : [];
}

Set<T> decodeJsonSetNamed<T>(
  String name,
  dynamic json,
  T Function(dynamic) decoder,
) {
  return json.containsKey(name)
      ? (json[name] as List<dynamic>).map(decoder).toSet()
      : {};
}

Map<String, List<EncounterAction>> actionMapFromJson(
    String name, dynamic json) {
  return mapFromJson(name, json,
      (value) => value.map((a) => EncounterAction.fromJson(a)).toList());
}

Map<String, T> mapFromJson<T>(
    String name, dynamic json, T Function(dynamic) decoder) {
  return json.containsKey(name)
      ? Map<String, T>.fromEntries((json[name] as Map<String, dynamic>)
          .entries
          .map((e) => MapEntry(e.key, decoder(e.value))))
      : {};
}

Map<String, dynamic> mapToJson<T>(
    Map<String, T> map, dynamic Function(T) encoder) {
  return Map<String, dynamic>.fromEntries(
      map.entries.map((e) => MapEntry(e.key, encoder(e.value))));
}

Map<String, dynamic> actionMapToJson(
    Map<String, List<EncounterAction>> milestoneMap) {
  return mapToJson(
      milestoneMap, (value) => value.map((a) => a.toJson()).toList());
}
