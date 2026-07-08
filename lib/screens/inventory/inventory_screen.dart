import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/theme.dart';
import '../../models/inventory.dart';
import '../../providers/inventory_provider.dart';
import '../../utils/item_ui.dart';

class InventoryScreen extends ConsumerWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inventoryAsync = ref.watch(inventoryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Inventario')),
      body: inventoryAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text('No se pudo cargar el inventario:\n$e',
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textMuted)),
          ),
        ),
        data: (items) {
          if (items.isEmpty) {
            return const _EmptyInventory();
          }
          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            itemCount: items.length,
            itemBuilder: (_, i) => _InventoryTile(inv: items[i]),
          );
        },
      ),
    );
  }
}

class _EmptyInventory extends StatelessWidget {
  const _EmptyInventory();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.backpack_outlined, size: 56, color: AppColors.textMuted),
          SizedBox(height: 12),
          Text('Tu inventario está vacío',
              style: TextStyle(color: AppColors.textMuted)),
          SizedBox(height: 4),
          Text('Compra items en la Tienda',
              style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
        ],
      ),
    );
  }
}

class _InventoryTile extends ConsumerWidget {
  final InventoryItem inv;
  const _InventoryTile({required this.inv});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final item = inv.item;
    final rarityColor = ItemUi.rarityColor(item.rarity);
    final notifier = ref.read(inventoryNotifierProvider.notifier);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: inv.equipped ? AppColors.accent : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              height: 52,
              width: 52,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.bg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: rarityColor, width: 2),
              ),
              child: Text(item.icon, style: const TextStyle(fontSize: 26)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(item.name,
                            style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                                fontSize: 15)),
                      ),
                      if (inv.quantity > 1)
                        Padding(
                          padding: const EdgeInsets.only(left: 6),
                          child: Text('x${inv.quantity}',
                              style: const TextStyle(
                                  color: AppColors.textMuted, fontSize: 13)),
                        ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(ItemUi.typeIcon(item.type),
                          size: 13, color: AppColors.textMuted),
                      const SizedBox(width: 4),
                      Text(ItemUi.rarityLabel(item.rarity),
                          style: TextStyle(color: rarityColor, fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
            OutlinedButton(
              onPressed: () => inv.equipped
                  ? notifier.unequipItem(inv.id)
                  : notifier.equipItem(inv.id),
              style: OutlinedButton.styleFrom(
                foregroundColor:
                    inv.equipped ? AppColors.accent : AppColors.textMuted,
                side: BorderSide(
                    color: inv.equipped
                        ? AppColors.accent
                        : AppColors.surfaceAlt),
                padding: const EdgeInsets.symmetric(horizontal: 12),
              ),
              child: Text(inv.equipped ? 'Equipado' : 'Equipar',
                  style: const TextStyle(fontSize: 13)),
            ),
          ],
        ),
      ),
    );
  }
}
