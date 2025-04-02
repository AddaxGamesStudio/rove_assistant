enum RoveGlyph {
  armoroll,
  aerios,
  hyperbola;

  int get countLimit {
    switch (this) {
      case RoveGlyph.aerios:
        return 1;
      case RoveGlyph.armoroll:
        return 1;
      case RoveGlyph.hyperbola:
        return 2;
    }
  }

  int get attackBuff {
    switch (this) {
      case RoveGlyph.aerios:
      case RoveGlyph.armoroll:
        return 0;
      case RoveGlyph.hyperbola:
        return 1;
    }
  }

  int get defenseBuff {
    switch (this) {
      case RoveGlyph.aerios:
      case RoveGlyph.hyperbola:
        return 0;
      case RoveGlyph.armoroll:
        return 1;
    }
  }

  String get label {
    switch (this) {
      case RoveGlyph.aerios:
        return 'Radiant Aerios';
      case RoveGlyph.armoroll:
        return 'Alluring Armoroll';
      case RoveGlyph.hyperbola:
        return 'Luminescent Hyperbola';
    }
  }

  factory RoveGlyph.fromName(String name) {
    return RoveGlyph.values.firstWhere((element) => element.name == name);
  }
}
