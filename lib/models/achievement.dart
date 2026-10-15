// Модель для достижения (ачивки)
class Achievement {
  final String id;
  final String title;
  final String description;
  final String iconName;
  bool isUnlocked;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.iconName,
    this.isUnlocked = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'iconName': iconName,
      'isUnlocked': isUnlocked,
    };
  }

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      iconName: json['iconName'] as String,
      isUnlocked: json['isUnlocked'] as bool? ?? false,
    );
  }

  @override
  String toString() {
    return 'Achievement(id: $id, title: $title, unlocked: $isUnlocked)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Achievement) {
      return false;
    }
    return id == other.id;
  }

  @override
  int get hashCode {
    return id.hashCode;
  }
}
