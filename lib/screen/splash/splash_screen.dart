import 'dart:async';
import 'package:e_book_app/screen/screen.dart';
import 'package:flutter/material.dart';
class SplashScreen extends StatelessWidget {
  static const String routeName = '/splash';

  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 2), () => Navigator.pushNamedAndRemoveUntil(context, MainScreen.routeName, (route) => false));
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onBackground,
      body: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Image(image: AssetImage('assets/logo/logo.png')),
          ),
        ],
      ),
    );
  }
}
