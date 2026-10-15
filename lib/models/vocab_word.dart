// Модель для словарного слова
class VocabWord {
  final String japanese;
  final String romaji;
  final String russian;
  final String exampleSentence;

  const VocabWord({
    required this.japanese,
    required this.romaji,
    required this.russian,
    required this.exampleSentence,
  });

  Map<String, dynamic> toJson() {
    return {
      'japanese': japanese,
      'romaji': romaji,
      'russian': russian,
      'exampleSentence': exampleSentence,
    };
  }

  factory VocabWord.fromJson(Map<String, dynamic> json) {
    return VocabWord(
      japanese: json['japanese'] as String,
      romaji: json['romaji'] as String,
      russian: json['russian'] as String,
      exampleSentence: json['exampleSentence'] as String,
    );
  }

  @override
  String toString() {
    return 'VocabWord(japanese: $japanese, russian: $russian)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! VocabWord) {
      return false;
    }
    return japanese == other.japanese;
  }

  @override
  int get hashCode {
    return japanese.hashCode;
  }
}
