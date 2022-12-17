import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mdi_todo/data/repositories/theme_mode_repository.dart';

part 'theme_mode_state.dart';

class ThemeModeCubit extends Cubit<ThemeModeState> {
  final ThemeModeRepository _themeModeRepository;

  ThemeModeCubit({
    required ThemeModeRepository themeModeRepository,
  })  : _themeModeRepository = themeModeRepository,
        super(ThemeModeState(ThemeMode.system)) {
    _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    final themeMode = await _themeModeRepository.getThemeMode();

    emit(ThemeModeState(themeMode ?? ThemeMode.system));
  }

  Future<void> changeThemeMode(ThemeMode themeMode) async {
    await _themeModeRepository.setThemeMode(themeMode);

    emit(ThemeModeState(themeMode));
  }
}
