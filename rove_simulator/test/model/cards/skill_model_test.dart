import 'package:flutter_test/flutter_test.dart';
import 'package:rove_simulator/model/cards/skill_model.dart';

import '../../test_data/cards_test_data.dart';

void main() {
  group('saveable', () {
    late SkillModel skill;

    setUp(() {
      skill = SkillModelTestData.testSkill();
    });

    test('round trip', () {
      expect(skill.isBack, isFalse);
      skill.flip();

      final data = skill.toSaveData();
      final otherSkill = SkillModelTestData.testSkill();
      otherSkill.initializeWithSaveData(data);
      expect(otherSkill.isBack, isTrue);
    });
  });
}
