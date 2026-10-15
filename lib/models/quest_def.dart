// Модель для квеста (задания в приложении)
class QuestDef {
  final String id;
  final String title;
  final String description;
  final int targetCount;
  int currentCount;
  final int reward;

  QuestDef({
    required this.id,
    required this.title,
    required this.description,
    required this.targetCount,
    this.currentCount = 0,
    required this.reward,
  });

  // Квест завершён, если текущий прогресс >= цели
  bool get isCompleted => currentCount >= targetCount;

  // Прогресс от 0.0 до 1.0 для прогресс-бара
  double get progress => (currentCount / targetCount).clamp(0.0, 1.0);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'targetCount': targetCount,
      'currentCount': currentCount,
      'reward': reward,
    };
  }

  factory QuestDef.fromJson(Map<String, dynamic> json) {
    return QuestDef(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      targetCount: json['targetCount'] as int,
      currentCount: json['currentCount'] as int? ?? 0,
      reward: json['reward'] as int,
    );
  }

  QuestDef copyWith({
    String? id,
    String? title,
    String? description,
    int? targetCount,
    int? currentCount,
    int? reward,
  }) {
    return QuestDef(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      targetCount: targetCount ?? this.targetCount,
      currentCount: currentCount ?? this.currentCount,
      reward: reward ?? this.reward,
    );
  }

  @override
  String toString() {
    return 'QuestDef(id: $id, progress: $currentCount/$targetCount)';
  }
}