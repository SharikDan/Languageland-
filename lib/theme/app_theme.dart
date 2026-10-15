import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  // ───── СВЕТЛАЯ ─────
  static ThemeData get light {
    final baseText = GoogleFonts.nunitoTextTheme();
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.lightBg,
      canvasColor: AppColors.lightBg,
      cardColor: AppColors.lightSurface,
      dividerColor: AppColors.lightDivider,
      colorScheme: const ColorScheme.light(
        primary: AppColors.lightPrimary,
        primaryContainer: AppColors.lightPrimaryContainer,
        onPrimaryContainer: AppColors.lightTextPrimary,
        secondary: AppColors.lightSecondary,
        surface: AppColors.lightSurface,
        onSurface: AppColors.lightTextPrimary,
        onSurfaceVariant: AppColors.lightTextSecondary,
        surfaceContainerHighest: AppColors.lightSurfaceAlt,
        error: AppColors.wrong,
      ),
      textTheme: baseText.apply(
        bodyColor: AppColors.lightTextPrimary,
        displayColor: AppColors.lightTextPrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.lightSurface,
        foregroundColor: AppColors.lightTextPrimary,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: AppColors.lightSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      dialogTheme: const DialogThemeData(backgroundColor: AppColors.lightSurface),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.lightPrimary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
          textStyle: GoogleFonts.nunito(
              fontSize: 15, fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.lightPrimary,
          side: const BorderSide(color: AppColors.lightPrimary, width: 2),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
        ),
      ),
      iconTheme: const IconThemeData(
          color: AppColors.lightTextSecondary, size: 22),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.lightPrimaryContainer,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  // ───── ТЁМНАЯ ─────
  static ThemeData get dark {
    final baseText = GoogleFonts.nunitoTextTheme(ThemeData.dark().textTheme);
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkBg,
      canvasColor: AppColors.darkBg,
      cardColor: AppColors.darkSurface,
      dividerColor: AppColors.darkDivider,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.darkPrimary,
        primaryContainer: AppColors.darkPrimaryContainer,
        onPrimaryContainer: AppColors.darkTextPrimary,
        secondary: AppColors.darkSecondary,
        surface: AppColors.darkSurface,
        onSurface: AppColors.darkTextPrimary,
        onSurfaceVariant: AppColors.darkTextSecondary,
        surfaceContainerHighest: AppColors.darkSurfaceAlt,
        error: AppColors.wrong,
      ),
      textTheme: baseText.apply(
        bodyColor: AppColors.darkTextPrimary,
        displayColor: AppColors.darkTextPrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkSurface,
        foregroundColor: AppColors.darkTextPrimary,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: AppColors.darkSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      dialogTheme: const DialogThemeData(backgroundColor: AppColors.darkSurface),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.darkPrimary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
          textStyle: GoogleFonts.nunito(
              fontSize: 15, fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.darkPrimary,
          side: const BorderSide(color: AppColors.darkPrimary, width: 2),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
        ),
      ),
      iconTheme: const IconThemeData(
          color: AppColors.darkTextSecondary, size: 22),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkSurfaceAlt,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}