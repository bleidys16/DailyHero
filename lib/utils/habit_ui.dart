import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../models/habit.dart';

/// Metadatos de presentación (etiqueta, icono, color) para los enums de Habit.
class HabitUi {
  // ---------- Categoría ----------
  static String categoryLabel(HabitCategory c) {
    switch (c) {
      case HabitCategory.health:
        return 'Salud';
      case HabitCategory.mind:
        return 'Mente';
      case HabitCategory.work:
        return 'Trabajo';
      case HabitCategory.social:
        return 'Social';
    }
  }

  static IconData categoryIcon(HabitCategory c) {
    switch (c) {
      case HabitCategory.health:
        return Icons.favorite;
      case HabitCategory.mind:
        return Icons.psychology;
      case HabitCategory.work:
        return Icons.work;
      case HabitCategory.social:
        return Icons.groups;
    }
  }

  static Color categoryColor(HabitCategory c) {
    switch (c) {
      case HabitCategory.health:
        return const Color(0xFF22C55E);
      case HabitCategory.mind:
        return const Color(0xFFA78BFA);
      case HabitCategory.work:
        return AppColors.accent;
      case HabitCategory.social:
        return const Color(0xFFF59E0B);
    }
  }

  // ---------- Dificultad ----------
  static String difficultyLabel(HabitDifficulty d) {
    switch (d) {
      case HabitDifficulty.easy:
        return 'Fácil';
      case HabitDifficulty.medium:
        return 'Medio';
      case HabitDifficulty.hard:
        return 'Difícil';
    }
  }

  static Color difficultyColor(HabitDifficulty d) {
    switch (d) {
      case HabitDifficulty.easy:
        return const Color(0xFF22C55E);
      case HabitDifficulty.medium:
        return const Color(0xFFF59E0B);
      case HabitDifficulty.hard:
        return const Color(0xFFEF4444);
    }
  }

  // ---------- Frecuencia ----------
  static String frequencyLabel(HabitFrequency f) {
    switch (f) {
      case HabitFrequency.daily:
        return 'Diario';
      case HabitFrequency.weekly:
        return 'Semanal';
      case HabitFrequency.oneTime:
        return 'Único';
    }
  }
}
