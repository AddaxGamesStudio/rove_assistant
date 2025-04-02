import 'dart:math';

enum XulcDieSide {
  cleaving,
  armor,
  flying,
  blank;

  String get label {
    switch (this) {
      case XulcDieSide.cleaving:
        return 'Cleaving';
      case XulcDieSide.armor:
        return 'Armor';
      case XulcDieSide.flying:
        return 'Flying';
      case XulcDieSide.blank:
        return 'Blank';
    }
  }

  bool get isBlank => this == XulcDieSide.blank;

  static XulcDieSide fromName(String name) {
    switch (name) {
      case 'cleaving':
        return XulcDieSide.cleaving;
      case 'armor':
        return XulcDieSide.armor;
      case 'flying':
        return XulcDieSide.flying;
      case 'blank':
        return XulcDieSide.blank;
      default:
        assert(false, 'Unknown XulcDieSide: $name');
        return XulcDieSide.blank;
    }
  }

  static XulcDieSide randomSide({int? seed}) {
    final values = XulcDieSide.values;
    return values[Random(seed).nextInt(values.length)];
  }

  String? get adversaryName {
    switch (this) {
      case XulcDieSide.cleaving:
        return 'Cleaving Xulc';
      case XulcDieSide.armor:
        return 'Armored Xulc';
      case XulcDieSide.flying:
        return 'Flying Xulc';
      case XulcDieSide.blank:
        return null;
    }
  }
}
