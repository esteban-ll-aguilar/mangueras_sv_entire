import 'package:flutter/material.dart';


final AppTheme = ThemeData(
  primarySwatch: Colors.blue,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  fontFamily: 'Roboto',
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.black),
    titleTextStyle: TextStyle(
      color: Colors.black,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.grey.shade100,
    contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    hintStyle: TextStyle(color: Colors.grey.shade500),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16),
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: Colors.black,
      padding: const EdgeInsets.symmetric(vertical: 16),
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    ),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    selectedItemColor: Colors.black,
    unselectedItemColor: Colors.grey.shade600,
    selectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
    unselectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
    type: BottomNavigationBarType.fixed,
    elevation: 8,
    showUnselectedLabels: true,
    showSelectedLabels: true,
  ),
  cardTheme: CardThemeData(
    color: Colors.white,
    shadowColor: Colors.grey.shade200,
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
  ),
  dividerTheme: DividerThemeData(
    color: Colors.grey.shade300,
    thickness: 1,
    space: 1,
  ),
  iconTheme: const IconThemeData(
    color: Colors.black,
    size: 24,
  ),
  textTheme: TextTheme(
    headlineLarge: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black),
    headlineMedium: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
    headlineSmall: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
    bodyLarge: const TextStyle(fontSize: 18, color: Colors.grey),
    bodyMedium: TextStyle(fontSize: 16, color: Colors.grey.shade800),
    bodySmall: TextStyle(fontSize: 14, color: Colors.grey.shade600),
    labelLarge: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
    labelMedium: TextStyle(fontSize: 15, color: Colors.grey.shade700),
    labelSmall: TextStyle(fontSize: 14, color: Colors.grey.shade600),
    titleLarge: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
    titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey.shade800),
    titleSmall: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey.shade700),
    displayLarge: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.black),
    displayMedium: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
    displaySmall: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
  ),
);