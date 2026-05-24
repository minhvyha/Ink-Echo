import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inkandecho/pages/settings_page.dart';
import 'package:inkandecho/services/accessibility_settings.dart';
import 'package:inkandecho/theme/ink_echo_palette.dart';
import 'package:inkandecho/theme/ink_echo_theme.dart';
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

  testWidgets('high contrast toggle updates accessibility settings',
      (tester) async {
    useTallTestSurface(tester);
    await tester.pumpWidget(
      ListenableBuilder(
        listenable: AccessibilitySettings.instance,
        builder: (context, _) {
          final a11y = AccessibilitySettings.instance;
          return MaterialApp(
            theme: InkEchoTheme.light(highContrast: a11y.highContrast),
            home: Scaffold(body: SettingsPage(onLogout: () {})),
          );
        },
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(
      find.ancestor(
        of: find.text('High contrast'),
        matching: find.byType(SwitchListTile),
      ),
    );
    await tester.pumpAndSettle();

    expect(AccessibilitySettings.instance.highContrast, isTrue);
    expect(
      Theme.of(tester.element(find.text('Settings')))
          .extension<InkEchoPalette>(),
      InkEchoPalette.highContrastLight,
    );
  });

  testWidgets('sign out asks for confirmation', (tester) async {
    var loggedOut = false;
    useTallTestSurface(tester);
    await tester.pumpWidget(
      wrapWithInkEchoTheme(SettingsPage(onLogout: () => loggedOut = true)),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Sign out'));
    await tester.pumpAndSettle();

    expect(find.text('Sign out?'), findsOneWidget);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(loggedOut, isFalse);

    await tester.tap(find.text('Sign out').first);
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'Sign out'));
    await tester.pumpAndSettle();
    expect(loggedOut, isTrue);
  });
}
