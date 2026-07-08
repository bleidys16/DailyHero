import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../config/theme.dart';
import '../../../models/habit.dart';
import '../../../providers/habit_provider.dart';
import '../../../utils/habit_ui.dart';

/// Lista de hábitos diarios pendientes ("misiones del día").
class DailyQuests extends ConsumerWidget {
  const DailyQuests({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              style: const TextStyle(color: AppColors.textMuted)),
        ),
      ),
      data: (habits) {
        if (habits.isEmpty) {
          return const _EmptyState();
        }
        return Column(
          children:
              habits.map((h) => _QuestTile(habit: h)).toList(growable: false),
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
        children: const [
          Icon(Icons.check_circle_outline,
              size: 48, color: AppColors.textMuted),
          SizedBox(height: 12),
          Text('No hay misiones pendientes',
              style: TextStyle(color: AppColors.textMuted)),
          SizedBox(height: 4),
          Text('Crea un hábito con el botón +',
              style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
        ],
      ),
    );
  }
}

class _QuestTile extends ConsumerStatefulWidget {
  final Habit habit;
  const _QuestTile({required this.habit});

  @override
  ConsumerState<_QuestTile> createState() => _QuestTileState();
}

class _QuestTileState extends ConsumerState<_QuestTile> {
  bool _completing = false;

  Future<void> _complete() async {
    setState(() => _completing = true);
    final habit = widget.habit;
    try {
      await ref.read(habitNotifierProvider.notifier).completeHabit(habit);
      if (!mounted) return;
      final gold = (habit.xpValue * 0.5).toInt();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('¡Misión completada! +${habit.xpValue} XP  +$gold oro'),
          backgroundColor: AppColors.primaryDark,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _completing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo completar: $e')),
      );
    }
  }

  Future<void> _confirmDelete() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Eliminar hábito'),
        content: Text('¿Eliminar "${widget.habit.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar',
                style: TextStyle(color: AppColors.hpLow)),
          ),
        ],
      ),
    );
    if (ok == true) {
      await ref
          .read(habitNotifierProvider.notifier)
          .deleteHabit(widget.habit.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final habit = widget.habit;
    final catColor = HabitUi.categoryColor(habit.category);

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            GestureDetector(
              onTap: _completing ? null : _complete,
              child: _completing
                  ? const SizedBox(
                      height: 28,
                      width: 28,
                      child: Padding(
                        padding: EdgeInsets.all(4),
                        child: CircularProgressIndicator(strokeWidth: 2.5),
                      ),
                    )
                  : Container(
                      height: 28,
                      width: 28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: catColor, width: 2),
                      ),
                    ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    habit.title,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(HabitUi.categoryIcon(habit.category),
                          size: 14, color: catColor),
                      const SizedBox(width: 4),
                      Text(HabitUi.categoryLabel(habit.category),
                          style: const TextStyle(
                              color: AppColors.textMuted, fontSize: 12)),
                      const SizedBox(width: 8),
                      _DifficultyChip(habit: habit),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('+${habit.xpValue} XP',
                    style: AppTheme.pixel.copyWith(
                        color: AppColors.xp, fontSize: 13)),
                InkWell(
                  onTap: _confirmDelete,
                  child: const Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Icon(Icons.delete_outline,
                        size: 18, color: AppColors.textMuted),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DifficultyChip extends StatelessWidget {
  final Habit habit;
  const _DifficultyChip({required this.habit});

  @override
  Widget build(BuildContext context) {
    final color = HabitUi.difficultyColor(habit.difficulty);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        HabitUi.difficultyLabel(habit.difficulty),
        style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600),
      ),
    );
  }
}
