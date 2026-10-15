// Модель для SRS-прогресса карточки (Spaced Repetition System)
class CardProgress {
  final String cardId;
  int box;
  int nextReviewMs;
  int lapses;
  int correctStreak;

  CardProgress({
    required this.cardId,
    this.box = 1,
    this.nextReviewMs = 0,
    this.lapses = 0,
    this.correctStreak = 0,
  });

  // Интервалы повторения для каждой коробки
  static const _intervals = [
    Duration(days: 1),
    Duration(days: 3),
    Duration(days: 7),
    Duration(days: 14),
    Duration(days: 30),
  ];

  void recordCorrect() {
    correctStreak++;
    if (box < 5) {
      box++;
    }
    final interval = _intervals[box.clamp(1, 5).toInt() - 1];
    nextReviewMs = DateTime.now()
        .add(interval)
        .millisecondsSinceEpoch;
  }

  void recordIncorrect() {
    lapses++;
    correctStreak = 0;
    box = 1;
    nextReviewMs = DateTime.now()
        .add(_intervals[0])
        .millisecondsSinceEpoch;
  }

  bool get isDue {
    return DateTime.now().millisecondsSinceEpoch >= nextReviewMs;
  }

  Map<String, dynamic> toJson() {
    return {
      'cardId': cardId,
      'box': box,
      'nextReviewMs': nextReviewMs,
      'lapses': lapses,
      'correctStreak': correctStreak,
    };
  }

  factory CardProgress.fromJson(Map<String, dynamic> json) {
    return CardProgress(
      cardId: json['cardId'] as String,
      box: (json['box'] as num).toInt(),
      nextReviewMs: (json['nextReviewMs'] as num).toInt(),
      lapses: (json['lapses'] as num).toInt(),
      correctStreak: (json['correctStreak'] as num).toInt(),
    );
  }

  @override
  String toString() {
    return 'CardProgress(cardId: $cardId, box: $box, streak: $correctStreak)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! CardProgress) {
      return false;
    }
    return cardId == other.cardId;
  }

  @override
  int get hashCode {
    return cardId.hashCode;
  }
}
