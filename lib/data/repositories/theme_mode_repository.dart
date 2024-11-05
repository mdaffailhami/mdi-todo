import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:mdi_todo/core/request_failure.dart';
import 'package:mdi_todo/data/data_sources/local/theme_mode_local_data_source.dart';

class ThemeModeRepository {
  final ThemeModeLocalDataSource localDataSource;

  ThemeModeRepository({required this.localDataSource});

  Either<RequestFailure, void> setThemeMode(ThemeMode themeMode) {
    return localDataSource.setThemeMode(themeMode);
  }

  Either<RequestFailure, ThemeMode?> getThemeMode() {
    return localDataSource.getThemeMode();
  }
}
