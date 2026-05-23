// Extra semantic colors (inputs, stats, cards) beyond Material [ColorScheme].

import 'package:flutter/material.dart';

/// Custom colors accessed via `Theme.of(context).extension<InkEchoPalette>()`.
@immutable
class InkEchoPalette extends ThemeExtension<InkEchoPalette> {
  final Color inputFill;
  final Color border;
  final Color emptyNotice;
  final Color statCream;
  final Color statPeach;
  final Color actionGreenBg;
  final Color actionGreenBorder;
  final Color actionGreenIcon;
  final Color actionPeachBg;
  final Color actionPeachBorder;
  final Color actionPeachIcon;
  final Color coverPlaceholder;
  final Color coverBorder;
  final Color transcriptionCard;
  final Color transcriptionBorder;
  final Color quoteOverlay;
  final Color googleButtonBg;
  final Color navUnselected;

  const InkEchoPalette({
    required this.inputFill,
    required this.border,
    required this.emptyNotice,
    required this.statCream,
    required this.statPeach,
    required this.actionGreenBg,
    required this.actionGreenBorder,
    required this.actionGreenIcon,
    required this.actionPeachBg,
    required this.actionPeachBorder,
    required this.actionPeachIcon,
    required this.coverPlaceholder,
    required this.coverBorder,
    required this.transcriptionCard,
    required this.transcriptionBorder,
    required this.quoteOverlay,
    required this.googleButtonBg,
    required this.navUnselected,
  });

  static const light = InkEchoPalette(
    inputFill: Color(0xFFF8F1E5),
    border: Color(0xFFE7E0D1),
    emptyNotice: Color(0xFFE8F2EC),
    statCream: Color(0xFFF7F2E7),
    statPeach: Color(0xFFF9D5C9),
    actionGreenBg: Color(0xFFD8FAEF),
    actionGreenBorder: Color(0xFF9FDCC8),
    actionGreenIcon: Color(0xFF0F6A57),
    actionPeachBg: Color(0xFFFDEAE4),
    actionPeachBorder: Color(0xFFE7C3B9),
    actionPeachIcon: Color(0xFF8B4D3B),
    coverPlaceholder: Color(0xFFD6E8DE),
    coverBorder: Color(0xFFB1D4C2),
    transcriptionCard: Color(0xFFFDEAE4),
    transcriptionBorder: Color(0xFFE7C3B9),
    quoteOverlay: Color(0x42FFFFFF),
    googleButtonBg: Color(0xFFF1EEE2),
    navUnselected: Color(0xFF9E9E9E),
  );

  static const highContrastLight = InkEchoPalette(
    inputFill: Colors.white,
    border: Colors.black,
    emptyNotice: Colors.white,
    statCream: Color(0xFFFFFFFF),
    statPeach: Color(0xFFFFE8E0),
    actionGreenBg: Color(0xFFE0FFF5),
    actionGreenBorder: Colors.black,
    actionGreenIcon: Color(0xFF004D40),
    actionPeachBg: Color(0xFFFFE0D6),
    actionPeachBorder: Colors.black,
    actionPeachIcon: Color(0xFF5C2E1F),
    coverPlaceholder: Color(0xFFE8F5F0),
    coverBorder: Colors.black,
    transcriptionCard: Colors.white,
    transcriptionBorder: Colors.black,
    quoteOverlay: Color(0xE6FFFFFF),
    googleButtonBg: Colors.white,
    navUnselected: Color(0xFF333333),
  );

  static const highContrastDark = InkEchoPalette(
    inputFill: Color(0xFF1A1A1A),
    border: Colors.white,
    emptyNotice: Color(0xFF1A1A1A),
    statCream: Color(0xFF1A1A1A),
    statPeach: Color(0xFF2A201E),
    actionGreenBg: Color(0xFF0D2E26),
    actionGreenBorder: Colors.white,
    actionGreenIcon: Color(0xFFB8F5E8),
    actionPeachBg: Color(0xFF2A201E),
    actionPeachBorder: Colors.white,
    actionPeachIcon: Color(0xFFFFD4C8),
    coverPlaceholder: Color(0xFF1A2A24),
    coverBorder: Colors.white,
    transcriptionCard: Color(0xFF1A1A1A),
    transcriptionBorder: Colors.white,
    quoteOverlay: Color(0xCC000000),
    googleButtonBg: Color(0xFF1A1A1A),
    navUnselected: Color(0xFFCCCCCC),
  );

  static const dark = InkEchoPalette(
    inputFill: Color(0xFF333330),
    border: Color(0xFF4A4A46),
    emptyNotice: Color(0xFF1E2E28),
    statCream: Color(0xFF2F2F2C),
    statPeach: Color(0xFF3A302C),
    actionGreenBg: Color(0xFF1E3D34),
    actionGreenBorder: Color(0xFF2D5C4E),
    actionGreenIcon: Color(0xFF8CEFD1),
    actionPeachBg: Color(0xFF3A2F2C),
    actionPeachBorder: Color(0xFF5C4540),
    actionPeachIcon: Color(0xFFF4C7B6),
    coverPlaceholder: Color(0xFF2A3530),
    coverBorder: Color(0xFF3D5248),
    transcriptionCard: Color(0xFF3A2F2C),
    transcriptionBorder: Color(0xFF5C4540),
    quoteOverlay: Color(0x66000000),
    googleButtonBg: Color(0xFF333330),
    navUnselected: Color(0xFF8A8A85),
  );

