import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inkandecho/pages/login_page.dart';

import '../helpers/test_helpers.dart';

void main() {
  setUpAll(disableGoogleFontRuntimeFetching);

  testWidgets('validates empty email and password on submit', (tester) async {
    useTallTestSurface(tester);
    await tester.pumpWidget(wrapWithInkEchoNavigator(const LoginPage()));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.widgetWithText(ElevatedButton, 'Sign in'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.widgetWithText(ElevatedButton, 'Sign in'));
    await tester.pumpAndSettle();

    expect(find.text('Email is required'), findsOneWidget);
    expect(find.text('Password is required'), findsOneWidget);
  });

  testWidgets('validates email format and short password', (tester) async {
    useTallTestSurface(tester);
    await tester.pumpWidget(wrapWithInkEchoNavigator(const LoginPage()));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).at(0), 'not-an-email');
    await tester.enterText(find.byType(TextFormField).at(1), '123');

    await tester.scrollUntilVisible(
      find.widgetWithText(ElevatedButton, 'Sign in'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.widgetWithText(ElevatedButton, 'Sign in'));
    await tester.pumpAndSettle();

    expect(find.text('Enter a valid email'), findsOneWidget);
    expect(find.text('Use at least 6 characters'), findsOneWidget);
  });

  testWidgets('toggles sign-up mode and password visibility', (tester) async {
    useTallTestSurface(tester);
    await tester.pumpWidget(wrapWithInkEchoNavigator(const LoginPage()));
    await tester.pumpAndSettle();

    expect(find.text('Forgot password?'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('New here? Create an account'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('New here? Create an account'));
    await tester.pumpAndSettle();

    expect(find.widgetWithText(ElevatedButton, 'Create account'), findsOneWidget);
    expect(find.text('Forgot password?'), findsNothing);

    await tester.scrollUntilVisible(
      find.byIcon(Icons.visibility_outlined),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.byIcon(Icons.visibility_outlined));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
  });
}
