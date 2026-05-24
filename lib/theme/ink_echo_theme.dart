// Material 3 themes: light/dark + optional high-contrast overrides.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'ink_echo_page_transitions.dart';
import 'ink_echo_palette.dart';
import 'ink_echo_tokens.dart';

/// Builds [ThemeData] from [InkEchoTokens] and [InkEchoPalette] extensions.
class InkEchoTheme {
  static ThemeData light({
    bool highContrast = false,
    bool reduceMotion = false,
  }) {
    final scheme = highContrast
        ? InkEchoTokens.highContrastLightScheme()
        : InkEchoTokens.lightScheme();
    final palette =
        highContrast ? InkEchoPalette.highContrastLight : InkEchoPalette.light;

    return _buildTheme(
      scheme,
      Brightness.light,
      palette,
      highContrast: highContrast,
      reduceMotion: reduceMotion,
    );
  }

  static ThemeData dark({
    bool highContrast = false,
    bool reduceMotion = false,
  }) {
    final scheme = highContrast
        ? InkEchoTokens.highContrastDarkScheme()
        : InkEchoTokens.darkScheme();
    final palette =
        highContrast ? InkEchoPalette.highContrastDark : InkEchoPalette.dark;

    return _buildTheme(
      scheme,
      Brightness.dark,
      palette,
      highContrast: highContrast,
      reduceMotion: reduceMotion,
    );
  }

  static ThemeData _buildTheme(
    ColorScheme scheme,
    Brightness brightness,
    InkEchoPalette palette, {
    required bool highContrast,
    required bool reduceMotion,
  }) {
    final textTheme = GoogleFonts.interTextTheme(
      brightness == Brightness.light
          ? ThemeData.light().textTheme
          : ThemeData.dark().textTheme,
    ).apply(
      bodyColor: scheme.onSurface,
      displayColor: scheme.onSurface,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      cardColor: scheme.surfaceContainerLowest,
      dividerColor: highContrast ? scheme.outline : scheme.outlineVariant,
      pageTransitionsTheme: inkEchoPageTransitions(reduceMotion: reduceMotion),
      splashFactory: reduceMotion ? NoSplash.splashFactory : null,
      highlightColor: reduceMotion ? Colors.transparent : null,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return scheme.primary;
          }
          return null;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return scheme.primaryContainer;
          }
          return null;
        }),
        splashRadius: reduceMotion ? 0 : null,
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: scheme.primary,
        thumbColor: scheme.primary,
        overlayColor: scheme.primary.withValues(alpha: 0.12),
        showValueIndicator: reduceMotion
            ? ShowValueIndicator.never
            : null,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      extensions: [
        palette,
        InkEchoAccessibility(
          highContrast: highContrast,
          reduceMotion: reduceMotion,
        ),
      ],
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: palette.inputFill,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: highContrast
              ? BorderSide(color: scheme.outline, width: 1.5)
              : BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            color: scheme.primary,
            width: highContrast ? 2 : 1.2,
          ),
        ),
      ),
      dialogTheme: DialogThemeData(
        elevation: highContrast ? 0 : 24,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: highContrast
              ? BorderSide(color: scheme.outline, width: 2)
              : BorderSide.none,
        ),
      ),
    );
  }
}

extension InkEchoColors on BuildContext {
  Color get inkBackground => Theme.of(this).scaffoldBackgroundColor;
  Color get inkSurface => Theme.of(this).colorScheme.surfaceContainerLowest;
  Color get inkMuted => Theme.of(this).colorScheme.onSurfaceVariant;
  Color get inkPrimaryText => Theme.of(this).colorScheme.onSurface;
  Color get inkAccent => Theme.of(this).colorScheme.primary;
  Color get inkPrimary => Theme.of(this).colorScheme.primary;
  Color get inkSecondary => Theme.of(this).colorScheme.secondary;

  BoxDecoration get vaultCardDecoration {
    final scheme = Theme.of(this).colorScheme;
    if (inkHighContrast) {
      return BoxDecoration(
        color: scheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(InkEchoTokens.radiusMd),
        border: Border.all(color: scheme.outline, width: 2),
      );
    }
    return BoxDecoration(
      color: scheme.surfaceContainerLowest,
      borderRadius: BorderRadius.circular(InkEchoTokens.radiusMd),
      boxShadow: [
        BoxShadow(
          color: scheme.primary.withValues(alpha: 0.04),
          blurRadius: 30,
          offset: const Offset(0, 8),
        ),
      ],
    );
  }
}
