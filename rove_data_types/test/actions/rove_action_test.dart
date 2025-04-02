import 'package:rove_data_types/rove_data_types.dart';
import 'package:test/test.dart';

void main() {
  group('json', () {
    test('toJson of generate ether', () {
      final action = RoveAction.generateEther();
      final json = action.toJson();
      expect(json['type'], RoveActionType.generateEther.toJson());
    });

    test('fromJson of generate ether', () {
      final json = {'type': RoveActionType.generateEther.toJson()};
      final action = RoveAction.fromJson(json);
      expect(action.type, RoveActionType.generateEther);
    });

    test('toJson of create glyph', () {
      final action = RoveAction.createGlyph(RoveGlyph.armoroll);
      final json = action.toJson();
      expect(json['type'], RoveActionType.createGlyph.toJson());
      expect(json['object'], RoveGlyph.armoroll.name);
    });

    test('fromJson of create glyph', () {
      final json = {
        'type': RoveActionType.createGlyph.toJson(),
        'object': RoveGlyph.armoroll.name
      };
      final action = RoveAction.fromJson(json);
      expect(action.type, RoveActionType.createGlyph);
      expect(action.object, RoveGlyph.armoroll.name);
    });

    test('toJson of buff', () {
      final action = RoveAction.buff(BuffType.attack, 2);
      final json = action.toJson();
      expect(json['type'], RoveActionType.buff.toJson());
      expect(json['buff_type'], BuffType.attack.toJson());
      expect(json['amount'], 2);
    });

    test('fromJson of buff', () {
      final json = {
        'type': RoveActionType.buff.toJson(),
        'buff_type': BuffType.attack.toJson(),
        'amount': 2
      };
      final action = RoveAction.fromJson(json);
      expect(action.type, RoveActionType.buff);
      expect(action.buffType, BuffType.attack);
      expect(action.amount, 2);
    });

    test('toJson of melee attack', () {
      final action = RoveAction.meleeAttack(3, pierce: true);
      final json = action.toJson();
      expect(json['type'], RoveActionType.attack.toJson());
      expect(json['amount'], 3);
      expect(json['pierce'], true);
    });

    test('fromJson of melee attack', () {
      final json = {
        'type': RoveActionType.attack.toJson(),
        'amount': 3,
        'pierce': true
      };
      final action = RoveAction.fromJson(json);
      expect(action.type, RoveActionType.attack);
      expect(action.amount, 3);
      expect(action.pierce, true);
    });

    test('toJson of range attack', () {
      final action = RoveAction.rangeAttack(2, startRange: 2, endRange: 4);
      final json = action.toJson();
      expect(json['type'], RoveActionType.attack.toJson());
      expect(json['amount'], 2);
      expect(json['range'], '(2, 4)');
    });

    test('fromJson of range attack', () {
      final json = {
        'type': RoveActionType.attack.toJson(),
        'amount': 2,
        'range': '(2, 4)'
      };
      final action = RoveAction.fromJson(json);
      expect(action.type, RoveActionType.attack);
      expect(action.amount, 2);
      expect(action.range.$1, 2);
      expect(action.range.$2, 4);
    });

    test('toJson of move', () {
      final action = RoveAction.move(3);
      final json = action.toJson();
      expect(json['type'], RoveActionType.move.toJson());
      expect(json['amount'], 3);
    });

    test('fromJson of move', () {
      final json = {'type': RoveActionType.move.toJson(), 'amount': 3};
      final action = RoveAction.fromJson(json);
      expect(action.type, RoveActionType.move);
      expect(action.amount, 3);
    });

    test('toJson of heal', () {
      final action = RoveAction.heal(3, startRange: 1, endRange: 2);
      final json = action.toJson();
      expect(json['type'], RoveActionType.heal.toJson());
      expect(json['amount'], 3);
      expect(json['range'], '(1, 2)');
    });

    test('fromJson of heal', () {
      final json = {
        'type': RoveActionType.heal.toJson(),
        'amount': 3,
        'range': '(1, 2)'
      };
      final action = RoveAction.fromJson(json);
      expect(action.type, RoveActionType.heal);
      expect(action.amount, 3);
      expect(action.range.$1, 1);
      expect(action.range.$2, 2);
    });

    test('toJson of jump', () {
      final action = RoveAction.jump(2);
      final json = action.toJson();
      expect(json['type'], RoveActionType.jump.toJson());
      expect(json['amount'], 2);
    });

    test('fromJson of jump', () {
      final json = {'type': RoveActionType.jump.toJson(), 'amount': 2};
      final action = RoveAction.fromJson(json);
      expect(action.type, RoveActionType.jump);
      expect(action.amount, 2);
    });

    test('toJson of teleport', () {
      final action = RoveAction.teleport(3);
      final json = action.toJson();
      expect(json['type'], RoveActionType.teleport.toJson());
      expect(json['amount'], 3);
    });

    test('fromJson of teleport', () {
      final json = {'type': RoveActionType.teleport.toJson(), 'amount': 3};
      final action = RoveAction.fromJson(json);
      expect(action.type, RoveActionType.teleport);
      expect(action.amount, 3);
    });

    test('toJson of create trap', () {
      final action = RoveAction.createTrap(2, endRange: 2);
      final json = action.toJson();
      expect(json['type'], RoveActionType.createTrap.toJson());
      expect(json['amount'], 2);
      expect(json['range'], '(1, 2)');
    });

    test('fromJson of create trap', () {
      final json = {
        'type': RoveActionType.createTrap.toJson(),
        'amount': 2,
        'range': '(1, 2)'
      };
      final action = RoveAction.fromJson(json);
      expect(action.type, RoveActionType.createTrap);
      expect(action.amount, 2);
      expect(action.range.$1, 1);
      expect(action.range.$2, 2);
    });

    test('toJson of place field', () {
      final action = RoveAction.placeField(EtherField.wildfire);
      final json = action.toJson();
      expect(json['type'], RoveActionType.placeField.toJson());
      expect(json['field'], EtherField.wildfire.toJson());
    });

    test('fromJson of place field', () {
      final json = {
        'type': RoveActionType.placeField.toJson(),
        'field': EtherField.wildfire.toJson()
      };
      final action = RoveAction.fromJson(json);
      expect(action.type, RoveActionType.placeField);
      expect(action.field, EtherField.wildfire);
    });

    test('toJson of trade', () {
      final action = RoveAction.trade();
      final json = action.toJson();
      expect(json['type'], RoveActionType.trade.toJson());
      expect(json['target_kind'], TargetKind.ally.toJson());
    });

    test('fromJson of trade', () {
      final json = {
        'type': RoveActionType.trade.toJson(),
        'target_kind': TargetKind.ally.toJson()
      };
      final action = RoveAction.fromJson(json);
      expect(action.type, RoveActionType.trade);
      expect(action.targetKind, TargetKind.ally);
    });
  });
}
