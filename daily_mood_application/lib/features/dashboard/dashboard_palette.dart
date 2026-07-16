import 'package:flutter/material.dart';

class DashboardPalette {
  DashboardPalette._();

  static ThemeMode _themeMode = ThemeMode.system;
  static Brightness _platformBrightness = Brightness.light;

  static void resolve({
    required ThemeMode themeMode,
    required Brightness platformBrightness,
  }) {
    _themeMode = themeMode;
    _platformBrightness = platformBrightness;
  }

  static bool get _isDark {
    return switch (_themeMode) {
      ThemeMode.dark => true,
      ThemeMode.light => false,
      ThemeMode.system => _platformBrightness == Brightness.dark,
    };
  }

  static Color get background =>
      _isDark ? const Color(0xFF15131B) : const Color(0xFFF8F1F3);
  static Color get surface =>
      _isDark ? const Color(0xFF211D2A) : const Color(0xFFFFFFFF);
  static Color get lilacPanel =>
      _isDark ? const Color(0xFF3A3158) : const Color(0xFFE1D8F8);
  static Color get pinkPanel =>
      _isDark ? const Color(0xFF4D2638) : const Color(0xFFF8D6E3);
  static Color get purple =>
      _isDark ? const Color(0xFFB89CFF) : const Color(0xFF8B4CFC);
  static Color get deepText =>
      _isDark ? const Color(0xFFF8F4FF) : const Color(0xFF17141B);
  static Color get mutedText =>
      _isDark ? const Color(0xFFCFC6D9) : const Color(0xFF746E7E);
  static Color get divider =>
      _isDark ? const Color(0xFF3A3344) : const Color(0xFFE9E2EA);
  static Color get hotPink =>
      _isDark ? const Color(0xFFFF8AB9) : const Color(0xFFFF4D96);
  static Color get green =>
      _isDark ? const Color(0xFF8FEFB0) : const Color(0xFF73E894);
  static Color get blue =>
      _isDark ? const Color(0xFFA7D0FF) : const Color(0xFF78B8FF);
  static Color get orange =>
      _isDark ? const Color(0xFFFFBE8B) : const Color(0xFFFF9B62);
}
