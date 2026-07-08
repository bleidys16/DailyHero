import 'package:flutter/material.dart';

import '../../../config/theme.dart';
import '../../../models/user.dart';
import '../../../utils/level_system.dart';

/// Tarjeta principal del héroe: avatar, nivel, barras de HP/XP y oro.
class HeroCard extends StatelessWidget {
  final User user;
  const HeroCard({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final progress = LevelSystem.fromTotalXp(user.totalXp);
    final hpFraction =
        user.maxHp == 0 ? 0.0 : (user.currentHp / user.maxHp).clamp(0.0, 1.0);
    final hpColor = hpFraction < 0.3 ? AppColors.hpLow : AppColors.hp;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 64,
                  width: 64,
                  decoration: BoxDecoration(
                    color: AppColors.bg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.primary, width: 2),
                  ),
                  child: const Icon(Icons.person,
                      size: 40, color: AppColors.accent),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name?.isNotEmpty == true ? user.name! : 'Héroe',
                        style: AppTheme.pixel.copyWith(
                          fontSize: 18,
                          color: AppColors.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'Nivel ${progress.level}',
                          style: AppTheme.pixel.copyWith(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                _GoldBadge(gold: user.gold),
              ],
            ),
            const SizedBox(height: 16),
            _StatBar(
              icon: Icons.favorite,
              color: hpColor,
              label: 'HP',
              value: '${user.currentHp}/${user.maxHp}',
              fraction: hpFraction,
            ),
            const SizedBox(height: 10),
            _StatBar(
              icon: Icons.bolt,
              color: AppColors.xp,
              label: 'XP',
              value: '${progress.xpIntoLevel}/${progress.xpForNext}',
              fraction: progress.fraction,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.local_fire_department,
                    color: Color(0xFFF97316), size: 18),
                const SizedBox(width: 4),
                Text(
                  'Racha: ${user.streakDays} días',
                  style: const TextStyle(color: AppColors.textMuted),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _GoldBadge extends StatelessWidget {
  final int gold;
  const _GoldBadge({required this.gold});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.bg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.monetization_on, color: AppColors.gold, size: 18),
          const SizedBox(width: 4),
          Text(
            '$gold',
            style: AppTheme.pixel.copyWith(
              color: AppColors.gold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatBar extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final String value;
  final double fraction;

  const _StatBar({
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
    required this.fraction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(label,
                      style: const TextStyle(
                          color: AppColors.textMuted, fontSize: 12)),
                  Text(value,
                      style: const TextStyle(
                          color: AppColors.textMuted, fontSize: 12)),
                ],
              ),
              const SizedBox(height: 4),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: fraction,
                  minHeight: 10,
                  backgroundColor: AppColors.bg,
                  valueColor: AlwaysStoppedAnimation(color),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
