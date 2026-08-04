import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/theme.dart';
import '../../providers/user_provider.dart';
import '../../providers/inventory_provider.dart';
import '../../utils/level_system.dart';
import '../../utils/item_ui.dart';

import '../../game/widgets/flame_avatar_view.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userNotifierProvider);
    final inventoryAsync = ref.watch(inventoryProvider);

    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final progress = LevelSystem.fromTotalXp(user.totalXp);

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: Text(
          'FICHA DEL HÉROE',
          style: AppTheme.titleRpg.copyWith(
            fontSize: 18,
            color: AppColors.textPrimary,
            letterSpacing: 1,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          // Hero Sheet Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.borderGold.withValues(alpha: 0.4),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.gold.withValues(alpha: 0.08),
                  blurRadius: 16,
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.gold, width: 2.5),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.gold.withValues(alpha: 0.3),
                        blurRadius: 12,
                      ),
                    ],
                  ),
                  child: const FlameAvatarView(size: 84, playerSize: 84),
                ),
                const SizedBox(height: 12),
                Text(
                  user.name?.isNotEmpty == true ? user.name! : 'Héroe',
                  style: AppTheme.titleRpg.copyWith(
                    fontSize: 24,
                    color: AppColors.textPrimary,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user.email,
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Key Metrics Grid
          Row(
            children: [
              _StatItem(
                icon: Icons.star,
                color: AppColors.gold,
                value: '${progress.level}',
                label: 'Nivel',
              ),
              const SizedBox(width: 10),
              _StatItem(
                icon: Icons.bolt,
                color: AppColors.xp,
                value: '${user.totalXp}',
                label: 'XP Total',
              ),
              const SizedBox(width: 10),
              _StatItem(
                icon: Icons.local_fire_department,
                color: const Color(0xFFF97316),
                value: '${user.streakDays}',
                label: 'Racha (Días)',
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Equipped Equipment Grid
          _SectionTitle(title: 'EQUIPAMIENTO ACTIVO'),
          const SizedBox(height: 8),
          inventoryAsync.when(
            loading: () => const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
            error: (_, __) => const SizedBox(),
            data: (items) {
              final equipped = items.where((i) => i.equipped).toList();
              if (equipped.isEmpty) {
                return Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.borderLight,
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'Sin equipamiento activo en este momento',
                      style: TextStyle(color: AppColors.textMuted, fontSize: 13),
                    ),
                  ),
                );
              }
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.3),
                  ),
                ),
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: equipped.map((inv) {
                    final rarityColor = ItemUi.rarityColor(inv.item.rarity);
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.bg,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: rarityColor, width: 1.5),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ItemIconThumb(item: inv.item, size: 24),
                          const SizedBox(width: 8),
                          Text(
                            inv.item.name,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              );
            },
          ),
          const SizedBox(height: 20),

          // General Stats List
          _SectionTitle(title: 'ESTADÍSTICAS GENERALES'),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.borderLight),
            ),
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                _StatRow(
                  icon: Icons.monetization_on,
                  iconColor: AppColors.gold,
                  label: 'Oro disponible',
                  value: '${user.gold}',
                ),
                const Divider(color: AppColors.borderLight, height: 16),
                _StatRow(
                  icon: Icons.bolt,
                  iconColor: AppColors.xp,
                  label: 'XP Acumulada',
                  value: '${user.totalXp}',
                ),
                const Divider(color: AppColors.borderLight, height: 16),
                _StatRow(
                  icon: Icons.favorite,
                  iconColor: AppColors.hp,
                  label: 'Puntos de Vida (HP)',
                  value: '${user.currentHp}/${user.maxHp}',
                ),
                const Divider(color: AppColors.borderLight, height: 16),
                _StatRow(
                  icon: Icons.local_fire_department,
                  iconColor: const Color(0xFFF97316),
                  label: 'Racha de héroe',
                  value: '${user.streakDays} días',
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Logout Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () =>
                  ref.read(userNotifierProvider.notifier).logout(),
              icon: const Icon(Icons.logout, size: 18),
              label: const Text('Cerrar sesión'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.hpLow,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String value;
  final String label;

  const _StatItem({
    required this.icon,
    required this.color,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Column(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(height: 6),
              Text(
                value,
                style: AppTheme.titleRpg.copyWith(
                  fontSize: 16,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppTheme.titleRpg.copyWith(
        fontSize: 14,
        color: AppColors.textPrimary,
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  const _StatRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
              ),
            ),
          ),
          Text(
            value,
            style: AppTheme.titleRpg.copyWith(
              color: AppColors.textMuted,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
