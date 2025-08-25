import 'package:flutter/material.dart';

final ThemeData appTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(
    // backgroundColor: Colors.deepPurple,
    // foregroundColor: Colors.white,
     foregroundColor: Colors.black,
    backgroundColor: Colors.white,
    elevation: 0,
    centerTitle: true,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      //backgroundColor: Colors.deepPurple,
      foregroundColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    filled: true,
    fillColor: Colors.grey[100],
  ),
  cardTheme: CardTheme(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    elevation: 4,
    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
  ),
);