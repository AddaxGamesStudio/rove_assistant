import 'package:rove_data_types/rove_data_types.dart';

extension PlayerGameExtension on Player {
  String get boardOverlayName => 'player_board.$name';
}
