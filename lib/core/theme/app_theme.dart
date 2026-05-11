import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Brand Colors (Modern Chat UI - Indigo)
  static const Color primaryColor = Color(0xFF4F46E5); 
  static const Color primaryLight = Color(0xFF818CF8);
  static const Color primaryDark = Color(0xFF3730A3);
  static const Color secondaryColor = Color(0xFF10B981); // Emerald
  static const Color accentColor = Color(0xFF6366F1); // Accent Indigo

  // Light Theme Colors
  static const Color lightBg = Colors.white;
  static const Color lightSurface = Colors.white;
  static const Color lightTextPrimary = Color(0xFF111827);
  static const Color lightTextSecondary = Color(0xFF4B5563);
  static const Color lightBorder = Color(0xFFE5E7EB);
  static const Color lightInputFill = Color(0xFFE9ECEF);

  // Dark Theme Colors
  static const Color darkBg = Color(0xFF0F172A);
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color darkTextPrimary = Color(0xFFE5E7EB);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
  static const Color darkBorder = Color(0xFF334155);
  static const Color darkInputFill = Color(0xFF334155);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      onPrimary: Colors.white,
      secondary: secondaryColor,
      surface: lightSurface,
      onSurface: lightTextPrimary,
      error: Colors.redAccent,
      outline: lightBorder,
      surfaceContainerHighest: Color(0xFFE5E7EB),
    ),
    scaffoldBackgroundColor: lightBg,
    textTheme: GoogleFonts.interTextTheme().copyWith(
      displayLarge: GoogleFonts.inter(
        color: lightTextPrimary,
        fontWeight: FontWeight.bold,
        fontSize: 32,
      ),
      displayMedium: GoogleFonts.inter(
        color: lightTextPrimary,
        fontWeight: FontWeight.bold,
        fontSize: 24,
      ),
      bodyLarge: GoogleFonts.inter(color: lightTextPrimary, fontSize: 16),
      bodyMedium: GoogleFonts.inter(color: lightTextSecondary, fontSize: 14),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: lightTextPrimary,
        fontSize: 20,
        fontWeight: FontWeight.bold,
        fontFamily: 'Inter',
      ),
      iconTheme: IconThemeData(color: lightTextPrimary, size: 24),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: lightInputFill,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(40),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(40),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(40),
        borderSide: const BorderSide(color: primaryColor, width: 1.5),
      ),
      hintStyle: GoogleFonts.inter(color: lightTextSecondary.withOpacity(0.5), fontSize: 16),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: primaryColor,
      onPrimary: Colors.white,
      secondary: secondaryColor,
      surface: darkSurface,
      onSurface: darkTextPrimary,
      error: Colors.redAccent,
      outline: darkBorder,
      surfaceContainerHighest: Color(0xFF334155),
    ),
    scaffoldBackgroundColor: darkBg,
    textTheme: GoogleFonts.interTextTheme().copyWith(
      displayLarge: GoogleFonts.inter(
        color: darkTextPrimary,
        fontWeight: FontWeight.bold,
        fontSize: 32,
      ),
      displayMedium: GoogleFonts.inter(
        color: darkTextPrimary,
        fontWeight: FontWeight.bold,
        fontSize: 24,
      ),
      bodyLarge: GoogleFonts.inter(color: darkTextPrimary, fontSize: 16),
      bodyMedium: GoogleFonts.inter(color: darkTextSecondary, fontSize: 14),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: darkTextPrimary,
        fontSize: 20,
        fontWeight: FontWeight.bold,
        fontFamily: 'Inter',
      ),
      iconTheme: IconThemeData(color: darkTextPrimary, size: 24),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: darkInputFill,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(40),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(40),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(40),
        borderSide: const BorderSide(color: primaryColor, width: 1.5),
      ),
      hintStyle: GoogleFonts.inter(color: darkTextSecondary.withOpacity(0.5), fontSize: 16),
    ),
  );
}
