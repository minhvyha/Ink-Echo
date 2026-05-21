// Global accessibility preferences (theme, text scale) via SharedPreferences.

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Singleton [ChangeNotifier] read by [MyApp] and [SettingsPage].
///
/// Persists: dark mode, text scale, bold text, reduce motion, high contrast.
class AccessibilitySettings extends ChangeNotifier {
  AccessibilitySettings._();
  static final AccessibilitySettings instance = AccessibilitySettings._();

  static const _keyDarkMode = 'a11y_dark_mode';
  static const _keyTextScale = 'a11y_text_scale';
  static const _keyBoldText = 'a11y_bold_text';
  static const _keyReduceMotion = 'a11y_reduce_motion';
  static const _keyHighContrast = 'a11y_high_contrast';

  bool _loaded = false;
  bool _darkMode = false;
  double _textScale = 1.0;
  bool _boldText = false;
  bool _reduceMotion = false;
  bool _highContrast = false;

  bool get isLoaded => _loaded;
  bool get darkMode => _darkMode;
  double get textScale => _textScale;
  bool get boldText => _boldText;
  bool get reduceMotion => _reduceMotion;
  bool get highContrast => _highContrast;

  String get textScaleLabel {
    if (_textScale < 0.95) return 'Small';
    if (_textScale < 1.08) return 'Default';
    if (_textScale < 1.22) return 'Large';
    return 'Extra large';
  }

  /// Loads prefs from disk; call once in [main] before [runApp].
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _darkMode = prefs.getBool(_keyDarkMode) ?? false;
    _textScale = prefs.getDouble(_keyTextScale) ?? 1.0;
    _boldText = prefs.getBool(_keyBoldText) ?? false;
    _reduceMotion = prefs.getBool(_keyReduceMotion) ?? false;
    _highContrast = prefs.getBool(_keyHighContrast) ?? false;
    _textScale = _textScale.clamp(0.85, 1.35);
    _loaded = true;
    notifyListeners();
  }

  Future<void> setDarkMode(bool value) async {
    if (_darkMode == value) return;
    _darkMode = value;
    await _saveBool(_keyDarkMode, value);
    notifyListeners();
  }

  Future<void> setTextScale(double value) async {
    final clamped = value.clamp(0.85, 1.35);
    if ((_textScale - clamped).abs() < 0.001) return;
    _textScale = clamped;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_keyTextScale, clamped);
    notifyListeners();
  }

  Future<void> setBoldText(bool value) async {
    if (_boldText == value) return;
    _boldText = value;
    await _saveBool(_keyBoldText, value);
    notifyListeners();
  }

  Future<void> setReduceMotion(bool value) async {
    if (_reduceMotion == value) return;
    _reduceMotion = value;
    await _saveBool(_keyReduceMotion, value);
    notifyListeners();
  }

  Future<void> setHighContrast(bool value) async {
    if (_highContrast == value) return;
    _highContrast = value;
    await _saveBool(_keyHighContrast, value);
    notifyListeners();
  }

  Future<void> _saveBool(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }
}
