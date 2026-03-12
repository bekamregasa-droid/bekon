import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    fontFamily: 'Inter',
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF2C3A2A),
      primaryContainer: Color(0xFF3E4F3C),
      secondary: Color(0xFFCBA776),
      secondaryContainer: Color(0xFFDBC29F),
      surface: Colors.white,
      background: Color(0xFFF5F5F0),
      error: Color(0xFFBA4A4A),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Color(0xFF2C3A2A),
      onBackground: Color(0xFF2C3A2A),
    ),
    appBarTheme: const AppBarTheme(
      centerTitle: false,
      elevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: Color(0xFF2C3A2A),
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: Color(0xFF2C3A2A),
        fontFamily: 'Inter',
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF2C3A2A),
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          fontFamily: 'Inter',
        ),
      ),
    ),
    cardTheme: CardTheme(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: Colors.white,
      margin: EdgeInsets.zero,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    fontFamily: 'Inter',
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF2C3A2A),
      primaryContainer: Color(0xFF1A2319),
      secondary: Color(0xFFCBA776),
      secondaryContainer: Color(0xFFB48B54),
      surface: Color(0xFF1A2319),
      background: Color(0xFF0F140F),
      error: Color(0xFFBA4A4A),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.white,
      onBackground: Colors.white,
    ),
  );
}