import 'package:flutter/material.dart';
import 'auth/auth_gate.dart';
import 'services/accessibility_settings.dart';
import 'theme/ink_echo_theme.dart';

class InkEchoApp extends StatelessWidget {
  const InkEchoApp({super.key});

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
