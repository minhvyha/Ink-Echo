import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inkandecho/pages/vault_page.dart';
import 'package:inkandecho/services/book_service.dart';
import 'package:inkandecho/services/connectivity_service.dart';

import '../helpers/test_helpers.dart';

void main() {
  setUpAll(() {
    disableGoogleFontRuntimeFetching();
  });

  late BookService emptyVaultService;

  setUp(() {
    emptyVaultService = createTestBookService();
  });

  testWidgets('shows vault header and new entry when library is empty',
      (tester) async {
    useTallTestSurface(tester);
    await tester.pumpWidget(
      wrapWithInkEchoNavigator(
        VaultPage(
          onOpenSettings: () {},
          bookService: emptyVaultService,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Your Vault'), findsOneWidget);
    expect(find.text('Start a New Entry'), findsOneWidget);
    expect(find.byIcon(Icons.menu), findsOneWidget);
    expect(find.byIcon(Icons.search), findsOneWidget);
  });

  testWidgets('opens search mode from app bar', (tester) async {
    useTallTestSurface(tester);
    await tester.pumpWidget(
      wrapWithInkEchoNavigator(
        VaultPage(
          onOpenSettings: () {},
          bookService: emptyVaultService,
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.search));
    await tester.pumpAndSettle();

    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Results'), findsNothing);
  });

  testWidgets('displays seeded books from injected BookService', (tester) async {
    useTallTestSurface(tester);
    final service = await createSeededBookService(
      id: 'seed-1',
      title: 'Seeded Book',
      echo: 'A reflection',
    );

    await tester.pumpWidget(
      wrapWithInkEchoNavigator(
        VaultPage(onOpenSettings: () {}, bookService: service),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Seeded Book'), findsOneWidget);
  });

  testWidgets('tapping featured card opens book detail', (tester) async {
    useTallTestSurface(tester);
    final service = await createSeededBookService(
      id: 'feat-1',
      title: 'Featured Entry',
      echo: 'Echo text',
    );

    await tester.pumpWidget(
      wrapWithInkEchoNavigator(
        Material(
          child: VaultPage(
            onOpenSettings: () {},
            bookService: service,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Featured Entry'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Echo text'), findsOneWidget);
    expect(find.text('Edit'), findsOneWidget);
  });

  testWidgets('search filters visible entries', (tester) async {
    useTallTestSurface(tester);
    final firestore = FakeFirebaseFirestore();
    await seedTestBook(
      firestore,
      id: 'a1',
      title: 'Alpha',
      echo: 'alpha echo',
      createdAt: DateTime(2025, 5, 20),
    );
    await seedTestBook(
      firestore,
      id: 'b1',
      title: 'Beta',
      echo: 'beta echo',
      createdAt: DateTime(2025, 5, 19),
    );
    final service = createTestBookService(firestore: firestore);

    await tester.pumpWidget(
      wrapWithInkEchoNavigator(
        VaultPage(onOpenSettings: () {}, bookService: service),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.search));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Alpha');
    await tester.pumpAndSettle();

    expect(find.text('1 entry found'), findsOneWidget);
    expect(find.text('Beta'), findsNothing);
  });

  testWidgets('shows offline empty state with retry when offline and no books',
      (tester) async {
    useTallTestSurface(tester);
    ConnectivityService.instance.setOnlineForTesting(false);
    addTearDown(() => ConnectivityService.instance.setOnlineForTesting(true));

    await tester.pumpWidget(
      wrapWithInkEchoNavigator(
        VaultPage(
          onOpenSettings: () {},
          bookService: emptyVaultService,
        ),
      ),
    );
    await pumpBrief(tester, const Duration(milliseconds: 600));

    expect(find.text('You\'re offline'), findsOneWidget);
    expect(find.text('Try again'), findsOneWidget);
  });

  testWidgets('opens drawer from menu button', (tester) async {
    useTallTestSurface(tester);
    await tester.pumpWidget(
      wrapWithInkEchoNavigator(
        VaultPage(
          onOpenSettings: () {},
          bookService: emptyVaultService,
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();

    expect(find.text('Your reading journal'), findsOneWidget);
    expect(find.text('SORT ENTRIES'), findsOneWidget);
  });
}
