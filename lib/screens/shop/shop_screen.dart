import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/theme.dart';
import '../../models/inventory.dart';
import '../../providers/inventory_provider.dart';
import '../../providers/user_provider.dart';
import '../../utils/item_ui.dart';

class ShopScreen extends ConsumerStatefulWidget {
  const ShopScreen({super.key});

  @override
  ConsumerState<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends ConsumerState<ShopScreen> {
  ItemType? _filter; // null = todos

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userNotifierProvider);
    final itemsAsync = ref.watch(allItemsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tienda'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: [
                const Icon(Icons.monetization_on,
                    color: AppColors.gold, size: 20),
                const SizedBox(width: 4),
                Text('${user?.gold ?? 0}',
                    style: AppTheme.pixel
                        .copyWith(color: AppColors.gold, fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _FilterBar(
            selected: _filter,
            onSelected: (f) => setState(() => _filter = f),
          ),
          Expanded(
            child: itemsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text('No se pudo cargar la tienda:\n$e',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppColors.textMuted)),
                ),
              ),
              data: (items) {
                final filtered = _filter == null
                    ? items
                    : items.where((i) => i.type == _filter).toList();
                if (filtered.isEmpty) {
                  return const Center(
                    child: Text('No hay items en esta categoría',
                        style: TextStyle(color: AppColors.textMuted)),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  itemCount: filtered.length,
                  itemBuilder: (_, i) => _ItemCard(item: filtered[i]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterBar extends StatelessWidget {
  final ItemType? selected;
  final ValueChanged<ItemType?> onSelected;
  const _FilterBar({required this.selected, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        children: [
          _chip(context, null, 'Todos', Icons.apps),
          ...ItemType.values.map((t) =>
              _chip(context, t, ItemUi.typeLabel(t), ItemUi.typeIcon(t))),
        ],
      ),
    );
  }

  Widget _chip(BuildContext context, ItemType? value, String label, IconData icon) {
    final isSel = selected == value;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        avatar: Icon(icon,
            size: 16, color: isSel ? Colors.white : AppColors.textMuted),
        selected: isSel,
        selectedColor: AppColors.primary,
        backgroundColor: AppColors.surface,
        onSelected: (_) => onSelected(value),
      ),
    );
  }
}

class _ItemCard extends ConsumerStatefulWidget {
  final Item item;
  const _ItemCard({required this.item});

  @override
  ConsumerState<_ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends ConsumerState<_ItemCard> {
  bool _buying = false;

  Future<void> _buy() async {
    setState(() => _buying = true);
    final ok = await ref
        .read(inventoryNotifierProvider.notifier)
        .buyItem(widget.item.id);
    if (!mounted) return;
    setState(() => _buying = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(ok
            ? '¡Compraste ${widget.item.name}!'
            : 'Oro insuficiente para ${widget.item.name}'),
        backgroundColor: ok ? AppColors.primaryDark : AppColors.hpLow,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final user = ref.watch(userNotifierProvider);
    final rarityColor = ItemUi.rarityColor(item.rarity);
    final canAfford = (user?.gold ?? 0) >= item.cost;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
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
                  Text(item.name,
                      style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 15)),
                  const SizedBox(height: 2),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                    decoration: BoxDecoration(
                      color: rarityColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(ItemUi.rarityLabel(item.rarity),
                        style: TextStyle(
                            color: rarityColor,
                            fontSize: 11,
                            fontWeight: FontWeight.w600)),
                  ),
                  if (item.description != null) ...[
                    const SizedBox(height: 4),
                    Text(item.description!,
                        style: const TextStyle(
                            color: AppColors.textMuted, fontSize: 12)),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.monetization_on,
                        color: AppColors.gold, size: 16),
                    const SizedBox(width: 3),
                    Text('${item.cost}',
                        style: AppTheme.pixel.copyWith(
                            color: AppColors.gold, fontSize: 13)),
                  ],
                ),
                const SizedBox(height: 6),
                SizedBox(
                  height: 32,
                  child: ElevatedButton(
                    onPressed: (_buying || !canAfford) ? null : _buy,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      backgroundColor: AppColors.primary,
                      disabledBackgroundColor: AppColors.surfaceAlt,
                    ),
                    child: _buying
                        ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white))
                        : const Text('Comprar',
                            style: TextStyle(fontSize: 13)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
