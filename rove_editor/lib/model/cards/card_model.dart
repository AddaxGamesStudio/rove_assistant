import 'package:flutter/foundation.dart';
import 'package:rove_data_types/rove_data_types.dart';

abstract class CardModel extends ChangeNotifier {
  List<RoveAction> get actions;
  String get name;
  int? _currentActionIndex;

  String get title => name;

  Set<int> get groups => actions
      .where((a) => a.exclusiveGroup != 0)
      .map((action) => action.exclusiveGroup)
      .toSet();

  bool get hasExclusiveGroups => groups.length > 1;

  int? get currentActionIndex => _currentActionIndex;
  set currentActionIndex(int? currentActionIndex) {
    _currentActionIndex = currentActionIndex;
    notifyListeners();
  }

  String groupDescriptionForIndex(int group) {
    final groups = this.groups;
    if (groups.length == 1) {
      return '';
    }
    if (groups.length == 2) {
      return group == 1 ? 'upper half' : 'bottom half';
    } else {
      return 'group $group';
    }
  }
}
