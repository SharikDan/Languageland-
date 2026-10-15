// Модель для элемента кандзи N5
class KanjiItem {
  final String char;
  final String meaning;
  final String kunyomi;
  final String onyomi;
  final List<String> examples;

  const KanjiItem({
    required this.char,
    required this.meaning,
    required this.kunyomi,
    required this.onyomi,
    required this.examples,
  });

  Map<String, dynamic> toJson() {
    return {
      'char': char,
      'meaning': meaning,
      'kunyomi': kunyomi,
      'onyomi': onyomi,
      'examples': examples,
    };
  }

  factory KanjiItem.fromJson(Map<String, dynamic> json) {
    return KanjiItem(
      char: json['char'] as String,
      meaning: json['meaning'] as String,
      kunyomi: json['kunyomi'] as String,
      onyomi: json['onyomi'] as String,
      examples: (json['examples'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );
  }

  @override
  String toString() {
    return 'KanjiItem(char: $char, meaning: $meaning)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! KanjiItem) {
      return false;
    }
    return char == other.char;
  }

  @override
  int get hashCode {
    return char.hashCode;
  }
}
