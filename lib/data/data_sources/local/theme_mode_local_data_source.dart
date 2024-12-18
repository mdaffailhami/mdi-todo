import 'package:flutter/material.dart';
import 'package:mdi_todo/core/dependencies.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeModeLocalDataSource {
  final SharedPreferences sharedPreferences = locator<SharedPreferences>();

  void set(ThemeMode themeMode) {
    try {
      sharedPreferences.setString('theme_mode', themeMode.name);
    } catch (e) {
      throw Exception('Set theme mode failed : ${e.toString()}');
    }
  }

  ThemeMode? get() {
    try {
      final themeModeName = sharedPreferences.getString('theme_mode');

      if (themeModeName == null) return null;

      return ThemeMode.values.firstWhere(
        (element) => element.name == themeModeName,
      );
    } catch (e) {
      throw Exception('Get theme mode failed: ${e.toString()}');
    }
  }
}
