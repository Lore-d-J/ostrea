import 'package:flutter/material.dart';

class AppTheme {
  // Ocean-inspired color palette
  static const Color primaryColor = Color(0xFF004E89); // Deep ocean blue
  static const Color secondaryColor = Color(0xFF0077B6); // Ocean blue
  static const Color tertiaryColor = Color(0xFF00B4D8); // Bright sea blue
  static const Color accentColor = Color(0xFFFF6B6B); // Sea coral
  static const Color backgroundColor = Color(0xFFF0F8FF); // Alice blue (light ocean)
  static const Color surfaceColor = Color(0xFFFFFFFF); // White
  static const Color errorColor = Color(0xFFD32F2F); // Red
  static const Color warningColor = Color(0xFFF57F17); // Orange
  static const Color successColor = Color(0xFF06A77D); // Sea green
  
  // Additional ocean colors
  static const Color seaGreen = Color(0xFF06A77D);
  static const Color lightTeal = Color(0xFF48CAE4);
  static const Color darkTeal = Color(0xFF023E8A);
  static const Color oceanFoam = Color(0xFFCAF0F8);
  static const Color sandColor = Color(0xFFF4E4C1);

  static ThemeData getTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
        primary: primaryColor,
        secondary: secondaryColor,
        tertiary: tertiaryColor,
      ),
      appBarTheme: AppBarTheme(
        elevation: 2,
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        centerTitle: true,
        shadowColor: secondaryColor,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: tertiaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 2,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: BorderSide(color: primaryColor, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: surfaceColor,
        shadowColor: primaryColor.withOpacity(0.2),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: oceanFoam,
        selectedColor: tertiaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        labelStyle: TextStyle(color: primaryColor, fontWeight: FontWeight.w500),
        secondaryLabelStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(
          color: primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 32,
        ),
        displayMedium: TextStyle(
          color: primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 28,
        ),
        displaySmall: TextStyle(
          color: primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
        headlineSmall: TextStyle(
          color: primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        titleLarge: TextStyle(
          color: primaryColor,
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
        bodyLarge: TextStyle(
          color: Color(0xFF333333),
          fontSize: 16,
          height: 1.5,
        ),
        bodyMedium: TextStyle(
          color: Color(0xFF666666),
          fontSize: 14,
        ),
      ),
      scaffoldBackgroundColor: backgroundColor,
      progressIndicatorTheme: ProgressIndicatorThemeData(
        circularTrackColor: oceanFoam,
        color: tertiaryColor,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: oceanFoam,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: lightTeal),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: lightTeal, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
      ),
    );
  }
}
