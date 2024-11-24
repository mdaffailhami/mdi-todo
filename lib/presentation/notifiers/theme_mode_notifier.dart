import 'package:flutter/material.dart';
import 'package:mdi_todo/data/repositories/theme_mode_repository.dart';

class ThemeModeNotifier extends ChangeNotifier {
  ThemeMode _value = ThemeMode.system;
  ThemeMode get value => _value;

  final ThemeModeRepository _repository = ThemeModeRepository();

  void load() {
    late final ThemeMode? userThemeMode;

    try {
      userThemeMode = _repository.get();
    } finally {
      if (userThemeMode != _value && userThemeMode != null) {
        _value = userThemeMode;
        notifyListeners();
      }
    }
  }

  void change(ThemeMode themeMode) {
    try {
      _repository.set(themeMode);
      _value = themeMode;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}
