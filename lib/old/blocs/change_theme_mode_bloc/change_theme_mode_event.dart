part of 'change_theme_mode_bloc.dart';

abstract class _ChangeThemeModeEvent {}

class _ChangeThemeModeRequested extends _ChangeThemeModeEvent {
  final ThemeMode themeMode;

  _ChangeThemeModeRequested(this.themeMode);
}
