import 'package:flutter/foundation.dart';

@immutable
class PlayerBoardToken {
  final String name;
  final int? valueIndex;
  final List<String> values;
  final bool exclusive;
  final bool permanent;

  String? get value => valueIndex != null ? values[valueIndex!] : null;

  PlayerBoardToken withToggledValue() {
    final int? nextValueIndex;
    if (valueIndex == null) {
      nextValueIndex = 0;
    } else {
      if (!permanent && valueIndex! + 1 >= values.length) {
        nextValueIndex = null;
      } else {
        nextValueIndex = (valueIndex! + 1) % values.length;
      }
    }
    return PlayerBoardToken._privateConstructor(
        name: name,
        valueIndex: nextValueIndex,
        values: values,
        exclusive: exclusive,
        permanent: permanent);
  }

  PlayerBoardToken withNullValue() {
    return PlayerBoardToken._privateConstructor(
        name: name,
        valueIndex: null,
        values: values,
        exclusive: exclusive,
        permanent: permanent);
  }

  PlayerBoardToken withInitialValueForClassNamed(String roverClassName) {
    final int? newValueIndex;
    if (name == bloodLustName) {
      switch (roverClassName) {
        case 'Umbral Howl':
          newValueIndex = values.indexOf(subduedBloodLustValue);
        case 'Nocturne Hoarfrost':
          newValueIndex = values.indexOf(feralBloodLustValue);
        default:
          newValueIndex = null;
      }
    } else if (name == flipName) {
      newValueIndex = 0;
    } else {
      newValueIndex = valueIndex;
    }
    return PlayerBoardToken._privateConstructor(
        name: name,
        valueIndex: newValueIndex,
        values: values,
        exclusive: exclusive,
        permanent: permanent);
  }

  PlayerBoardToken._privateConstructor(
      {required this.name,
      this.valueIndex,
      values,
      this.exclusive = false,
      this.permanent = false})
      : assert(values.isNotEmpty),
        values = values ?? [name];

  static const String bloodLustName = 'Blood Lust';
  static const String flipName = 'Flip';
  static const String feralBloodLustValue = 'blood_lust_feral';
  static const String subduedBloodLustValue = 'blood_lust_subdued';

  String toJson() {
    return '$name(${valueIndex ?? 'null'})';
  }

  factory PlayerBoardToken.fromJson(String json) {
    final parts = json.split('(');
    final name = parts[0];
    final value = parts[1].substring(0, parts[1].length - 1);
    return PlayerBoardToken.fromNameValue(
        name: name, valueIndex: value == 'null' ? null : int.parse(value));
  }

  factory PlayerBoardToken.fromNameValue(
      {required String name, int? valueIndex}) {
    switch (name) {
      case 'Blood Lust':
        return PlayerBoardToken._privateConstructor(
            name: bloodLustName,
            valueIndex: valueIndex,
            values: const [feralBloodLustValue, subduedBloodLustValue],
            permanent: true);
      case 'Quartic':
      case 'Spinaerios':
      case 'Thureoll':
        return PlayerBoardToken._privateConstructor(
            name: name,
            valueIndex: valueIndex,
            values: [name],
            exclusive: true);
      default:
        return PlayerBoardToken._privateConstructor(
            name: name, valueIndex: valueIndex, values: [name]);
    }
  }
}
