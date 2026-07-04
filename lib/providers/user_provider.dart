import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';
import '../services/supabase_service.dart';

final supabaseServiceProvider = Provider((ref) => SupabaseService());

// Usuario actual autenticado
final currentUserProvider = FutureProvider<User?>((ref) async {
  final supabase = ref.watch(supabaseServiceProvider);
  return await supabase.getCurrentUser();
});

// Proveedor de notificador para actualizar usuario
final userNotifierProvider = StateNotifierProvider<UserNotifier, User?>((ref) {
  return UserNotifier(ref);
});

class UserNotifier extends StateNotifier<User?> {
  final Ref ref;

  UserNotifier(this.ref) : super(null) {
    _initialize();
  }

  void _initialize() async {
    final supabase = ref.read(supabaseServiceProvider);
    final user = await supabase.getCurrentUser();
    state = user;
  }

  /// Sign up
  Future<bool> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final supabase = ref.read(supabaseServiceProvider);
      final user = await supabase.signUp(
        email: email,
        password: password,
        name: name,
      );
      state = user;
      return true;
    } catch (e) {
      print('Error en sign up: $e');
      return false;
    }
  }

  /// Login
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      final supabase = ref.read(supabaseServiceProvider);
      final user = await supabase.login(email: email, password: password);
      state = user;
      return true;
    } catch (e) {
      print('Error en login: $e');
      return false;
    }
  }

  /// Logout
  Future<void> logout() async {
    try {
      final supabase = ref.read(supabaseServiceProvider);
      await supabase.logout();
      state = null;
    } catch (e) {
      print('Error en logout: $e');
    }
  }

  /// Añadir XP
  Future<void> addXp(int xp) async {
    if (state == null) return;
    try {
      final supabase = ref.read(supabaseServiceProvider);
      await supabase.addXp(state!.id, xp);
      // Refrescar usuario
      final updatedUser = await supabase.getUser(state!.id);
      state = updatedUser;
    } catch (e) {
      print('Error añadiendo XP: $e');
    }
  }

  /// Gastar oro
  Future<bool> spendGold(int amount) async {
    if (state == null) return false;
    try {
      final supabase = ref.read(supabaseServiceProvider);
      await supabase.spendGold(state!.id, amount);
      final updatedUser = await supabase.getUser(state!.id);
      state = updatedUser;
      return true;
    } catch (e) {
      print('Error gastando oro: $e');
      return false;
    }
  }

  /// Añadir oro
  Future<void> addGold(int amount) async {
    if (state == null) return;
    try {
      final supabase = ref.read(supabaseServiceProvider);
      await supabase.addGold(state!.id, amount);
      final updatedUser = await supabase.getUser(state!.id);
      state = updatedUser;
    } catch (e) {
      print('Error añadiendo oro: $e');
    }
  }

  /// Refrescar datos del usuario
  Future<void> refresh() async {
    if (state == null) return;
    try {
      final supabase = ref.read(supabaseServiceProvider);
      final updatedUser = await supabase.getUser(state!.id);
      state = updatedUser;
    } catch (e) {
      print('Error refrescando usuario: $e');
    }
  }
}
