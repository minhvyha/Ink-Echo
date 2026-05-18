import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inkandecho/widgets/ink_echo_brand.dart';

import '../helpers/test_helpers.dart';

void main() {
  setUpAll(disableGoogleFontRuntimeFetching);

  testWidgets('shows logo icon and app name', (tester) async {
    await tester.pumpWidget(wrapWithInkEchoTheme(const InkEchoBrand()));
    await tester.pump();

    expect(find.byIcon(Icons.menu_book_rounded), findsOneWidget);
    expect(find.text('Ink & Echo'), findsOneWidget);
  });
}
