import 'package:flutter/material.dart';
import 'package:mdi_todo/core/request_failure.dart';
import 'package:mdi_todo/core/request_state.dart';
import 'package:mdi_todo/data/repositories/theme_mode_repository.dart';

class ThemeModeProvider extends ChangeNotifier {
  final ThemeModeRepository repository;

  ThemeModeProvider({required this.repository});

  RequestState state = RequestState.loading;
  ThemeMode? value;
  RequestFailure? error;

  void load() {
    repository.getThemeMode().fold(
      (failure) {
        error = failure;
        state = RequestState.failed;
      },
      (value) {
        this.value = value;
        state = RequestState.loaded;
      },
    );

    notifyListeners();
  }

  void change(ThemeMode value) {
    repository.setThemeMode(value).fold(
      (failure) {
        error = failure;
        state = RequestState.failed;
      },
      (_) {
        this.value = value;
        state = RequestState.loaded;
      },
    );

    notifyListeners();
  }
}
