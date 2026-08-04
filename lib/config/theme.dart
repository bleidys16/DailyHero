import 'package:flutter/material.dart';

class AppColors {
  static const bg = Color(0xFF081225);
  static const surface = Color(0xFF101C33);
  static const surfaceAlt = Color(0xFF1A2A4A);

  static const primary = Color(0xFF2CC9C3);
  static const primaryDark = Color(0xFF1A8A86);
  static const primaryLight = Color(0xFF5EEAE5);
  static const accent = Color(0xFF2CC9C3);

  static const gold = Color(0xFFF7C948);
  static const xp = Color(0xFF2196F3);
  static const hp = Color(0xFFE53935);
  static const hpLow = Color(0xFFEF4444);

  static const textPrimary = Color(0xFFF5F7FA);
  static const textMuted = Color(0xFFA6B0C3);
  static const textOnPrimary = Color(0xFFFFFFFF);

  static const common = Color(0xFFA6B0C3);
  static const uncommon = Color(0xFF22C55E);
  static const rare = Color(0xFF2196F3);
  static const legendary = Color(0xFFF7C948);

  static const borderGold = Color(0xFFF7C948);
  static const borderCard = Color(0xFF2CC9C3);
  static const borderLight = Color(0xFF1A2A4A);
}

class AppTheme {
  static ThemeData get dark {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.bg,
      cardColor: AppColors.surface,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.accent,
        surface: AppColors.surface,
        onPrimary: Colors.white,
        onSurface: AppColors.textPrimary,
      ),
    );

    return base.copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
        titleTextStyle: TextStyle(
          fontFamily: 'Jersey10',
          fontSize: 22,
          letterSpacing: 1,
          color: AppColors.primary,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceAlt,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.hpLow),
        ),
        labelStyle: const TextStyle(
          fontFamily: 'SpaceGrotesk',
          color: AppColors.textMuted,
        ),
        hintStyle: const TextStyle(
          fontFamily: 'SpaceGrotesk',
          color: AppColors.textMuted,
        ),
        prefixIconColor: AppColors.textMuted,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(0, 52),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          textStyle: const TextStyle(
            fontFamily: 'SpaceGrotesk',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: BorderSide.none,
          minimumSize: const Size(0, 52),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: const TextStyle(
            fontFamily: 'SpaceGrotesk',
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.surface,
        contentTextStyle: const TextStyle(
          fontFamily: 'SpaceGrotesk',
          color: AppColors.textPrimary,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: AppColors.borderCard, width: 0.5),
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(
            color: AppColors.borderCard.withOpacity(0.3),
            width: 0.5,
          ),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.surface,
        indicatorColor: AppColors.primary.withOpacity(0.15),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              fontFamily: 'SpaceGrotesk',
              color: AppColors.primary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            );
          }
          return const TextStyle(
            fontFamily: 'SpaceGrotesk',
            color: AppColors.textMuted,
            fontSize: 12,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.primary, size: 24);
          }
          return const IconThemeData(color: AppColors.textMuted, size: 24);
        }),
      ),
    );
  }

  /// Fuente para títulos cortos (títulos de pantalla y secciones).
  static const TextStyle titleRpg = TextStyle(fontFamily: 'Jersey10');

  /// Fuente para todo el contenido.
  static const TextStyle body = TextStyle(fontFamily: 'SpaceGrotesk');
}
