import 'package:flutter/material.dart';
import 'colors.dart';
import 'text_styles.dart';

class AppTheme {
  //
  // DARK THEME
  //

  static ThemeData get dark => ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,

    // Couleurs principales
    colorScheme: const ColorScheme.dark(
      primary: AppColors.green,
      primaryContainer: AppColors.greenDark,
      secondary: AppColors.red,
      error: AppColors.redLight,
      surface: AppColors.bgCardDark,
      onPrimary: AppColors.textPrimaryDark,
      onSecondary: AppColors.textSecondaryDark,
      onSurface: AppColors.textPrimaryDark,
    ),

    // Background
    scaffoldBackgroundColor: AppColors.bgDark,

    // Icon
    iconTheme: const IconThemeData(color: AppColors.iconDark),

    // AppBar
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.bgSidebarDark,
      foregroundColor: AppColors.textPrimaryDark,
      elevation: 0,
      titleTextStyle: AppTextStyles.headingDark,
    ),

    // Cards
    cardTheme: CardThemeData(
      color: AppColors.bgCardDark,
      elevation: 10,
      shadowColor: const Color(0xFF555555),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      margin: EdgeInsets.zero,
    ),

    // Inputs
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.bgInputDark,
      hintStyle: AppTextStyles.captionDark,
      labelStyle: AppTextStyles.labelDark,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.green, width: 1.5),
      ),
    ),

    // Boutons principaux
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.colorButton,
        foregroundColor: AppColors.textOnButton,
        textStyle: AppTextStyles.buttonDark,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 0,
      ),
    ),

    // Boutons texte
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Colors.grey,
        side: const BorderSide(color: Colors.grey),
        textStyle: AppTextStyles.labelDark,
      ),
    ),

    // Texte global
    textTheme: const TextTheme(
      displayLarge: AppTextStyles.displayLargeDark,
      displaySmall: AppTextStyles.displaySmallDark,
      headlineMedium: AppTextStyles.headingDark,
      headlineSmall: AppTextStyles.headingSmallDark,
      bodyLarge: AppTextStyles.bodyDark,
      bodyMedium: AppTextStyles.bodySecondaryDark,
      labelLarge: AppTextStyles.labelDark,
      bodySmall: AppTextStyles.captionDark,
    ),

    // Divider
    dividerTheme: const DividerThemeData(
      color: AppColors.bgHoverDark,
      thickness: 1,
    ),
  );

  //
  // LIGHT THEME
  //
  static ThemeData get light => ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,

    // Couleurs principales
    colorScheme: const ColorScheme.light(
      primary: AppColors.green,
      primaryContainer: AppColors.greenLight,
      secondary: AppColors.red,
      error: AppColors.redDark,
      surface: AppColors.bgCardLight,
      onPrimary: AppColors.textPrimaryLight,
      onSecondary: AppColors.textSecondaryLight,
      onSurface: AppColors.textPrimaryLight,
    ),

    // Background
    scaffoldBackgroundColor: AppColors.bgLight,

    // Icon
    iconTheme: const IconThemeData(color: AppColors.iconLight),

    // AppBar
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.bgSidebarLight,
      foregroundColor: AppColors.textPrimaryLight,
      elevation: 0,
      titleTextStyle: AppTextStyles.headingLight,
    ),

    // Cards
    cardTheme: CardThemeData(
      color: AppColors.bgCardLight,
      elevation: 10,
      shadowColor: Color(0xFF000000),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      margin: EdgeInsets.zero,
    ),

    // Inputs
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.bgInputLight,
      hintStyle: AppTextStyles.captionLight,
      labelStyle: AppTextStyles.labelLight,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.green, width: 1.5),
      ),
    ),

    // Boutons principaux
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.green,
        foregroundColor: AppColors.textOnButton,
        textStyle: AppTextStyles.buttonLight,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 0,
      ),
    ),

    // Boutons texte
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.greenDark,
        textStyle: AppTextStyles.labelLight,
      ),
    ),

    // Texte global
    textTheme: const TextTheme(
      displayLarge: AppTextStyles.displayLargeLight,
      displaySmall: AppTextStyles.displaySmallLight,
      headlineMedium: AppTextStyles.headingLight,
      headlineSmall: AppTextStyles.headingSmallLight,
      bodyLarge: AppTextStyles.bodyLight,
      bodyMedium: AppTextStyles.bodySecondaryLight,
      labelLarge: AppTextStyles.labelLight,
      bodySmall: AppTextStyles.captionLight,
    ),

    // Divider
    dividerTheme: const DividerThemeData(
      color: AppColors.bgHoverLight,
      thickness: 1,
    ),
  );
}
