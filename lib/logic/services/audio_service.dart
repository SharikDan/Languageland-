import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioService {
  AudioService._();
  static final AudioService instance = AudioService._();

  static final AudioPlayer _musicPlayer = AudioPlayer();
  static final AudioPlayer _sfxPlayer = AudioPlayer();

  static bool _isMusicEnabled = true;
  static bool _isSoundEnabled = true;
  static bool _isTTSEnabled = true;
  static bool _isInitialized = false;
  static bool _isPlayingSfx = false;

  static bool get isMusicEnabled => _isMusicEnabled;
  static bool get isSoundEnabled => _isSoundEnabled;
  static bool get isTTSEnabled => _isTTSEnabled;

  static Future<void> init() async {
    try {
      await _musicPlayer.setReleaseMode(ReleaseMode.loop);
      await _musicPlayer.setVolume(0.2);
      await _sfxPlayer.setVolume(0.4);
      _isInitialized = true;
      debugPrint('✓ AudioService инициализирован');
    } catch (e) {
      debugPrint('⚠️ Ошибка AudioService: $e');
    }
  }

  static void toggleMusic() {
    _isMusicEnabled = !_isMusicEnabled;
    if (!_isMusicEnabled) stopMusic();
  }

  static void toggleSound() => _isSoundEnabled = !_isSoundEnabled;
  static void toggleTTS() => _isTTSEnabled = !_isTTSEnabled;

  static Future<void> playMusic(String fileName) async {
    if (!_isMusicEnabled || !_isInitialized) return;
    try {
      await _musicPlayer.stop();
      await _musicPlayer.play(AssetSource('music/$fileName'));
      debugPrint('🎵 Музыка: $fileName');
    } catch (e) {
      debugPrint('⚠️ Ошибка музыки: $e');
    }
  }

  static Future<void> stopMusic() async {
    try { await _musicPlayer.stop(); } catch (e) {}
  }

  static Future<void> playSound(String fileName) async {
    if (!_isSoundEnabled || !_isInitialized || _isPlayingSfx) return;
    try {
      _isPlayingSfx = true; // Блокируем новые звуки, пока играет этот
      await _sfxPlayer.play(AssetSource('sounds/$fileName'));
      debugPrint('🔊 Звук: $fileName');
      
      // Через 500мс снимаем блокировку
      await Future.delayed(const Duration(milliseconds: 500));
      _isPlayingSfx = false;
    } catch (e) {
      _isPlayingSfx = false;
      debugPrint('⚠️ Ошибка звука: $e');
    }
  }
}