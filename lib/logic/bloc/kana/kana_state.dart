import 'package:ayas_languageland/models/kana_char.dart';

abstract class KanaState {
  const KanaState();
}

class KanaInitial extends KanaState {
  const KanaInitial();
}

class KanaPractice extends KanaState {
  final KanaChar currentChar;
  final List<String> options;
  final String? selectedRomaji;
  final int currentIndex;
  final int totalCount;
  final int correctCount;
  final int wrongCount;

  const KanaPractice({
    required this.currentChar,
    required this.options,
    this.selectedRomaji,
    required this.currentIndex,
    required this.totalCount,
    required this.correctCount,
    required this.wrongCount,
  });

  KanaPractice copyWith({
    KanaChar? currentChar,
    List<String>? options,
    String? selectedRomaji,
    int? currentIndex,
    int? totalCount,
    int? correctCount,
    int? wrongCount,
  }) {
    return KanaPractice(
      currentChar: currentChar ?? this.currentChar,
      options: options ?? this.options,
      selectedRomaji: selectedRomaji ?? this.selectedRomaji,
      currentIndex: currentIndex ?? this.currentIndex,
      totalCount: totalCount ?? this.totalCount,
      correctCount: correctCount ?? this.correctCount,
      wrongCount: wrongCount ?? this.wrongCount,
    );
  }
}

abstract class KanaCheckResult extends KanaState {
  final bool isCorrect;
  final KanaChar currentChar;
  final String correctRomaji;
  final String selectedRomaji;
  final int currentIndex;
  final int totalCount;
  final int correctCount;
  final int wrongCount;

  const KanaCheckResult({
    required this.isCorrect,
    required this.currentChar,
    required this.correctRomaji,
    required this.selectedRomaji,
    required this.currentIndex,
    required this.totalCount,
    required this.correctCount,
    required this.wrongCount,
  });
}

class KanaCorrect extends KanaCheckResult {
  const KanaCorrect({
    required super.currentChar,
    required super.correctRomaji,
    required super.selectedRomaji,
    required super.currentIndex,
    required super.totalCount,
    required super.correctCount,
    required super.wrongCount,
  }) : super(isCorrect: true);
}

class KanaWrong extends KanaCheckResult {
  const KanaWrong({
    required super.currentChar,
    required super.correctRomaji,
    required super.selectedRomaji,
    required super.currentIndex,
    required super.totalCount,
    required super.correctCount,
    required super.wrongCount,
  }) : super(isCorrect: false);
}

class KanaResults extends KanaState {
  final int correctCount;
  final int wrongCount;
  final int totalCount;
  final double accuracy;

  const KanaResults({
    required this.correctCount,
    required this.wrongCount,
    required this.totalCount,
    required this.accuracy,
  });
}
