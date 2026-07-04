enum HabitFrequency { daily, weekly, oneTime }

enum HabitDifficulty { easy, medium, hard }

enum HabitCategory { health, mind, work, social }

class Habit {
  final String id;
  final String userId;
  final String title;
  final String? description;
  final HabitFrequency frequency;
  final HabitDifficulty difficulty;
  final HabitCategory category;
  final int xpReward;
  final bool completed;
  final DateTime? completedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  Habit({
    required this.id,
    required this.userId,
    required this.title,
    this.description,
    required this.frequency,
    required this.difficulty,
    required this.category,
    this.xpReward = 50,
    this.completed = false,
    this.completedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  int get xpValue {
    int base = xpReward;
    switch (difficulty) {
      case HabitDifficulty.easy:
        return base;
      case HabitDifficulty.medium:
        return (base * 1.5).toInt();
      case HabitDifficulty.hard:
        return (base * 2).toInt();
    }
  }

  factory Habit.fromJson(Map<String, dynamic> json) {
    return Habit(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      frequency: HabitFrequency.values.byName(json['frequency'] as String),
      difficulty: HabitDifficulty.values.byName(json['difficulty'] as String),
      category: HabitCategory.values.byName(json['category'] as String),
      xpReward: json['xp_reward'] as int? ?? 50,
      completed: json['completed'] as bool? ?? false,
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'] as String)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'description': description,
      'frequency': frequency.name,
      'difficulty': difficulty.name,
      'category': category.name,
      'xp_reward': xpReward,
      'completed': completed,
      'completed_at': completedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Habit copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    HabitFrequency? frequency,
    HabitDifficulty? difficulty,
    HabitCategory? category,
    int? xpReward,
    bool? completed,
    DateTime? completedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Habit(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      frequency: frequency ?? this.frequency,
      difficulty: difficulty ?? this.difficulty,
      category: category ?? this.category,
      xpReward: xpReward ?? this.xpReward,
      completed: completed ?? this.completed,
      completedAt: completedAt ?? this.completedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
