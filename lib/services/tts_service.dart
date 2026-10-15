// TTS-сервис для озвучки японского текста
import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  TtsService._();

  static final TtsService _instance = TtsService._();
  static TtsService get instance => _instance;

  final FlutterTts _tts = FlutterTts();
  bool _isInitialized = false;
  bool _isAvailable = true;
  bool _isEnabled = true;

  Future<void> initialize() async {
    if (_isInitialized) {
      return;
    }

    try {
      await _tts.setLanguage('ja-JP');
      await _tts.setSpeechRate(0.5);
      await _tts.setVolume(1.0);
      await _tts.setPitch(1.0);

      final languages = await _tts.getLanguages;
      if (languages != null && languages.isNotEmpty) {
        _isAvailable = languages.toString().contains('ja');
      }

      _isInitialized = true;
    } catch (e) {
      _isAvailable = false;
      _isInitialized = true;
    }
  }

  Future<void> speak(String text) async {
    if (!_isEnabled || !_isAvailable || text.isEmpty) {
      return;
    }

    try {
      await initialize();
      await _tts.speak(text);
    } catch (e) {
      _isAvailable = false;
    }
  }

  Future<void> stop() async {
    try {
      await _tts.stop();
    } catch (e) {
      // Игнорируем ошибки остановки
    }
  }

  void setEnabled(bool enabled) {
    _isEnabled = enabled;
    if (!enabled) {
      stop();
    }
  }

  bool get isEnabled => _isEnabled;
  bool get isAvailable => _isAvailable;
}
