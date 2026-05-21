import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inkandecho/models/vault_books_state.dart';
import 'package:inkandecho/models/book.dart';
import 'package:inkandecho/widgets/vault/vault_sync_banner.dart';

import '../helpers/test_helpers.dart';

void main() {
  setUpAll(disableGoogleFontRuntimeFetching);

  const book = Book(id: '1', title: 'T', author: 'A', echo: 'E');

  testWidgets('shows offline banner with retry', (tester) async {
    var retried = false;
    await tester.pumpWidget(
      wrapWithInkEchoTheme(
        VaultSyncBanner(
          state: const VaultBooksState(
            books: [book],
            isOffline: true,
          ),
          onRetry: () => retried = true,
        ),
      ),
    );

    expect(find.textContaining('offline'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);

    await tester.tap(find.text('Retry'));
    expect(retried, isTrue);
  });

  testWidgets('shows error banner with retry', (tester) async {
    await tester.pumpWidget(
      wrapWithInkEchoTheme(
        VaultSyncBanner(
          state: VaultBooksState(
            books: const [],
            error: FirebaseException(
              code: 'unavailable',
              plugin: 'cloud_firestore',
            ),
          ),
          onRetry: () {},
        ),
      ),
    );

    expect(find.textContaining('offline'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
  });

  testWidgets('hides when online and synced', (tester) async {
    await tester.pumpWidget(
      wrapWithInkEchoTheme(
        VaultSyncBanner(
          state: const VaultBooksState(
            books: [book],
            isOffline: false,
            isFromCache: false,
          ),
        ),
      ),
    );

    expect(find.byType(VaultSyncBanner), findsOneWidget);
    expect(find.text('Retry'), findsNothing);
  });
}
