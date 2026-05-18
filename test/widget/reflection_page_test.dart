import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inkandecho/pages/reflection_page.dart';

import '../helpers/test_helpers.dart';

void main() {
  setUpAll(disableGoogleFontRuntimeFetching);

  testWidgets('shows add reflection form and validates required fields',
      (tester) async {
    useTallTestSurface(tester);
    await tester.pumpWidget(
      wrapWithInkEchoNavigator(const ReflectionPage()),
    );
    await tester.pumpAndSettle(const Duration(seconds: 2));

    expect(find.text('Add a book'), findsOneWidget);
    expect(find.text('Ink & Echo'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Save book'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Save book'));
    await tester.pumpAndSettle();

    expect(
      find.text('Please add a title and author before saving.'),
      findsOneWidget,
    );
  });

  testWidgets('close button pops navigator', (tester) async {
    await tester.pumpWidget(
      wrapWithInkEchoNavigator(
        Material(
          child: Navigator(
            onGenerateRoute: (_) => MaterialPageRoute<void>(
              builder: (_) => const ReflectionPage(),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle(const Duration(seconds: 2));

    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();
  });
}
