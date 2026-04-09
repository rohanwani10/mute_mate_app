import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Primary
  static const Color primary = Color(0xFF00685F);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color iconBg = Color.fromARGB(255, 165, 212, 205);
  static const Color primaryContainer = Color(0xFF008378);
  static const Color onPrimaryContainer = Color(0xFFF4FFFC);
  static const Color primaryFixed = Color(
    0xFF008378,
  ); // Added to fix compilation error

  // Secondary
  static const Color secondary = Color(0xFF9D4300);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryIcon = Color(0xFFFFDBCA);
  static const Color secondaryMic = Color(0xFF9D4300);
  static const Color secondaryContainer = Color(0xFFFD761A);
  static const Color onSecondaryContainer = Color(0xFF5C2400);

  // Tertiary
  static const Color tertiary = Color(0xFF006948);
  static const Color onTertiary = Color(0xFFFFFFFF);

  // Surface & Background
  static const Color background = Color(0xFFF9F9F8);
  static const Color onBackground = Color(0xFF1A1C1C);
  static const Color surface = Color(0xFFF9F9F8);
  static const Color onSurface = Color(0xFF1A1C1C);
  static const Color surfaceVariant = Color(0xFFE2E2E2);
  static const Color onSurfaceVariant = Color(0xFF3D4947);

  // Containers
  static const Color surfaceContainerLow = Color(0xFFF3F4F3);
  static const Color surfaceContainerlowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerHigh = Color(0xFFE8E8E7);

  // Error
  static const Color error = Color(0xFFBA1A1A);
  static const Color onError = Color(0xFFFFFFFF);

  // Custom
  static const Color outline = Color(0xFF6D7A77);
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        onPrimary: AppColors.onPrimary,
        secondary: AppColors.secondary,
        onSecondary: AppColors.onSecondary,
        surface: AppColors.surface,
        onSurface: AppColors.onSurface,
        error: AppColors.error,
        onError: AppColors.onError,
      ),
      textTheme: GoogleFonts.manropeTextTheme().copyWith(
        displayLarge: GoogleFonts.plusJakartaSans(
          fontWeight: FontWeight.w700,
          color: AppColors.onSurface,
        ),
        headlineMedium: GoogleFonts.plusJakartaSans(
          fontWeight: FontWeight.w700,
          color: AppColors.onSurface,
        ),
        titleLarge: GoogleFonts.plusJakartaSans(
          fontWeight: FontWeight.w700,
          color: AppColors.onSurface,
        ),
      ),
      scaffoldBackgroundColor: AppColors.background,
    );
  }
}
