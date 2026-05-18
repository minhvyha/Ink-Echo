import 'package:flutter/material.dart';

/// Design tokens from the Ink & Echo library dashboard spec.
abstract final class InkEchoTokens {
  static const primary = Color(0xFF28695C);
  static const onPrimary = Color(0xFFFFFFFF);
  static const primaryContainer = Color(0xFF98D8C8);
  static const onPrimaryContainer = Color(0xFF1D6053);

  static const secondary = Color(0xFF87503F);
  static const onSecondary = Color(0xFFFFFFFF);
  static const secondaryContainer = Color(0xFFFDB5A0);
  static const onSecondaryContainer = Color(0xFF794534);

  static const surface = Color(0xFFFBF9F5);
  static const onSurface = Color(0xFF1B1C1A);
  static const onSurfaceVariant = Color(0xFF3F4946);
  static const surfaceBright = Color(0xFFFBF9F5);
  static const surfaceContainer = Color(0xFFEFEEEA);
  static const surfaceContainerLow = Color(0xFFF5F3EF);
  static const surfaceContainerLowest = Color(0xFFFFFFFF);
  static const surfaceVariant = Color(0xFFE4E2DE);

  static const outline = Color(0xFF6F7976);
  static const outlineVariant = Color(0xFFBFC9C5);

  static const radiusMd = 16.0;
  static const radiusLg = 24.0;
  static const gutter = 20.0;
  static const gap = 24.0;

  static ColorScheme lightScheme() => const ColorScheme(
        brightness: Brightness.light,
        primary: primary,
        onPrimary: onPrimary,
        primaryContainer: primaryContainer,
        onPrimaryContainer: onPrimaryContainer,
        secondary: secondary,
        onSecondary: onSecondary,
        secondaryContainer: secondaryContainer,
        onSecondaryContainer: onSecondaryContainer,
        tertiary: Color(0xFF65587A),
        onTertiary: onPrimary,
        tertiaryContainer: Color(0xFFD5C5EC),
        onTertiaryContainer: Color(0xFF5D5071),
        error: Color(0xFFBA1A1A),
        onError: onPrimary,
        errorContainer: Color(0xFFFFDAD6),
        onErrorContainer: Color(0xFF93000A),
        surface: surface,
        onSurface: onSurface,
        onSurfaceVariant: onSurfaceVariant,
        outline: outline,
        outlineVariant: outlineVariant,
        shadow: Color(0xFF28695C),
        scrim: Colors.black,
        inverseSurface: Color(0xFF30312E),
        onInverseSurface: Color(0xFFF2F0ED),
        inversePrimary: Color(0xFF93D3C3),
        surfaceTint: primary,
        surfaceContainerHighest: Color(0xFFE4E2DE),
        surfaceContainerHigh: Color(0xFFEAE8E4),
        surfaceContainer: surfaceContainer,
        surfaceContainerLow: surfaceContainerLow,
        surfaceContainerLowest: surfaceContainerLowest,
      );

  static ColorScheme darkScheme() => const ColorScheme(
        brightness: Brightness.dark,
        primary: Color(0xFF93D3C3),
        onPrimary: Color(0xFF00201A),
        primaryContainer: Color(0xFF1D6053),
        onPrimaryContainer: Color(0xFFAFEFDF),
        secondary: Color(0xFFFDB5A0),
        onSecondary: Color(0xFF350F04),
        secondaryContainer: Color(0xFF6B3929),
        onSecondaryContainer: Color(0xFFFFDBD0),
        tertiary: Color(0xFFD0C0E7),
        onTertiary: Color(0xFF211633),
        tertiaryContainer: Color(0xFF4D4161),
        onTertiaryContainer: Color(0xFFECDCFF),
        error: Color(0xFFFFB4AB),
        onError: Color(0xFF690005),
        errorContainer: Color(0xFF93000A),
        onErrorContainer: Color(0xFFFFDAD6),
        surface: Color(0xFF1B1C1A),
        onSurface: Color(0xFFE4E2DE),
        onSurfaceVariant: Color(0xFFBFC9C5),
        outline: Color(0xFF6F7976),
        outlineVariant: Color(0xFF3F4946),
        shadow: Colors.black,
        scrim: Colors.black,
        inverseSurface: Color(0xFFE4E2DE),
        onInverseSurface: Color(0xFF30312E),
        inversePrimary: primary,
        surfaceTint: Color(0xFF93D3C3),
        surfaceContainerHighest: Color(0xFF3F4946),
        surfaceContainerHigh: Color(0xFF353634),
        surfaceContainer: Color(0xFF2A2B29),
        surfaceContainerLow: Color(0xFF252624),
        surfaceContainerLowest: Color(0xFF1A1B19),
      );
}
