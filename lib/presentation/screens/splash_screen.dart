import 'package:flutter/material.dart';

class MySplashScreen extends StatefulWidget {
  final Duration duration;
  final Widget home;

  const MySplashScreen({super.key, required this.duration, required this.home});

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(
      widget.duration,
      () => Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => widget.home,
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
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