  @override
  InkEchoPalette copyWith({
    Color? inputFill,
    Color? border,
    Color? emptyNotice,
    Color? statCream,
    Color? statPeach,
    Color? actionGreenBg,
    Color? actionGreenBorder,
    Color? actionGreenIcon,
    Color? actionPeachBg,
    Color? actionPeachBorder,
    Color? actionPeachIcon,
    Color? coverPlaceholder,
    Color? coverBorder,
    Color? transcriptionCard,
    Color? transcriptionBorder,
    Color? quoteOverlay,
    Color? googleButtonBg,
    Color? navUnselected,
  }) {
    return InkEchoPalette(
      inputFill: inputFill ?? this.inputFill,
      border: border ?? this.border,
      emptyNotice: emptyNotice ?? this.emptyNotice,
      statCream: statCream ?? this.statCream,
      statPeach: statPeach ?? this.statPeach,
      actionGreenBg: actionGreenBg ?? this.actionGreenBg,
      actionGreenBorder: actionGreenBorder ?? this.actionGreenBorder,
      actionGreenIcon: actionGreenIcon ?? this.actionGreenIcon,
      actionPeachBg: actionPeachBg ?? this.actionPeachBg,
      actionPeachBorder: actionPeachBorder ?? this.actionPeachBorder,
      actionPeachIcon: actionPeachIcon ?? this.actionPeachIcon,
      coverPlaceholder: coverPlaceholder ?? this.coverPlaceholder,
      coverBorder: coverBorder ?? this.coverBorder,
      transcriptionCard: transcriptionCard ?? this.transcriptionCard,
      transcriptionBorder: transcriptionBorder ?? this.transcriptionBorder,
      quoteOverlay: quoteOverlay ?? this.quoteOverlay,
      googleButtonBg: googleButtonBg ?? this.googleButtonBg,
      navUnselected: navUnselected ?? this.navUnselected,
    );
  }

  @override
  InkEchoPalette lerp(ThemeExtension<InkEchoPalette>? other, double t) {
    if (other is! InkEchoPalette) return this;
    Color lerpColor(Color a, Color b) => Color.lerp(a, b, t)!;
    return InkEchoPalette(
      inputFill: lerpColor(inputFill, other.inputFill),
      border: lerpColor(border, other.border),
      emptyNotice: lerpColor(emptyNotice, other.emptyNotice),
      statCream: lerpColor(statCream, other.statCream),
      statPeach: lerpColor(statPeach, other.statPeach),
      actionGreenBg: lerpColor(actionGreenBg, other.actionGreenBg),
      actionGreenBorder: lerpColor(actionGreenBorder, other.actionGreenBorder),
      actionGreenIcon: lerpColor(actionGreenIcon, other.actionGreenIcon),
      actionPeachBg: lerpColor(actionPeachBg, other.actionPeachBg),
      actionPeachBorder: lerpColor(actionPeachBorder, other.actionPeachBorder),
      actionPeachIcon: lerpColor(actionPeachIcon, other.actionPeachIcon),
      coverPlaceholder: lerpColor(coverPlaceholder, other.coverPlaceholder),
      coverBorder: lerpColor(coverBorder, other.coverBorder),
      transcriptionCard: lerpColor(transcriptionCard, other.transcriptionCard),
      transcriptionBorder: lerpColor(transcriptionBorder, other.transcriptionBorder),
      quoteOverlay: lerpColor(quoteOverlay, other.quoteOverlay),
      googleButtonBg: lerpColor(googleButtonBg, other.googleButtonBg),
      navUnselected: lerpColor(navUnselected, other.navUnselected),
    );
  }
}

extension InkEchoPaletteContext on BuildContext {
  InkEchoPalette get inkPalette =>
      Theme.of(this).extension<InkEchoPalette>() ?? InkEchoPalette.light;

  bool get inkHighContrast =>
      Theme.of(this).extension<InkEchoAccessibility>()?.highContrast ?? false;
}

/// Flags for accessibility-driven theme behavior (cards, typography).
@immutable
class InkEchoAccessibility extends ThemeExtension<InkEchoAccessibility> {
  final bool highContrast;
  final bool reduceMotion;

  const InkEchoAccessibility({
    this.highContrast = false,
    this.reduceMotion = false,
  });

  @override
  InkEchoAccessibility copyWith({
    bool? highContrast,
    bool? reduceMotion,
  }) {
    return InkEchoAccessibility(
      highContrast: highContrast ?? this.highContrast,
      reduceMotion: reduceMotion ?? this.reduceMotion,
    );
  }

  @override
  InkEchoAccessibility lerp(
    ThemeExtension<InkEchoAccessibility>? other,
    double t,
  ) {
    if (other is! InkEchoAccessibility) return this;
    return t < 0.5 ? this : other;
  }
}
