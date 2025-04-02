import 'dart:ui';

List<String> _partsFromVectorString(String vectorString) {
  return vectorString
      .replaceAll('(', '')
      .replaceAll(')', '')
      .replaceAll(' ', '')
      .split(',');
}

String coordinateToString((int, int) coordinate) {
  return rangeToString(coordinate);
}

(int, int) parseCoordinate(String coordinate) {
  return parseRange(coordinate);
}

(int, int) parseRange(String range) {
  final parts = _partsFromVectorString(range);
  return (int.parse(parts[0]), int.parse(parts[1]));
}

String rangeToString((int, int) range) {
  return '(${range.$1}, ${range.$2})';
}

Rect parseRect(String rect) {
  final parts = _partsFromVectorString(rect);
  return Rect.fromLTWH(
      int.parse(parts[0]).toDouble(),
      int.parse(parts[1]).toDouble(),
      int.parse(parts[2]).toDouble(),
      int.parse(parts[3]).toDouble());
}

String rectToString(Rect rect) {
  return '(${rect.left.toInt()}, ${rect.top.toInt()}, ${rect.width.toInt()}, ${rect.height.toInt()})';
}
