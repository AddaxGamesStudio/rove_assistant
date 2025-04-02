import 'package:test/test.dart';
import 'package:rove_data_types/src/actions/aoe_def.dart';

void main() {
  group('AOEDef', () {
    test('equidistant is calculated correctly', () {
      expect(AOEDef.x1Hex().equidistant, isTrue);
      expect(AOEDef.x2Front().equidistant, isTrue);
      expect(AOEDef.x3Front().equidistant, isFalse);
      expect(AOEDef.x3Line().equidistant, isFalse);
      expect(AOEDef.x3Triangle().equidistant, isTrue);
      expect(AOEDef.x5FrontSpray().equidistant, isFalse);
      expect(AOEDef.x7Honeycomb().equidistant, isFalse);
    });

    test('maxDistanceToOrigin is calculated correctly', () {
      expect(AOEDef.x1Hex().maxDistanceToOrigin, 0);
      expect(AOEDef.x2Front().maxDistanceToOrigin, 1);
      expect(AOEDef.x3Line().maxDistanceToOrigin, 2);
      expect(AOEDef.x3Triangle().maxDistanceToOrigin, 1);
      expect(AOEDef.x5FrontSpray().maxDistanceToOrigin, 2);
      expect(AOEDef.x7Honeycomb().maxDistanceToOrigin, 1);
    });
  });
}
