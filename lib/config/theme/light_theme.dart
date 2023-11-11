import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    appBarTheme: const AppBarTheme(backgroundColor: Colors.transparent),
    fontFamily: 'OpenSans',
    colorScheme: const ColorScheme.light(
        background: Colors.white,
        primary: Color(0xFF8C2EEE),
        secondary: Color(0xFFC7C7C7),
        onBackground: Color(0xFFEEE6F5),
        secondaryContainer: Colors.black54,
    ),
    textTheme: const TextTheme(
        displayLarge: TextStyle(
            color: Colors.black,
            fontSize: 32,
            fontWeight: FontWeight.bold
        ),
        displayMedium: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold
        ),
        displaySmall: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold
        ),
        headlineMedium: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold
        ),
        headlineSmall: TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.bold
        ),
        titleLarge: TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.normal
        ),
        bodyLarge: TextStyle(
            color: Colors.black,
            fontSize: 12,
            fontWeight: FontWeight.normal
        ),
        bodyMedium: TextStyle(
            color: Colors.black,
            fontSize: 10,
            fontWeight: FontWeight.normal
        ),
        labelSmall: TextStyle(
            color: Color(0xFFC7C7C7),
            fontSize: 18,
            fontWeight: FontWeight.normal
        ),
        bodySmall: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold
        ),

    )
);