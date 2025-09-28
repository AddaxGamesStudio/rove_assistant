import 'package:flutter_test/flutter_test.dart';
import 'package:rove_data_types/rove_data_types.dart';

itemWithName(String name) {
  return ItemDef(
      name: 'Powdered Drakaen',
      cardId: '1',
      slotType: ItemSlotType.pocket,
      price: 1,
      stock: 4);
}

void main() {
  group('CampaignModel', () {
    test('should return stock of 1 after adding item', () {
      final campaign = Campaign();
      campaign.addPlayer('Rover #1', 'True Scale');
      campaign.addItem(
          baseClassName: 'True Scale', item: itemWithName('Powdered Drakaen'));

      expect(campaign.ownedStockForItem('Powdered Drakaen'), 1);
    });

    test('should return stock of 2 after adding item twice', () {
      final campaign = Campaign();
      campaign.addPlayer('Rover #1', 'True Scale');
      campaign.addItem(
          baseClassName: 'True Scale', item: itemWithName('Powdered Drakaen'));
      campaign.addItem(
          baseClassName: 'True Scale', item: itemWithName('Powdered Drakaen'));

      expect(campaign.ownedStockForItem('Powdered Drakaen'), 2);
    });

    test('should return stock of 0 after removing item', () {
      final campaign = Campaign();
      campaign.addPlayer('Rover #1', 'True Scale');
      campaign.addItem(
          baseClassName: 'True Scale', item: itemWithName('Powdered Drakaen'));
      campaign.removeItem(
          baseClassName: 'True Scale', itemName: 'Powdered Drakaen');

      expect(campaign.ownedStockForItem('Powdered Drakaen'), 0);
    });

    test('should return stock of 2 after adding item to two players', () {
      final campaign = Campaign();
      campaign.addPlayer('Rover #1', 'True Scale');
      campaign.addPlayer('Rover #2', 'Flash');
      campaign.addItem(
          baseClassName: 'True Scale', item: itemWithName('Powdered Drakaen'));
      campaign.addItem(
          baseClassName: 'Flash', item: itemWithName('Powdered Drakaen'));

      expect(campaign.ownedStockForItem('Powdered Drakaen'), 2);
    });

    test(
        'should return stock of 1 after adding item to one player and removing from another',
        () {
      final campaign = Campaign();
      campaign.addPlayer('Rover #1', 'True Scale');
      campaign.addPlayer('Rover #2', 'Flash');
      campaign.addItem(
          baseClassName: 'True Scale', item: itemWithName('Powdered Drakaen'));
      campaign.addItem(
          baseClassName: 'Flash', item: itemWithName('Powdered Drakaen'));
      campaign.removeItem(
          baseClassName: 'True Scale', itemName: 'Powdered Drakaen');

      expect(campaign.ownedStockForItem('Powdered Drakaen'), 1);
    });

    test('should return stock of 1 when initializing from JSON', () {
      final Map<String, dynamic> json;
      {
        final campaign = Campaign();
        campaign.addPlayer('Rover #1', 'True Scale');
        campaign.addItem(
            baseClassName: 'True Scale',
            item: itemWithName('Powdered Drakaen'));
        json = campaign.toJson();
      }
      final campaign = Campaign.fromJson(json);

      expect(campaign.ownedStockForItem('Powdered Drakaen'), 1);
    });
  });
}
