class VocabWord {
  final String japanese;
  final String romaji;
  final String russian;
  final String english;
  final String exampleSentence;

  const VocabWord({
    required this.japanese,
    required this.romaji,
    required this.russian,
    required this.english,
    required this.exampleSentence,
  });

  Map<String, dynamic> toJson() {
    return {
      'japanese': japanese,
      'romaji': romaji,
      'russian': russian,
      'english': english,
      'exampleSentence': exampleSentence,
    };
  }

  factory VocabWord.fromJson(Map<String, dynamic> json) {
    return VocabWord(
      japanese: json['japanese'] as String,
      romaji: json['romaji'] as String,
      russian: json['russian'] as String,
      english: json['english'] as String? ?? json['russian'] as String,
      exampleSentence: json['exampleSentence'] as String,
    );
  }
}
