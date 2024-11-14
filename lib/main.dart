import 'package:flutter/material.dart';
import 'package:mdi_todo/core/dependency_injections.dart';
import 'package:mdi_todo/presentation/pages/home_page.dart';
import 'package:mdi_todo/presentation/providers/tasks_provider.dart';
import 'package:mdi_todo/presentation/providers/theme_mode_provider.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setup();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => getIt.get<ThemeModeProvider>()),
        ChangeNotifierProvider(create: (_) => getIt.get<TasksProvider>()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () {
      if (context.mounted) context.read<ThemeModeProvider>().load();
    });

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MDI Todo',
      themeMode: context.watch<ThemeModeProvider>().value ?? ThemeMode.system,
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
      home: const Scaffold(body: MyHomePage()),
      // home: const MySplashScreen(
      //   duration: Duration(seconds: 2),
      //   home: MyHomeScreen(),
      // ),
    );
  }
}
