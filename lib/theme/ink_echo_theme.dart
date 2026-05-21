// Material 3 themes: light/dark + optional high-contrast overrides.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'ink_echo_palette.dart';
import 'ink_echo_tokens.dart';

/// Builds [ThemeData] from [InkEchoTokens] and [InkEchoPalette] extensions.
class InkEchoTheme {
  static ThemeData light({required bool highContrast}) {
    final scheme = highContrast
        ? InkEchoTokens.lightScheme().copyWith(
            surface: Colors.white,
            onSurface: Colors.black,
          )
        : InkEchoTokens.lightScheme();

    return _buildTheme(scheme, Brightness.light, InkEchoPalette.light);
  }

  static ThemeData dark({required bool highContrast}) {
    final scheme = highContrast
        ? InkEchoTokens.darkScheme().copyWith(
            surface: Colors.black,
            onSurface: Colors.white,
          )
        : InkEchoTokens.darkScheme();

    return _buildTheme(scheme, Brightness.dark, InkEchoPalette.dark);
  }

  static ThemeData _buildTheme(
    ColorScheme scheme,
    Brightness brightness,
    InkEchoPalette palette,
  ) {
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
      dividerColor: scheme.outlineVariant,
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
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: scheme.primary,
        thumbColor: scheme.primary,
        overlayColor: scheme.primary.withValues(alpha: 0.12),
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
      extensions: [palette],
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: palette.inputFill,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: scheme.primary, width: 1.2),
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

  BoxDecoration get vaultCardDecoration => BoxDecoration(
        color: Theme.of(this).colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(InkEchoTokens.radiusMd),
        boxShadow: [
          BoxShadow(
            color: Theme.of(this).colorScheme.primary.withValues(alpha: 0.04),
            blurRadius: 30,
            offset: const Offset(0, 8),
          ),
        ],
      );
}
