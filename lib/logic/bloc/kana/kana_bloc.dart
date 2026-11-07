import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ayas_languageland/models/kana_char.dart';
import 'package:ayas_languageland/data/hiragana_data.dart';
import 'package:ayas_languageland/data/katakana_data.dart';
import 'package:ayas_languageland/logic/services/app_state.dart';
import 'package:ayas_languageland/logic/services/tts_service.dart';
import 'package:ayas_languageland/logic/services/app_localizations.dart';
import 'kana_event.dart';
import 'kana_state.dart';

class KanaBloc extends Bloc<KanaEvent, KanaState> {
  final Random _random = Random();
  late List<KanaChar> _dataset;
  late List<KanaChar> _shuffledChars;
  int _currentIndex = 0;
  int _correctCount = 0;
  int _wrongCount = 0;
  String _currentMode = 'hiragana';

  KanaBloc() : super(const KanaInitial()) {
    on<KanaInitEvent>(_onInit);
    on<KanaSwitchModeEvent>(_onSwitchMode);
    on<KanaSelectEvent>(_onSelect);
    on<KanaCheckEvent>(_onCheck);
    on<KanaNextEvent>(_onNext);
    on<KanaRetryEvent>(_onRetry);
    on<KanaPlaySoundEvent>(_onPlaySound);
  }

  void _onInit(KanaInitEvent event, Emitter<KanaState> emit) {
    _currentMode = event.mode;
    _dataset = event.mode == 'katakana' ? katakanaData : hiraganaData;
    _shuffledChars = List.from(_dataset)..shuffle(_random);
    _currentIndex = 0;
    _correctCount = 0;
    _wrongCount = 0;
    _emitPractice(emit);
  }

  void _onSwitchMode(KanaSwitchModeEvent event, Emitter<KanaState> emit) {
    _onInit(KanaInitEvent(mode: event.mode), emit);
  }

  void _onSelect(KanaSelectEvent event, Emitter<KanaState> emit) {
    if (state is KanaPractice) {
      final current = state as KanaPractice;
      emit(current.copyWith(selectedRomaji: event.selectedRomaji));
    }
  }

  void _onCheck(KanaCheckEvent event, Emitter<KanaState> emit) {
    if (state is! KanaPractice) return;
    final current = state as KanaPractice;
    if (current.selectedRomaji == null) return;

    final isEn = (AppLoc.lang.value == 'en');
    final correctString = isEn ? current.currentChar.romaji : '${current.currentChar.romajiRu} (${current.currentChar.romaji})';

    final isCorrect = current.selectedRomaji == correctString;
    final cardId = AppState.cardId(current.currentChar.type, current.currentChar.char);

    AppState.recordAnswer(cardId, isCorrect);

    if (isCorrect) {
      _correctCount++;
      AppState.addXP(10);
      AppState.updateStreak();
      emit(KanaCorrect(
        currentChar: current.currentChar,
        correctRomaji: current.currentChar.romaji,
        selectedRomaji: current.selectedRomaji!,
        currentIndex: _currentIndex,
        totalCount: _shuffledChars.length,
        correctCount: _correctCount,
        wrongCount: _wrongCount,
      ));
    } else {
      _wrongCount++;
      emit(KanaWrong(
        currentChar: current.currentChar,
        correctRomaji: current.currentChar.romaji,
        selectedRomaji: current.selectedRomaji!,
        currentIndex: _currentIndex,
        totalCount: _shuffledChars.length,
        correctCount: _correctCount,
        wrongCount: _wrongCount,
      ));
    }
  }

  void _onNext(KanaNextEvent event, Emitter<KanaState> emit) {
    _currentIndex++;
    if (_currentIndex >= _shuffledChars.length) {
      final accuracy = (_correctCount / (_correctCount + _wrongCount)) * 100;
      emit(KanaResults(
        correctCount: _correctCount,
        wrongCount: _wrongCount,
        totalCount: _shuffledChars.length,
        accuracy: accuracy,
      ));
    } else {
      _emitPractice(emit);
    }
  }

  void _onRetry(KanaRetryEvent event, Emitter<KanaState> emit) {
    _onInit(KanaInitEvent(mode: _currentMode), emit);
  }

  Future<void> _onPlaySound(KanaPlaySoundEvent event, Emitter<KanaState> emit) async {
    if (state is KanaPractice) {
      final char = (state as KanaPractice).currentChar.char;
      await TtsService.instance.speak(char);
    }
  }

  void _emitPractice(Emitter<KanaState> emit) {
    final currentChar = _shuffledChars[_currentIndex];
    final options = _generateOptions(currentChar);
    emit(KanaPractice(
      currentChar: currentChar,
      options: options,
      selectedRomaji: null,
      currentIndex: _currentIndex,
      totalCount: _shuffledChars.length,
      correctCount: _correctCount,
      wrongCount: _wrongCount,
    ));
  }

  List<String> _generateOptions(KanaChar correct) {
    final isEn = (AppLoc.lang.value == 'en');
    final options = <String>[];

    // Вот тут магия: если английский, то "o", если русский, то "о (о)"
    String formatOption(KanaChar k) {
      return isEn ? k.romaji : '${k.romajiRu} (${k.romaji})';
    }

    options.add(formatOption(correct));

    final allStrings = _dataset
        .where((k) => k.romaji != correct.romaji)
        .map((k) => formatOption(k))
        .toList()
      ..shuffle(_random);

    options.addAll(allStrings.take(3));
    options.shuffle(_random);
    return options;
  }
}
