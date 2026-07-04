import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/habit.dart';
import '../services/supabase_service.dart';
import 'user_provider.dart';

// Obtener todos los hábitos del usuario
final habitListProvider = FutureProvider<List<Habit>>((ref) async {
  final user = ref.watch(userNotifierProvider);
  if (user == null) return [];

  final supabase = ref.watch(supabaseServiceProvider);
  return await supabase.getUserHabits(user.id);
});

// Obtener solo hábitos del día
final dailyHabitsProvider = FutureProvider<List<Habit>>((ref) async {
  final user = ref.watch(userNotifierProvider);
  if (user == null) return [];

  final supabase = ref.watch(supabaseServiceProvider);
  return await supabase.getDailyHabits(user.id);
});

// Notificador para crear/actualizar/eliminar hábitos
final habitNotifierProvider = StateNotifierProvider<HabitNotifier, void>((ref) {
  return HabitNotifier(ref);
});

class HabitNotifier extends StateNotifier<void> {
  final Ref ref;

  HabitNotifier(this.ref) : super(null);

  /// Crear nuevo hábito
  Future<void> createHabit({
    required String title,
    required String? description,
    required HabitFrequency frequency,
    required HabitDifficulty difficulty,
    required HabitCategory category,
    int xpReward = 50,
  }) async {
    final user = ref.read(userNotifierProvider);
    if (user == null) throw Exception('Usuario no autenticado');

    try {
      final habit = Habit(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: user.id,
        title: title,
        description: description,
        frequency: frequency,
        difficulty: difficulty,
        category: category,
        xpReward: xpReward,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final supabase = ref.read(supabaseServiceProvider);
      await supabase.createHabit(habit);

      // Refrescar lista
      ref.refresh(habitListProvider);
      ref.refresh(dailyHabitsProvider);
    } catch (e) {
      throw Exception('Error creando hábito: $e');
    }
  }

  /// Completar hábito
  Future<void> completeHabit(Habit habit) async {
    final user = ref.read(userNotifierProvider);
    if (user == null) throw Exception('Usuario no autenticado');

    try {
      final supabase = ref.read(supabaseServiceProvider);
      await supabase.completeHabit(habit.id, user.id, habit.xpValue);

      // Añadir XP al usuario
      await ref.read(userNotifierProvider.notifier).addXp(habit.xpValue);

      // Refrescar listas
      ref.refresh(habitListProvider);
      ref.refresh(dailyHabitsProvider);
    } catch (e) {
      throw Exception('Error completando hábito: $e');
    }
  }

  /// Actualizar hábito
  Future<void> updateHabit(Habit habit) async {
    try {
      final supabase = ref.read(supabaseServiceProvider);
      await supabase.updateHabit(habit);

      ref.refresh(habitListProvider);
      ref.refresh(dailyHabitsProvider);
    } catch (e) {
      throw Exception('Error actualizando hábito: $e');
    }
  }

  /// Eliminar hábito
  Future<void> deleteHabit(String habitId) async {
    try {
      final supabase = ref.read(supabaseServiceProvider);
      await supabase.deleteHabit(habitId);

      ref.refresh(habitListProvider);
      ref.refresh(dailyHabitsProvider);
    } catch (e) {
      throw Exception('Error eliminando hábito: $e');
    }
  }
}
