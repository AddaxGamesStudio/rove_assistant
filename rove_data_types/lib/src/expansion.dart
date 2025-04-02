// ignore_for_file: unused_element

enum Expansion {
  xulc(name: 'Xulc');

  static Expansion? fromValue(String value) {
    switch (value) {
      case 'xulc':
        return Expansion.xulc;
      default:
        return null;
    }
  }

  final String name;
  final int roversLevel;
  final int merchantLevel;
  final int startingLystPerRover;
  final int unlockedTraitCount;

  const Expansion(
      {required this.name,
      this.roversLevel = 9,
      this.merchantLevel = 4,
      this.startingLystPerRover = 300,
      this.unlockedTraitCount = 2});
}
