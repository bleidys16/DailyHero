enum MissionStatus { pending, completed, failed }

class Mission {
  final String id;
  final String habitId;
  final String userId;
  final MissionStatus status;
  final DateTime createdAt;
  final DateTime? completedAt;

  Mission({
    required this.id,
    required this.habitId,
    required this.userId,
    required this.status,
    required this.createdAt,
    this.completedAt,
  });

  factory Mission.fromJson(Map<String, dynamic> json) {
    return Mission(
      id: json['id'] as String,
      habitId: json['habit_id'] as String,
      userId: json['user_id'] as String,
      status: MissionStatus.values.byName(json['status'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'habit_id': habitId,
      'user_id': userId,
      'status': status.name,
      'created_at': createdAt.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
    };
  }
}
