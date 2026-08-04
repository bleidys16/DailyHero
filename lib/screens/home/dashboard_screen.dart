import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/theme.dart';
import '../../providers/habit_provider.dart';
import '../../providers/user_provider.dart';
import '../avatar/avatar_playground_screen.dart';
import 'widgets/add_habit_sheet.dart';
import 'widgets/daily_quests.dart';
import 'widgets/hero_card.dart';
import 'widgets/stats_bar.dart';

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
    final greeting = _getGreeting();

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'DAILY HERO',
          style: AppTheme.titleRpg.copyWith(
            fontSize: 12,
            color: AppColors.primary,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.menu, color: AppColors.textPrimary),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            tooltip: 'Avatar',
            icon: const Icon(Icons.videogame_asset,
                color: AppColors.textMuted, size: 22),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const AvatarPlaygroundScreen(),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined,
                color: AppColors.textMuted, size: 22),
            onPressed: () {},
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add, size: 28),
        onPressed: () => AddHabitSheet.show(context),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/dash_inicio.png',
            fit: BoxFit.cover,
          ),
          Container(
            color: AppColors.bg.withOpacity(0.7),
          ),
          RefreshIndicator(
            onRefresh: () => _refresh(ref),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
              children: [
                Text(
                  '¡$greeting, ${user?.name ?? 'Héroe'}!',
                  style: AppTheme.body.copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Hoy es un buen día para ser héroe',
                  style: AppTheme.body.copyWith(
                    fontSize: 14,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 20),
                if (user != null)
                  HeroCard(user: user)
                else
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.surface.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: AppColors.borderCard.withOpacity(0.3),
                        width: 0.5,
                      ),
                    ),
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.only(left: 4),
                  child: Text(
                    'DAILY QUESTS',
                    style: AppTheme.titleRpg.copyWith(
                      fontSize: 11,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const DailyQuests(),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.only(left: 4),
                  child: Text(
                    'STATS',
                    style: AppTheme.titleRpg.copyWith(
                      fontSize: 11,
                      color: AppColors.gold,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const StatsBar(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Buen día';
    if (hour < 18) return 'Buenas tardes';
    return 'Buenas noches';
  }
}
