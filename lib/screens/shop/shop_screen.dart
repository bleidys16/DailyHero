import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/theme.dart';
import '../../models/inventory.dart';
import '../../providers/inventory_provider.dart';
import '../../providers/user_provider.dart';
import '../../utils/item_ui.dart';

import '../../widgets/purchase_overlay.dart';

class ShopScreen extends ConsumerStatefulWidget {
  const ShopScreen({super.key});

  @override
  ConsumerState<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends ConsumerState<ShopScreen> {
  ItemType? _filter;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userNotifierProvider);
    final itemsAsync = ref.watch(allItemsProvider);

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: Text(
          'Tienda',
          style: AppTheme.titleRpg.copyWith(
            fontSize: 18,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.gold.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.gold.withValues(alpha: 0.4)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.monetization_on,
                    color: AppColors.gold, size: 20),
                const SizedBox(width: 4),
                Text(
                  '${user?.gold ?? 0}',
                  style: AppTheme.titleRpg.copyWith(
                    color: AppColors.gold,
                    fontSize: 14,
                  ),
                ),
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
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text('No se pudo cargar la tienda:\n$e',
                      textAlign: TextAlign.center,
                      style:
                          const TextStyle(color: AppColors.textMuted)),
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
                return GridView.builder(
                  padding:
                      const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.8,
                  ),
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
        padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        children: [
          _chip(context, null, 'Todos', Icons.apps),
          ...ItemType.values.map((t) => _chip(
              context, t, ItemUi.typeLabel(t), ItemUi.typeIcon(t))),
        ],
      ),
    );
  }

  Widget _chip(
      BuildContext context, ItemType? value, String label, IconData icon) {
    final isSel = selected == value;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label, style: const TextStyle(fontSize: 12)),
        avatar:
            Icon(icon, size: 16, color: isSel ? Colors.white : AppColors.textMuted),
        selected: isSel,
        selectedColor: AppColors.primary,
        backgroundColor: AppColors.surface,
        side: BorderSide(
          color: isSel ? AppColors.primary : AppColors.borderLight,
        ),
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

    // Overlay animado de compra en vez de SnackBar plano
    PurchaseOverlay.show(
      context,
      itemName: widget.item.name,
      goldSpent: widget.item.cost,
      success: ok,
    );
  }

  String _rarityStars(ItemRarity rarity) {
    switch (rarity) {
      case ItemRarity.common:
        return '⭐';
      case ItemRarity.uncommon:
        return '⭐⭐';
      case ItemRarity.rare:
        return '⭐⭐⭐';
      case ItemRarity.legendary:
        return '⭐⭐⭐⭐';
    }
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final user = ref.watch(userNotifierProvider);
    final rarityColor = ItemUi.rarityColor(item.rarity);
    final canAfford = (user?.gold ?? 0) >= item.cost;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: rarityColor.withValues(alpha: 0.4),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: rarityColor.withValues(alpha: 0.08),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 68,
            width: 68,
            alignment: Alignment.center,
            child: ItemIconThumb(item: item, size: 52),
          ),
          const SizedBox(height: 8),
          Text(
            item.name,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            _rarityStars(item.rarity),
            style: const TextStyle(fontSize: 10),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.monetization_on,
                  color: AppColors.gold, size: 15),
              const SizedBox(width: 4),
              Text(
                '${item.cost}',
                style: AppTheme.titleRpg.copyWith(
                  color: AppColors.gold,
                  fontSize: 15,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            height: 32,
            child: ElevatedButton(
              onPressed: (_buying || !canAfford) ? null : _buy,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
                backgroundColor: canAfford ? AppColors.primary : AppColors.surfaceAlt,
                disabledBackgroundColor: AppColors.surfaceAlt.withValues(alpha: 0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: _buying
                  ? const SizedBox(
                      height: 14,
                      width: 14,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white))
                  : Text(
                      canAfford ? 'Comprar' : 'Insuficiente',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: canAfford ? Colors.white : AppColors.textMuted,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
