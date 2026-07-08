import '../models/habit.dart';
import '../models/inventory.dart';
import '../models/mission.dart';
import '../models/user.dart';
import '../utils/level_system.dart';
import 'supabase_service.dart';

/// Servicio en memoria para el "modo demo": permite ver y usar toda la app
/// (crear/completar hábitos, ganar XP y oro) sin depender de Supabase.
class MockService extends SupabaseService {
  User _user = User(
    id: 'demo',
    email: 'demo@dailyhero.app',
    name: 'Aventurero',
    level: 5,
    totalXp: 1012,
    currentHp: 80,
    maxHp: 100,
    gold: 1200,
    streakDays: 7,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  final List<Habit> _habits = [
    Habit(
      id: 'h1',
      userId: 'demo',
      title: 'Ir al gimnasio',
      description: '1 hora de entrenamiento',
      frequency: HabitFrequency.daily,
      difficulty: HabitDifficulty.medium,
      category: HabitCategory.health,
      xpReward: 100,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    Habit(
      id: 'h2',
      userId: 'demo',
      title: 'Estudiar Flutter',
      description: '2 horas de código',
      frequency: HabitFrequency.daily,
      difficulty: HabitDifficulty.hard,
      category: HabitCategory.mind,
      xpReward: 100,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    Habit(
      id: 'h3',
      userId: 'demo',
      title: 'Meditar 10 min',
      frequency: HabitFrequency.daily,
      difficulty: HabitDifficulty.easy,
      category: HabitCategory.mind,
      xpReward: 50,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  ];

  // ---------- AUTH / USERS ----------
  @override
  Future<User?> getCurrentUser() async => _user;

  @override
  Future<User?> getUser(String userId) async => _user;

  @override
  Future<User?> login({required String email, required String password}) async =>
      _user;

  @override
  Future<User?> signUp({
    required String email,
    required String password,
    required String name,
  }) async =>
      _user;

  @override
  Future<void> logout() async {}

  @override
  Future<void> addXp(String userId, int xp) async {
    final newTotal = _user.totalXp + xp;
    _user = _user.copyWith(
      totalXp: newTotal,
      level: LevelSystem.fromTotalXp(newTotal).level,
    );
  }

  @override
  Future<void> addGold(String userId, int amount) async {
    _user = _user.copyWith(gold: _user.gold + amount);
  }

  @override
  Future<void> spendGold(String userId, int amount) async {
    if (_user.gold < amount) throw Exception('Oro insuficiente');
    _user = _user.copyWith(gold: _user.gold - amount);
  }

  // ---------- HABITS ----------
  @override
  Future<List<Habit>> getUserHabits(String userId) async =>
      List.unmodifiable(_habits);

  @override
  Future<List<Habit>> getDailyHabits(String userId) async => _habits
      .where((h) => h.frequency == HabitFrequency.daily && !h.completed)
      .toList();

  @override
  Future<Habit?> createHabit(Habit habit) async {
    _habits.add(habit);
    return habit;
  }

  @override
  Future<void> completeHabit(
      String habitId, String userId, int xpReward) async {
    final i = _habits.indexWhere((h) => h.id == habitId);
    if (i >= 0) {
      _habits[i] =
          _habits[i].copyWith(completed: true, completedAt: DateTime.now());
    }
    await addXp(userId, xpReward);
    await addGold(userId, (xpReward * 0.5).toInt());
  }

  @override
  Future<Habit?> updateHabit(Habit habit) async {
    final i = _habits.indexWhere((h) => h.id == habit.id);
    if (i >= 0) _habits[i] = habit;
    return habit;
  }

  @override
  Future<void> deleteHabit(String habitId) async {
    _habits.removeWhere((h) => h.id == habitId);
  }

  // ---------- TIENDA / INVENTARIO ----------
  final List<Item> _items = [
    Item(id: 'i1', name: 'Espada de Hierro', type: ItemType.weapon, rarity: ItemRarity.common, cost: 150, icon: '⚔️', description: '+5 de ataque'),
    Item(id: 'i2', name: 'Daga Veloz', type: ItemType.weapon, rarity: ItemRarity.uncommon, cost: 400, icon: '🗡️', description: 'Ataques rápidos'),
    Item(id: 'i3', name: 'Espada Flamígera', type: ItemType.weapon, rarity: ItemRarity.rare, cost: 1200, icon: '🔥', description: 'Daño de fuego'),
    Item(id: 'i4', name: 'Excalibur', type: ItemType.weapon, rarity: ItemRarity.legendary, cost: 3000, icon: '⚡', description: 'La espada legendaria'),
    Item(id: 'i5', name: 'Escudo de Madera', type: ItemType.armor, rarity: ItemRarity.common, cost: 120, icon: '🛡️', description: '+3 de defensa'),
    Item(id: 'i6', name: 'Armadura de Cuero', type: ItemType.armor, rarity: ItemRarity.uncommon, cost: 350, icon: '🥋', description: '+8 de defensa'),
    Item(id: 'i7', name: 'Poción de Vida', type: ItemType.potion, rarity: ItemRarity.common, cost: 80, icon: '🧪', description: 'Restaura 50 HP'),
    Item(id: 'i8', name: 'Elixir de XP', type: ItemType.potion, rarity: ItemRarity.rare, cost: 600, icon: '✨', description: 'XP doble por 1 día'),
    Item(id: 'i9', name: 'Sombrero Elegante', type: ItemType.cosmetic, rarity: ItemRarity.uncommon, cost: 300, icon: '🎩', description: 'Puro estilo'),
    Item(id: 'i10', name: 'Corona Real', type: ItemType.cosmetic, rarity: ItemRarity.legendary, cost: 2500, icon: '👑', description: 'Digna de un rey'),
  ];

  final List<InventoryItem> _inventory = [];

  @override
  Future<List<Item>> getAllItems() async => List.unmodifiable(_items);

  @override
  Future<List<InventoryItem>> getUserInventory(String userId) async =>
      List.unmodifiable(_inventory);

  @override
  Future<void> buyItem(String userId, String itemId) async {
    final item = _items.firstWhere((i) => i.id == itemId);
    if (_user.gold < item.cost) throw Exception('Oro insuficiente');
    await spendGold(userId, item.cost);

    final idx = _inventory.indexWhere((inv) => inv.itemId == itemId);
    if (idx >= 0) {
      _inventory[idx] =
          _inventory[idx].copyWith(quantity: _inventory[idx].quantity + 1);
    } else {
      _inventory.add(InventoryItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: userId,
        itemId: itemId,
        item: item,
        acquiredAt: DateTime.now(),
      ));
    }
  }

  @override
  Future<void> equipItem(String inventoryItemId) async {
    final i = _inventory.indexWhere((e) => e.id == inventoryItemId);
    if (i >= 0) _inventory[i] = _inventory[i].copyWith(equipped: true);
  }

  @override
  Future<void> unequipItem(String inventoryItemId) async {
    final i = _inventory.indexWhere((e) => e.id == inventoryItemId);
    if (i >= 0) _inventory[i] = _inventory[i].copyWith(equipped: false);
  }

  // ---------- NO USADOS EN DEMO ----------
  @override
  Future<List<Mission>> getUserMissions(String userId) async => [];
}
