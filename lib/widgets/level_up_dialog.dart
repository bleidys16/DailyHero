import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../config/theme.dart';

class LevelUpDialog extends StatelessWidget {
  final int newLevel;

  const LevelUpDialog({super.key, required this.newLevel});

  static Future<void> show(BuildContext context, {required int newLevel}) async {
    await showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.75),
      builder: (_) => LevelUpDialog(newLevel: newLevel),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.gold, width: 2.5),
          boxShadow: [
            BoxShadow(
              color: AppColors.gold.withValues(alpha: 0.35),
              blurRadius: 30,
              spreadRadius: 4,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.stars_rounded,
              color: AppColors.gold,
              size: 64,
            )
                .animate(onPlay: (controller) => controller.repeat(reverse: true))
                .scale(
                  duration: 800.ms,
                  begin: const Offset(1, 1),
                  end: const Offset(1.15, 1.15),
                )
                .shimmer(duration: 1200.ms, color: Colors.white),
            const SizedBox(height: 12),
            Text(
              '¡NIVEL ALCANZADO!',
              style: AppTheme.titleRpg.copyWith(
                fontSize: 26,
                color: AppColors.gold,
                letterSpacing: 1.5,
              ),
              textAlign: TextAlign.center,
            ).animate().fade(duration: 400.ms).slideY(begin: -0.2, end: 0),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.gold.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.gold, width: 1.5),
              ),
              child: Text(
                'NIVEL $newLevel',
                style: AppTheme.titleRpg.copyWith(
                  fontSize: 28,
                  color: AppColors.gold,
                  letterSpacing: 2,
                ),
              ),
            ).animate().scale(delay: 200.ms, duration: 500.ms, curve: Curves.elasticOut),
            const SizedBox(height: 16),
            Text(
              '¡Tu héroe se ha vuelto más fuerte!\nHas desbloqueado más poder para continuar tu aventura.',
              style: AppTheme.body.copyWith(
                color: AppColors.textPrimary,
                fontSize: 14,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ).animate().fade(delay: 300.ms),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.gold,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  '¡CONTINUAR AVENTURA!',
                  style: AppTheme.titleRpg.copyWith(
                    fontSize: 16,
                    color: Colors.black,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ).animate().fade(delay: 400.ms).slideY(begin: 0.2, end: 0),
          ],
        ),
      ),
    );
  }
}
