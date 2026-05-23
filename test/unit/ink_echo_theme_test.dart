import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inkandecho/theme/ink_echo_page_transitions.dart';
import 'package:inkandecho/theme/ink_echo_palette.dart';
import 'package:inkandecho/theme/ink_echo_tokens.dart';

void main() {
  group('InkEcho accessibility tokens', () {
    test('highContrastLightScheme uses strong contrast colors', () {
      final scheme = InkEchoTokens.highContrastLightScheme();
      expect(scheme.onSurface, Colors.black);
      expect(scheme.outline, Colors.black);
      expect(scheme.surface, Colors.white);
    });

    test('highContrastDarkScheme uses strong contrast colors', () {
      final scheme = InkEchoTokens.highContrastDarkScheme();
      expect(scheme.onSurface, Colors.white);
      expect(scheme.outline, Colors.white);
      expect(scheme.surface, Colors.black);
    });

    test('high contrast palettes use visible borders', () {
      expect(InkEchoPalette.highContrastLight.border, Colors.black);
      expect(InkEchoPalette.highContrastDark.border, Colors.white);
    });

    test('reduce motion page transitions are instant', () {
      final transitions = inkEchoPageTransitions(reduceMotion: true);
      expect(
        transitions.builders[TargetPlatform.android],
        isA<InkEchoInstantPageTransitionsBuilder>(),
      );
      expect(
        transitions.builders[TargetPlatform.iOS],
        isA<InkEchoInstantPageTransitionsBuilder>(),
      );
    });
  });
}
