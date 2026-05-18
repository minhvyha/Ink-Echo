import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inkandecho/pages/vault_page.dart';

import '../helpers/test_helpers.dart';

void main() {
  setUpAll(() {
    disableGoogleFontRuntimeFetching();
  });

  setUp(() async {
    await ensureFirebaseInitialized();
  });

  testWidgets('shows vault header and new entry when library is empty',
      (tester) async {
    useTallTestSurface(tester);
    await tester.pumpWidget(
      wrapWithInkEchoNavigator(
        VaultPage(onOpenSettings: () {}),
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
        VaultPage(onOpenSettings: () {}),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.search));
    await tester.pumpAndSettle();

    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Results'), findsNothing);
  });

  testWidgets('opens drawer from menu button', (tester) async {
    useTallTestSurface(tester);
    await tester.pumpWidget(
      wrapWithInkEchoNavigator(
        VaultPage(onOpenSettings: () {}),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();

    expect(find.text('Your reading journal'), findsOneWidget);
    expect(find.text('SORT ENTRIES'), findsOneWidget);
  });
}
