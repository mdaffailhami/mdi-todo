part of 'stream_theme_mode_bloc.dart';

abstract class _StreamThemeModeEvent {}

class _StreamThemeModeRequested extends _StreamThemeModeEvent {}

class _ThemeModeChanged extends _StreamThemeModeEvent {
  final ThemeMode themeMode;

  _ThemeModeChanged(this.themeMode);
}
