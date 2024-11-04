import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mdi_todo/old/repositories/theme_mode_repository.dart';

part 'change_theme_mode_event.dart';
part 'change_theme_mode_state.dart';

class ChangeThemeModeBloc
    extends Bloc<_ChangeThemeModeEvent, ChangeThemeModeState> {
  void changeThemeMode(ThemeMode themeMode) =>
      add(_ChangeThemeModeRequested(themeMode));

  ChangeThemeModeBloc({
    required ThemeModeRepository themeModeRepository,
  }) : super(ChangeThemeModeInitial()) {
    on<_ChangeThemeModeRequested>((event, emit) async {
      emit(ChangeThemeModeInProgress());

      try {
        await themeModeRepository.setThemeMode(event.themeMode);

        emit(ChangeThemeModeSuccess(event.themeMode));
      } catch (e) {
        log(e.toString());
        emit(ChangeThemeModeFailure());
      }
    });
  }
}
