import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mdi_todo/blocs/stream_theme_mode_bloc/stream_theme_mode_bloc.dart';
import 'package:mdi_todo/screens/home_screen.dart';
import 'package:mdi_todo/screens/splash_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<StreamThemeModeBloc>(context).streamThemeMode();

    return BlocBuilder<StreamThemeModeBloc, StreamThemeModeState>(
      builder: (context, state) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'MDI Todo',
          themeMode: state is StreamThemeModeSuccess
              ? state.themeMode
              : ThemeMode.system,
          theme: ThemeData(
            brightness: Brightness.light,
            useMaterial3: true,
            colorSchemeSeed: const Color(0xFF00579E),
            visualDensity: VisualDensity.standard,
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            useMaterial3: true,
            colorSchemeSeed: const Color(0xFF00579E),
            visualDensity: VisualDensity.standard,
          ),
          home: const MySplashScreen(
            duration: Duration(seconds: 2),
            home: MyHomeScreen(),
          ),
        );
      },
    );
  }
}
