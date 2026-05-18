import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inkandecho/pages/settings_page.dart';
import 'package:inkandecho/services/accessibility_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/test_helpers.dart';

void main() {
  setUpAll(() async {
    disableGoogleFontRuntimeFetching();
    await ensureFirebaseInitialized();
  });

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await AccessibilitySettings.instance.load();
    await AccessibilitySettings.instance.setDarkMode(false);
  });

  testWidgets('shows settings sections and toggles dark mode', (tester) async {
    useTallTestSurface(tester);
    await tester.pumpWidget(
      wrapWithInkEchoTheme(SettingsPage(onLogout: () {})),
    );
    await tester.pumpAndSettle();

    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('ACCESSIBILITY'), findsOneWidget);

    expect(find.text('Dark mode'), findsOneWidget);

    await tester.tap(
      find.ancestor(
        of: find.text('Dark mode'),
        matching: find.byType(SwitchListTile),
      ),
    );
    await tester.pumpAndSettle();

    expect(AccessibilitySettings.instance.darkMode, isTrue);
  });
}
