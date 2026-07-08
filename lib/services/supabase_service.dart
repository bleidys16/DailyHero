import 'package:supabase_flutter/supabase_flutter.dart' hide User;
import '../models/user.dart';
import '../models/habit.dart';
import '../models/mission.dart';
import '../models/inventory.dart';

class SupabaseService {
  static final SupabaseClient _client = Supabase.instance.client;

  // ============ AUTH ============

  /// Sign up con email y password
  Future<User?> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user == null) throw Exception('Sign up failed');

      // Crear registro en tabla users
      final user = User(
        id: response.user!.id,
        email: email,
        name: name,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _client.from('users').insert(user.toJson());

      return user;
    } catch (e) {
      throw Exception('Error en sign up: $e');
    }
  }

  /// Login con email y password
  Future<User?> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) throw Exception('Login failed');

      final userData = await _client
          .from('users')
          .select()
          .eq('id', response.user!.id)
          .single();

      return User.fromJson(userData);
    } catch (e) {
      throw Exception('Error en login: $e');
    }
  }

  /// Logout
  Future<void> logout() async {
    try {
      await _client.auth.signOut();
    } catch (e) {
      throw Exception('Error en logout: $e');
    }
  }

  /// Obtener usuario actual
  Future<User?> getCurrentUser() async {
    try {
      final authUser = _client.auth.currentUser;
      if (authUser == null) return null;

      final userData =
          await _client.from('users').select().eq('id', authUser.id).single();

      return User.fromJson(userData);
    } catch (e) {
      return null;
    }
  }

  // ============ USERS ============

  /// Obtener usuario por ID
  Future<User?> getUser(String userId) async {
    try {
      final userData =
          await _client.from('users').select().eq('id', userId).single();

      return User.fromJson(userData);
    } catch (e) {
      throw Exception('Error obteniendo usuario: $e');
    }
  }

  /// Actualizar usuario
  Future<User?> updateUser(User user) async {
    try {
      await _client.from('users').update(user.toJson()).eq('id', user.id);
      return user;
    } catch (e) {
      throw Exception('Error actualizando usuario: $e');
    }
  }

  /// Aumentar XP del usuario
  Future<void> addXp(String userId, int xp) async {
    try {
      final user = await getUser(userId);
      if (user == null) throw Exception('Usuario no encontrado');

      int newTotalXp = user.totalXp + xp;
      int newLevel = user.level;
      int xpNeeded = 100; // XP para siguiente nivel

      // Sistema simple de nivelación
      while (newTotalXp >= xpNeeded) {
        newTotalXp -= xpNeeded;
        newLevel += 1;
        xpNeeded = (xpNeeded * 1.5).toInt();
      }

      await _client.from('users').update({
        'total_xp': user.totalXp + xp,
        'level': newLevel,
      }).eq('id', userId);
    } catch (e) {
      throw Exception('Error añadiendo XP: $e');
    }
  }

  /// Gastar oro
  Future<void> spendGold(String userId, int amount) async {
    try {
      final user = await getUser(userId);
      if (user == null) throw Exception('Usuario no encontrado');
      if (user.gold < amount) throw Exception('Oro insuficiente');

      await _client.from('users').update({
        'gold': user.gold - amount,
      }).eq('id', userId);
    } catch (e) {
      throw Exception('Error gastando oro: $e');
    }
  }

  /// Añadir oro
  Future<void> addGold(String userId, int amount) async {
    try {
      final user = await getUser(userId);
      if (user == null) throw Exception('Usuario no encontrado');

      await _client.from('users').update({
        'gold': user.gold + amount,
      }).eq('id', userId);
    } catch (e) {
      throw Exception('Error añadiendo oro: $e');
    }
  }

  // ============ HABITS ============

  /// Crear hábito
  Future<Habit?> createHabit(Habit habit) async {
    try {
      await _client.from('habits').insert(habit.toJson());
      return habit;
    } catch (e) {
      throw Exception('Error creando hábito: $e');
    }
  }

  /// Obtener hábitos del usuario
  Future<List<Habit>> getUserHabits(String userId) async {
    try {
      final data = await _client
          .from('habits')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return List<Habit>.from(data.map((h) => Habit.fromJson(h)));
    } catch (e) {
      throw Exception('Error obteniendo hábitos: $e');
    }
  }

  /// Obtener hábitos del día (diarios sin completar)
  Future<List<Habit>> getDailyHabits(String userId) async {
    try {
      final data = await _client
          .from('habits')
          .select()
          .eq('user_id', userId)
          .eq('frequency', 'daily')
          .eq('completed', false)
          .order('created_at', ascending: false);

      return List<Habit>.from(data.map((h) => Habit.fromJson(h)));
    } catch (e) {
      throw Exception('Error obteniendo daily quests: $e');
    }
  }

  /// Completar hábito
  Future<void> completeHabit(
      String habitId, String userId, int xpReward) async {
    try {
      await _client.from('habits').update({
        'completed': true,
        'completed_at': DateTime.now().toIso8601String(),
      }).eq('id', habitId);

      // Añadir XP y oro al usuario
      await addXp(userId, xpReward);
      int goldReward = (xpReward * 0.5).toInt();
      await addGold(userId, goldReward);
    } catch (e) {
      throw Exception('Error completando hábito: $e');
    }
  }

  /// Eliminar hábito
  Future<void> deleteHabit(String habitId) async {
    try {
      await _client.from('habits').delete().eq('id', habitId);
    } catch (e) {
      throw Exception('Error eliminando hábito: $e');
    }
  }

  /// Actualizar hábito
  Future<Habit?> updateHabit(Habit habit) async {
    try {
      await _client.from('habits').update(habit.toJson()).eq('id', habit.id);
      return habit;
    } catch (e) {
      throw Exception('Error actualizando hábito: $e');
    }
  }

  // ============ MISSIONS ============

  /// Crear misión
  Future<Mission?> createMission(Mission mission) async {
    try {
      await _client.from('missions').insert(mission.toJson());
      return mission;
    } catch (e) {
      throw Exception('Error creando misión: $e');
    }
  }

  /// Obtener misiones del usuario
  Future<List<Mission>> getUserMissions(String userId) async {
    try {
      final data = await _client
          .from('missions')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return List<Mission>.from(data.map((m) => Mission.fromJson(m)));
    } catch (e) {
      throw Exception('Error obteniendo misiones: $e');
    }
  }

  /// Completar misión
  Future<void> completeMission(String missionId) async {
    try {
      await _client.from('missions').update({
        'status': 'completed',
        'completed_at': DateTime.now().toIso8601String(),
      }).eq('id', missionId);
    } catch (e) {
      throw Exception('Error completando misión: $e');
    }
  }

  // ============ ITEMS / TIENDA ============

  /// Obtener todos los items de la tienda
  Future<List<Item>> getAllItems() async {
    try {
      final data = await _client.from('items').select().order('cost');
      return List<Item>.from(data.map((i) => Item.fromJson(i)));
    } catch (e) {
      throw Exception('Error obteniendo items: $e');
    }
  }

  // ============ INVENTORY ============

  /// Obtener inventario del usuario
  Future<List<InventoryItem>> getUserInventory(String userId) async {
    try {
      final data = await _client
          .from('inventory')
          .select('*, item:item_id(*)')
          .eq('user_id', userId);

      return List<InventoryItem>.from(
          data.map((i) => InventoryItem.fromJson(i)));
    } catch (e) {
      throw Exception('Error obteniendo inventario: $e');
    }
  }

  /// Comprar item
  Future<void> buyItem(String userId, String itemId) async {
    try {
      // Obtener item
      final itemData =
          await _client.from('items').select().eq('id', itemId).single();

      final item = Item.fromJson(itemData);

      // Verificar oro
      final user = await getUser(userId);
      if (user == null) throw Exception('Usuario no encontrado');
      if (user.gold < item.cost) throw Exception('Oro insuficiente');

      // Gastar oro
      await spendGold(userId, item.cost);

      // Verificar si ya existe en inventario
      final existing = await _client
          .from('inventory')
          .select()
          .eq('user_id', userId)
          .eq('item_id', itemId);

      if (existing.isNotEmpty) {
        // Aumentar cantidad
        await _client.from('inventory').update({
          'quantity': existing[0]['quantity'] + 1,
        }).eq('id', existing[0]['id']);
      } else {
        // Crear nuevo
        final inventoryItem = InventoryItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          userId: userId,
          itemId: itemId,
          item: item,
          acquiredAt: DateTime.now(),
        );

        await _client.from('inventory').insert(inventoryItem.toJson());
      }
    } catch (e) {
      throw Exception('Error comprando item: $e');
    }
  }

  /// Equipar item
  Future<void> equipItem(String inventoryItemId) async {
    try {
      await _client.from('inventory').update({
        'equipped': true,
      }).eq('id', inventoryItemId);
    } catch (e) {
      throw Exception('Error equipando item: $e');
    }
  }

  /// Desequipar item
  Future<void> unequipItem(String inventoryItemId) async {
    try {
      await _client.from('inventory').update({
        'equipped': false,
      }).eq('id', inventoryItemId);
    } catch (e) {
      throw Exception('Error desequipando item: $e');
    }
  }
}
