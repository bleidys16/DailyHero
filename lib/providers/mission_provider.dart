import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/mission.dart';
import '../services/supabase_service.dart';
import 'user_provider.dart';

// Obtener misiones del usuario
final missionListProvider = FutureProvider<List<Mission>>((ref) async {
  final user = ref.watch(userNotifierProvider);
  if (user == null) return [];

  final supabase = ref.watch(supabaseServiceProvider);
  return await supabase.getUserMissions(user.id);
});

// Notificador para crear/completar misiones
final missionNotifierProvider =
    StateNotifierProvider<MissionNotifier, void>((ref) {
  return MissionNotifier(ref);
});

class MissionNotifier extends StateNotifier<void> {
  final Ref ref;

  MissionNotifier(this.ref) : super(null);

  /// Crear misión
  Future<void> createMission({
    required String habitId,
  }) async {
    final user = ref.read(userNotifierProvider);
    if (user == null) throw Exception('Usuario no autenticado');

    try {
      final mission = Mission(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        habitId: habitId,
        userId: user.id,
        status: MissionStatus.pending,
        createdAt: DateTime.now(),
      );

      final supabase = ref.read(supabaseServiceProvider);
      await supabase.createMission(mission);

      ref.refresh(missionListProvider);
    } catch (e) {
      throw Exception('Error creando misión: $e');
    }
  }

  /// Completar misión
  Future<void> completeMission(String missionId) async {
    try {
      final supabase = ref.read(supabaseServiceProvider);
      await supabase.completeMission(missionId);

      ref.refresh(missionListProvider);
    } catch (e) {
      throw Exception('Error completando misión: $e');
    }
  }
}
