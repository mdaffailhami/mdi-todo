import 'package:flutter/material.dart';
import 'package:mdi_todo/core/dependencies.dart';
import 'package:mdi_todo/data/data_sources/local/theme_mode_local_data_source.dart';

class ThemeModeRepository {
  final ThemeModeLocalDataSource _localDataSource =
      locator<ThemeModeLocalDataSource>();

  void set(ThemeMode themeMode) {
    try {
      _localDataSource.set(themeMode);
    } catch (e) {
      rethrow;
    }
  }

  ThemeMode? get() {
    try {
      return _localDataSource.get();
    } catch (e) {
      rethrow;
    }
  }
}
