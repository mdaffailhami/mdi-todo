import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mdi_todo/blocs/change_theme_mode_bloc/change_theme_mode_bloc.dart';
import 'package:mdi_todo/repositories/theme_mode_repository.dart';

part 'stream_theme_mode_event.dart';
part 'stream_theme_mode_state.dart';

class StreamThemeModeBloc
    extends Bloc<_StreamThemeModeEvent, StreamThemeModeState> {
  late StreamSubscription<ChangeThemeModeState>? _changeThemeModeSubscription;

  void streamThemeMode() => add(_StreamThemeModeRequested());

  @override
  Future<void> close() {
    _changeThemeModeSubscription?.cancel();
    return super.close();
  }

  StreamThemeModeBloc({
    required ChangeThemeModeBloc changeThemeModeBloc,
    required ThemeModeRepository themeModeRepository,
  }) : super(StreamThemeModeInitial()) {
    on<_StreamThemeModeRequested>((event, emit) async {
      emit(StreamThemeModeInProgress());

      try {
        final themeMode = await themeModeRepository.getThemeMode();

        _changeThemeModeSubscription = changeThemeModeBloc.stream.listen(
          (state) {
            if (state is ChangeThemeModeSuccess) {
              add(_ThemeModeChanged(state.changedThemeMode));
            }
          },
        );

        emit(StreamThemeModeSuccess(themeMode ?? ThemeMode.system));
      } catch (e) {
        log(e.toString());
        emit(StreamThemeModeFailure());
      }
    });

    on<_ThemeModeChanged>((event, emit) {
      emit(StreamThemeModeSuccess(event.themeMode));
    });
  }
}
