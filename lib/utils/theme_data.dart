import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppConstants.darkBgColor,
      cardColor: AppConstants.darkCardColor,
      primaryColor: AppConstants.darkAccentColor,
      colorScheme: const ColorScheme.dark(
        primary: AppConstants.darkAccentColor,
        secondary: AppConstants.darkAccentColor2,
        surface: AppConstants.darkCardColor,
        background: AppConstants.darkBgColor,
        onPrimary: Colors.black,
        onSecondary: Colors.white,
        onSurface: AppConstants.darkTextColor,
        onBackground: AppConstants.darkTextColor,
      ),
      textTheme: GoogleFonts.poppinsTextTheme(
        ThemeData.dark().textTheme.copyWith(
          displayLarge: GoogleFonts.poppins(
            fontSize: 56,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            letterSpacing: -1.0,
          ),
          displayMedium: GoogleFonts.poppins(
            fontSize: 40,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            letterSpacing: -0.5,
          ),
          displaySmall: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
          titleLarge: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          titleMedium: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
          bodyLarge: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: AppConstants.darkTextColor,
            height: 1.6,
          ),
          bodyMedium: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppConstants.darkTextMuted,
            height: 1.5,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: AppConstants.darkCardColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppConstants.glassBorderDark, width: 1.0),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppConstants.darkBgColor,
        hintStyle: const TextStyle(color: AppConstants.darkTextMuted, fontSize: 14),
        labelStyle: const TextStyle(color: AppConstants.darkTextColor, fontSize: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppConstants.glassBorderDark, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppConstants.glassBorderDark, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppConstants.darkAccentColor, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
      ),
      dividerColor: AppConstants.glassBorderDark,
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppConstants.lightBgColor,
      cardColor: AppConstants.lightCardColor,
      primaryColor: AppConstants.lightAccentColor,
      colorScheme: const ColorScheme.light(
        primary: AppConstants.lightAccentColor,
        secondary: AppConstants.lightAccentColor2,
        surface: AppConstants.lightCardColor,
        background: AppConstants.lightBgColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppConstants.lightTextColor,
        onBackground: AppConstants.lightTextColor,
      ),
      textTheme: GoogleFonts.poppinsTextTheme(
        ThemeData.light().textTheme.copyWith(
          displayLarge: GoogleFonts.poppins(
            fontSize: 56,
            fontWeight: FontWeight.w800,
            color: AppConstants.lightTextColor,
            letterSpacing: -1.0,
          ),
          displayMedium: GoogleFonts.poppins(
            fontSize: 40,
            fontWeight: FontWeight.w800,
            color: AppConstants.lightTextColor,
            letterSpacing: -0.5,
          ),
          displaySmall: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: AppConstants.lightTextColor,
          ),
          titleLarge: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: AppConstants.lightTextColor,
          ),
          titleMedium: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: AppConstants.lightTextColor,
          ),
          bodyLarge: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: AppConstants.lightTextColor,
            height: 1.6,
          ),
          bodyMedium: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppConstants.lightTextMuted,
            height: 1.5,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: AppConstants.lightCardColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppConstants.glassBorderLight, width: 1.0),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF1F5F9),
        hintStyle: const TextStyle(color: AppConstants.lightTextMuted, fontSize: 14),
        labelStyle: const TextStyle(color: AppConstants.lightTextColor, fontSize: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppConstants.glassBorderLight, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppConstants.glassBorderLight, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppConstants.lightAccentColor, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
      ),
      dividerColor: AppConstants.glassBorderLight,
    );
  }
}
