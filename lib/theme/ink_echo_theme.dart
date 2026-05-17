import 'package:flutter/material.dart';

class InkEchoTheme {
  static const _seed = Color(0xFF007352);
  static const _accent = Color(0xFF2BBF9B);

  static ThemeData light({required bool highContrast}) {
    final base = ColorScheme.fromSeed(
      seedColor: _seed,
      brightness: Brightness.light,
      primary: const Color(0xFF007352),
      secondary: _accent,
    );
    final scheme = highContrast
        ? base.copyWith(
            surface: Colors.white,
            onSurface: Colors.black,
            outline: Colors.black54,
          )
        : base;

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: scheme,
      scaffoldBackgroundColor:
          highContrast ? Colors.white : const Color(0xFFfffbff),
      cardColor: highContrast ? Colors.white : const Color(0xFFF7F2E7),
      dividerColor: highContrast ? Colors.black26 : const Color(0xFFE7E0D1),
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const Color(0xFF007352);
          }
          return null;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const Color(0xFF8CEFD1);
          }
          return null;
        }),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: const Color(0xFF007352),
        thumbColor: const Color(0xFF007352),
        overlayColor: const Color(0xFF007352).withValues(alpha: 0.12),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: const Color(0xFF007352),
          foregroundColor: Colors.white,
        ),
      ),
      textTheme: _textTheme(Brightness.light, highContrast),
    );
  }

  static ThemeData dark({required bool highContrast}) {
    final base = ColorScheme.fromSeed(
      seedColor: _seed,
      brightness: Brightness.dark,
      primary: _accent,
      surface: const Color(0xFF1E1E1C),
    );
    final scheme = highContrast
        ? base.copyWith(
            surface: Colors.black,
            onSurface: Colors.white,
            outline: Colors.white70,
          )
        : base;

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
      scaffoldBackgroundColor:
          highContrast ? Colors.black : const Color(0xFF1A1A18),
      cardColor: highContrast ? const Color(0xFF0D0D0D) : const Color(0xFF2A2A28),
      dividerColor: highContrast ? Colors.white38 : const Color(0xFF3D3D3A),
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return _accent;
          }
          return null;
        }),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: _accent,
        thumbColor: _accent,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: const Color(0xFF1B9C7A),
          foregroundColor: Colors.white,
        ),
      ),
      textTheme: _textTheme(Brightness.dark, highContrast),
    );
  }

  static TextTheme _textTheme(Brightness brightness, bool highContrast) {
    final base = brightness == Brightness.light
        ? ThemeData.light().textTheme
        : ThemeData.dark().textTheme;
    if (!highContrast) return base;
    return base.apply(
      bodyColor: brightness == Brightness.light ? Colors.black : Colors.white,
      displayColor: brightness == Brightness.light ? Colors.black : Colors.white,
    );
  }
}

/// Semantic surface colors used outside ThemeData (cards, headers).
extension InkEchoColors on BuildContext {
  Color get inkSurface => Theme.of(this).cardColor;
  Color get inkMuted => Theme.of(this).colorScheme.onSurface.withValues(
        alpha: Theme.of(this).brightness == Brightness.light ? 0.55 : 0.65,
      );
  Color get inkPrimaryText => Theme.of(this).colorScheme.onSurface;
  Color get inkAccent => Theme.of(this).colorScheme.secondary;
}
