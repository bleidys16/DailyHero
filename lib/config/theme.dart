import 'package:flutter/material.dart';

/// Paleta y tema visual de DailyHero (pixel-art RPG oscuro).
class AppColors {
  static const bg = Color(0xFF1E293B); // slate-800
  static const surface = Color(0xFF334155); // slate-700
  static const surfaceAlt = Color(0xFF475569); // slate-600
  static const primary = Color(0xFF7C3AED); // púrpura
  static const primaryDark = Color(0xFF6D28D9);
  static const accent = Color(0xFF22D3EE); // cyan

  static const gold = Color(0xFFFBBF24);
  static const xp = Color(0xFFFACC15);
  static const hp = Color(0xFF22C55E);
  static const hpLow = Color(0xFFEF4444);

  static const textPrimary = Color(0xFFF1F5F9); // slate-100
  static const textMuted = Color(0xFF94A3B8); // slate-400

  // Rarezas
  static const common = Color(0xFF94A3B8);
  static const uncommon = Color(0xFF4ADE80);
  static const rare = Color(0xFF38BDF8);
  static const legendary = Color(0xFFFBBF24);
}

class AppTheme {
  static ThemeData get dark {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.bg,
      cardColor: AppColors.surface,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.dark,
        primary: AppColors.primary,
        secondary: AppColors.accent,
        surface: AppColors.surface,
      ),
    );

    return base.copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.bg,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: 'PixelFont',
          fontSize: 20,
          color: AppColors.textPrimary,
          letterSpacing: 1,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.surfaceAlt),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        labelStyle: const TextStyle(color: AppColors.textMuted),
        prefixIconColor: AppColors.textMuted,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: AppColors.surfaceAlt,
        contentTextStyle: TextStyle(color: AppColors.textPrimary),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Fuente pixel para títulos/números.
  static const pixel = TextStyle(fontFamily: 'PixelFont');
}
