part of 'stream_theme_mode_bloc.dart';

abstract class StreamThemeModeState {}

class StreamThemeModeInitial extends StreamThemeModeState {}

class StreamThemeModeInProgress extends StreamThemeModeState {}

class StreamThemeModeFailure extends StreamThemeModeState {}

class StreamThemeModeSuccess extends StreamThemeModeState {
  final ThemeMode themeMode;

  StreamThemeModeSuccess(this.themeMode);
}
