import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/theme.dart';
import '../../providers/habit_provider.dart';
import '../../providers/user_provider.dart';
import '../avatar/avatar_playground_screen.dart';
import 'widgets/add_habit_sheet.dart';
import 'widgets/daily_quests.dart';
import 'widgets/hero_card.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  Future<void> _refresh(WidgetRef ref) async {
    await ref.read(userNotifierProvider.notifier).refresh();
    ref.invalidate(dailyHabitsProvider);
    ref.invalidate(habitListProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('DailyHero'),
        actions: [
          IconButton(
            tooltip: 'Avatar (demo)',
            icon: const Icon(Icons.videogame_asset),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const AvatarPlaygroundScreen(),
              ),
            ),
          ),
          IconButton(
            tooltip: 'Cerrar sesión',
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(userNotifierProvider.notifier).logout(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Hábito'),
        onPressed: () => AddHabitSheet.show(context),
      ),
      body: RefreshIndicator(
        onRefresh: () => _refresh(ref),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
          children: [
            if (user != null)
              HeroCard(user: user)
            else
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
            const SizedBox(height: 24),
            Row(
              children: [
                const Icon(Icons.flag, color: AppColors.accent, size: 20),
                const SizedBox(width: 8),
                Text('Misiones del día',
                    style: AppTheme.pixel.copyWith(
                        fontSize: 16, color: AppColors.textPrimary)),
              ],
            ),
            const SizedBox(height: 12),
            const DailyQuests(),
          ],
        ),
      ),
    );
  }
}
