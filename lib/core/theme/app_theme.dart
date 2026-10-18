import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const rose = Color(0xFFBE3455);
  static const plum = Color(0xFF4A1D3D);
  static const cream = Color(0xFFFFF8F6);
  static const blush = Color(0xFFFFF1F5);
  static const blushDeep = Color(0xFFFBDDE6);
  static const pinkLine = Color(0xFFF5CDD9);
  static const menstrual = Color(0xFFB3261E);
  static const follicular = Color(0xFF2E7D5B);
  static const ovulation = Color(0xFFB45309);
  static const luteal = Color(0xFF5B4B9A);
}

class AppTheme {
  static ThemeData light() {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.rose,
        surface: AppColors.blush,
      ),
      scaffoldBackgroundColor: AppColors.blush,
    );
    return base.copyWith(
      textTheme: GoogleFonts.nunitoTextTheme(base.textTheme)
          .apply(bodyColor: AppColors.plum, displayColor: AppColors.plum)
          .copyWith(
            headlineSmall: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: AppColors.plum),
            titleMedium: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.plum),
          ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.pinkLine),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.rose,
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14)),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        indicatorColor: AppColors.blushDeep,
      ),
    );
  }
}
