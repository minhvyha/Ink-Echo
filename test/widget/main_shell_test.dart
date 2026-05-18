import 'package:flutter_test/flutter_test.dart';
import 'package:inkandecho/pages/main_shell.dart';

import '../helpers/test_helpers.dart';

void main() {
  setUpAll(() async {
    disableGoogleFontRuntimeFetching();
    await ensureFirebaseInitialized();
  });

  testWidgets('switches between vault and settings tabs', (tester) async {
    await tester.pumpWidget(
      wrapWithInkEchoNavigator(
        MainShell(onLogout: () {}),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Your Vault'), findsOneWidget);

    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();

    expect(find.text('PREFERENCES'), findsOneWidget);
    expect(find.text('Your Vault'), findsNothing);
  });
}
