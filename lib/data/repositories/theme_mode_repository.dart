import 'package:flutter/material.dart';
import 'package:mdi_todo/data/data_sources/local/theme_mode_local_data_source.dart';

class ThemeModeRepository {
  final ThemeModeLocalDataSource localDataSource = ThemeModeLocalDataSource();

  void set(ThemeMode themeMode) {
    try {
      localDataSource.set(themeMode);
    } catch (e) {
      rethrow;
    }
  }

  ThemeMode? get() {
    try {
      return localDataSource.get();
    } catch (e) {
      rethrow;
    }
  }
}
