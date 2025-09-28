import 'dart:ui';

extension ColorExtension on Color {
  Color darken(double amount) {
    assert(amount >= 0 && amount <= 1);

    final f = 1 - amount;
    return Color.from(
      alpha: a,
      red: r * f,
      green: g * f,
      blue: b * f,
    );
  }
}
