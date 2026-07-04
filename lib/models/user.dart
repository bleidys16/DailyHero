class User {
  final String id;
  final String email;
  final String? name;
  final int level;
  final int totalXp;
  final int currentHp;
  final int maxHp;
  final int gold;
  final int streakDays;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.email,
    this.name,
    this.level = 1,
    this.totalXp = 0,
    this.currentHp = 100,
    this.maxHp = 100,
    this.gold = 0,
    this.streakDays = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String?,
      level: json['level'] as int? ?? 1,
      totalXp: json['total_xp'] as int? ?? 0,
      currentHp: json['current_hp'] as int? ?? 100,
      maxHp: json['max_hp'] as int? ?? 100,
      gold: json['gold'] as int? ?? 0,
      streakDays: json['streak_days'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'level': level,
      'total_xp': totalXp,
      'current_hp': currentHp,
      'max_hp': maxHp,
      'gold': gold,
      'streak_days': streakDays,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  User copyWith({
    String? id,
    String? email,
    String? name,
    int? level,
    int? totalXp,
    int? currentHp,
    int? maxHp,
    int? gold,
    int? streakDays,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      level: level ?? this.level,
      totalXp: totalXp ?? this.totalXp,
      currentHp: currentHp ?? this.currentHp,
      maxHp: maxHp ?? this.maxHp,
      gold: gold ?? this.gold,
      streakDays: streakDays ?? this.streakDays,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
