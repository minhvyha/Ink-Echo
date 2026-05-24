// Vault typography via Google Fonts (Playfair Display + Inter).

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'ink_echo_palette.dart';

/// Text styles for vault, cards, and headers (theme-aware colors).
extension InkEchoTypography on BuildContext {
  Color get _bodyMutedColor {
    final scheme = Theme.of(this).colorScheme;
    final hc = Theme.of(this).extension<InkEchoAccessibility>()?.highContrast;
    return hc == true ? scheme.onSurface : scheme.onSurfaceVariant;
  }
  TextStyle get vaultDisplayLg => GoogleFonts.playfairDisplay(
        fontSize: 40,
        height: 48 / 40,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.02 * 40,
        color: Theme.of(this).colorScheme.onSurface,
      );

  TextStyle get vaultDisplayMd => GoogleFonts.playfairDisplay(
        fontSize: 32,
        height: 40 / 32,
        fontWeight: FontWeight.w700,
        color: Theme.of(this).colorScheme.primary,
      );

  TextStyle get vaultBodyLg => GoogleFonts.inter(
        fontSize: 18,
        height: 28 / 18,
        fontWeight: FontWeight.w400,
        color: _bodyMutedColor,
      );

  TextStyle get vaultHeadline => GoogleFonts.inter(
        fontSize: 20,
        height: 28 / 20,
        fontWeight: FontWeight.w600,
        color: Theme.of(this).colorScheme.onSurface,
      );

  TextStyle get vaultQuote => GoogleFonts.playfairDisplay(
        fontSize: 22,
        height: 34 / 22,
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.w400,
        color: _bodyMutedColor,
      );

  TextStyle get vaultLabelSm => GoogleFonts.inter(
        fontSize: 12,
        height: 16 / 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.2,
      );

  TextStyle get vaultLabelMd => GoogleFonts.inter(
        fontSize: 14,
        height: 20 / 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.14,
      );
}
