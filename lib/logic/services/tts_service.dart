import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  TtsService._();
  static final TtsService instance = TtsService._();

  final FlutterTts _tts = FlutterTts();
  bool _isInitialized = false;
  bool _isEnabled = true;
  bool _isSpeaking = false; // Блокировка на время произношения

  Future<void> init() async {
    if (_isInitialized) return;
    try {
      await _tts.setLanguage('ja-JP');
      await _tts.setSpeechRate(0.4);
      await _tts.setVolume(1.0);
      await _tts.setPitch(1.0);
      
      // Когда TTS заканчивает говорить, снимаем блокировку
      _tts.setCompletionHandler(() {
        _isSpeaking = false;
      });
      // Если произошла ошибка, тоже снимаем блокировку
      _tts.setErrorHandler((msg) {
        _isSpeaking = false;
      });

      _isInitialized = true;
      debugPrint('✓ TTS инициализирован');
    } catch (e) {
      debugPrint('⚠️ TTS init error: $e');
    }
  }

  Future<void> speak(String text) async {
    if (!_isEnabled || text.isEmpty) return;
    
    // Если уже говорим - игнорируем новый запрос (защита от спама)
    if (_isSpeaking) {
      debugPrint('🔇 TTS пропущен (уже говорит)');
      return;
    }

    try {
      _isSpeaking = true;
      await _tts.speak(text);
      debugPrint('🔊 TTS сказал: $text');
    } catch (e) {
      _isSpeaking = false;
      debugPrint('⚠️ TTS speak error: $e');
    }
  }

  void setEnabled(bool enabled) {
    _isEnabled = enabled;
    if (!enabled) {
      _tts.stop();
      _isSpeaking = false;
    }
  }
}
