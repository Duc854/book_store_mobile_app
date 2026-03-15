import 'package:flutter/material.dart';

class AppTheme {

  static const primary = Color(0xFF2C3E50);
  static const secondary = Color(0xFFECF0F1);
  static const accent = Color(0xFF27AE60);
  static const error = Color(0xFFE74C3C);
  static const price = Color(0xFFE67E22);

  static ThemeData theme = ThemeData(

    fontFamily: "Roboto",

    primaryColor: primary,

    scaffoldBackgroundColor: secondary,

    appBarTheme: const AppBarTheme(
      backgroundColor: primary,
      foregroundColor: Colors.white,
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: accent,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: accent,
        foregroundColor: Colors.white,
      ),
    ),
  );
}