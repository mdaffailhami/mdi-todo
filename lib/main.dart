import 'package:flutter/material.dart';
import 'package:mdi_todo/core/dependencies.dart';
import 'package:mdi_todo/presentation/notifiers/theme_mode_notifier.dart';
import 'package:mdi_todo/presentation/pages/home_page.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await injectDependencies();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeModeNotifier()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Load user's theme mode
      context.read<ThemeModeNotifier>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MDI Todo',
      themeMode: context.watch<ThemeModeNotifier>().value,
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
