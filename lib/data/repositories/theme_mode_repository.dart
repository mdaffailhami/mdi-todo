import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import 'package:mdi_todo/core/dependencies.dart';
import 'package:mdi_todo/data/data_sources/local/theme_mode_local_data_source.dart';

class ThemeModeRepository {
  final ThemeModeLocalDataSource _localDataSource =
      locator<ThemeModeLocalDataSource>();

  void set(ThemeMode themeMode) {
    try {
      _localDataSource.set(themeMode);
      _saveAndUpdateActiveTasksWidget(themeMode);
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

  Future<void> _saveAndUpdateActiveTasksWidget(ThemeMode themeMode) async {
    // Save data for app widget
    await HomeWidget.saveWidgetData('theme_mode', themeMode.name);

    // Update (Notify to reload) app widget
    await HomeWidget.updateWidget(
      name: 'ActiveTasksWidgetReceiver',
      androidName: 'ActiveTasksWidgetReceiver',
    );
  }
}
