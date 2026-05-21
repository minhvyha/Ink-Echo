// App entry: Firebase init, accessibility prefs, themed MaterialApp, AuthGate root.

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'services/accessibility_settings.dart';
import 'services/auth_gate.dart';
import 'services/auth_service.dart';
import 'theme/ink_echo_theme.dart';

/// Boots Firebase and Google Sign-In, loads saved accessibility settings,
/// then runs [MyApp] with light/dark themes tied to user preferences.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await AuthService.instance.init();
  await AccessibilitySettings.instance.load();

  runApp(const MyApp());
}

/// Root widget: applies [AccessibilitySettings] to theme and text scaling.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AccessibilitySettings.instance,
      builder: (context, _) {
        final a11y = AccessibilitySettings.instance;
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Ink & Echo',
          theme: InkEchoTheme.light(highContrast: a11y.highContrast),
          darkTheme: InkEchoTheme.dark(highContrast: a11y.highContrast),
          themeMode: a11y.darkMode ? ThemeMode.dark : ThemeMode.light,
          // Respect system-wide a11y toggles from Settings.
          builder: (context, child) {
            final media = MediaQuery.of(context);
            return MediaQuery(
              data: media.copyWith(
                textScaler: TextScaler.linear(a11y.textScale),
                boldText: a11y.boldText,
                disableAnimations: a11y.reduceMotion,
              ),
              child: child ?? const SizedBox.shrink(),
            );
          },
          home: const AuthGate(),
        );
      },
    );
  }
}
