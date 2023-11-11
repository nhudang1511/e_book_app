import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    appBarTheme: const AppBarTheme(backgroundColor: Colors.black),
    fontFamily: 'OpenSans',
    colorScheme: const ColorScheme.dark(
        background: Colors.black,
        primary: Color(0xFF8C2EEE),
        secondary: Colors.white,
        onBackground: Color(0xFF122158),
        secondaryContainer: Colors.white,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
          color: Colors.white,
          fontSize: 32,
          fontWeight: FontWeight.bold
      ),
      displayMedium: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold
      ),
      displaySmall: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold
      ),
      headlineMedium: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold
      ),
      headlineSmall: TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold
      ),
      titleLarge: TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.normal
      ),
      bodyLarge: TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.normal
      ),
      bodyMedium: TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.normal
      ),
      labelSmall: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.normal
      ),
      bodySmall: TextStyle(
        color: Colors.black,
        fontSize: 16,
        fontWeight: FontWeight.bold
      ),
    )
);