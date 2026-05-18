import 'package:flutter_test/flutter_test.dart';
import 'package:inkandecho/widgets/bottom_nav_bar.dart';

import '../helpers/test_helpers.dart';

void main() {
  setUpAll(disableGoogleFontRuntimeFetching);

  testWidgets('highlights selected tab and reports changes', (tester) async {
    var index = 0;

    await tester.pumpWidget(
      wrapWithInkEchoTheme(
        AppBottomNavBar(
          currentIndex: index,
          onChanged: (value) => index = value,
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Vault'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);

    await tester.tap(find.text('Settings'));
    expect(index, 1);

    await tester.pumpWidget(
      wrapWithInkEchoTheme(
        AppBottomNavBar(
          currentIndex: index,
          onChanged: (value) => index = value,
        ),
      ),
    );
    await tester.pump();

    await tester.tap(find.text('Vault'));
    expect(index, 0);
  });
}
