import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static const TextTheme _textTheme = TextTheme(
    displayLarge: TextStyle(fontSize: 32, color: AppColors.white),
    displayMedium: TextStyle(fontSize: 24, color: AppColors.white),
    displaySmall: TextStyle(fontSize: 32, color: AppColors.blue),
    bodyLarge: TextStyle(fontSize: 18, color: AppColors.white),
    bodyMedium: TextStyle(fontSize: 16, color: AppColors.white),
    bodySmall: TextStyle(fontSize: 18, color: AppColors.blue),
    labelLarge: TextStyle(fontSize: 14, color: AppColors.blue),
    labelMedium: TextStyle(fontSize: 14, color: AppColors.white),
    labelSmall: TextStyle(fontSize: 14, color: AppColors.grey),
  );

  static ThemeData lightTheme = ThemeData(
    // Основные цвета
    primaryColor: AppColors.white,
    colorScheme: const ColorScheme.light(
      primary: AppColors.blue,
      secondary: AppColors.blueLight,
      tertiary: AppColors.grey,
      error: AppColors.error,
    ),

    fontFamily: 'Helios',
    textTheme: _textTheme,

    // Поля ввода
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),

      filled: true,
      fillColor: AppColors.white,
      hintStyle: _textTheme.labelSmall,
    ),

    // AppBar
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: AppColors.blue,
      foregroundColor: AppColors.white,
    ),


  );


  // Стили кнопок
  static ButtonStyle primaryButton = ElevatedButton.styleFrom(
    backgroundColor: AppColors.blue,
    foregroundColor: AppColors.white,
    textStyle: lightTheme.textTheme.labelMedium,
    minimumSize: const Size(120, 24),
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  );

  static ButtonStyle secondaryButton = OutlinedButton.styleFrom(
    foregroundColor: AppColors.blue,
    textStyle: lightTheme.textTheme.labelLarge,
    side: const BorderSide(color: AppColors.blue),
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  );

  static ButtonStyle tertiaryButton = ElevatedButton.styleFrom(
    backgroundColor: AppColors.grey,
    foregroundColor: AppColors.white,
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  );

}