import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../config/theme.dart';

/// Overlay flotante para compras de la tienda — aparece con animación
/// indicando el ítem comprado y el oro gastado.
class PurchaseOverlay extends StatefulWidget {
  final String itemName;
  final int goldSpent;
  final bool success;
  final VoidCallback? onDismiss;

  const PurchaseOverlay({
    super.key,
    required this.itemName,
    required this.goldSpent,
    required this.success,
    this.onDismiss,
  });

  static void show(
    BuildContext context, {
    required String itemName,
    required int goldSpent,
    required bool success,
  }) {
    final overlay = Overlay.of(context);
    late final OverlayEntry entry;

    entry = OverlayEntry(
      builder: (_) => PurchaseOverlay(
        itemName: itemName,
        goldSpent: goldSpent,
        success: success,
        onDismiss: () => entry.remove(),
      ),
    );

    overlay.insert(entry);
  }

  @override
  State<PurchaseOverlay> createState() => _PurchaseOverlayState();
}

class _PurchaseOverlayState extends State<PurchaseOverlay> {
  bool _visible = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (!mounted) return;
      setState(() => _visible = false);
      Future.delayed(const Duration(milliseconds: 350), () {
        widget.onDismiss?.call();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final isSuccess = widget.success;
    final accentColor = isSuccess ? AppColors.gold : AppColors.hpLow;

    return Positioned(
      top: MediaQuery.of(context).padding.top + 60,
      left: 24,
      right: 24,
      child: IgnorePointer(
        child: AnimatedOpacity(
          opacity: _visible ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
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
                  color: accentColor.withValues(alpha: 0.5),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: accentColor.withValues(alpha: 0.2),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.5),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    isSuccess ? Icons.shopping_bag : Icons.block,
                    color: accentColor,
                    size: 28,
                  )
                      .animate()
                      .scale(duration: 400.ms, curve: Curves.elasticOut),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          isSuccess
                              ? '¡Objeto adquirido!'
                              : 'Oro insuficiente',
                          style: AppTheme.titleRpg.copyWith(
                            fontSize: 14,
                            color: accentColor,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          isSuccess
                              ? '${widget.itemName} — ${widget.goldSpent} oro'
                              : widget.itemName,
                          style: AppTheme.body.copyWith(
                            color: AppColors.textPrimary,
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  if (isSuccess) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.gold.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: AppColors.gold.withValues(alpha: 0.4)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.monetization_on,
                              color: AppColors.gold, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            '-${widget.goldSpent}',
                            style: AppTheme.titleRpg.copyWith(
                              fontSize: 13,
                              color: AppColors.gold,
                            ),
                          ),
                        ],
                      ),
                    )
                        .animate()
                        .fade(delay: 200.ms, duration: 300.ms)
                        .slideX(begin: 0.3, end: 0),
                  ],
                ],
              ),
            )
                .animate()
                .slideY(begin: -0.3, end: 0, duration: 350.ms, curve: Curves.easeOut)
                .fade(duration: 300.ms),
          ),
        ),
      ),
    );
  }
}
