part of 'change_theme_mode_bloc.dart';

abstract class ChangeThemeModeState {}

class ChangeThemeModeInitial extends ChangeThemeModeState {}

class ChangeThemeModeInProgress extends ChangeThemeModeState {}

class ChangeThemeModeFailure extends ChangeThemeModeState {}

class ChangeThemeModeSuccess extends ChangeThemeModeState {
  final ThemeMode changedThemeMode;

  ChangeThemeModeSuccess(this.changedThemeMode);
}
