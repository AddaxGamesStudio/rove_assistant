import 'package:rove_data_types/rove_data_types.dart';

extension RoveActionLayout on RoveAction {
  int get rowCount {
    int count = 1;
    if (aoe != null) {
      count++;
    }
    if (augments.isNotEmpty) {
      count = count + augments.length;
    }
    return count;
  }
}
