// Модель для грамматической фразы
class GrammarPhrase {
  final String japanese;
  final String russian;
  final String explanation;
  final List<String> examples;

  const GrammarPhrase({
    required this.japanese,
    required this.russian,
    required this.explanation,
    required this.examples,
  });

  Map<String, dynamic> toJson() {
    return {
      'japanese': japanese,
      'russian': russian,
      'explanation': explanation,
      'examples': examples,
    };
  }

  factory GrammarPhrase.fromJson(Map<String, dynamic> json) {
    return GrammarPhrase(
      japanese: json['japanese'] as String,
      russian: json['russian'] as String,
      explanation: json['explanation'] as String,
      examples: (json['examples'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );
  }

  @override
  String toString() {
    return 'GrammarPhrase(japanese: $japanese, russian: $russian)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! GrammarPhrase) {
      return false;
    }
    return japanese == other.japanese;
  }

  @override
  int get hashCode {
    return japanese.hashCode;
  }
}
