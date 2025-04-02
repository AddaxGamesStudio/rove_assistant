import 'package:flutter_test/flutter_test.dart';
import 'package:rove_simulator/model/cards/reaction_model.dart';

import '../../test_data/cards_test_data.dart';

void main() {
  group('saveable', () {
    late ReactionModel reaction;

    setUp(() {
      reaction = ReactionModelTestData.testReaction();
    });

    test('round trip', () {
      expect(reaction.isBack, isFalse);
      reaction.flip();

      final data = reaction.toSaveData();
      final otherReaction = ReactionModelTestData.testReaction();
      otherReaction.initializeWithSaveData(data);
      expect(otherReaction.isBack, isTrue);
    });
  });
}
