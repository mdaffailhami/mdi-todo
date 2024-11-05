import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:mdi_todo/core/request_failure.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeModeLocalDataSource {
  final SharedPreferences sharedPreferences;

  ThemeModeLocalDataSource({required this.sharedPreferences});

  Either<RequestFailure, void> setThemeMode(ThemeMode themeMode) {
    try {
      sharedPreferences.setString('theme_mode', themeMode.name);
      return const Right(null);
    } catch (e) {
      return Left(RequestFailure(e.toString()));
    }
  }

  Either<RequestFailure, ThemeMode?> getThemeMode() {
    try {
      final themeModeName = sharedPreferences.getString('theme_mode');

      if (themeModeName == null) return const Right(null);

      return Right(ThemeMode.values.firstWhere(
        (element) => element.name == themeModeName,
      ));
    } catch (e) {
      return Left(RequestFailure(e.toString()));
    }
  }
}
