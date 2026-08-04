import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../config/theme.dart';

/// Overlay flotante que muestra las recompensas obtenidas al completar
/// una misión: XP, oro y opcionalmente nivel subido.
class RewardOverlay extends StatefulWidget {
  final int xpGained;
  final int goldGained;
  final int? newLevel; // Si subió de nivel
  final VoidCallback? onDismiss;

  const RewardOverlay({
    super.key,
    required this.xpGained,
    required this.goldGained,
    this.newLevel,
    this.onDismiss,
  });

  /// Muestra el overlay como un OverlayEntry durante ~2.5 segundos y se
  /// auto-desvanece. Si [newLevel] != null, muestra el diálogo de nivel
  /// después del overlay.
  static void show(
    BuildContext context, {
    required int xpGained,
    required int goldGained,
    int? newLevel,
  }) {
    final overlay = Overlay.of(context);
    late final OverlayEntry entry;

    entry = OverlayEntry(
      builder: (_) => RewardOverlay(
        xpGained: xpGained,
        goldGained: goldGained,
        newLevel: newLevel,
        onDismiss: () {
          entry.remove();
        },
      ),
    );

    overlay.insert(entry);
  }

  @override
  State<RewardOverlay> createState() => _RewardOverlayState();
}

class _RewardOverlayState extends State<RewardOverlay>
    with SingleTickerProviderStateMixin {
  bool _visible = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 2200), () {
      if (!mounted) return;
      setState(() => _visible = false);
      Future.delayed(const Duration(milliseconds: 400), () {
        widget.onDismiss?.call();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 60,
      left: 24,
      right: 24,
      child: IgnorePointer(
        child: AnimatedOpacity(
          opacity: _visible ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOut,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.surface.withValues(alpha: 0.97),
                    const Color(0xFF1A1A2E).withValues(alpha: 0.97),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.gold.withValues(alpha: 0.5),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.gold.withValues(alpha: 0.2),
                    blurRadius: 24,
                    spreadRadius: 2,
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.5),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Título
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.auto_awesome, color: AppColors.gold, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        '¡MISIÓN COMPLETADA!',
                        style: AppTheme.titleRpg.copyWith(
                          fontSize: 16,
                          color: AppColors.gold,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.auto_awesome, color: AppColors.gold, size: 20),
                    ],
                  )
                      .animate()
                      .fade(duration: 300.ms)
                      .shimmer(
                        delay: 300.ms,
                        duration: 800.ms,
                        color: Colors.white.withValues(alpha: 0.3),
                      ),
                  const SizedBox(height: 14),
                  // Recompensas
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // XP Badge
                      _RewardBadge(
                        icon: Icons.flash_on,
                        label: '+${widget.xpGained} XP',
                        color: AppColors.xp,
                        delay: 200,
                      ),
                      const SizedBox(width: 16),
                      // Gold Badge
                      _RewardBadge(
                        icon: Icons.monetization_on,
                        label: '+${widget.goldGained}',
                        color: AppColors.gold,
                        delay: 400,
                      ),
                      if (widget.newLevel != null) ...[
                        const SizedBox(width: 16),
                        _RewardBadge(
                          icon: Icons.stars_rounded,
                          label: 'LVL ${widget.newLevel}!',
                          color: const Color(0xFFFF6B6B),
                          delay: 600,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RewardBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final int delay;

  const _RewardBadge({
    required this.icon,
    required this.label,
    required this.color,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.4), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTheme.titleRpg.copyWith(
              fontSize: 15,
              color: color,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    )
        .animate()
        .fade(delay: Duration(milliseconds: delay), duration: 300.ms)
        .scale(
          delay: Duration(milliseconds: delay),
          duration: 400.ms,
          curve: Curves.elasticOut,
          begin: const Offset(0.5, 0.5),
          end: const Offset(1, 1),
        );
  }
}
