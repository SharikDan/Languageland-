import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ─── СВЕТЛАЯ ТЕМА ───
  static const lightPrimary = Color(0xFFE91E63);
  static const lightPrimaryContainer = Color(0xFFFCE4EC);
  static const lightSecondary = Color(0xFFFFB74D);
  static const lightBg = Color(0xFFFFF5F8);
  static const lightSurface = Color(0xFFFFFFFF);
  static const lightSurfaceAlt = Color(0xFFF8F8FA);
  static const lightTextPrimary = Color(0xFF2C2C2C);
  static const lightTextSecondary = Color(0xFF7A7A8C);
  static const lightDivider = Color(0xFFE5E5EC);

  // ─── ТЁМНАЯ ТЕМА ───
  static const darkPrimary = Color(0xFFFF6B9D);
  static const darkPrimaryContainer = Color(0xFF3D1F2E);
  static const darkSecondary = Color(0xFFFFB74D);
  static const darkBg = Color(0xFF0F0F17);
  static const darkSurface = Color(0xFF1C1C28);
  static const darkSurfaceAlt = Color(0xFF23232F);
  static const darkTextPrimary = Color(0xFFEDEDF2);
  static const darkTextSecondary = Color(0xFFA0A0B0);
  static const darkDivider = Color(0xFF2A2A38);

  // ─── СЕМАНТИЧЕСКИЕ ───
  static const correct = Color(0xFF4CAF50);
  static const wrong = Color(0xFFE53935);
  static const gold = Color(0xFFFFB300);
}

// ─── Хелперы для доступа к цветам по теме ───
Color bgOf(BuildContext c) {
  final dark = Theme.of(c).brightness == Brightness.dark;
  return dark ? AppColors.darkBg : AppColors.lightBg;
}

Color surfaceOf(BuildContext c) {
  final dark = Theme.of(c).brightness == Brightness.dark;
  return dark ? AppColors.darkSurface : AppColors.lightSurface;
}

Color surfaceAltOf(BuildContext c) {
  final dark = Theme.of(c).brightness == Brightness.dark;
  return dark ? AppColors.darkSurfaceAlt : AppColors.lightSurfaceAlt;
}

Color textOf(BuildContext c) {
  return Theme.of(c).colorScheme.onSurface;
}

Color textSubOf(BuildContext c) {
  final dark = Theme.of(c).brightness == Brightness.dark;
  return dark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
}