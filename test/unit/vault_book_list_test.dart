import 'package:flutter_test/flutter_test.dart';
import 'package:inkandecho/utils/vault_book_list.dart';

import '../helpers/test_helpers.dart';

void main() {
  group('vault_book_list', () {
    final books = sampleBookList();

    test('filterVaultBooks returns all books for empty query', () {
      expect(filterVaultBooks(books, ''), books);
      expect(filterVaultBooks(books, '   '), books);
    });

    test('filterVaultBooks matches title, author, echo, mood, transcription', () {
      expect(filterVaultBooks(books, 'newest'), hasLength(1));
      expect(filterVaultBooks(books, 'zed zebra'), hasLength(1));
      expect(filterVaultBooks(books, 'older echo'), hasLength(1));
      expect(filterVaultBooks(books, 'zzznomatch'), isEmpty);
    });

    test('filterVaultBooks is case insensitive', () {
      expect(filterVaultBooks(books, 'ALPHABET'), hasLength(1));
    });

    test('sortVaultBooks orders by newest', () {
      final sorted = sortVaultBooks(books, VaultSortOrder.newest);
      expect(sorted.first.title, 'Newest Book');
      expect(sorted.last.title, 'Older Book');
    });

    test('sortVaultBooks orders by oldest', () {
      final sorted = sortVaultBooks(books, VaultSortOrder.oldest);
      expect(sorted.first.title, 'Older Book');
      expect(sorted.last.title, 'Newest Book');
    });

    test('sortVaultBooks orders by title', () {
      final sorted = sortVaultBooks(books, VaultSortOrder.title);
      expect(sorted.first.title, 'Alphabet Anchor');
      expect(sorted.last.title, 'Older Book');
    });
  });
}
