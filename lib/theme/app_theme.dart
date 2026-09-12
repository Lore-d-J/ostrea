import 'package:flutter/material.dart';

class AppTheme {
  // Requested ocean-inspired palette
  static const Color primaryColor = Color(0xFF111313);
  static const Color secondaryColor = Color(0xFF1C2020);
  static const Color tertiaryColor = Color(0xFF11D5B4);
  static const Color accentColor = Color(0xFFEE5353);
  static const Color backgroundColor = Color(0xFFC4C7CA);
  static const Color surfaceColor = Color(0xFF000000);
  static const Color errorColor = Color(0xFFC43838);
  static const Color warningColor = Color(0xFFD7731B);
  static const Color successColor = Color(0xFF4EEAC2);

  // Additional shared color helpers
  static const Color seaGreen = successColor;
  static const Color lightTeal = tertiaryColor;
  static const Color darkTeal = Color(0xFF003F34);
  static const Color oceanFoam = Color(0xFFEAF9F7);
  static const Color sandColor = Color(0xFFF4E4C1);

  static ThemeData getTheme() {
    return _buildTheme(Brightness.light);
  }

  static ThemeData getDarkTheme() {
    return _buildTheme(Brightness.dark);
  }

  static ThemeData _buildTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: brightness,
        primary: primaryColor,
        secondary: secondaryColor,
        tertiary: tertiaryColor,
        error: errorColor,
        surface: isDark ? surfaceColor : surfaceColor,
      ),
      appBarTheme: AppBarTheme(
        elevation: 2,
        backgroundColor: primaryColor,
        foregroundColor: isDark ? tertiaryColor : Colors.white,
        centerTitle: true,
        shadowColor: secondaryColor,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: tertiaryColor,
        foregroundColor: isDark ? Color(0xFF111313) : Colors.white,
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
          foregroundColor: tertiaryColor,
          side: BorderSide(color: tertiaryColor, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        color: isDark ? secondaryColor : Colors.white,
        shadowColor: primaryColor.withValues(alpha: 0.1),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: isDark ? secondaryColor : oceanFoam,
        selectedColor: tertiaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        labelStyle: TextStyle(color: tertiaryColor, fontWeight: FontWeight.w500),
        secondaryLabelStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(
          color: isDark ? tertiaryColor : primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 32,
        ),
        displayMedium: TextStyle(
          color: isDark ? tertiaryColor : primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 28,
        ),
        displaySmall: TextStyle(
          color: isDark ? tertiaryColor : primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
        headlineSmall: TextStyle(
          color: isDark ? tertiaryColor : primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        titleLarge: TextStyle(
          color: isDark ? tertiaryColor : primaryColor,
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
        bodyLarge: TextStyle(
          color: isDark ? Colors.white : Color(0xFF333333),
          fontSize: 16,
          height: 1.5,
        ),
        bodyMedium: TextStyle(
          color: isDark ? Colors.white70 : Color(0xFF666666),
          fontSize: 14,
        ),
      ),
      scaffoldBackgroundColor: isDark ? surfaceColor : backgroundColor,
      progressIndicatorTheme: ProgressIndicatorThemeData(
        circularTrackColor: oceanFoam,
        color: tertiaryColor,
        linearTrackColor: tertiaryColor.withValues(alpha: 0.1),
        linearMinHeight: 12,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? secondaryColor : oceanFoam,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: tertiaryColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: tertiaryColor, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: tertiaryColor, width: 2),
        ),
      ),
    );
  }
}
