import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/inventory.dart';
import '../services/supabase_service.dart';
import 'user_provider.dart';

// Obtener inventario del usuario
final inventoryProvider = FutureProvider<List<InventoryItem>>((ref) async {
  final user = ref.watch(userNotifierProvider);
  if (user == null) return [];

  final supabase = ref.watch(supabaseServiceProvider);
  return await supabase.getUserInventory(user.id);
});

// Notificador para compras y equipamiento
final inventoryNotifierProvider =
    StateNotifierProvider<InventoryNotifier, void>((ref) {
  return InventoryNotifier(ref);
});

class InventoryNotifier extends StateNotifier<void> {
  final Ref ref;

  InventoryNotifier(this.ref) : super(null);

  /// Comprar item
  Future<bool> buyItem(String itemId) async {
    final user = ref.read(userNotifierProvider);
    if (user == null) throw Exception('Usuario no autenticado');

    try {
      final supabase = ref.read(supabaseServiceProvider);
      await supabase.buyItem(user.id, itemId);

      // Refrescar inventario y oro del usuario
      ref.refresh(inventoryProvider);
      await ref.read(userNotifierProvider.notifier).refresh();

      return true;
    } catch (e) {
      print('Error comprando item: $e');
      return false;
    }
  }

  /// Equipar item
  Future<void> equipItem(String inventoryItemId) async {
    try {
      final supabase = ref.read(supabaseServiceProvider);
      await supabase.equipItem(inventoryItemId);

      ref.refresh(inventoryProvider);
    } catch (e) {
      throw Exception('Error equipando item: $e');
    }
  }

  /// Desequipar item
  Future<void> unequipItem(String inventoryItemId) async {
    try {
      final supabase = ref.read(supabaseServiceProvider);
      await supabase.unequipItem(inventoryItemId);

      ref.refresh(inventoryProvider);
    } catch (e) {
      throw Exception('Error desequipando item: $e');
    }
  }
}
