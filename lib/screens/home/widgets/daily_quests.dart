import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../config/theme.dart';
import '../../../models/habit.dart';
import '../../../providers/habit_provider.dart';
import '../../../providers/user_provider.dart';
import '../../../utils/habit_ui.dart';
import '../../../utils/level_system.dart';
import '../../../widgets/reward_overlay.dart';
import '../../../widgets/level_up_dialog.dart';

class DailyQuests extends ConsumerStatefulWidget {
  const DailyQuests({Key? key}) : super(key: key);

  @override
  ConsumerState<DailyQuests> createState() => _DailyQuestsState();
}

class _DailyQuestsState extends ConsumerState<DailyQuests> {
  /// IDs de hábitos ya completados en esta sesión, para que desaparezcan
  /// de la lista aunque el refresh del backend tarde o falle.
  final Set<String> _doneIds = {};

  void _handleCompleted(String habitId, int? newLevel) {
    setState(() => _doneIds.add(habitId));
    if (newLevel != null) {
      Future.delayed(const Duration(milliseconds: 2600), () {
        if (!mounted) return;
        LevelUpDialog.show(context, newLevel: newLevel);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final quests = ref.watch(dailyHabitsProvider);

    return quests.when(
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 32),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: Text('Error cargando misiones:\n$e',
              textAlign: TextAlign.center,
              style: AppTheme.body.copyWith(color: AppColors.textMuted)),
        ),
      ),
      data: (habits) {
        final visible =
            habits.where((h) => !_doneIds.contains(h.id)).toList();
        if (visible.isEmpty) {
          return const _EmptyState();
        }
        return Column(
          children: visible
              .map((h) => _QuestTile(
                    key: ValueKey(h.id),
                    habit: h,
                    onCompleted: (newLevel) =>
                        _handleCompleted(h.id, newLevel),
                  ))
              .toList(growable: false),
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          const Icon(Icons.check_circle_outline,
              size: 48, color: AppColors.textMuted),
          const SizedBox(height: 12),
          Text('No hay misiones pendientes',
              style: AppTheme.body.copyWith(color: AppColors.textMuted)),
          const SizedBox(height: 4),
          Text('Crea un hábito con el botón +',
              style: AppTheme.body.copyWith(
                  color: AppColors.textMuted, fontSize: 12)),
        ],
      ),
    );
  }
}

class _QuestTile extends ConsumerStatefulWidget {
  final Habit habit;
  final ValueChanged<int?> onCompleted;
  const _QuestTile({super.key, required this.habit, required this.onCompleted});

  @override
  ConsumerState<_QuestTile> createState() => _QuestTileState();
}

class _QuestTileState extends ConsumerState<_QuestTile>
    with SingleTickerProviderStateMixin {
  bool _completing = false;
  bool _completed = false;

  Future<void> _complete() async {
    if (_completing || _completed) return;
    setState(() => _completing = true);
    final habit = widget.habit;

    // Capturar nivel ANTES de completar
    final userBefore = ref.read(userNotifierProvider);
    final levelBefore = userBefore != null
        ? LevelSystem.fromTotalXp(userBefore.totalXp).level
        : 0;

    try {
      await ref.read(habitNotifierProvider.notifier).completeHabit(habit);
      if (!mounted) return;

      setState(() {
        _completing = false;
        _completed = true;
      });

      final xpGained = habit.xpValue;
      final goldGained = (habit.xpValue * 0.5).toInt();

      // Capturar nivel DESPUÉS de completar
      final userAfter = ref.read(userNotifierProvider);
      final levelAfter = userAfter != null
          ? LevelSystem.fromTotalXp(userAfter.totalXp).level
          : 0;
      final didLevelUp = levelAfter > levelBefore;

      // Mostrar overlay de recompensas animado
      if (mounted) {
        RewardOverlay.show(
          context,
          xpGained: xpGained,
          goldGained: goldGained,
          newLevel: didLevelUp ? levelAfter : null,
        );
      }

      // Avisar al padre para que quite la tarea de la lista.
      widget.onCompleted(didLevelUp ? levelAfter : null);
    } catch (e) {
      if (!mounted) return;
      setState(() => _completing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo completar: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final habit = widget.habit;
    final icon = HabitUi.categoryIcon(habit.category);
    final iconColor = HabitUi.categoryColor(habit.category);

    return AnimatedOpacity(
      opacity: _completed ? 0.4 : 1.0,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
      child: AnimatedSlide(
        offset: _completed ? const Offset(0.4, 0) : Offset.zero,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOut,
        child: AnimatedScale(
          scale: _completed ? 0.96 : 1.0,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOut,
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.surface.withOpacity(0.95),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _completed
                    ? AppColors.primary.withOpacity(0.35)
                    : AppColors.borderCard.withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.14),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor, size: 20),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        habit.title,
                        style: AppTheme.body.copyWith(
                          color: _completed
                              ? AppColors.textMuted
                              : AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          decoration: _completed
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        HabitUi.categoryLabel(habit.category),
                        style: AppTheme.body.copyWith(
                          color: AppColors.textMuted,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.xp.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '+${habit.xpValue} XP',
                    style: AppTheme.body.copyWith(
                      color: AppColors.xp,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _completing ? null : _complete,
                  child: _completing
                      ? const SizedBox(
                          height: 30,
                          width: 30,
                          child: Padding(
                            padding: EdgeInsets.all(6),
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: AppColors.primary,
                            ),
                          ),
                        )
                      : AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            color: _completed
                                ? AppColors.primary
                                : AppColors.primary.withOpacity(0.1),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: _completed
                                  ? AppColors.primary
                                  : AppColors.primary.withOpacity(0.4),
                            ),
                          ),
                          child: _completed
                              ? const Icon(Icons.check,
                                  size: 16, color: Colors.white)
                              : const Icon(Icons.arrow_forward,
                                  size: 16, color: AppColors.primary),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
