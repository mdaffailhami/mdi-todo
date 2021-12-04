import 'package:flutter/material.dart';
import 'package:mdi_todo/screens/main.screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: Theme.of(context).textTheme.copyWith(
              subtitle2: const TextStyle(color: Colors.grey),
            ),
      ),
      home: const MainScreen(),
    );
  }
}
