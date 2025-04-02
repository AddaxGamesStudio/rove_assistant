import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rove_app_common/widgets/common/rove_text.dart';

void main() {
  group('RoveTextHelper.textSpansWithMarkdown', () {
    final baseStyle = const TextStyle(fontSize: 14.0, color: Colors.black);

    test('handles plain text without markdown', () {
      final spans = RoveTextHelper.textSpansWithMarkdown(
        text: 'Plain text',
        baseStyle: baseStyle,
      );

      expect(spans.length, 1);
      expect((spans[0]).text, 'Plain text');
      expect((spans[0]).style, baseStyle);
    });

    test('handles bold text with **', () {
      final spans = RoveTextHelper.textSpansWithMarkdown(
        text: 'Hello **bold** world',
        baseStyle: baseStyle,
      );

      expect(spans.length, 3);
      expect((spans[0]).text, 'Hello ');
      expect((spans[1]).text, 'bold');
      expect((spans[1]).style?.fontWeight, FontWeight.bold);
      expect((spans[2]).text, ' world');
    });

    test('handles italic text with *', () {
      final spans = RoveTextHelper.textSpansWithMarkdown(
        text: 'Hello *italic* world',
        baseStyle: baseStyle,
      );

      expect(spans.length, 3);
      expect((spans[0]).text, 'Hello ');
      expect((spans[1]).text, 'italic');
      expect((spans[1]).style?.fontStyle, FontStyle.italic);
      expect((spans[2]).text, ' world');
    });

    test('handles bold italic text with ***', () {
      final spans = RoveTextHelper.textSpansWithMarkdown(
        text: 'Hello ***bold italic*** world',
        baseStyle: baseStyle,
      );

      expect(spans.length, 3);
      expect((spans[0]).text, 'Hello ');
      expect((spans[1]).text, 'bold italic');
      expect((spans[1]).style?.fontWeight, FontWeight.bold);
      expect((spans[1]).style?.fontStyle, FontStyle.italic);
      expect((spans[2]).text, ' world');
    });

    test('handles multiple markdown styles in one text', () {
      final spans = RoveTextHelper.textSpansWithMarkdown(
        text: '**bold** and *italic* and ***both***',
        baseStyle: baseStyle,
      );

      expect(spans.length, 5);
      expect((spans[0]).text, 'bold');
      expect((spans[0]).style?.fontWeight, FontWeight.bold);
      expect((spans[1]).text, ' and ');
      expect((spans[2]).text, 'italic');
      expect((spans[2]).style?.fontStyle, FontStyle.italic);
      expect((spans[3]).text, ' and ');
      expect((spans[4]).text, 'both');
      expect((spans[4]).style?.fontWeight, FontWeight.bold);
      expect((spans[4]).style?.fontStyle, FontStyle.italic);
    });
  });
}
