import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/theme.dart';
import '../../models/inventory.dart';
import '../../providers/inventory_provider.dart';
import '../../utils/item_ui.dart';

class InventoryScreen extends ConsumerStatefulWidget {
  const InventoryScreen({super.key});

  @override
  ConsumerState<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends ConsumerState<InventoryScreen> {
  ItemType? _filter;

  @override
  Widget build(BuildContext context) {
    final inventoryAsync = ref.watch(inventoryProvider);

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: Text(
          'Inventario',
          style: AppTheme.titleRpg.copyWith(
            fontSize: 18,
            color: AppColors.textPrimary,
          ),
        ),
      ),
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
        data: (items) => ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          children: [
            const _SectionTitle('EQUIPAMIENTO'),
            const SizedBox(height: 12),
            _EquipSlots(items: items),
            const SizedBox(height: 24),
            const _SectionTitle('MOCHILA'),
            const SizedBox(height: 12),
            if (items.isEmpty)
              const _EmptyBag()
            else ...[
              _FilterBar(
                selected: _filter,
                onSelected: (f) => setState(() => _filter = f),
              ),
              const SizedBox(height: 12),
              _ItemGrid(
                items: items
                    .where((inv) =>
                        _filter == null || inv.item.type == _filter)
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTheme.titleRpg.copyWith(
        fontSize: 13,
        letterSpacing: 1.5,
        color: AppColors.primary,
      ),
    );
  }
}

class _EquipSlotDef {
  final String label;
  final String sprite;
  final String keyword;
  const _EquipSlotDef(this.label, this.sprite, this.keyword);
}

const _equipDefs = [
  _EquipSlotDef('Espada', 'assets/sprites/iron_sword.png', 'espada'),
  _EquipSlotDef('Escudo', 'assets/sprites/guardian_shield.png', 'escudo'),
  _EquipSlotDef('Armadura', 'assets/sprites/leather_armor.png', 'armadura'),
  _EquipSlotDef('Casco', 'assets/sprites/warrior_helmet.png', 'casco'),
  _EquipSlotDef('Botas', 'assets/sprites/adventurer_boots.png', 'botas'),
  _EquipSlotDef('Capa', 'assets/sprites/blue_cape.png', 'capa'),
];

class _EquipSlots extends ConsumerWidget {
  final List<InventoryItem> items;
  const _EquipSlots({required this.items});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(inventoryNotifierProvider.notifier);

    return Row(
      children: List.generate(_equipDefs.length, (i) {
        final def = _equipDefs[i];
        final matches = items
            .where((inv) =>
                inv.item.name.toLowerCase().contains(def.keyword))
            .toList();
        InventoryItem? owned;
        if (matches.isNotEmpty) {
          owned =
              matches.firstWhere((m) => m.equipped, orElse: () => matches.first);
        }
        final equipped = owned?.equipped ?? false;

        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
                right: i < _equipDefs.length - 1 ? 8 : 0),
            child: _EquipSlot(
              def: def,
              owned: owned,
              equipped: equipped,
              onTap: () {
                if (owned == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Consíguelo en la Tienda'),
                    ),
                  );
                  return;
                }
                if (equipped) {
                  notifier.unequipItem(owned!.id);
                } else {
                  notifier.equipItem(owned!.id);
                }
              },
            ),
          ),
        );
      }),
    );
  }
}

class _EquipSlot extends StatelessWidget {
  final _EquipSlotDef def;
  final InventoryItem? owned;
  final bool equipped;
  final VoidCallback onTap;

  const _EquipSlot({
    required this.def,
    required this.owned,
    required this.equipped,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = equipped
        ? AppColors.primary
        : (owned != null ? AppColors.gold : AppColors.borderLight);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 52,
            width: 52,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColor, width: equipped ? 2 : 1),
              boxShadow: equipped
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.45),
                        blurRadius: 10,
                      ),
                    ]
                  : null,
            ),
            child: Opacity(
              opacity: owned == null ? 0.35 : 1.0,
              child: Image.asset(
                def.sprite,
                fit: BoxFit.contain,
                width: 40,
                height: 40,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          height: 13,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              def.label,
              style: AppTheme.body.copyWith(
                color: equipped ? AppColors.primary : AppColors.textMuted,
                fontSize: 10,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _FilterBar extends StatelessWidget {
  final ItemType? selected;
  final ValueChanged<ItemType?> onSelected;
  const _FilterBar({required this.selected, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _chip(context, null, 'Todos'),
          ...ItemType.values.map((t) =>
              _chip(context, t, ItemUi.typeLabel(t))),
        ],
      ),
    );
  }

  Widget _chip(
      BuildContext context, ItemType? value, String label) {
    final isSel = selected == value;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label, style: const TextStyle(fontSize: 12)),
        selected: isSel,
        selectedColor: AppColors.primary,
        backgroundColor: AppColors.surface,
        side: BorderSide(
          color: isSel ? AppColors.primary : AppColors.borderLight,
        ),
        labelStyle: TextStyle(
          color: isSel ? Colors.white : AppColors.textMuted,
        ),
        onSelected: (_) => onSelected(value),
      ),
    );
  }
}

class _ItemGrid extends StatelessWidget {
  final List<InventoryItem> items;
  const _ItemGrid({required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 32),
        child: Center(
          child: Text('No hay items en esta categoría',
              style: TextStyle(color: AppColors.textMuted)),
        ),
      );
    }
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.72,
      ),
      itemCount: items.length,
      itemBuilder: (_, i) => _ItemCell(inv: items[i]),
    );
  }
}

class _ItemCell extends ConsumerWidget {
  final InventoryItem inv;
  const _ItemCell({required this.inv});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final item = inv.item;
    final rarityColor = ItemUi.rarityColor(item.rarity);
    final notifier = ref.read(inventoryNotifierProvider.notifier);

    return GestureDetector(
      onTap: () => inv.equipped
          ? notifier.unequipItem(inv.id)
          : notifier.equipItem(inv.id),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: inv.equipped ? AppColors.primary : rarityColor,
            width: inv.equipped ? 2 : 1,
          ),
          boxShadow: inv.equipped
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.35),
                    blurRadius: 12,
                  ),
                ]
              : null,
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ItemIconThumb(item: item, size: 40),
                  const SizedBox(height: 6),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      item.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTheme.body.copyWith(
                        fontSize: 10,
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (inv.quantity > 1)
                    Text(
                      'x${inv.quantity}',
                      style: AppTheme.body.copyWith(
                        fontSize: 9,
                        color: AppColors.textMuted,
                      ),
                    ),
                ],
              ),
            ),
            if (inv.equipped)
              Positioned(
                top: 4,
                right: 4,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 5, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.5),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Text(
                    'EQUIPADO',
                    style: AppTheme.body.copyWith(
                      color: Colors.white,
                      fontSize: 7,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _EmptyBag extends StatelessWidget {
  const _EmptyBag();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: [
          Icon(Icons.backpack_outlined,
              size: 56, color: AppColors.textMuted),
          SizedBox(height: 12),
          Text('Tu mochila está vacía',
              style: TextStyle(color: AppColors.textMuted)),
          SizedBox(height: 4),
          Text('Compra items en la Tienda',
              style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
        ],
      ),
    );
  }
}
