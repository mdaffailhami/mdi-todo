import 'package:flutter/material.dart';

class MySplashScreen extends StatelessWidget {
  final Duration duration;
  final Widget home;

  const MySplashScreen({
    super.key,
    required this.duration,
    required this.home,
  });

  @override
  Widget build(BuildContext context) {
    Future.delayed(
      duration,
      () => Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => home,
      )),
    );

    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/mdi-todo-logo.png',
          width: 144,
        ),
      ),
    );
  }
}
