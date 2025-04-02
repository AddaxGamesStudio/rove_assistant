import 'package:rove_data_types/rove_data_types.dart';

abstract class TwoSidedCardDef {
  final String? id;
  final String name;
  final String subtype;
  final String back;
  final bool isUpgrade;
  final List<RoveAction> actions;

  TwoSidedCardDef(
      {this.id,
      required this.name,
      required this.subtype,
      required this.back,
      this.isUpgrade = false,
      required this.actions});

  String get cardTitle => name + (subtype.isNotEmpty ? ' [$subtype]' : '');
}
