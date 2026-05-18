import 'package:flutter_test/flutter_test.dart';
import 'package:inkandecho/services/accessibility_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('AccessibilitySettings', () {
    late AccessibilitySettings settings;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      settings = AccessibilitySettings.instance;
    });

    test('load restores persisted values', () async {
      SharedPreferences.setMockInitialValues({
        'a11y_dark_mode': true,
        'a11y_text_scale': 1.2,
        'a11y_bold_text': true,
        'a11y_reduce_motion': true,
        'a11y_high_contrast': true,
      });

      await settings.load();

      expect(settings.isLoaded, isTrue);
      expect(settings.darkMode, isTrue);
      expect(settings.textScale, 1.2);
      expect(settings.boldText, isTrue);
      expect(settings.reduceMotion, isTrue);
      expect(settings.highContrast, isTrue);
      expect(settings.textScaleLabel, 'Large');
    });

    test('setDarkMode persists and notifies', () async {
      await settings.load();
      var notified = false;
      settings.addListener(() => notified = true);

      await settings.setDarkMode(true);

      expect(settings.darkMode, isTrue);
      expect(notified, isTrue);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool('a11y_dark_mode'), isTrue);
    });

    test('setTextScale clamps to supported range', () async {
      await settings.load();

      await settings.setTextScale(2.0);
      expect(settings.textScale, 1.35);
      expect(settings.textScaleLabel, 'Extra large');

      await settings.setTextScale(0.5);
      expect(settings.textScale, 0.85);
    });
  });
}
