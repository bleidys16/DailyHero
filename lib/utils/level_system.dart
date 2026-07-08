/// Sistema de niveles. Replica EXACTAMENTE la curva del backend
/// (SupabaseService.addXp): se consumen umbrales 100, 150, 225, ...
/// (cada uno x1.5) a partir del XP total acumulado.
class LevelProgress {
  final int level;
  final int xpIntoLevel; // XP acumulado dentro del nivel actual
  final int xpForNext; // XP necesario para pasar al siguiente nivel

  const LevelProgress({
    required this.level,
    required this.xpIntoLevel,
    required this.xpForNext,
  });

  /// Progreso 0.0 - 1.0 hacia el siguiente nivel.
  double get fraction =>
      xpForNext == 0 ? 0 : (xpIntoLevel / xpForNext).clamp(0.0, 1.0);
}

class LevelSystem {
  /// Deriva nivel y progreso a partir del XP total acumulado.
  static LevelProgress fromTotalXp(int totalXp) {
    int remaining = totalXp < 0 ? 0 : totalXp;
    int level = 1;
    int need = 100;

    while (remaining >= need) {
      remaining -= need;
      level += 1;
      need = (need * 1.5).toInt();
    }

    return LevelProgress(
      level: level,
      xpIntoLevel: remaining,
      xpForNext: need,
    );
  }
}
