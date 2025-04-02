import 'package:flutter_test/flutter_test.dart';
import 'package:rove_app_common/widgets/common/rove_text.dart';

void main() {
  group('RoveText', () {
    test('Match <shield>', () {
      final List<String> components = RoveTextHelper.componentize('<shield>');
      expect(components.length, 1);
      expect(components[0], '<shield>');
    });

    test('Match [lyst]', () {
      final List<String> components = RoveTextHelper.componentize('[lyst]');
      expect(components.length, 1);
      expect(components[0], '[lyst]');
    });

    test('Match <health>', () {
      final List<String> components = RoveTextHelper.componentize('<health>');
      expect(components.length, 1);
      expect(components[0], '<health>');
    });

    test('Match multiple tags', () {
      final List<String> components =
          RoveTextHelper.componentize('<shield>Test<health>');
      expect(components.length, 3);
      expect(components[0], '<shield>');
      expect(components[1], 'Test');
      expect(components[2], '<health>');
    });

    test('Match tag at the start', () {
      final List<String> components =
          RoveTextHelper.componentize('<shield>Test');
      expect(components.length, 2);
      expect(components[0], '<shield>');
      expect(components[1], 'Test');
    });

    test('Match tag at the end', () {
      final List<String> components =
          RoveTextHelper.componentize('Test<shield>');
      expect(components.length, 2);
      expect(components[0], 'Test');
      expect(components[1], '<shield>');
    });

    test('Match tag in the middle', () {
      final List<String> components =
          RoveTextHelper.componentize('Test<shield>Test');
      expect(components.length, 3);
      expect(components[0], 'Test');
      expect(components[1], '<shield>');
      expect(components[2], 'Test');
    });

    test('Match no tag', () {
      final List<String> components = RoveTextHelper.componentize('Test');
      expect(components.length, 1);
      expect(components[0], 'Test');
    });

    test('Match empty string', () {
      final List<String> components = RoveTextHelper.componentize('');
      expect(components.length, 1);
      expect(components[0].isEmpty, true);
    });
  });
}
