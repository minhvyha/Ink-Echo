import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inkandecho/utils/book_format.dart';

import '../helpers/test_helpers.dart';

void main() {
  group('book_format', () {
    test('formatBookDate formats known dates', () {
      expect(formatBookDate(DateTime(2025, 5, 17)), 'May 17');
      expect(formatBookDateLabel(DateTime(2025, 5, 17)), 'MAY 17');
    });

    test('formatBookDate returns Recently when null', () {
      expect(formatBookDate(null), 'Recently');
    });

    test('quoteForBook prefers echo then transcription', () {
      final withEcho = sampleBook(echo: 'Primary echo');
      expect(quoteForBook(withEcho), 'Primary echo');

      final withTranscription = sampleBook(
        echo: '   ',
        transcription: 'Spoken words',
      );
      expect(quoteForBook(withTranscription), 'Spoken words');

      final fallback = sampleBook(echo: '', transcription: null);
      expect(
        quoteForBook(fallback),
        'A quiet moment waiting to be remembered.',
      );
    });

    test('tagsForBook collects mood, voice, photo, reflections', () {
      final book = sampleBook(
        mood: 'Nostalgic',
        transcription: 'note',
        coverImageBase64: 'img',
        echo: 'text',
      );
      expect(tagsForBook(book), ['Nostalgic', 'Voice note', 'Photo']);
    });

    test('tagsForBook falls back to Journal', () {
      final book = sampleBook(
        mood: null,
        transcription: null,
        coverImageBase64: null,
        echo: '',
      );
      expect(tagsForBook(book), ['Journal']);
    });

    test('estimateReadLabel scales with word count', () {
      final short = sampleBook(echo: 'one two three');
      expect(estimateReadLabel(short), '1 min read');

      final longEcho = sampleBook(
        echo: List.filled(250, 'word').join(' '),
      );
      expect(estimateReadLabel(longEcho), '2 min read');
    });

    test('bookCardPalette is stable per id and theme', () {
      final light = bookCardPalette('stable-id', Brightness.light);
      final lightAgain = bookCardPalette('stable-id', Brightness.light);
      expect(light.$1, lightAgain.$1);
      expect(light.$2, lightAgain.$2);

      final dark = bookCardPalette('stable-id', Brightness.dark);
      expect(dark.$1, isNot(light.$1));
    });
  });
}
