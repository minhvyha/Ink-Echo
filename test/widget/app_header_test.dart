import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inkandecho/widgets/app_header.dart';

import '../helpers/test_helpers.dart';

void main() {
  setUpAll(disableGoogleFontRuntimeFetching);

  testWidgets('close button pops navigator', (tester) async {
    await tester.pumpWidget(
      wrapWithInkEchoNavigator(
        Material(
          child: Navigator(
            onGenerateRoute: (_) => MaterialPageRoute<void>(
              builder: (_) => const Scaffold(
                body: AppHeader(showClose: true),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Ink & Echo'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();
  });

  testWidgets('custom onClose callback is used', (tester) async {
    var closed = false;

    await tester.pumpWidget(
      wrapWithInkEchoTheme(
        AppHeader(
          showClose: true,
          onClose: () => closed = true,
        ),
      ),
    );
    await tester.pump();

    await tester.tap(find.byIcon(Icons.close));
    expect(closed, isTrue);
  });
}
