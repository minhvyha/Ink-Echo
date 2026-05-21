import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inkandecho/widgets/common_buttons.dart';

import '../helpers/test_helpers.dart';

void main() {
  setUpAll(disableGoogleFontRuntimeFetching);

  testWidgets('GradientButton invokes onPressed when tapped', (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      wrapWithInkEchoTheme(
        GradientButton(
          text: 'Save',
          icon: Icons.check,
          gradient: const LinearGradient(
            colors: [Color(0xFF1B9C7A), Color(0xFF2BBF9B)],
          ),
          onPressed: () => tapped = true,
        ),
      ),
    );

    await tester.tap(find.text('Save'));
    await tester.pump();
    expect(tapped, isTrue);
  });

  testWidgets('PillButton displays label with custom colors', (tester) async {
    await tester.pumpWidget(
      wrapWithInkEchoTheme(
        const PillButton(
          text: 'Inspiring',
          background: Color(0xFFF0EBDD),
          textColor: Color(0xFF1D6053),
        ),
      ),
    );

    expect(find.text('Inspiring'), findsOneWidget);
  });
}
