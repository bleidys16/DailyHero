import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../config/theme.dart';
import '../../../providers/user_provider.dart';
import '../../../providers/habit_provider.dart';

class StatsBar extends ConsumerWidget {
  const StatsBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userNotifierProvider);
    final habitsAsync = ref.watch(habitListProvider);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.surface.withOpacity(0.95),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.borderCard.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _StatTile(
              icon: Icons.local_fire_department,
              value: '${user?.streakDays ?? 0}',
              label: 'Racha',
              color: const Color(0xFFF97316),
            ),
          ),
          Container(width: 1, height: 36, color: Colors.white10),
          Expanded(
            child: _StatTile(
              icon: Icons.bolt,
              value: '${user?.totalXp ?? 0}',
              label: 'XP Total',
              color: AppColors.xp,
            ),
          ),
          Container(width: 1, height: 36, color: Colors.white10),
          Expanded(
            child: habitsAsync.when(
              loading: () => const _StatTile(
                icon: Icons.flag_outlined,
                value: '...',
                label: 'Misiones',
                color: AppColors.gold,
              ),
              error: (_, __) => const _StatTile(
                icon: Icons.flag_outlined,
                value: '?',
                label: 'Misiones',
                color: AppColors.gold,
              ),
              data: (habits) {
                final completed = habits.where((h) => h.completed).length;
                return _StatTile(
                  icon: Icons.flag_outlined,
                  value: '$completed',
                  label: 'Misiones',
                  color: AppColors.gold,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatTile({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(height: 8),
        Text(
          value,
          style: AppTheme.body.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTheme.body.copyWith(
            color: AppColors.textMuted,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
