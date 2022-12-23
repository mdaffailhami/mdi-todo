import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeModeRepository {
  final _sharedPreferences = SharedPreferences.getInstance();

  Future<void> setThemeMode(ThemeMode themeMode) async {
    (await _sharedPreferences).setString('theme_mode', themeMode.name);
  }

  Future<ThemeMode?> getThemeMode() async {
    final themeModeName = (await _sharedPreferences).getString('theme_mode');

    if (themeModeName == null) return null;

    return ThemeMode.values.firstWhere(
      (element) => element.name == themeModeName,
    );
  }
}
