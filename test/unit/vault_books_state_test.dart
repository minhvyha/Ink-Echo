import 'package:flutter_test/flutter_test.dart';
import 'package:inkandecho/models/vault_books_state.dart';
import 'package:inkandecho/models/book.dart';

void main() {
  group('VaultBooksState', () {
    const book = Book(
      id: '1',
      title: 'T',
      author: 'A',
      echo: 'E',
    );

    test('showOfflineEmpty when offline with no cached books', () {
      const state = VaultBooksState(
        books: [],
        isOffline: true,
        isLoading: false,
      );
      expect(state.showOfflineEmpty, isTrue);
      expect(state.showOfflineNotice, isFalse);
    });

    test('showOfflineNotice when offline with cached books', () {
      const state = VaultBooksState(
        books: [book],
        isOffline: true,
      );
      expect(state.showOfflineNotice, isTrue);
      expect(state.showSyncingNotice, isFalse);
    });

    test('showSyncingNotice when from cache while online', () {
      const state = VaultBooksState(
        books: [book],
        isFromCache: true,
        isOffline: false,
      );
      expect(state.showSyncingNotice, isTrue);
    });

    test('hasError when error is set', () {
      final state = VaultBooksState(
        books: const [],
        error: Exception('fail'),
      );
      expect(state.hasError, isTrue);
    });
  });
}
