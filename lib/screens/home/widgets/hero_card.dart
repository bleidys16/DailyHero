import 'package:flutter/material.dart';

import '../../../config/theme.dart';
import '../../../models/user.dart';
import '../../../utils/level_system.dart';

import '../../../game/widgets/flame_avatar_view.dart';

class HeroCard extends StatelessWidget {
  final User user;
  const HeroCard({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final progress = LevelSystem.fromTotalXp(user.totalXp);
    final hpFraction =
        user.maxHp == 0 ? 0.0 : (user.currentHp / user.maxHp).clamp(0.0, 1.0);
    final hpColor = hpFraction < 0.3 ? AppColors.hpLow : AppColors.hp;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.borderGold.withValues(alpha: 0.4),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.gold.withValues(alpha: 0.08),
            blurRadius: 20,
            spreadRadius: 2,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.gold, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.gold.withValues(alpha: 0.3),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: const FlameAvatarView(size: 64, playerSize: 64),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name?.isNotEmpty == true ? user.name! : 'Héroe',
                      style: AppTheme.body.copyWith(
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.4),
                        ),
                      ),
                      child: Text(
                        'NIVEL ${progress.level}',
                        style: AppTheme.titleRpg.copyWith(
                          fontSize: 14,
                          color: AppColors.primary,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              _GoldBadge(gold: user.gold),
            ],
          ),
          const SizedBox(height: 20),
          _StatBar(
            icon: Icons.favorite,
            color: hpColor,
            label: 'HP',
            value: '${user.currentHp}/${user.maxHp}',
            fraction: hpFraction,
          ),
          const SizedBox(height: 14),
          _StatBar(
            icon: Icons.bolt,
            color: AppColors.xp,
            label: 'XP',
            value: '${progress.xpIntoLevel}/${progress.xpForNext}',
            fraction: progress.fraction,
          ),
        ],
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
        color: AppColors.gold.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.monetization_on, color: AppColors.gold, size: 18),
          const SizedBox(width: 6),
          Text(
            '$gold',
            style: AppTheme.titleRpg.copyWith(
              color: AppColors.gold,
              fontSize: 16,
              letterSpacing: 0.5,
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
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    label,
                    style: AppTheme.body.copyWith(
                      fontSize: 12,
                      color: AppColors.textMuted,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    value,
                    style: AppTheme.body.copyWith(
                      fontSize: 12,
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: fraction,
                  minHeight: 10,
                  backgroundColor: AppColors.surfaceAlt,
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

