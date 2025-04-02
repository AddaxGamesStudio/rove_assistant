import 'package:rove_data_types/rove_data_types.dart';
import 'package:test/test.dart';

void main() {
  group('containsUnambiguousMatch', () {
    test('expect specific cost is unambiguous match to specific ether', () {
      final item = _itemWithCost([ItemEtherCost.air]);
      expect(item.containsUnambiguousMatch([Ether.wind]), true);
    });

    test(
        'expect specific cost is unambiguous match to ether containing multiple corresponding',
        () {
      final item = _itemWithCost([ItemEtherCost.air]);
      expect(item.containsUnambiguousMatch([Ether.wind, Ether.wind]), true);
    });

    test(
        'expect specific cost is unambiguous match to ether containing corresponding and more',
        () {
      final item = _itemWithCost([ItemEtherCost.air]);
      expect(item.containsUnambiguousMatch([Ether.wind, Ether.crux]), true);
    });

    test('expect specific cost is not unambiguous match to different ether',
        () {
      final item = _itemWithCost([ItemEtherCost.air]);
      expect(item.containsUnambiguousMatch([Ether.crux]), false);
    });

    test('expect specific 2x cost is unambiguous match to corresponding ether',
        () {
      final item = _itemWithCost([ItemEtherCost.air, ItemEtherCost.crux]);
      expect(item.containsUnambiguousMatch([Ether.wind, Ether.crux]), true);
    });

    test('expect specific 2x cost is no match to different ether', () {
      final item = _itemWithCost([ItemEtherCost.air, ItemEtherCost.crux]);
      expect(item.containsUnambiguousMatch([Ether.morph, Ether.earth]), false);
    });

    test('expect specific 2x cost is no match to partially corresponding ether',
        () {
      final item = _itemWithCost([ItemEtherCost.air, ItemEtherCost.crux]);
      expect(
          item.containsUnambiguousMatch([Ether.morph, Ether.earth, Ether.wind]),
          false);
    });

    test(
        'expect either cost is unambiguous match to single corresponding ether',
        () {
      final item = _itemWithCost([ItemEtherCost.fireOrAir]);
      expect(item.containsUnambiguousMatch([Ether.fire]), true);
    });

    test(
        'expect either cost is unambiguous match to multiple corresponding ether',
        () {
      final item = _itemWithCost([ItemEtherCost.fireOrAir]);
      expect(item.containsUnambiguousMatch([Ether.fire, Ether.fire]), true);
    });

    test(
        'expect either cost is unambiguous match to multiple ether that contain unambiguous match',
        () {
      final item = _itemWithCost([ItemEtherCost.fireOrAir]);
      expect(
          item.containsUnambiguousMatch([Ether.fire, Ether.fire, Ether.crux]),
          true);
    });

    test(
        'expect either cost is not unambiguous match to multiple ether that contain both values',
        () {
      final item = _itemWithCost([ItemEtherCost.fireOrAir]);
      expect(
          item.containsUnambiguousMatch([Ether.fire, Ether.wind, Ether.crux]),
          false);
    });

    test('expect either cost is not match to multiple corresponding ether', () {
      final item = _itemWithCost([ItemEtherCost.fireOrAir]);
      expect(item.containsUnambiguousMatch([Ether.fire, Ether.wind]), false);
    });

    test('expect wild cost is unambiguous match to single ether', () {
      final item = _itemWithCost([ItemEtherCost.wild]);
      expect(item.containsUnambiguousMatch([Ether.wind]), true);
    });

    test(
        'expect wild cost is not unambiguous match to multiple ether of different type',
        () {
      final item = _itemWithCost([ItemEtherCost.wild]);
      expect(item.containsUnambiguousMatch([Ether.wind, Ether.crux]), false);
    });

    test('expect wild cost is unambiguous match to multiple ether of same type',
        () {
      final item = _itemWithCost([ItemEtherCost.wild]);
      expect(item.containsUnambiguousMatch([Ether.wind, Ether.wind]), true);
    });

    test('expect 2x wild cost is unambiguous match to 2 ether', () {
      final item = _itemWithCost([ItemEtherCost.wild, ItemEtherCost.wild]);
      expect(item.containsUnambiguousMatch([Ether.wind, Ether.wind]), true);
    });

    test(
        'expect 2x wild cost is not unambiguous match to 3 ether of different type',
        () {
      final item = _itemWithCost([ItemEtherCost.wild, ItemEtherCost.wild]);
      expect(
          item.containsUnambiguousMatch([Ether.wind, Ether.wind, Ether.crux]),
          false);
    });

    test('expect 2x wild cost is unambiguous match to 3 ether of same type',
        () {
      final item = _itemWithCost([ItemEtherCost.wild, ItemEtherCost.wild]);
      expect(
          item.containsUnambiguousMatch([Ether.wind, Ether.wind, Ether.wind]),
          true);
    });

    test(
        'expect 1x exact, 1x wild is unambiguous match to 2 ether containing the exact ether',
        () {
      final item = _itemWithCost([ItemEtherCost.wild, ItemEtherCost.air]);
      expect(item.containsUnambiguousMatch([Ether.wind, Ether.wind]), true);
    });

    test(
        'expect 1x exact, 1x wild is unambiguous match to 3 ether of the same value',
        () {
      final item = _itemWithCost([ItemEtherCost.wild, ItemEtherCost.air]);
      expect(
          item.containsUnambiguousMatch([Ether.wind, Ether.wind, Ether.wind]),
          true);
    });

    test(
        'expect 1x exact, 1x wild is not unambiguous match to 3 ether including the exact ether that are not all the same',
        () {
      final item = _itemWithCost([ItemEtherCost.wild, ItemEtherCost.air]);
      expect(
          item.containsUnambiguousMatch([Ether.wind, Ether.crux, Ether.wind]),
          false);
    });

    test(
        'expect 1x exact, 1x either is unambiguous match to 2 ether containing the exact ether and one of the either values',
        () {
      final item =
          _itemWithCost([ItemEtherCost.waterOrEarth, ItemEtherCost.air]);
      expect(item.containsUnambiguousMatch([Ether.wind, Ether.earth]), true);
    });

    test(
        'expect 1x exact, 1x either is unambiguous match to 3 ether of the same value that match both',
        () {
      final item = _itemWithCost([ItemEtherCost.fireOrAir, ItemEtherCost.air]);
      expect(item.containsUnambiguousMatch([Ether.wind, Ether.wind]), true);
    });

    test(
        'expect 1x exact, 1x either is not unambiguous match to 3 ether that can match in multiple ways',
        () {
      final item =
          _itemWithCost([ItemEtherCost.fireOrAir, ItemEtherCost.earth]);
      expect(
          item.containsUnambiguousMatch([Ether.fire, Ether.earth, Ether.wind]),
          false);
    });

    test(
        'expect 1x exact, 1x wild, 1x either is not unambiguous match to 3 ether that can match',
        () {
      final item = _itemWithCost(
          [ItemEtherCost.wild, ItemEtherCost.fireOrAir, ItemEtherCost.earth]);
      expect(
          item.containsUnambiguousMatch([Ether.wind, Ether.earth, Ether.wind]),
          true);
    });
  });

  group('canMatch', () {
    test('expect specific cost can match specific ether', () {
      final item = _itemWithCost([ItemEtherCost.air]);
      expect(item.canMatch([Ether.wind]), true);
    });

    test('expect specific cost is can match multiple ether of the same type',
        () {
      final item = _itemWithCost([ItemEtherCost.air]);
      expect(item.canMatch([Ether.wind, Ether.wind]), true);
    });

    test(
        'expect specific cost can match ether containing corresponding and more',
        () {
      final item = _itemWithCost([ItemEtherCost.air]);
      expect(item.canMatch([Ether.wind, Ether.crux]), true);
    });

    test('expect specific cost can not match different ether', () {
      final item = _itemWithCost([ItemEtherCost.air]);
      expect(item.canMatch([Ether.crux]), false);
    });

    test('expect specific 2x cost can match corresponding ether', () {
      final item = _itemWithCost([ItemEtherCost.air, ItemEtherCost.crux]);
      expect(item.canMatch([Ether.wind, Ether.crux]), true);
    });

    test('expect specific 2x cost can not match different ether', () {
      final item = _itemWithCost([ItemEtherCost.air, ItemEtherCost.crux]);
      expect(item.canMatch([Ether.morph, Ether.earth]), false);
    });

    test(
        'expect specific 2x cost can not match to partially corresponding ether',
        () {
      final item = _itemWithCost([ItemEtherCost.air, ItemEtherCost.crux]);
      expect(item.canMatch([Ether.morph, Ether.earth, Ether.wind]), false);
    });

    test('expect either cost can match single corresponding ether', () {
      final item = _itemWithCost([ItemEtherCost.fireOrAir]);
      expect(item.canMatch([Ether.fire]), true);
    });

    test('expect either cost can match single differing ether', () {
      final item = _itemWithCost([ItemEtherCost.fireOrAir]);
      expect(item.canMatch([Ether.earth]), false);
    });

    test('expect either cost can match multiple corresponding ether', () {
      final item = _itemWithCost([ItemEtherCost.fireOrAir]);
      expect(item.canMatch([Ether.fire, Ether.fire]), true);
    });

    test('expect either cost can match to multiple ether that contain match',
        () {
      final item = _itemWithCost([ItemEtherCost.fireOrAir]);
      expect(item.canMatch([Ether.fire, Ether.fire, Ether.crux]), true);
    });

    test(
        'expect either cost can match to multiple ether that contain both values',
        () {
      final item = _itemWithCost([ItemEtherCost.fireOrAir]);
      expect(item.canMatch([Ether.fire, Ether.wind, Ether.crux]), true);
    });

    test('expect either can match multiple corresponding ether', () {
      final item = _itemWithCost([ItemEtherCost.fireOrAir]);
      expect(item.canMatch([Ether.fire, Ether.wind]), true);
    });

    test('expect wild cost can match single ether', () {
      final item = _itemWithCost([ItemEtherCost.wild]);
      expect(item.canMatch([Ether.wind]), true);
    });

    test('expect wild cost can match multiple ether of different type', () {
      final item = _itemWithCost([ItemEtherCost.wild]);
      expect(item.canMatch([Ether.wind, Ether.crux]), true);
    });

    test('expect wild cost can match multiple ether of same type', () {
      final item = _itemWithCost([ItemEtherCost.wild]);
      expect(item.canMatch([Ether.wind, Ether.wind]), true);
    });

    test('expect 2x wild cost can match to 2 ether', () {
      final item = _itemWithCost([ItemEtherCost.wild, ItemEtherCost.wild]);
      expect(item.canMatch([Ether.wind, Ether.wind]), true);
    });

    test('expect 2x wild cost can match to 3 ether of different type', () {
      final item = _itemWithCost([ItemEtherCost.wild, ItemEtherCost.wild]);
      expect(item.canMatch([Ether.wind, Ether.wind, Ether.crux]), true);
    });

    test('expect 2x wild cost can  match to 3 ether of same type', () {
      final item = _itemWithCost([ItemEtherCost.wild, ItemEtherCost.wild]);
      expect(item.canMatch([Ether.wind, Ether.wind, Ether.wind]), true);
    });

    test(
        'expect 1x exact, 1x wild can match to 2 ether containing the exact ether',
        () {
      final item = _itemWithCost([ItemEtherCost.wild, ItemEtherCost.air]);
      expect(item.canMatch([Ether.wind, Ether.wind]), true);
    });

    test(
        'expect 1x exact, 1x wild can not match to 2 ether that do not contain the exact ether',
        () {
      final item = _itemWithCost([ItemEtherCost.wild, ItemEtherCost.air]);
      expect(item.canMatch([Ether.fire, Ether.fire]), false);
    });

    test('expect 1x exact, 1x wild can match to 3 ether of the same value', () {
      final item = _itemWithCost([ItemEtherCost.wild, ItemEtherCost.air]);
      expect(item.canMatch([Ether.wind, Ether.wind, Ether.wind]), true);
    });

    test(
        'expect 1x exact, 1x wild can match to 3 ether including the exact ether that are not all the same',
        () {
      final item = _itemWithCost([ItemEtherCost.wild, ItemEtherCost.air]);
      expect(item.canMatch([Ether.wind, Ether.crux, Ether.wind]), true);
    });

    test(
        'expect 1x exact, 1x either is can match to 2 ether containing the exact ether and one of the either values',
        () {
      final item =
          _itemWithCost([ItemEtherCost.waterOrEarth, ItemEtherCost.air]);
      expect(item.canMatch([Ether.wind, Ether.earth]), true);
    });

    test(
        'expect 1x exact, 1x either can match to 3 ether of the same value that match both',
        () {
      final item = _itemWithCost([ItemEtherCost.fireOrAir, ItemEtherCost.air]);
      expect(item.canMatch([Ether.wind, Ether.wind]), true);
    });

    test(
        'expect 1x exact, 1x either can match 3 ether that can match in multiple ways',
        () {
      final item =
          _itemWithCost([ItemEtherCost.fireOrAir, ItemEtherCost.earth]);
      expect(item.canMatch([Ether.fire, Ether.earth, Ether.wind]), true);
    });

    test('expect 1x exact, 1x wild, 1x either can match 3 ether that can match',
        () {
      final item = _itemWithCost(
          [ItemEtherCost.wild, ItemEtherCost.fireOrAir, ItemEtherCost.earth]);
      expect(item.canMatch([Ether.wind, Ether.earth, Ether.wind]), true);
    });
  });

  group('matchingEther', () {
    test(
        'expect right ether for specific cost on list with single matching ether',
        () {
      final item = _itemWithCost([ItemEtherCost.air]);
      expect(item.matchingEther([Ether.wind]), [Ether.wind]);
    });

    test(
        'expect right ether for specific cost on list with multiple matching ether',
        () {
      final item = _itemWithCost([ItemEtherCost.air]);
      expect(item.matchingEther([Ether.wind, Ether.wind]), [Ether.wind]);
    });

    test(
        'expect right ether for specific cost on list with multiple ether containing corresponding and more',
        () {
      final item = _itemWithCost([ItemEtherCost.air]);
      expect(item.matchingEther([Ether.wind, Ether.crux]), [Ether.wind]);
    });

    test('expect empty list for specific cost on list with other ether', () {
      final item = _itemWithCost([ItemEtherCost.air]);
      expect(item.matchingEther([Ether.crux]), []);
    });

    test('expect right ether for 2x speficic cost on list matching exactly',
        () {
      final item = _itemWithCost([ItemEtherCost.air, ItemEtherCost.crux]);
      expect(item.matchingEther([Ether.wind, Ether.crux]),
          [Ether.wind, Ether.crux]);
    });

    test('expect empty list for 2x specific cost on list that does not match',
        () {
      final item = _itemWithCost([ItemEtherCost.air, ItemEtherCost.crux]);
      expect(item.matchingEther([Ether.morph, Ether.earth]), []);
    });

    test(
        'expect empty list for 2x specific cost on list that partially matches',
        () {
      final item = _itemWithCost([ItemEtherCost.air, ItemEtherCost.crux]);
      expect(item.matchingEther([Ether.morph, Ether.earth, Ether.wind]), []);
    });

    test('expect right ether for either cost on list that matches', () {
      final item = _itemWithCost([ItemEtherCost.fireOrAir]);
      expect(item.matchingEther([Ether.fire]), [Ether.fire]);
    });

    test('expect empty list for either cost on list that does not match', () {
      final item = _itemWithCost([ItemEtherCost.fireOrAir]);
      expect(item.matchingEther([Ether.earth]), []);
    });

    test(
        'expect right ether for either cost on list with multiple ether of the same value that match',
        () {
      final item = _itemWithCost([ItemEtherCost.fireOrAir]);
      expect(item.matchingEther([Ether.fire, Ether.fire]), [Ether.fire]);
    });

    test('expect first ether for either cost on list with multiple matches',
        () {
      final item = _itemWithCost([ItemEtherCost.fireOrAir]);
      expect(item.matchingEther([Ether.wind, Ether.fire]), [Ether.wind]);
    });

    test('expect first ether for wild cost on list with single ether', () {
      final item = _itemWithCost([ItemEtherCost.wild]);
      expect(item.matchingEther([Ether.wind]), [Ether.wind]);
    });

    test('expect first ether for wild cost on list with multiple ether', () {
      final item = _itemWithCost([ItemEtherCost.wild]);
      expect(item.matchingEther([Ether.wind, Ether.crux]), [Ether.wind]);
    });

    test(
        'expect single ether for wild cost on list with multiple ether of same type',
        () {
      final item = _itemWithCost([ItemEtherCost.wild]);
      expect(item.matchingEther([Ether.wind, Ether.wind]), [Ether.wind]);
    });

    test(
        'expect first two ether for 2x wild cost on list with two ether of same type',
        () {
      final item = _itemWithCost([ItemEtherCost.wild, ItemEtherCost.wild]);
      expect(item.matchingEther([Ether.wind, Ether.wind]),
          [Ether.wind, Ether.wind]);
    });

    test('expect first two ether for 2x wild cost on list with 3 ether', () {
      final item = _itemWithCost([ItemEtherCost.wild, ItemEtherCost.wild]);
      expect(item.matchingEther([Ether.wind, Ether.wind, Ether.crux]),
          [Ether.wind, Ether.wind]);
    });

    test(
        'expect right ether for 1x exact, 1x wild on list of two ether containing the exact ether',
        () {
      final item = _itemWithCost([ItemEtherCost.wild, ItemEtherCost.air]);
      expect(item.matchingEther([Ether.wind, Ether.wind]),
          [Ether.wind, Ether.wind]);
    });

    test(
        'expect empty list for 1x exact, 1x wild cost for list that do not contains the exact ether',
        () {
      final item = _itemWithCost([ItemEtherCost.wild, ItemEtherCost.air]);
      expect(item.matchingEther([Ether.fire, Ether.fire]), []);
    });

    test(
        'expect right ether for 1x exact, 1x wild on list of 3 different ether including the exact ether',
        () {
      final item = _itemWithCost([ItemEtherCost.wild, ItemEtherCost.air]);
      expect(item.matchingEther([Ether.wind, Ether.crux, Ether.wind]),
          [Ether.wind, Ether.crux]);
    });

    test(
        'expect right ether for 1x exact, 1x either on list of 2 ether containing the exact ether and one of the either values',
        () {
      final item =
          _itemWithCost([ItemEtherCost.waterOrEarth, ItemEtherCost.air]);
      expect(item.matchingEther([Ether.earth, Ether.wind]),
          [Ether.wind, Ether.earth]);
    });

    test(
        'expect right ether for 1x exact, 1x either on list of 3 ether of the same value that match both',
        () {
      final item = _itemWithCost([ItemEtherCost.fireOrAir, ItemEtherCost.air]);
      expect(item.matchingEther([Ether.wind, Ether.wind]),
          [Ether.wind, Ether.wind]);
    });

    test(
        'expect right ether for 1x either, 1x exact on list that matches in multiple ways',
        () {
      final item =
          _itemWithCost([ItemEtherCost.fireOrAir, ItemEtherCost.earth]);
      expect(item.matchingEther([Ether.fire, Ether.earth, Ether.wind]),
          [Ether.earth, Ether.fire]);
    });

    test('expect right ether for 1x exact, 1x wild, 1x either on matching list',
        () {
      final item = _itemWithCost(
          [ItemEtherCost.wild, ItemEtherCost.fireOrAir, ItemEtherCost.earth]);
      expect(item.matchingEther([Ether.wind, Ether.earth, Ether.wind]),
          [Ether.earth, Ether.wind, Ether.wind]);
    });

    test(
        'expect empty list when list that can match but needs to be resolved in certain order',
        () {
      // Can fail to return matching ether depending on order. This is ok because Rove does not have ether cost of this complexity.
      final item = _itemWithCost(
          [ItemEtherCost.wild, ItemEtherCost.earth, ItemEtherCost.fireOrEarth]);
      expect(item.matchingEther([Ether.earth, Ether.fire, Ether.wind]), []);
    });
  });
}

ItemDef _itemWithCost(List<ItemEtherCost> cost) {
  return ItemDef(
    name: 'Test',
    cardId: 'Test',
    slotType: ItemSlotType.pocket,
    price: 0,
    stock: 0,
    etherCost: cost,
  );
}
